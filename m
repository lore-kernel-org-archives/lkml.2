Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1JAHJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 03:09:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54307 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab1JAHJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 03:09:19 -0400
Date: Sat, 1 Oct 2011 09:07:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] x86 fix
Message-ID: <20111001070745.GA18697@elte.hu>
References: <20110930182256.GA21246@elte.hu>
 <alpine.LFD.2.02.1109302143520.2711@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109302143520.2711@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://tesla.tglx.de/git/linux-2.6-tip.git x86-urgent-for-linus

 Thanks,

	Ingo

------------------>
Matt Fleming (1):
      x86/rtc: Don't recursively acquire rtc_lock


 arch/x86/kernel/rtc.c         |   23 ++++++++++++-----------
 arch/x86/platform/mrst/vrtc.c |    9 +++++++++
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 3f2ad26..ccdbc16 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -42,8 +42,11 @@ int mach_set_rtc_mmss(unsigned long nowtime)
 {
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char save_control, save_freq_select;
+	unsigned long flags;
 	int retval = 0;
 
+	spin_lock_irqsave(&rtc_lock, flags);
+
 	 /* tell the clock it's being set */
 	save_control = CMOS_READ(RTC_CONTROL);
 	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
@@ -93,12 +96,17 @@ int mach_set_rtc_mmss(unsigned long nowtime)
 	CMOS_WRITE(save_control, RTC_CONTROL);
 	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
 
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
 	return retval;
 }
 
 unsigned long mach_get_cmos_time(void)
 {
 	unsigned int status, year, mon, day, hour, min, sec, century = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc_lock, flags);
 
 	/*
 	 * If UIP is clear, then we have >= 244 microseconds before
@@ -125,6 +133,8 @@ unsigned long mach_get_cmos_time(void)
 	status = CMOS_READ(RTC_CONTROL);
 	WARN_ON_ONCE(RTC_ALWAYS_BCD && (status & RTC_DM_BINARY));
 
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
 	if (RTC_ALWAYS_BCD || !(status & RTC_DM_BINARY)) {
 		sec = bcd2bin(sec);
 		min = bcd2bin(min);
@@ -169,24 +179,15 @@ EXPORT_SYMBOL(rtc_cmos_write);
 
 int update_persistent_clock(struct timespec now)
 {
-	unsigned long flags;
-	int retval;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	retval = x86_platform.set_wallclock(now.tv_sec);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-
-	return retval;
+	return x86_platform.set_wallclock(now.tv_sec);
 }
 
 /* not static: needed by APM */
 void read_persistent_clock(struct timespec *ts)
 {
-	unsigned long retval, flags;
+	unsigned long retval;
 
-	spin_lock_irqsave(&rtc_lock, flags);
 	retval = x86_platform.get_wallclock();
-	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	ts->tv_sec = retval;
 	ts->tv_nsec = 0;
diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index 73d70d6..6d5dbcd 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -58,8 +58,11 @@ EXPORT_SYMBOL_GPL(vrtc_cmos_write);
 unsigned long vrtc_get_time(void)
 {
 	u8 sec, min, hour, mday, mon;
+	unsigned long flags;
 	u32 year;
 
+	spin_lock_irqsave(&rtc_lock, flags);
+
 	while ((vrtc_cmos_read(RTC_FREQ_SELECT) & RTC_UIP))
 		cpu_relax();
 
@@ -70,6 +73,8 @@ unsigned long vrtc_get_time(void)
 	mon = vrtc_cmos_read(RTC_MONTH);
 	year = vrtc_cmos_read(RTC_YEAR);
 
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
 	/* vRTC YEAR reg contains the offset to 1960 */
 	year += 1960;
 
@@ -83,8 +88,10 @@ unsigned long vrtc_get_time(void)
 int vrtc_set_mmss(unsigned long nowtime)
 {
 	int real_sec, real_min;
+	unsigned long flags;
 	int vrtc_min;
 
+	spin_lock_irqsave(&rtc_lock, flags);
 	vrtc_min = vrtc_cmos_read(RTC_MINUTES);
 
 	real_sec = nowtime % 60;
@@ -95,6 +102,8 @@ int vrtc_set_mmss(unsigned long nowtime)
 
 	vrtc_cmos_write(real_sec, RTC_SECONDS);
 	vrtc_cmos_write(real_min, RTC_MINUTES);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+
 	return 0;
 }
 
