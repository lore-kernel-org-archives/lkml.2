Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1A0Buu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 20:50:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:39442 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413Ab1A0But convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 20:50:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,383,1291622400"; 
   d="scan'208";a="651570823"
Date: Thu, 27 Jan 2011 09:50:34 +0800
From: Feng Tang <feng.tang@intel.com>
To: <alan@lxorguk.ukuu.org.uk>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH 2/2] mrst/vrtc: avoid using CMOS RTC ops
Message-ID: <20110127095034.1ae706d9@feng-i7>
In-Reply-To: <AANLkTi=KQ-5=h-iDPRtBRvy45jafQxxhyJu4UPCxZ6Lg@mail.gmail.com>
References: <20110125142613.9886.69516.stgit@bob.linux.org.uk>
	<20110125142627.9886.47807.stgit@bob.linux.org.uk>
	<AANLkTi=KQ-5=h-iDPRtBRvy45jafQxxhyJu4UPCxZ6Lg@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: 2011/1/25
> Subject: [PATCH 2/2] mrst/vrtc: avoid using CMOS RTC ops
> To: x86@kernel.org, linux-kernel@vger.kernel.org
> 
> 
> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
> If we don't assign Moorestown specific wallclock init and ops function
> the rtc/persisent clock code will use CMOS RTC for access, this will
> crash Moorestown as the ioports are not present.
> Also in the vrtc driver, we should avoid using CMOS access to check
> UIP status.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---

Hi,

Here is the updated version, following the change of moving the
wallclock_init() to x86_init.timers.

Thanks,
Feng
-----------------

>From f1b25a39a11a34036db625c8fb4e5a6a0acfa56d Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Thu, 27 Jan 2011 09:39:08 +0800
Subject: [PATCH] mrst/vrtc: avoid using cmos rtc ops

If we don't assign Moorestown specific wallclock init and ops function
the rtc/persisent clock code will use cmos rtc for access, this will
crash Moorestown in that the ioports are not present.

Also in vrtc driver, should avoid using cmos access to check UIP status.

[feng.tang@intel.com: use set_fixmap_offset_nocache() to simplify code]
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 arch/x86/platform/mrst/mrst.c |    2 ++
 arch/x86/platform/mrst/vrtc.c |   15 ++++-----------
 drivers/rtc/rtc-mrst.c        |   13 ++++++++++++-
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index ea6529e..5c0207b 100644
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
+	x86_init.timers.wallclock_init = mrst_rtc_init;
 	x86_init.pci.init = pci_mrst_init;
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index 32cd7ed..f6f34c5 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -100,21 +100,14 @@ int vrtc_set_mmss(unsigned long nowtime)
 
 void __init mrst_rtc_init(void)
 {
-	unsigned long rtc_paddr;
-	void __iomem *virt_base;
+	unsigned long vrtc_paddr = sfi_mrtc_array[0].phys_addr;
 
 	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
-	if (!sfi_mrtc_num)
+	if (!sfi_mrtc_num || !vrtc_paddr)
 		return;
 
-	rtc_paddr = sfi_mrtc_array[0].phys_addr;
-
-	/* vRTC's register address may not be page aligned */
-	set_fixmap_nocache(FIX_LNW_VRTC, rtc_paddr);
-
-	virt_base = (void __iomem *)__fix_to_virt(FIX_LNW_VRTC);
-	virt_base += rtc_paddr & ~PAGE_MASK;
-	vrtc_virt_base = virt_base;
+	vrtc_virt_base = (void __iomem *)set_fixmap_offset_nocache(FIX_LNW_VRTC,
+								vrtc_paddr);
 
 	x86_platform.get_wallclock = vrtc_get_time;
 	x86_platform.set_wallclock = vrtc_set_mmss;
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
-- 
1.7.0.4
