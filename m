Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0CXVKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:10:20 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:51814 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab0CXVKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:10:19 -0400
Date: Wed, 24 Mar 2010 16:10:12 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: Potential stack overflow
In-Reply-To: <1269464591.2849.15.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1003241608270.16858@router.home>
References: <1269430856.3213.27.camel@edumazet-laptop>  <alpine.DEB.2.00.1003241414270.14329@router.home>  <1269458528.2849.2.camel@edumazet-laptop>  <alpine.DEB.2.00.1003241443520.14329@router.home> <1269464591.2849.15.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Eric Dumazet wrote:

> @@ -3651,16 +3654,19 @@ static void process_slab(struct loc_track *t, struct kmem_cache *s,
>  		struct page *page, enum track_item alloc)
>  {
>  	void *addr = page_address(page);
> -	DECLARE_BITMAP(map, page->objects);
> +	long *map = kzalloc(BITS_TO_LONGS(page->objects) * sizeof(long),
> +			    GFP_ATOMIC);
>  	void *p;
>
> -	bitmap_zero(map, page->objects);
> +	if (!map)
> +		return;
>  	for_each_free_object(p, s, page->freelist)
>  		set_bit(slab_index(p, s, addr), map);
>
>  	for_each_object(p, s, addr, page->objects)
>  		if (!test_bit(slab_index(p, s, addr), map))
>  			add_location(t, s, get_track(s, p, alloc));
> +	kfree(map);
>  }
>

Hmmm... Thats another case. We should alloate the map higher up there I
guess and pass the address in so that one allocation can be used for all
slabs. validate_slab_cache() does that.

