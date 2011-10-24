Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1JXWVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:21:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36136 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1JXWVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:21:22 -0400
Date: Tue, 25 Oct 2011 00:21:13 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rajendra Nayak <rnayak@ti.com>, patches@linaro.org, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024222113.GG4394@ponder.secretlab.ca>
References: <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <20111024092411.GE8708@ponder.secretlab.ca>
 <20111024130429.GD1755@S2100-06.ap.freescale.net>
 <20111024130636.GB26033@opensource.wolfsonmicro.com>
 <20111024134025.GE1755@S2100-06.ap.freescale.net>
 <20111024135950.GV8708@ponder.secretlab.ca>
 <20111024145139.GH1755@S2100-06.ap.freescale.net>
 <20111024145631.GB8708@ponder.secretlab.ca>
 <20111024155132.GI1755@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024155132.GI1755@S2100-06.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:51:33PM +0800, Shawn Guo wrote:
> On Mon, Oct 24, 2011 at 04:56:31PM +0200, Grant Likely wrote:
> > On Mon, Oct 24, 2011 at 10:51:40PM +0800, Shawn Guo wrote:
> > > On Mon, Oct 24, 2011 at 03:59:50PM +0200, Grant Likely wrote:
> > > > On Mon, Oct 24, 2011 at 09:40:26PM +0800, Shawn Guo wrote:
> > > > > diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> > > > > index 8fe132d..29dcf90 100644
> > > > > --- a/drivers/regulator/core.c
> > > > > +++ b/drivers/regulator/core.c
> > > > > @@ -2673,7 +2673,8 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
> > > > >         BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);
> > > > > 
> > > > >         /* find device_node and attach it */
> > > > > -       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);
> > > > > +       rdev->dev.of_node = of_find_node_by_name(dev->parent->of_node,
> > > > > +                                                regulator_desc->name);
> > > > 
> > > > of_find_node_by_name() doesn't work that way.  The first argument is a
> > > > starting point, but it doesn't restrict the search to children of a
> > > > node.
> > > > 
> > > > for_each_child_of_node() is what you want to use when iterating over
> > > > the children which unfortunately changes the structure of this
> > > > function.
> > > > 
> > > The dev->parent->of_node is meant to point to node 'pmic: mc13892@0'.
> > > And the intention here is not to iterate over the children, but to
> > > start a search from a reasonable point rather than the top root node.
> > 
> > It is always better to attach the of_node at struct device
> > registration time instead of searching the tree in common code.  The
> > of_node should already be assigned by the time regulator_register() is
> > called.
> 
> That's the problem we have.  There is no 'struct dev' to attach of_node
> for each regulator by the time regulator_register() is called, because
> the 'struct dev' for each regulator is created inside
> regulator_register() as wrapped by 'struct regulator_dev'.

Then regulator_register must be split in half.  This is a common use
case, and other libraries have had to do the same.  One half to
allocate the structure, and then a second half for registration, and
regulator_register() becomes a simpler helper that calls both.  That
way a caller can insert extra initialization between the two steps.

g.

