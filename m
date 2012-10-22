Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab2JVAkt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:40:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43629 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab2JVAks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:40:48 -0400
Message-ID: <50849604.9050109@oracle.com>
Date: Mon, 22 Oct 2012 08:40:36 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>,
        Linux Driver <Linux-Driver@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
CC: netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Greg Marsden <greg.marsden@oracle.com>
Subject: [PATCH] qla3xxx: Ensure request/response queue addr writes to the
 registers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before use the request and response queue addr, make sure it has wrote
to the registers.

Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
Cc: Ron Mercer <ron.mercer@qlogic.com>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index df09b1c..6407d0d 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2525,6 +2525,13 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
 	qdev->req_q_size =
 	    (u32) (NUM_REQ_Q_ENTRIES * sizeof(struct ob_mac_iocb_req));
 
+	qdev->rsp_q_size = NUM_RSP_Q_ENTRIES * sizeof(struct net_rsp_iocb);
+
+	/* The barrier is required to ensure request and response queue
+	 * addr writes to the registers.
+	 */
+	wmb();
+
 	qdev->req_q_virt_addr =
 	    pci_alloc_consistent(qdev->pdev,
 				 (size_t) qdev->req_q_size,
@@ -2536,8 +2543,6 @@ static int ql_alloc_net_req_rsp_queues(struct ql3_adapter *qdev)
 		return -ENOMEM;
 	}
 
-	qdev->rsp_q_size = NUM_RSP_Q_ENTRIES * sizeof(struct net_rsp_iocb);
-
 	qdev->rsp_q_virt_addr =
 	    pci_alloc_consistent(qdev->pdev,
 				 (size_t) qdev->rsp_q_size,
-- 
1.7.11.7

