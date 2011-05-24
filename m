Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab1EXSQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:16:15 -0400
Received: from mail.hsia.com.cn ([61.152.154.60]:49743 "EHLO hsia.com.cn"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab1EXSQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:16:14 -0400
X-Greylist: delayed 3194 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 May 2011 14:16:07 EDT
Date: Wed, 25 May 2011 01:22:31 +0800
From: Richard Zhao <linuxzsc@hsia.com.cn>
To: Colin Cross <ccross@google.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 0/4] Add a generic struct clk
Message-ID: <20110524172231.GA2764@b20223-02.ap.freescale.net>
References: <1305876469.325655.313573683829.0.gpush@pororo>
 <1305876469.325655.313573683829.0.gpush@pororo>
 <BANLkTik=EFayZW61TgfOni-XML+tRLOcqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik=EFayZW61TgfOni-XML+tRLOcqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Reply-To: <richard@b20223-02.ap.freescale.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 04:12:24PM -0700, Colin Cross wrote:
> On Fri, May 20, 2011 at 12:27 AM, Jeremy Kerr <jeremy.kerr@canonical.com> wrote:
> > [This series was originally titled 'Add a common struct clk', but
> > the goals have changed since that first set of patches. We're now aiming
> > for a more complete generic clock infrastructure, rather than just
> > abstracting struct clk]
> >
> > [This series still needs work, see the TODO section below]
> >
> > [Totally RFC at the moment]
> >
> > Hi all,
> >
> > These patches are an attempt to allow platforms to share clock code. At
> > present, the definitions of 'struct clk' are local to platform code,
> > which makes allocating and initialising cross-platform clock sources
> > difficult, and makes it impossible to compile a single image containing
> > support for two ARM platforms with different struct clks.
> >
> > The three patches are for the architecture-independent kernel code,
> > introducing the common clk infrastructure. The changelog for the first
> > patch includes details about the new clock definitions.
> >
> > The second patch implements clk_set_rate, and in doing so adds
> > functionality to walk the clock tree in both directions.
> >
> > clk_set_parent is left unimplemented, see TODO below for why.
> >
> > The third and fourth patches provide some basic clocks (fixed-rate and
> > gated), mostly to serve as an example of the hardware implementation.
> > I'm intending to later provide similar base clocks for mux and divider
> > hardware clocks.
> >
> > Many thanks to the following for their input:
> >  * Benjamin Herrenschmidt <benh@kernel.crashing.org>
> >  * Thomas Gleixner <tglx@linutronix.de>
> >  * Ben Dooks <ben-linux@fluff.org>
> >  * Baruch Siach <baruch@tkos.co.il>
> >  * Russell King <linux@arm.linux.org.uk>
> >  * Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> >  * Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
> >  * Vincent Guittot <vincent.guittot@linaro.org>
> >  * Sascha Hauer <s.hauer@pengutronix.de>
> >  * Ryan Mallon <ryan@bluewatersys.com>
> >  * Colin Cross <ccross@google.com>
> >  * Jassi Brar <jassisinghbrar@gmail.com>
> >  * Saravana Kannan <skannan@codeaurora.org>
> 
> I have a similar set of patches I was working on that handles a little
> more of the common code than these.  I can post them if you want, but
> for now I'll just point out where I had different ideas, and not muddy
> the waters with conflicting patches.
> 
> > TODO:
> >
> >  * Need to figure out the locking around clk_set_parent. Changing the in-kernel
> >   clock topology requires acquiring both the mutex (to prevent against races
> >   with clk_prepare, which may propagate to the parent clock) and the spinlock
> >   (to prevent the same race with clk_enable).
> >
> >   However, we should also be changing the hardware clock topology in sync with
> >   the in-kernel clock topology, which would imply that both locks *also* need
> >   to be held while updating the parent in the hardware (ie, in
> >   clk_hw_ops->set_parent) too.  However, I believe some platform clock
> >   implementations may require this callback to be able to sleep. Comments?
> 
> This sequence is the best I could come up with without adding a
> temporary 2nd parent:
> 1. lock prepare mutex
Maybe tell child clocks "I'm going to change clock rate, please stop work if needed"
> 2. call prepare on the new parent if prepare_count > 0
> 3. lock the enable spinlock
> 4. call enable on the new parent if enable_count > 0
> 5. change the parent pointer to the new parent
> 6. unlock the spinlock
> 7. call the set_parent callback
Why do it need to sleep if it only set some hw registers?
> 8. lock the enable spinlock
> 9. call disable on the old parent iff you called enable on the new
> parent (enable_count may have changed)
> 10. unlock the enable spinlock
> 11. call unprepare on the old parent if prepare_count
propagate rate here and also tell child clocks "rate changed already, change your
parameters and go on to work".
> 12. unlock prepare mutex
> 
> The only possible problem I see is that if a clock starts disabled at
> step 1., and clk_enable is called on it between steps 6 and 7,
> clk_enable will return having enabled the new parent, but the clock is
> still running off the old parent.  As soon as the clock gets switched
> to the new parent, the clock will be properly enabled.  I don't see
> this as a huge problem - calling clk_set_parent on a clock while it is
> enabled may not even work without causing glitches on some platforms.
some do be glitch free, especially for cpu clock parents.
> 
> I guess the only way around it would be to store a temporary
> "new_parent" pointer between steps 5 and 9, and have
> clk_enable/disable operate on both the current parent and the new
> parent.  They would also need to refcount the extra enables separately
> to undo on the old parent.
> 
> >  * tglx and I have been discussing different ways of passing clock information
> >   to the clock hardware implementation. I'm proposing providing a base 'struct
> >   clk_hw', which implementations subclass by wrapping in their own structure
> >   (or one of a set of simple 'library' structures, like clk_hw_mux or
> >   clk_hw_gate).  The clk_hw base is passed as the first argument to all
> >   clk_hw_ops callbacks.
> >
> >   tglx's plan is to create a separate struct clk_hwdata, which contains a
> >   union of base data structures for common clocks: div, mux, gate, etc. The
> >   ops callbacks are passed a clk_hw, plus a clk_hwdata, and most of the base
> >   hwdata fields are handled within the core clock code. This means less
> >   encapsulation of clock implementation logic, but more coverage of
> >   clock basics through the core code.
> 
> I don't think they should be a union, I think there should be 3
> separate private datas, and three sets of clock ops, for the three
> different types of clock blocks: rate changers (dividers and plls),
> muxes, and gates.  These blocks are very often combined - a device
> clock often has a mux and a divider, and clk_set_parent and
> clk_set_rate on the same struct clk both need to work.
> 
> >   tglx, could you send some details about your approach? I'm aiming to refine
> >   this series with the good bits from each technique.
> >
> >  * The clock registration code probably needs work. This is the domain
> >   of the platform/board maintainers, any wishes here?
When clock init, data in struct clk may not be synced with hw registers. After
enabled minimal needed clk (cpu, core bus etc), we need sync the whole tree,
disable zero enable_count clocks, set correct .rate ... . The sync function
is also common code, right? but not have to be called all times I think.

Thanks
Richard
> >
> > Cheers,
> >
> >
> > Jeremy
> >
> > --
> >
> > ---
> > Jeremy Kerr (4):
> >      clk: Add a generic clock infrastructure
> >      clk: Implement clk_set_rate
> >      clk: Add fixed-rate clock
> >      clk: Add simple gated clock
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
