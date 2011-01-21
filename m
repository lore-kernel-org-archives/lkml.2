Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1AUP6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 10:58:04 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:45372 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab1AUP6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 10:58:00 -0500
Subject: Re: flex_array related problems on selinux policy loading
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
In-Reply-To: <20110121072022.GA3070@secunet.com>
References: <20110120122659.GD4639@secunet.com>
	 <1295537330.9039.583.camel@nimitz>  <20110121072022.GA3070@secunet.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 21 Jan 2011 07:57:35 -0800
Message-ID: <1295625455.9039.3326.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 08:20 +0100, Steffen Klassert wrote:
> On Thu, Jan 20, 2011 at 07:28:50AM -0800, Dave Hansen wrote:
> > On Thu, 2011-01-20 at 13:26 +0100, Steffen Klassert wrote:
> > ...
> > > @@ -187,6 +195,9 @@ int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
> > >  	struct flex_array_part *part;
> > >  	void *dst;
> > > 
> > > +	if (unlikely(ZERO_OR_NULL_PTR(fa)))
> > > +		return 0;
> > 
> > I think it's OK to add these for the array alloc and free cases.  But,
> > it's really dangerous to do it for put.  It has the potential to
> > silently throw away data and then be really confusing to debug when you
> > can't get it back later.
> 
> If the pointer to struct flex_array is a ZERO_SIZE_PTR we have to exit
> before we try to dereference the first time as we have not allocated
> anything. We can think about returning an error value in flex_array_put
> if the flex_array is a ZERO_SIZE_PTR. The the user would be notified
> that we could not store his data, but that's all we can do here I think.

Yeah, a zero-sized array with a put() done on it should return -ENOSPC,
not 0.  But, an array storing 0-byte objects can and should return 0.

Basically, the patch confuses those two cases.

> > I tend to think about the flex_array itself as being more like a
> > kmem_cache than anything else.  So, all of the operations on the array
> > itself, like shrinking and growing are probably OK.
> 
> Hm, if either element_size or total_nr_elements is zero on allocation time,
> the maximum size the array can ever have is zero. So I don't see how to
> grow (shrink) anything in this case. Do I miss something here?

I mean it shouldn't return an error, nor is it invalid.  You can't _do_
anything, but it's at least valid.

My suggestion would be to simply make sure that the code handles 0-sized
objects and 0-length arrays OK, and do it in two separate patches.  The
ZERO_SIZE_PTR can't be used for both because you need to know which
situation you were in and you need different behavior (like in
flex_array_put()).

Frankly, I like the idea of just allocating a 'struct flex_array' in any
case, and just teaching the code to handle element_size=0 and
nr_elements=0.  That way, if you have bugs in the code that does things
like flex_array_alloc(elem_size=0, len=5, ...) and then
flex_array_get(fa, index=99), you have the potential to detect and
report the bugs.  The only way to do that is to remember what you set
the length as.  

If you're worried about allocating a whole page, you could easily just
kmalloc() a the two integers for the metadata portion of the 'struct
flex_array'.

-- Dave

