Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1AZQMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:12:21 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56076 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab1AZQMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:12:19 -0500
Subject: Re: flex_array related problems on selinux policy loading
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Eric Paris <eparis@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20110126102328.GC3070@secunet.com>
References: <20110120122659.GD4639@secunet.com>
	 <1295537330.9039.583.camel@nimitz> <20110121072022.GA3070@secunet.com>
	 <1295625455.9039.3326.camel@nimitz>  <20110126102328.GC3070@secunet.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 26 Jan 2011 08:10:16 -0800
Message-ID: <1296058216.7567.21.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 11:23 +0100, Steffen Klassert wrote: 
> Yes, I thought a moment on allocating the basic struct flex_array
> in any case. But I immediately stopped thinking about this when I saw that
> I would allocate a whole page that I don't need afterwards. For the moment
> I don't see any sane way to allocate just the metadata as long as the
> struct flex_array has a fixed size.
> 
> Btw. why the struct flex_array needs to have page size?

It was designed as an alternative to _large_ allocations and we didn't
expect people to want to use it for small things.  But, it doesn't
_need_ to stay that way, we just did it like that for simplicity.

> If we would make
> flex_array of dynamic size, say metadata plus the maximum size of the array
> in the case that the metadata and the array fit into a single page, and
> metadata plus space for all the base pointers we need to dereference the
> parts, if the metadata and array is beyond page size. With this, the struct
> flex_array would have a reasonable size in any case, even if the array to
> store is small or of zero size.

Sounds like a good idea to me.  Done right, it should only really affect
the allocation path since we use kmalloc() already, and we can still
plain kfree() it.

-- Dave


