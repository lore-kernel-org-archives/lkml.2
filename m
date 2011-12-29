Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1L2XHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 18:07:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab1L2XHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 18:07:18 -0500
Date: Thu, 29 Dec 2011 15:07:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] mm: vmscan: fix typo in isolating lru pages
Message-Id: <20111229150717.6c8ba825.akpm@linux-foundation.org>
In-Reply-To: <CAJd=RBAp=ooYGoDqJG0qkUhRuYTsSKG9h+bUvC0dvuVCvfkCgQ@mail.gmail.com>
References: <CAJd=RBAp=ooYGoDqJG0qkUhRuYTsSKG9h+bUvC0dvuVCvfkCgQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Dec 2011 20:38:41 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> It is not the tag page but the cursor page that we should process, and it looks
> a typo.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Hugh Dickins <hughd@google.com>
> ---
> 
> --- a/mm/vmscan.c	Thu Dec 29 20:20:16 2011
> +++ b/mm/vmscan.c	Thu Dec 29 20:23:30 2011
> @@ -1231,13 +1231,13 @@ static unsigned long isolate_lru_pages(u
> 
>  				mem_cgroup_lru_del(cursor_page);
>  				list_move(&cursor_page->lru, dst);
> -				isolated_pages = hpage_nr_pages(page);
> +				isolated_pages = hpage_nr_pages(cursor_page);
>  				nr_taken += isolated_pages;
>  				nr_lumpy_taken += isolated_pages;
>  				if (PageDirty(cursor_page))
>  					nr_lumpy_dirty += isolated_pages;
>  				scan++;
> -				pfn += isolated_pages-1;
> +				pfn += isolated_pages - 1;
>  			} else {
>  				/*
>  				 * Check if the page is freed already.

This problem looks pretty benign in mainline.  But Andrea's "mm:
vmscan: check if we isolated a compound page during lumpy scan" came
along and uses isolated_pages rather a lot more, including using it to
advance across the pfn array.

I jiggled your patch to suit current mainline then reworked everything
else so we end up with this result.

