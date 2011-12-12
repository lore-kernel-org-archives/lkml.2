Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1LLXMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:12:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab1LLXMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:12:17 -0500
Date: Mon, 12 Dec 2011 15:12:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: try to free orphaned page
Message-Id: <20111212151215.2363f5cd.akpm@linux-foundation.org>
In-Reply-To: <CAJd=RBAN7cK_6OstO=5gszW8cJ_d4-8iQC3gWG6HUtabiMN9Yg@mail.gmail.com>
References: <CAJd=RBAN7cK_6OstO=5gszW8cJ_d4-8iQC3gWG6HUtabiMN9Yg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 20:24:39 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> If the orphaned page has no buffer attached at the moment, we clean it up by
> hand, then it has the chance to progress the freeing trip.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/vmscan.c	Sun Dec  4 13:10:08 2011
> +++ b/mm/vmscan.c	Mon Dec 12 20:12:44 2011
> @@ -487,12 +487,10 @@ static pageout_t pageout(struct page *pa
>  		 * Some data journaling orphaned pages can have
>  		 * page->mapping == NULL while being dirty with clean buffers.
>  		 */
> -		if (page_has_private(page)) {
> -			if (try_to_free_buffers(page)) {
> -				ClearPageDirty(page);
> -				printk("%s: orphaned page\n", __func__);
> -				return PAGE_CLEAN;
> -			}
> +		if (!page_has_private(page) || try_to_free_buffers(page)) {
> +			ClearPageDirty(page);
> +			printk(KERN_INFO "%s: orphaned page\n", __func__);
> +			return PAGE_CLEAN;
>  		}
>  		return PAGE_KEEP;
>  	}

So if we find a dirty pagecache page with nothing at ->private, you're
suggesting that we simply mark it clean and free it.

afacit it would be a bug for a page to be in that state.

What prompted this patch?  I assume you've not encountered pages in
this state in your testing because if you had, that printk wouldn't
still be in there!

A brief bit of googling indicates that nobody has seen the "pageout:
orphaned page" warning for five years.
