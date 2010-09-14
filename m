Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab0INR0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:26:12 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:42350 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751153Ab0INR0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:26:09 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: wA1CfF8VM1kx59LLCQm28w8JAJ4yUTAJU1MsqhmUl4gpqR7
 _AIieaDuflVpL3X2X5Hc4mtoULkAbcoMvjDxAyX5aTbqyuY00yjvuaHTeH_N
 wDOCE52D5FCaoam4wXIJhY1jlCE7Q9RH.eXCOXu1JDzEbgP88m5bBIZyAPPA
 pHDXpK26zx6mB9hilUPjnOq0t4DcnP4g3hUavTNpbkdyfNSEyUsJGMQozy26
 HlU97y65wNfRHVlk0Af0IqQwCRLKD
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 14 Sep 2010 12:26:05 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: torvalds@linux-founation.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/2] SLUB: Fix merged slab cache names
In-Reply-To: <1284483964-2370-1-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1009141221310.31857@router.home>
References: <1284483964-2370-1-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Pekka Enberg wrote:

> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 59260e2..df201cf 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -76,6 +76,8 @@
>  # define SLAB_FAILSLAB		0x00000000UL
>  #endif
>
> +#define SLAB_DYNAMIC_NAME	0x04000000UL	/* s->name is kmalloc()'d */
> +

Put this into mm/slub.c as slub only flag? What is the difference from
refcount == 1?

> @@ -3218,6 +3221,18 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
>  	down_write(&slub_lock);
>  	s = find_mergeable(size, align, flags, name, ctor);
>  	if (s) {
> +		if (!(s->flags & SLAB_DYNAMIC_NAME)) {
> +			const char *new_name;
> +
> +			new_name = kstrdup(s->name, GFP_KERNEL);

Ok. Keeping the original name. Why dont we do strdup by default and always
do a kfree(s->name) on close?

