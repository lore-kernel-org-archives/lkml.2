Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1CPU2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:28:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab1CPU2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=lQHEdWPLA1zKeEo6G/Ffs5g/Fo1Mky2PqdY7NMGB/ay7T62y7IiEYlCu45aLS4Prhg
         FihF+Qrgly82hKlsjj2A==
Date: Wed, 16 Mar 2011 13:28:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: George Spelvin <linux@horizon.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, herbert@gondor.hengli.com.au,
        mpm@selenic.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] mm/slub: Factor out some common code.
In-Reply-To: <20110316022805.27713.qmail@science.horizon.com>
Message-ID: <alpine.DEB.2.00.1103161308410.11002@chino.kir.corp.google.com>
References: <20110316022805.27713.qmail@science.horizon.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, George Spelvin wrote:

> For sysfs files that map a boolean to a flags bit.

Where's your signed-off-by?

> ---
>  mm/slub.c |   93 ++++++++++++++++++++++++++++--------------------------------
>  1 files changed, 43 insertions(+), 50 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index e15aa7f..856246f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3982,38 +3982,61 @@ static ssize_t objects_partial_show(struct kmem_cache *s, char *buf)
>  }
>  SLAB_ATTR_RO(objects_partial);
>  
> +static ssize_t flag_show(struct kmem_cache *s, char *buf, unsigned flag)
> +{
> +	return sprintf(buf, "%d\n", !!(s->flags & flag));
> +}
> +
> +static ssize_t flag_store(struct kmem_cache *s,
> +				const char *buf, size_t length, unsigned flag)
> +{
> +	s->flags &= ~flag;
> +	if (buf[0] == '1')
> +		s->flags |= flag;
> +	return length;
> +}
> +
> +/* Like above, but changes allocation size; so only allowed on empty slab */
> +static ssize_t flag_store_sizechange(struct kmem_cache *s,
> +				const char *buf, size_t length, unsigned flag)
> +{
> +	if (any_slab_objects(s))
> +		return -EBUSY;
> +
> +	flag_store(s, buf, length, flag);
> +	calculate_sizes(s, -1);
> +	return length;
> +}
> +

Nice cleanup.

"flag" should be unsigned long in all of these functions: the constants 
are declared with UL suffixes in slab.h.

After that's fixed,

	Acked-by: David Rientjes <rientjes@google.com>
