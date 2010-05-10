Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab0EJXCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:02:37 -0400
Received: from kroah.org ([198.145.64.141]:51872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757478Ab0EJW6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:14 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:39 2010
Message-Id: <20100510223539.715353077@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Lord <mlord@pobox.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [59/98] libata: Fix accesses at LBA28 boundary (old bug, but nasty) (v2)
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Lord <kernel@teksavvy.com>

commit 45c4d015a92f72ec47acd0c7557abdc0c8a6499d upstream.

Most drives from Seagate, Hitachi, and possibly other brands,
do not allow LBA28 access to sector number 0x0fffffff (2^28 - 1).
So instead use LBA48 for such accesses.

This bug could bite a lot of systems, especially when the user has
taken care to align partitions to 4KB boundaries. On misaligned systems,
it is less likely to be encountered, since a 4KB read would end at
0x10000000 rather than at 0x0fffffff.

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ata.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -1000,8 +1000,8 @@ static inline int ata_ok(u8 status)
 
 static inline int lba_28_ok(u64 block, u32 n_block)
 {
-	/* check the ending block number */
-	return ((block + n_block) < ((u64)1 << 28)) && (n_block <= 256);
+	/* check the ending block number: must be LESS THAN 0x0fffffff */
+	return ((block + n_block) < ((1 << 28) - 1)) && (n_block <= 256);
 }
 
 static inline int lba_48_ok(u64 block, u32 n_block)


