Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2EUVtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:49:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44915 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab2EUVtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:49:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, david.vrabel@citrix.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/2] xen/smp: unbind irqworkX when unplugging vCPUs.
Date: Mon, 21 May 2012 17:42:41 -0400
Message-Id: <1337636562-9579-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1337636562-9579-1-git-send-email-konrad.wilk@oracle.com>
References: <1337636562-9579-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The git commit  1ff2b0c303698e486f1e0886b4d9876200ef8ca5
"xen: implement IRQ_WORK_VECTOR handler" added the functionality
to have a per-cpu "irqworkX" for the IPI APIC functionality.
However it missed the unbind when a vCPU is unplugged resulting
in an orphaned per-cpu interrupt line for unplugged vCPU:

  30:        216          0   xen-dyn-event     hvc_console
  31:        810          4   xen-dyn-event     eth0
  32:         29          0   xen-dyn-event     blkif
- 36:          0          0  xen-percpu-ipi       irqwork2
- 37:        287          0   xen-dyn-event     xenbus
+ 36:        287          0   xen-dyn-event     xenbus
 NMI:          0          0   Non-maskable interrupts
 LOC:          0          0   Local timer interrupts
 SPU:          0          0   Spurious interrupts

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/smp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 0503c0c..0e95d7c 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -418,6 +418,7 @@ static void xen_cpu_die(unsigned int cpu)
 	unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
 	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(xen_irq_work, cpu), NULL);
 	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
 
-- 
1.7.7.5

