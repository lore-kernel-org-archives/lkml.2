Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163074Ab1FAI1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:27:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:45054 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163063Ab1FAI0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:26:55 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:10 2011
Message-Id: <20110601081210.331572943@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:43 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [133/165] UBIFS: fix a rare memory leak in ro to rw remounting path
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1247
Lines: 40

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit eaeee242c531cd4b0a4a46e8b5dd7ef504380c42 upstream.

When re-mounting from R/O mode to R/W mode and the LEB count in the superblock
is not up-to date, because for the underlying UBI volume became larger, we
re-write the superblock. We allocate RAM for these purposes, but never free it.
So this is a memory leak, although very rare one.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/sb.c    |    3 ++-
 fs/ubifs/super.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
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
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1584,6 +1584,7 @@ static int ubifs_remount_rw(struct ubifs
 		}
 		sup->leb_cnt = cpu_to_le32(c->leb_cnt);
 		err = ubifs_write_sb_node(c, sup);
+		kfree(sup);
 		if (err)
 			goto out;
 	}


