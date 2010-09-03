Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab0ICKiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:38:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:35747 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997Ab0ICKbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:22 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/41] dm: fix locking context in queue_io()
Date: Fri,  3 Sep 2010 12:29:41 +0200
Message-Id: <1283509796-1510-27-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Now queue_io() is called from dec_pending(), which may be called with
interrupts disabled, so queue_io() must not enable interrupts
unconditionally and must save/restore the current interrupts status.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/md/dm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2011704..cd2f7e7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -512,9 +512,11 @@ static void end_io_acct(struct dm_io *io)
  */
 static void queue_io(struct mapped_device *md, struct bio *bio)
 {
-	spin_lock_irq(&md->deferred_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&md->deferred_lock, flags);
 	bio_list_add(&md->deferred, bio);
-	spin_unlock_irq(&md->deferred_lock);
+	spin_unlock_irqrestore(&md->deferred_lock, flags);
 	queue_work(md->wq, &md->work);
 }
 
-- 
1.7.1

