Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab0FOBqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:46:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab0FOBqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:46:30 -0400
Date: Mon, 14 Jun 2010 18:45:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
Message-Id: <20100614184544.32b1c371.akpm@linux-foundation.org>
In-Reply-To: <4C16D46D.3020302@redhat.com>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie>
	<1276514273-27693-12-git-send-email-mel@csn.ul.ie>
	<20100614231144.GG6590@dastard>
	<20100614162143.04783749.akpm@linux-foundation.org>
	<20100615003943.GK6590@dastard>
	<4C16D46D.3020302@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 21:16:29 -0400 Rik van Riel <riel@redhat.com> wrote:

> Would it be hard to add a "please flush this file"
> way to call the filesystem flushing threads?

Passing the igrab()bed inode into the flusher threads would fix the
iput_final() problems, as long as the alloc_pages() caller never blocks
indefinitely waiting for the work which the flusher threads are doing. 

Otherwise we get (very hard-to-hit) deadlocks where the alloc_pages()
caller holds VFS locks and is waiting for the flusher threads while all
the flusher threads are stuck under iput_final() waiting for those VFS
locks.

That's fixable by not using igrab()/iput().  You can use lock_page() to
pin the address_space.  Pass the address of the locked page across to
the flusher threads so they don't try to lock it a second time, or just
use trylocking on that writeback path or whatever.

