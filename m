Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2ATQRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:17:41 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:48821 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab2ATQR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:17:29 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/mKGUPvKxZDRxn3ePGOCuV
Subject: [PATCH 1/4] pinctrl: Free debugfs entries when unloading a pinmux
 driver
To: linux-kernel@vger.kernel.org
From: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Date: Fri, 20 Jan 2012 08:17:22 -0800
Message-ID: <20120120161722.21955.90415.stgit@kaulin.local>
In-Reply-To: <20120120161610.21955.25082.stgit@kaulin.local>
References: <20120120161610.21955.25082.stgit@kaulin.local>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free debugfs entries when unloading a pinmux driver

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/pinctrl/core.c |   14 +++++++++++++-
 drivers/pinctrl/core.h |    3 +++
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 569bdb3..d9d35fc 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -510,10 +510,12 @@ static struct dentry *debugfs_root;
 
 static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 {
-	static struct dentry *device_root;
+	struct dentry *device_root;
 
 	device_root = debugfs_create_dir(dev_name(pctldev->dev),
 					 debugfs_root);
+	pctldev->device_root = device_root;
+
 	if (IS_ERR(device_root) || !device_root) {
 		pr_warn("failed to create debugfs directory for %s\n",
 			dev_name(pctldev->dev));
@@ -529,6 +531,11 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 	pinconf_init_device_debugfs(device_root, pctldev);
 }
 
+static void pinctrl_remove_device_debugfs(struct pinctrl_dev *pctldev)
+{
+	debugfs_remove_recursive(pctldev->device_root);
+}
+
 static void pinctrl_init_debugfs(void)
 {
 	debugfs_root = debugfs_create_dir("pinctrl", NULL);
@@ -553,6 +560,10 @@ static void pinctrl_init_debugfs(void)
 {
 }
 
+static void pinctrl_remove_device_debugfs(struct pinctrl_dev *pctldev)
+{
+}
+
 #endif
 
 /**
@@ -641,6 +652,7 @@ void pinctrl_unregister(struct pinctrl_dev *pctldev)
 	if (pctldev == NULL)
 		return;
 
+	pinctrl_remove_device_debugfs(pctldev);
 	pinmux_unhog_maps(pctldev);
 	/* TODO: check that no pinmuxes are still active? */
 	mutex_lock(&pinctrldev_list_mutex);
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 177a331..cfa86da 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -41,6 +41,9 @@ struct pinctrl_dev {
 	struct device *dev;
 	struct module *owner;
 	void *driver_data;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *device_root;
+#endif
 #ifdef CONFIG_PINMUX
 	struct mutex pinmux_hogs_lock;
 	struct list_head pinmux_hogs;

