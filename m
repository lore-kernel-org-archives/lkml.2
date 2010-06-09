Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab0FIMCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:02:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61376 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab0FIMCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:02:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=pRRXF0xtdCfRoSsvL1iYoD989Wt4Tcrt/xPMTdOyi6lOPA+/Jgg6I2PL3ozWe0PyrS
         PRB90UzgdEN6lsTLNSww46FJqhxKCrxsCmA1s1+miNNKsCS2EPrGXuEIgIhpq17oPb/q
         L2Y0UcitZjzIoEpnHR/cN8KrDmO3ZUs799+Os=
Date: Wed, 9 Jun 2010 14:01:54 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <tj@kernel.org>, Robert Hancock <hancockrwd@gmail.com>,
       Vivek Mahajan <vivek.mahajan@freescale.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] sata_sil24: memset() overflow
Message-ID: <20100609120153.GF5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
	Robert Hancock <hancockrwd@gmail.com>,
	Vivek Mahajan <vivek.mahajan@freescale.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cb->atapi.cdb is an array of 16 u8 elements.  The call too memset() 
would set the first part of the sge array to zero as well.  It's not
a packed struct. 

This one has been around for five years.  I found it with Smatch.  I
think the reason no one has seen it before is because we normally call
sil24_fill_sg() and that overwrites sge with proper information?

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I don't have this hardware myself so I can't test it.  Sorry. :(

diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index e925051..9e459eb 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -865,7 +865,7 @@ static void sil24_qc_prep(struct ata_queued_cmd *qc)
 	} else {
 		prb = &cb->atapi.prb;
 		sge = cb->atapi.sge;
-		memset(cb->atapi.cdb, 0, 32);
+		memset(cb->atapi.cdb, 0, sizeof(cb->atapi.cdb));
 		memcpy(cb->atapi.cdb, qc->cdb, qc->dev->cdb_len);
 
 		if (ata_is_data(qc->tf.protocol)) {
