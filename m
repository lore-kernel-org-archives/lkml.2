Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2E2J7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:59:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14256 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2E2J7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:59:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 29 May 2012 02:59:40 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Mike Turquette <mturquette@ti.com>, Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] clk: add extension API
Date: Tue, 29 May 2012 12:58:59 +0300
Message-ID: <1338285540-24407-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an extension API for clocks. This allows clocktypes to provide extensions
for features which are uncommon and cannot be easily mapped onto normal clock
framework concecpts. eg: resetting blocks, configuring clock phase etc.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 drivers/clk/clk.c            |    8 ++++++++
 include/linux/clk-provider.h |    2 ++
 include/linux/clk.h          |    2 ++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index e5d5dc1..39bc458 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -956,6 +956,14 @@ struct clk *clk_get_parent(struct clk *clk)
 }
 EXPORT_SYMBOL_GPL(clk_get_parent);
 
+int clk_ext(struct clk *clk, unsigned int op, unsigned long param)
+{
+	if (clk->ops->ext)
+		return clk->ops->ext(clk->hw, op, param);
+
+	return -EINVAL;
+}
+
 /*
  * .get_parent is mandatory for clocks with multiple possible parents.  It is
  * optional for single-parent clocks.  Always call .get_parent if it is
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 6803fb4..08025d3 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -109,6 +109,8 @@ struct clk_ops {
 	int		(*set_rate)(struct clk_hw *hw, unsigned long,
 				    unsigned long);
 	void		(*init)(struct clk_hw *hw);
+	int		(*ext)(struct clk_hw *hw, unsigned int op,
+					unsigned long param);
 };
 
 /**
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 0e078bd..74be656 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -278,4 +278,6 @@ struct clk *clk_get_sys(const char *dev_id, const char *con_id);
 int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
 			struct device *dev);
 
+int clk_ext(struct clk *clk, unsigned int op, unsigned long param);
+
 #endif
-- 
1.7.9.1

