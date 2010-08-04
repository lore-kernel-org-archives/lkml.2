Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0HDCGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:06:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44629 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab0HDCGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:06:22 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Will Drewry <wad@chromium.org>
Subject: [PATCH 3/3] init: add support for root devices specified by partition UUID
Date: Tue,  3 Aug 2010 21:04:43 -0500
Message-Id: <1280887483-2979-3-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third patch in a series which adds support for
storing partition metadata, optionally, off of the hd_struct.

One major use for that data is being able to resolve partition
by other identities than just the index on a block device.  Device
enumeration varies by platform and there's a benefit to being able
to use something like EFI GPT's GUIDs to determine the correct
block device and partition to mount as the root.

This change adds that support to root= by adding support for
the following syntax:

  root=PARTUUID=hex-uuid

I can't say this is the best way to do it, but it should be reasonably
clean to extend. There are a number of alternate approaches, and I'd love to
hear what is preferred.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 init/do_mounts.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 02e3ca4..7b22abf 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -58,6 +58,78 @@ static int __init readwrite(char *str)
 __setup("ro", readonly);
 __setup("rw", readwrite);
 
+/**
+ * match_dev_by_uuid - callback for finding a partition using its uuid
+ * @dev:	device passed in by the caller
+ * @data:	opaque pointer to a 36 byte char array with a UUID
+ *
+ * Returns 1 if the device matches, and 0 otherwise.
+ */
+static int __init match_dev_by_uuid(struct device *dev, void *data)
+{
+	u8 *uuid = data;
+	char candidate[37];
+	struct hd_struct *part = dev_to_part(dev);
+
+	if (!part->info)
+		goto no_match;
+
+	/* Each format may parse UUIDs differently.  To that end,
+	 * each format will have to parse either the given uuid or
+	 * the candidate partition.  It'd be more efficient to parse
+	 * prior to the walk, but we'd need to store all the possible
+	 * parsed guids.
+	 */
+	switch (part->info->format) {
+#ifdef CONFIG_EFI_PARTITION
+	case PARTITION_META_INFO_FORMAT_EFI:
+		snprintf(candidate, sizeof(candidate), "%pUl",
+			 part->info->efi.uuid.b);
+		if (!strcmp(uuid, candidate))
+			goto match;
+#endif
+	default:
+			goto no_match;
+	}
+
+match:
+	return 1;
+no_match:
+	return 0;
+}
+
+
+/**
+ * devt_from_partuuid - looks up the dev_t of a partition by its UUID
+ * @uuid:	36 byte char array containing a hex ascii UUID
+ *
+ * The function will return the first partition which contains a matching
+ * UUID value in its partition_meta_info struct.  This does not search
+ * by filesystem UUIDs.
+ *
+ * Returns the matching dev_t on success or 0 on failure.
+ */
+static dev_t __init devt_from_partuuid(char *uuid)
+{
+	dev_t res = 0;
+	struct device *dev = NULL;
+	unsigned char *uuid_cur = (unsigned char *) uuid;
+
+	/* Downcase the letters in the UUID for uniformity. */
+	for (; *uuid_cur; ++uuid_cur)
+		*uuid_cur = tolower(*uuid_cur);
+
+	dev = class_find_device(&block_class, NULL, uuid, &match_dev_by_uuid);
+	if (!dev)
+		goto done;
+
+	res = dev->devt;
+	put_device(dev);
+
+done:
+	return res;
+}
+
 /*
  *	Convert a name into device number.  We accept the following variants:
  *
@@ -68,6 +140,8 @@ __setup("rw", readwrite);
  *         of partition - device number of disk plus the partition number
  *	5) /dev/<disk_name>p<decimal> - same as the above, that form is
  *	   used when disk name of partitioned disk ends on a digit.
+ *	6) PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF representing the
+ *	   unique id of a partition if the partition table provides it.
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
@@ -82,6 +156,16 @@ dev_t name_to_dev_t(char *name)
 	dev_t res = 0;
 	int part;
 
+	if (strncmp(name, "PARTUUID=", 9) == 0) {
+		name += 9;
+		if (strlen(name) != 36)
+			goto fail;
+		res = devt_from_partuuid(name);
+		if (!res)
+			goto fail;
+		goto done;
+	}
+
 	if (strncmp(name, "/dev/", 5) != 0) {
 		unsigned maj, min;
 
-- 
1.7.0.4

