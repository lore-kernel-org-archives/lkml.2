Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab1HVM2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 08:28:42 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:38240 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab1HVM2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 08:28:36 -0400
Message-ID: <4E524B73.3050704@free.fr>
Date: Mon, 22 Aug 2011 14:28:35 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>, akpm@linux-foundation.org,
        bonbons@linux-vserver.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
 when reboot
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <20110814161707.GB30846@redhat.com> <20110814213642.GB13799@hallyn.com> <20110815144744.GA9660@redhat.com> <4E4DA461.8030006@free.fr> <20110819152416.GA17034@redhat.com>
In-Reply-To: <20110819152416.GA17034@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2011 05:24 PM, Oleg Nesterov wrote:
> On 08/19, Daniel Lezcano wrote:
>> On 08/15/2011 04:47 PM, Oleg Nesterov wrote:
>>> 	- sys_reboot(cmd) does
>>>
>>> 		if (!global_namespace) {
>>> 			task_active_pid_ns(current)->reboot_cmd = cmd;
>>> 			sigkill_my_init();
>>> 		}
>> Hi Oleg,
>>
>> what would be your advice to get rid of from_ancestor_ns which prevent
>> the signal to be delivered to the init process ?
> Sure, a plain kill can't work. You can do force_sig_info(), this clears
> SIGNAL_UNKILLABLE.
>
> Hmm. But now I seem to recall we have other reasons to make the new
> sigkill_task() helper... We will see. Anyway, force_ should work afaics.

Thanks Oleg.

I wrote the patch by sending a signal to the init process of the pid
namespace using force_sig_info.
That works fine, thanks for the hint.

I am wondering what is the best way to transmit the reason of the reboot
to the parent of the container's init.

If we pass the reason to the exit_code of the init process, that will be
a bit weird as the process is signaled and did not exited  no ?
Furthermore, how to differentiate an application container (eg. a
script) exiting with an error with the same value of a reboot reason ?

Wouldn't make sense to let the user to specify a signal via prctl where
the si_code is filled with the reason ?

Without invoking the prctl, the init process is simply killed by the
kernel, otherwise we send the signal to the container's init.

>From userspace:

void sigreboot(int sig, siginfo_t *si, void *private)
{
    switch(si->si_code) {
       case LINUX_REBOOT_CMD_RESTART:
        reboot_container();
        break;

      case LINUX_REBOOT_CMD_HALT:
        halt_container();
        break;

     ...
    }
}

  struct sigaction sa = {
    .sa_sigaction = sigreboot,
    .sa_flags =  SA_SIGINFO;  
 }
 
 sigaction(SIGUSR1, &sa, NULL);

 prctl(PR_SIGREBOOT, SIGUSR1);

 -----

 and from the kernel (called from sys_reboot):

 int kill_pid_ns(struct pid_namespace *pid_ns, int reason)
{
        struct task_struct *tsk;
        struct siginfo info;

        if (pid_ns->notifier) {

                         info.si_signo = SIGKILL;
                         info.si_errno = 0;
                         info.si_code = reason;
                         info.si_pid = 0;
                         info.si_uid = 0;

                         return force_sig_info(notifier->sig, &info,
notifier->tsk);
        }

        write_lock_irq(&tasklist_lock);
        tsk = pid_ns->child_reaper;
        write_unlock_irq(&tasklist_lock);

        info.si_signo = SIGKILL;
        info.si_errno = 0;
        info.si_code = SI_KERNEL;
        info.si_pid = 0;
        info.si_uid = 0;

        return force_sig_info(SIGKILL, &info, tsk);
}

Roughly, assuming pid_ns->notifier is reseted when we reparent to the
init_pid_ns.init.

What do you think ?

Thanks
  -- Daniel
