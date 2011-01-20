Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1ATPaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:30:03 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57430 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab1ATPaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:30:01 -0500
Subject: Re: flex_array related problems on selinux policy loading
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
In-Reply-To: <20110120122659.GD4639@secunet.com>
References: <20110120122659.GD4639@secunet.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 20 Jan 2011 07:28:50 -0800
Message-ID: <1295537330.9039.583.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 13:26 +0100, Steffen Klassert wrote:
> flex_array_alloc allocates the basic struct flex_array regardless whether
> total_nr_elements or element_size is zero. Then flex_array_prealloc
> fails with -ENOSPC if total_nr_elements is zero or it hits a division by
> zero if element_size is zero.
> 
> This patch changes the behaviour on zero size allocations to the same
> as kmalloc, we return ZERO_SIZE_PTR in this case. All flex_array handlers
> test for ZERO_SIZE_PTR and return an appropriate value to the caller.

Some of this seems pretty sane, at least to make it more of a drop-in
for kmalloc().

...
> @@ -187,6 +195,9 @@ int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
>  	struct flex_array_part *part;
>  	void *dst;
> 
> +	if (unlikely(ZERO_OR_NULL_PTR(fa)))
> +		return 0;

I think it's OK to add these for the array alloc and free cases.  But,
it's really dangerous to do it for put.  It has the potential to
silently throw away data and then be really confusing to debug when you
can't get it back later.

This can only make sense if you have a zero-byte element.  However, this
would also just return if you happened to try and insert data in to a
zero-length array.  That's a bug we need to catch.  Note that
kmem_cache_create() doesn't let you create caches for zero-byte objects.

> @@ -215,6 +226,9 @@ int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
>  	struct flex_array_part *part;
>  	void *dst;
> 
> +	if (unlikely(ZERO_OR_NULL_PTR(fa)))
> +		return 0;

I tend to think about the flex_array itself as being more like a
kmem_cache than anything else.  So, all of the operations on the array
itself, like shrinking and growing are probably OK.

Can you also pull the unlikely()s?  

-- Dave

