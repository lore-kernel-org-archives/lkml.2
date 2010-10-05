Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab0JEKwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 06:52:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37978 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab0JEKwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 06:52:47 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 7/8] EDAC, MCE: Fix FR MCEs decoding
Date: Tue,  5 Oct 2010 12:54:07 +0200
Message-Id: <1286276048-20556-8-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286276048-20556-1-git-send-email-bp@amd64.org>
References: <1286276048-20556-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Those are N/A on K8, so don't decode them there.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index cf6d44a..82dc0de 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -491,11 +491,17 @@ EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
 
 static void amd_decode_fr_mce(struct mce *m)
 {
+	if (boot_cpu_data.x86 == 0xf)
+		goto wrong_fr_mce;
+
 	/* we have only one error signature so match all fields at once. */
-	if ((m->status & 0xffff) == 0x0f0f)
-		pr_emerg(HW_ERR " FR Error: CPU Watchdog timer expire.\n");
-	else
-		pr_emerg(HW_ERR "Corrupted FR MCE info?\n");
+	if ((m->status & 0xffff) == 0x0f0f) {
+		pr_emerg(HW_ERR "FR Error: CPU Watchdog timer expire.\n");
+		return;
+	}
+
+wrong_fr_mce:
+	pr_emerg(HW_ERR "Corrupted FR MCE info?\n");
 }
 
 static inline void amd_decode_err_code(u16 ec)
-- 
1.7.3.1.50.g1e633

