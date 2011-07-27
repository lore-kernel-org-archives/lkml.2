Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab1G0WH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:07:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:46879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab1G0VsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900462"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: Artem.Bityutskiy@nokia.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [24/99] UBIFS: fix a rare memory leak in ro to rw remounting path
Message-Id: <20110727214822.BAD082403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit eaeee242c531cd4b0a4a46e8b5dd7ef504380c42 upstream.

When re-mounting from R/O mode to R/W mode and the LEB count in the superblock
is not up-to date, because for the underlying UBI volume became larger, we
re-write the superblock. We allocate RAM for these purposes, but never free it.
So this is a memory leak, although very rare one.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ubifs/sb.c    |    3 ++-
 fs/ubifs/super.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/ubifs/sb.c
===================================================================
--- linux-2.6.35.y.orig/fs/ubifs/sb.c
+++ linux-2.6.35.y/fs/ubifs/sb.c
@@ -475,7 +475,8 @@ failed:
  * @c: UBIFS file-system description object
  *
  * This function returns a pointer to the superblock node or a negative error
- * code.
+ * code. Note, the user of this function is responsible of kfree()'ing the
+ * returned superblock buffer.
  */
 struct ubifs_sb_node *ubifs_read_sb_node(struct ubifs_info *c)
 {
Index: linux-2.6.35.y/fs/ubifs/super.c
===================================================================
--- linux-2.6.35.y.orig/fs/ubifs/super.c
+++ linux-2.6.35.y/fs/ubifs/super.c
@@ -1545,6 +1545,7 @@ static int ubifs_remount_rw(struct ubifs
 		}
 		sup->leb_cnt = cpu_to_le32(c->leb_cnt);
 		err = ubifs_write_sb_node(c, sup);
+		kfree(sup);
 		if (err)
 			goto out;
 	}
