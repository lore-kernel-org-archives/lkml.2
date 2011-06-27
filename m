Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1F0X26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:28:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8046 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab1F0X23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=UgkxAxlGEyjUF/EuNum4wDSbP+rT01YfJc4T7VArnI1DBgpEhJ0eFPTXrkTREEWt4L
         LgNL2Rq97pCVljSGcttA==
Date: Mon, 27 Jun 2011 16:28:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ben Greear <greearb@candelatech.com>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] slub:  Add method to verify memory is not deleted.
In-Reply-To: <1309216631-31493-3-git-send-email-greearb@candelatech.com>
Message-ID: <alpine.DEB.2.00.1106271622510.24211@chino.kir.corp.google.com>
References: <1309216631-31493-1-git-send-email-greearb@candelatech.com> <1309216631-31493-3-git-send-email-greearb@candelatech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, greearb@candelatech.com wrote:

> From: Ben Greear <greearb@candelatech.com>
> 
> This is for tracking down suspect memory usage.
> 

Several things wrong with this:

 - I have no idea where patch 1/2 is.

 - the subject line is ambiguous, when you say memory is "deleted," I 
   thought at first you were talking about hot-removed, but it seems like 
   you're talking about "freed."

 - what "suspect memory usage" are you adding functionality to catch and
   how are you doing it?

 - you didn't cc the slab maintainers, Pekka Enberg and Christoph Lameter
   (I added them).

> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 ad4dd1c... 35a13d2... M	include/linux/slab.h
> :100644 100644 14d0135... b3d7680... M	mm/slub.c
>  include/linux/slab.h |    9 +++++++++
>  mm/slub.c            |   34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index ad4dd1c..35a13d2 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -302,6 +302,15 @@ extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
>  
>  #endif /* CONFIG_NUMA */
>  
> +/** Calling this on deleted objects will print some
> + * SLUB debugging information.
> + */

Ambiguous as to what it will be printing and violation of the comment 
style used in the kernel (see Documentation/CodingStyle).

> +#if defined(CONFIG_SLUB) && defined(CONFIG_SLUB_DEBUG)
> +extern bool verify_mem_not_deleted(const void *x);
> +#else
> +#define verify_mem_not_deleted(x)

This will surely break if anybody isn't using slub or CONFIG_SLUB_DEBUG 
and it testing verify_mem_not_deleted().  You probably want

	static inline bool verify_mem_not_deleted(const void *x)
	{
		return false;
	}

> +#endif
> +
>  /*
>   * Shortcuts
>   */
> diff --git a/mm/slub.c b/mm/slub.c
> index 14d0135..b3d7680 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2953,6 +2953,40 @@ size_t ksize(const void *object)
>  }
>  EXPORT_SYMBOL(ksize);
>  
> +#if defined(CONFIG_SLUB_DEBUG)

#ifdef CONFIG_SLUB_DEBUG

> +bool verify_mem_not_deleted(const void *x)
> +{
> +	struct page *page;
> +	void *object = (void *)x;
> +	struct kmem_cache *s;
> +	unsigned long flags;
> +	bool rv = false;
> +
> +	if (unlikely(ZERO_OR_NULL_PTR(x)))
> +		false;
> +

Did you even compile-test this?

> +	local_irq_save(flags);
> +
> +	page = virt_to_head_page(x);
> +	if (unlikely(!PageSlab(page))) {
> +		BUG_ON(!PageCompound(page));

Why is there a BUG_ON() here if we didn't pass a pointer to a slab object?

> +		goto out_unlock;
> +	}
> +
> +	s = page->slab;
> +
> +	if (on_freelist(s, page, object)) {
> +		object_err(s, page, object, "Object is on fee-list");

s/fee/free/

> +		goto out_unlock;
> +	}
> +	rv = true;
> +out_unlock:
> +	local_irq_restore(flags);
> +	return rv;
> +}
> +EXPORT_SYMBOL(verify_mem_not_deleted);
> +#endif
> +
