Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161868Ab2GLXkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:40:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040Ab2GLWij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:38:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>, Ilan Elias <ilane@ti.com>,
        security@kernel.org
Subject: [ 046/187] NFC: Prevent multiple buffer overflows in NCI
Date: Thu, 12 Jul 2012 15:33:22 -0700
Message-Id: <20120712191526.629346123@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/nfc/nci/ntf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -106,7 +106,7 @@ static __u8 *nci_extract_rf_params_nfca_
 	nfca_poll->sens_res = __le16_to_cpu(*((__u16 *)data));
 	data += 2;
 
-	nfca_poll->nfcid1_len = *data++;
+	nfca_poll->nfcid1_len = min_t(__u8, *data++, NFC_NFCID1_MAXSIZE);
 
 	pr_debug("sens_res 0x%x, nfcid1_len %d\n",
 		 nfca_poll->sens_res, nfca_poll->nfcid1_len);
@@ -130,7 +130,7 @@ static __u8 *nci_extract_rf_params_nfcb_
 			struct rf_tech_specific_params_nfcb_poll *nfcb_poll,
 						     __u8 *data)
 {
-	nfcb_poll->sensb_res_len = *data++;
+	nfcb_poll->sensb_res_len = min_t(__u8, *data++, NFC_SENSB_RES_MAXSIZE);
 
 	pr_debug("sensb_res_len %d\n", nfcb_poll->sensb_res_len);
 
@@ -145,7 +145,7 @@ static __u8 *nci_extract_rf_params_nfcf_
 						     __u8 *data)
 {
 	nfcf_poll->bit_rate = *data++;
-	nfcf_poll->sensf_res_len = *data++;
+	nfcf_poll->sensf_res_len = min_t(__u8, *data++, NFC_SENSF_RES_MAXSIZE);
 
 	pr_debug("bit_rate %d, sensf_res_len %d\n",
 		 nfcf_poll->bit_rate, nfcf_poll->sensf_res_len);
@@ -331,7 +331,7 @@ static int nci_extract_activation_params
 	switch (ntf->activation_rf_tech_and_mode) {
 	case NCI_NFC_A_PASSIVE_POLL_MODE:
 		nfca_poll = &ntf->activation_params.nfca_poll_iso_dep;
-		nfca_poll->rats_res_len = *data++;
+		nfca_poll->rats_res_len = min_t(__u8, *data++, 20);
 		pr_debug("rats_res_len %d\n", nfca_poll->rats_res_len);
 		if (nfca_poll->rats_res_len > 0) {
 			memcpy(nfca_poll->rats_res,
@@ -341,7 +341,7 @@ static int nci_extract_activation_params
 
 	case NCI_NFC_B_PASSIVE_POLL_MODE:
 		nfcb_poll = &ntf->activation_params.nfcb_poll_iso_dep;
-		nfcb_poll->attrib_res_len = *data++;
+		nfcb_poll->attrib_res_len = min_t(__u8, *data++, 50);
 		pr_debug("attrib_res_len %d\n", nfcb_poll->attrib_res_len);
 		if (nfcb_poll->attrib_res_len > 0) {
 			memcpy(nfcb_poll->attrib_res,


