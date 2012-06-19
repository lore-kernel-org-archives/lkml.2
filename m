Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2FSQDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:03:36 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42305 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab2FSQDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:03:34 -0400
From: Borislav Petkov <bp@amd64.org>
To: X86-ML <x86@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] x86, microcode: Sanitize per-cpu microcode reloading interface
Date: Tue, 19 Jun 2012 18:03:30 +0200
Message-Id: <1340121811-4477-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
In-Reply-To: <1340121811-4477-1-git-send-email-bp@amd64.org>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Microcode reloading in a per-core manner is a very bad idea for both
major x86 vendors. And the thing is, we have such interface with which
we can end up with different microcode versions applied on different
cores of an otherwise homogeneous wrt (family,model,stepping) system.

So turn off the possibility of doing that per core and allow it only
system-wide.

This is a minimal fix which we'd like to see in stable too thus the
more-or-less arbitrary decision to allow system-wide reloading only on
the BSP:

$ echo 1 > /sys/devices/system/cpu/cpu0/microcode/reload
...

and disable the interface on the other cores:

$ echo 1 > /sys/devices/system/cpu/cpu23/microcode/reload
-bash: echo: write error: Invalid argument

Also, allowing the reload only from one CPU (the BSP in
that case) doesn't allow the reload procedure to degenerate
into an O(n^2) deal when triggering reloads from all
/sys/devices/system/cpu/cpuX/microcode/reload sysfs nodes
simultaneously.

A more generic fix will follow.

Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/microcode_core.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index fbdfc6917180..24b852b61be3 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -298,19 +298,31 @@ static ssize_t reload_store(struct device *dev,
 			    const char *buf, size_t size)
 {
 	unsigned long val;
-	int cpu = dev->id;
-	ssize_t ret = 0;
+	int cpu;
+	ssize_t ret = 0, tmp_ret;
+
+	/* allow reload only from the BSP */
+	if (boot_cpu_data.cpu_index != dev->id)
+		return -EINVAL;
 
 	ret = kstrtoul(buf, 0, &val);
 	if (ret)
 		return ret;
 
-	if (val == 1) {
-		get_online_cpus();
-		if (cpu_online(cpu))
-			ret = reload_for_cpu(cpu);
-		put_online_cpus();
+	if (val != 1)
+		return size;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		tmp_ret = reload_for_cpu(cpu);
+		if (tmp_ret != 0)
+			pr_warn("Error reloading microcode on CPU %d\n", cpu);
+
+		/* save retval of the first encountered reload error */
+		if (!ret)
+			ret = tmp_ret;
 	}
+	put_online_cpus();
 
 	if (!ret)
 		ret = size;
-- 
1.7.11.rc1

