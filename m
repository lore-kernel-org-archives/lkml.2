Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab2JKC0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:26:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42232 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933994Ab2JKC0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:26:45 -0400
X-Sasl-enc: Vlx6sDZFDTDVDhkMljYY/b3pClIQoGnuzFX9BB8SnPjF 1349922403
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Devendra Naga <devendra.aaru@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 73/84] r8169: call netif_napi_del at errpaths and at driver unload
Date: Thu, 11 Oct 2012 11:03:57 +0900
Message-Id: <20121011015430.202473167@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devendra Naga <devendra.aaru@gmail.com>

commit ad1be8d345416a794dea39761a374032aa471a76 upstream.

When register_netdev fails, the init'ed NAPIs by netif_napi_add must be
deleted with netif_napi_del, and also when driver unloads, it should
delete the NAPI before unregistering netdevice using unregister_netdev.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3706,6 +3706,7 @@ out:
 	return rc;
 
 err_out_msi_4:
+	netif_napi_del(&tp->napi);
 	rtl_disable_msi(pdev, tp);
 	iounmap(ioaddr);
 err_out_free_res_3:
@@ -3731,6 +3732,8 @@ static void __devexit rtl8169_remove_one
 
 	cancel_delayed_work_sync(&tp->task);
 
+	netif_napi_del(&tp->napi);
+
 	unregister_netdev(dev);
 
 	rtl_release_firmware(tp);


