Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2ALKHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 05:07:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64353 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2ALKHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 05:07:04 -0500
Date: Thu, 12 Jan 2012 10:07:02 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
Message-ID: <20120112100702.GM3226@page>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
 <20120110213338.GD3226@page>
 <CACxGe6vqb8AZcZb5WMvfmLsUZH7=SEtBrJCSfsFmDYpKX42MzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6vqb8AZcZb5WMvfmLsUZH7=SEtBrJCSfsFmDYpKX42MzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 09:46:58PM -0700, Grant Likely wrote:
> On Tue, Jan 10, 2012 at 2:33 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> > On Mon, Dec 12, 2011 at 03:02:04PM -0700, Grant Likely wrote:
> >> +- clock-output-names : From common clock binding
> >> +
> >> +Example:
> >> +     clock {
> >> +             compatible = "fixed-clock";
> >> +             #clock-cells = <0>;
> >> +             clock-frequency = <1000000000>;
> >> +     };
> >
> > I wonder if this should have an optional clock consumer with a standard
> > name for parenting?  For example, on picoxcell there is a fixed 200MHz
> > APB clock that is really a PLL from a 20MHz reference input and I'd like
> > to represent that in the clock tree.
> 
> If it depends on a parent clock, then it really isn't a fixed clock,
> is it (from the perspective of the OS).  The point of this binding is
> a trivial way to describe clocks that don't change.  If that
> assumption doesn't hold true, then this binding isn't suitable for
> that clock.  As you point out, even the gpio enable feature is pushing
> things a bit.
> 
> That said, I'm open to extending this binding if something can be
> defined that will have a lot of use cases.

Well for picoxcell where the 200MHz APB clock is just a PLL generated 
from a 20MHz clock then it kind of is a fixed clock as far as Linux is 
concerned isn't it?  The rate can't be changed and and the clock can't 
be disabled so it's just a dumb clock with a parent.

I guess I could just omit the parent as far as Linux is concerned, but 
it would be nice to represent the real clock tree if possible.

> > I'm about to start trying to get this and Mike's common struct clk
> > patches working on picoxcell, and the one thing I'm not understanding at
> > the moment is how to handle the tree itself.  Currently I was planning
> > on iterating over all clocks and finding a named input clock "ref" or
> > "input" perhaps.  This would be fine for picoxcell, but I guess more
> > complicated chips may need something else.
> 
> It might be useful to have something like of_irq_init() for setting up
> initial clocks, but the solution feels inelegant to me.  I suspect
> that there will be end up being intertwined init order dependencies
> between clocks and irqs and other early setup stuff that could be
> handled better.  Again, I need to think about this some more.  There
> might need to be something like an of_early_probe() call that accepts
> a match table of compatible values and setup functions with some logic
> or data to resolve dependencies.  The trick will be to not end up with
> something complex.  I'll need to think about this more...

Yes, probably not an easy problem to solve, especially for the platforms 
where the parent can change at runtime.

I wonder if an of_clk_init() could take a platform callback, so that 
of_clk_init() goes of and creates a struct clk for each clk in the DT, 
then for each registered clock calls a platform specific callback which 
returns the parent (if any).  It feels like a fairly platform specific 
problem to me.

Jamie
