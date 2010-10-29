Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761270Ab0J2K17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 06:27:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35592 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760951Ab0J2K15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 06:27:57 -0400
Date: Fri, 29 Oct 2010 12:27:13 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@alien8.de>, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101029102713.GA21125@aftab>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <1288120736.2645.9.camel@localhost>
 <20101027142622.GA1555@arch.trippelsdorf.de>
 <20101027182608.GA1580@arch.trippelsdorf.de>
 <20101029081831.GA7149@liondog.tnic>
 <20101029083013.GA1553@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029083013.GA1553@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 04:30:13AM -0400, Markus Trippelsdorf wrote:
> > Well, what do you know, the temporary "slowdown" triggered on my setup
> > too. After waiting a minute maybe, the machine recovered and guess what
> > appeared in dmesg:
> > 
> > [44729.650859] Clocksource tsc unstable (delta = -8615263009 ns)
> > [44729.656229] Switching to clocksource hpet
> > 
> > I've reverted the changeset above and will run without it to check
> > whether it makes any difference.
> 
> After further testing I've found out that the tsc- and the kvm-issue are
> unrelated. IOW I get these "slowdowns" even with 34f971f6f7988be4
> reverted.

hmm, I'll run with 34f971f6f798 reverted for a while just to confirm
your observations...

> I guess John was right when he wrote:
> > From your dmesg, I'd guess the hpet is the watchdog clocksource, so I
> > be on the lookout for hpet related changes.
> >
> > Maybe does reverting 995bd3bb5c78f3ff71339803c0b8337ed36d64fb hide the
> > issue?  
> 
> Because with 995bd3bb5c78f reverted I never had a single "slowdown" here.

That's strange, when we tested this one everything seemed fine so I
guess this is one of those bugs which appear later, just as if out of
nowhere.

Thomas, could it be that SMI fires in between the HPET write and
subsequent read:

	hpet_writel(cnt, HPET_Tn_CMP(timer));

	...

	res = (s32)(cnt - hpet_readl(HPET_COUNTER));

causing the -ETIME and thus a wait for HPET wraparound? My machine at
least does SMI-initiated C1E so it could very well be the problem.

Markus, can you verify this on your system by compiling x86info from
git://git.choralone.org/git/x86info and doing

./lsmsr Int

as root?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
