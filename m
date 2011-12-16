Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab1LPTu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 14:50:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932754Ab1LPTuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:46:00 2011
Message-Id: <20111216194600.740730954@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Theodore Tso" <tytso@mit.edu>
Subject: [41/53] ext4: fix ext4_end_io_dio() racing against fsync()
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit b5a7e97039a80fae673ccc115ce595d5b88fb4ee upstream.

We need to make sure iocb->private is cleared *before* we put the
io_end structure on i_completed_io_list.  Otherwise fsync() could
potentially run on another CPU and free the iocb structure out from
under us.

Reported-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2630,10 +2630,11 @@ static void ext4_end_io_dio(struct kiocb
  		  iocb->private, io_end->inode->i_ino, iocb, offset,
 		  size);
 
+	iocb->private = NULL;
+
 	/* if not aio dio with unwritten extents, just free io and return */
 	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
 		ext4_free_io_end(io_end);
-		iocb->private = NULL;
 out:
 		if (is_async)
 			aio_complete(iocb, ret, 0);
@@ -2656,7 +2657,6 @@ out:
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
 	/* queue the work to convert unwritten extents to written */
-	iocb->private = NULL;
 	queue_work(wq, &io_end->work);
 
 	/* XXX: probably should move into the real I/O completion handler */


