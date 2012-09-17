Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab2IQAuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33372 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026Ab2IQAtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:36 -0400
Message-Id: <20120917003626.895040502@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 005/135] iwlwifi: fix flow handler debug code
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 94543a8d4fb302817014981489f15cb3b92ec3c2 upstream.

iwl_dbgfs_fh_reg_read() can cause crashes and/or
BUG_ON in slub because the ifdefs are wrong, the
code in iwl_dump_fh() should use DEBUGFS, not
DEBUG to protect the buffer writing code.

Also, while at it, clean up the arguments to the
function, some code and make it generally safer.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust filenames and context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -303,7 +303,7 @@ int iwl_queue_space(const struct iwl_que
 ******************************************************/
 int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 			    char **buf, bool display);
-int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display);
+int iwl_dump_fh(struct iwl_trans *trans, char **buf);
 void iwl_dump_csr(struct iwl_trans *trans);
 
 /*****************************************************
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -678,7 +678,7 @@ static void iwl_irq_handle_error(struct
 
 	iwl_dump_nic_error_log(trans);
 	iwl_dump_csr(trans);
-	iwl_dump_fh(trans, NULL, false);
+	iwl_dump_fh(trans, NULL);
 	iwl_dump_nic_event_log(trans, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(trans->shrd) & IWL_DL_FW_ERRORS)
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1541,13 +1541,9 @@ static const char *get_fh_string(int cmd
 	}
 }
 
-int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display)
+int iwl_dump_fh(struct iwl_trans *trans, char **buf)
 {
 	int i;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	int pos = 0;
-	size_t bufsz = 0;
-#endif
 	static const u32 fh_tbl[] = {
 		FH_RSCSR_CHNL0_STTS_WPTR_REG,
 		FH_RSCSR_CHNL0_RBDCB_BASE_REG,
@@ -1559,29 +1555,35 @@ int iwl_dump_fh(struct iwl_trans *trans,
 		FH_TSSR_TX_STATUS_REG,
 		FH_TSSR_TX_ERROR_REG
 	};
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (display) {
-		bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (buf) {
+		int pos = 0;
+		size_t bufsz = ARRAY_SIZE(fh_tbl) * 48 + 40;
+
 		*buf = kmalloc(bufsz, GFP_KERNEL);
 		if (!*buf)
 			return -ENOMEM;
+
 		pos += scnprintf(*buf + pos, bufsz - pos,
 				"FH register values:\n");
-		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++) {
+
+		for (i = 0; i < ARRAY_SIZE(fh_tbl); i++)
 			pos += scnprintf(*buf + pos, bufsz - pos,
 				"  %34s: 0X%08x\n",
 				get_fh_string(fh_tbl[i]),
 				iwl_read_direct32(bus(trans), fh_tbl[i]));
-		}
+
 		return pos;
 	}
 #endif
+
 	IWL_ERR(trans, "FH register values:\n");
-	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++) {
+	for (i = 0; i <  ARRAY_SIZE(fh_tbl); i++)
 		IWL_ERR(trans, "  %34s: 0X%08x\n",
 			get_fh_string(fh_tbl[i]),
 			iwl_read_direct32(bus(trans), fh_tbl[i]));
-	}
+
 	return 0;
 }
 
@@ -1929,11 +1931,11 @@ static ssize_t iwl_dbgfs_fh_reg_read(str
 					 size_t count, loff_t *ppos)
 {
 	struct iwl_trans *trans = file->private_data;
-	char *buf;
+	char *buf = NULL;
 	int pos = 0;
 	ssize_t ret = -EFAULT;
 
-	ret = pos = iwl_dump_fh(trans, &buf, true);
+	ret = pos = iwl_dump_fh(trans, &buf);
 	if (buf) {
 		ret = simple_read_from_buffer(user_buf,
 					      count, ppos, buf, pos);


