Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab2DJUl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:41:57 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44528 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab2DJUl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:41:56 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irq/irq_domain: Quit ignoring error returns from irq_alloc_desc_from().
To: David Daney <ddaney.cavm@gmail.com>
Cc: David Daney <ddaney.cavm@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4F8314BE.9090708@gmail.com>
References: <1333669933-25267-1-git-send-email-ddaney.cavm@gmail.com> <20120407012616.62D133E17B2@localhost> <4F8314BE.9090708@gmail.com>
Date: Tue, 10 Apr 2012 14:41:53 -0600
Message-Id: <20120410204153.4B1CC3E0D65@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Apr 2012 09:56:30 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> On 04/06/2012 06:26 PM, Grant Likely wrote:
> > On Thu,  5 Apr 2012 16:52:13 -0700, David Daney<ddaney.cavm@gmail.com>  wrote:
> >> From: David Daney<david.daney@cavium.com>
> >>
> >> In commit 4bbdd45a (irq_domain/powerpc: eliminate irq_map; use
> >> irq_alloc_desc() instead) code was added that ignores error returns
> >> from irq_alloc_desc_from() by (silently) casting the return value to
> >> unsigned.  The negitive value error return now suddenly looks like a
> >> valid irq number.
> >>
> >> Commits cc79ca69 (irq_domain: Move irq_domain code from powerpc to
> >> kernel/irq) and 1bc04f2c (irq_domain: Add support for base irq and
> >> hwirq in legacy mappings) move this code to its current location in
> >> irqdomain.c
> >>
> >> The result of all of this is a null pointer dereference OOPS if one of
> >> the error cases is hit.
> >>
> >> The fix: Don't cast away the negativeness of the return value and then
> >> check for errors.
> >>
> >> Signed-off-by: David Daney<david.daney@cavium.com>
> >> ---
> >>   kernel/irq/irqdomain.c |   11 ++++++-----
> >>   1 files changed, 6 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> >> index af48e59..9d3e3ae 100644
> >> --- a/kernel/irq/irqdomain.c
> >> +++ b/kernel/irq/irqdomain.c
> >> @@ -351,6 +351,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
> >>   				irq_hw_number_t hwirq)
> >>   {
> >>   	unsigned int virq, hint;
> >> +	int irq;
> >
> > Merged, but I've dropped the new variable in favour of making virq an
> > int.  Makes for a smaller diffstat.
> >
> 
> Thanks Grant,
> 
> I had thought about that too, but since virq throughout all the rest of 
> the code is unsigned, I didn't want to introduce an inconsistency.
> 
> After a little more thought, I think that the domain of virq and the irq 
> used by the rest of the kernel are the same, so it might make sense to 
> change virq to be int universally, and use the kernel convention that 
> negative numbers indicate error conditions.  But that would be a much 
> larger patch.

... touching pretty much *every* driver in the kernel!  Blech!

Yeah, that's not going to happen.  As a rule, irq numbers are always
unsigned, but there are a few apis that can return either '0' meaning
no irq, or a negative value indicating an error.  The irq_alloc_desc
apis unfortunately are one such case.

g.

