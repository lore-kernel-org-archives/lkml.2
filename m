Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab2EXUGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:06:00 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:51253 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933458Ab2EXUF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:05:56 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, Russ.Dill@ti.com, mporter@ti.com,
        linux-arm-kernel@lists.infradead.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        stable@vger.kernel.org
Subject: [PATCH] [ARM] Unconditional call to smp_cross_call on UP crashes (take #2)
Date: Fri, 25 May 2012 19:58:36 +0000
Message-Id: <1337975916-31167-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap2plus_defconfig builds with SMP & SMP_ON_UP set.
On beagle (which is UP) is_smp() returns false and we don't call
smp_init_cpus which in turn does not initialize smp_cross_call which
remains NULL.

When issuing a reboot we OOPS with a NULL dereference on stop smp_call.

Fixed by a check with if (!cpumask_empty(&mask)) before issuing the smp
stop cross call.

Restarting system.
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = dda50000
[00000000] *pgd=9e723831, *pte=00000000, *ppte=00000000
Internal error: Oops: 80000007 [#1] SMP ARM
Modules linked in:
CPU: 0    Not tainted  (3.4.0-00001-gb15b046 #30)
PC is at 0x0
LR is at smp_send_stop+0x4c/0xe8
pc : [<00000000>]    lr : [<c00188cc>]    psr: 60000013
sp : de7b5e70  ip : 00000000  fp : 00000001
r10: 00000000  r9 : de7b4000  r8 : c07263d0
r7 : 00000000  r6 : c06e1294  r5 : 000f4240  r4 : de7b5e74
r3 : 00000000  r2 : 00000000  r1 : 00000006  r0 : de7b5e74
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5387d  Table: 9da50019  DAC: 00000015
Process reboot (pid: 2229, stack limit = 0xde7b42f8)
Stack: (0xde7b5e70 to 0xde7b6000)
5e60:                                     00000000 00000000 00000000 01234567
5e80: de7b4000 c001475c 4321fedc c0052570 0000003e 00000000 c081db78 0000003e
5ea0: 00000001 00000002 00000002 c00891f0 00000002 dd5ba0ac 00000002 00000000
5ec0: dd5ba0ac de7b4000 c009eef4 de7b4000 c00f44dc de7b4000 c00f44dc 00000000
5ee0: c0c94d24 de7b4000 00000000 00000000 00000002 00000002 00000000 c00891f0
5f00: 00000002 00000000 00000000 c011286c 00000000 dd5ba060 60000013 00000000
5f20: dd688d8c 00000000 de7b4000 c06e20f8 dec14760 dec14750 de7b4000 c06e20f8
5f40: 00011f10 c01128a0 00000002 00000000 c011286c c00fa014 dd8c3180 de7b4000
5f60: c0013380 de508bc0 00000001 60000010 00000001 ef000000 00000001 c0089bfc
5f80: 00000000 00000001 00000004 00000058 00000000 00000001 00000004 00000058
5fa0: c0013428 c0013260 00000000 00000001 fee1dead 28121969 01234567 00000000
5fc0: 00000000 00000001 00000004 00000058 00000001 00000001 00000000 00000001
5fe0: b6e76200 beba4c90 00009210 b6e76218 60000010 fee1dead 00000000 00000000
[<c00188cc>] (smp_send_stop+0x4c/0xe8) from [<c001475c>] (machine_restart+0xc/0x54)
[<c001475c>] (machine_restart+0xc/0x54) from [<c0052570>] (sys_reboot+0x140/0x204)
[<c0052570>] (sys_reboot+0x140/0x204) from [<c0013260>] (ret_fast_syscall+0x0/0x3c)
Code: bad PC value
---[ end trace f5035e8726d1f51b ]---

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: stable@vger.kernel.org
---
 arch/arm/kernel/smp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 8f46446..7babc3f 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -590,7 +590,8 @@ void smp_send_stop(void)
 
 	cpumask_copy(&mask, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), &mask);
-	smp_cross_call(&mask, IPI_CPU_STOP);
+	if (!cpumask_empty(&mask))
+		smp_cross_call(&mask, IPI_CPU_STOP);
 
 	/* Wait up to one second for other CPUs to stop */
 	timeout = USEC_PER_SEC;
-- 
1.7.1

