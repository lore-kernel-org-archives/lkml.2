Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab0EISr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 14:47:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab0EISrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 14:47:25 -0400
Date: Sun, 9 May 2010 20:45:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mathias Krause <Mathias.Krause@secunet.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel panic on kill(0, SIGTERM) with PGID == 0
Message-ID: <20100509184510.GA15219@redhat.com>
References: <4BE01C86.3050908@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE01C86.3050908@secunet.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for delay, vacation.

On 05/04, Mathias Krause wrote:
>
> Hi Oleg, Hi Eric,
>
> I stumbled across a nasty bug related to the special init I'm using
> (cinit) and a process trying to kill it's process group. That always ends
> in a kernel NULL pointer dereference. git bisect brought me to that
> commit:
>
> | commit 430c623121ea88ca80595c99fdc63b7f8a803ae5
> | Author: Oleg Nesterov <oleg@tv-sign.ru>
> | Date:   Fri Feb 8 04:19:11 2008 -0800
> |
> | start the global /sbin/init with 0,0 special pids
> |
> | As Eric pointed out, there is no problem with init starting with sid == pgid
> | == 0, and this was historical linux behavior changed in 2.6.18.
> |
> | Remove kernel_init()->__set_special_pids(), this is unneeded and complicates
> | the rules for sys_setsid().
> |
> | This change and the previous change in daemonize() mean that /sbin/init does
> | not need the special "session != 1" hack in sys_setsid() any longer. We can'
> | remove this check yet, we should cleanup copy_process(CLONE_NEWPID) first, s
> | update the comment only.
> |
> | Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> | Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> | Cc: Pavel Emelyanov <xemul@openvz.org>
> | Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> | Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> Well, it actually is a problem for my setup. If neither init nor any of
> the programs init starts ever change the PGID, all will live in the
> process group 0. That's bad when some of the started programs tries to
> kill its process group. That will in fact kill _all_ processes. So far so
> bad.

sorry again, I'll try to comment this later...

And I think this should be discussed on lkml, cc'ed.

> But it even gets worser because process group 0 contains some
> special processes, like swapper (PID: 0). Normally swapper will never be
> reachable for userland because PID 0 is handled special by kill(2) but
> killing the current process group while having a PGID of 0 will also try
> to kill those special processes like swapper. This ends in the following
> kernel null pointer deref:
>
> [    3.595820] BUG: unable to handle kernel NULL pointer dereference at 000003a8

Thanks Mathias.

I think this should be fixed anyway. Could you try the patch below?

In any case swapper should be immune to signals, and its ->thread_group
should be properly initiallized (the patch does only this).

> [    3.595820]  [<c012b45b>] __group_send_sig_info+0x7b/0xa0
> [    3.595820]  [<c012b5bd>] group_send_sig_info+0x5d/0x80
> [    3.595820]  [<c012b628>] __kill_pgrp_info+0x48/0x70
> [    3.595820]  [<c012b679>] kill_pgrp_info+0x29/0x40

Looks like, you kernel is old. Any chance you can also test the recent
kernel?

> May be a minor bug, because it can be work around by calling setpgid(0,0)
> in init

setpgid(0,0) just moves the caller's pgrp from PGID 0, that is why it
helps.

> but I think it should be fixed, anyway.

Completely agreed.

> A reproducer is attached. It contains a substitute for init that triggers
> the bug.

Thanks.

I didn't try it, but it looks overcomplicated to trigger this bug, or
I missed something? Afaics, init could be just

	int main(void)
	{
		kill(0, SIGGKILL);
	}

No?

Oleg.

We should also change INIT_SIGHAND, but _hopefully_ this is enough
to fix the crash.

--- x/include/linux/init_task.h
+++ x/include/linux/init_task.h
@@ -172,6 +172,7 @@ extern struct cred init_cred;
 		[PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID),		\
 		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
 	},								\
+	.thread_group	= LIST_HEAD_INIT(tsk.thread_group),		\
 	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
 	INIT_IDS							\
 	INIT_PERF_EVENTS(tsk)						\


