Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0C3XTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:19:08 -0400
Received: from kroah.org ([198.145.64.141]:45356 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab0C3XSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:41 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:53 2010
Message-Id: <20100330225653.028499392@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [083/116] fs/partition/msdos: fix unusable extended partition for > 512B sector
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 8e0cc811e0f8029a7225372fb0951fab102c012f upstream.

Smaller size than a minimum blocksize can't be used, after all it's
handled like 0 size.

For extended partition itself, this makes sure to use bigger size than one
logical sector size at least.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/msdos.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/fs/partitions/msdos.c
+++ b/fs/partitions/msdos.c
@@ -492,9 +492,16 @@ int msdos_partition(struct parsed_partit
 		if (!size)
 			continue;
 		if (is_extended_partition(p)) {
-			/* prevent someone doing mkfs or mkswap on an
-			   extended partition, but leave room for LILO */
-			put_partition(state, slot, start, size == 1 ? 1 : 2);
+			/*
+			 * prevent someone doing mkfs or mkswap on an
+			 * extended partition, but leave room for LILO
+			 * FIXME: this uses one logical sector for > 512b
+			 * sector, although it may not be enough/proper.
+			 */
+			sector_t n = 2;
+			n = min(size, max(sector_size, n));
+			put_partition(state, slot, start, n);
+
 			printk(" <");
 			parse_extended(state, bdev, start, size);
 			printk(" >");


