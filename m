Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964Ab2JKCUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:20:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47178 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964831Ab2JKCPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:15:09 -0400
X-Sasl-enc: YFsIT47uk3R7NXZYgpVeEyZ5CYoFOF4z+gfQKWxIe5BL 1349921707
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>, Hayes <hayeswang@realtek.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 62/84] r8169: remove erroneous processing of always set bit.
Date: Thu, 11 Oct 2012 11:03:46 +0900
Message-Id: <20121011015428.237978108@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit e03f33af79f0772156e1a1a1e36bdddf8012b2e4 upstream.

When set, RxFOVF (resp. RxBOVF) is always 1 (resp. 0).

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes <hayeswang@realtek.com>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -388,6 +388,7 @@ enum rtl_register_content {
 	RxOK		= 0x0001,
 
 	/* RxStatusDesc */
+	RxBOVF	= (1 << 24),
 	RxFOVF	= (1 << 23),
 	RxRWT	= (1 << 22),
 	RxRES	= (1 << 21),
@@ -666,6 +667,7 @@ struct rtl8169_private {
 	struct mii_if_info mii;
 	struct rtl8169_counters counters;
 	u32 saved_wolopts;
+	u32 opts1_mask;
 
 	const struct firmware *fw;
 #define RTL_FIRMWARE_UNKNOWN	ERR_PTR(-EAGAIN);
@@ -3442,6 +3444,9 @@ rtl8169_init_one(struct pci_dev *pdev, c
 	tp->intr_event = cfg->intr_event;
 	tp->napi_event = cfg->napi_event;
 
+	tp->opts1_mask = (tp->mac_version != RTL_GIGA_MAC_VER_01) ?
+		~(RxBOVF | RxFOVF) : ~0;
+
 	init_timer(&tp->timer);
 	tp->timer.data = (unsigned long) dev;
 	tp->timer.function = rtl8169_phy_timer;
@@ -4920,7 +4925,7 @@ static int rtl8169_rx_interrupt(struct n
 		u32 status;
 
 		rmb();
-		status = le32_to_cpu(desc->opts1);
+		status = le32_to_cpu(desc->opts1) & tp->opts1_mask;
 
 		if (status & DescOwn)
 			break;


