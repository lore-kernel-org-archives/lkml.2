Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab2AWXur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:50:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab2AWXun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:50:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:29 2012
Message-Id: <20120123234029.752573739@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:40:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [80/90] pnfs-obj: pNFS errors are communicated on iodata->pnfs_error
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 5c0b4129c07b902b27d3f3ebc087757f534a3abd upstream.

Some time along the way pNFS IO errors were switched to
communicate with a special iodata->pnfs_error member instead
of the regular RPC members. But objlayout was not switched
over.

Fix that!
Without this fix any IO error is hanged, because IO is not
switched to MDS and pages are never cleared or read.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/nfs/objlayout/objlayout.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/nfs/objlayout/objlayout.c
+++ b/fs/nfs/objlayout/objlayout.c
@@ -294,9 +294,11 @@ objlayout_read_done(struct objlayout_io_
 	dprintk("%s: Begin status=%zd eof=%d\n", __func__, status, eof);
 	rdata = state->rpcdata;
 	rdata->task.tk_status = status;
-	if (status >= 0) {
+	if (likely(status >= 0)) {
 		rdata->res.count = status;
 		rdata->res.eof = eof;
+	} else {
+		rdata->pnfs_error = status;
 	}
 	objlayout_iodone(state);
 	/* must not use state after this point */
@@ -380,15 +382,17 @@ objlayout_write_done(struct objlayout_io
 	wdata = state->rpcdata;
 	state->status = status;
 	wdata->task.tk_status = status;
-	if (status >= 0) {
+	if (likely(status >= 0)) {
 		wdata->res.count = status;
 		wdata->verf.committed = state->committed;
 		dprintk("%s: Return status %d committed %d\n",
 			__func__, wdata->task.tk_status,
 			wdata->verf.committed);
-	} else
+	} else {
+		wdata->pnfs_error = status;
 		dprintk("%s: Return status %d\n",
 			__func__, wdata->task.tk_status);
+	}
 	objlayout_iodone(state);
 	/* must not use state after this point */
 


