Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0CZTBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 15:01:17 -0400
Received: from www.tglx.de ([62.245.132.106]:41049 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab0CZTBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 15:01:15 -0400
Date: Fri, 26 Mar 2010 20:01:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Subject: Re: [BUG-REPORT][PREEMPT-RT] 2.6.33.1-rt11 triggers
 DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled), in a 32-bit kvm session
In-Reply-To: <520f0cf11003260502o5ecb23adpe69f6eb465142821@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1003261951330.3147@localhost.localdomain>
References: <520f0cf11003260502o5ecb23adpe69f6eb465142821@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Mar 2010, John Kacur wrote:

> During boot-up of 2.6.33.1-rt11 in a 32-bit qemu-kvm machine,
> The following warning is reliably (every time) triggered.
> 
> ------------[ cut here ]------------
> WARNING: at /home/jkacur/jk-2.6/kernel/fork.c:1065 copy_process+0x299/0x160f()
> Hardware name:
> Modules linked in:
> Pid: 64, comm: khelper Not tainted 2.6.33.1-rt11 #1
> Call Trace:
>  [<c104961a>] warn_slowpath_common+0x83/0x9a
>  [<c1049643>] warn_slowpath_null+0x12/0x15
>  [<c1046f89>] copy_process+0x299/0x160f
>  [<c1048711>] do_fork+0x235/0x4e2
>  [<c107da08>] ? register_lock_class+0x17/0x22d
>  [<c107e6dc>] ? mark_lock+0x1e/0x1c0
>  [<c1064a2f>] ? ____call_usermodehelper+0x0/0x138
>  [<c100ae09>] kernel_thread+0x79/0x81
>  [<c1064a2f>] ? ____call_usermodehelper+0x0/0x138
>  [<c100391c>] ? kernel_thread_helper+0x0/0x10
>  [<c1064cc7>] __call_usermodehelper+0x75/0xa0
>  [<c10673b6>] worker_thread+0x1f6/0x2fb
>  [<c1067374>] ? worker_thread+0x1b4/0x2fb
>  [<c1064c52>] ? __call_usermodehelper+0x0/0xa0
>  [<c106a91e>] ? autoremove_wake_function+0x0/0x46
>  [<c106a740>] kthread+0x6b/0x74
>  [<c10671c0>] ? worker_thread+0x0/0x2fb
>  [<c106a6d5>] ? kthread+0x0/0x74
>  [<c106a6d5>] ? kthread+0x0/0x74
>  [<c1003922>] kernel_thread_helper+0x6/0x10
> ---[ end trace a22d306b065d4a66 ]---
> 
> I am happy to provide more information to help debug this.

Can you run the following patch please ?

Thanks,

	tglx
---

diff --git a/kernel/fork.c b/kernel/fork.c
index 340cbc8..b63e8f5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1062,7 +1062,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	rt_mutex_init_task(p);
 
 #ifdef CONFIG_PROVE_LOCKING
-	DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
+	//DEBUG_LOCKS_WARN_ON(!p->hardirqs_enabled);
+	if (!p->hardirqs_enabled)
+		print_irqtrace_events(p);
 	DEBUG_LOCKS_WARN_ON(!p->softirqs_enabled);
 #endif
 	retval = -EAGAIN;
