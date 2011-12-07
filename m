Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab1LGQWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:22:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933628Ab1LGQWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:22:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:19 2011
Message-Id: <20111207161219.043938665@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:54 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <JBottomley@Parallels.com>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Subject: [052/104] SCSI: Silencing killing requests for dead queue
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

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
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1408,6 +1408,8 @@ static void scsi_kill_request(struct req
 
 	blk_start_request(req);
 
+	scmd_printk(KERN_INFO, cmd, "killing request\n");
+
 	sdev = cmd->device;
 	starget = scsi_target(sdev);
 	shost = sdev->host;
@@ -1489,7 +1491,6 @@ static void scsi_request_fn(struct reque
 	struct request *req;
 
 	if (!sdev) {
-		printk("scsi: killing requests for dead queue\n");
 		while ((req = blk_peek_request(q)) != NULL)
 			scsi_kill_request(req, q);
 		return;


