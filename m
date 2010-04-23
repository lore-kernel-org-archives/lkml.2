Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0DWICO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:02:14 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:50403 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab0DWIAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:00:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       rtc-linux@googlegroups.com
Subject: [PATCH 14/14] m68k: amiga - RTC platform device conversion
Date: Fri, 23 Apr 2010 10:00:35 +0200
Message-Id: <1272009635-6504-15-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-14-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-4-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-5-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-6-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-7-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-8-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-9-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-10-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-11-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-12-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-13-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-14-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A2000 TOD is an Oki MSM6242B, while the A3000 TOD is a Ricoh RP5C01.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: rtc-linux@googlegroups.com
---
 arch/m68k/amiga/config.c   |  174 --------------------------------------------
 arch/m68k/amiga/platform.c |   17 ++++
 2 files changed, 17 insertions(+), 174 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index a50e8ab..abe0c38 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -97,10 +97,6 @@ static void amiga_get_model(char *model);
 static void amiga_get_hardware_list(struct seq_file *m);
 /* amiga specific timer functions */
 static unsigned long amiga_gettimeoffset(void);
-static int a3000_hwclk(int, struct rtc_time *);
-static int a2000_hwclk(int, struct rtc_time *);
-static int amiga_set_clock_mmss(unsigned long);
-static unsigned int amiga_get_ss(void);
 extern void amiga_mksound(unsigned int count, unsigned int ticks);
 static void amiga_reset(void);
 extern void amiga_init_sound(void);
@@ -141,10 +137,6 @@ static struct {
 	}
 };
 
-static struct resource rtc_resource = {
-	.start = 0x00dc0000, .end = 0x00dcffff
-};
-
 static struct resource ram_resource[NUM_MEMINFO];
 
 
@@ -390,15 +382,6 @@ void __init config_amiga(void)
 	mach_get_model       = amiga_get_model;
 	mach_get_hardware_list = amiga_get_hardware_list;
 	mach_gettimeoffset   = amiga_gettimeoffset;
-	if (AMIGAHW_PRESENT(A3000_CLK)) {
-		mach_hwclk         = a3000_hwclk;
-		rtc_resource.name = "A3000 RTC";
-		request_resource(&iomem_resource, &rtc_resource);
-	} else /* if (AMIGAHW_PRESENT(A2000_CLK)) */ {
-		mach_hwclk         = a2000_hwclk;
-		rtc_resource.name = "A2000 RTC";
-		request_resource(&iomem_resource, &rtc_resource);
-	}
 
 	/*
 	 * default MAX_DMA=0xffffffff on all machines. If we don't do so, the SCSI
@@ -407,8 +390,6 @@ void __init config_amiga(void)
 	 */
 	mach_max_dma_address = 0xffffffff;
 
-	mach_set_clock_mmss  = amiga_set_clock_mmss;
-	mach_get_ss          = amiga_get_ss;
 	mach_reset           = amiga_reset;
 #if defined(CONFIG_INPUT_M68K_BEEP) || defined(CONFIG_INPUT_M68K_BEEP_MODULE)
 	mach_beep            = amiga_mksound;
@@ -536,161 +517,6 @@ static unsigned long amiga_gettimeoffset(void)
 	return ticks + offset;
 }
 
