Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2BEWuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:50:01 -0500
Received: from 1wt.eu ([62.212.114.60]:61822 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab2BEW0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:10 -0500
Message-Id: <20120205220950.089165886@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Timo Warns <warns@pre-sense.de>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 15/91] Fix corrupted OSF partition table parsing
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
Cc: stable@kernel.org
[ Changed the patch trivially to not repeat the whole le16_to_cpu()
  thing, and to use an explicit constant for the magic value '8' ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/partitions/osf.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/fs/partitions/osf.c
===================================================================
--- longterm-2.6.27.orig/fs/partitions/osf.c	2012-02-05 22:34:34.555915472 +0100
+++ longterm-2.6.27/fs/partitions/osf.c	2012-02-05 22:34:37.034915210 +0100
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
@@ -45,7 +48,7 @@
 			u8  p_fstype;
 			u8  p_frag;
 			__le16 p_cpg;
-		} d_partitions[8];
+		} d_partitions[MAX_OSF_PARTITIONS];
 	} * label;
 	struct d_partition * partition;
 
@@ -63,7 +66,12 @@
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


