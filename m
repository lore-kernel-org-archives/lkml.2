Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027Ab1BPAum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:50:42 -0500
Received: from kroah.org ([198.145.64.141]:45952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933240Ab1BPAu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:50:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:10 2011
Message-Id: <20110216002110.847388604@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [patch 118/176] ixgbe: fix for 82599 erratum on Header Splitting
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Don Skidmore <donald.c.skidmore@intel.com>

commit a124339ad28389093ed15eca990d39c51c5736cc upstream.

We have found a hardware erratum on 82599 hardware that can lead to
unpredictable behavior when Header Splitting mode is enabled.  So
we are no longer enabling this feature on affected hardware.

Please see the 82599 Specification Update for more information.

Signed-off-by: Don Skidmore <donald.c.skidmore@intel.com>
Tested-by: Stephen Ko <stephen.s.ko@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ixgbe/ixgbe_main.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -2651,9 +2651,16 @@ static void ixgbe_configure_rx(struct ix
 	int rx_buf_len;
 
 	/* Decide whether to use packet split mode or not */
+	/* On by default */
+	adapter->flags |= IXGBE_FLAG_RX_PS_ENABLED;
+
 	/* Do not use packet split if we're in SR-IOV Mode */
-	if (!adapter->num_vfs)
-		adapter->flags |= IXGBE_FLAG_RX_PS_ENABLED;
+	if (adapter->num_vfs)
+		adapter->flags &= ~IXGBE_FLAG_RX_PS_ENABLED;
+
+	/* Disable packet split due to 82599 erratum #45 */
+	if (hw->mac.type == ixgbe_mac_82599EB)
+		adapter->flags &= ~IXGBE_FLAG_RX_PS_ENABLED;
 
 	/* Set the RX buffer length according to the mode */
 	if (adapter->flags & IXGBE_FLAG_RX_PS_ENABLED) {


