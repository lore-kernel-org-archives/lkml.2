Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1AIWmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:42:35 -0500
Received: from vs244178.vserver.de ([62.75.244.178]:56194 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1AIWme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:42:34 -0500
X-Greylist: delayed 2121 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Jan 2011 17:42:33 EST
Date: Sun, 9 Jan 2011 23:07:07 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1927484457.20110109230707@eikelenboom.it>
To: Yinghai Lu <yinghai@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] x86: usb handoff in early_quirk
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some systems keep getting
APIC calibration not consistent with PM-Timer: 139ms instead of 100ms
APIC delta adjusted to PM-Timer: 831249 (1163736)

USB legacy SMI handler is not disabled at that time.

Try to disable USB legacy support early with this patch.
So later APIC Timer calibration don't get messed up by USB legacy support SMI handler.
After this patch, that warning never show up for 100 reboot tests.

reuse code from drivers/usb/host/pci-quirks.c
with changes
1. delay and sleep ===> io_delay
2. dev_warn etc to pr_warn(num, slot, func...)

Signed-off-by: Yinghai Lu <yinghai@xxxxxxxxxx>

---
arch/x86/kernel/early-quirks.c | 170 +++++++++++++++++++++++++++++++++++++++++
1 file changed, 170 insertions(+)

Index: linux-2.6/arch/x86/kernel/early-quirks.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early-quirks.c
+++ linux-2.6/arch/x86/kernel/early-quirks.c
@@ -19,6 +19,174 @@
#include <asm/iommu.h>
#include <asm/gart.h>

+static inline void early_udelay2(void)
+{
+#ifndef CONFIG_PARVIRT
+ native_io_delay();
+#else
+ pv_cpu_ops.io_delay();
+#endif
+}
+


Shouldn't that be CONFIG_PARAVIRT ?

--

Sander

