Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2HNAXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 20:23:06 -0400
Received: from ozlabs.org ([203.10.76.45]:42934 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813Ab2HNAXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 20:23:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 2/4] virtio_balloon: introduce migration primitives to balloon pages
In-Reply-To: <20120813084123.GF14081@redhat.com>
References: <cover.1344619987.git.aquini@redhat.com> <f19b63dfa026fe2f8f11ec017771161775744781.1344619987.git.aquini@redhat.com> <20120813084123.GF14081@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 14 Aug 2012 09:29:49 +0930
Message-ID: <87lihis5qi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2012 11:41:23 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Fri, Aug 10, 2012 at 02:55:15PM -0300, Rafael Aquini wrote:
> > +/*
> > + * Populate balloon_mapping->a_ops->freepage method to help compaction on
> > + * re-inserting an isolated page into the balloon page list.
> > + */
> > +void virtballoon_putbackpage(struct page *page)
> > +{
> > +	spin_lock(&pages_lock);
> > +	list_add(&page->lru, &vb_ptr->pages);
> > +	spin_unlock(&pages_lock);
> 
> Could the following race trigger:
> migration happens while module unloading is in progress,
> module goes away between here and when the function
> returns, then code for this function gets overwritten?
> If yes we need locking external to module to prevent this.
> Maybe add a spinlock to struct address_space?

The balloon module cannot be unloaded until it has leaked all its pages,
so I think this is safe:

        static void remove_common(struct virtio_balloon *vb)
        {
        	/* There might be pages left in the balloon: free them. */
        	while (vb->num_pages)
        		leak_balloon(vb, vb->num_pages);

Cheers,
Rusty.
