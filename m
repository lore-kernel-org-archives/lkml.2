Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab0IQSWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:22:09 -0400
Received: from smtp105.sbc.mail.ac4.yahoo.com ([76.13.13.244]:32746 "HELO
	smtp105.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755995Ab0IQSWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:22:04 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: QnNNnmsVM1nGEJM_sr58ApJ1ZDKD1ZuF4jHRZ9oRyosxxQ7
 nu6oDSxl8ZuzgbrbCt5yvjURVFrzsboAaVG6SkanFH7liZ3edS6lql7Wesa.
 merOY9ZR3.JsuTD.7X1jpEm0uKLQY70ADN5ESl7Lkk_JnZJJE4obCzusvDO7
 _XhsXmeM_bAOvJTqggSgy2358gLlptxoUZ9Dbu553Hp5ugOOfvYnv.PsLaR5
 _IJJDuHzmPns5pEtOnDlWQRH9RrsDdxxq8VKnJDwDMWOlKPS8jKM._no3m8J
 Urv60GfM7hY5TvwLXByyS_1gNzqWV7uSAYq6PtnQqQcr0imGeRYlT67XNCHu
 eLCeFvpUgRE.BBmtKXA--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH v2 02/11] scsi: Drop struct Scsi_Host->host_lock usage in scsi_dispatch_cmd()
Date: Fri, 17 Sep 2010 11:21:59 -0700
Message-Id: <1284747719-20881-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts scsi_dispatch_cmd() to no longer lock() + unlock()
struct Scsi_Host->host_lock while calling scsi_cmd_get_serial() and
SHT->queuecommand() dispatcher.  This patch follows commit 5900e428420d
which means we can now safely call scsi_cmd_get_serial() without the
host_lock held.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/scsi.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4724ce7..d1aa209 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -658,7 +658,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
-	unsigned long flags = 0;
 	unsigned long timeout;
 	int rtn = 0;
 
@@ -744,7 +743,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	spin_lock_irqsave(host->host_lock, flags);
 	/*
 	 * AK: unlikely race here: for some reason the timer could
 	 * expire before the serial number is set up below.
@@ -760,7 +758,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		trace_scsi_dispatch_cmd_start(cmd);
 		rtn = host->hostt->queuecommand(cmd, scsi_done);
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
+
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
-- 
1.7.2.3

