Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab2GDOXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:23:54 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:12557 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753334Ab2GDOXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:23:20 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, John Linn <john.linn@xilinx.com>
Subject: [PATCH 3/3] ARM: zynq: Map DEBUG_LL UARTs in vmalloc space.
Date: Wed,  4 Jul 2012 10:13:35 -0400
Message-Id: <1341411215-3617-4-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1341411215-3617-1-git-send-email-nbowler@elliptictech.com>
References: <1341411215-3617-1-git-send-email-nbowler@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the other statically mapped devices on this platform, the
physical=virtual mapping of the UARTs placese these devices outside
of the vmalloc region (0xf0000000–0xff000000).  This causes the
following crash when booting the ZC702 board with CONFIG_DEBUG_LL
enabled:

  BUG: mapping for 0xe0001000 at 0xe0001000 out of vmalloc space
  ------------[ cut here ]------------
  kernel BUG at /scratch_space/linux/arch/arm/mm/mmu.c:580!
  Internal error: Oops - BUG: 0 [#1] PREEMPT ARM
  Modules linked in:
  CPU: 0    Not tainted  (3.5.0-rc5-00012-g832a165 #50)
  PC is at early_pte_alloc+0x54/0x70
  LR is at create_mapping+0x288/0x310
  pc : [<c043ab14>]    lr : [<c043adb8>]    psr: 200001d3
  sp : c07fff10  ip : 000008f8  fp : 00000000
  r10: 00001000  r9 : 413fc090  r8 : e0001000
  r7 : e0002000  r6 : 00000041  r5 : e0001000  r4 : c0007800
  r3 : 2000040e  r2 : 00000041  r1 : e0001000  r0 : 2000040e
  Flags: nzCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
  Control: 18c5387d  Table: 00004059  DAC: 00000015
  Process swapper (pid: 0, stack limit = 0xc07fe2e8)
  Stack: (0xc07fff10 to 0xc0800000)
  ff00:                                     e0001000 c080a81c c0007800 c043adb8
  ff20: e0001000 00000080 e0002000 e0001fff 00000080 c0451270 00000001 ef7fdfe0
  ff40: c043ae40 40000001 413fc090 ef7fe000 00000000 c043ae7c c043c0c0 c044fcbc
  ff60: 00000000 0002f7ff c0450fb8 c07fffe4 00000000 c043b5e4 ffff0000 0002f7ff
  ff80: 00001000 00000008 c08148c4 c044fcbc c0830218 00008000 c08148c4 c0438b08
  ffa0: 00000000 18c5387d c03b5952 c07fffc4 c0837ec4 00000001 c080604c c0450ba8
  ffc0: c0809a54 00004059 00000000 c04354f4 00000000 00000000 00000000 00000000
  ffe0: 00000000 c0450bac 18c5387d c080604c c0450ba8 0000803c 00000000 00000000
  [<c043ab14>] (early_pte_alloc+0x54/0x70) from [<c043adb8>] (create_mapping+0x288/0x310)
  [<c043adb8>] (create_mapping+0x288/0x310) from [<c043ae7c>] (iotable_init+0x3c/0xb0)
  [<c043ae7c>] (iotable_init+0x3c/0xb0) from [<c043b5e4>] (paging_init+0x574/0x708)
  [<c043b5e4>] (paging_init+0x574/0x708) from [<c0438b08>] (setup_arch+0x518/0x7d4)
  [<c0438b08>] (setup_arch+0x518/0x7d4) from [<c04354f4>] (start_kernel+0x68/0x2d4)
  [<c04354f4>] (start_kernel+0x68/0x2d4) from [<0000803c>] (0x803c)
  Code: f57ff04f e5940000 e3100002 0a000000 (e7f001f2)
  ---[ end trace 1b75b31a2719ed1c ]---
  Kernel panic - not syncing: Attempted to kill the idle task!

It seems easy enough to move the static mappings into the vmalloc range,
so let's do so.  This allows the system to boot.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Cc: John Linn <john.linn@xilinx.com>

---
 arch/arm/mach-zynq/include/mach/zynq_soc.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
index 6f83f1c..e1c4704 100644
--- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -17,13 +17,12 @@
 
 #define PERIPHERAL_CLOCK_RATE		2500000
 
-/* For now, all mappings are flat (physical = virtual)
- */
+/* The UART must be mapped within the vmalloc range (0xF0000000-0xFF000000). */
 #define UART0_PHYS			0xE0000000
-#define UART0_VIRT			UART0_PHYS
+#define UART0_VIRT			0xF0000000
 
 #define UART1_PHYS			0xE0001000
-#define UART1_VIRT			UART1_PHYS
+#define UART1_VIRT			0xF0001000
 
 #define TTC0_PHYS			0xF8001000
 #define TTC0_VIRT			TTC0_PHYS
-- 
1.7.8.6


