Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2JJOUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:20:22 -0400
Received: from mail.x86-64.org ([217.9.48.20]:44188 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab2JJOUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:20:16 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 2/3] Change mce_dont_log_ce
Date: Wed, 10 Oct 2012 16:20:00 +0200
Message-Id: <1349878801-15956-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349878801-15956-1-git-send-email-bp@amd64.org>
References: <1349878801-15956-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Not-Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       | 6 ++++++
 arch/x86/kernel/cpu/mcheck/mce.c | 9 +++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 54d73b1f00a0..18a66ac35fc5 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -207,6 +207,12 @@ extern void register_mce_write_callback(ssize_t (*)(struct file *filp,
 				    const char __user *ubuf,
 				    size_t usize, loff_t *off));
 
+struct mca_config {
+	u64 dont_log_ce	: 1,
+#define MCA_CFG_DONT_LOG_CE	0
+	    __resv1	: 63;
+};
+
 /*
  * Exception handler
  */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 29e87d3b2843..8925bcdc5816 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -79,7 +79,6 @@ static int			rip_msr			__read_mostly;
 static int			mce_bootlog		__read_mostly = -1;
 static int			monarch_timeout		__read_mostly = -1;
 static int			mce_panic_timeout	__read_mostly;
-static int			mce_dont_log_ce		__read_mostly;
 int				mce_cmci_disabled	__read_mostly;
 int				mce_ignore_ce		__read_mostly;
 int				mce_ser			__read_mostly;
@@ -87,6 +86,8 @@ int				mce_bios_cmci_threshold	__read_mostly;
 
 struct mce_bank                *mce_banks		__read_mostly;
 
+struct mca_config mca_cfg __read_mostly;
+
 /* User mode helper program triggered by machine check event */
 static unsigned long		mce_need_notify;
 static char			mce_helper[128];
@@ -631,7 +632,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
 		 */
-		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce)
+		if (!(flags & MCP_DONTLOG) && !mca_cfg.dont_log_ce)
 			mce_log(&m);
 
 		/*
@@ -1962,7 +1963,7 @@ static int __init mcheck_enable(char *str)
 	else if (!strcmp(str, "no_cmci"))
 		mce_cmci_disabled = 1;
 	else if (!strcmp(str, "dont_log_ce"))
-		mce_dont_log_ce = 1;
+		mca_cfg.dont_log_ce = 1;
 	else if (!strcmp(str, "ignore_ce"))
 		mce_ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
@@ -2192,7 +2193,7 @@ static ssize_t store_int_with_restart(struct device *s,
 static DEVICE_ATTR(trigger, 0644, show_trigger, set_trigger);
 static DEVICE_INT_ATTR(tolerant, 0644, tolerant);
 static DEVICE_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
-static DEVICE_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
+static DEVICE_BIT_ATTR(dont_log_ce, 0644, mca_cfg, MCA_CFG_DONT_LOG_CE);
 
 static struct dev_ext_attribute dev_attr_check_interval = {
 	__ATTR(check_interval, 0644, device_show_int, store_int_with_restart),
-- 
1.8.0.rc0.18.gf84667d

