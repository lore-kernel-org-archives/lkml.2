Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0H0Qt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:49:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40087 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891Ab0H0QtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:49:24 -0400
Subject: Re: [PATCH 03/24] arm: mm: add proc info for ScorpionMP
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
In-Reply-To: <1282926826.5075.21.camel@m0nster>
References: <1282926826.5075.21.camel@m0nster>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 27 Aug 2010 17:49:06 +0100
Message-ID: <1282927746.26355.74.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2010 16:49:06.0810 (UTC) FILETIME=[C37485A0:01CB4607]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 17:33 +0100, Daniel Walker wrote:
> On Fri, 2010-08-27 at 17:04 +0100, Catalin Marinas wrote:
> > On Fri, 2010-08-27 at 16:29 +0100, Daniel Walker wrote:
> > > On Fri, 2010-08-27 at 14:54 +0100, Catalin Marinas wrote:
> > > > On Wed, 2010-08-25 at 05:57 +0100, Jeff Ohlstein wrote:
> > > > > From: Daniel Walker <dwalker@codeaurora.org>
> > > > >
> > > > > ScorpionMP does not have the SMP/nAMP and TLB ops broadcasting bits in
> > > > > ACTLR.
> > > > >
> > > > > Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
> > > > > Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
> > > > > ---
> > > > >  arch/arm/mm/proc-v7.S |   24 ++++++++++++++++++++++++
> > > > >  1 files changed, 24 insertions(+), 0 deletions(-)
> > > > >
> > > > > diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
> > > > > index 7aaf88a..98fd7e5 100644
> > > > > --- a/arch/arm/mm/proc-v7.S
> > > > > +++ b/arch/arm/mm/proc-v7.S
> > > > > @@ -196,6 +196,7 @@ __v7_setup:
> > > > >         orreq   r0, r0, #(1 << 6) | (1 << 0)    @ Enable SMP/nAMP mode and
> > > > >         mcreq   p15, 0, r0, c1, c0, 1           @ TLB ops broadcasting
> > > > >  #endif
> > > > > +__v7_msm_setup:
> > > > >         adr     r12, __v7_setup_stack           @ the local stack
> > > > >         stmia   r12, {r0-r5, r7, r9, r11, lr}
> > > > >         bl      v7_flush_dcache_all
> > > >
> > > > It may be better to move the generic __v7_setup here and have a specific
> > > > entry for ARM Ltd cores (mask 0xff0f0000 and value 0x410f0000).
> > >
> > > I'm not sure I follow you.. Are you saying there are other cpu's that
> > > don't need the SMP stuff at the top of __v7_setup ?
> >
> > The SMP/nAMP bit is something specific to the ARM11MPCore and Cortex-A9
> > processors produced by ARM. If you core doesn't need this, it should use
> > a default __v7_setup without any additional bits being set.
> >
> > I'm not aware of other MP ARM processors produced by other companies
> > that would require exactly the same bit being set.
> 
> So your saying it makes more sense to change the msm entry into the
> default entry, and make the current default into the
> ARM11MPCore/Cortex-A9 entry?

So my opinion is to not add any specific msm code but make the
__v7_setup skip the ACTLR bit setting. Then add an entry for Cortex-A9
to set those bits.

> There's 4 or 5 other cpu's that have SMP but none have had to jump over
> those bits AFAIK ..

Maybe they don't do anything with those bits and writing to them is
harmless. They'll complain if their code stops working but it is usually
unlikely that people implementing their own v7MP would use the same bits
in ACTLR as Cortex-A9.

I'm not sure whether someone licensing and manufacturing a Cortex-A9
would use the same manufacturer id (TI folks would know better). If not
we could check against 0x000fc090.

-- 
Catalin

