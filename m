Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab2GZVVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:21:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55834 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab2GZVVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:21:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Boaz Harrosh <bharrosh@panasas.com>
Subject: [ 18/23] pnfs-obj: dont leak objio_state if ore_write/read fails
Date: Thu, 26 Jul 2012 14:19:57 -0700
Message-Id: <20120726211407.519257798@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211405.959857593@linuxfoundation.org>
References: <20120726211420.GA7678@kroah.com>
 <20120726211405.959857593@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit 9909d45a8557455ca5f8ee7af0f253debc851f1a upstream.

[Bug since 3.2 Kernel]
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/objlayout/objio_osd.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -453,7 +453,10 @@ int objio_read_pagelist(struct nfs_read_
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
@@ -537,8 +540,10 @@ int objio_write_pagelist(struct nfs_writ
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


