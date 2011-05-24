Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab1EXWUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 18:20:53 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52654 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab1EXWUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 18:20:52 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.39-rc7-mmotm0512 lockdep splat in scheduler code
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306275571_2633P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 24 May 2011 18:19:31 -0400
Message-ID: <28171.1306275571@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A02020A.4DDC2EF5.0055,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306275571_2633P
Content-Type: text/plain; charset=us-ascii

Sorry if this was reported already but I missed it on the lkml firehose..

Seen this morning at boot while configuring the sound card. Semi-reproducible,
as it's tripped 3 times in the last 5 boots of this kernel. However, it hadn't
tripped once in the previous 15 boots of that same kernel (odd, as it's same
kernel binary and same initrd, and we're still on the initrd at this point). Not sure
what changed to make it start happening.

(/proc/interrupts lists:  48:      67445      66819   PCI-MSI-edge      hda_intel)

[    2.511386] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.523230] 
[    2.523231] ===================================================
[    2.523234] [ INFO: suspicious rcu_dereference_check() usage. ]
[    2.523236] ---------------------------------------------------
[    2.523238] kernel/sched_rt.c:1244 invoked rcu_dereference_check() without protection!
[    2.523241] 
[    2.523241] other info that might help us debug this:
[    2.523242] 
[    2.523244] 
[    2.523245] rcu_scheduler_active = 1, debug_locks = 1
[    2.523247] 1 lock held by irq/48-hda_inte/85:
[    2.523249]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8102adc9>] post_schedule.part.20+0xf/0x45
[    2.523259] 
[    2.523260] stack backtrace:
[    2.523263] Pid: 85, comm: irq/48-hda_inte Not tainted 2.6.39-rc7-mmotm0512 #2
[    2.523265] Call Trace:
[    2.523271]  [<ffffffff81066d8e>] lockdep_rcu_dereference+0x9a/0xa2
[    2.523275]  [<ffffffff8102c45e>] find_lowest_rq+0xf9/0x174
[    2.523279]  [<ffffffff8102d167>] find_lock_lowest_rq+0x2c/0xfe
[    2.523284]  [<ffffffff81032485>] push_rt_task.part.60+0xac/0x156
[    2.523288]  [<ffffffff81032633>] post_schedule_rt+0x1a/0x23
[    2.523291]  [<ffffffff8102ade5>] post_schedule.part.20+0x2b/0x45
[    2.523296]  [<ffffffff8156a651>] schedule+0x6f2/0x738
[    2.523301]  [<ffffffff8108c446>] ? irq_thread_fn+0x29/0x29
[    2.523305]  [<ffffffff8108c3df>] irq_thread+0x173/0x1b1
[    2.523309]  [<ffffffff8108c26c>] ? irq_finalize_oneshot+0xc9/0xc9
[    2.523314]  [<ffffffff81054e4e>] kthread+0x7f/0x87
[    2.523318]  [<ffffffff81573e54>] kernel_thread_helper+0x4/0x10
[    2.523322]  [<ffffffff8156d044>] ? retint_restore_args+0xe/0xe
[    2.523326]  [<ffffffff81054dcf>] ? __init_kthread_worker+0x55/0x55
[    2.523330]  [<ffffffff81573e50>] ? gs_change+0xb/0xb
[    2.523409] 
[    2.523409] ===================================================
[    2.523412] [ INFO: suspicious rcu_dereference_check() usage. ]
[    2.523414] ---------------------------------------------------
[    2.523416] kernel/sched.c:619 invoked rcu_dereference_check() without protection!
[    2.523418] 
[    2.523419] other info that might help us debug this:
[    2.523420] 
[    2.523422] 
[    2.523422] rcu_scheduler_active = 1, debug_locks = 1
[    2.523425] 2 locks held by irq/48-hda_inte/85:
[    2.523427]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff8102d0ca>] double_rq_lock+0x62/0x77
[    2.523434]  #1:  (&rq->lock/1){..-...}, at: [<ffffffff8102d0d7>] double_rq_lock+0x6f/0x77
[    2.523441] 
[    2.523442] stack backtrace:
[    2.523444] Pid: 85, comm: irq/48-hda_inte Not tainted 2.6.39-rc7-mmotm0512 #2
[    2.523446] Call Trace:
[    2.523450]  [<ffffffff81066d8e>] lockdep_rcu_dereference+0x9a/0xa2
[    2.523454]  [<ffffffff8102aecf>] task_group+0x7a/0xb9
[    2.523458]  [<ffffffff8102af20>] set_task_rq+0x12/0x6b
[    2.523462]  [<ffffffff810320d3>] set_task_cpu+0x8b/0xe8
[    2.523466]  [<ffffffff8121c985>] ? plist_check_head+0x120/0x125
[    2.523470]  [<ffffffff8121cb1b>] ? plist_del+0x70/0x79
[    2.523474]  [<ffffffff8102cd87>] ? dequeue_task_rt+0x33/0x38
[    2.523477]  [<ffffffff8102c9cd>] ? dequeue_task+0x9b/0xa7
[    2.523482]  [<ffffffff810324f5>] push_rt_task.part.60+0x11c/0x156
[    2.523486]  [<ffffffff81032633>] post_schedule_rt+0x1a/0x23
[    2.523489]  [<ffffffff8102ade5>] post_schedule.part.20+0x2b/0x45
[    2.523494]  [<ffffffff8156a651>] schedule+0x6f2/0x738
[    2.523497]  [<ffffffff8108c446>] ? irq_thread_fn+0x29/0x29
[    2.523501]  [<ffffffff8108c3df>] irq_thread+0x173/0x1b1
[    2.523505]  [<ffffffff8108c26c>] ? irq_finalize_oneshot+0xc9/0xc9
[    2.523509]  [<ffffffff81054e4e>] kthread+0x7f/0x87
[    2.523513]  [<ffffffff81573e54>] kernel_thread_helper+0x4/0x10
[    2.523517]  [<ffffffff8156d044>] ? retint_restore_args+0xe/0xe
[    2.523521]  [<ffffffff81054dcf>] ? __init_kthread_worker+0x55/0x55
[    2.523524]  [<ffffffff81573e50>] ? gs_change+0xb/0xb
[    2.548750] input: HDA Intel Mic at Sep Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6



--==_Exmh_1306275571_2633P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFN3C7zcC3lWbTT17ARAjuLAJ9nHY1ILq7LuBy5o6wKQLV4S4hLjQCg5nBW
DALdy6p+cPsiuZKav1wo3bs=
=6/N7
-----END PGP SIGNATURE-----

--==_Exmh_1306275571_2633P--

