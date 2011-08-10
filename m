Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1HJSIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:08:41 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:29561 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1HJSIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:08:40 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Aug 2011 14:08:40 EDT
Message-Id: <201108101803.p7AI36eV008484@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 10 Aug 2011 13:56:28 -0400
Subject: [PATCH] nfs: fix a couple of minor portability issues
To: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 10 Aug 2011 18:03:07.0197 (UTC) FILETIME=[C1E2CED0:01CC5787]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building on tilepro revealed two minor portability issues: the
blocklayout.c file used prefetchw() without #include <linux/prefetch.h>,
and the nfs4filelayout.c file used do_div() on an s64 not a u64.
This change fixes those two issues so the NFS code builds on tilepro.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 fs/nfs/blocklayout/blocklayout.c |    1 +
 fs/nfs/nfs4filelayout.c          |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index e56564d..9561c8f 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -36,6 +36,7 @@
 #include <linux/namei.h>
 #include <linux/bio.h>		/* struct bio */
 #include <linux/buffer_head.h>	/* various write calls */
+#include <linux/prefetch.h>
 
 #include "blocklayout.h"
 
diff --git a/fs/nfs/nfs4filelayout.c b/fs/nfs/nfs4filelayout.c
index e8915d4..6976a72 100644
--- a/fs/nfs/nfs4filelayout.c
+++ b/fs/nfs/nfs4filelayout.c
@@ -48,13 +48,13 @@ filelayout_get_dense_offset(struct nfs4_filelayout_segment *flseg,
 			    loff_t offset)
 {
 	u32 stripe_width = flseg->stripe_unit * flseg->dsaddr->stripe_count;
-	u64 tmp;
+	u64 tmp, uoff;
 
 	offset -= flseg->pattern_offset;
-	tmp = offset;
+	tmp = uoff = offset;
 	do_div(tmp, stripe_width);
 
-	return tmp * flseg->stripe_unit + do_div(offset, flseg->stripe_unit);
+	return tmp * flseg->stripe_unit + do_div(uoff, flseg->stripe_unit);
 }
 
 /* This function is used by the layout driver to calculate the
-- 
1.6.5.2

