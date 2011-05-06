Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1EFBEe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:04:34 -0400
Received: from kroah.org ([198.145.64.141]:36549 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab1EFAYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:06 2011
Message-Id: <20110506002206.140798623@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:19:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [011/143] UBIFS: fix master node recovery
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 6e0d9fd38b750d678bf9fd07db23582f52fafa55 upstream.

This patch fixes the following symptoms:
1. Unmount UBIFS cleanly.
2. Start mounting UBIFS R/W and have a power cut immediately
3. Start mounting UBIFS R/O, this succeeds
4. Try to re-mount UBIFS R/W - this fails immediately or later on,
   because UBIFS will write the master node to the flash area
   which has been written before.

The analysis of the problem:

1. UBIFS is unmounted cleanly, both copies of the master node are clean.
2. UBIFS is being mounter R/W, starts changing master node copy 1, and
   a power cut happens. The copy N1 becomes corrupted.
3. UBIFS is being mounted R/O. It notices the copy N1 is corrupted and
   reads copy N2. Copy N2 is clean.
4. Because of R/O mode, UBIFS cannot recover copy 1.
5. The mount code (ubifs_mount()) sees that the master node is clean,
   so it decides that no recovery is needed.
6. We are re-mounting R/W. UBIFS believes no recovery is needed and
   starts updating the master node, but copy N1 is still corrupted
   and was not recovered!

Fix this problem by marking the master node as dirty every time we
recover it and we are in R/O mode. This forces further recovery and
the UBIFS cleans-up the corruptions and recovers the copy N1 when
re-mounting R/W later.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/recovery.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -299,6 +299,32 @@ int ubifs_recover_master_node(struct ubi
 			goto out_free;
 		}
 		memcpy(c->rcvrd_mst_node, c->mst_node, UBIFS_MST_NODE_SZ);
+
+		/*
+		 * We had to recover the master node, which means there was an
+		 * unclean reboot. However, it is possible that the master node
+		 * is clean at this point, i.e., %UBIFS_MST_DIRTY is not set.
+		 * E.g., consider the following chain of events:
+		 *
+		 * 1. UBIFS was cleanly unmounted, so the master node is clean
+		 * 2. UBIFS is being mounted R/W and starts changing the master
+		 *    node in the first (%UBIFS_MST_LNUM). A power cut happens,
+		 *    so this LEB ends up with some amount of garbage at the
+		 *    end.
+		 * 3. UBIFS is being mounted R/O. We reach this place and
+		 *    recover the master node from the second LEB
+		 *    (%UBIFS_MST_LNUM + 1). But we cannot update the media
+		 *    because we are being mounted R/O. We have to defer the
+		 *    operation.
+		 * 4. However, this master node (@c->mst_node) is marked as
+		 *    clean (since the step 1). And if we just return, the
+		 *    mount code will be confused and won't recover the master
+		 *    node when it is re-mounter R/W later.
+		 *
+		 *    Thus, to force the recovery by marking the master node as
+		 *    dirty.
+		 */
+		c->mst_node->flags |= cpu_to_le32(UBIFS_MST_DIRTY);
 	} else {
 		/* Write the recovered master node */
 		c->max_sqnum = le64_to_cpu(mst->ch.sqnum) - 1;


