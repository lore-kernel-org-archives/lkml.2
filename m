Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab1DZVW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:22:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab1DZVOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483763"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: tailai.ly@taobao.com, jaxboe@fusionio.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [83/106] block, blk-sysfs: Fix an err return path in blk_register_queue()
Message-Id: <20110426211405.171283E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Liu Yuan <tailai.ly@taobao.com>

commit ed5302d3c25006a9edc7a7fbea97a30483f89ef7 upstream.

We do not call blk_trace_remove_sysfs() in err return path
if kobject_add() fails. This path fixes it.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 block/blk-sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/block/blk-sysfs.c
===================================================================
--- linux-2.6.35.y.orig/block/blk-sysfs.c
+++ linux-2.6.35.y/block/blk-sysfs.c
@@ -502,8 +502,10 @@ int blk_register_queue(struct gendisk *d
 		return ret;
 
 	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj), "%s", "queue");
-	if (ret < 0)
+	if (ret < 0) {
+		blk_trace_remove_sysfs(dev);
 		return ret;
+	}
 
 	kobject_uevent(&q->kobj, KOBJ_ADD);
 
