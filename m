Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab1FPPcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:32:36 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45693 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab1FPPce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:32:34 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] x86, microcode, AMD: Fix section header size check
Date: Thu, 16 Jun 2011 17:32:07 +0200
Message-Id: <1308238327-27965-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1308238327-27965-1-git-send-email-bp@amd64.org>
References: <1308238327-27965-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

The ucode size check has to take the section header size into account
too when sanity checking the section length. Shorten and clarify define
names, while at it.

Caught-by: Ben Hutchings <ben@decadent.org.uk>
Link: http://lkml.kernel.org/r/1302752223.5282.674.camel@localhost
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index d30d67c..591be0e 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -66,8 +66,8 @@ struct microcode_amd {
 	unsigned int			mpb[0];
 };
 
-#define UCODE_CONTAINER_SECTION_HDR	8
-#define UCODE_CONTAINER_HEADER_SIZE	12
+#define SECTION_HDR_SIZE	8
+#define CONTAINER_HDR_SZ	12
 
 static struct equiv_cpu_entry *equiv_cpu_table;
 
@@ -177,7 +177,7 @@ static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
 
 	actual_size = *(u32 *)(buf + 4);
 
-	if (actual_size > size || actual_size > max_size) {
+	if (actual_size + SECTION_HDR_SIZE > size || actual_size > max_size) {
 		pr_err("section size mismatch\n");
 		return 0;
 	}
@@ -204,8 +204,8 @@ get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
 	if (!mc)
 		goto out;
 
-	get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, actual_size);
-	*mc_size = actual_size + UCODE_CONTAINER_SECTION_HDR;
+	get_ucode_data(mc, buf + SECTION_HDR_SIZE, actual_size);
+	*mc_size = actual_size + SECTION_HDR_SIZE;
 
 out:
 	return mc;
@@ -229,9 +229,10 @@ static int install_equiv_cpu_table(const u8 *buf)
 		return -ENOMEM;
 	}
 
-	get_ucode_data(equiv_cpu_table, buf + UCODE_CONTAINER_HEADER_SIZE, size);
+	get_ucode_data(equiv_cpu_table, buf + CONTAINER_HDR_SZ, size);
 
-	return size + UCODE_CONTAINER_HEADER_SIZE; /* add header length */
+	/* add header length */
+	return size + CONTAINER_HDR_SZ;
 }
 
 static void free_equiv_cpu_table(void)
-- 
1.7.4.rc2

