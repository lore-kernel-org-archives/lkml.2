Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2GWBnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:43:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54300 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab2GWBnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:09 -0400
Message-Id: <20120723010701.599448834@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>,
        Iwo Mergler <Iwo.Mergler@netcommwireless.com>,
        James Nute <newten82@gmail.com>
Subject: [ 067/108] UBIFS: fix a bug in empty space fix-up
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>

commit c6727932cfdb13501108b16c38463c09d5ec7a74 upstream.

UBIFS has a feature called "empty space fix-up" which is a quirk to work-around
limitations of dumb flasher programs. Namely, of those flashers that are unable
to skip NAND pages full of 0xFFs while flashing, resulting in empty space at
the end of half-filled eraseblocks to be unusable for UBIFS. This feature is
relatively new (introduced in v3.0).

The fix-up routine (fixup_free_space()) is executed only once at the very first
mount if the superblock has the 'space_fixup' flag set (can be done with -F
option of mkfs.ubifs). It basically reads all the UBIFS data and metadata and
writes it back to the same LEB. The routine assumes the image is pristine and
does not have anything in the journal.

There was a bug in 'fixup_free_space()' where it fixed up the log incorrectly.
All but one LEB of the log of a pristine file-system are empty. And one
contains just a commit start node. And 'fixup_free_space()' just unmapped this
LEB, which resulted in wiping the commit start node. As a result, some users
were unable to mount the file-system next time with the following symptom:

UBIFS error (pid 1): replay_log_leb: first log node at LEB 3:0 is not CS node
UBIFS error (pid 1): replay_log_leb: log error detected while replaying the log at LEB 3:0

The root-cause of this bug was that 'fixup_free_space()' wrongly assumed
that the beginning of empty space in the log head (c->lhead_offs) was known
on mount. However, it is not the case - it was always 0. UBIFS does not store
in it the master node and finds out by scanning the log on every mount.

The fix is simple - just pass commit start node size instead of 0 to
'fixup_leb()'.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
Reported-by: Iwo Mergler <Iwo.Mergler@netcommwireless.com>
Tested-by: Iwo Mergler <Iwo.Mergler@netcommwireless.com>
Reported-by: James Nute <newten82@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ubifs/sb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index ef3d1ba..15e2fc5 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -718,8 +718,12 @@ static int fixup_free_space(struct ubifs_info *c)
 		lnum = ubifs_next_log_lnum(c, lnum);
 	}
 
-	/* Fixup the current log head */
-	err = fixup_leb(c, c->lhead_lnum, c->lhead_offs);
+	/*
+	 * Fixup the log head which contains the only a CS node at the
+	 * beginning.
+	 */
+	err = fixup_leb(c, c->lhead_lnum,
+			ALIGN(UBIFS_CS_NODE_SZ, c->min_io_size));
 	if (err)
 		goto out;
 


