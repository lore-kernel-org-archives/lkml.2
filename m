Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2JKG6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 02:58:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38701 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2JKG6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 02:58:21 -0400
Date: Thu, 11 Oct 2012 09:57:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Krishna C Gudipati <kgudipat@brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] bfa: unlock on error in bfad_iocmd_cfg_trunk()
Message-ID: <20121011065758.GF31607@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We added a new return but forgot to drop the lock first.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Bug introduced in e353546e "[SCSI] bfa: Add diagnostic port (D-Port)
support".

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 555e7db..91465b2 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2238,8 +2238,10 @@ bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 
-	if (bfa_fcport_is_dport(&bfad->bfa))
+	if (bfa_fcport_is_dport(&bfad->bfa)) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		return BFA_STATUS_DPORT_ERR;
+	}
 
 	if ((fcport->cfg.topology == BFA_PORT_TOPOLOGY_LOOP) ||
 		(fcport->topology == BFA_PORT_TOPOLOGY_LOOP))
