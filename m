Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab1FGWUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:20:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58422 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab1FGWUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hPqC5qYzHVxv4/yFPhLLrcE2wRz+lFAImtsFdIXgvTECywH+vJQUUhi19LtrCnlmtY
         n2FvAZoAI8Wt2l/6II++rmmxdYMl2XbmxUimOCX9AaMxBNWNUctryZPqblXk77zK5iHb
         QUWtDhps/hdmTYlB2e88BNaFtxGxYtDLs6/a0=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Will Drewry <wad@chromium.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH v2] init: add root=PARTUUID=UUID,PARTNROFF=%d support
Date: Tue,  7 Jun 2011 17:19:33 -0500
Message-Id: <1307485173-32010-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <BANLkTi=dndbsjqbF7nTDJ0Qpvs=WNP=W6A@mail.gmail.com>
References: <BANLkTi=dndbsjqbF7nTDJ0Qpvs=WNP=W6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand root=PARTUUID=UUID syntax to support selecting a root partition
by integer offset from a known, unique partition.  This approach
provides similar properties to specifying a device and partition number,
but using the UUID as the unique path prior to evaluating the offset.

For example,
  root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B,PARTNROFF=1
selects the partition with UUID 99DE.. then select the next
partition.

This change is motivated by a particular usecase in Chromium OS where
the bootloader can easily determine what partition it is on (by UUID)
but doesn't perform general partition table walking.

That said, support for this model provides a direct mechanism for the
user to modify the root partition to boot without specifically needing
to extract each UUID or update the bootloader explicitly when the root
partition UUID is changed (if it is recreated to be larger, for
instance).  Pinning to a /boot-style partition UUID allows the arbitrary
root partition reconfiguration/modifications with slightly less
ambiguity than just [dev][partition] and less stringency than the
specific root partition UUID.

At present, PARTNROFF is tied to PARTUUID use and must follow
immediately.  It is possible to expand support to other values of root=
or to add other key-value attributes and orderings, but it seems
unnecessary to add the infrastructure without a concrete need.

v2: - convert from +/-%u to ,PARTNROFF=%d

Signed-off-by: Will Drewry <wad@chromium.org>
---
 init/do_mounts.c |   34 ++++++++++++++++++++++++++++++----
 1 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index c0851a8..35329b2 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -85,12 +85,15 @@ no_match:
 
 /**
  * devt_from_partuuid - looks up the dev_t of a partition by its UUID
- * @uuid:	36 byte char array containing a hex ascii UUID
+ * @uuid:	min 36 byte char array containing a hex ascii UUID
  *
  * The function will return the first partition which contains a matching
  * UUID value in its partition_meta_info struct.  This does not search
  * by filesystem UUIDs.
  *
+ * If @uuid is followed by a ",PARTNROFF=%d", then the number will be
+ * extracted and used as an offset from the partition identified by the UUID.
+ *
  * Returns the matching dev_t on success or 0 on failure.
  */
 static dev_t devt_from_partuuid(char *uuid_str)
@@ -98,6 +101,16 @@ static dev_t devt_from_partuuid(char *uuid_str)
 	dev_t res = 0;
 	struct device *dev = NULL;
 	u8 uuid[16];
+	struct gendisk *disk;
+	struct hd_struct *part;
+	int offset = 0;
+
+	if (strlen(uuid_str) < 36)
+		goto done;
+
+	/* Check for optional partition number offset attributes. */
+	if (uuid_str[36])
+		sscanf(&uuid_str[36], ",PARTNROFF=%d", &offset);
 
 	/* Pack the requested UUID in the expected format. */
 	part_pack_uuid(uuid_str, uuid);
@@ -107,8 +120,21 @@ static dev_t devt_from_partuuid(char *uuid_str)
 		goto done;
 
 	res = dev->devt;
-	put_device(dev);
 
+	/* Attempt to find the partition by offset. */
+	if (!offset)
+		goto no_offset;
+
+	res = 0;
+	disk = part_to_disk(dev_to_part(dev));
+	part = disk_get_part(disk, dev_to_part(dev)->partno + offset);
+	if (part) {
+		res = part_devt(part);
+		put_device(part_to_dev(part));
+	}
+
+no_offset:
+	put_device(dev);
 done:
 	return res;
 }
@@ -126,6 +152,8 @@ done:
  *	   used when disk name of partitioned disk ends on a digit.
  *	6) PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF representing the
  *	   unique id of a partition if the partition table provides it.
+ *	7) PARTUUID=<UUID>,PARTNROFF=<int> to select a partition in relation to
+ *	   a partition with a known unique id.
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
@@ -143,8 +171,6 @@ dev_t name_to_dev_t(char *name)
 #ifdef CONFIG_BLOCK
 	if (strncmp(name, "PARTUUID=", 9) == 0) {
 		name += 9;
-		if (strlen(name) != 36)
-			goto fail;
 		res = devt_from_partuuid(name);
 		if (!res)
 			goto fail;
-- 
1.7.0.4

