Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2GIOrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:47:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38131 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754332Ab2GIOiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:00 -0400
Message-Id: <20120709143117.360564794@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>, Ilan Elias <ilane@ti.com>
Subject: [ 05/48] NFC: Prevent multiple buffer overflows in NCI
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Rosenberg <dan.j.rosenberg@gmail.com>

commit 67de956ff5dc1d4f321e16cfbd63f5be3b691b43 upstream.

Fix multiple remotely-exploitable stack-based buffer overflows due to
the NCI code pulling length fields directly from incoming frames and
copying too much data into statically-sized arrays.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: security@kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Ilan Elias <ilane@ti.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
[bwh: Backported to 3.2:
 - Drop changes to parsing of tech B and tech F parameters
 - Various renaming]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -86,7 +86,7 @@ static int nci_rf_activate_nfca_passive_
 	nfca_poll->sens_res = __le16_to_cpu(*((__u16 *)data));
 	data += 2;
 
-	nfca_poll->nfcid1_len = *data++;
+	nfca_poll->nfcid1_len = min_t(__u8, *data++, sizeof(nfca_poll->nfcid1));
 
 	nfc_dbg("sens_res 0x%x, nfcid1_len %d",
 		nfca_poll->sens_res,
@@ -111,7 +111,7 @@ static int nci_rf_activate_nfca_passive_
 
 	switch (ntf->rf_interface_type) {
 	case NCI_RF_INTERFACE_ISO_DEP:
-		nfca_poll_iso_dep->rats_res_len = *data++;
+		nfca_poll_iso_dep->rats_res_len = min_t(__u8, *data++, 20);
 		if (nfca_poll_iso_dep->rats_res_len > 0) {
 			memcpy(nfca_poll_iso_dep->rats_res,
 				data,


