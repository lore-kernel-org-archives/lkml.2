Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933601Ab2JDVTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:19:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584Ab2JDVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:19:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jack Wang <jack_wang@usish.com>, John Drescher <drescherjm@gmail.com>,
        Dan Williams <djbw@fb.com>, James Bottomley <JBottomley@Parallels.com>
Subject: [ 55/56] SCSI: scsi_remove_target: fix softlockup regression on hot remove
Date: Thu,  4 Oct 2012 14:16:16 -0700
Message-Id: <20121004211158.373013789@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <djbw@fb.com>

commit bc3f02a795d3b4faa99d37390174be2a75d091bd upstream.

John reports:
 BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u:8:2202]
 [..]
 Call Trace:
  [<ffffffff8141782a>] scsi_remove_target+0xda/0x1f0
  [<ffffffff81421de5>] sas_rphy_remove+0x55/0x60
  [<ffffffff81421e01>] sas_rphy_delete+0x11/0x20
  [<ffffffff81421e35>] sas_port_delete+0x25/0x160
  [<ffffffff814549a3>] mptsas_del_end_device+0x183/0x270

...introduced by commit 3b661a9 "[SCSI] fix hot unplug vs async scan race".

Don't restart lookup of more stargets in the multi-target case, just
arrange to traverse the list once, on the assumption that new targets
are always added at the end.  There is no guarantee that the target will
change state in scsi_target_reap() so we can end up spinning if we
restart.

Acked-by: Jack Wang <jack_wang@usish.com>
LKML-Reference: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
Reported-by: John Drescher <drescherjm@gmail.com>
Tested-by: John Drescher <drescherjm@gmail.com>
Signed-off-by: Dan Williams <djbw@fb.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_sysfs.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1031,33 +1031,31 @@ static void __scsi_remove_target(struct
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget, *found;
+	struct scsi_target *starget, *last = NULL;
 	unsigned long flags;
 
- restart:
-	found = NULL;
+	/* remove targets being careful to lookup next entry before
+	 * deleting the last
+	 */
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
-			found = starget;
-			found->reap_ref++;
-			break;
+			/* assuming new targets arrive at the end */
+			starget->reap_ref++;
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			if (last)
+				scsi_target_reap(last);
+			last = starget;
+			__scsi_remove_target(starget);
+			spin_lock_irqsave(shost->host_lock, flags);
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (found) {
-		__scsi_remove_target(found);
-		scsi_target_reap(found);
-		/* in the case where @dev has multiple starget children,
-		 * continue removing.
-		 *
-		 * FIXME: does such a case exist?
-		 */
-		goto restart;
-	}
+	if (last)
+		scsi_target_reap(last);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 


