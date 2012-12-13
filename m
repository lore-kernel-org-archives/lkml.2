Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2LMOBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:01:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44011 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab2LMOBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 015/241] target: Fix double-free of se_cmd in target_complete_tmr_failure
Date: Thu, 13 Dec 2012 11:56:20 -0200
Message-Id: <1355407206-17100-16-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit e13d5fef88c40b87c8430f8274c3a9ca32ef90bc upstream.

Fabric drivers currently expect to internally release se_cmd in the event
of a TMR failure during target_submit_tmr(), which means the immediate call
to transport_generic_free_cmd() after TFO->queue_tm_rsp() from within
target_complete_tmr_failure() workqueue context is wrong.

This is done as some fabrics expect TMR operations to be acknowledged
before releasing the descriptor, so the assumption that core is releasing
se_cmd associated TMR memory is incorrect.  This fixes a OOPs where
transport_generic_free_cmd() was being called more than once.

This bug was originally observed with tcm_qla2xxx fabric ports.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/target/target_core_transport.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0981707..7879ff4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1617,7 +1617,6 @@ static void target_complete_tmr_failure(struct work_struct *work)
 
 	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
-	transport_generic_free_cmd(se_cmd, 0);
 }
 
 /**
-- 
1.7.9.5

