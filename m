Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1HEPmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:42:23 -0400
Received: from www17.your-server.de ([213.133.104.17]:42950 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1HEPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:42:21 -0400
Subject: [PATCH] [SCSI] lpfc: GFP_KERNEL malloc with lock held
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Fri, 05 Aug 2011 17:41:43 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312558906.5589.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Find functions that refer to GFP_KERNEL but are called with locks held.
 The proposed change of converting the GFP_KERNEL is not necessarily the
 correct one.  It may be desired to unlock the lock, or to not call the
 function under the lock in the first place.

 The semantic patch that makes this output is available
 in scripts/coccinelle/locks/call_kern.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

__lpfc_set_rrq_active: This function is called with hbalock held and
interrupts disabled.

diff -u -p a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c 2011-07-30 21:45:25.982285760 +0200
+++ b/drivers/scsi/lpfc/lpfc_sli.c 2011-08-02 10:10:20.333918852 +0200
@@ -557,7 +557,7 @@ __lpfc_set_rrq_active(struct lpfc_hba *p
 	if (test_and_set_bit(xritag, ndlp->active_rrqs.xri_bitmap))
 		goto out;
 
-	rrq = mempool_alloc(phba->rrq_pool, GFP_KERNEL);
+	rrq = mempool_alloc(phba->rrq_pool, GFP_ATOMIC);
 	if (rrq) {
 		rrq->send_rrq = send_rrq;
 		rrq->xritag = xritag;