-static int a3000_hwclk(int op, struct rtc_time *t)
-{
-	tod_3000.cntrl1 = TOD3000_CNTRL1_HOLD;
-
-	if (!op) { /* read */
-		t->tm_sec  = tod_3000.second1 * 10 + tod_3000.second2;
-		t->tm_min  = tod_3000.minute1 * 10 + tod_3000.minute2;
-		t->tm_hour = tod_3000.hour1   * 10 + tod_3000.hour2;
-		t->tm_mday = tod_3000.day1    * 10 + tod_3000.day2;
-		t->tm_wday = tod_3000.weekday;
-		t->tm_mon  = tod_3000.month1  * 10 + tod_3000.month2 - 1;
-		t->tm_year = tod_3000.year1   * 10 + tod_3000.year2;
-		if (t->tm_year <= 69)
-			t->tm_year += 100;
-	} else {
-		tod_3000.second1 = t->tm_sec / 10;
-		tod_3000.second2 = t->tm_sec % 10;
-		tod_3000.minute1 = t->tm_min / 10;
-		tod_3000.minute2 = t->tm_min % 10;
-		tod_3000.hour1   = t->tm_hour / 10;
-		tod_3000.hour2   = t->tm_hour % 10;
-		tod_3000.day1    = t->tm_mday / 10;
-		tod_3000.day2    = t->tm_mday % 10;
-		if (t->tm_wday != -1)
-			tod_3000.weekday = t->tm_wday;
-		tod_3000.month1  = (t->tm_mon + 1) / 10;
-		tod_3000.month2  = (t->tm_mon + 1) % 10;
-		if (t->tm_year >= 100)
-			t->tm_year -= 100;
-		tod_3000.year1   = t->tm_year / 10;
-		tod_3000.year2   = t->tm_year % 10;
-	}
-
-	tod_3000.cntrl1 = TOD3000_CNTRL1_FREE;
-
-	return 0;
-}
-
-static int a2000_hwclk(int op, struct rtc_time *t)
-{
-	int cnt = 5;
-
-	tod_2000.cntrl1 = TOD2000_CNTRL1_HOLD;
-
-	while ((tod_2000.cntrl1 & TOD2000_CNTRL1_BUSY) && cnt) {
-		tod_2000.cntrl1 &= ~TOD2000_CNTRL1_HOLD;
-		udelay(70);
-		tod_2000.cntrl1 |= TOD2000_CNTRL1_HOLD;
-		--cnt;
-	}
-
-	if (!cnt)
-		printk(KERN_INFO "hwclk: timed out waiting for RTC (0x%x)\n",
-			tod_2000.cntrl1);
-
-	if (!op) { /* read */
-		t->tm_sec  = tod_2000.second1     * 10 + tod_2000.second2;
-		t->tm_min  = tod_2000.minute1     * 10 + tod_2000.minute2;
-		t->tm_hour = (tod_2000.hour1 & 3) * 10 + tod_2000.hour2;
-		t->tm_mday = tod_2000.day1        * 10 + tod_2000.day2;
-		t->tm_wday = tod_2000.weekday;
-		t->tm_mon  = tod_2000.month1      * 10 + tod_2000.month2 - 1;
-		t->tm_year = tod_2000.year1       * 10 + tod_2000.year2;
-		if (t->tm_year <= 69)
-			t->tm_year += 100;
-
-		if (!(tod_2000.cntrl3 & TOD2000_CNTRL3_24HMODE)) {
-			if (!(tod_2000.hour1 & TOD2000_HOUR1_PM) && t->tm_hour == 12)
-				t->tm_hour = 0;
-			else if ((tod_2000.hour1 & TOD2000_HOUR1_PM) && t->tm_hour != 12)
-				t->tm_hour += 12;
-		}
-	} else {
-		tod_2000.second1 = t->tm_sec / 10;
-		tod_2000.second2 = t->tm_sec % 10;
-		tod_2000.minute1 = t->tm_min / 10;
-		tod_2000.minute2 = t->tm_min % 10;
-		if (tod_2000.cntrl3 & TOD2000_CNTRL3_24HMODE)
-			tod_2000.hour1 = t->tm_hour / 10;
-		else if (t->tm_hour >= 12)
-			tod_2000.hour1 = TOD2000_HOUR1_PM +
-				(t->tm_hour - 12) / 10;
-		else
-			tod_2000.hour1 = t->tm_hour / 10;
-		tod_2000.hour2   = t->tm_hour % 10;
-		tod_2000.day1    = t->tm_mday / 10;
-		tod_2000.day2    = t->tm_mday % 10;
-		if (t->tm_wday != -1)
-			tod_2000.weekday = t->tm_wday;
-		tod_2000.month1  = (t->tm_mon + 1) / 10;
-		tod_2000.month2  = (t->tm_mon + 1) % 10;
-		if (t->tm_year >= 100)
-			t->tm_year -= 100;
-		tod_2000.year1   = t->tm_year / 10;
-		tod_2000.year2   = t->tm_year % 10;
-	}
-
-	tod_2000.cntrl1 &= ~TOD2000_CNTRL1_HOLD;
-
-	return 0;
-}
-
-static int amiga_set_clock_mmss(unsigned long nowtime)
-{
-	short real_seconds = nowtime % 60, real_minutes = (nowtime / 60) % 60;
-
-	if (AMIGAHW_PRESENT(A3000_CLK)) {
-		tod_3000.cntrl1 = TOD3000_CNTRL1_HOLD;
-
-		tod_3000.second1 = real_seconds / 10;
-		tod_3000.second2 = real_seconds % 10;
-		tod_3000.minute1 = real_minutes / 10;
-		tod_3000.minute2 = real_minutes % 10;
-
-		tod_3000.cntrl1 = TOD3000_CNTRL1_FREE;
-	} else /* if (AMIGAHW_PRESENT(A2000_CLK)) */ {
-		int cnt = 5;
-
-		tod_2000.cntrl1 |= TOD2000_CNTRL1_HOLD;
-
-		while ((tod_2000.cntrl1 & TOD2000_CNTRL1_BUSY) && cnt) {
-			tod_2000.cntrl1 &= ~TOD2000_CNTRL1_HOLD;
-			udelay(70);
-			tod_2000.cntrl1 |= TOD2000_CNTRL1_HOLD;
-			--cnt;
-		}
-
-		if (!cnt)
-			printk(KERN_INFO "set_clock_mmss: timed out waiting for RTC (0x%x)\n", tod_2000.cntrl1);
-
-		tod_2000.second1 = real_seconds / 10;
-		tod_2000.second2 = real_seconds % 10;
-		tod_2000.minute1 = real_minutes / 10;
-		tod_2000.minute2 = real_minutes % 10;
-
-		tod_2000.cntrl1 &= ~TOD2000_CNTRL1_HOLD;
-	}
-
-	return 0;
-}
-
-static unsigned int amiga_get_ss(void)
-{
-	unsigned int s;
-
-	if (AMIGAHW_PRESENT(A3000_CLK)) {
-		tod_3000.cntrl1 = TOD3000_CNTRL1_HOLD;
-		s = tod_3000.second1 * 10 + tod_3000.second2;
-		tod_3000.cntrl1 = TOD3000_CNTRL1_FREE;
-	} else /* if (AMIGAHW_PRESENT(A2000_CLK)) */ {
-		s = tod_2000.second1 * 10 + tod_2000.second2;
-	}
-	return s;
-}
-
 static NORET_TYPE void amiga_reset(void)
     ATTRIB_NORET;
 
diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index c985db0..7fd8b41 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -116,6 +116,13 @@ static const struct gayle_ide_platform_data a4000_ide_pdata __initconst = {
 };
 
 
+static const struct resource amiga_rtc_resource __initconst = {
+	.start	= 0x00dc0000,
+	.end	= 0x00dcffff,
+	.flags	= IORESOURCE_MEM,
+};
+
+
 static int __init amiga_init_devices(void)
 {
 	struct platform_device *pdev;
@@ -174,6 +181,16 @@ static int __init amiga_init_devices(void)
 	if (AMIGAHW_PRESENT(AMI_PARALLEL))
 		platform_device_register_simple("amiga-parallel", -1, NULL, 0);
 
+
+	/* real time clocks */
+	if (AMIGAHW_PRESENT(A2000_CLK))
+		platform_device_register_simple("rtc-msm6242", -1,
+						&amiga_rtc_resource, 1);
+
+	if (AMIGAHW_PRESENT(A3000_CLK))
+		platform_device_register_simple("rtc-rp5c01", -1,
+						&amiga_rtc_resource, 1);
+
 	return 0;
 }
 
-- 
1.6.0.4

