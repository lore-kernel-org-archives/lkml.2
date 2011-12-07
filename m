Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab1LGQXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:23:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933811Ab1LGQXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:23:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:17 2011
Message-Id: <20111207161217.237310786@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:32 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Tejun Heo <tj@kernel.org>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [030/104] ext4: fix racy use-after-free in ext4_end_io_dio()
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 4c81f045c0bd2cbb78cc6446a4cd98038fe11a2e upstream.

ext4_end_io_dio() queues io_end->work and then clears iocb->private;
however, io_end->work calls aio_complete() which frees the iocb
object.  If that slab object gets reallocated, then ext4_end_io_dio()
can end up clearing someone else's iocb->private, this use-after-free
can cause a leak of a struct ext4_io_end_t structure.

Detected and tested with slab poisoning.

[ Note: Can also reproduce using 12 fio's against 12 file systems with the
  following configuration file:

  [global]
  direct=1
  ioengine=libaio
  iodepth=1
  bs=4k
  ba=4k
  size=128m

  [create]
  filename=${TESTDIR}
  rw=write

  -- tytso ]

Google-Bug-Id: 5354697
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Kent Overstreet <koverstreet@google.com>
Tested-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2656,8 +2656,8 @@ out:
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
 	/* queue the work to convert unwritten extents to written */
-	queue_work(wq, &io_end->work);
 	iocb->private = NULL;
+	queue_work(wq, &io_end->work);
 
 	/* XXX: probably should move into the real I/O completion handler */
 	inode_dio_done(inode);


