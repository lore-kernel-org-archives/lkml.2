Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1AUHU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:20:26 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:40243 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1AUHUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:20:24 -0500
Date: Fri, 21 Jan 2011 08:20:22 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: flex_array related problems on selinux policy loading
Message-ID: <20110121072022.GA3070@secunet.com>
References: <20110120122659.GD4639@secunet.com>
 <1295537330.9039.583.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295537330.9039.583.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Jan 2011 07:20:22.0519 (UTC) FILETIME=[AA843070:01CBB93B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 07:28:50AM -0800, Dave Hansen wrote:
> On Thu, 2011-01-20 at 13:26 +0100, Steffen Klassert wrote:
> ...
> > @@ -187,6 +195,9 @@ int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
> >  	struct flex_array_part *part;
> >  	void *dst;
> > 
> > +	if (unlikely(ZERO_OR_NULL_PTR(fa)))
> > +		return 0;
> 
> I think it's OK to add these for the array alloc and free cases.  But,
> it's really dangerous to do it for put.  It has the potential to
> silently throw away data and then be really confusing to debug when you
> can't get it back later.

If the pointer to struct flex_array is a ZERO_SIZE_PTR we have to exit
before we try to dereference the first time as we have not allocated
anything. We can think about returning an error value in flex_array_put
if the flex_array is a ZERO_SIZE_PTR. The the user would be notified
that we could not store his data, but that's all we can do here I think.

Anyway, I just noticed in some functions the line

int part_nr = fa_element_to_part_nr(fa, element_nr);

which already dereferences the flex_array before I test for ZERO_SIZE_PTR.
So I have to fix this and to resubmit the patch.

> 
> This can only make sense if you have a zero-byte element.  However, this
> would also just return if you happened to try and insert data in to a
> zero-length array.  That's a bug we need to catch.  Note that
> kmem_cache_create() doesn't let you create caches for zero-byte objects.
> 
> > @@ -215,6 +226,9 @@ int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
> >  	struct flex_array_part *part;
> >  	void *dst;
> > 
> > +	if (unlikely(ZERO_OR_NULL_PTR(fa)))
> > +		return 0;
> 
> I tend to think about the flex_array itself as being more like a
> kmem_cache than anything else.  So, all of the operations on the array
> itself, like shrinking and growing are probably OK.

Hm, if either element_size or total_nr_elements is zero on allocation time,
the maximum size the array can ever have is zero. So I don't see how to
grow (shrink) anything in this case. Do I miss something here?

> 
> Can you also pull the unlikely()s?  
> 

Usually, when you call flex_array_alloc you want to allocate some memory.
So I considered a zero size allocation as a rare corner case, like kmalloc
does. Therefore the unlikely branch predictors made sense for me. Anyway,
I don't have a strong opinion about the unlikelys, so if you think it is
better to remove them I'll do so.

Steffen

