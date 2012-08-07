Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab2HGXl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:41:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2HGW1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:27:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>, Sathya Perla <sperla@emulex.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 008/122] be2net: Missing byteswap in be_get_fw_log_level causes oops on PowerPC
Date: Tue,  7 Aug 2012 15:24:56 -0700
Message-Id: <20120807221948.988666294@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit ac46a4623815113a0305b2a491c125f473a88c53 upstream.

We are seeing an oops in be_get_fw_log_level on ppc64 where we walk
off the end of memory.

commit 941a77d582c8 (be2net: Fix to allow get/set of debug levels in
the firmware.) requires byteswapping of num_modes and num_modules.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Sathya Perla <sperla@emulex.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/emulex/benet/be_ethtool.c |    5 +++--
 drivers/net/ethernet/emulex/benet/be_main.c    |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -910,8 +910,9 @@ static void be_set_fw_log_level(struct b
 	if (!status) {
 		cfgs = (struct be_fat_conf_params *)(extfat_cmd.va +
 					sizeof(struct be_cmd_resp_hdr));
-		for (i = 0; i < cfgs->num_modules; i++) {
-			for (j = 0; j < cfgs->module[i].num_modes; j++) {
+		for (i = 0; i < le32_to_cpu(cfgs->num_modules); i++) {
+			u32 num_modes = le32_to_cpu(cfgs->module[i].num_modes);
+			for (j = 0; j < num_modes; j++) {
 				if (cfgs->module[i].trace_lvl[j].mode ==
 								MODE_UART)
 					cfgs->module[i].trace_lvl[j].dbg_lvl =
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -3479,7 +3479,7 @@ u32 be_get_fw_log_level(struct be_adapte
 	if (!status) {
 		cfgs = (struct be_fat_conf_params *)(extfat_cmd.va +
 						sizeof(struct be_cmd_resp_hdr));
-		for (j = 0; j < cfgs->module[0].num_modes; j++) {
+		for (j = 0; j < le32_to_cpu(cfgs->module[0].num_modes); j++) {
 			if (cfgs->module[0].trace_lvl[j].mode == MODE_UART)
 				level = cfgs->module[0].trace_lvl[j].dbg_lvl;
 		}


