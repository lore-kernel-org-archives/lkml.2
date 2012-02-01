Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2BAVPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:15:51 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43239 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932548Ab2BAVK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:28 -0500
X-Sasl-enc: ZcyGJCbP3QPnAymkuTXQ8+iv9iLJk7FYv9hZwQ/LUdnY 1328130626
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:48 2012
Message-Id: <20120201210048.559564337@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [53/89] iwlwifi: fix PCI-E transport "inta" race
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit b49ba04a3a0382e7314d990707c21094c410425a upstream.

When an interrupt comes in, we read the reason
bits and collect them into "trans_pcie->inta".
This happens with the spinlock held. However,
there's a bug resetting this variable -- that
happens after the spinlock has been released.
This means that it is possible for interrupts
to be missed if the reset happens after some
other interrupt reasons were already added to
the variable.

I found this by code inspection, looking for a
reason that we sometimes see random commands
time out. It seems possible that this causes
such behaviour, but I can't say for sure right
now since it happens extremely infrequently on
my test systems.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -957,11 +957,11 @@ void iwl_irq_tasklet(struct iwl_trans *t
 	}
 #endif
 
-	spin_unlock_irqrestore(&trans->shrd->lock, flags);
-
 	/* saved interrupt in inta variable now we can reset trans_pcie->inta */
 	trans_pcie->inta = 0;
 
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
+
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
 		IWL_ERR(trans, "Hardware error detected.  Restarting.\n");


