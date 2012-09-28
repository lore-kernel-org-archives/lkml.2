Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031078Ab2I1TTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:19:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030614Ab2I1TEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:04:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 212/262] iwlwifi: fix flow handler debug code
Date: Fri, 28 Sep 2012 11:52:21 -0700
Message-Id: <20120928183023.134652453@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    2 -
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   30 +++++++++++-----------
 3 files changed, 18 insertions(+), 16 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -355,7 +355,7 @@ int iwl_queue_space(const struct iwl_que
 /*****************************************************
 * Error handling
 ******************************************************/
-int iwl_dump_fh(struct iwl_trans *trans, char **buf, bool display);
+int iwl_dump_fh(struct iwl_trans *trans, char **buf);
 void iwl_dump_csr(struct iwl_trans *trans);
 
 /*****************************************************
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -559,7 +559,7 @@ static void iwl_irq_handle_error(struct
 	}
 
 	iwl_dump_csr(trans);
-	iwl_dump_fh(trans, NULL, false);
+	iwl_dump_fh(trans, NULL);
 
 	iwl_op_mode_nic_error(trans->op_mode);
 }
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1655,13 +1655,9 @@ static const char *get_fh_string(int cmd
 #undef IWL_CMD
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
@@ -1673,29 +1669,35 @@ int iwl_dump_fh(struct iwl_trans *trans,
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
 				iwl_read_direct32(trans, fh_tbl[i]));
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
 			iwl_read_direct32(trans, fh_tbl[i]));
-	}
+
 	return 0;
 }
 
@@ -1990,11 +1992,11 @@ static ssize_t iwl_dbgfs_fh_reg_read(str
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


