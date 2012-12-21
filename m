Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab2LUBnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 20:43:22 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44877 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab2LUBnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 20:43:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <8739097bkk.fsf@xmission.com>
	<1353083750-3621-1-git-send-email-ebiederm@xmission.com>
	<1353083750-3621-11-git-send-email-ebiederm@xmission.com>
	<20121219181400.GA22991@redhat.com>
Date: Thu, 20 Dec 2012 17:43:04 -0800
In-Reply-To: <20121219181400.GA22991@redhat.com> (Oleg Nesterov's message of
	"Wed, 19 Dec 2012 19:14:00 +0100")
Message-ID: <871uektc2f.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/tzQsMURWRCnQDi7t/Pqi93cjefbbOass=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 11/11] pidns: Support unsharing the pid namespace.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Hi Eric,
>
> oleg@tv-sign.ru no longer works, so I just noticed these emails.

Darn and instead of bouncing the emails just go into a black hole :(

I have updated my address book to point to oleg@redhat.com so
hopefully I don't make that mistake again.

> On 11/16, Eric W. Biederman wrote:
>>
>> Unsharing of the pid namespace unlike unsharing of other namespaces
>> does not take affect immediately.  Instead it affects the children
>> created with fork and clone.
>
> I'll try to read this series later, but I am not sure I will ever
> understand the code with these patches ;)

Hopefully the code doesn't cause you too many problems.

> So alloc_pid() becomes the only user nsproxy->pid_ns and it is not
> necessarily equal to task_active_pid_ns(). It seems to me that this
> adds a lot of new corner cases.

I have tried to simply outlaw the most of the new corner cases as they
simply are not interesting so there is no point implementing them,
or thinking about them once they are outlawed.

> Unless I missed something, at least we should not allow CLONE_THREAD
> if active_pid_ns != nsproxy->pid_ns. If nothing else, copy_process()
> initializes ->child_reaper only if thread_group_leader(child). And
> ->child_reaper == NULL can obviously lead to crash.

Hmm.  Let me think that through as you may have a point.

In copy_pid_ns I fail if task_active_pid_ns != nsproxy->pid_ns, and in
unshare CLONE_NEW_PID implies "CLONE_THREAD|CLONE_VM|CLONE_SIGHAND".  So
I avoid most of those cases already.

You are asking about clone(CLONE_THREAD) after unshare(CLONE_NEWPID).  I
totally failed to realize that case existed.  Oleg thank you for
pointing it out.

Below is my preliminary patch for ruling those things out.  I have added
CLONE_PARENT to the forbidden set because that seems about as bad
as CLONE_SIGHAND or CLONE_THREAD.

I will cook up a proper patch and get it merged shortly.

Eric


diff --git a/kernel/fork.c b/kernel/fork.c
index c36c4e3..340a25c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1166,6 +1166,14 @@ static struct task_struct *copy_process(unsigned long clone_flags,
                                current->signal->flags & SIGNAL_UNKILLABLE)
                return ERR_PTR(-EINVAL);
 
+       /*
+        * If the children will be in a different pid namespace don't allow
+        * the creation of threads.
+        */
+       if ((clone_flags & (CLONE_THREAD|CLONE_SIGHAND|CLONE_VM|CLONE_PARENT)) &&
+           task_active_pid_ns(current) != current->nsproxy->pid_ns)
+               return ERR_PTR(-EINVAL);
+
        retval = security_task_create(clone_flags);
        if (retval)
                goto fork_out;

