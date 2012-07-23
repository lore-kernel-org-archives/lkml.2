Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab2GWB5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:57:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54232 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753306Ab2GWBm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:59 -0400
Message-Id: <20120723010702.097482977@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>
Subject: [ 070/108] pnfs-obj: dont leak objio_state if ore_write/read fails
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 9909d45a8557455ca5f8ee7af0f253debc851f1a upstream.

[Bug since 3.2 Kernel]
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/objlayout/objio_osd.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/objlayout/objio_osd.c b/fs/nfs/objlayout/objio_osd.c
index b47277b..86d7595 100644
--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -454,7 +454,10 @@ int objio_read_pagelist(struct nfs_read_data *rdata)
 	objios->ios->done = _read_done;
 	dprintk("%s: offset=0x%llx length=0x%x\n", __func__,
 		rdata->args.offset, rdata->args.count);
-	return ore_read(objios->ios);
+	ret = ore_read(objios->ios);
+	if (unlikely(ret))
+		objio_free_result(&objios->oir);
+	return ret;
 }
 
 /*
@@ -539,8 +542,10 @@ int objio_write_pagelist(struct nfs_write_data *wdata, int how)
 	dprintk("%s: offset=0x%llx length=0x%x\n", __func__,
 		wdata->args.offset, wdata->args.count);
 	ret = ore_write(objios->ios);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		objio_free_result(&objios->oir);
 		return ret;
+	}
 
 	if (objios->sync)
 		_write_done(objios->ios, objios);


