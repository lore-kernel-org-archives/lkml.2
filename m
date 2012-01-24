Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab2AXCmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:42:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2AXCmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:42:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:25 2012
Message-Id: <20120124023925.693167535@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [020/129] pnfs-obj: pNFS errors are communicated on iodata->pnfs_error
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1318
Lines: 43

From: Boaz Harrosh <bharrosh@panasas.com>

commit 5c0b4129c07b902b27d3f3ebc087757f534a3abd upstream.

Some time along the way pNFS IO errors were switched to
communicate with a special iodata->pnfs_error member instead
of the regular RPC members. But objlayout was not switched
over.

Fix that!
Without this fix any IO error is hanged, because IO is not
switched to MDS and pages are never cleared or read.

[Applies to 3.2.0. Same bug different patch for 3.1/0 Kernels]
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/objlayout/objlayout.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfs/objlayout/objlayout.c
+++ b/fs/nfs/objlayout/objlayout.c
@@ -254,6 +254,8 @@ objlayout_read_done(struct objlayout_io_
 	oir->status = rdata->task.tk_status = status;
 	if (status >= 0)
 		rdata->res.count = status;
+	else
+		rdata->pnfs_error = status;
 	objlayout_iodone(oir);
 	/* must not use oir after this point */
 
@@ -334,6 +336,8 @@ objlayout_write_done(struct objlayout_io
 	if (status >= 0) {
 		wdata->res.count = status;
 		wdata->verf.committed = oir->committed;
+	} else {
+		wdata->pnfs_error = status;
 	}
 	objlayout_iodone(oir);
 	/* must not use oir after this point */


