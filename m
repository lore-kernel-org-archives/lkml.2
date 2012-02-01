Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2BAV3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:29:30 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:63445 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab2BAVTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/smp: Fix CPU online/offline bug triggering a BUG: scheduling while atomic.
Date: Wed,  1 Feb 2012 16:16:39 -0500
Message-Id: <1328131000-13485-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1328131000-13485-1-git-send-email-konrad.wilk@oracle.com>
References: <1328131000-13485-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F29AC57.0006,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a user offlines a VCPU and then onlines it, we get:

NMI watchdog disabled (cpu2): hardware events not enabled
BUG: scheduling while atomic: swapper/2/0/0x00000002
Modules linked in: dm_multipath dm_mod xen_evtchn iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi scsi_mod libcrc32c crc32c radeon fbco
 ttm bitblit softcursor drm_kms_helper xen_blkfront xen_netfront xen_fbfront fb_sys_fops sysimgblt sysfillrect syscopyarea xen_kbdfront xenfs [last unloaded:

Pid: 0, comm: swapper/2 Tainted: G           O 3.2.0phase15.1-00003-gd6f7f5b-dirty #4
Call Trace:
 [<ffffffff81070571>] __schedule_bug+0x61/0x70
 [<ffffffff8158eb78>] __schedule+0x798/0x850
 [<ffffffff8158ed6a>] schedule+0x3a/0x50
 [<ffffffff810349be>] cpu_idle+0xbe/0xe0
 [<ffffffff81583599>] cpu_bringup_and_idle+0xe/0x10

The reason for this should be obvious from this call-chain:
cpu_bringup_and_idle:
 \- cpu_bringup
  |   \-[preempt_disable]
  |
  |- cpu_idle
       \- play_dead [assuming the user offlined the VCPU]
       |     \
       |     +- (xen_play_dead)
       |          \- HYPERVISOR_VCPU_off [so VCPU is dead, once user
       |          |                       onlines it starts from here]
       |          \- cpu_bringup [preempt_disable]
       |
       +- preempt_enable_no_reschedule()
       +- schedule()
       \- preempt_enable()

So we have two preempt_disble() and one preempt_enable(). Calling
preempt_enable() after the cpu_bringup() in the xen_play_dead
fixes the imbalance.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/smp.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 041d4fe..501d4e0 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -409,6 +409,13 @@ static void __cpuinit xen_play_dead(void) /* used only with HOTPLUG_CPU */
 	play_dead_common();
 	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
 	cpu_bringup();
+	/*
+	 * Balance out the preempt calls - as we are running in cpu_idle
+	 * loop which has been called at bootup from cpu_bringup_and_idle.
+	 * The cpucpu_bringup_and_idle called cpu_bringup which made a
+	 * preempt_disable() So this preempt_enable will balance it out.
+	 */
+	preempt_enable();
 }
 
 #else /* !CONFIG_HOTPLUG_CPU */
-- 
1.7.7.5

