Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298Ab2EKTem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:34:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27823 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab2EKTek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:34:40 -0400
Date: Fri, 11 May 2012 15:28:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
Message-ID: <20120511192831.GC3785@phenom.dumpdata.com>
References: <4FAB21E7.7020703@kernel.org>
 <20120510140215.GC26152@phenom.dumpdata.com>
 <4FABD503.4030808@vflare.org>
 <4FABDA9F.1000105@linux.vnet.ibm.com>
 <20120510151941.GA18302@kroah.com>
 <4FABECF5.8040602@vflare.org>
 <20120510164418.GC13964@kroah.com>
 <4FABF9D4.8080303@vflare.org>
 <20120510173322.GA30481@phenom.dumpdata.com>
 <4FAC4E3B.3030909@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAC4E3B.3030909@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please look.
> 
> struct zs_handle {
> 	void *handle
> };
> 
> 1)
> 
> static struct zv_hdr *zv_create(..)
> {
> 	struct zs_handle handle;
> 	..
> 	handle = zs_malloc(pool, size);
> 	..
> 	return handle;

Compiler will complain that you are returning incorrect type.

> }
> 
> handle is on stack so it can't be used by index for slot of radix tree.

The fix is of course to return a pointer (which your function
declared), and instead do this:

{
	struct zs_handle *handle;

	handle = zs_malloc(pool, size);
	return handle;
}

> 
> 2)
> 
> static struct zv_hdr *zv_create(..)
> {
> 	struct zs_handle handle;
> 	..
> 	handle = zs_malloc(pool, size);
> 	..
> 	return handle.handle;
> }
> 
> Okay. Now it works but zcache coupled with zsmalloc tightly.
> User of zsmalloc should never know internal of zs_handle.

OK. Then it can just forward declare it:

struct zs_handle;

and zsmalloc will treat it as an opaque pointer.

> 
> 3)
> 
> - zsmalloc.h
> void *zs_handle_to_ptr(struct zs_handle handle)
> {
> 	return handle.hanle;
> }
> 
> static struct zv_hdr *zv_create(..)
> {
> 	struct zs_handle handle;
> 	..
> 	handle = zs_malloc(pool, size);
> 	..
> 	return zs_handle_to_ptr(handle);

> }

> 
> Why should zsmalloc support such interface?

Why not? It is better than a 'void *' or a typedef.

It is modeled after a pte_t.


> It's a zcache problem so it's desriable to solve it in zcache internal.

Not really. We shouldn't really pass any 'void *' pointers around.

> And in future, if we can add/remove zs_handle's fields, we can't make
> sure such API.

Meaning ... what exactly do you mean? That the size of the structure
will change and we won't return the right value? Why not?
If you use the 'zs_handle_to_ptr' won't that work? Especially if you
add new values to the end of the struct it won't cause issues.

> 
> 
> >> Its true that making it a real struct would prevent accidental casts
> >> to void * but due to the above problem, I think we have to stick
> >> with unsigned long.

So the problem you are seeing is that you don't want 'struct zs_handle'
be present in the drivers/staging/zsmalloc/zsmalloc.h header file?
It looks like the proper place.
