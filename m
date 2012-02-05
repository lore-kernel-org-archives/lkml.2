Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2BEW01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:27 -0500
Received: from 1wt.eu ([62.212.114.60]:61901 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab2BEW0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:24 -0500
Message-Id: <20120205220950.684814014@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:18 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>, Jens Axboe <jaxboe@fusionio.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 29/91] cfq-iosched: fix a rcu warning
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 3181faa85bda3dc3f5e630a1846526c9caaa38e3 upstream.

I got a rcu warnning at boot. the ioc->ioc_data is rcu_deferenced, but
doesn't hold rcu_read_lock.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/cfq-iosched.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/block/cfq-iosched.c
===================================================================
--- longterm-2.6.27.orig/block/cfq-iosched.c	2012-02-05 22:34:38.850917663 +0100
+++ longterm-2.6.27/block/cfq-iosched.c	2012-02-05 22:34:38.987917155 +0100
@@ -1286,11 +1286,14 @@
 	cic->dead_key = (unsigned long) cic->key;
 	cic->key = NULL;
 
+	rcu_read_lock();
 	if (rcu_dereference(ioc->ioc_data) == cic) {
+		rcu_read_unlock();
 		spin_lock(&ioc->lock);
 		rcu_assign_pointer(ioc->ioc_data, NULL);
 		spin_unlock(&ioc->lock);
-	}
+	} else
+		rcu_read_unlock();
 
 	if (cic->cfqq[ASYNC]) {
 		cfq_exit_cfqq(cfqd, cic->cfqq[ASYNC]);


