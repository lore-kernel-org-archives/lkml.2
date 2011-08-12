Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1HNQKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:10:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab1HNQKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:10:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:59 2011
Message-Id: <20110812210559.318167584@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [82/90] ext3: Properly count journal credits for long symlinks
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit d2db60df1e7eb39cf0f378dfc4dd8813666d46ef upstream.

Commit ae54870a1dc9 ("ext3: Fix lock inversion in ext3_symlink()")
recalculated the number of credits needed for a long symlink, in the
process of splitting it into two transactions.  However, the first
credit calculation under-counted because if selinux is enabled, credits
are needed to create the selinux xattr as well.

Overrunning the reservation will result in an OOPS in
journal_dirty_metadata() due to this assert:

  J_ASSERT_JH(jh, handle->h_buffer_credits > 0);

Fix this by increasing the reservation size.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext3/namei.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2210,9 +2210,11 @@ static int ext3_symlink (struct inode *
 		/*
 		 * For non-fast symlinks, we just allocate inode and put it on
 		 * orphan list in the first transaction => we need bitmap,
-		 * group descriptor, sb, inode block, quota blocks.
+		 * group descriptor, sb, inode block, quota blocks, and
+		 * possibly selinux xattr blocks.
 		 */
-		credits = 4 + EXT3_MAXQUOTAS_INIT_BLOCKS(dir->i_sb);
+		credits = 4 + EXT3_MAXQUOTAS_INIT_BLOCKS(dir->i_sb) +
+			  EXT3_XATTR_TRANS_BLOCKS;
 	} else {
 		/*
 		 * Fast symlink. We have to add entry to directory


