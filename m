Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143Ab0J2RBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 13:01:30 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:33613 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab0J2RB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 13:01:28 -0400
Date: Fri, 29 Oct 2010 19:00:40 +0200
From: Borislav Petkov <bp@amd64.org>
To: Thomas Gleixner <tglx@linutronix.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@alien8.de>, john stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101029170040.GJ21125@aftab>
References: <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <1288120736.2645.9.camel@localhost>
 <20101027142622.GA1555@arch.trippelsdorf.de>
 <20101027182608.GA1580@arch.trippelsdorf.de>
 <20101029081831.GA7149@liondog.tnic>
 <20101029083013.GA1553@arch.trippelsdorf.de>
 <20101029102713.GA21125@aftab>
 <alpine.LFD.2.00.1010291411150.2692@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010291411150.2692@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 08:14:12AM -0400, Thomas Gleixner wrote:
> On Fri, 29 Oct 2010, Borislav Petkov wrote:
> > On Fri, Oct 29, 2010 at 04:30:13AM -0400, Markus Trippelsdorf wrote:
> > That's strange, when we tested this one everything seemed fine so I
> > guess this is one of those bugs which appear later, just as if out of
> > nowhere.
> > 
> > Thomas, could it be that SMI fires in between the HPET write and
> > subsequent read:
> > 
> > 	hpet_writel(cnt, HPET_Tn_CMP(timer));
> > 
> > 	...
> > 
> > 	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
> > 
> > causing the -ETIME and thus a wait for HPET wraparound? My machine at
> > least does SMI-initiated C1E so it could very well be the problem.
> 
> Well, even if a SMI fires, then the counter will be ahead of cnt and
> we get -ETIME. The upper layer of clockevents/timers will then
> reprogram HPET. So that's not an issue.

Ah, I missed the upper layer, good.

> The only problem which might hit us is when our assumption of 8 HPET
> cycles being enough to transfer the new match value into the real
> match register is wrong.

So Markus, can you try with 995bd3bb5c78, but by increasing the value
to, say 16 (I don't know what's a good value here, let's double the old
one). Simply change the line

	return res < 8 ? -ETIME : 0;

to

	return res < 16 ? -ETIME : 0;


in <arch/x86/kernel/hpet.c:hpet_next_event()>. I'll do that too on the
machine here when I get around to it.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
