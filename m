Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1ABHYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:24:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:36510 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab1ABHYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Luca Tettamanti <kronos.it@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 188/260] atl1: fix resume
Date: Sun,  2 Jan 2011 02:18:04 -0500
Message-Id: <1293952756-15010-189-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:36.0823 (UTC) FILETIME=[F87B6070:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luca Tettamanti <kronos.it@gmail.com>

commit ec5a32f67c603b11d68eb283d94eb89a4f6cfce1 upstream.

adapter->cmb.cmb is initialized when the device is opened and freed when
it's closed. Accessing it unconditionally during resume results either
in a crash (NULL pointer dereference, when the interface has not been
opened yet) or data corruption (when the interface has been used and
brought down adapter->cmb.cmb points to a deallocated memory area).

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Acked-by: Chris Snook <chris.snook@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/atlx/atl1.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 0ebd820..9d9ba41 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2849,10 +2849,11 @@ static int atl1_resume(struct pci_dev *pdev)
 	pci_enable_wake(pdev, PCI_D3cold, 0);
 
 	atl1_reset_hw(&adapter->hw);
-	adapter->cmb.cmb->int_stats = 0;
 
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		adapter->cmb.cmb->int_stats = 0;
 		atl1_up(adapter);
+	}
 	netif_device_attach(netdev);
 
 	return 0;
-- 
1.7.3.3

