Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0EKO6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:58:23 -0400
Received: from www.tglx.de ([62.245.132.106]:51219 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab0EKO6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:58:22 -0400
Date: Tue, 11 May 2010 16:57:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
In-Reply-To: <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1005111643380.3401@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010, Jacob Pan wrote:
> --- /dev/null
> +++ b/arch/x86/include/asm/vrtc.h
> @@ -0,0 +1,27 @@
> +#ifndef _MRST_VRTC_H
> +#define _MRST_VRTC_H
> +
> +#ifdef CONFIG_X86_MRST
> +extern unsigned char vrtc_cmos_read(unsigned char reg);
> +extern void vrtc_cmos_write(unsigned char val, unsigned char reg);
> +extern unsigned long vrtc_get_time(void);
> +extern int vrtc_set_mmss(unsigned long nowtime);
> +extern void vrtc_set_base(void __iomem *base);
> +
> +#define MRST_VRTC_PGOFFSET  (0xc00)
> +
> +#else

  Errm. That's a MRST specific header and nothing outside of MRST is
  using it. So why the #ifdef CONFIG_X86_MRST and the inline functions
  in the #else path ?

> +static inline unsigned char vrtc_cmos_read(unsigned char reg)
> +{
> +	return 0xff;
> +}
> +
 
>  /**
>   * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
> @@ -268,7 +269,24 @@ void __init mrst_time_init(void)
>  
>  void __init mrst_rtc_init(void)
>  {
> +	unsigned long rtc_paddr;
> +	void __iomem *virt_base;
> +
>  	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
> +	if (!sfi_mrtc_num)
> +		return;
> +
> +	rtc_paddr = sfi_mrtc_array[0].phys_addr;
> +
> +	/* vRTC's register address may not be page aligned */
> +	set_fixmap_nocache(FIX_LNW_VRTC, rtc_paddr);

Why do we need a fixmap for that ? There is no need to setup RTC that
early. The first call is from timekeeping_init() 

Also this RTC init code should be in vrtc.c

> +
> +static unsigned char __iomem *vrtc_virt_base;
> +
> +void vrtc_set_base(void __iomem *base)
> +{
> +	vrtc_virt_base = base;
> +}
> +
> +unsigned char vrtc_cmos_read(unsigned char reg)
> +{
> +	unsigned char retval;
> +
> +	/* vRTC's registers range from 0x0 to 0xD */
> +	if (reg > 0xd || !vrtc_virt_base)
> +		return 0xff;
> +
> +	lock_cmos_prefix(reg);

  This lock_cmos magic should just die. I have no idea why something
  wants or wanted to access the RTC from an NMI.

> +	retval = __raw_readb(vrtc_virt_base + (reg << 2));
> +	lock_cmos_suffix(reg);
> +	return retval;
> +}
> +EXPORT_SYMBOL(vrtc_cmos_read);
> +
> +void vrtc_cmos_write(unsigned char val, unsigned char reg)
> +{
> +	if (reg > 0xd || !vrtc_virt_base)
> +		return;
> +
> +	lock_cmos_prefix(reg);
> +	__raw_writeb(val, vrtc_virt_base + (reg << 2));
> +	lock_cmos_suffix(reg);
> +}
> +EXPORT_SYMBOL(vrtc_cmos_write);
> +
> +unsigned long vrtc_get_time(void)
> +{
> +	u8 sec, min, hour, mday, mon;
> +	u32 year;
> +
> +	while ((vrtc_cmos_read(RTC_FREQ_SELECT) & RTC_UIP))
> +		cpu_relax();
> +
> +	sec = vrtc_cmos_read(RTC_SECONDS);
> +	min = vrtc_cmos_read(RTC_MINUTES);
> +	hour = vrtc_cmos_read(RTC_HOURS);
> +	mday = vrtc_cmos_read(RTC_DAY_OF_MONTH);
> +	mon = vrtc_cmos_read(RTC_MONTH);
> +	year = vrtc_cmos_read(RTC_YEAR);
> +
> +	/* vRTC YEAR reg contains the offset to 1960 */
> +	year += 1960;
> +
> +	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
> +		"mon: %d year: %d\n", sec, min, hour, mday, mon, year);

  Please remove the debug noise

Thanks,

	tglx
