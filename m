Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab0ELCW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:22:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:14057 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab0ELCW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:22:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,211,1272870000"; 
   d="scan'208";a="797612688"
Date: Wed, 12 May 2010 10:34:22 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
Message-ID: <20100512103422.1d59cc85@feng-i7>
In-Reply-To: <alpine.LFD.2.00.1005111643380.3401@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com>
	<alpine.LFD.2.00.1005111643380.3401@localhost.localdomain>
Organization: intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for the great comments!


On Tue, 11 May 2010 22:57:44 +0800
Thomas Gleixner <tglx@linutronix.de> wrote:

> > +extern int vrtc_set_mmss(unsigned long nowtime);
> > +extern void vrtc_set_base(void __iomem *base);
> > +
> > +#define MRST_VRTC_PGOFFSET  (0xc00)
> > +
> > +#else
> 
>   Errm. That's a MRST specific header and nothing outside of MRST is
>   using it. So why the #ifdef CONFIG_X86_MRST and the inline functions
>   in the #else path ?

My bad not mentioning there is another rtc-mrst.c which will sit in drivers/rtc,
it will use some of the functions listed here. It will be posted later.

vrtc.c/rtc-mrst.c is similar with the rtc.c/rtc-cmos.c in general x86 PCs, as
drivers/rtc may not always be enabled in kernel, vrtc.c need sit in arch/x86
to provide the get/set_time service, while rtc-mrst.c will serve general rtc
subsystem

> >  void __init mrst_rtc_init(void)
> >  {
> > +	unsigned long rtc_paddr;
> > +	void __iomem *virt_base;
> > +
> >  	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
> > +	if (!sfi_mrtc_num)
> > +		return;
> > +
> > +	rtc_paddr = sfi_mrtc_array[0].phys_addr;
> > +
> > +	/* vRTC's register address may not be page aligned */
> > +	set_fixmap_nocache(FIX_LNW_VRTC, rtc_paddr);
> 
> Why do we need a fixmap for that ? There is no need to setup RTC that
> early. The first call is from timekeeping_init() 

Actually when to init the vrtc register is a big problem for me, vrtc
need be inited before timekeeping_init(), and I thought better to put it
somewhere in setup_arch(), as it is architecture specific, and ioremap
is not working at that time. Also that's the reason I created a new
wallclock_init func for x86_platforms, I could not find a better way
to do the vrtc init.

> 
> Also this RTC init code should be in vrtc.c
I agree I should move this init code to vrtc.c, but still think it should
be called in the setup_arch() than in start_kernel()

> 
> > +
> > +static unsigned char __iomem *vrtc_virt_base;
> > +
> > +void vrtc_set_base(void __iomem *base)
> > +{
> > +	vrtc_virt_base = base;
> > +}
> > +
> > +unsigned char vrtc_cmos_read(unsigned char reg)
> > +{
> > +	unsigned char retval;
> > +
> > +	/* vRTC's registers range from 0x0 to 0xD */
> > +	if (reg > 0xd || !vrtc_virt_base)
> > +		return 0xff;
> > +
> > +	lock_cmos_prefix(reg);
> 
>   This lock_cmos magic should just die. I have no idea why something
>   wants or wanted to access the RTC from an NMI.

I will try to reuse the rtc_lock defined in rtc.c whose get/set_time
service won't be called with vrtc's at the same time.

> > +	/* vRTC YEAR reg contains the offset to 1960 */
> > +	year += 1960;
> > +
> > +	printk(KERN_INFO "vRTC: sec: %d min: %d hour: %d day: %d "
> > +		"mon: %d year: %d\n", sec, min, hour, mday, mon,
> > year);
> 
>   Please remove the debug noise

Will make it a pr_debug.

Thanks,
Feng
