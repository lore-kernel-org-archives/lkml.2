Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab2JWGRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:17:03 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38887 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2JWGRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:17:00 -0400
Subject: Re: [PATCH for-v3.7 2/2] slub: optimize kmalloc* inlining for
 GFP_DMA
From: Eric Dumazet <eric.dumazet@gmail.com>
To: JoonSoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <CAAmzW4Nz_=_Tj-D=DXaO-SR5pRZ_n7-gfVbKHa+=DP0NQioAaQ@mail.gmail.com>
References: <1350748093-7868-1-git-send-email-js1304@gmail.com>
	 <1350748093-7868-2-git-send-email-js1304@gmail.com>
	 <0000013a88e2e9dc-9f72abd3-9a31-454c-b70b-9937ba54c0ee-000000@email.amazonses.com>
	 <CAAmzW4Nz_=_Tj-D=DXaO-SR5pRZ_n7-gfVbKHa+=DP0NQioAaQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Oct 2012 08:16:55 +0200
Message-ID: <1350973015.8609.1444.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 11:29 +0900, JoonSoo Kim wrote:
> 2012/10/22 Christoph Lameter <cl@linux.com>:
> > On Sun, 21 Oct 2012, Joonsoo Kim wrote:
> >
> >> kmalloc() and kmalloc_node() of the SLUB isn't inlined when @flags = __GFP_DMA.
> >> This patch optimize this case,
> >> so when @flags = __GFP_DMA, it will be inlined into generic code.
> >
> > __GFP_DMA is a rarely used flag for kmalloc allocators and so far it was
> > not considered that it is worth to directly support it in the inlining
> > code.
> >
> >
> 
> Hmm... but, the SLAB already did that optimization for __GFP_DMA.
> Almost every kmalloc() is invoked with constant flags value,
> so I think that overhead from this patch may be negligible.
> With this patch, code size of vmlinux is reduced slightly.

Only because you asked a allyesconfig

GFP_DMA is used for less than 0.1 % of kmalloc() calls, for legacy
hardware (from last century)


In fact if you want to reduce even more your vmlinux, you could test

if (__builtin_constant_p(flags) && (flags & SLUB_DMA))
    return kmem_cache_alloc_trace(s, flags, size);

to force the call to out of line code.




