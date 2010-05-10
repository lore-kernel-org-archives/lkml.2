Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab0EJXkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:40:07 -0400
Received: from kroah.org ([198.145.64.141]:33001 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab0EJWwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:52:01 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:20 2010
Message-Id: <20100510223320.179273402@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:32:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [033/117] ocfs2: Compute metaecc for superblocks during online resize.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joel Becker <joel.becker@oracle.com>

commit a42ab8e1a37257da37e0f018e707bf365ac24531 upstream.

Online resize writes out the new superblock and its backups directly.
The metaecc data wasn't being recomputed.  Let's do that directly.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Acked-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/buffer_head_io.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -407,6 +407,7 @@ int ocfs2_write_super_or_backup(struct o
 				struct buffer_head *bh)
 {
 	int ret = 0;
+	struct ocfs2_dinode *di = (struct ocfs2_dinode *)bh->b_data;
 
 	mlog_entry_void();
 
@@ -426,6 +427,7 @@ int ocfs2_write_super_or_backup(struct o
 
 	get_bh(bh); /* for end_buffer_write_sync() */
 	bh->b_end_io = end_buffer_write_sync;
+	ocfs2_compute_meta_ecc(osb->sb, bh->b_data, &di->i_check);
 	submit_bh(WRITE, bh);
 
 	wait_on_buffer(bh);


