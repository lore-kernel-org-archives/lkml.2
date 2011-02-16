Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab1BPBlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:41:37 -0500
Received: from kroah.org ([198.145.64.141]:38960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978Ab1BPATx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:32 2011
Message-Id: <20110216001432.134760660@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <James.Bottomley@suse.de>
Subject: [070/272] [SCSI] libsas: fix runaway error handler problem
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@suse.de>

commit 9ee91f7fb550a4c82f82d9818e42493484c754af upstream.

libsas makes use of scsi_schedule_eh() but forgets to clear the
host_eh_scheduled flag in its error handling routine.  Because of this,
the error handler thread never gets to sleep; it's constantly awake and
trying to run the error routine leading to console spew and inability to
run anything else (at least on a UP system).  The fix is to clear the
flag as we splice the work queue.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/libsas/sas_scsi_host.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -647,6 +647,7 @@ void sas_scsi_recover_host(struct Scsi_H
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
+	shost->host_eh_scheduled = 0;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	SAS_DPRINTK("Enter %s\n", __func__);


