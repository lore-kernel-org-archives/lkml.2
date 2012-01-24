Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab2AXSYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:24:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab2AXSYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:24:11 -0500
Date: Tue, 24 Jan 2012 13:18:22 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: [PATCH v2 -mm 0/3] kswapd vs compaction improvements
Message-ID: <20120124131822.4dc03524@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a kernel with compaction enabled with some memory pressure has
caused my system to run into all kinds of trouble.

One of the more obvious problems is that while kswapd does not try to 
free contiguous pages when CONFIG_COMPACTION is enabled, it does
continue reclaiming until enough contiguous pages have become available.
This can lead to enormous swap storms, where lots of memory is freed
and a fair amount of the working set can end up in swap.

A second problem is that memory compaction currently does nothing for
network allocations in the receive path, for eg. jumbo frames, because
those are done in interrupt context.  In the past we have tried to
have kswapd invoke memory compaction, but it used too much CPU time.
The second patch in this series has kswapd invoke compaction very
carefully, taking in account the desired page order, as well as
zone->compaction_deferred.

I have tested these patches on my system, and things seem to behave
well. Any tests and reviews would be appreciated.
