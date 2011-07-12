Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1GLT0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:26:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65099 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab1GLT0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:26:43 -0400
MIME-Version: 1.0
In-Reply-To: <201107072059.p67KxQ0O021814@hera.kernel.org>
References: <201107072059.p67KxQ0O021814@hera.kernel.org>
Date: Tue, 12 Jul 2011 21:26:42 +0200
X-Google-Sender-Auth: 14vJH-vE0i0r2SglzjpHUF8FaDc
Message-ID: <CAMuHMdUA7+j-hQuvu7g5kCZX1nqwPtR+mwhPP1nmxfkmCxfKmg@mail.gmail.com>
Subject: Re: FS-Cache: Add a helper to bulk uncache pages on an inode
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 22:59, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
>    FS-Cache: Add a helper to bulk uncache pages on an inode
>
>    Add an FS-Cache helper to bulk uncache pages on an inode.  This will
>    only work for the circumstance where the pages in the cache correspond
>    1:1 with the pages attached to an inode's page cache.
>
>    This is required for CIFS and NFS: When disabling inode cookie, we were
>    returning the cookie and setting cifsi->fscache to NULL but failed to
>    invalidate any previously mapped pages.  This resulted in "Bad page
>    state" errors and manifested in other kind of errors when running
>    fsstress.  Fix it by uncaching mapped pages when we disable the inode
>    cookie.
>
>    This patch should fix the following oops and "Bad page state" errors
>    seen during fsstress testing.

> --- a/fs/fscache/page.c
> +++ b/fs/fscache/page.c
> @@ -954,3 +954,47 @@ void fscache_mark_pages_cached(struct fscache_retrieval *op,
>        pagevec_reinit(pagevec);
>  }
>  EXPORT_SYMBOL(fscache_mark_pages_cached);
> +
> +/*
> + * Uncache all the pages in an inode that are marked PG_fscache, assuming them
> + * to be associated with the given cookie.
> + */
> +void __fscache_uncache_all_inode_pages(struct fscache_cookie *cookie,
> +                                      struct inode *inode)
> +{
> +       struct address_space *mapping = inode->i_mapping;
> +       struct pagevec pvec;
> +       pgoff_t next;
> +       int i;
> +
> +       _enter("%p,%p", cookie, inode);
> +
> +       if (!mapping || mapping->nrpages == 0) {
> +               _leave(" [no pages]");
> +               return;
> +       }
> +
> +       pagevec_init(&pvec, 0);
> +       next = 0;
> +       while (next <= (loff_t)-1 &&

On m68k, I get:

fs/fscache/page.c: In function ‘__fscache_uncache_all_inode_pages’:
fs/fscache/page.c:979: warning: comparison is always false due to
limited range of data type

next is pgoff_t, which is defined to unsigned long by default, unless
overridden by the arch
(hmm, no single arch seems to do that?).
loff_t is (signed) long long.

> +              pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)
> +              ) {
> +               for (i = 0; i < pagevec_count(&pvec); i++) {
> +                       struct page *page = pvec.pages[i];
> +                       pgoff_t page_index = page->index;
> +
> +                       ASSERTCMP(page_index, >=, next);
> +                       next = page_index + 1;
> +
> +                       if (PageFsCache(page)) {
> +                               __fscache_wait_on_page_write(cookie, page);
> +                               __fscache_uncache_page(cookie, page);
> +                       }
> +               }
> +               pagevec_release(&pvec);
> +               cond_resched();
> +       }
> +
> +       _leave("");
> +}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
