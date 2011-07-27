Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab1G0Ahd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:37:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:48912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab1G0AfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="34855850"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: Warns@pre-sense.de, warns@pre-sense.de, eugeneteo@kernel.sg,
        harvey.harrison@gmail.com, rich@flatcap.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [30/98] fs/partitions/ldm.c: fix oops caused by corrupted partition table
Message-Id: <20110727003522.7EB712403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Timo Warns <Warns@pre-sense.de>

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/partitions/ldm.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/fs/partitions/ldm.c
===================================================================
--- linux-2.6.35.y.orig/fs/partitions/ldm.c
+++ linux-2.6.35.y/fs/partitions/ldm.c
@@ -1299,6 +1299,11 @@ static bool ldm_frag_add (const u8 *data
 
 	BUG_ON (!data || !frags);
 
+	if (size < 2 * VBLK_SIZE_HEAD) {
+		ldm_error("Value of size is to small.");
+		return false;
+	}
+
 	group = get_unaligned_be32(data + 0x08);
 	rec   = get_unaligned_be16(data + 0x0C);
 	num   = get_unaligned_be16(data + 0x0E);
@@ -1306,6 +1311,10 @@ static bool ldm_frag_add (const u8 *data
 		ldm_error ("A VBLK claims to have %d parts.", num);
 		return false;
 	}
+	if (rec >= num) {
+		ldm_error("REC value (%d) exceeds NUM value (%d)", rec, num);
+		return false;
+	}
 
 	list_for_each (item, frags) {
 		f = list_entry (item, struct frag, list);
@@ -1334,10 +1343,9 @@ found:
 
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
