Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab1CUXwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:52:47 -0400
Received: from kroah.org ([198.145.64.141]:49256 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710Ab1CUXPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:10 2011
Message-Id: <20110321230710.297619611@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@oracle.com>
Subject: [11/87] Btrfs: deal with short returns from copy_from_user
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Mason <chris.mason@oracle.com>

commit 31339acd07b4ba687906702085127895a56eb920 upstream.

When copy_from_user is only able to copy some of the bytes we requested,
we may end up creating a partially up to date page.  To avoid garbage in
the page, we need to treat a partial copy as a zero length copy.

This makes the rest of the file_write code drop the page and
retry the whole copy instead of marking the partially up to
date page as dirty.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/file.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -69,6 +69,19 @@ static noinline int btrfs_copy_from_user
 
 		/* Flush processor's dcache for this page */
 		flush_dcache_page(page);
+
+		/*
+		 * if we get a partial write, we can end up with
+		 * partially up to date pages.  These add
+		 * a lot of complexity, so make sure they don't
+		 * happen by forcing this copy to be retried.
+		 *
+		 * The rest of the btrfs_file_write code will fall
+		 * back to page at a time copies after we return 0.
+		 */
+		if (!PageUptodate(page) && copied < count)
+			copied = 0;
+
 		iov_iter_advance(i, copied);
 		write_bytes -= copied;
 		total_copied += copied;


