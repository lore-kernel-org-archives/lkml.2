Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab0EXXHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:07:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:55334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758405Ab0EXXHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:07:44 -0400
Date: Mon, 24 May 2010 23:07:27 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, akpm@linux-foundation.org, JBeulich@novell.com,
       tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <201005241913.o4OJDH3Z010874@imap1.linux-foundation.org>
References: <201005241913.o4OJDH3Z010874@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: "nosmp" command line option should force the system into UP mode
Message-ID: <tip-5f2eb55026c91f8400ab4469aff88b2e201b5616@git.kernel.org>
Git-Commit-ID: 5f2eb55026c91f8400ab4469aff88b2e201b5616
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 24 May 2010 23:07:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f2eb55026c91f8400ab4469aff88b2e201b5616
Gitweb:     http://git.kernel.org/tip/5f2eb55026c91f8400ab4469aff88b2e201b5616
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Mon, 24 May 2010 12:13:17 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 24 May 2010 13:31:52 -0700

x86: "nosmp" command line option should force the system into UP mode

Bits set in cpu_possible_mask prior to the execution of
prefill_possible_map() (i.e.  when parsing ACPI or MPS tables) would
prevent the SMP alternatives logic from switching to UP mode, plus
unnecessary setup of per-CPU data for CPUs that can never come online.

Additionally, without CONFIG_HOTPLUG_CPU disabled CPUs can never come
online, and hence setting cpu_possible_mask bits for them is again a
simple waste of resources.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <201005241913.o4OJDH3Z010874@imap1.linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/smpboot.c |   26 +++++++++++++++++++++++---
 1 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 763d815..37462f1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1215,9 +1215,17 @@ __init void prefill_possible_map(void)
 	if (!num_processors)
 		num_processors = 1;
 
-	if (setup_possible_cpus == -1)
-		possible = num_processors + disabled_cpus;
-	else
+	i = setup_max_cpus ?: 1;
+	if (setup_possible_cpus == -1) {
+		possible = num_processors;
+#ifdef CONFIG_HOTPLUG_CPU
+		if (setup_max_cpus)
+			possible += disabled_cpus;
+#else
+		if (possible > i)
+			possible = i;
+#endif
+	} else
 		possible = setup_possible_cpus;
 
 	total_cpus = max_t(int, possible, num_processors + disabled_cpus);
@@ -1230,11 +1238,23 @@ __init void prefill_possible_map(void)
 		possible = nr_cpu_ids;
 	}
 
+#ifdef CONFIG_HOTPLUG_CPU
+	if (!setup_max_cpus)
+#endif
+	if (possible > i) {
+		printk(KERN_WARNING
+			"%d Processors exceeds max_cpus limit of %u\n",
+			possible, setup_max_cpus);
+		possible = i;
+	}
+
 	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
 		possible, max_t(int, possible - num_processors, 0));
 
 	for (i = 0; i < possible; i++)
 		set_cpu_possible(i, true);
+	for (; i < NR_CPUS; i++)
+		set_cpu_possible(i, false);
 
 	nr_cpu_ids = possible;
 }
