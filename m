Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2G3SD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 14:03:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44801 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563Ab2G3SDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 14:03:55 -0400
Date: Mon, 30 Jul 2012 19:03:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] mfd: arizona: convert to regmap_add_irq_chips
Message-ID: <20120730180352.GR4468@opensource.wolfsonmicro.com>
References: <1343415776-27176-1-git-send-email-swarren@wwwdotorg.org>
 <20120729203854.GF4384@opensource.wolfsonmicro.com>
 <5016BEC4.5000600@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5016BEC4.5000600@wwwdotorg.org>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 11:05:08AM -0600, Stephen Warren wrote:
> On 07/29/2012 02:38 PM, Mark Brown wrote:
> > On Fri, Jul 27, 2012 at 01:02:56PM -0600, Stephen Warren wrote:

> >> 1) regmap_add_irq_chips() calls regmap_add_irq_chip() with irq==0 rather
> >>    than -1, so in turn irq_domain_add_linear() is called rather than
> >>    irq_domain_add_legacy(). This change could be avoided by providing an
> >>    irq_bases array to regmap_add_irq_chips().

> > This is a problem.

> OK, can you explain why? Is the problem the difference between the two
> types of IRQ domain? I would have assumed this was an internal detail of
> the driver hence not an issue. I assume there's no issue with
> known/static IRQ numbers, since both 0 and -1 end up dynamically
> allocating the IRQ bases IIRC.

We have GPIOs we might want to do interrupts on, if the API doesn't
support providing a base we've got an issue.

> >> 2) regmap_add_irq_chips() requests the top-level interrupt itself, so this
> >>    happens before the Arizona driver hooks the child BOOT_DONE and
> >>    CTRLIF_ERR interrupts. In the original, all the IRQ chips were created
> >>    first, and then the top-level IRQ was requested. This may cause a
> >>    functional difference if those interrupts are pending at probe() time.

> > Boot done is very likely to be asserted.

> Hmmm. Perhaps that means regmap_add_irq_chips() should be split into two
> parts; one to create all the IRQ chips and hook everything together, and
> the second to actually enable the interrupt.

That's what the existing arizona code does, it only requests the primary
IRQ line once it's completed setup.
