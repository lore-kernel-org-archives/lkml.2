Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab1CUXwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:52:49 -0400
Received: from kroah.org ([198.145.64.141]:49253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902Ab1CUXPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:10 2011
Message-Id: <20110321230710.202271726@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Timo Warns <warns@pre-sense.de>
Subject: [10/87] Fix corrupted OSF partition table parsing
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
[ Changed the patch trivially to not repeat the whole le16_to_cpu()
  thing, and to use an explicit constant for the magic value '8' ]
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/osf.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/partitions/osf.c
+++ b/fs/partitions/osf.c
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


