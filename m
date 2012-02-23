Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab2BWWhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:37:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab2BWWg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:36:59 -0500
Date: Thu, 23 Feb 2012 14:36:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: extend prefault helpers to fault in more than
 PAGE_SIZE
Message-Id: <20120223143658.0e318ce2.akpm@linux-foundation.org>
In-Reply-To: <1329393696-4802-2-git-send-email-daniel.vetter@ffwll.ch>
References: <1329393696-4802-1-git-send-email-daniel.vetter@ffwll.ch>
	<1329393696-4802-2-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 13:01:36 +0100
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> drm/i915 wants to read/write more than one page in its fastpath
> and hence needs to prefault more than PAGE_SIZE bytes.
> 
> I've checked the callsites and they all already clamp size when
> calling fault_in_pages_* to the same as for the subsequent
> __copy_to|from_user and hence don't rely on the implicit clamping
> to PAGE_SIZE.
> 
> Also kill a copy&pasted spurious space in both functions while at it.
>
> ...
>
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -408,6 +408,7 @@ extern void add_page_wait_queue(struct page *page, wait_queue_t *waiter);
>  static inline int fault_in_pages_writeable(char __user *uaddr, int size)
>  {
>  	int ret;
> +	char __user *end = uaddr + size - 1;
>  
>  	if (unlikely(size == 0))
>  		return 0;
> @@ -416,17 +417,20 @@ static inline int fault_in_pages_writeable(char __user *uaddr, int size)
>  	 * Writing zeroes into userspace here is OK, because we know that if
>  	 * the zero gets there, we'll be overwriting it.
>  	 */
> -	ret = __put_user(0, uaddr);
> +	while (uaddr <= end) {
> +		ret = __put_user(0, uaddr);
> +		if (ret != 0)
> +			return ret;
> +		uaddr += PAGE_SIZE;
> +	}

The callsites in filemap.c are pretty hot paths, which is why this
thing remains explicitly inlined.  I think it would be worth adding a
bit of code here to avoid adding a pointless test-n-branch and larger
cache footprint to read() and write().

A way of doing that is to add another argument to these functions, say
"bool multipage".  Change the code to do

	if (multipage) {
		while (uaddr <= end) {
			...
		}
	}

and change the callsites to pass in constant "true" or "false".  Then
compile it up and manually check that the compiler completely removed
the offending code from the filemap.c callsites.

Wanna have a think about that?  If it all looks OK then please be sure
to add code comments explaining why we did this.

>  	if (ret == 0) {
> -		char __user *end = uaddr + size - 1;
> -
>  		/*
>  		 * If the page was already mapped, this will get a cache miss
>  		 * for sure, so try to avoid doing it.
>  		 */
> -		if (((unsigned long)uaddr & PAGE_MASK) !=
> +		if (((unsigned long)uaddr & PAGE_MASK) ==
>  				((unsigned long)end & PAGE_MASK))

Maybe I'm having a dim day, but I don't immediately see why != got
turned into ==.


Once we have this settled I'd suggest that the patch be carried in
whatever-git-tree-needs-it.
