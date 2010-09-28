Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760214Ab0I1A23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:28:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:40105 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab0I1A22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:28:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,244,1283756400"; 
   d="scan'208";a="329395304"
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100927151607.GX26290@redhat.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
	 <1285549026-5008-7-git-send-email-ying.huang@intel.com>
	 <20100927104426.GD32222@erda.amd.com>
	 <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
	 <20100927134341.GQ13563@erda.amd.com>  <20100927151607.GX26290@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 08:28:25 +0800
Message-ID: <1285633705.20791.84.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Don,

On Mon, 2010-09-27 at 23:16 +0800, Don Zickus wrote:
> On Mon, Sep 27, 2010 at 03:43:41PM +0200, Robert Richter wrote:
> > On 27.09.10 08:56:44, huang ying wrote:
> > 
> > > >> -static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
> > > >> -{
> > > >> -     unsigned char reason = get_nmi_reason();
> > > >> -     char buf[64];
> > > >> -
> > > >> -     sprintf(buf, "NMI received for unknown reason %02x\n", reason);
> > > >> -     die_nmi(buf, regs, 1); /* Always panic here */
> > > >> -     return 0;
> > > >
> > > > You are dropping this code that is different to panic().
> > > 
> > > What is the difference? Is it relevant?
> > 
> > I think yes, since the code behaves different. Otherwise we could
> > remove die_nmi() completly and replace it by panic(). But both are
> > different implementions. Maybe we can merge the code, but I didn't
> > look at it closly.
> 
> Actually die_nmi is a wrapper around panic with two important pieces.
> One, it dumps some registers and two it does another notifier call to
> DIE_NMIWATCHDOG (which correlates to another discussion in this patch
> series).
> 
> So if we do any consolidation between panic and die_nmi, it should be
> convert to die_nmi.  But then I wonder if that breaks the original
> semantics of 'panic_on_unrecovered_nmi'.  I don't think so though.

Please take a look at the original code:


                if (nmi_watchdog_tick(regs, reason))
                        return;
                if (!do_nmi_callback(regs, cpu))
#endif /* !CONFIG_LOCKUP_DETECTOR */
                        unknown_nmi_error(reason, regs);
#else
                unknown_nmi_error(reason, regs);
#endif

If NMI comes from watchdog, nmi_watchdog_tick() will return 1. So
do_nmi_callback() is NOT for watchdog NMI, but for unknown NMI. Why do
we call DIE_NMIWATCHDOG for unknown NMI (NOT watchdog NMI)? die_nmi is
for watchdog, not unknown NMI.

So another issue is registers dumping. If it is necessary, we can dump
registers in unknown_nmi_error(). Although I think unknown NMI comes
from hardware instead of software, so it does not help much to dump
registers.

Best Regards,
Huang Ying


