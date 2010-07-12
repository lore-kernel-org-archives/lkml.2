Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0GLWkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:40:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48207 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab0GLWke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:40:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=O8Y3lzGSIiTw21i3KeoQ0AZenyj4vaF6fPehFD55JJvVT07cIZKhDxz6W8hRWQ6seJ
         m3T6WIuZd1wEtxBBWR1Rfi0rTbbnlj8eyw0SiCp289LKCLwGR7M58nc8s5DLbVtFVF5C
         LzBUdZcMTiT4nG+kHQdfklSe/BwWF+aGSry3U=
Date: Tue, 13 Jul 2010 00:39:05 +0200
From: Dan Carpenter <error27@gmail.com>
To: suokkos@gmail.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: questions about ttm_page_alloc.c
Message-ID: <20100712223905.GH5658@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, suokkos@gmail.com,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm investigating: https://bugzilla.kernel.org/show_bug.cgi?id=16337

He is using the new radeon with the new ttm pool wc/uc page allocator.
I'm sort of over my head when it comes to mm stuff so forgive me if
these are dumb questions...  I'm looking at 
drivers/gpu/drm/ttm/ttm_page_alloc.c.

   230  static int set_pages_array_wc(struct page **pages, int addrinarray)
   231  {
   232  #ifdef TTM_HAS_AGP
   233          int i;
   234  
   235          for (i = 0; i < addrinarray; i++)
   236                  map_page_into_agp(pages[i]);
			^^^^^^^^^^^^^^^^^^^^^^^^^^^

	This actually sets the pages to uncached and not to write
	cached.  Is that deliberate?

   237  #endif
   238          return 0;
   239  }

[snip]

   327                  pages_to_free[freed_pages++] = p;
   328                  /* We can only remove NUM_PAGES_TO_ALLOC at a time. */
   329                  if (freed_pages >= NUM_PAGES_TO_ALLOC) {
   330                          /* remove range of pages from the pool */
   331                          __list_del(p->lru.prev, &pool->list);

	Why do we use p->lru.prev here when we use &p->lru in other
	places?

   332  
   333                          ttm_pool_update_free_locked(pool, freed_pages);
   334                          /**
   335                           * Because changing page caching is costly
   336                           * we unlock the pool to prevent stalling.

regards,
dan carpenter
