Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab1LNPqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:46:36 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:45161 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093Ab1LNPqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:46:34 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: netdev@vger.kernel.org, kxie@chelsio.com, michaelc@cs.wisc.edu,
        davem@davemloft.net, JBottomley@parallels.com,
        linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [PATCH] libcxgbi: do not print a message when memory allocation fails
Date: Wed, 14 Dec 2011 13:46:23 -0200
Message-Id: <1323877583-6844-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 11121415-8936-0000-0000-0000055C707D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In alloc_pdu, libcxgbi tries to allocate a skb with GFP_ATOMIC, which
may potentially fail. When it happens, the current code prints a warning
message.

When the system is under IO stress, this failure may happen lots of
times and it usually scares users.

Instead of printing the warning message, the code now increases the
tx_dropped statistics for the ethernet interface wich is doing the iscsi
task.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/scsi/cxgbi/libcxgbi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index c10f74a..3422bc2 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1862,8 +1862,9 @@ int cxgbi_conn_alloc_pdu(struct iscsi_task *task, u8 opcode)
 
 	tdata->skb = alloc_skb(cdev->skb_tx_rsvd + headroom, GFP_ATOMIC);
 	if (!tdata->skb) {
-		pr_warn("alloc skb %u+%u, opcode 0x%x failed.\n",
-			cdev->skb_tx_rsvd, headroom, opcode);
+		struct cxgbi_sock *csk = cconn->cep->csk;
+		struct net_device *ndev = cdev->ports[csk->port_id];
+		ndev->stats.tx_dropped++;
 		return -ENOMEM;
 	}
 
-- 
1.7.4.4

