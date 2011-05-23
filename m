Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1EWOzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab1EWOzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:55:42 -0400
Date: Mon, 23 May 2011 10:55:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] blk-cgroup: Initialize ioc->cgroup_changed at ioc creation
 time
Message-ID: <20110523145539.GA4019@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't explicitly initialize it to zero, CFQ might think that
cgroup of ioc has changed and it generates lots of unnecessary calls
to call_for_each_cic(changed_cgroup). Fix it.

cfq_get_io_context()
  cfq_ioc_set_cgroup()
     call_for_each_cic(ioc, changed_cgroup)

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-ioc.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6-block/block/blk-ioc.c
===================================================================
--- linux-2.6-block.orig/block/blk-ioc.c	2011-03-08 09:40:58.057296008 -0500
+++ linux-2.6-block/block/blk-ioc.c	2011-05-23 10:33:51.875994035 -0400
@@ -96,6 +96,9 @@ struct io_context *alloc_io_context(gfp_
 		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
 		INIT_HLIST_HEAD(&ret->cic_list);
 		ret->ioc_data = NULL;
+#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
+		ret->cgroup_changed = 0;
+#endif
 	}
 
 	return ret;
