Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab1KWXGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 18:06:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65515 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab1KWXGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 18:06:40 -0500
Date: Wed, 23 Nov 2011 15:06:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: zhihua che <zhihua.che@gmail.com>
cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org
Subject: Re: Fwd: Slub Allocator: Why get_order(size * MAX_OBJS_PER_PAGE) -
 1 in function slab_order()?
In-Reply-To: <CABexPfHxM=NpwrrbFrTJUVZHzORpVaqAwoh1yC7d=RTfwnQWwg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1111231501030.24794@chino.kir.corp.google.com>
References: <CABexPfF-31f1vcJpqdsDHKUHfes1230vwGMtm6ETZXVQQf4bcA@mail.gmail.com> <alpine.DEB.2.00.1111221847320.30008@chino.kir.corp.google.com> <CABexPfEte8U5pVBJ=LvRKMY5=oW7F2vRjw_d9893Yy8W88hfDg@mail.gmail.com>
 <CABexPfHxM=NpwrrbFrTJUVZHzORpVaqAwoh1yC7d=RTfwnQWwg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1750135002-1322089599=:24794"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1750135002-1322089599=:24794
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 23 Nov 2011, zhihua che wrote:

> I know what you mean, that is, a slab can only store no more than
> MAX_OBJS_PER_PAGE, actually 0x7FFF, objects.
> 
> But  get_order(size * MAX_OBJS_PER_PAGE) already returns the order
> which reserves no_more_than size * MAX_OBJS_PER_PAGE memory.  Right?
> 

Yes, but it reserves too much memory if the conditional is true.

> So I think there is no need to subtract one.
> 

If we didn't subtract one, then the order of a slab page would allow for 
_more_ than MAX_OBJS_PER_PAGE to be allocated and that's not allowed 
because of the restrictions in struct page.

Consider a page size of 4K and an object size of 8 bytes.  
get_order(8 * 32767) would be 6, so that's a 4K * 2^6 = 256K slab page 
without the subtraction and could allocate (256K * 1024 / 8) = 32768 which 
is greater than MAX_OBJS_PER_PAGE and not allowed.

So we subtract one so the compound slab page is guaranteed to allocate 
less than MAX_OBJS_PER_PAGE.
--397155492-1750135002-1322089599=:24794--
