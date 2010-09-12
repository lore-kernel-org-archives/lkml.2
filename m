Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0ILPz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:55:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:32253 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0ILPzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:55:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,355,1280732400"; 
   d="scan'208";a="553787496"
Message-Id: <20100912154945.758129106@intel.com>
User-Agent: quilt/0.48-1
Date: Sun, 12 Sep 2010 23:49:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Dave Chinner <david@fromorbit.com>
CC: Jan Kara <jack@suse.cz>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Mel Gorman <mel@csn.ul.ie>
CC: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Chris Mason <chris.mason@oracle.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Li Shaohua <shaohua.li@intel.com>
CC: Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 00/17] [RFC] soft and dynamic dirty throttling limits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic idea is to introduce a small region under the bdi dirty threshold.
The task will be throttled gently when stepping into the bottom of region,
and get throttled more and more aggressively as bdi dirty+writeback pages
goes up closer to the top of region. At some point the application will be
throttled at the right bandwidth that balances with the device write bandwidth.
(the 2nd patch has more details)

The first two patch groups introduce two building blocks..

    IO-less balance_dirty_pages()
	[PATCH 02/17] writeback: IO-less balance_dirty_pages()
	[PATCH 03/17] writeback: per-task rate limit to balance_dirty_pages()
	[PATCH 04/17] writeback: quit throttling when bdi dirty/writeback pages go down            
	[PATCH 05/17] writeback: quit throttling when signal pending
    (trace event)
	[PATCH 06/17] writeback: move task dirty fraction to balance_dirty_pages()
	[PATCH 07/17] writeback: add trace event for balance_dirty_pages()

    bandwidth estimation
	[PATCH 08/17] writeback: account per-bdi accumulated written pages
	[PATCH 09/17] writeback: bdi write bandwidth estimation
	[PATCH 10/17] writeback: show bdi write bandwidth in debugfs

..for use by the next two features:

    larger nr_to_write (hence IO size)
	[PATCH 11/17] writeback: make nr_to_write a per-file limit
	[PATCH 12/17] writeback: scale IO chunk size up to device bandwidth

    dynamic dirty pages limit
	[PATCH 14/17] vmscan: add scan_control.priority
	[PATCH 15/17] mm: lower soft dirty limits on memory pressure
	[PATCH 16/17] mm: create /vm/dirty_pressure in debugfs

The following two patches can be merged independently indeed.

    change of rules
	[PATCH 01/17] writeback: remove the internal 5% low bound on dirty_ratio
	[PATCH 13/17] writeback: reduce per-bdi dirty threshold ramp up time

And this cleanup reflects a late thought, it would better to be moved to the
beginning of the patch series..

    cleanup
	[PATCH 17/17] writeback: consolidate balance_dirty_pages() variable names


 fs/fs-writeback.c                |   49 ++++-
 include/linux/backing-dev.h      |    2
 include/linux/sched.h            |    7
 include/linux/writeback.h        |   17 +
 include/trace/events/writeback.h |   47 +++++
 mm/backing-dev.c                 |   29 +--
 mm/page-writeback.c              |  248 ++++++++++++++++-------------
 mm/vmscan.c                      |   22 ++
 mm/vmstat.c                      |   29 +++
 9 files changed, 311 insertions(+), 139 deletions(-)

Thanks,
Fengguang

