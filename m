Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0K3RPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:15:40 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46829 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab0K3RPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:15:39 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Simon Kirby <sim@hostway.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [RFC PATCH 0/3] Prevent kswapd dumping excessive amounts of memory in response to high-order allocations
Date: Tue, 30 Nov 2010 17:15:36 +0000
Message-Id: <1291137339-6323-1-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Kirby reported the following problem

   We're seeing cases on a number of servers where cache never fully
   grows to use all available memory.  Sometimes we see servers with 4
   GB of memory that never seem to have less than 1.5 GB free, even with
   a constantly-active VM.  In some cases, these servers also swap out
   while this happens, even though they are constantly reading the working
   set into memory.  We have been seeing this happening for a long time;
   I don't think it's anything recent, and it still happens on 2.6.36.

After some debugging work by Simon, Dave Hansen and others, the prevaling
theory became that kswapd is reclaiming order-3 pages requested by SLUB
too aggressive about it.

There are two apparent problems here. On the target machine, there is a small
Normal zone in comparison to DMA32. As kswapd tries to balance all zones, it
would continually try reclaiming for Normal even though DMA32 was balanced
enough for callers. The second problem is that sleeping_prematurely() uses
the requested order, not the order kswapd finally reclaimed at. This keeps
kswapd artifically awake.

This series aims to alleviate these problems but needs testing to confirm
it alleviates the actual problem and wider review to think if there is a
better alternative approach. Local tests passed but are not reproducing
the same problem unfortunately so the results are inclusive.

 include/linux/mmzone.h |    3 +-
 mm/page_alloc.c        |    2 +-
 mm/vmscan.c            |   90 ++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 79 insertions(+), 16 deletions(-)

