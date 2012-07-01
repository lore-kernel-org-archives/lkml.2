Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2GATfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 15:35:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46989 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab2GATfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 15:35:50 -0400
Date: Sun, 1 Jul 2012 12:35:03 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-c9fc3f778a6a215ace14ee556067c73982b6d40f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, stable@vger.kernel.org, hmh@hmh.eng.br,
        tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: hmh@hmh.eng.br, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        stable@vger.kernel.org, borislav.petkov@amd.com
In-Reply-To: <1340280437-7718-2-git-send-email-bp@amd64.org>
References: <1340280437-7718-2-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode:
  Sanitize per-cpu microcode reloading interface
Git-Commit-ID: c9fc3f778a6a215ace14ee556067c73982b6d40f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 01 Jul 2012 12:35:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9fc3f778a6a215ace14ee556067c73982b6d40f
Gitweb:     http://git.kernel.org/tip/c9fc3f778a6a215ace14ee556067c73982b6d40f
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 21 Jun 2012 14:07:16 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 1 Jul 2012 10:24:05 -0700

x86, microcode: Sanitize per-cpu microcode reloading interface

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
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1340280437-7718-2-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/microcode_core.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index fbdfc69..24b852b 100644
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
