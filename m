Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966512Ab0CPPYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:24:10 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:55168 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966420Ab0CPPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:24:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: [PATCH 3/3] SCSI: qla2xxx, fix lock imbalance
Date: Tue, 16 Mar 2010 16:23:59 +0100
Message-Id: <1268753039-17214-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1268753039-17214-1-git-send-email-jslaby@suse.cz>
References: <1268753039-17214-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found that one error path in qla24xx_bsg_timeout omits to
unlock ha->hardware_lock. Fix that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 90d1e06..a3591e5 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2388,6 +2388,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
 	return 0;
 
 done:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
 		kfree(sp->fcport);
 	kfree(sp->ctx);
-- 
1.7.0.1


