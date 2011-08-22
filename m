Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1HVTSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:18:04 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:42393 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab1HVTSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:18:01 -0400
Date: Mon, 22 Aug 2011 21:17:16 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        "Serge E. Hallyn" <serge@hallyn.com>, akpm@linux-foundation.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
 when reboot
Message-ID: <20110822211716.7c141d5c@neptune.home>
In-Reply-To: <20110822173949.GA13242@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
	<20110814161707.GB30846@redhat.com>
	<20110814213642.GB13799@hallyn.com>
	<20110815144744.GA9660@redhat.com>
	<4E4DA461.8030006@free.fr>
	<20110819152416.GA17034@redhat.com>
	<4E524B73.3050704@free.fr>
	<20110822154448.GA8527@redhat.com>
	<20110822183134.10390b46@neptune.home>
	<20110822173949.GA13242@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 August 2011 Oleg Nesterov wrote:
> On 08/22, Bruno Prémont wrote:
> >
> > On Mon, 22 August 2011 Oleg Nesterov <oleg@redhat.com> wrote:
> > > On 08/22, Daniel Lezcano wrote:
> > > >
> > > > If we pass the reason to the exit_code of the init process, that will be
> > > > a bit weird as the process is signaled and did not exited  no ?
> > >
> > > Just in case, you shouldn't change ->exit_code blindly. We should only
> > > change it if init was a) SIGKILL'ed and b) pid_ns->reboot_cmd is set.
> > > In this case we can assume that it was killed by sys_reboot.
> > >
> > > Now. I didn't really mean exit_state should be equal to sys_reboot's
> > > cmd arg. I thought about something like
> > >
> > > 	swicth (reboot_cmd) {
> > > 	case LINUX_REBOOT_CMD_RESTART:
> > > 		code = SIGHUP;
> > > 		break;
> > > 	case LINUX_REBOOT_CMD_HALT:
> > > 		code = SIGINT;	// doesn't really matter what we report
> > > 		...
> > > 	}
> >
> > Isn't it possible to add the two cases to si_code possible values, e.g.
> > CDL_RESTART, CDL_HALT (or CDL_SYS_RESTART, CDL_SYS_HALT
> 
> How? You should change do_wait() paths then. Even if we could, personally
> I'd strongly object ;) Look, you have the very specific problem. The kernel
> can't do everything to make everyone happy. There is tradeoff.
> 
> But if you really meant siginfo->si_code, I do not understand at all what
> you actually mean. This info is not preserved when the task exits.

I've been reading do_wait() code a bit, it decides between CLD_KILLED and
CLD_DUMPED based on a bit of (struct task_struct).exit_code.
So struct_task IS still available (how about it's namespace references? If
the namespaces are not the reboot reason would need to be stored somewhere
inside of struct task which might be some overhead too much)

So as long as container init's task_struct exists the reboot reason could
be preserved and used to replace CLD_DUMPED/CLD_KILLED siginfo->si_code.

So yes, tradeoff then is where to adjust code in order to get the information
along.

> > to avoid possible
> > confusion with CDL_STOPPED)?
> 
> How it is possible to confuse this with CDL_STOPPED?

Confusion is usually reading too quickly! (e.g. skipping, overseeing,
not realizing the details)

> > Then on sys_reboot() flag container init and kill it (this way sys_reboot()
> > preserves its "will not return on success for restart/halt" scematic)?
> 
> This is what I suggested...
> 
> > Then container init would see CLD_KILLED replaced with matching reboot
> > reason.
> 
> For what? its parent need this info, not container init. I guess I got
> lost completely.

I meant CLD_KILLED as visible to parent in siginfo.
Sure, as container's init gets killed it doesn't see anything itself.

> > Playing with the exit code is probably more problematic
> 
> OK, then please do something else. I do not pretend I really understand
> what do you really need to solve your problem. But please do not forget
> the kernel is already very complex and full of misc hacks ;)
> 
> > > And, iiuc, the point was to "fix" sys_reboot() so that we do not need
> > > to mofify the distro/userspace?
> >
> > That's definitely the goal (not modify distro/userspace running inside
> > container).
> 
> In this case I do not understand how prctl() can help.

I'm not talking about prctl() - as I understand Daniel the prctl() part is
for the process outside of the container, not the one inside.
So for container hypervisor to say if it wants to get informed or not.

> But please do not try to convince me, this is simply unnecessary ;)

No, trying to know what's reasonably possible without having to do a second
iteration when a new (foreseeable) features arrives.
And also hopefully having the same understanding of the issue.

Bruno
