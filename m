Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933450Ab1C3WFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:05:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:35488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221Ab1C3VGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903734064"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: James.Bottomley@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [38/275] libsas: fix runaway error handler problem
Message-Id: <20110330210433.B104D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/libsas/sas_scsi_host.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/scsi/libsas/sas_scsi_host.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/libsas/sas_scsi_host.c	2011-03-29 22:51:53.815346169 -0700
+++ linux-2.6.35.y/drivers/scsi/libsas/sas_scsi_host.c	2011-03-29 23:02:58.973326440 -0700
@@ -649,6 +649,7 @@
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
+	shost->host_eh_scheduled = 0;
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	SAS_DPRINTK("Enter %s\n", __func__);
