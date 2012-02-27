Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2B0QNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:13:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab2B0QNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:13:17 -0500
Message-ID: <4F4BAB7A.4040809@redhat.com>
Date: Mon, 27 Feb 2012 11:12:42 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
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
> On Thu, 23 Feb 2012 15:00:34 -0500
> Rik van Riel<riel@redhat.com>  wrote:

>> The benefit is that things scale a lot better, and we remove about
>> 200 lines of code.
>
> We've been playing whack-a-mole with this search for many years.  What
> about developing a proper data structure with which to locate a
> suitable-sized hole in O(log(N)) time?

I have thought about this, and see a few different
possibilities:

1) Allocate a new (smaller) structure to keep track
    of free areas; this creates the possibility of
    munmap failing due to a memory allocation failure.
    It looks like it can already do that, but I do not
    like the idea of adding another failure path like
    it.

2) Use the vma_struct to keep track of free areas.
    Somewhat bloated, and may still not fix (1), because
    munmap can end up splitting a VMA.

I guess the free areas could be maintained in a prio tree,
sorted by both free area size and address, so we can fill
in the memory in the desired direction.

What I do not know is whether it will be worthwhile,
because the code I have now seems to behave well even
what is essentially a worst case scenario.

-- 
All rights reversed
