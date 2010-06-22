Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0FVPfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:35:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab0FVPfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:35:14 -0400
Date: Tue, 22 Jun 2010 11:34:57 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH v3] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100622153457.GA5381@redhat.com>
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
 <20100617091322.b7d21473.randy.dunlap@oracle.com>
 <4C1A7D61.8010900@redhat.com>
 <20100621122145.76ebd7ac.akpm@linux-foundation.org>
 <20100621194559.GI3217@redhat.com>
 <20100621130008.d3dc01a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621130008.d3dc01a8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is similar to Theordore Ts'o's TAINT_USER patch,
linux-2.6 commit 34f5a39899f3f3e815da64f48ddb72942d86c366.

Individual distributions may enable "generic" features such as X86 support,
PPC support, and driver support.

Some of the features that are enabled by these "generic" feature flags may
not be considered supported by the individual distribution.

For example, a distribution may want to support PPC but not the Power5
chipset, or the e1000e driver but not a card with a specific DeviceID because
of known firmware issues.

Typically, one would push a config patch to enable and disable the feature and
patch the distribution.  However, in some cases this is not feasible in order
to preserve kabi and at the same time maintain parity with the upstream kernel.
In some cases the distribution may want to allow booting of these features but
explicitly notify a user that they are not "officially" supported.  It is also
possible that the hardware is fixed via a firmware update at a later date,
making it supported again.

It would be useful for a distribution to notify the installer and
bug reporting applications, and notify users that the hardware they are using
is unsupported during panic, oops, BUG(), and WARN().

This patch introduces the TAINT_HARDWARE_UNSUPPORTED flag for distributions
to use.

V2:  clean up documentation
V3:  add wrapper function around tainting unsupported function

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>

---

This includes a wrapper function we were preparing to use internally.  We
weren't sure if people would frown upon adding a function with no callers
upstream, so we initially held off on it and just submitted the flag.

Another alternative is I can just submit a patch that just reserves
bits for vendor specific uses, if that is more favorable.

Cheers,
Don

diff --git a/Documentation/oops-tracing.txt b/Documentation/oops-tracing.txt
index 6fe9001..e337b0a 100644
--- a/Documentation/oops-tracing.txt
+++ b/Documentation/oops-tracing.txt
@@ -263,6 +263,8 @@ characters, each representing a particular tainted value.
  12: 'I' if the kernel is working around a severe bug in the platform
      firmware (BIOS or similar).
 
+ 13: 'H' if the hardware is unsupported by the distribution
+
 The primary reason for the 'Tainted: ' string is to tell kernel
 debuggers if this is a clean kernel or if anything unusual has
 occurred.  Tainting is permanent: even if an offending module is
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index cc5e3ff..422b3f4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -347,6 +347,11 @@ extern enum system_states {
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
 #define TAINT_FIRMWARE_WORKAROUND	11
+/*
+ *  Don't call add_taint(TAINT_HARDWARE_UNSUPPORTED) directly - use
+ *  mark_hardware_unsupported()
+ */ 
+#define TAINT_HARDWARE_UNSUPPORTED	12
 
 extern void dump_stack(void) __cold;
 
@@ -781,4 +786,5 @@ struct sysinfo {
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
 
+extern void mark_hardware_unsupported(char *msg);
 #endif
diff --git a/kernel/panic.c b/kernel/panic.c
index dbe13db..90f87c7 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -179,6 +179,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_WARN,			'W', ' ' },
 	{ TAINT_CRAP,			'C', ' ' },
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
+	{ TAINT_HARDWARE_UNSUPPORTED,	'H', ' ' },
 };
 
 /**
@@ -196,6 +197,7 @@ static const struct tnt tnts[] = {
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
  *  'I' - Working around severe firmware bug.
+ *  'H' - Hardware is unsupported.
  *
  *	The string is overwritten by the next call to print_tainted().
  */
@@ -247,6 +249,15 @@ void add_taint(unsigned flag)
 }
 EXPORT_SYMBOL(add_taint);
 
+void mark_hardware_unsupported(char *msg)
+{
+	printk(KERN_CRIT "UNSUPPORTED HARDWARE DEVICE: %s\n", msg);
+	WARN_TAINT(1, TAINT_HARDWARE_UNSUPPORTED,
+		   "Your hardware is unsupported.  Please do not report "
+		   "bugs, panics, oopses, etc., on this hardware.\n");
+}
+EXPORT_SYMBOL(mark_hardware_unsupported);
+
 static void spin_msec(int msecs)
 {
 	int i;
