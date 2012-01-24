Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab2AXCqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:46:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab2AXCqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:46:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:31 2012
Message-Id: <20120124023930.952166207@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peng Tao <peng_tao@emc.com>,
        Benny Halevy <bhalevy@tonian.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [079/129] pnfsblock: limit bio page count
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1277
Lines: 45

From: Peng Tao <bergwolf@gmail.com>

commit 74a6eeb44ca6174d9cc93b9b8b4d58211c57bc80 upstream.

One bio can have at most BIO_MAX_PAGES pages. We should limit it bec otherwise
bio_alloc will fail when there are many pages in one read/write_pagelist.

Signed-off-by: Peng Tao <peng_tao@emc.com>
Signed-off-by: Benny Halevy <bhalevy@tonian.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/blocklayout/blocklayout.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -146,14 +146,19 @@ static struct bio *bl_alloc_init_bio(int
 {
 	struct bio *bio;
 
+	npg = min(npg, BIO_MAX_PAGES);
 	bio = bio_alloc(GFP_NOIO, npg);
-	if (!bio)
-		return NULL;
+	if (!bio && (current->flags & PF_MEMALLOC)) {
+		while (!bio && (npg /= 2))
+			bio = bio_alloc(GFP_NOIO, npg);
+	}
 
-	bio->bi_sector = isect - be->be_f_offset + be->be_v_offset;
-	bio->bi_bdev = be->be_mdev;
-	bio->bi_end_io = end_io;
-	bio->bi_private = par;
+	if (bio) {
+		bio->bi_sector = isect - be->be_f_offset + be->be_v_offset;
+		bio->bi_bdev = be->be_mdev;
+		bio->bi_end_io = end_io;
+		bio->bi_private = par;
+	}
 	return bio;
 }
 


