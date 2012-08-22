Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab2HVXi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:38:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab2HVXiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:38:50 -0400
Date: Wed, 22 Aug 2012 16:38:36 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-bb9d3e473d5b324907e15dff4e54410b28ea50e2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <1344361461-10076-4-git-send-email-bp@amd64.org>
References: <1344361461-10076-4-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode: Drop uci->
 mc check on resume path
Git-Commit-ID: bb9d3e473d5b324907e15dff4e54410b28ea50e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Aug 2012 16:38:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bb9d3e473d5b324907e15dff4e54410b28ea50e2
Gitweb:     http://git.kernel.org/tip/bb9d3e473d5b324907e15dff4e54410b28ea50e2
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 3 Aug 2012 15:26:50 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 22 Aug 2012 16:14:44 -0700

x86, microcode: Drop uci->mc check on resume path

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
Link: http://lkml.kernel.org/r/1344361461-10076-4-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_core.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 63a9568..706a5c9 100644
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
