Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1G0Afl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:35:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:7312 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab1G0Afc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:35:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30471239"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: Warns@pre-sense.de, warns@pre-sense.de, stable@kernel.org,
        ak@linux.intel.com, torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [38/98] Fix corrupted OSF partition table parsing
Message-Id: <20110727003530.A09992403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:35:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Timo Warns <Warns@pre-sense.de>

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[ Changed the patch trivially to not repeat the whole le16_to_cpu()
  thing, and to use an explicit constant for the magic value '8' ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/partitions/osf.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/fs/partitions/osf.c
===================================================================
--- linux-2.6.35.y.orig/fs/partitions/osf.c
+++ linux-2.6.35.y/fs/partitions/osf.c
@@ -10,10 +10,13 @@
 #include "check.h"
 #include "osf.h"
 
+#define MAX_OSF_PARTITIONS 8
+
 int osf_partition(struct parsed_partitions *state)
 {
 	int i;
 	int slot = 1;
+	unsigned int npartitions;
 	Sector sect;
 	unsigned char *data;
 	struct disklabel {
@@ -45,7 +48,7 @@ int osf_partition(struct parsed_partitio
 			u8  p_fstype;
 			u8  p_frag;
 			__le16 p_cpg;
-		} d_partitions[8];
+		} d_partitions[MAX_OSF_PARTITIONS];
 	} * label;
 	struct d_partition * partition;
 
@@ -63,7 +66,12 @@ int osf_partition(struct parsed_partitio
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
