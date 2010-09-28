Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab0I1PT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:19:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab0I1PT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:19:58 -0400
Date: Tue, 28 Sep 2010 11:19:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Robert Richter <robert.richter@amd.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
Message-ID: <20100928151924.GJ26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-7-git-send-email-ying.huang@intel.com>
 <20100927104426.GD32222@erda.amd.com>
 <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
 <20100927134341.GQ13563@erda.amd.com>
 <20100927151607.GX26290@redhat.com>
 <1285633705.20791.84.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285633705.20791.84.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 08:28:25AM +0800, Huang Ying wrote:
> Hi, Don,
> 
> On Mon, 2010-09-27 at 23:16 +0800, Don Zickus wrote:
> > On Mon, Sep 27, 2010 at 03:43:41PM +0200, Robert Richter wrote:
> > > On 27.09.10 08:56:44, huang ying wrote:
> > > 
> > > > >> -static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
> > > > >> -{
> > > > >> -     unsigned char reason = get_nmi_reason();
> > > > >> -     char buf[64];
> > > > >> -
> > > > >> -     sprintf(buf, "NMI received for unknown reason %02x\n", reason);
> > > > >> -     die_nmi(buf, regs, 1); /* Always panic here */
> > > > >> -     return 0;
> > > > >
> > > > > You are dropping this code that is different to panic().
> > > > 
> > > > What is the difference? Is it relevant?
> > > 
> > > I think yes, since the code behaves different. Otherwise we could
> > > remove die_nmi() completly and replace it by panic(). But both are
> > > different implementions. Maybe we can merge the code, but I didn't
> > > look at it closly.
> > 
> > Actually die_nmi is a wrapper around panic with two important pieces.
> > One, it dumps some registers and two it does another notifier call to
> > DIE_NMIWATCHDOG (which correlates to another discussion in this patch
> > series).
> > 
> > So if we do any consolidation between panic and die_nmi, it should be
> > convert to die_nmi.  But then I wonder if that breaks the original
> > semantics of 'panic_on_unrecovered_nmi'.  I don't think so though.
> 
> Please take a look at the original code:
> 
> 
>                 if (nmi_watchdog_tick(regs, reason))
>                         return;
>                 if (!do_nmi_callback(regs, cpu))
> #endif /* !CONFIG_LOCKUP_DETECTOR */
>                         unknown_nmi_error(reason, regs);
> #else
>                 unknown_nmi_error(reason, regs);
> #endif
> 
> If NMI comes from watchdog, nmi_watchdog_tick() will return 1. So
> do_nmi_callback() is NOT for watchdog NMI, but for unknown NMI. Why do
> we call DIE_NMIWATCHDOG for unknown NMI (NOT watchdog NMI)? die_nmi is
> for watchdog, not unknown NMI.

I think watchdog is an overloaded term.  I was under the impression that
once the nmi watchdog determined a problem, it called the DIE_NMIWATCHDOG
die chain to see if any other drivers wanted to clean up or do their thing
first before panic'ing (namely drivers in drivers/char/watchdog).

Cheers,
Don
