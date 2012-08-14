Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2HNIcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:32:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab2HNIci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:32:38 -0400
Date: Tue, 14 Aug 2012 11:33:20 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 2/4] virtio_balloon: introduce migration primitives to
 balloon pages
Message-ID: <20120814083320.GA3597@redhat.com>
References: <cover.1344619987.git.aquini@redhat.com>
 <f19b63dfa026fe2f8f11ec017771161775744781.1344619987.git.aquini@redhat.com>
 <20120813084123.GF14081@redhat.com>
 <87lihis5qi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lihis5qi.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 09:29:49AM +0930, Rusty Russell wrote:
> On Mon, 13 Aug 2012 11:41:23 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Fri, Aug 10, 2012 at 02:55:15PM -0300, Rafael Aquini wrote:
> > > +/*
> > > + * Populate balloon_mapping->a_ops->freepage method to help compaction on
> > > + * re-inserting an isolated page into the balloon page list.
> > > + */
> > > +void virtballoon_putbackpage(struct page *page)
> > > +{
> > > +	spin_lock(&pages_lock);
> > > +	list_add(&page->lru, &vb_ptr->pages);
> > > +	spin_unlock(&pages_lock);
> > 
> > Could the following race trigger:
> > migration happens while module unloading is in progress,
> > module goes away between here and when the function
> > returns, then code for this function gets overwritten?
> > If yes we need locking external to module to prevent this.
> > Maybe add a spinlock to struct address_space?
> 
> The balloon module cannot be unloaded until it has leaked all its pages,
> so I think this is safe:
> 
>         static void remove_common(struct virtio_balloon *vb)
>         {
>         	/* There might be pages left in the balloon: free them. */
>         	while (vb->num_pages)
>         		leak_balloon(vb, vb->num_pages);
> 
> Cheers,
> Rusty.

I know I meant something else.
Let me lay this out:

CPU1 executes:
void virtballoon_putbackpage(struct page *page)
{
	spin_lock(&pages_lock);
	list_add(&page->lru, &vb_ptr->pages);
	spin_unlock(&pages_lock);


		at this point CPU2 unloads module:
						leak_balloon
						......

		next CPU2 loads another module so code memory gets overwritten

now CPU1 executes the next instruction:

}

which would normally return to function's caller,
but it has been overwritten by CPU2 so we get corruption.

No?

-- 
MST
