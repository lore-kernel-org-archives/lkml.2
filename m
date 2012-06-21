Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab2FUT4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:56:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53127 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759914Ab2FUT4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:56:16 -0400
Message-ID: <4FE37C5C.4090009@gmail.com>
Date: Thu, 21 Jun 2012 15:56:12 -0400
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, David Miller <davem@davemloft.net>,
        ilane@ti.com
CC: linux-kernel@vger.kernel.org, security@kernel.org,
        linux-netdev@vger.kernel.org
Subject: [PATCH] NFC: prevent multiple buffer overflows in NCI
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix multiple remotely-exploitable stack-based buffer overflows due to the NCI
code pulling length fields directly from incoming frames and copying too much
data into statically-sized arrays. Fortunately, there don't appear to be any
active users of this code (yet).

This patch fixes the overflows, but I suspect the code will need to be
completely reworked since this doesn't address the more systemic problem of
failing to check that the values read from incoming frame data aren't from
beyond the end of the pulled skb data. Build tested only.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: stable@kernel.org
Cc: security@kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ilan Elias <ilane@ti.com>
---
 net/nfc/nci/ntf.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index cb26461..2ab196a 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -106,7 +106,7 @@ static __u8 *nci_extract_rf_params_nfca_passive_poll(struct
nci_dev *ndev,
 	nfca_poll->sens_res = __le16_to_cpu(*((__u16 *)data));
 	data += 2;
 -	nfca_poll->nfcid1_len = *data++;
+	nfca_poll->nfcid1_len = min_t(__u8, *data++, NFC_NFCID1_MAXSIZE);
  	pr_debug("sens_res 0x%x, nfcid1_len %d\n",
 		 nfca_poll->sens_res, nfca_poll->nfcid1_len);
@@ -130,7 +130,7 @@ static __u8 *nci_extract_rf_params_nfcb_passive_poll(struct
nci_dev *ndev,
 			struct rf_tech_specific_params_nfcb_poll *nfcb_poll,
 						     __u8 *data)
 {
-	nfcb_poll->sensb_res_len = *data++;
+	nfcb_poll->sensb_res_len = min_t(__u8, *data++, NFC_SENSB_RES_MAXSIZE);
  	pr_debug("sensb_res_len %d\n", nfcb_poll->sensb_res_len);
 @@ -145,7 +145,7 @@ static __u8 *nci_extract_rf_params_nfcf_passive_poll(struct
nci_dev *ndev,
 						     __u8 *data)
 {
 	nfcf_poll->bit_rate = *data++;
-	nfcf_poll->sensf_res_len = *data++;
+	nfcf_poll->sensf_res_len = min_t(__u8, *data++, NFC_SENSF_RES_MAXSIZE);
  	pr_debug("bit_rate %d, sensf_res_len %d\n",
 		 nfcf_poll->bit_rate, nfcf_poll->sensf_res_len);
@@ -331,7 +331,7 @@ static int nci_extract_activation_params_iso_dep(struct
nci_dev *ndev,
 	switch (ntf->activation_rf_tech_and_mode) {
 	case NCI_NFC_A_PASSIVE_POLL_MODE:
 		nfca_poll = &ntf->activation_params.nfca_poll_iso_dep;
-		nfca_poll->rats_res_len = *data++;
+		nfca_poll->rats_res_len = min_t(__u8, *data++, 20);
 		pr_debug("rats_res_len %d\n", nfca_poll->rats_res_len);
 		if (nfca_poll->rats_res_len > 0) {
 			memcpy(nfca_poll->rats_res,
@@ -341,7 +341,7 @@ static int nci_extract_activation_params_iso_dep(struct
nci_dev *ndev,
  	case NCI_NFC_B_PASSIVE_POLL_MODE:
 		nfcb_poll = &ntf->activation_params.nfcb_poll_iso_dep;
-		nfcb_poll->attrib_res_len = *data++;
+		nfcb_poll->attrib_res_len = min_t(__u8, *data++, 50);
 		pr_debug("attrib_res_len %d\n", nfcb_poll->attrib_res_len);
 		if (nfcb_poll->attrib_res_len > 0) {
 			memcpy(nfcb_poll->attrib_res,


