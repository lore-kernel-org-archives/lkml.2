Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1BJRPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:15:51 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44645 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab1BJRPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:15:48 -0500
From: Borislav Petkov <bp@amd64.org>
To: <linux-edac@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 16/30] amd64_edac: Adjust channel counting to F15h
Date: Thu, 10 Feb 2011 18:15:19 +0100
Message-Id: <1297358133-14320-17-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1297358133-14320-1-git-send-email-bp@amd64.org>
References: <1297358133-14320-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The only difference is that F10h used to sport ganged DCTs and F15h
doesn't so adjust the F10h routine and reuse it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 729d9f1..1ec0145 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1082,15 +1082,13 @@ static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, int cs_mode)
  * Pass back:
  *	contents of the DCL0_LOW register
  */
-static int f10_early_channel_count(struct amd64_pvt *pvt)
+static int f1x_early_channel_count(struct amd64_pvt *pvt)
 {
 	int i, j, channels = 0;
 
-	/* If we are in 128 bit mode, then we are using 2 channels */
-	if (pvt->dclr0 & F10_WIDTH_128) {
-		channels = 2;
-		return channels;
-	}
+	/* On F10h, if we are in 128 bit mode, then we are using 2 channels */
+	if (boot_cpu_data.x86 == 0x10 && (pvt->dclr0 & F10_WIDTH_128))
+		return 2;
 
 	/*
 	 * Need to check if in unganged mode: In such, there are 2 channels,
@@ -1540,7 +1538,7 @@ static struct amd64_family_type amd64_family_types[] = {
 		.f1_id = PCI_DEVICE_ID_AMD_10H_NB_MAP,
 		.f3_id = PCI_DEVICE_ID_AMD_10H_NB_MISC,
 		.ops = {
-			.early_channel_count	= f10_early_channel_count,
+			.early_channel_count	= f1x_early_channel_count,
 			.get_error_address	= f10_get_error_address,
 			.read_dram_ctl_register	= f10_read_dram_ctl_register,
 			.map_sysaddr_to_csrow	= f10_map_sysaddr_to_csrow,
@@ -1551,6 +1549,7 @@ static struct amd64_family_type amd64_family_types[] = {
 	[F15_CPUS] = {
 		.ctl_name = "F15h",
 		.ops = {
+			.early_channel_count	= f1x_early_channel_count,
 			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
 		}
 	},
-- 
1.7.4.rc2

