Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0EQJQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:16:32 -0400
Received: from www.tglx.de ([62.245.132.106]:37417 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab0EQJQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:16:30 -0400
Date: Mon, 17 May 2010 11:15:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
In-Reply-To: <20100512103422.1d59cc85@feng-i7>
Message-ID: <alpine.LFD.2.00.1005171102590.3368@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com> <alpine.LFD.2.00.1005111643380.3401@localhost.localdomain> <20100512103422.1d59cc85@feng-i7>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng,

[ Cc'ed John ]

On Wed, 12 May 2010, Feng Tang wrote:
> > >  void __init mrst_rtc_init(void)
> > >  {
> > > +	unsigned long rtc_paddr;
> > > +	void __iomem *virt_base;
> > > +
> > >  	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
> > > +	if (!sfi_mrtc_num)
> > > +		return;
> > > +
> > > +	rtc_paddr = sfi_mrtc_array[0].phys_addr;
> > > +
> > > +	/* vRTC's register address may not be page aligned */
> > > +	set_fixmap_nocache(FIX_LNW_VRTC, rtc_paddr);
> > 
> > Why do we need a fixmap for that ? There is no need to setup RTC that
> > early. The first call is from timekeeping_init() 
> 
> Actually when to init the vrtc register is a big problem for me, vrtc
> need be inited before timekeeping_init(), and I thought better to put it
> somewhere in setup_arch(), as it is architecture specific, and ioremap
> is not working at that time. Also that's the reason I created a new
> wallclock_init func for x86_platforms, I could not find a better way
> to do the vrtc init.

There is no particular reason why we need to read it in
timekeeping_init(). Nothing in the kernel needs the correct wall time
at that point. So we can safely move the setting of xtime to rtc wall
clock time to a separate timekeeping_late_init() function.

John ???
 
> > Also this RTC init code should be in vrtc.c
> I agree I should move this init code to vrtc.c, but still think it should
> be called in the setup_arch() than in start_kernel()

I do not :)

> > > +	lock_cmos_prefix(reg);
> > 
> >   This lock_cmos magic should just die. I have no idea why something
> >   wants or wanted to access the RTC from an NMI.
> 
> I will try to reuse the rtc_lock defined in rtc.c whose get/set_time
> service won't be called with vrtc's at the same time.

Please don't create artifical dependencies. Use a separate vrtc_lock
to serialize the access to vrtc.

Thanks,

	tglx
