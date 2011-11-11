Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab1KKL3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:29:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39201 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab1KKL3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:29:11 -0500
Message-ID: <4EBD0703.3090706@openvz.org>
Date: Fri, 11 Nov 2011 15:29:07 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111010 Iceape/2.0.14
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH v2] mm: add free_hot_cold_page_list helper
References: <20110729075837.12274.58405.stgit@localhost6> <20111101074502.32668.93131.stgit@zurg> <alpine.LSU.2.00.1111101810420.1239@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1111101810420.1239@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Tue, 1 Nov 2011, Konstantin Khlebnikov wrote:
>
>> This patch adds helper free_hot_cold_page_list() to free list of 0-order pages.
>> It frees pages directly from the list without temporary page-vector.
>> It also calls trace_mm_pagevec_free() to simulate pagevec_free() behaviour.
>
> Sorry for not speaking up sooner, but I do like this patch very much
> (and I'm content with your trace compatibility choice - whatever).
>
> Not so much in itself, but because it then allows a further patch
> (mainly to mm/vmscan.c) to remove two levels of pagevec, reducing
> its deepest stack by around 240 bytes.

That's Great. Also I don't like pagevec-based free because we sometimes do
extra lru lock-unlock on vector overflow.

>
> I have that patch, but keep putting off sending it in, because I want
> to show a reclaim stack overflow that it prevents, but the new avoidance
> of writeback in direct reclaim makes that harder to demonstrate.  Damn!
>
> One question on your patch: where you have release_pages() doing
>> +		list_add_tail(&page->lru,&pages_to_free);
>
> That seems reasonable, but given that __pagevec_free() proceeds by
> 	while (--i>= 0) {
> , starting from the far end of the pagevec (the most recently added
> struct page, the most likely to be hot), wouldn't you reproduce
> existing behaviour more accurately by a simple list_add()?
>
> Or have I got that back to front?  If so, a comment on the
> list_add_tail() would help me to remember why - thanks.
>
> Hugh

Ok, this reasonable. Any way, the second its user: shrink_page_list() puts pages at the front.

