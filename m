Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0LOXgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:36:40 -0500
Received: from claw.goop.org ([74.207.240.146]:42196 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0LOXgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:36:37 -0500
Message-ID: <4D095102.6010505@goop.org>
Date: Wed, 15 Dec 2010 15:36:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: stefano.stabellini@eu.citrix.com
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 08/11] xen p2m: transparently change the p2m
 mappings in the m2p override
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop> <1292420446-3348-8-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1292420446-3348-8-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 05:40 AM, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>
> In m2p_add_override store the original mfn into page->index and then
> change the p2m mapping, setting mfns as FOREIGN_FRAME.
>
> In m2p_remove_override restore the original mapping.
>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/xen/p2m.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 8db19d5..7dde8e4 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -407,8 +407,11 @@ static unsigned long mfn_hash(unsigned long mfn)
>  void m2p_add_override(unsigned long mfn, struct page *page)
>  {
>  	unsigned long flags;
> +	unsigned long pfn = page_to_pfn(page);
>  	page->private = mfn;
> +	page->index = pfn_to_mfn(pfn);

Is there any risk that a page being used for a granted mfn will end up
getting xen_create_contiguous_region() applied to it via the DMA API? 
That would be messy...

    J


>  
> +	__set_phys_to_machine(pfn, FOREIGN_FRAME(mfn));
>  	spin_lock_irqsave(&m2p_override_lock, flags);
>  	list_add(&page->lru,  &m2p_overrides[mfn_hash(mfn)]);
>  	spin_unlock_irqrestore(&m2p_override_lock, flags);
> @@ -420,6 +423,7 @@ void m2p_remove_override(struct page *page)
>  	spin_lock_irqsave(&m2p_override_lock, flags);
>  	list_del(&page->lru);
>  	spin_unlock_irqrestore(&m2p_override_lock, flags);
> +	__set_phys_to_machine(page_to_pfn(page), page->index);
>  }
>  
>  struct page *m2p_find_override(unsigned long mfn)

