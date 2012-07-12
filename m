Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab2GLWhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:37:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57335 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759452Ab2GLWhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:37:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Devendra Naga <devendra.aaru@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 021/187] r8169: call netif_napi_del at errpaths and at driver unload
Date: Thu, 12 Jul 2012 15:32:57 -0700
Message-Id: <20120712191524.229526261@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Devendra Naga <devendra.aaru@gmail.com>

[ Upstream commit ad1be8d345416a794dea39761a374032aa471a76 ]

when register_netdev fails, the init'ed NAPIs by netif_napi_add must be
deleted with netif_napi_del, and also when driver unloads, it should
delete the NAPI before unregistering netdevice using unregister_netdev.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5966,6 +5966,8 @@ static void __devexit rtl_remove_one(str
 
 	cancel_work_sync(&tp->wk.work);
 
+	netif_napi_del(&tp->napi);
+
 	unregister_netdev(dev);
 
 	rtl_release_firmware(tp);
@@ -6288,6 +6290,7 @@ out:
 	return rc;
 
 err_out_msi_4:
+	netif_napi_del(&tp->napi);
 	rtl_disable_msi(pdev, tp);
 	iounmap(ioaddr);
 err_out_free_res_3:


