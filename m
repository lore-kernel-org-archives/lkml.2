Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab2HPTDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:03:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48771 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031Ab2HPTDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:03:32 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] extcon: Ensure dynamically allocated sysfs attributes are initialised
Date: Thu, 16 Aug 2012 20:03:21 +0100
Message-Id: <1345143801-24357-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The operation of lockdep requires that all dynamically allocated sysfs
nodes are initialised using sysfs_attr_init() otherwise lots of warnings
are generated. Ensure that all the dynamically allocated attributes that
extcon generates have this done.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon_class.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index f6419f9..481cfa0 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -30,6 +30,7 @@
 #include <linux/err.h>
 #include <linux/extcon.h>
 #include <linux/slab.h>
+#include <linux/sysfs.h>
 
 /*
  * extcon_cable_name suggests the standard cable names for commonly used
@@ -673,10 +674,12 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 			cable->attr_g.name = str;
 			cable->attr_g.attrs = cable->attrs;
 
+			sysfs_attr_init(&cable->attr_name.attr);
 			cable->attr_name.attr.name = "name";
 			cable->attr_name.attr.mode = 0444;
 			cable->attr_name.show = cable_name_show;
 
+			sysfs_attr_init(&cable->attr_state.attr);
 			cable->attr_state.attr.name = "state";
 			cable->attr_state.attr.mode = 0644;
 			cable->attr_state.show = cable_state_show;
@@ -722,6 +725,7 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 				goto err_muex;
 			}
 			strcpy(name, buf);
+			sysfs_attr_init(&edev->d_attrs_muex[index].attr);
 			edev->d_attrs_muex[index].attr.name = name;
 			edev->d_attrs_muex[index].attr.mode = 0000;
 			edev->attrs_muex[index] = &edev->d_attrs_muex[index]
-- 
1.7.10.4

