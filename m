Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab1H3QTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:19:36 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:45276 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755547Ab1H3QTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:19:35 -0400
Subject: Re: [PATCH v2] x86: Don't recursively acquire rtc_lock
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        johnstultz <johnstul@us.ibm.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1314720739-28683-1-git-send-email-matt@console-pimps.org>
References: <1314720739-28683-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 17:17:20 +0100
Message-ID: <1314721040.3649.4.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Jan and Avi, apparently git send-email doesn't grok Acked-by's)

On Tue, 2011-08-30 at 17:12 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> A deadlock was introduced on x86 in commit ef68c8f87ed1 ("x86:
> Serialize EFI time accesses on rtc_lock") because efi_get_time() and
> friends can be called with rtc_lock already held by
> read_persistent_time(), e.g.
> 
> timekeeping_init()
>     read_persistent_clock()     <-- acquire rtc_lock
>         efi_get_time()
>             phys_efi_get_time() <-- acquire rtc_lock <DEADLOCK>
> 
> To fix this let's push the locking down into the get_wallclock() and
> set_wallclock() implementations. Only the clock implementations that
> access the x86 RTC directly need to acquire rtc_lock, so it makes
> sense to push the locking down into the rtc, vrtc and efi code.
> 
> The virtualization implementations don't require rtc_lock to be held
> because they provide their own serialization.
> 
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> Acked-by: Jan Beulich <jbeulich@novell.com>
> Acked-by: Avi Kivity <avi@redhat.com> [for the virtualization aspect]
> ---
>  arch/x86/kernel/rtc.c         |   23 ++++++++++++-----------
>  arch/x86/platform/mrst/vrtc.c |    9 +++++++++
>  2 files changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
> index 3f2ad26..ccdbc16 100644
> --- a/arch/x86/kernel/rtc.c
> +++ b/arch/x86/kernel/rtc.c
> @@ -42,8 +42,11 @@ int mach_set_rtc_mmss(unsigned long nowtime)
>  {
>  	int real_seconds, real_minutes, cmos_minutes;
>  	unsigned char save_control, save_freq_select;
> +	unsigned long flags;
>  	int retval = 0;
>  
> +	spin_lock_irqsave(&rtc_lock, flags);
> +
>  	 /* tell the clock it's being set */
>  	save_control = CMOS_READ(RTC_CONTROL);
>  	CMOS_WRITE((save_control|RTC_SET), RTC_CONTROL);
> @@ -93,12 +96,17 @@ int mach_set_rtc_mmss(unsigned long nowtime)
>  	CMOS_WRITE(save_control, RTC_CONTROL);
>  	CMOS_WRITE(save_freq_select, RTC_FREQ_SELECT);
>  
> +	spin_unlock_irqrestore(&rtc_lock, flags);
> +
>  	return retval;
>  }
>  
>  unsigned long mach_get_cmos_time(void)
>  {
>  	unsigned int status, year, mon, day, hour, min, sec, century = 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rtc_lock, flags);
>  
>  	/*
>  	 * If UIP is clear, then we have >= 244 microseconds before
> @@ -125,6 +133,8 @@ unsigned long mach_get_cmos_time(void)
>  	status = CMOS_READ(RTC_CONTROL);
>  	WARN_ON_ONCE(RTC_ALWAYS_BCD && (status & RTC_DM_BINARY));
>  
> +	spin_unlock_irqrestore(&rtc_lock, flags);
> +
>  	if (RTC_ALWAYS_BCD || !(status & RTC_DM_BINARY)) {
>  		sec = bcd2bin(sec);
>  		min = bcd2bin(min);
> @@ -169,24 +179,15 @@ EXPORT_SYMBOL(rtc_cmos_write);
>  
>  int update_persistent_clock(struct timespec now)
>  {
> -	unsigned long flags;
> -	int retval;
> -
> -	spin_lock_irqsave(&rtc_lock, flags);
> -	retval = x86_platform.set_wallclock(now.tv_sec);
> -	spin_unlock_irqrestore(&rtc_lock, flags);
> -
> -	return retval;
> +	return x86_platform.set_wallclock(now.tv_sec);
>  }
>  
>  /* not static: needed by APM */
>  void read_persistent_clock(struct timespec *ts)
>  {
> -	unsigned long retval, flags;
> +	unsigned long retval;
>  
> -	spin_lock_irqsave(&rtc_lock, flags);
>  	retval = x86_platform.get_wallclock();
> -	spin_unlock_irqrestore(&rtc_lock, flags);
>  
>  	ts->tv_sec = retval;
>  	ts->tv_nsec = 0;
> diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
> index 73d70d6..6d5dbcd 100644
> --- a/arch/x86/platform/mrst/vrtc.c
> +++ b/arch/x86/platform/mrst/vrtc.c
> @@ -58,8 +58,11 @@ EXPORT_SYMBOL_GPL(vrtc_cmos_write);
>  unsigned long vrtc_get_time(void)
>  {
>  	u8 sec, min, hour, mday, mon;
> +	unsigned long flags;
>  	u32 year;
>  
> +	spin_lock_irqsave(&rtc_lock, flags);
> +
>  	while ((vrtc_cmos_read(RTC_FREQ_SELECT) & RTC_UIP))
>  		cpu_relax();
>  
> @@ -70,6 +73,8 @@ unsigned long vrtc_get_time(void)
>  	mon = vrtc_cmos_read(RTC_MONTH);
>  	year = vrtc_cmos_read(RTC_YEAR);
>  
> +	spin_unlock_irqrestore(&rtc_lock, flags);
> +
>  	/* vRTC YEAR reg contains the offset to 1960 */
>  	year += 1960;
>  
> @@ -83,8 +88,10 @@ unsigned long vrtc_get_time(void)
>  int vrtc_set_mmss(unsigned long nowtime)
>  {
>  	int real_sec, real_min;
> +	unsigned long flags;
>  	int vrtc_min;
>  
> +	spin_lock_irqsave(&rtc_lock, flags);
>  	vrtc_min = vrtc_cmos_read(RTC_MINUTES);
>  
>  	real_sec = nowtime % 60;
> @@ -95,6 +102,8 @@ int vrtc_set_mmss(unsigned long nowtime)
>  
>  	vrtc_cmos_write(real_sec, RTC_SECONDS);
>  	vrtc_cmos_write(real_min, RTC_MINUTES);
> +	spin_unlock_irqrestore(&rtc_lock, flags);
> +
>  	return 0;
>  }
>  



