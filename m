Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab2ADWDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:03:42 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:33837 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab2ADWDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:03:39 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: venkat.x.venkatsubra@oracle.com
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        dledford@redhat.com, Jes.Sorensen@redhat.com, rds-devel@oss.oracle.com
Subject: [PATCH] rds_rdma: don't assume infiniband device is PCI
Date: Wed,  4 Jan 2012 20:03:16 -0200
Message-Id: <1325714596-4655-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 12010422-9254-0000-0000-000007BB9CA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RDS code assumes that the struct ib_device dma_device member, which is a
pointer, points to a struct device embedded in a struct pci_dev.

This is not the case for ehca, for example, which is a OF driver, and
makes dma_device point to a struct device embedded in a struct
platform_device.

This will make the system crash when rds_rdma is loaded in a system
with ehca, since it will try to access the bus member of a non-existent
struct pci_dev.

The only reason rds_rdma uses the struct pci_dev is to get the NUMA node
the device is attached to. Using dev_to_node for that is much better,
since it won't assume which bus the infiniband is attached to.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: dledford@redhat.com
Cc: Jes.Sorensen@redhat.com
Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Cc: rds-devel@oss.oracle.com
---
 net/rds/ib.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index edfaaaf..8d2b3d5 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -186,8 +186,7 @@ struct rds_ib_device {
 	struct work_struct	free_work;
 };
 
-#define pcidev_to_node(pcidev) pcibus_to_node(pcidev->bus)
-#define ibdev_to_node(ibdev) pcidev_to_node(to_pci_dev(ibdev->dma_device))
+#define ibdev_to_node(ibdev) dev_to_node(ibdev->dma_device)
 #define rdsibdev_to_node(rdsibdev) ibdev_to_node(rdsibdev->dev)
 
 /* bits for i_ack_flags */
-- 
1.7.4.4

