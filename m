Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab2JDBi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:38:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39900 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2JDBi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:38:26 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-37-506ce89016b5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] extcon: MAX77693: Add platform data for MUIC device to
 initialize registers
Date: Thu, 04 Oct 2012 10:38:18 +0900
Message-id: <1349314698-3926-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jAd0JL3ICDE5/kLW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZL+7PYi6YKFrRsEetgfG6YBcjJ4eEgInE1VuP2CBsMYkL99YD
	2VwcQgKLGCWe7t/MAuEsZZLYdeopK0gVm4CWxP4XN8A6RAQUJDb3PgOLMwtUS5w7dRksLiwQ
	J3Fy0wsmEJtFQFVi67fTjCA2r4CLxMHeOywQ2xQkWpcdYp/AyL2AkWEVo2hqQXJBcVJ6rpFe
	cWJucWleul5yfu4mRrAHn0nvYFzVYHGIUYCDUYmH12JSToAQa2JZcWXuIUYJDmYlEV7jrUAh
	3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFCAumJJanZqakFqUUwWSYOTqkGxoBr6/PFFMSO
	OKsssNh8ZM20sm1ZcpnPvSe+ZjwXnFq7WXrrIu7zfH6qOl49xbpema+uzz2YNf/yg3WxGnx1
	G1xlA5L554p0nd/jKBZ878w1ydK4nQ++3Nj/3CiypNb7a7DDhvBvmb/KPHImnNrj0rarY479
	pUPBmrqrji10Wrrv6syOetVXCUosxRmJhlrMRcWJAJLAKKLcAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add platform data for MUIC device to initialize register
on probe() call because it should unmask interrupt mask register
and initialize some register related to MUIC device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/extcon/extcon-max77693.c |   27 +++++++++++++++++++++++++++
 include/linux/mfd/max77693.h     |   13 +++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index ac9bac8..3e9520a 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -651,6 +651,8 @@ out:
 static int __devinit max77693_muic_probe(struct platform_device *pdev)
 {
 	struct max77693_dev *max77693 = dev_get_drvdata(pdev->dev.parent);
+	struct max77693_platform_data *pdata = dev_get_platdata(max77693->dev);
+	struct max77693_muic_platform_data *muic_pdata = pdata->muic_data;
 	struct max77693_muic_info *info;
 	int ret, i;
 	u8 id;
@@ -721,6 +723,31 @@ static int __devinit max77693_muic_probe(struct platform_device *pdev)
 		goto err_extcon;
 	}
 
+	/* Initialize MUIC register by using platform data */
+	for (i = 0 ; i < muic_pdata->num_init_data ; i++) {
+		enum max77693_irq_source irq_src = MAX77693_IRQ_GROUP_NR;
+
+		max77693_write_reg(info->max77693->regmap_muic,
+				muic_pdata->init_data[i].addr,
+				muic_pdata->init_data[i].data);
+
+		switch (muic_pdata->init_data[i].addr) {
+		case MAX77693_MUIC_REG_INTMASK1:
+			irq_src = MUIC_INT1;
+			break;
+		case MAX77693_MUIC_REG_INTMASK2:
+			irq_src = MUIC_INT2;
+			break;
+		case MAX77693_MUIC_REG_INTMASK3:
+			irq_src = MUIC_INT3;
+			break;
+		}
+
+		if (irq_src < MAX77693_IRQ_GROUP_NR)
+			info->max77693->irq_masks_cur[irq_src]
+				= muic_pdata->init_data[i].data;
+	}
+
 	/* Check revision number of MUIC device*/
 	ret = max77693_read_reg(info->max77693->regmap_muic,
 			MAX77693_MUIC_REG_ID, &id);
diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index 1d28ae9..fe03b2d 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -30,7 +30,20 @@
 #ifndef __LINUX_MFD_MAX77693_H
 #define __LINUX_MFD_MAX77693_H
 
+struct max77693_reg_data {
+	u8 addr;
+	u8 data;
+};
+
+struct max77693_muic_platform_data {
+	struct max77693_reg_data *init_data;
+	int num_init_data;
+};
+
 struct max77693_platform_data {
 	int wakeup;
+
+	/* muic data */
+	struct max77693_muic_platform_data *muic_data;
 };
 #endif	/* __LINUX_MFD_MAX77693_H */
-- 
1.7.0.4

