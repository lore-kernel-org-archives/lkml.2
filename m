Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780Ab2CMAXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:23:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:48312 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2CMAXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Timo Warns <Warns@pre-sense.de>,
        Timo Warns <warns@pre-sense.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 127/196] Fix corrupted OSF partition table parsing
Date: Mon, 12 Mar 2012 20:20:40 -0400
Message-Id: <1331598109-31424-82-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timo Warns <Warns@pre-sense.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1eafbfeb7bdf59cfe173304c76188f3fd5f1fd05 upstream.

The kernel automatically evaluates partition tables of storage devices.
The code for evaluating OSF partitions contains a bug that leaks data
from kernel heap memory to userspace for certain corrupted OSF
partitions.

In more detail:

  for (i = 0 ; i < le16_to_cpu(label->d_npartitions); i++, partition++) {

iterates from 0 to d_npartitions - 1, where d_npartitions is read from
the partition table without validation and partition is a pointer to an
array of at most 8 d_partitions.

Add the proper and obvious validation.

Signed-off-by: Timo Warns <warns@pre-sense.de>
[ Changed the patch trivially to not repeat the whole le16_to_cpu()
  thing, and to use an explicit constant for the magic value '8' ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/partitions/osf.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/partitions/osf.c b/fs/partitions/osf.c
index c05c17bc..6e0825e 100644
--- a/fs/partitions/osf.c
+++ b/fs/partitions/osf.c
@@ -10,10 +10,13 @@
 #include "check.h"
 #include "osf.h"
 
+#define MAX_OSF_PARTITIONS 8
+
 int osf_partition(struct parsed_partitions *state, struct block_device *bdev)
 {
 	int i;
 	int slot = 1;
+	unsigned int npartitions;
 	Sector sect;
 	unsigned char *data;
 	struct disklabel {
@@ -45,7 +48,7 @@ int osf_partition(struct parsed_partitions *state, struct block_device *bdev)
 			u8  p_fstype;
 			u8  p_frag;
 			__le16 p_cpg;
-		} d_partitions[8];
+		} d_partitions[MAX_OSF_PARTITIONS];
 	} * label;
 	struct d_partition * partition;
 
@@ -63,7 +66,12 @@ int osf_partition(struct parsed_partitions *state, struct block_device *bdev)
 		put_dev_sector(sect);
 		return 0;
 	}
-	for (i = 0 ; i < le16_to_cpu(label->d_npartitions); i++, partition++) {
+	npartitions = le16_to_cpu(label->d_npartitions);
+	if (npartitions > MAX_OSF_PARTITIONS) {
+		put_dev_sector(sect);
+		return 0;
+	}
+	for (i = 0 ; i < npartitions; i++, partition++) {
 		if (slot == state->limit)
 		        break;
 		if (le32_to_cpu(partition->p_size))
-- 
1.7.9.3

