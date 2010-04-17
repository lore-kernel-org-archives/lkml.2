Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0DQWfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 18:35:15 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:56461 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab0DQWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 18:35:12 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Apr 2010 18:35:12 EDT
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Andries Brouwer <aeb@cwi.nl>, Fabio Massimo Di Nitto <fabbione@ubuntu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH] fs/partitions: use ADDPART_FLAG_RAID instead of magic number
Date: Sat, 17 Apr 2010 19:28:09 -0300
Message-Id: <1271543289-25833-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ADDPART_FLAG_RAID was introduced in commit d18d768, and most places were
converted to use it instead of a hardcoded value. However, some places seem
to have been missed.

Change all of them to the symbolic names via the following semantic patch:

@@
struct parsed_partitions *state;
expression E;
@@
(
- state->parts[E].flags = 1
+ state->parts[E].flags = ADDPART_FLAG_RAID
|
- state->parts[E].flags |= 1
+ state->parts[E].flags |= ADDPART_FLAG_RAID
|
- state->parts[E].flags = 2
+ state->parts[E].flags = ADDPART_FLAG_WHOLEDISK
|
- state->parts[E].flags |= 2
+ state->parts[E].flags |= ADDPART_FLAG_WHOLEDISK
)

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 fs/partitions/efi.c   |    2 +-
 fs/partitions/mac.c   |    2 +-
 fs/partitions/msdos.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 91babda..f5867f8 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -631,7 +631,7 @@ efi_partition(struct parsed_partitions *state, struct block_device *bdev)
 		/* If this is a RAID volume, tell md */
 		if (!efi_guidcmp(ptes[i].partition_type_guid,
 				 PARTITION_LINUX_RAID_GUID))
-			state->parts[i+1].flags = 1;
+			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
 	}
 	kfree(ptes);
 	kfree(gpt);
diff --git a/fs/partitions/mac.c b/fs/partitions/mac.c
index d4a0fad..dece9b4 100644
--- a/fs/partitions/mac.c
+++ b/fs/partitions/mac.c
@@ -75,7 +75,7 @@ int mac_partition(struct parsed_partitions *state, struct block_device *bdev)
 			be32_to_cpu(part->block_count) * (secsize/512));
 
 		if (!strnicmp(part->type, "Linux_RAID", 10))
-			state->parts[slot].flags = 1;
+			state->parts[slot].flags = ADDPART_FLAG_RAID;
 #ifdef CONFIG_PPC_PMAC
 		/*
 		 * If this is the first bootable partition, tell the
diff --git a/fs/partitions/msdos.c b/fs/partitions/msdos.c
index 90be97f..efe3df7 100644
--- a/fs/partitions/msdos.c
+++ b/fs/partitions/msdos.c
@@ -509,7 +509,7 @@ int msdos_partition(struct parsed_partitions *state, struct block_device *bdev)
 		}
 		put_partition(state, slot, start, size);
 		if (SYS_IND(p) == LINUX_RAID_PARTITION)
-			state->parts[slot].flags = 1;
+			state->parts[slot].flags = ADDPART_FLAG_RAID;
 		if (SYS_IND(p) == DM6_PARTITION)
 			printk("[DM]");
 		if (SYS_IND(p) == EZD_PARTITION)
-- 
1.6.6.1

