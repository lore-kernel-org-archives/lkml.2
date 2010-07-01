Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab0GAVFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:05:40 -0400
Received: from kroah.org ([198.145.64.141]:47822 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932818Ab0GAUvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:07 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:37 2010
Message-Id: <20100701173437.171783414@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: [patch 123/164] iwlwifi: reset card during probe
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

commit 4843b5a731b31916d100cfc5ba4d03ae78462ed9 upstream.

To ensure that card is in a sane state during probe we add a reset call.
This change was prompted by users of kdump who was not able to bring up the
wireless driver in the kdump kernel. The problem here was that the primary
kernel, which is not running at the time, left the wireless card up and
running. When the kdump kernel starts it is thus possible to immediately
receive interrupts from firmware after registering interrupt, but without
being ready to deal with interrupts from firmware yet.

Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +++++++
 2 files changed, 15 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3365,6 +3365,14 @@ static int iwl_pci_probe(struct pci_dev
 	 */
 	spin_lock_init(&priv->reg_lock);
 	spin_lock_init(&priv->lock);
+
+	/*
+	 * stop and reset the on-board processor just in case it is in a
+	 * strange state ... like being left stranded by a primary kernel
+	 * and this is now the kdump kernel trying to start up
+	 */
+	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+
 	iwl_hw_detect(priv);
 	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s REV=0x%X\n",
 		priv->cfg->name, priv->hw_rev);
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4022,6 +4022,13 @@ static int iwl3945_pci_probe(struct pci_
 	spin_lock_init(&priv->reg_lock);
 	spin_lock_init(&priv->lock);
 
+	/*
+	 * stop and reset the on-board processor just in case it is in a
+	 * strange state ... like being left stranded by a primary kernel
+	 * and this is now the kdump kernel trying to start up
+	 */
+	iwl_write32(priv, CSR_RESET, CSR_RESET_REG_FLAG_NEVO_RESET);
+
 	/***********************
 	 * 4. Read EEPROM
 	 * ********************/


