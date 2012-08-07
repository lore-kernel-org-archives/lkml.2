Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2HGRs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:48:56 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35563 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab2HGRo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:44:26 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH v0 03/12] x86, microcode: Drop uci->mc check on resume path
Date: Tue,  7 Aug 2012 19:44:12 +0200
Message-Id: <1344361461-10076-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1344361461-10076-1-git-send-email-bp@amd64.org>
References: <1344361461-10076-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Remove the uci->mc check on the cpu resume path because the low-level
drivers do that anyway.

More importantly, though, this fixes a contrived and obscure but still
important case. Imagine the following:

* boot machine, no new microcode in /lib/firmware

* a subset of the CPUs is offlined

* in the meantime, user puts new fresh microcode container into
/lib/firmware and reloads it by doing
$ echo 1 > /sys/devices/system/cpu/microcode/reload

* offlined cores come back online and they don't get the newer microcode
applied due to this check.

Later patches take care of the issue on AMD.

While at it, cleanup code around it.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_core.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 63a956865022..706a5c9b8eb2 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -369,13 +369,10 @@ static void microcode_fini_cpu(int cpu)
 
 static enum ucode_state microcode_resume_cpu(int cpu)
 {
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-	if (!uci->mc)
-		return UCODE_NFOUND;
-
 	pr_debug("CPU%d updated upon resume\n", cpu);
-	apply_microcode_on_target(cpu);
+
+	if (apply_microcode_on_target(cpu))
+		return UCODE_ERROR;
 
 	return UCODE_OK;
 }
@@ -404,14 +401,11 @@ static enum ucode_state microcode_init_cpu(int cpu)
 static enum ucode_state microcode_update_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	enum ucode_state ustate;
 
 	if (uci->valid)
-		ustate = microcode_resume_cpu(cpu);
-	else
-		ustate = microcode_init_cpu(cpu);
+		return microcode_resume_cpu(cpu);
 
-	return ustate;
+	return microcode_init_cpu(cpu);
 }
 
 static int mc_device_add(struct device *dev, struct subsys_interface *sif)
-- 
1.7.11.rc1

