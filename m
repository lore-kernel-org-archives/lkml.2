Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2ARVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:25:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48736 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2ARVZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:25:57 -0500
Date: Wed, 18 Jan 2012 14:25:55 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Milton Miller <miltonm@bga.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 06/14] irq_domain/powerpc: Eliminate virq_is_host()
Message-ID: <20120118212555.GO4223@ponder.secretlab.ca>
References: <1326313337-24603-7-git-send-email-grant.likely@secretlab.ca>
 <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
 <keep-irq-is-domain@mdm.bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <keep-irq-is-domain@mdm.bga.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more thoughts...

On Thu, Jan 12, 2012 at 04:17:58AM -0600, Milton Miller wrote:
> On Wed Jan 11 2012 about 15:24:34 EST, Grant Likely wrote:
> > There is only one user, and it is trivial to open-code.
> 
> I added virq_is_host because I had planned to change how we find the
> host (domain) from a virq.
> 
> Instead of storing a pointer in irq_desc (a pointer for every irq),
> I planned to use a NR_IRQ(+extra) bitmap per domain.  This should be
> a win storage-wise when the number of irq controllers is less than the
> number of bits in a long.
> 
> This would also convert scanning for a reverse map from walking every
> irqdesc to walking find_next_bit over the irqs assigned to the host.

>From my reading of the code, this should no long be a concern for
anything except the radix revmap.  Only the radix revmap has the song
and dance about deferring allocation of the revmap.  The linear map in
immediately allocated and should always be available for mapping.

The only exception I could imagine is a linear hwirq mapping for a
hwirq number higher than the size of the revmap, but I don't think
that the code supports.  As you mention below, it should be possible
to remove the fallback to linear search entirely.

> Thus my rule was "code outside kernel/irq must not touch domain";
> both the contents and how it was associated were abstracted.

Good rule.  I'll consider this.

> Other planned changes included splitting the reverse lookup into
> domain dependent pieces, creating the ida for sparse map at domain
> creation time (init irq is after radix_tree_init as its used by the
> current irq code) so we never fall back to linear search.  Linear
> populated the reverse map as the irq was assigned, and changed to
> a seperate subtype if it mapped an irq above the map size.

I don't think it's worthwhile to handle corner cases like irq above
the map size in the linear map.  If that actually happens, then the
driver should probably switch to the tree revmap.

> 
> I thought some of the domains would be split into seperate files
> selected by Kconfig, at least the sparse tree.

I might do that, we'll see how the file looks when I'm done.

g.
