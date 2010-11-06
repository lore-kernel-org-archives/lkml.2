Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0KFOla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:41:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64795 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab0KFOl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PYavtA4ueg2d8c8jSG5Y6H/ilZnICxoxFIjGO5gS536Vc9hCrw0Q+hIMOHoDeeEo5k
         6qx7wPapksh2qapYRH3I/tR78xh2+uW6m2/yJgeF6Xl/SGiQpP21h4h56MGfOpDqROKI
         dTx681lcclOJuJ+//oTynk/G81i8nqH0DV0lM=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Alex Chiang <achiang@hp.com>, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] infiniband: core: fix information leak to userland
Date: Sat,  6 Nov 2010 17:41:20 +0300
Message-Id: <1289054481-18145-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure ib_uverbs_qp_attr is copied to userland with allmost all
fields uninitialized (140 bytes on x86).  It leads to leaking of
contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/infiniband/core/ucm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 08f948d..ccfa4f9 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -622,7 +622,7 @@ static ssize_t ib_ucm_init_qp_attr(struct ib_ucm_file *file,
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	resp.qp_attr_mask = 0;
+	memset(&resp, 0, sizeof(resp));
 	memset(&qp_attr, 0, sizeof qp_attr);
 	qp_attr.qp_state = cmd.qp_state;
 	result = ib_cm_init_qp_attr(ctx->cm_id, &qp_attr, &resp.qp_attr_mask);
-- 
1.7.0.4

