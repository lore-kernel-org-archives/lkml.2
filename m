Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab2CTSd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:33:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab2CTSd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:33:27 -0400
Message-ID: <4F68CD55.4040606@redhat.com>
Date: Tue, 20 Mar 2012 14:32:53 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, hughd@google.com
Subject: Re: [PATCH -mm 2/2] mm: do not reset mm->free_area_cache on every
 single munmap
References: <20120223145417.261225fd@cuia.bos.redhat.com> <20120223150034.2c757b3a@cuia.bos.redhat.com> <20120223135614.7c4e02db.akpm@linux-foundation.org>
In-Reply-To: <20120223135614.7c4e02db.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 04:56 PM, Andrew Morton wrote:

> We've been playing whack-a-mole with this search for many years.  What
> about developing a proper data structure with which to locate a
> suitable-sized hole in O(log(N)) time?

I got around to looking at this, and the more I look, the
worse things get.  The obvious (and probably highest
reasonable complexity) solution looks like this:

struct free_area {
	unsigned long address;
	struct rb_node rb_addr;
	unsigned long size;
	struct rb_node rb_size;
};

This works in a fairly obvious way for normal mmap
and munmap calls, inserting the free area into the tree
at the desired location, or expanding one that is already
there.

However, it totally falls apart when we need to get
aligned areas, for eg. hugetlb or cache coloring on
architectures with virtually indexed caches.

For those kinds of allocations, we are back to tree
walking just like today, giving us a fairly large amount
of additional complexity for no obvious gain.

Is this really the path we want to go down?

-- 
All rights reversed
