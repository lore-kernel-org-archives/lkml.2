Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1H0O4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:56:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab1H0O4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:56:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:04:20 2011
Message-Id: <20110826220419.964588165@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 15:03:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Timo Warns <warns@pre-sense.de>, Matt Domsch <Matt_Domsch@dell.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Dave Jones <davej@codemonkey.org.uk>
Subject: [11/20] fs/partitions/efi.c: corrupted GUID partition tables can cause kernel oops
In-Reply-To: <20110826220431.GA15382@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Timo Warns <Warns@pre-sense.de>

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
Signed-off-by: Timo Warns <warns@pre-sense.de>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/partitions/efi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -311,6 +311,15 @@ is_gpt_valid(struct block_device *bdev,
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


