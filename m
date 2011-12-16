Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab1LPUFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:05:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab1LPTuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:46:01 2011
Message-Id: <20111216194601.270655811@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yongqiang Yang <xiaoqiangnk@gmail.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [44/53] ext4: avoid potential hang in mpage_submit_io() when blocksize < pagesize
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

commit 13a79a4741d37fda2fbafb953f0f301dc007928f upstream.

If there is an unwritten but clean buffer in a page and there is a
dirty buffer after the buffer, then mpage_submit_io does not write the
dirty buffer out.  As a result, da_writepages loops forever.

This patch fixes the problem by checking dirty flag.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1261,8 +1261,11 @@ static int mpage_da_submit_io(struct mpa
 					clear_buffer_unwritten(bh);
 				}
 
-				/* skip page if block allocation undone */
-				if (buffer_delay(bh) || buffer_unwritten(bh))
+				/*
+				 * skip page if block allocation undone and
+				 * block is dirty
+				 */
+				if (ext4_bh_delay_or_unwritten(NULL, bh))
 					skip_page = 1;
 				bh = bh->b_this_page;
 				block_start += bh->b_size;


