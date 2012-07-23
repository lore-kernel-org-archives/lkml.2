Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab2GWCD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:03:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54105 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141Ab2GWBml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:41 -0400
Message-Id: <20120723010704.685500627@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:18 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Devendra Naga <devendra.aaru@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 087/108] r8169: call netif_napi_del at errpaths and at driver unload
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devendra Naga <devendra.aaru@gmail.com>

commit ad1be8d345416a794dea39761a374032aa471a76 upstream.

when register_netdev fails, the init'ed NAPIs by netif_napi_add must be
deleted with netif_napi_del, and also when driver unloads, it should
delete the NAPI before unregistering netdevice using unregister_netdev.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/realtek/r8169.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4185,6 +4185,7 @@ out:
 	return rc;
 
 err_out_msi_4:
+	netif_napi_del(&tp->napi);
 	rtl_disable_msi(pdev, tp);
 	iounmap(ioaddr);
 err_out_free_res_3:
@@ -4210,6 +4211,8 @@ static void __devexit rtl8169_remove_one
 
 	cancel_delayed_work_sync(&tp->task);
 
+	netif_napi_del(&tp->napi);
+
 	unregister_netdev(dev);
 
 	rtl_release_firmware(tp);


