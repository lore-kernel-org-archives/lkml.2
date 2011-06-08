Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab1FHUOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:14:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60252 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1FHUOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:14:20 -0400
From: Phil Oester <kernel@linuxace.com>
To: linux-kernel@vger.kernel.org
Cc: Narendra_K@Dell.com, jordan_hargrave@Dell.com, jbarnes@virtuousgeek.org
Subject: [PATCH] Fix embedded nic order on Dell PowerEdge systems
Date: Wed,  8 Jun 2011 13:14:13 -0700
Message-Id: <1307564053-2996-1-git-send-email-kernel@linuxace.com>
X-Mailer: git-send-email 1.7.5.2
Author: Phil Oester <kernel@linuxace.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    In commit 6e8af08dfa40b747002207d3ce8e8b43a050d99f ("PCI: enable pci=bfsort
    by default on future Dell systems"), the callback added was placed at the
    top of the list, before the specific PowerEdge models.  This ends up
    breaking the more specific models listed, since the new callback handles
    all Dell systems but the older systems don't have the new 0xB1 smbios
    entry.
    
    Fix this by placing the new check _after_ the more specific PowerEdge
    sytems.
    
    Phil Oester
    
    Signed-off-by: Phil Oester <kernel@linuxace.com>

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 5fe7502..92df322 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -247,13 +247,6 @@ static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
 	},
 #endif		/* __i386__ */
 	{
-		.callback = find_sort_method,
-		.ident = "Dell System",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
-		},
-	},
-	{
 		.callback = set_bf_sort,
 		.ident = "Dell PowerEdge 1950",
 		.matches = {
@@ -294,6 +287,13 @@ static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
 		},
 	},
 	{
+		.callback = find_sort_method,
+		.ident = "Dell System",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+		},
+	},
+	{
 		.callback = set_bf_sort,
 		.ident = "HP ProLiant BL20p G3",
 		.matches = {
