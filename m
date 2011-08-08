Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab1HHNkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 09:40:41 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34339 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662Ab1HHNkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 09:40:40 -0400
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
From: Matt Fleming <matt@console-pimps.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: hpa@linux.intel.com, mjg@redhat.com, linux-kernel@vger.kernel.org,
        john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <4E3C30C602000078000740D5@nat28.tlf.novell.com>
References: <4E3C30C602000078000740D5@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 14:40:36 +0100
Message-ID: <1312810836.10579.127.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 18:04 +0100, Jan Beulich wrote:
> 
> Virtual platforms will have to take care of the serialization in the
> host anyway, so the guest side implementation of getwallclock et al
> is entirely unaffected.

Ah, OK, that's the important part. I didn't realise that rtc_lock isn't
actually required by any other code. In which case, yes, it completely
makes sense to push the locking of rtc_lock down into the
implementations that actually need it.

It'd be great if I could get some ACK's from the virtualization guys.

--------8<--------

>From a0a39dbb69f6ac675846bf00f30ad153506a4567 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Mon, 8 Aug 2011 12:59:35 +0100
Subject: [PATCH] x86, efi: Don't recursively acquire rtc_lock

A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86:
Serialize EFI time accesses on rtc_lock") because efi_get_time() and
friends can be called with rtc_lock already held by
read_persistent_time(), e.g.

timekeeping_init()
    read_persistent_clock()     <-- acquire rtc_lock
        efi_get_time()
            phys_efi_get_time() <-- acquire rtc_lock <DEADLOCK>

To fix this let's push the locking down into the get_wallclock() and
set_wallclock() implementations. Only the clock implementations that
access the x86 RTC directly need to acquire rtc_lock, so it makes
sense to push the locking down into the rtc, vrtc and efi code.

The virtualization implementations don't require rtc_lock to be held
because they provide their own serialization.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
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
 
-- 
1.7.4.4


