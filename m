Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab3AHXiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:38:55 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53703 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983Ab3AHXix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:38:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Hannes Reinecke <hare@suse.de>, James Bottomley <JBottomley@Parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 37/77] Silencing 'killing requests for dead queue'
Date: Tue, 8 Jan 2013 18:35:16 -0500
Message-ID: <1357688156-25387-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 745718132c3c7cac98a622b610e239dcd5217f71 upstream.

When we tear down a device we try to flush all outstanding
commands in scsi_free_queue(). However the check in
scsi_request_fn() is imperfect as it only signals that
we _might start_ aborting commands, not that we've actually
aborted some.
So move the printk inside the scsi_kill_request function,
this will also give us a hint about which commands are aborted.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/scsi_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9f240f4..ca8666b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1383,6 +1383,8 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 		BUG();
 	}
 
+	scmd_printk(KERN_INFO, cmd, "killing request\n");
+
 	sdev = cmd->device;
 	starget = scsi_target(sdev);
 	shost = sdev->host;
@@ -1469,7 +1471,6 @@ static void scsi_request_fn(struct request_queue *q)
 	struct request *req;
 
 	if (!sdev) {
-		printk("scsi: killing requests for dead queue\n");
 		while ((req = blk_peek_request(q)) != NULL)
 			scsi_kill_request(req, q);
 		return;
-- 
1.7.12.1

