Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab2EaLv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:51:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49579 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2EaLv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:51:27 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] r8169: call netif_napi_del at errpaths and at driver unload
Date: Thu, 31 May 2012 17:21:20 +0530
Message-Id: <1338465080-22720-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when register_netdev fails, the init'ed NAPIs by netif_napi_add must be
deleted with netif_napi_del, and also when driver unloads, it should
delete the NAPI before unregistering netdevice using unregister_netdev.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 00b4f56..9757ce3 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6345,6 +6345,8 @@ static void __devexit rtl_remove_one(struct pci_dev *pdev)
 
 	cancel_work_sync(&tp->wk.work);
 
+	netif_napi_del(&tp->napi);
+
 	unregister_netdev(dev);
 
 	rtl_release_firmware(tp);
@@ -6668,6 +6670,7 @@ out:
 	return rc;
 
 err_out_msi_4:
+	netif_napi_del(&tp->napi);
 	rtl_disable_msi(pdev, tp);
 	iounmap(ioaddr);
 err_out_free_res_3:
-- 
1.7.9.5

