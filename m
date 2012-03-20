Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab2CTTGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 15:06:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827Ab2CTTGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 15:06:40 -0400
Message-ID: <4F68D51B.7030501@redhat.com>
Date: Tue, 20 Mar 2012 15:06:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, hughd@google.com
Subject: Re: [PATCH -mm 2/2] mm: do not reset mm->free_area_cache on every
 single munmap
References: <20120223145417.261225fd@cuia.bos.redhat.com> <20120223150034.2c757b3a@cuia.bos.redhat.com> <20120223135614.7c4e02db.akpm@linux-foundation.org> <20120320190055.GZ24602@redhat.com>
In-Reply-To: <20120320190055.GZ24602@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 03:00 PM, Andrea Arcangeli wrote:
> On Thu, Feb 23, 2012 at 01:56:14PM -0800, Andrew Morton wrote:
>> We've been playing whack-a-mole with this search for many years.  What
>> about developing a proper data structure with which to locate a
>> suitable-sized hole in O(log(N)) time?
>
> I intended to implement it a couple of years ago.
>
> It takes a change to the rbtree code so that when rb_erase and
> rb_insert_color are called, proper methods are called to notify the
> caller that there's been a rotation (probably calling a new
> rb_insert_color_with_metadata(&method(left_rot, right_rot)) )

There are two issues here.

1) We also need the ability to search by address, so we can
    merge free areas that are adjacent.

2) Hugetlb, shared mappings on architectures with virtually
    indexed caches (eg. MIPS) need holes that are not only of
    a certain size, but also fit a certain alignment.

To get (2) we are essentially back to tree walking. I am not
convinced that that is a lot better than what we are doing
today, or worth the extra complexity...

-- 
All rights reversed
