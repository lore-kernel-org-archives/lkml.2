Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2AJCeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 21:34:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab2AJCeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 21:34:36 -0500
Date: Mon, 9 Jan 2012 21:31:56 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        akpm@linux-foundation.org, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com,
        aarcange@redhat.com
Subject: [PATCH -mm 0/2] kswapd vs compaction improvements
Message-ID: <20120109213156.0ff47ee5@annuminas.surriel.com>
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
