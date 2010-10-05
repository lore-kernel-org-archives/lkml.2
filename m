Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab0JEKww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:52:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37972 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945Ab0JEKwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:52:46 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/8] EDAC, MCE: Warn about LS MCEs on F14h
Date: Tue,  5 Oct 2010 12:54:05 +0200
Message-Id: <1286276048-20556-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286276048-20556-1-git-send-email-bp@amd64.org>
References: <1286276048-20556-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

F14h CPUs do not generate LS MCEs so exit early and warn the user in
case this path is ever hit that something else might be going haywire.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 6e49f1e..adb5d25 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -343,19 +343,27 @@ wrong_bu_mce:
 
 static void amd_decode_ls_mce(struct mce *m)
 {
-	u32 ec  = m->status & 0xffff;
-	u32 xec = (m->status >> 16) & 0xf;
+	u16 ec = m->status & 0xffff;
+	u8 xec = (m->status >> 16) & 0xf;
+
+	if (boot_cpu_data.x86 == 0x14) {
+		pr_emerg("You shouldn't be seeing an LS MCE on this cpu family,"
+			 " please report on LKML.\n");
+		return;
+	}
 
 	pr_emerg(HW_ERR "Load Store Error");
 
 	if (xec == 0x0) {
-		u8 rrrr = (ec >> 4) & 0xf;
+		u8 r4 = (ec >> 4) & 0xf;
 
-		if (!BUS_ERROR(ec) || (rrrr != 0x3 && rrrr != 0x4))
+		if (!BUS_ERROR(ec) || (r4 != R4_DRD && r4 != R4_DWR))
 			goto wrong_ls_mce;
 
 		pr_cont(" during %s.\n", RRRR_MSG(ec));
-	}
+	} else
+		goto wrong_ls_mce;
+
 	return;
 
 wrong_ls_mce:
-- 
1.7.3.1.50.g1e633

