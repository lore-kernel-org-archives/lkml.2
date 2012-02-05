Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2BEWtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:49:31 -0500
Received: from 1wt.eu ([62.212.114.60]:61834 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab2BEW0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:11 -0500
Message-Id: <20120205220950.003970410@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:02 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Timo Warns <warns@pre-sense.de>, Eugene Teo <eugeneteo@kernel.sg>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        Richard Russon <rich@flatcap.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 13/91] fs/partitions/ldm.c: fix oops caused by corrupted partition table
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit c340b1d640001c8c9ecff74f68fd90422ae2448a upstream.

The kernel automatically evaluates partition tables of storage devices.
The code for evaluating LDM partitions (in fs/partitions/ldm.c) contains
a bug that causes a kernel oops on certain corrupted LDM partitions.
A kernel subsystem seems to crash, because, after the oops, the kernel no
longer recognizes newly connected storage devices.

The patch validates the value of vblk_size.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Timo Warns <warns@pre-sense.de>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Richard Russon <rich@flatcap.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/partitions/ldm.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

Index: longterm-2.6.27/fs/partitions/ldm.c
===================================================================
--- longterm-2.6.27.orig/fs/partitions/ldm.c	2012-02-05 22:34:34.635914935 +0100
+++ longterm-2.6.27/fs/partitions/ldm.c	2012-02-05 22:34:36.759915873 +0100
@@ -1299,6 +1299,11 @@
 
 	BUG_ON (!data || !frags);
 
+	if (size < 2 * VBLK_SIZE_HEAD) {
+		ldm_error("Value of size is to small.");
+		return false;
+	}
+
 	group = get_unaligned_be32(data + 0x08);
 	rec   = get_unaligned_be16(data + 0x0C);
 	num   = get_unaligned_be16(data + 0x0E);
@@ -1306,6 +1311,10 @@
 		ldm_error ("A VBLK claims to have %d parts.", num);
 		return false;
 	}
+	if (rec >= num) {
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, num);
+		return false;
+	}
 
 	list_for_each (item, frags) {
 		f = list_entry (item, struct frag, list);
@@ -1334,10 +1343,9 @@
 
 	f->map |= (1 << rec);
 
-	if (num > 0) {
-		data += VBLK_SIZE_HEAD;
-		size -= VBLK_SIZE_HEAD;
-	}
+	data += VBLK_SIZE_HEAD;
+	size -= VBLK_SIZE_HEAD;
+
 	memcpy (f->data+rec*(size-VBLK_SIZE_HEAD)+VBLK_SIZE_HEAD, data, size);
 
 	return true;


