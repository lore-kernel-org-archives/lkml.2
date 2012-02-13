Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab2BMVax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:30:53 -0500
Received: from usindpps03.hds.com ([207.126.252.16]:35652 "EHLO
	usindpps03.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab2BMVav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:30:51 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mjg@redhat.com" <mjg@redhat.com>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>
Date: Mon, 13 Feb 2012 16:22:21 -0500
Subject: RE: [PATCH 2/2] x86, reschedule: check to see if system is shutting
 down
Thread-Topic: [PATCH 2/2] x86, reschedule: check to see if system is
 shutting down
Thread-Index: AczqjfUizZJMMGLeQ46HPHpQ4MqkjgABvx1w
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2DAC7A8FC3@USINDEVS01.corp.hds.com>
References: <1329164860-668-1-git-send-email-dzickus@redhat.com>
 <1329164860-668-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1329164860-668-3-git-send-email-dzickus@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1202130209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>+		WARN_ON(atomic_read(&stopping_cpu) == -1)

WARN_ON(atomic_read(&stopping_cpu) == -1); ?

";" is missing...

Seiji


-----Original Message-----
From: Don Zickus [mailto:dzickus@redhat.com] 
Sent: Monday, February 13, 2012 3:28 PM
To: x86@kernel.org
Cc: LKML; Peter Zijlstra; tony.luck@intel.com; Seiji Aguchi; ak@linux.intel.com; mjg@redhat.com; levinsasha928@gmail.com; Don Zickus
Subject: [PATCH 2/2] x86, reschedule: check to see if system is shutting down

Due to reschedule changes in v3.3, a WARN_ON has popped up because a cpu suddenly became offline without letting anyone know.

This results in the schedule trying to move something to another cpu only to find out it isn't there and getting confused.  The splat looks something like:

[   32.448626] ------------[ cut here ]------------
[   32.449160] WARNING: at arch/x86/kernel/smp.c:119 native_smp_send_reschedule+0x25/0x43()
[   32.449621] Pid: 1, comm: init_stage2 Not tainted 3.2.0+ #14
[   32.449621] Call Trace:
[   32.449621]  <IRQ>  [<ffffffff81041a44>] ? native_smp_send_reschedule+0x25/0x43
[   32.449621]  [<ffffffff810735b2>] warn_slowpath_common+0x7b/0x93
[   32.449621]  [<ffffffff810962cc>] ? tick_nohz_handler+0xc9/0xc9
[   32.449621]  [<ffffffff81073675>] warn_slowpath_null+0x15/0x18
[   32.449621]  [<ffffffff81041a44>] native_smp_send_reschedule+0x25/0x43
[   32.449621]  [<ffffffff81067a00>] smp_send_reschedule+0xa/0xc
[   32.449621]  [<ffffffff8106f25e>] scheduler_tick+0x21a/0x242
[   32.449621]  [<ffffffff8107da10>] update_process_times+0x62/0x73
[   32.449621]  [<ffffffff81096336>] tick_sched_timer+0x6a/0x8a
[   32.449621]  [<ffffffff8108c5eb>] __run_hrtimer.clone.26+0x55/0xcb
[   32.449621]  [<ffffffff8108cd77>] hrtimer_interrupt+0xcb/0x19b
[   32.449621]  [<ffffffff810428a8>] smp_apic_timer_interrupt+0x72/0x85
[   32.449621]  [<ffffffff8165a8de>] apic_timer_interrupt+0x6e/0x80
[   32.449621]  <EOI>  [<ffffffff8165928e>] ? _raw_spin_unlock_irqrestore+0x3a/0x3e
[   32.449621]  [<ffffffff81042f4e>] ? arch_local_irq_restore+0x6/0xd
[   32.449621]  [<ffffffff810430c4>] default_send_IPI_mask_allbutself_phys+0x78/0x88
[   32.449621]  [<ffffffff8106c3c4>] ? __migrate_task+0xf1/0xf1
[   32.449621]  [<ffffffff81045445>] physflat_send_IPI_allbutself+0x12/0x14
[   32.449621]  [<ffffffff81041aaf>] native_stop_other_cpus+0x4d/0xa8
[   32.449621]  [<ffffffff810411c6>] native_machine_shutdown+0x56/0x6d
[   32.449621]  [<ffffffff81048499>] kvm_shutdown+0x1a/0x1c
[   32.449621]  [<ffffffff810411f9>] machine_shutdown+0xa/0xc
[   32.449621]  [<ffffffff81041265>] native_machine_restart+0x20/0x32
[   32.449621]  [<ffffffff81041297>] machine_restart+0xa/0xc
[   32.449621]  [<ffffffff81081d53>] kernel_restart+0x49/0x4d

I solved this by re-using the atomic global variable that is set during native_smp_stop_other_cpus().  This is the piece of code that causes the problem and it sets stopping_cpu to reflect the system is going down.

If the variable is set do not yell with the WARN_ON, just return.

v2:  use if-condition for WARN-ON instead of if {WARN_ON(1)}

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/smp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c index 48d2b7d..54d570e 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -120,7 +120,8 @@ static bool smp_no_nmi_ipi = false;  static void native_smp_send_reschedule(int cpu)  {
 	if (unlikely(cpu_is_offline(cpu))) {
-		WARN_ON(1);
+		/* system is not shutting down.. yell */
+		WARN_ON(atomic_read(&stopping_cpu) == -1)
 		return;
 	}
 	apic->send_IPI_mask(cpumask_of(cpu), RESCHEDULE_VECTOR);
--
1.7.7.6

