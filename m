Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab2LSMNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 07:13:48 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54927 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2LSMNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 07:13:41 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1355912802-2505-1-git-send-email-xtfeng@gmail.com>
References: <1355912802-2505-1-git-send-email-xtfeng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 19 Dec 2012 04:13:30 -0800
To: Xiaotian Feng <xtfeng@gmail.com>, akpm@linux-foundation.org
CC: Xiaotian Feng <dannyfeng@tencent.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Message-ID: <dfadce3a-07b9-4760-9213-edf93abab2e7@email.android.com>
X-XM-AID: U2FsdGVkX1+kfzoZR/CHY+5+oz2PKn3wqGxHpcsvG6A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Xiaotian Feng <xtfeng@gmail.com>,akpm@linux-foundation.org
X-Spam-Relay-Country: 
Subject: Re: [PATCH] proc: fix inconsistent lock state
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng <xtfeng@gmail.com> wrote:

>Lockdep found an inconsistent lock state when rcu is processing
>delayed work in softirq. Currently, kernel is using
>spin_lock/spin_unlock
>to protect proc_inum_ida, but proc_free_inum is called by rcu in
>softirq
>context.

Emarassing.  Thank you for finding this.

Something doesn't feel right.   I don't think there should be a path where we get to proc_free_inum from bh context.

Rcu callbacks should be running in process context (if a special one). 

I need to sleep on this one but do_softirq -> rcu_process_callbacks seems wrong.

I will dig into this more after I have finished sleeping.  What rcu options do you have selected?

Eric

