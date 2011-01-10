Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1AJXLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:11:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31847 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab1AJXLd (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 Jan 2011 18:11:33 -0500
Date: Mon, 10 Jan 2011 18:11:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy.Fitzhardinge@citrix.com
Subject: Re: [PATCH 05/12] xen: add m2p override mechanism
Message-ID: <20110110231121.GB16550@dumpdata.com>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
 <1294655801-16230-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294655801-16230-5-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:36:34AM +0000, stefano.stabellini@eu.citrix.com wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Add a simple hashtable based mechanism to override some portions of the
> m2p, so that we can find out the pfn corresponding to an mfn of a
> granted page. In fact entries corresponding to granted pages in the m2p
> hold the original pfn value of the page in the source domain that
> granted it.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/include/asm/xen/page.h |   16 ++++++-
>  arch/x86/xen/p2m.c              |   80 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 93 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
> index 8760cc6..50f0a0f 100644
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -42,6 +42,11 @@ extern unsigned int   machine_to_phys_order;
>  extern unsigned long get_phys_to_machine(unsigned long pfn);
>  extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
>  
> +extern void m2p_add_override(unsigned long mfn, struct page *page);
> +extern void m2p_remove_override(struct page *page);
> +extern struct page *m2p_find_override(unsigned long mfn);
> +extern unsigned long m2p_find_override_pfn(unsigned long mfn, unsigned long pfn);
> +
>  static inline unsigned long pfn_to_mfn(unsigned long pfn)
>  {
>  	unsigned long mfn;
> @@ -72,9 +77,6 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		return mfn;
>  
> -	if (unlikely((mfn >> machine_to_phys_order) != 0))
> -		return ~0;
> -
>  	pfn = 0;
>  	/*
>  	 * The array access can fail (e.g., device space beyond end of RAM).
> @@ -83,6 +85,14 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
>  	 */
>  	__get_user(pfn, &machine_to_phys_mapping[mfn]);
>  
> +	/*
> +	 * If this appears to be a foreign mfn (because the pfn
> +	 * doesn't map back to the mfn), then check the local override
> +	 * table to see if there's a better pfn to use.
> +	 */
> +	if (get_phys_to_machine(pfn) != mfn)

Any reason to not use 'pfn_to_mfn' call instead? If we do want
to use the get_hhys_to_machine wouldn't be easier to just
check for 'FOREIGN_FRAME_BIT' set? Or is just mostly a copy-n-paste
of mfn_to_local_pfn?

Asking this b/c with some of my changes this will be triggered on
identity mappings. The reason being that the IDENTITY_FRAME_BIT
is still set when using get_phys_to_machine. However on the 'pfn_to_mfn'
call, that is cleared (along with the FOREIGN_FRAME_BIT)...

