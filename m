Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0LQLVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:21:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:22582 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177Ab0LQLVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:21:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,360,1288594800"; 
   d="scan'208";a="584664162"
Date: Fri, 17 Dec 2010 19:21:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] writeback: skip balance_dirty_pages() for in-memory fs
Message-ID: <20101217112111.GA8323@localhost>
References: <20101213144646.341970461@intel.com>
 <20101213150329.002158963@intel.com>
 <20101217021934.GA9525@localhost>
 <alpine.LSU.2.00.1012162239270.23229@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1012162239270.23229@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids unnecessary checks and dirty throttling on tmpfs/ramfs.

It also prevents

[  388.126563] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050

in the balance_dirty_pages tracepoint, which will call

	dev_name(mapping->backing_dev_info->dev)

but shmem_backing_dev_info.dev is NULL.

CC: Hugh Dickins <hughd@google.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2010-12-17 19:09:19.000000000 +0800
+++ linux-next/mm/page-writeback.c	2010-12-17 19:09:22.000000000 +0800
@@ -899,6 +899,9 @@ void balance_dirty_pages_ratelimited_nr(
 {
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 
+	if (!bdi_cap_account_dirty(bdi))
+		return;
+
 	current->nr_dirtied += nr_pages_dirtied;
 
 	if (unlikely(!current->nr_dirtied_pause))
