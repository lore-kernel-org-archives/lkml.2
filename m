Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab1KKCbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 21:31:15 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60953 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1KKCbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 21:31:14 -0500
Date: Thu, 10 Nov 2011 18:31:05 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH v2] mm: add free_hot_cold_page_list helper
In-Reply-To: <20111101074502.32668.93131.stgit@zurg>
Message-ID: <alpine.LSU.2.00.1111101810420.1239@sister.anvils>
References: <20110729075837.12274.58405.stgit@localhost6> <20111101074502.32668.93131.stgit@zurg>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011, Konstantin Khlebnikov wrote:

> This patch adds helper free_hot_cold_page_list() to free list of 0-order pages.
> It frees pages directly from the list without temporary page-vector.
> It also calls trace_mm_pagevec_free() to simulate pagevec_free() behaviour.

Sorry for not speaking up sooner, but I do like this patch very much
(and I'm content with your trace compatibility choice - whatever).

Not so much in itself, but because it then allows a further patch
(mainly to mm/vmscan.c) to remove two levels of pagevec, reducing
its deepest stack by around 240 bytes.

I have that patch, but keep putting off sending it in, because I want
to show a reclaim stack overflow that it prevents, but the new avoidance
of writeback in direct reclaim makes that harder to demonstrate.  Damn!

One question on your patch: where you have release_pages() doing
> +		list_add_tail(&page->lru, &pages_to_free);

That seems reasonable, but given that __pagevec_free() proceeds by
	while (--i >= 0) {
, starting from the far end of the pagevec (the most recently added
struct page, the most likely to be hot), wouldn't you reproduce
existing behaviour more accurately by a simple list_add()?

Or have I got that back to front?  If so, a comment on the
list_add_tail() would help me to remember why - thanks.

Hugh
