Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1LTAZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:25:26 -0500
Received: from ozlabs.org ([203.10.76.45]:50576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab1LTAZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:25:20 -0500
Date: Tue, 20 Dec 2011 11:25:15 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>, aik@ozlabs.ru,
        benh@kernel.crashing.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com, rusty@rustcorp.com.au,
        iommu@lists.linux-foundation.org, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, joro@8bytes.org
Subject: Re: [RFC] Device isolation infrastructure v2
Message-ID: <20111220002515.GA5133@truffala.fritz.box>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>, aik@ozlabs.ru,
	benh@kernel.crashing.org, chrisw@redhat.com, agraf@suse.de,
	scottwood@freescale.com, B08248@freescale.com,
	rusty@rustcorp.com.au, iommu@lists.linux-foundation.org,
	qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
	joro@8bytes.org
References: <1323930340-24055-1-git-send-email-david@gibson.dropbear.id.au>
 <1323972307.2437.19.camel@x201.home>
 <20111216145353.GA29877@amd.com>
 <20111219001125.GA30390@truffala.fritz.box>
 <1324309598.2132.12.camel@shinybook.infradead.org>
 <20111219223120.GB5207@truffala.fritz.box>
 <1324335400.2132.47.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1324335400.2132.47.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 10:56:40PM +0000, David Woodhouse wrote:
> On Tue, 2011-12-20 at 09:31 +1100, David Gibson wrote:
> > When we're running paravirtualized under pHyp, it's impossible to
> > merge multiple PEs into one domain per se.  We could fake it rather
> > nastily by replicating all map/unmaps across mutiple PEs.  When
> > running bare metal, we could do so a bit more nicely by assigning
> > multiple PEs the same TCE pointer, but we have no mechanism to do so
> > at present. 
> 
> VT-d does share the page tables, as you could on bare metal. But it's an
> implementation detail — there's nothing *fundamentally* wrong with
> having to do the map/unmap for each PE, is there? It's only at VM setup
> time, so it doesn't really matter if it's slow.
> 
> Surely that's the only way you're going to present the guest with the
> illusion of having no IOMMU; so that DMA to any given guest physical
> address "just works".
> 
> On the other hand, perhaps you don't want to do that at all. Perhaps
> you're better off presenting a virtualised IOMMU to the guest and
> *insisting* that it fully uses it in order to do any DMA at all?

Not only do we want to, we more or less *have* to.  Existing kernels,
which are used to being paravirt under phyp expect and need a paravirt
iommu.  DMA without iommu setup just doesn't happen.  And the
map/unmap hypercalls are frequently a hot path, so slow does matter.

The other problem is that each domain's IOVA window is often fairly
small, a limitation that would get even worse if we try to put too
many devices in there.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