>Use spin_lock_bh/spin_unlock_bh fix following lockdep warning.
>
>[   49.709127] =================================
>[   49.709360] [ INFO: inconsistent lock state ]
>[   49.709593] 3.7.0 #36 Not tainted
>[   49.709846] ---------------------------------
>[   49.710080] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
>[   49.710377] swapper/1/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
>[   49.710640]  (proc_inum_lock){+.?...}, at: [<ffffffff8124280c>]
>proc_free_inum+0x1c/0x50
>[   49.711287] {SOFTIRQ-ON-W} state was registered at:
>[   49.711540]   [<ffffffff8110dc4e>] __lock_acquire+0x8ae/0xca0
>[   49.711896]   [<ffffffff8110e1d9>] lock_acquire+0x199/0x200
>[   49.712242]   [<ffffffff81b295e1>] _raw_spin_lock+0x41/0x50
>[   49.712590]   [<ffffffff81242efc>] proc_alloc_inum+0x4c/0xd0
>[   49.712941]   [<ffffffff811f1799>] alloc_mnt_ns+0x49/0xc0
>[   49.713282]   [<ffffffff811f3365>] create_mnt_ns+0x25/0x70
>[   49.713625]   [<ffffffff82115443>] mnt_init+0x161/0x1c7
>[   49.713962]   [<ffffffff82114f51>] vfs_caches_init+0x107/0x11a
>[   49.714392]   [<ffffffff820f3c67>] start_kernel+0x348/0x38c
>[   49.714815]   [<ffffffff820f3335>]
>x86_64_start_reservations+0x131/0x136
>[   49.715279]   [<ffffffff820f343d>] x86_64_start_kernel+0x103/0x112
>[   49.715728] irq event stamp: 2993422
>[   49.716006] hardirqs last  enabled at (2993422):
>[<ffffffff81b29f75>] _raw_spin_unlock_irqrestore+0x55/0x80
>[   49.716661] hardirqs last disabled at (2993421):
>[<ffffffff81b296f9>] _raw_spin_lock_irqsave+0x29/0x70
>[   49.717300] softirqs last  enabled at (2993394):
>[<ffffffff810ab0b3>] _local_bh_enable+0x13/0x20
>[   49.717920] softirqs last disabled at (2993395):
>[<ffffffff81b2c33c>] call_softirq+0x1c/0x30
>[   49.718528]
>[   49.718528] other info that might help us debug this:
>[   49.718992]  Possible unsafe locking scenario:
>[   49.718992]
>[   49.719433]        CPU0
>[   49.719669]        ----
>[   49.719902]   lock(proc_inum_lock);
>[   49.720308]   <Interrupt>
>[   49.720548]     lock(proc_inum_lock);
>[   49.720961]
>[   49.720961]  *** DEADLOCK ***
>[   49.720961]
>[   49.721477] no locks held by swapper/1/0.
>[   49.721769]
>[   49.721769] stack backtrace:
>[   49.722150] Pid: 0, comm: swapper/1 Not tainted 3.7.0 #36
>[   49.722555] Call Trace:
>[   49.722787]  <IRQ>  [<ffffffff810a40f1>] ? vprintk_emit+0x471/0x510
>[   49.723307]  [<ffffffff81109ce5>] print_usage_bug+0x2a5/0x2c0
>[   49.723671]  [<ffffffff8110a03b>] mark_lock+0x33b/0x5e0
>[   49.724014]  [<ffffffff8110dbb3>] __lock_acquire+0x813/0xca0
>[   49.724374]  [<ffffffff8110a8ad>] ? trace_hardirqs_on+0xd/0x10
>[   49.724741]  [<ffffffff8110e1d9>] lock_acquire+0x199/0x200
>[   49.725095]  [<ffffffff8124280c>] ? proc_free_inum+0x1c/0x50
>[   49.725455]  [<ffffffff81b295e1>] _raw_spin_lock+0x41/0x50
>[   49.725806]  [<ffffffff8124280c>] ? proc_free_inum+0x1c/0x50
>[   49.726165]  [<ffffffff8124280c>] proc_free_inum+0x1c/0x50
>[   49.726519]  [<ffffffff810c76a2>] ? put_pid+0x42/0x60
>[   49.726857]  [<ffffffff81128cac>] free_pid_ns+0x1c/0x50
>[   49.727201]  [<ffffffff81128d0e>] put_pid_ns+0x2e/0x50
>[   49.727540]  [<ffffffff810c76aa>] put_pid+0x4a/0x60
>[   49.727868]  [<ffffffff810c76d2>] delayed_put_pid+0x12/0x20
>[   49.728225]  [<ffffffff81132ed2>] rcu_process_callbacks+0x462/0x790
>[   49.728606]  [<ffffffff810ab4e4>] __do_softirq+0x1b4/0x3b0
>[   49.728959]  [<ffffffff81104132>] ?
>clockevents_program_event+0xc2/0xf0
>[   49.729354]  [<ffffffff81b2c33c>] call_softirq+0x1c/0x30
>[   49.729702]  [<ffffffff81057bf9>] do_softirq+0x59/0xd0
>[   49.730039]  [<ffffffff810ab024>] irq_exit+0x54/0xd0
>[   49.730370]  [<ffffffff81b2ca05>] smp_apic_timer_interrupt+0x95/0xa3
>[   49.730755]  [<ffffffff81b2bbf2>] apic_timer_interrupt+0x72/0x80
>[   49.731124]  <EOI>  [<ffffffff81b2a473>] ?
>retint_restore_args+0x13/0x13
>[   49.731658]  [<ffffffff8199d125>] ? cpuidle_wrap_enter+0x55/0xa0
>[   49.732029]  [<ffffffff8199d121>] ? cpuidle_wrap_enter+0x51/0xa0
>[   49.732399]  [<ffffffff8199d180>] cpuidle_enter_tk+0x10/0x20
>[   49.732759]  [<ffffffff8199cb57>] cpuidle_enter_state+0x17/0x50
>[   49.733128]  [<ffffffff8199d507>] cpuidle_idle_call+0x287/0x520
>[   49.733496]  [<ffffffff8105feca>] cpu_idle+0xba/0x130
>[   49.733830]  [<ffffffff81b2059f>] start_secondary+0x2b3/0x2bc
>
>Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Al Viro <viro@zeniv.linux.org.uk>
>Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>Cc: linux-kernel@vger.kernel.org
>---
> fs/proc/generic.c |   12 ++++++------
> 1 file changed, 6 insertions(+), 6 deletions(-)
>
>diff --git a/fs/proc/generic.c b/fs/proc/generic.c
>index 7b3ae3c..e659a0f 100644
>--- a/fs/proc/generic.c
>+++ b/fs/proc/generic.c
>@@ -359,18 +359,18 @@ retry:
> 	if (!ida_pre_get(&proc_inum_ida, GFP_KERNEL))
> 		return -ENOMEM;
> 
>-	spin_lock(&proc_inum_lock);
>+	spin_lock_bh(&proc_inum_lock);
> 	error = ida_get_new(&proc_inum_ida, &i);
>-	spin_unlock(&proc_inum_lock);
>+	spin_unlock_bh(&proc_inum_lock);
> 	if (error == -EAGAIN)
> 		goto retry;
> 	else if (error)
> 		return error;
> 
> 	if (i > UINT_MAX - PROC_DYNAMIC_FIRST) {
>-		spin_lock(&proc_inum_lock);
>+		spin_lock_bh(&proc_inum_lock);
> 		ida_remove(&proc_inum_ida, i);
>-		spin_unlock(&proc_inum_lock);
>+		spin_unlock_bh(&proc_inum_lock);
> 		return -ENOSPC;
> 	}
> 	*inum = PROC_DYNAMIC_FIRST + i;
>@@ -379,9 +379,9 @@ retry:
> 
> void proc_free_inum(unsigned int inum)
> {
>-	spin_lock(&proc_inum_lock);
>+	spin_lock_bh(&proc_inum_lock);
> 	ida_remove(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
>-	spin_unlock(&proc_inum_lock);
>+	spin_unlock_bh(&proc_inum_lock);
> }
> 
>static void *proc_follow_link(struct dentry *dentry, struct nameidata
>*nd)


