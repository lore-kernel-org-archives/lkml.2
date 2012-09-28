Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293Ab2I1S7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:59:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965241Ab2I1S7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Arend Van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 120/262] brcmfmac: Fix big endian host configuration data.
Date: Fri, 28 Sep 2012 11:50:49 -0700
Message-Id: <20120928183012.282898579@linuxfoundation.org>
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

From: Hante Meuleman <meuleman@broadcom.com>

commit e020a83d0942a5aceac35986500c9834efc8707d upstream.

Fixes big endian host configuration parameters.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c |   26 +++++++++++--------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -764,8 +764,11 @@ static void brcmf_c_arp_offload_set(stru
 {
 	char iovbuf[32];
 	int retcode;
+	__le32 arp_mode_le;
 
-	brcmf_c_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
+	arp_mode_le = cpu_to_le32(arp_mode);
+	brcmf_c_mkiovar("arp_ol", (char *)&arp_mode_le, 4, iovbuf,
+			sizeof(iovbuf));
 	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
@@ -781,8 +784,11 @@ static void brcmf_c_arp_offload_enable(s
 {
 	char iovbuf[32];
 	int retcode;
+	__le32 arp_enable_le;
 
-	brcmf_c_mkiovar("arpoe", (char *)&arp_enable, 4,
+	arp_enable_le = cpu_to_le32(arp_enable);
+
+	brcmf_c_mkiovar("arpoe", (char *)&arp_enable_le, 4,
 			iovbuf, sizeof(iovbuf));
 	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
@@ -802,10 +808,10 @@ int brcmf_c_preinit_dcmds(struct brcmf_p
 	char buf[128], *ptr;
 	u32 dongle_align = drvr->bus_if->align;
 	u32 glom = 0;
-	u32 roaming = 1;
-	uint bcn_timeout = 3;
-	int scan_assoc_time = 40;
-	int scan_unassoc_time = 40;
+	__le32 roaming_le = cpu_to_le32(1);
+	__le32 bcn_timeout_le = cpu_to_le32(3);
+	__le32 scan_assoc_time_le = cpu_to_le32(40);
+	__le32 scan_unassoc_time_le = cpu_to_le32(40);
 	int i;
 
 	mutex_lock(&drvr->proto_block);
@@ -840,14 +846,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_p
 
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
-	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
+	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout_le, 4, iovbuf,
 		    sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
-	brcmf_c_mkiovar("roam_off", (char *)&roaming, 4,
+	brcmf_c_mkiovar("roam_off", (char *)&roaming_le, 4,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
@@ -859,9 +865,9 @@ int brcmf_c_preinit_dcmds(struct brcmf_p
 				  sizeof(iovbuf));
 
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
-			 (char *)&scan_assoc_time, sizeof(scan_assoc_time));
+		 (char *)&scan_assoc_time_le, sizeof(scan_assoc_time_le));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
-			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
+		 (char *)&scan_unassoc_time_le, sizeof(scan_unassoc_time_le));
 
 	/* Set and enable ARP offload feature */
 	brcmf_c_arp_offload_set(drvr, BRCMF_ARPOL_MODE);


