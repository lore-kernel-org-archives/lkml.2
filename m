Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2ETM2L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 08:28:11 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:35785
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753353Ab2ETM2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 08:28:10 -0400
Date: Sun, 20 May 2012 14:28:07 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] UBIFS: add ksa_pos to replay buds, read when replaying
Message-ID: <alpine.DEB.2.00.1205201418170.27583@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch read the ksa_pos from data nodes to the replay buds when performing
a replay after unclean commit. This is critical for the correctness of the key
state map, because the keys that are assigned to uncommited data nodes will be
considered "unused" after mounting but will be considered "used" after
replaying. The ksa_pos values stored in the replay bud are passed to the TNC
using ubifs_tnc_add.

This was tested by assigning distinct ksa_pos values and disabling commiting.
Data was written and then the drive was remounted. The ksa_pos values were
read from the journal and outputted while replaying. When the file was later
read, it was confirmed that the ksa_pos values were already loaded into the
TNC.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/replay.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/replay.c b/fs/ubifs/replay.c
index 1fec6e2..1f02829 100644
--- a/fs/ubifs/replay.c
+++ b/fs/ubifs/replay.c
@@ -47,6 +47,7 @@
  * @nm: directory entry name
  * @old_size: truncation old size
  * @new_size: truncation new size
+ * @ksa_pos: the node's cryptographic key's position in the KSA
  *
  * The replay process first scans all buds and builds the replay list, then
  * sorts the replay list in nodes sequence number order, and then inserts all
@@ -67,6 +68,7 @@ struct replay_entry {
 			loff_t new_size;
 		};
 	};
+	long long ksa_pos;
 };

 /**
@@ -251,7 +253,7 @@ static int apply_replay_entry(struct ubifs_info *c, struct replay_entry *r)
 			}
 		else
 			err = ubifs_tnc_add(c, &r->key, r->lnum, r->offs,
-					    r->len, 0);
+					    r->len, r->ksa_pos);
 		if (err)
 			return err;

@@ -345,6 +347,7 @@ static void destroy_replay_list(struct ubifs_info *c)
  * @used: number of bytes in use in a LEB
  * @old_size: truncation old size
  * @new_size: truncation new size
+ * @ksa_pos: the node's cryptographic key's position in the KSA
  *
  * This function inserts a scanned non-direntry node to the replay list. The
  * replay list contains @struct replay_entry elements, and we sort this list in
@@ -356,7 +359,7 @@ static void destroy_replay_list(struct ubifs_info *c)
 static int insert_node(struct ubifs_info *c, int lnum, int offs, int len,
 		       union ubifs_key *key, unsigned long long sqnum,
 		       int deletion, int *used, loff_t old_size,
-		       loff_t new_size)
+		       loff_t new_size, long long ksa_pos)
 {
 	struct replay_entry *r;

@@ -371,6 +374,7 @@ static int insert_node(struct ubifs_info *c, int lnum, int offs, int len,

 	if (!deletion)
 		*used += ALIGN(len, 8);
+	r->ksa_pos = ksa_pos;
 	r->lnum = lnum;
 	r->offs = offs;
 	r->len = len;
@@ -606,7 +610,7 @@ static int replay_bud(struct ubifs_info *c, struct bud_entry *b)
 				deletion = 1;
 			err = insert_node(c, lnum, snod->offs, snod->len,
 					  &snod->key, snod->sqnum, deletion,
-					  &used, 0, new_size);
+					  &used, 0, new_size, 0);
 			break;
 		}
 		case UBIFS_DATA_NODE:
@@ -618,7 +622,8 @@ static int replay_bud(struct ubifs_info *c, struct bud_entry *b)

 			err = insert_node(c, lnum, snod->offs, snod->len,
 					  &snod->key, snod->sqnum, deletion,
-					  &used, 0, new_size);
+					  &used, 0, new_size,
+					  le64_to_cpu(dn->ksa_pos));
 			break;
 		}
 		case UBIFS_DENT_NODE:
@@ -658,7 +663,7 @@ static int replay_bud(struct ubifs_info *c, struct bud_entry *b)
 			trun_key_init(c, &key, le32_to_cpu(trun->inum));
 			err = insert_node(c, lnum, snod->offs, snod->len,
 					  &key, snod->sqnum, 1, &used,
-					  old_size, new_size);
+					  old_size, new_size, 0);
 			break;
 		}
 		default:
-- 
1.7.5.4


