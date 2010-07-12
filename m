Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933Ab0GLXNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 19:13:05 -0400
Received: from nox2.protox.org ([95.130.11.66]:45875 "EHLO protox.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab0GLXNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 19:13:02 -0400
Message-ID: <4C3BA165.5020008@freedesktop.org>
Date: Mon, 12 Jul 2010 19:12:37 -0400
From: Jerome Glisse <glisse@freedesktop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Thunderbird/3.1
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, suokkos@gmail.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: questions about ttm_page_alloc.c
References: <20100712223905.GH5658@bicker>
In-Reply-To: <20100712223905.GH5658@bicker>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 06:39 PM, Dan Carpenter wrote:
> I'm investigating: https://bugzilla.kernel.org/show_bug.cgi?id=16337
>
> He is using the new radeon with the new ttm pool wc/uc page allocator.
> I'm sort of over my head when it comes to mm stuff so forgive me if
> these are dumb questions...  I'm looking at
> drivers/gpu/drm/ttm/ttm_page_alloc.c.
>
>     230  static int set_pages_array_wc(struct page **pages, int addrinarray)
>     231  {
>     232  #ifdef TTM_HAS_AGP
>     233          int i;
>     234
>     235          for (i = 0; i<  addrinarray; i++)
>     236                  map_page_into_agp(pages[i]);
> 			^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> 	This actually sets the pages to uncached and not to write
> 	cached.  Is that deliberate?
>
>     237  #endif
>     238          return 0;
>     239  }
>
> [snip]
>
>     327                  pages_to_free[freed_pages++] = p;
>     328                  /* We can only remove NUM_PAGES_TO_ALLOC at a time. */
>     329                  if (freed_pages>= NUM_PAGES_TO_ALLOC) {
>     330                          /* remove range of pages from the pool */
>     331                          __list_del(p->lru.prev,&pool->list);
>
> 	Why do we use p->lru.prev here when we use&p->lru in other
> 	places?
>
>     332
>     333                          ttm_pool_update_free_locked(pool, freed_pages);
>     334                          /**
>     335                           * Because changing page caching is costly
>     336                           * we unlock the pool to prevent stalling.
>
> regards,
> dan carpenter
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

No it's fine, this code is for non x86 CPU, and on such platform
we assume wc == uncached and wb is normal (ie cached).

Cheers,
Jerome
