Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609Ab1CEBCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:02:22 -0500
Received: from kroah.org ([198.145.64.141]:50497 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab1CEBBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:01:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:41 2011
Message-Id: <20110305005641.138362258@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [67/73] nilfs2: fix regression that i-flag is not set on changeless checkpoints
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit 72746ac643928f6c3113b5aa783d8ea1b13949d2 upstream.

According to the report from Jiro SEKIBA titled "regression in
2.6.37?"  (Message-Id: <8739n8vs1f.wl%jir@sekiba.com>), on 2.6.37 and
later kernels, lscp command no longer displays "i" flag on checkpoints
that snapshot operations or garbage collection created.

This is a regression of nilfs2 checkpointing function, and it's
critical since it broke behavior of a part of nilfs2 applications.
For instance, snapshot manager of TimeBrowse gets to create
meaningless snapshots continuously; snapshot creation triggers another
checkpoint, but applications cannot distinguish whether the new
checkpoint contains meaningful changes or not without the i-flag.

This patch fixes the regression and brings that application behavior
back to normal.

Reported-by: Jiro SEKIBA <jir@unicus.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Jiro SEKIBA <jir@unicus.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nilfs2/segment.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -430,7 +430,8 @@ static void nilfs_segctor_begin_finfo(st
 	nilfs_segctor_map_segsum_entry(
 		sci, &sci->sc_binfo_ptr, sizeof(struct nilfs_finfo));
 
-	if (inode->i_sb && !test_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags))
+	if (NILFS_I(inode)->i_root &&
+	    !test_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags))
 		set_bit(NILFS_SC_HAVE_DELTA, &sci->sc_flags);
 	/* skip finfo */
 }


