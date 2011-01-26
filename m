Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1AZKXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:23:33 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:42165 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab1AZKXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:23:31 -0500
Date: Wed, 26 Jan 2011 11:23:28 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: flex_array related problems on selinux policy loading
Message-ID: <20110126102328.GC3070@secunet.com>
References: <20110120122659.GD4639@secunet.com>
 <1295537330.9039.583.camel@nimitz>
 <20110121072022.GA3070@secunet.com>
 <1295625455.9039.3326.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295625455.9039.3326.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Jan 2011 10:23:29.0390 (UTC) FILETIME=[134468E0:01CBBD43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ed Andrew on request.

On Fri, Jan 21, 2011 at 07:57:35AM -0800, Dave Hansen wrote:
> 
> My suggestion would be to simply make sure that the code handles 0-sized
> objects and 0-length arrays OK, and do it in two separate patches.  The
> ZERO_SIZE_PTR can't be used for both because you need to know which
> situation you were in and you need different behavior (like in
> flex_array_put()).
> 
> Frankly, I like the idea of just allocating a 'struct flex_array' in any
> case, and just teaching the code to handle element_size=0 and
> nr_elements=0.  That way, if you have bugs in the code that does things
> like flex_array_alloc(elem_size=0, len=5, ...) and then
> flex_array_get(fa, index=99), you have the potential to detect and
> report the bugs.  The only way to do that is to remember what you set
> the length as. 

Ok, if we can catch these bugs in an easy way, without a lot of extra
handling for this a rare case, we should do this.
 
> 
> If you're worried about allocating a whole page, you could easily just
> kmalloc() a the two integers for the metadata portion of the 'struct
> flex_array'.
> 

Yes, I thought a moment on allocating the basic struct flex_array
in any case. But I immediately stopped thinking about this when I saw that
I would allocate a whole page that I don't need afterwards. For the moment
I don't see any sane way to allocate just the metadata as long as the
struct flex_array has a fixed size.

Btw. why the struct flex_array needs to have page size? If we would make
flex_array of dynamic size, say metadata plus the maximum size of the array
in the case that the metadata and the array fit into a single page, and
metadata plus space for all the base pointers we need to dereference the
parts, if the metadata and array is beyond page size. With this, the struct
flex_array would have a reasonable size in any case, even if the array to
store is small or of zero size.

Steffen
