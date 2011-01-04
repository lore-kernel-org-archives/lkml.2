Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1ADQys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 11:54:48 -0500
Received: from smtp.citrix.com ([66.165.176.89]:15697 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab1ADQyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 11:54:47 -0500
X-IronPort-AV: E=Sophos;i="4.60,273,1291611600"; 
   d="scan'208";a="11774179"
Subject: Re: [PATCH 2/8] xen/mmu: Add the notion of identity (1-1) mapping.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Jan Beulich" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <1293738517-7287-3-git-send-email-konrad.wilk@oracle.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
	 <1293738517-7287-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 4 Jan 2011 16:53:48 +0000
Message-ID: <1294160028.3831.563.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should patch 7/8 (add the IDENTITY_FRAME_BIT) be folded back into this
patch?

On Thu, 2010-12-30 at 19:48 +0000, Konrad Rzeszutek Wilk wrote:
> Our P2M tree structure is a three-level. On the leaf nodes
> we set the Machine Frame Number (MFN) of the PFN. What this means
> is that when one does: pfn_to_mfn(pfn), which is used when creating
> PTE entries, you get the real MFN of the hardware. When Xen sets
> up a guest it initially populates a array which has descending MFN
> values, as so:
> 
>  idx: 0,  1,       2
>  [0x290F, 0x290E, 0x290D, ..]
> 
> so pfn_to_mfn(2)==0x290D. If you start, restart many guests that list
> starts looking quite random.
> 
> We graft this structure on our P2M tree structure and stick in
> those MFN in the leafs. But for all other leaf entries, or for the top
> root, or middle one, for which there is a void entry, we assume it is
> "missing". So
>  pfn_to_mfn(0xc0000)=INVALID_P2M_ENTRY.
> 
> We add the possibility of setting 1-1 mappings on certain regions, so
> that:
>  pfn_to_mfn(0xc0000)=0xc0000
> 
> The benefit of this is, that we can assume for non-RAM regions (think
> PCI BARs, or ACPI spaces), we can create mappings easily b/c we
> get the PFN value to match the MFN.
> 
> For this to work efficiently we introduce are two new pages: p2m_identity
> and p2m_mid_identity.  All entries in p2m_identity are set to INVALID_P2M_ENTRY
> type,

This statement confused me at first. I think the piece of information
which is missing in the rest of the paragraph is that on lookup we spot
that the entry points to p2m_identity and return the identity value
instead of dereferencing and returning INVALID_P2M_ENTRY.

If the value is never actually (deliberately) completely dereferecned
then perhaps for sanity/debugging the page should contain some other
invalid/poison value so we can spot in stack traces etc cases where it
has been erroneously dereferenced? (e.g. 0xFFFFFFFE?) Or does that
confuse the tools/migration or something similar?

> @@ -410,6 +418,17 @@ unsigned long get_phys_to_machine(unsigned long pfn)
>  	mididx = p2m_mid_index(pfn);
>  	idx = p2m_index(pfn);
>  
> +	/*
> +	 * The INVALID_P2M_ENTRY is filled in both p2m_*identity
> +	 * and in p2m_*missing, so returning the INVALID_P2M_ENTRY
> +	 * would be wrong.
> +	 */
> +	if (p2m_top[topidx] == p2m_mid_identity)
> +		return pfn;
> +
> +	if (p2m_top[topidx][mididx] == p2m_identity)
> +		return pfn;
> +

If p2m_top[topidx] == p2m_mid_identity the also p2m_top[topidx][mididx]
== p2m_identity. Therefore I'm not sure if the first check is worthwhile
or not.

> @@ -517,6 +542,26 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>  	mididx = p2m_mid_index(pfn);
>  	idx = p2m_index(pfn);
>  
> +	/* For sparse holes were the p2m leaf has real PFN along with
> +	 * PCI holes, stick in the PFN as the MFN value.
> +	 */
> +	if (pfn == mfn) {
> +		if (p2m_top[topidx] == p2m_mid_identity)
> +			return 1;
> +		if (p2m_top[topidx][mididx] == p2m_identity)
> +			return 1;

Should be "return true" throughout for a function returning bool. I
think it can also be simplified as per my comment above.

> +		/* Swap over from MISSING to IDENTITY if needed. */
> +		if (p2m_top[topidx] == p2m_mid_missing) {
> +			p2m_top[topidx] = p2m_mid_identity;
> +			return 1;
> +		}
> +		if (p2m_top[topidx][mididx] == p2m_missing) {
> +			p2m_top[topidx][mididx] = p2m_identity;
> +			return 1;
> +		}

I don't think I quite understand this bit.

If I do "__set_phys_to_machine(X, X)" where X happens to currently
correspond to p2m_mid_missing won't that cause all pfn entries in the
range covered by p2m_top[topidx] (i.e. quite a few, like 512^2 pages or
something) to switch from missing to identity? Similarly for
p2m_top[topidx][mididx]?

Perhaps ranges of identity bits are often well aligned with the
boundaries in the p2m 3-level tree but wouldn't that just be
coincidence?

Don't we need to completely populate the tree at this point and setup
the leaf nodes as appropriate? Which we can't do since this is
__set_phys_to_machine so we need to fail and let set_phys_to_machine to
its thing? Or maybe this hole bit needs to be hoisted up to
set_phys_to_machine?

Ian.

> +	}
> +
>  	if (p2m_top[topidx][mididx] == p2m_missing)
>  		return mfn == INVALID_P2M_ENTRY;
>  


