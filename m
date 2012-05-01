Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007Ab2EAV1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 17:27:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2EAV07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 17:26:59 -0400
Date: Tue, 1 May 2012 14:26:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] refault distance-based file cache sizing
Message-Id: <20120501142656.c9160d96.akpm@linux-foundation.org>
In-Reply-To: <4FA05354.8000304@redhat.com>
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
	<20120501120819.0af1e54b.akpm@linux-foundation.org>
	<4FA05354.8000304@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2012 17:19:16 -0400
Rik van Riel <riel@redhat.com> wrote:

> On 05/01/2012 03:08 PM, Andrew Morton wrote:
> > On Tue,  1 May 2012 10:41:48 +0200
> > Johannes Weiner<hannes@cmpxchg.org>  wrote:
> >
> >> This series stores file cache eviction information in the vacated page
> >> cache radix tree slots and uses it on refault to see if the pages
> >> currently on the active list need to have their status challenged.
> >
> > So we no longer free the radix-tree node when everything under it has
> > been reclaimed?  One could create workloads which would result in a
> > tremendous amount of memory used by radix_tree_node_cachep objects.
> >
> > So I assume these things get thrown away at some point.  Some
> > discussion about the life-cycle here would be useful.
> 
> I assume that in the current codebase Johannes has, we would
> have to rely on the inode cache shrinker to reclaim the inode
> and throw out the radix tree nodes.
> 
> Having a better way to deal with radix tree nodes that contain
> stale entries (where the evicted pages would no longer receive
> special treatment on re-fault, because it has been so long) get
> reclaimed would be nice for a future version.
> 

Well, think of a stupid workload which creates a large number of very
large but sparse files (populated with one page in each 64, for
example).  Get them all in cache, then sit there touching the inodes to
keep then fresh.  What's the worst case here?


