Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0K3FcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 00:32:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59882 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab0K3FcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 00:32:08 -0500
Date: Tue, 30 Nov 2010 06:32:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@amd64.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        john stultz <johnstul@us.ibm.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH -v1.1] HPET: Fix HPET readout for small deltas
Message-ID: <20101130053201.GA19176@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@amd64.org>,
	"a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
	john stultz <johnstul@us.ibm.com>,
	"Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>,
	"heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"avi@redhat.com" <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	"hpa@linux.intel.com" <hpa@linux.intel.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>
References: <20101129155254.GC1170@aftab>
 <alpine.LFD.2.00.1011292322080.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011292322080.2900@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 11:36:05PM +0100, Thomas Gleixner wrote:
> On Mon, 29 Nov 2010, Borislav Petkov wrote:
> >  
> > +	/* Accept only sensible values written by BIOS */
> > +	if (hpet_tbl->minimum_tick < hpet_min_tick)
> > +		hpet_min_tick = hpet_tbl->minimum_tick;
> 
> I ran this through everything I could get hold of. And as I feared
> when ACPI was mentioned in the first place, I found at least three
> machines which have hpet_tbl->minimum_tick < 4. Two of those failed to
> boot.

Damn, that's just f*cked up.

> This is all doomed to fail. 
> 
> 1) ACPI's trustworthiness aproaches ZERO
> 
> 2) The chipset manufactures who implement the "HPET spec" are even
>    worse. They could tell us the exact number of cycles which are
>    necessary to make these "specificatin compliant" trainwrecks
>    functional, but all we get is a reference to #1.

... and also, there's the notion of different HPET implementations from
the different chipset vendors hiding under the compliancy blanket. I
could venture a wild guess which shouldn't be far from the truth that
the "exact number of cycles" is different for each implementation.

> Crap. If you don't come up with some real facts,

Sorry, this is all I got ;-( - I'm sure you can imagine why...

> I'm simply going to commit
> 
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index ae03cab..0388a70 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -408,7 +408,7 @@ static int hpet_next_event(unsigned long delta,
>  	 */
>  	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
>  
> -	return res < 8 ? -ETIME : 0;
> +	return res < 128 ? -ETIME : 0;
>  }
>  
>  static void hpet_legacy_set_mode(enum clock_event_mode mode,
> 
> along with the corresponding fix for the min_delta_ns value.

I'm afraid this is our only option right now.

-- 
Regards/Gruss,
    Boris.
