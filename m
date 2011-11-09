Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab1KJDUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:20:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933777Ab1KJDUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:20:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:03 2011
Message-Id: <20111109212703.085963289@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:25:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Adam Radford <aradford@gmail.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [028/262] [SCSI] megaraid_sas: Fix instance access in megasas_reset_timer
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: adam radford <aradford@gmail.com>

commit f575c5d3ebdca3b0482847d8fcba971767754a9e upstream.

The following patch for megaraid_sas will fix a potential bad pointer access
in megasas_reset_timer(), when a MegaRAID 9265/9285 or 9360/9380 gets a
timeout.  megasas_build_io_fusion() sets SCp.ptr to be a struct
megasas_cmd_fusion *, but then megasas_reset_timer() was casting SCp.ptr to be
a struct megasas_cmd *, then trying to access cmd->instance, which is invalid.

Just loading instance from scmd->device->host->hostdata in
megasas_reset_timer() fixes the issue.

Signed-off-by: Adam Radford <aradford@gmail.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/megaraid/megaraid_sas_base.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1906,7 +1906,6 @@ static int megasas_generic_reset(struct
 static enum
 blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 {
-	struct megasas_cmd *cmd = (struct megasas_cmd *)scmd->SCp.ptr;
 	struct megasas_instance *instance;
 	unsigned long flags;
 
@@ -1915,7 +1914,7 @@ blk_eh_timer_return megasas_reset_timer(
 		return BLK_EH_NOT_HANDLED;
 	}
 
-	instance = cmd->instance;
+	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 	if (!(instance->flag & MEGASAS_FW_BUSY)) {
 		/* FW is busy, throttle IO */
 		spin_lock_irqsave(instance->host->host_lock, flags);


