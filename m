Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab1FATsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:48:30 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47420 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759773Ab1FATs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RzSQZecL75Jn7u9rTO7qve3OWjHqxFuDP0A7vlQb22/LTmGldTcbgGpktg8jnj2wAe
         fpQpZ/igYK+aYWhwSwQeRcmjiLKxpUlJJ1niFjly9R6bJ5xFs9Rs5XkmqiyE4wnyUfjH
         TXo2je06TypOEPpjjbwLmbUac87+0u0wYV9no=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Will Drewry <wad@chromium.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH] init: add root=PARTUUID=UUID+/-%d support
Date: Wed,  1 Jun 2011 14:49:48 -0500
Message-Id: <1306957788-12310-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is practical and/or interesting to others, but it's a
minimal change --

Expands root=PARTUUID=UUID syntax to support selecting a root partition
by integer offset from a known, unique partition.  This approach
provides similar properties to specifying a device and partition number,
but using the UUID as the unique path prior to evaluating the offset.

For example,
  root=PARTUUID=99DE9194-FC15-4223-9192-FC243948F88B+1
selects the partition with UUID 99DE.. then select the next
partition.

This change is motivated by a particular usecase in Chromium OS where
the bootloader can easily determine what partition it is on (by UUID)
but doesn't perform general partition table walking.

That said, support for this approach provides a direct mechanism for the
user to modify the root partition to boot without specifically needing
to extract each PARTUUID or update the bootloader explicitly when the
root partition UUID is changed (if it is recreated to be larger, for
instance, restored, etc).  Pinning to a /boot partition UUID with an
offset allows the arbitrary root partition reconfiguration/modifications
with slightly less ambiguity than just [dev][partition] and less
stringency than the specific root partition UUID.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 init/do_mounts.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index c0851a8..d1a7a33 100644
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
+ * If @uuid is of the format UUID+/-%u, then the partition offset from the
+ * found partition will be returned.
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
+	unsigned int offset = 0;
+	u8 op = 0;
+
+	if (strlen(uuid_str) < 36)
+		goto done;
+
+	if (uuid_str[36])
+		sscanf(&uuid_str[36], "%c%u", &op, &offset);
 
 	/* Pack the requested UUID in the expected format. */
 	part_pack_uuid(uuid_str, uuid);
@@ -107,8 +120,25 @@ static dev_t devt_from_partuuid(char *uuid_str)
 		goto done;
 
 	res = dev->devt;
-	put_device(dev);
 
+	/* Attempt to find the partition by offset. */
+	if (!offset)
+		goto no_offset;
+
+	disk = part_to_disk(dev_to_part(dev));
+	part = NULL;
+	res = 0;
+	if (op == '+')
+		part = disk_get_part(disk, dev_to_part(dev)->partno + offset);
+	else if (op == '-')
+		part = disk_get_part(disk, dev_to_part(dev)->partno - offset);
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
@@ -126,6 +156,8 @@ done:
  *	   used when disk name of partitioned disk ends on a digit.
  *	6) PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF representing the
  *	   unique id of a partition if the partition table provides it.
+ *	7) PARTUUID=<UUID><+/-><decimal> to select a partition in relation to
+ *	   a partition with a known unique id.
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
@@ -143,8 +175,6 @@ dev_t name_to_dev_t(char *name)
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

