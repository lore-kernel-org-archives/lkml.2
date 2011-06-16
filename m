Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab1FPPcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:32:50 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45689 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab1FPPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:32:29 -0400
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] x86, microcode, AMD: Correct buf references
Date: Thu, 16 Jun 2011 17:32:06 +0200
Message-Id: <1308238327-27965-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1308238327-27965-1-git-send-email-bp@amd64.org>
References: <1308238327-27965-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Both the equivalence table and the microcode patch types are u32. Access
them properly through the buf-ptr.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index c561038..d30d67c 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -157,7 +157,7 @@ static int apply_microcode_amd(int cpu)
 static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	unsigned int max_size, actual_size;
+	u32 max_size, actual_size;
 
 #define F1XH_MPB_MAX_SIZE 2048
 #define F14H_MPB_MAX_SIZE 1824
@@ -175,7 +175,7 @@ static unsigned int verify_ucode_size(int cpu, const u8 *buf, unsigned int size)
 		break;
 	}
 
-	actual_size = buf[4] + (buf[5] << 8);
+	actual_size = *(u32 *)(buf + 4);
 
 	if (actual_size > size || actual_size > max_size) {
 		pr_err("section size mismatch\n");
@@ -191,7 +191,7 @@ get_next_ucode(int cpu, const u8 *buf, unsigned int size, unsigned int *mc_size)
 	struct microcode_header_amd *mc = NULL;
 	unsigned int actual_size = 0;
 
-	if (buf[0] != UCODE_UCODE_TYPE) {
+	if (*(u32 *)buf != UCODE_UCODE_TYPE) {
 		pr_err("invalid type field in container file section header\n");
 		goto out;
 	}
-- 
1.7.4.rc2

