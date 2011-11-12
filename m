Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1KLAp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:45:27 -0500
Received: from sous-sol.org ([216.99.217.87]:42913 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754197Ab1KLAp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:45:26 -0500
X-Greylist: delayed 1682 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Nov 2011 19:45:25 EST
Date: Fri, 11 Nov 2011 16:45:13 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, chrisw@sous-sol.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains
 unattached to iommus
Message-ID: <20111112004513.GP14486@sequoia.sous-sol.org>
References: <20111111224849.9756.13368.stgit@bling.home>
 <1321058267.2006.21.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1321058267.2006.21.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> On Fri, 2011-11-11 at 15:49 -0700, Alex Williamson wrote:
> > To fix this, switch domain_update_iommu_coherency() to use the
> > safer, non-coherent default for domains not attached to iommus. 
> 
> That isn't a fix for the problem you described.
> 
> The problem is that changing a domain from coherent to non-coherent is
> *broken*. It probably needs to flush the cache for the *entire* set of
> page tables — not just the new context entry it adds.

For a guest domain, the page tables aren't actually changing.
And for the snoop mode change, we remap the pages.

> You might have removed the *common* case where we trigger that bug, but
> it certainly isn't a fix.
> 
> However, I'd be receptive to an argument that the situation you describe
> is in fact the *only* time we'd have to switch from coherent to
> non-coherent at run time, because the coherency is an all-or-nothing
> characteristic of the chipset. Either all the IOMMUs are coherent, or
> none of them, right? This brain-damage only affects the first chipsets
> from before we worked out that cache incoherency was a *really* f*cking
> stupid idea, doesn't it?

Dunno if it exists going forward (I've stopped being surprised by the
brain damage in this area ;), but those machines are still out there.

> So if you were to ditch the whole idea of a per-domain runtime update,
> and instead calculate a global value for 'iommu_coherency' at boot time,
> by iterating over for_each_active_iommu()¹, I think that would be a
> better way to deal with the issue. And you *could* really call that a
> 'fix'.
> 
> Make sense?

Ideally, yes.  Not sure we can practically do it though.  Would have to
be sure we force incoherent access mode for the busted hw.

thanks,
-chris
