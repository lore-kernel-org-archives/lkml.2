Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2KHAB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 19:01:26 -0500
Received: from ozlabs.org ([203.10.76.45]:35981 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738Ab2KHABW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 19:01:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, aquini@redhat.com
Subject: Re: [PATCH v11 5/7] virtio_balloon: introduce migration primitives to balloon pages
In-Reply-To: <265aaff9a79f503672f0cdcdff204114b5b5ba5b.1352256088.git.aquini@redhat.com>
References: <cover.1352256081.git.aquini@redhat.com> <265aaff9a79f503672f0cdcdff204114b5b5ba5b.1352256088.git.aquini@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 08 Nov 2012 09:32:18 +1030
Message-ID: <87625h3tl1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael Aquini <aquini@redhat.com> writes:
> + * virtballoon_migratepage - perform the balloon page migration on behalf of
> + *			     a compation thread.     (called under page lock)

> +	if (!mutex_trylock(&vb->balloon_lock))
> +		return -EAGAIN;

Erk, OK...

> +	/* balloon's page migration 1st step  -- inflate "newpage" */
> +	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
> +	balloon_page_insert(newpage, mapping, &vb_dev_info->pages);
> +	vb_dev_info->isolated_pages--;
> +	spin_unlock_irqrestore(&vb_dev_info->pages_lock, flags);
> +	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
> +	set_page_pfns(vb->pfns, newpage);
> +	tell_host(vb, vb->inflate_vq);

tell_host does wait_event(), so you can't call it under the page_lock.
Right?

You probably get away with it because current qemu will service you
immediately.  You could spin here in this case for the moment.

There's a second call to tell_host():

> +	/*
> +	 * balloon's page migration 2nd step -- deflate "page"
> +	 *
> +	 * It's safe to delete page->lru here because this page is at
> +	 * an isolated migration list, and this step is expected to happen here
> +	 */
> +	balloon_page_delete(page);
> +	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
> +	set_page_pfns(vb->pfns, page);
> +	tell_host(vb, vb->deflate_vq);

The first one can be delayed, the second one can be delayed if the host
didn't ask for VIRTIO_BALLOON_F_MUST_TELL_HOST (qemu doesn't).

We could implement a proper request queue for these, and return -EAGAIN
if the queue fills.  Though in practice, it's not important (it might
help performance).

Cheers,
Rusty.
