Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965318Ab2CMAZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:25:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:49121 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030203Ab2CMAZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Timo Warns <Warns@pre-sense.de>,
        Timo Warns <warns@pre-sense.de>, Matt Domsch <Matt_Domsch@dell.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Dave Jones <davej@codemonkey.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 193/196] fs/partitions/efi.c: corrupted GUID partition tables can cause kernel oops
Date: Mon, 12 Mar 2012 20:21:46 -0400
Message-Id: <1331598109-31424-148-git-send-email-paul.gortmaker@windriver.com>
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

commit 3eb8e74ec72736b9b9d728bad30484ec89c91dde upstream.

The kernel automatically evaluates partition tables of storage devices.
The code for evaluating GUID partitions (in fs/partitions/efi.c) contains
a bug that causes a kernel oops on certain corrupted GUID partition
tables.

This bug has security impacts, because it allows, for example, to
prepare a storage device that crashes a kernel subsystem upon connecting
the device (e.g., a "USB Stick of (Partial) Death").

	crc = efi_crc32((const unsigned char *) (*gpt), le32_to_cpu((*gpt)->header_size));

computes a CRC32 checksum over gpt covering (*gpt)->header_size bytes.
There is no validation of (*gpt)->header_size before the efi_crc32 call.

A corrupted partition table may have large values for (*gpt)->header_size.
 In this case, the CRC32 computation access memory beyond the memory
allocated for gpt, which may cause a kernel heap overflow.

Validate value of GUID partition table header size.

[akpm@linux-foundation.org: fix layout and indenting]
[PG: replace state->bdev with bdev, since 1493bf217f7f isn't in 34]

Signed-off-by: Timo Warns <warns@pre-sense.de>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/partitions/efi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index ee59684..9b40337 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -312,6 +312,15 @@ is_gpt_valid(struct block_device *bdev, u64 lba,
 		goto fail;
 	}
 
+	/* Check the GUID Partition Table header size */
+	if (le32_to_cpu((*gpt)->header_size) >
+			bdev_logical_block_size(bdev)) {
+		pr_debug("GUID Partition Table Header size is wrong: %u > %u\n",
+			le32_to_cpu((*gpt)->header_size),
+			bdev_logical_block_size(bdev));
+		goto fail;
+	}
+
 	/* Check the GUID Partition Table CRC */
 	origcrc = le32_to_cpu((*gpt)->header_crc32);
 	(*gpt)->header_crc32 = 0;
-- 
1.7.9.3

