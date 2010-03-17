Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab0CQElv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:41:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59512 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab0CQElt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:41:49 -0400
Date: Wed, 17 Mar 2010 15:41:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sage Weil <sage@newdream.net>, NeilBrown <neilb@suse.de>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20100317154145.bd9fca16.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

fs/ceph/msgpool.c: In function 'ceph_msgpool_put':
fs/ceph/msgpool.c:173: error: implicit declaration of function 'kref_set'

Caused by commit 10c5d9fdc9ba89606b34f01cbe6ea287abba7395 ("kref: remove
kref_set") from the driver-core tree interacting with commit
c2e552e76e2c6907ca50cd9a4b747a2e2e8c615e ("ceph: use kref for ceph_msg")
from the ceph tree.

I applied the following patch for today (which may not be correct):

[Sage, if this patch is correct, it should be applied to the ceph tree.]

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 17 Mar 2010 15:35:22 +1100
Subject: [PATCH] ceph: update for removal of kref_set

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ceph/msgpool.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ceph/msgpool.c b/fs/ceph/msgpool.c
index ca3b44a..030297f 100644
--- a/fs/ceph/msgpool.c
+++ b/fs/ceph/msgpool.c
@@ -170,7 +170,7 @@ void ceph_msgpool_put(struct ceph_msgpool *pool, struct ceph_msg *msg)
 		msg->front.iov_len = pool->front_len;
 		msg->hdr.front_len = cpu_to_le32(pool->front_len);
 
-		kref_set(&msg->kref, 1);  /* retake a single ref */
+		kref_init(&msg->kref);  /* retake a single ref */
 		list_add(&msg->list_head, &pool->msgs);
 		pool->num++;
 		dout("msgpool_put %p reclaim %p, now %d/%d\n", pool, msg,
-- 
1.7.0

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
