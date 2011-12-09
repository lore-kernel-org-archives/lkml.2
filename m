Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1LISJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:09:21 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36261 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab1LISJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:09:08 -0500
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/5] x86, microcode, AMD: Add a reusable buffer
Date: Fri,  9 Dec 2011 19:08:52 +0100
Message-Id: <1323454135-16777-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1323454135-16777-1-git-send-email-bp@amd64.org>
References: <1323454135-16777-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a simple 4K page which gets allocated on driver init and freed on
driver exit instead of vmalloc'ing small buffers for each ucode patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index e8a68c2..9129c69 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -71,6 +71,9 @@ struct microcode_amd {
 
 static struct equiv_cpu_entry *equiv_cpu_table;
 
+/* page-sized ucode patch buffer */
+void *patch;
+
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
@@ -351,9 +354,14 @@ static struct microcode_ops microcode_amd_ops = {
 
 struct microcode_ops * __init init_amd_microcode(void)
 {
+	patch = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!patch)
+		return NULL;
+
 	return &microcode_amd_ops;
 }
 
 void __exit exit_amd_microcode(void)
 {
+	free_page((unsigned long)patch);
 }
-- 
1.7.8.rc0

