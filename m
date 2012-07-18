Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2GRWtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:49:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2GRWtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:49:10 -0400
Date: Wed, 18 Jul 2012 15:49:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>, Rafael Aquini <aquini@linux.com>
Subject: Re: [PATCH v4 2/3] virtio_balloon: introduce migration primitives
 to balloon pages
Message-Id: <20120718154908.14704344.akpm@linux-foundation.org>
In-Reply-To: <050e06731e0489867ed804387509e36d072507ec.1342485774.git.aquini@redhat.com>
References: <cover.1342485774.git.aquini@redhat.com>
	<050e06731e0489867ed804387509e36d072507ec.1342485774.git.aquini@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012 13:50:42 -0300
Rafael Aquini <aquini@redhat.com> wrote:

> Besides making balloon pages movable at allocation time and introducing
> the necessary primitives to perform balloon page migration/compaction,
> this patch also introduces the following locking scheme to provide the
> proper synchronization and protection for struct virtio_balloon elements
> against concurrent accesses due to parallel operations introduced by
> memory compaction / page migration.
>  - balloon_lock (mutex) : synchronizes the access demand to elements of
> 			  struct virtio_balloon and its queue operations;
>  - pages_lock (spinlock): special protection to balloon pages list against
> 			  concurrent list handling operations;
> 
> ...
>
> +	balloon_mapping->a_ops = &virtio_balloon_aops;
> +	balloon_mapping->backing_dev_info = (void *)vb;

hoo boy.  We're making page->mapping->backing_dev_info point at a
struct which does not have type `struct backing_dev_info'.  And then we
are exposing that page to core MM functions.  So we're hoping that core
MM will never walk down page->mapping->backing_dev_info and explode.

That's nasty, hacky and fragile.
