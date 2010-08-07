Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab0HGWPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 18:15:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48706 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab0HGWPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 18:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ji2G5qGIR63GfTc5hL8HJ1MZpnPbPwyPdxlxRaJizVyZhGk4ZCAEjEKoQBl3F75bDI
         7qoAojRPuFh0s/BUiJSP//bpHprxiSTHdsJw5MontDMIxMJbZbovSBbVLeUhF/ZFoNcV
         o3Q07D4PsQCuHe7dE+VqfBwvodRX3tE8KgZIw=
Date: Sun, 8 Aug 2010 00:15:17 +0200
From: Dan Carpenter <error27@gmail.com>
To: James Smart <james.smart@emulex.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] lpfc: change spin_lock_irq() to spin_lock()
Message-ID: <20100807221517.GC9031@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	James Smart <james.smart@emulex.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Alex Iannicelli <alex.iannicelli@emulex.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In lpfc_cleanup_pending_mbox() we already have IRQs disabled so we don't
need to disable them again.

Also in lpfc_sli_intr_handler() there is a typo where it has
spin_unlock_irq() instead of just spin_unlock().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e758eae..f772a7e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8460,7 +8460,7 @@ lpfc_sli_intr_handler(int irq, void *dev_id)
 	 * If there is deferred error attention, do not check for any interrupt.
 	 */
 	if (unlikely(phba->hba_flag & DEFER_ERATT)) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock(&phba->hbalock);
 		return IRQ_NONE;
 	}
 
@@ -12813,9 +12813,9 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 			}
 			ndlp = (struct lpfc_nodelist *) mb->context2;
 			if (ndlp) {
-				spin_lock_irq(shost->host_lock);
+				spin_lock(shost->host_lock);
 				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
-				spin_unlock_irq(shost->host_lock);
+				spin_unlock(shost->host_lock);
 				lpfc_nlp_put(ndlp);
 				mb->context2 = NULL;
 			}
@@ -12831,9 +12831,9 @@ lpfc_cleanup_pending_mbox(struct lpfc_vport *vport)
 		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
 			ndlp = (struct lpfc_nodelist *) mb->context2;
 			if (ndlp) {
-				spin_lock_irq(shost->host_lock);
+				spin_lock(shost->host_lock);
 				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
-				spin_unlock_irq(shost->host_lock);
+				spin_unlock(shost->host_lock);
 				lpfc_nlp_put(ndlp);
 				mb->context2 = NULL;
 			}
