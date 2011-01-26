Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1AZNEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 08:04:12 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:59897 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab1AZNEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 08:04:10 -0500
Date: Wed, 26 Jan 2011 14:04:07 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: flex_array related problems on selinux policy loading
Message-ID: <20110126130407.GD3070@secunet.com>
References: <20110120122659.GD4639@secunet.com>
 <1295537330.9039.583.camel@nimitz>
 <20110121072022.GA3070@secunet.com>
 <1295625455.9039.3326.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295625455.9039.3326.camel@nimitz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Jan 2011 13:04:08.0040 (UTC) FILETIME=[8459AE80:01CBBD59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> 

Another thing came to my mind. An atempt to do a zero size allocation
always succeed on kmalloc. If we want to allocate our metadata even in
this case, we should be aware that this allocation _can_ fail. So
flex_array_alloc would not show the same behaviour as kmalloc on zero
size allocations. As most potential flex_array users convert their code
from kmalloc, the behaviour of flex_array_alloc should be the same as of
kmalloc. Showing a different behaviour here will produce pitfalls for
potential new users. Also, to tell a user that we can not allocate memory
for him, if the wants to allocate 0 byte (nothing) is quite odd. This
user could easily continue processing, even if we can not allocate our
metadata in this moment.

>From this point of view, I'd tend to not allocating anything. Instead we
could return two newly defined pointers, e.g. FLEX_ARRAY_ZERO_SIZE and
FLEX_ARRAY_ZERO_ELEMENTS to catch if either element_size or
total_nr_elements is zero.

The downside of this is of course, that we can't catch the bugs you
mentioned above.

Steffen

