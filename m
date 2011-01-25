Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1AYOxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:53:15 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47506 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1AYOxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:53:12 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] mrst/vrtc: avoid using CMOS RTC ops
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Jan 2011 14:26:28 +0000
Message-ID: <20110125142627.9886.47807.stgit@bob.linux.org.uk>
In-Reply-To: <20110125142613.9886.69516.stgit@bob.linux.org.uk>
References: <20110125142613.9886.69516.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

If we don't assign Moorestown specific wallclock init and ops function
the rtc/persisent clock code will use CMOS RTC for access, this will
crash Moorestown as the ioports are not present.
Also in the vrtc driver, we should avoid using CMOS access to check UIP status.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/platform/mrst/mrst.c |    2 ++
 drivers/rtc/rtc-mrst.c        |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)


diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index ea6529e..dea829c 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -31,6 +31,7 @@
 #include <asm/apic.h>
 #include <asm/io_apic.h>
 #include <asm/mrst.h>
+#include <asm/mrst-vrtc.h>
 #include <asm/io.h>
 #include <asm/i8259.h>
 #include <asm/intel_scu_ipc.h>
@@ -268,6 +269,7 @@ void __init x86_mrst_early_setup(void)
 
 	x86_platform.calibrate_tsc = mrst_calibrate_tsc;
 	x86_platform.i8042_detect = mrst_i8042_detect;
+	x86_platform.wallclock_init = mrst_rtc_init;
 	x86_init.pci.init = pci_mrst_init;
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index bcd0cf6..28e02e7 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -62,6 +62,17 @@ static inline int is_intr(u8 rtc_intr)
 	return rtc_intr & RTC_IRQMASK;
 }
 
+static inline unsigned char vrtc_is_updating(void)
+{
+	unsigned char uip;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	uip = (vrtc_cmos_read(RTC_FREQ_SELECT) & RTC_UIP);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return uip;
+}
+
 /*
  * rtc_time's year contains the increment over 1900, but vRTC's YEAR
  * register can't be programmed to value larger than 0x64, so vRTC
@@ -76,7 +87,7 @@ static int mrst_read_time(struct device *dev, struct rtc_time *time)
 {
 	unsigned long flags;
 
-	if (rtc_is_updating())
+	if (vrtc_is_updating())
 		mdelay(20);
 
 	spin_lock_irqsave(&rtc_lock, flags);

