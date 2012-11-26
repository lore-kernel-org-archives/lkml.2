Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2KZTUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:20:15 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40019 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab2KZTUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:20:13 -0500
From: Russ Dill <Russ.Dill@ti.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: mturquette@ti.com, Russ Dill <Russ.Dill@ti.com>
Subject: [PATCH] Don't mark shared helper functions as inline
Date: Mon, 26 Nov 2012 11:20:09 -0800
Message-Id: <1353957609-1295-1-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper functions that access the opaque struct clk should
not be marked inline since they are contained in clk.c, but expected
to be used by other compilation units. This causes compile errors
under gcc-4.7

In file included from arch/arm/mach-omap2/clockdomain.c:25:0:
arch/arm/mach-omap2/clockdomain.c: In function ‘clkdm_clk_disable’:
include/linux/clk-provider.h:338:12: error: inlining failed in call to always_inline ‘__clk_get_enable_count’: function body not available
arch/arm/mach-omap2/clockdomain.c:1001:28: error: called from here
make[1]: *** [arch/arm/mach-omap2/clockdomain.o] Error 1
make: *** [arch/arm/mach-omap2] Error 2


Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 drivers/clk/clk.c            | 14 +++++++-------
 include/linux/clk-provider.h |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 56e4495e..ed01746 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -249,32 +249,32 @@ late_initcall(clk_disable_unused);
 
 /***    helper functions   ***/
 
-inline const char *__clk_get_name(struct clk *clk)
+const char *__clk_get_name(struct clk *clk)
 {
 	return !clk ? NULL : clk->name;
 }
 
-inline struct clk_hw *__clk_get_hw(struct clk *clk)
+struct clk_hw *__clk_get_hw(struct clk *clk)
 {
 	return !clk ? NULL : clk->hw;
 }
 
-inline u8 __clk_get_num_parents(struct clk *clk)
+u8 __clk_get_num_parents(struct clk *clk)
 {
 	return !clk ? -EINVAL : clk->num_parents;
 }
 
-inline struct clk *__clk_get_parent(struct clk *clk)
+struct clk *__clk_get_parent(struct clk *clk)
 {
 	return !clk ? NULL : clk->parent;
 }
 
-inline int __clk_get_enable_count(struct clk *clk)
+int __clk_get_enable_count(struct clk *clk)
 {
 	return !clk ? -EINVAL : clk->enable_count;
 }
 
-inline int __clk_get_prepare_count(struct clk *clk)
+int __clk_get_prepare_count(struct clk *clk)
 {
 	return !clk ? -EINVAL : clk->prepare_count;
 }
@@ -300,7 +300,7 @@ out:
 	return ret;
 }
 
-inline unsigned long __clk_get_flags(struct clk *clk)
+unsigned long __clk_get_flags(struct clk *clk)
 {
 	return !clk ? -EINVAL : clk->flags;
 }
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index c127315..f9f5e9e 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -335,8 +335,8 @@ const char *__clk_get_name(struct clk *clk);
 struct clk_hw *__clk_get_hw(struct clk *clk);
 u8 __clk_get_num_parents(struct clk *clk);
 struct clk *__clk_get_parent(struct clk *clk);
-inline int __clk_get_enable_count(struct clk *clk);
-inline int __clk_get_prepare_count(struct clk *clk);
+int __clk_get_enable_count(struct clk *clk);
+int __clk_get_prepare_count(struct clk *clk);
 unsigned long __clk_get_rate(struct clk *clk);
 unsigned long __clk_get_flags(struct clk *clk);
 int __clk_is_enabled(struct clk *clk);
-- 
1.8.0

