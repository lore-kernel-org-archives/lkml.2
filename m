Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0ERHi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 03:38:59 -0400
Received: from www.tglx.de ([62.245.132.106]:50553 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab0ERHi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 03:38:57 -0400
Date: Tue, 18 May 2010 09:38:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 7/8] x86/mrst: add vrtc driver which serves as a wall
 clock device
In-Reply-To: <20100518142719.50ff74fa@feng-i7>
Message-ID: <alpine.LFD.2.00.1005180936480.3368@localhost.localdomain>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com> <1273254108-3234-8-git-send-email-jacob.jun.pan@linux.intel.com> <alpine.LFD.2.00.1005111643380.3401@localhost.localdomain> <20100512103422.1d59cc85@feng-i7>
 <alpine.LFD.2.00.1005171102590.3368@localhost.localdomain> <20100518142719.50ff74fa@feng-i7>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 May 2010, Feng Tang wrote:
> Hi Thomas,
> 
> 
> On Mon, 17 May 2010 17:15:55 +0800
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> 
> > > 
> > > Actually when to init the vrtc register is a big problem for me,
> > > vrtc need be inited before timekeeping_init(), and I thought better
> > > to put it somewhere in setup_arch(), as it is architecture
> > > specific, and ioremap is not working at that time. Also that's the
> > > reason I created a new wallclock_init func for x86_platforms, I
> > > could not find a better way to do the vrtc init.
> > 
> > There is no particular reason why we need to read it in
> > timekeeping_init(). Nothing in the kernel needs the correct wall time
> > at that point. So we can safely move the setting of xtime to rtc wall
> > clock time to a separate timekeeping_late_init() function.
> > 
> > John ???
> >  
> Yeah, good suggestion, if xtime init is moved to a later time in kernel
> init flow, then vrtc's init function can be set a arch_initcall()

John was away yesterday, so we have to wait for his answer, but I don't
expect a nono from him.
 
> > > > > +	lock_cmos_prefix(reg);
> > > > 
> > > >   This lock_cmos magic should just die. I have no idea why
> > > > something wants or wanted to access the RTC from an NMI.
> > > 
> > > I will try to reuse the rtc_lock defined in rtc.c whose get/set_time
> > > service won't be called with vrtc's at the same time.
> > 
> > Please don't create artifical dependencies. Use a separate vrtc_lock
> > to serialize the access to vrtc.
> I just checked the code, when wall clock's get/set_time service is called,
> it is always protected by rtc_lock(code in arch/x86/kernel/rtc.c), then
> no need to add the lock for each individual register read/write operation.

Grr. Yes, missed that the code is called under rtc_lock already. So
you can drop the locking in your code completely.

Thanks,

	tglx
