Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1K2H6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:58:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37733 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1K2H6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:58:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 29 Nov 2011 16:57:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [V4 PATCH 1/2] tmpfs: add fallocate support
Message-Id: <20111129165720.6034bf5c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4ED4888E.9040402@redhat.com>
References: <1322544793-2676-1-git-send-email-amwang@redhat.com>
	<20111129150210.ad266dd7.kamezawa.hiroyu@jp.fujitsu.com>
	<4ED4888E.9040402@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 15:23:58 +0800
Cong Wang <amwang@redhat.com> wrote:

> 于 2011年11月29日 14:02, KAMEZAWA Hiroyuki 写道:
> >
> > You can't know whether the 'page' is allocated by alloc_page() in fallocate()
> > or just found as exiting one.
> > Then, yourwill corrupt existing pages in error path.
> > Is it allowed ?
> >
> 
> According to the comment,
> 
> /*
>   * shmem_getpage_gfp - find page in cache, or get from swap, or allocate
>   *
>   * If we allocate a new one we do not mark it dirty. That's up to the
>   * vm. If we swap it in we mark it dirty since we also free the swap
>   * entry since a page cannot live in both the swap and page cache
>   */
> 
> so we can know if the page is newly allocated by checking page dirty bit.
> Or am I missing something?
> 

If swap-in doesn't happen and  a page is found...

==
       page = find_lock_page(mapping, index); <=============== you find a page
       if (radix_tree_exceptional_entry(page)) {
                swap = radix_to_swp_entry(page);
                page = NULL;
        }

        if (sgp != SGP_WRITE &&
            ((loff_t)index << PAGE_CACHE_SHIFT) >= i_size_read(inode)) {
                error = -EINVAL;
                goto failed;
        }

        if (page || (sgp == SGP_READ && !swap.val)) {
                /*
                 * Once we can get the page lock, it must be uptodate:
                 * if there were an error in reading back from swap,
                 * the page would not be inserted into the filecache.
                 */
                BUG_ON(page && !PageUptodate(page));
                *pagep = page; <========================= return here.
                return 0;
        }
==
Page will not be marked as dirty.

Thanks,
-Kame

