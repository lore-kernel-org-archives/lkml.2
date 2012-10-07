Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2JGXWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:22:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38131 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700Ab2JGXVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:21:54 -0400
Message-Id: <20121007225837.075103560@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hante Meuleman <meuleman@broadcom.com>,
        Arend Van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 017/108] brcmfmac: Fix big endian host configuration data.
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hante Meuleman <meuleman@broadcom.com>

commit e020a83d0942a5aceac35986500c9834efc8707d upstream.

Fixes big endian host configuration parameters.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   26 ++++++++++++--------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -775,8 +775,11 @@ static void brcmf_c_arp_offload_set(stru
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
@@ -792,8 +795,11 @@ static void brcmf_c_arp_offload_enable(s
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
@@ -814,10 +820,10 @@ int brcmf_c_preinit_dcmds(struct brcmf_p
 	char buf[128], *ptr;
 	u32 dongle_align = BRCMF_SDALIGN;
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
 
 	brcmf_os_proto_block(drvr);
@@ -852,14 +858,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_p
 
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
@@ -874,9 +880,9 @@ int brcmf_c_preinit_dcmds(struct brcmf_p
 				  sizeof(iovbuf));
 
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
-			 (char *)&scan_assoc_time, sizeof(scan_assoc_time));
+		 (char *)&scan_assoc_time_le, sizeof(scan_assoc_time_le));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
-			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
+		 (char *)&scan_unassoc_time_le, sizeof(scan_unassoc_time_le));
 
 	/* Set and enable ARP offload feature */
 	brcmf_c_arp_offload_set(drvr, BRCMF_ARPOL_MODE);


