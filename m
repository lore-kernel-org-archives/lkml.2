Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1AJXDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:03:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43015 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1AJXDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:03:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=qOsIENCG6U1H/VO2TZTpZW8ixuZnJjcfu1ylxVgAl6sUq79zPw2LMA+2EeAztG6pG
	zmSmb//AIsRkgC/NFeimw==
From: Mike Waychison <mikew@google.com>
To: mingo@elte.hu, borislav.petkov@amd.com, rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org, mikew@google.com
Subject: [PATCH] x86: Add an option to disable decoding of MCE
Date: Mon, 10 Jan 2011 15:03:17 -0800
Message-Id: <1294700597-24239-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
References: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies to v2.6.37.

Updated with documentation of the new option.
---

On our systems, we do not want to have any "decoders" called on machine
check events.  These decoders can easily spam our logs and cause space
problems on machines that have a lot of correctable error events.  We
_do_ however want to get the messages delivered via /dev/mcelog for
userland processing.

Introduce an interface "dont_decode" that allows us to skip the
decoders.  We always call the decoders by default.

Google-Bug-Id: 3289142
Signed-off-by: Mike Waychison <mikew@google.com>
---
 Documentation/x86/x86_64/boot-options.txt |    5 +++++
 Documentation/x86/x86_64/machinecheck     |    6 ++++++
 arch/x86/kernel/cpu/mcheck/mce.c          |   24 ++++++++++++++++++------
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 7fbbaf8..dd7145a 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -22,6 +22,11 @@ Machine check
 		as corrected are silently cleared by OS.
 		This option will be useful if you have no interest in any
 		of corrected errors.
+   mce=dont_decode
+		Disable in-kernel decoding of errors.  Setting this boot
+		option will cause EDAC to be skipped (if enabled) and no
+		messages to be printed into the logs.  Events will still
+		be available via /dev/mcelog however.
    mce=ignore_ce
 		Disable features for corrected errors, e.g. polling timer
 		and CMCI.  All events reported as corrected are not cleared
diff --git a/Documentation/x86/x86_64/machinecheck b/Documentation/x86/x86_64/machinecheck
index b1fb302..7ef7003 100644
--- a/Documentation/x86/x86_64/machinecheck
+++ b/Documentation/x86/x86_64/machinecheck
@@ -65,6 +65,12 @@ tolerant
 	Note this only makes a difference if the CPU allows recovery
 	from a machine check exception. Current x86 CPUs generally do not.
 
+dont_decode
+	Disable in-kernel decoding of any errors.  Setting this boot
+	option will cause EDAC to be skipped (if enabled) and no
+	messages to be printed into the logs.  Events will still be
+	available via /dev/mcelog however.
+
 trigger
 	Program to run when a machine check event is detected.
 	This is an alternative to running mcelog regularly from cron
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7a35b72..3c30057 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -82,6 +82,7 @@ static int			mce_bootlog		__read_mostly = -1;
 static int			monarch_timeout		__read_mostly = -1;
 static int			mce_panic_timeout	__read_mostly;
 static int			mce_dont_log_ce		__read_mostly;
+static int			mce_dont_decode		__read_mostly;
 int				mce_cmci_disabled	__read_mostly;
 int				mce_ignore_ce		__read_mostly;
 int				mce_ser			__read_mostly;
@@ -209,6 +210,17 @@ void mce_log(struct mce *mce)
 	set_bit(0, &mce_need_notify);
 }
 
+static void call_decoders(struct mce *m)
+{
+	if (mce_dont_decode)
+		return;
+	/*
+	 * Print out human-readable details about the MCE error,
+	 * (if the CPU has an implementation for that)
+	 */
+	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+}
+
 static void print_mce(struct mce *m)
 {
 	pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
@@ -234,11 +246,7 @@ static void print_mce(struct mce *m)
 	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
 		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
 
-	/*
-	 * Print out human-readable details about the MCE error,
-	 * (if the CPU has an implementation for that)
-	 */
-	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
+	call_decoders(m);
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
@@ -588,7 +596,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 */
 		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
 			mce_log(&m);
-			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
+			call_decoders(&m);
 			add_taint(TAINT_MACHINE_CHECK);
 		}
 
@@ -1700,6 +1708,8 @@ static int __init mcheck_enable(char *str)
 		mce_cmci_disabled = 1;
 	else if (!strcmp(str, "dont_log_ce"))
 		mce_dont_log_ce = 1;
+	else if (!strcmp(str, "dont_decode"))
+		mce_dont_decode = 1;
 	else if (!strcmp(str, "ignore_ce"))
 		mce_ignore_ce = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
@@ -1926,6 +1936,7 @@ static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
 static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
 static SYSDEV_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
 static SYSDEV_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
+static SYSDEV_INT_ATTR(dont_decode, 0644, mce_dont_decode);
 
 static struct sysdev_ext_attribute attr_check_interval = {
 	_SYSDEV_ATTR(check_interval, 0644, sysdev_show_int,
@@ -1949,6 +1960,7 @@ static struct sysdev_attribute *mce_attrs[] = {
 	&attr_trigger,
 	&attr_monarch_timeout.attr,
 	&attr_dont_log_ce.attr,
+	&attr_dont_decode.attr,
 	&attr_ignore_ce.attr,
 	&attr_cmci_disabled.attr,
 	NULL
-- 
1.7.3.1

