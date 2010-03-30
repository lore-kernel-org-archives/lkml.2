Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab0C3Chy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 22:37:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59908 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724Ab0C3Chw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 22:37:52 -0400
Date: Tue, 30 Mar 2010 13:37:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shanyu Zhao <shanyu.zhao@intel.com>, Zhu Yi <yi.zhu@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20100330133745.27295ee0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-agn.c between commit
d4dca4e53fde2953d74198a2c445db1d36ed9fd2 ("iwlwifi: clear unattended
interrupts in tasklet") from the wireless-current tree and commit
a4c8b2a692601de0a7bcb032b69f806050944dff ("iwlwifi: move ICT data to agn
part of union") from the net tree.

I fixed it up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-agn.c
index e4c2e1e,0a376f7..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@@ -1258,17 -1236,9 +1236,17 @@@ static void iwl_irq_tasklet(struct iwl_
  	/* Ack/clear/reset pending uCode interrupts.
  	 * Note:  Some bits in CSR_INT are "OR" of bits in CSR_FH_INT_STATUS,
  	 */
 -	iwl_write32(priv, CSR_INT, priv->_agn.inta);
 +	/* There is a hardware bug in the interrupt mask function that some
 +	 * interrupts (i.e. CSR_INT_BIT_SCD) can still be generated even if
 +	 * they are disabled in the CSR_INT_MASK register. Furthermore the
 +	 * ICT interrupt handling mechanism has another bug that might cause
 +	 * these unmasked interrupts fail to be detected. We workaround the
 +	 * hardware bugs here by ACKing all the possible interrupts so that
 +	 * interrupt coalescing can still be achieved.
 +	 */
- 	iwl_write32(priv, CSR_INT, priv->inta | ~priv->inta_mask);
++	iwl_write32(priv, CSR_INT, priv->_agn.inta | ~priv->inta_mask);
  
- 	inta = priv->inta;
+ 	inta = priv->_agn.inta;
  
  #ifdef CONFIG_IWLWIFI_DEBUG
  	if (iwl_get_debug_level(priv) & IWL_DL_ISR) {
