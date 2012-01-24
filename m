Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab2AXCnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:43:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329Ab2AXCn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:43:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:26 2012
Message-Id: <20120124023926.592942726@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [030/129] UBI: fix use-after-free on error path
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1374
Lines: 46

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit e57e0d8e818512047fe379157c3f77f1b9fabffb upstream.

When we fail to erase a PEB, we free the corresponding erase entry object,
but then re-schedule this object if the error code was something like -EAGAIN.
Obviously, it is a bug to use the object after we have freed it.

Reported-by: Emese Revfy <re.emese@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ubi/wl.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1052,7 +1052,6 @@ static int erase_worker(struct ubi_devic
 
 	ubi_err("failed to erase PEB %d, error %d", pnum, err);
 	kfree(wl_wrk);
-	kmem_cache_free(ubi_wl_entry_slab, e);
 
 	if (err == -EINTR || err == -ENOMEM || err == -EAGAIN ||
 	    err == -EBUSY) {
@@ -1065,14 +1064,16 @@ static int erase_worker(struct ubi_devic
 			goto out_ro;
 		}
 		return err;
-	} else if (err != -EIO) {
+	}
+
+	kmem_cache_free(ubi_wl_entry_slab, e);
+	if (err != -EIO)
 		/*
 		 * If this is not %-EIO, we have no idea what to do. Scheduling
 		 * this physical eraseblock for erasure again would cause
 		 * errors again and again. Well, lets switch to R/O mode.
 		 */
 		goto out_ro;
-	}
 
 	/* It is %-EIO, the PEB went bad */
 


