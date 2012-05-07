Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2EGHlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:41:52 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52211 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571Ab2EGHlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:41:50 -0400
Date: Mon, 7 May 2012 10:41:45 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Minchan Kim <minchan@kernel.org>
cc: Nitin Gupta <ngupta@vflare.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cl@linux-foundation.org
Subject: Re: [PATCH 4/4] zsmalloc: zsmalloc: align cache line size
In-Reply-To: <4FA33E89.6080206@kernel.org>
Message-ID: <alpine.LFD.2.02.1205071038090.2851@tux.localdomain>
References: <1336027242-372-1-git-send-email-minchan@kernel.org> <1336027242-372-4-git-send-email-minchan@kernel.org> <4FA28EFD.5070002@vflare.org> <4FA33E89.6080206@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2012, Minchan Kim wrote:
> >> It's a overkill to align pool size with PAGE_SIZE to avoid
> >> false-sharing. This patch aligns it with just cache line size.
> >>
> >> Signed-off-by: Minchan Kim<minchan@kernel.org>
> >> ---
> >>   drivers/staging/zsmalloc/zsmalloc-main.c |    6 +++---
> >>   1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c
> >> b/drivers/staging/zsmalloc/zsmalloc-main.c
> >> index 51074fa..3991b03 100644
> >> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> >> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> >> @@ -489,14 +489,14 @@ fail:
> >>
> >>   struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
> >>   {
> >> -    int i, error, ovhd_size;
> >> +    int i, error;
> >>       struct zs_pool *pool;
> >>
> >>       if (!name)
> >>           return NULL;
> >>
> >> -    ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
> >> -    pool = kzalloc(ovhd_size, GFP_KERNEL);
> >> +    pool = kzalloc(ALIGN(sizeof(*pool), cache_line_size()),
> >> +                GFP_KERNEL);
> > 
> > a basic question:
> >  Is rounding off allocation size to cache_line_size enough to ensure
> > that the object is cache-line-aligned? Isn't it possible that even
> > though the object size is multiple of cache-line, it may still not be
> > properly aligned and end up sharing cache line with some other
> > read-mostly object?
> 
> AFAIK, SLAB allocates object aligned cache-size so I think that problem cannot happen.
> But needs double check.
> Cced Pekka.

The kmalloc(size) function only gives you the following guarantees:

  (1) The allocated object is _at least_ 'size' bytes.
 
  (2) The returned pointer is aligned to ARCH_KMALLOC_MINALIGN.

Anything beyond that is implementation detail and probably will break if 
you switch between SLAB/SLUB/SLOB.

			Pekka
