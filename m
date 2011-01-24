Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1AXP0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:26:54 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44593 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1AXP0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:26:24 -0500
From: Borislav Petkov <bp@amd64.org>
To: <x86@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/7] x86, microcode, AMD: Simplify install_equiv_cpu_table
Date: Mon, 24 Jan 2011 16:29:00 +0100
Message-Id: <1295882943-11184-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295882943-11184-1-git-send-email-bp@amd64.org>
References: <1295882943-11184-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

There's no need to memcpy the ucode header in order to look at it only
in this function - use the original buffer instead. Also, fix return
type semantics by returning a negative value on error and a positive
otherwise.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Andreas Herrmann <Andreas.Herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index ef91df0..9a451d7 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -188,27 +188,22 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 
 static int install_equiv_cpu_table(const u8 *buf)
 {
-	u8 *container_hdr[UCODE_CONTAINER_HEADER_SIZE];
-	unsigned int *buf_pos = (unsigned int *)container_hdr;
-	unsigned long size;
+	unsigned int *ibuf = (unsigned int *)buf;
+	unsigned int type = ibuf[1];
+	unsigned int size = ibuf[2];
 
-	get_ucode_data(&container_hdr, buf, UCODE_CONTAINER_HEADER_SIZE);
-
-	size = buf_pos[2];
-
-	if (buf_pos[1] != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
+	if (type != UCODE_EQUIV_CPU_TABLE_TYPE || !size) {
 		pr_err("error: invalid type field in container file section header\n");
-		return 0;
+		return -EINVAL;
 	}
 
 	equiv_cpu_table = vmalloc(size);
 	if (!equiv_cpu_table) {
 		pr_err("failed to allocate equivalent CPU table\n");
-		return 0;
+		return -ENOMEM;
 	}
 
-	buf += UCODE_CONTAINER_HEADER_SIZE;
-	get_ucode_data(equiv_cpu_table, buf, size);
+	get_ucode_data(equiv_cpu_table, buf + UCODE_CONTAINER_HEADER_SIZE, size);
 
 	return size + UCODE_CONTAINER_HEADER_SIZE; /* add header length */
 }
@@ -232,7 +227,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 	enum ucode_state state = UCODE_OK;
 
 	offset = install_equiv_cpu_table(ucode_ptr);
-	if (!offset) {
+	if (offset < 0) {
 		pr_err("failed to create equivalent cpu table\n");
 		return UCODE_ERROR;
 	}
-- 
1.7.4.rc2

