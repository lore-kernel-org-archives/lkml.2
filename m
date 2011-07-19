Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab1GSUjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:39:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54197 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1GSUjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:39:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ZgqYMjFoz58LfL+yoxcx55w76gLRNXocdPhiimLFpOWksklHh9RYRScJA4vQGN7DR
	mXvdK2El4i63FszuIarXQ==
Subject: [PATCH v1 2/2] run-init: Add drop_capabilities support.
To: "Andrew G. Morgan" <agm@google.com>, Maximilian Attems <max@stro.at>,
        Eric Northup <digitaleric@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>
From: Mike Waychison <mikew@google.com>
Cc: Eric Paris <eparis@parisplace.org>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Jul 2011 13:38:53 -0700
Message-ID: <20110719203853.646.50974.stgit@mike2.sea.corp.google.com>
In-Reply-To: <20110719203843.646.73383.stgit@mike2.sea.corp.google.com>
References: <20110719203843.646.73383.stgit@mike2.sea.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to run-init to allow the dropping of
POSIX capabilities.

This works by adding a "-d" flag to run-init, which takes a comma
separated list of capability names that should be dropped right before
exec'ing the real init binary.

kinit is also modified by this change, such that it understands the same
argument when prepended with "drop_capabilities=" on the kernel command
line.

When processing capabilities to drop, CAP_SETPCAP is special cased to be
dropped last, so that the order that capabilities are given does not
cause dropping of later enumerated capabilities to fail if it is listed
early on.

Dropping of capabilities happens in three parts.  We explicitly drop the
capability from init's inherited, permitted and effective masks.  We
also drop the capability from the bounding set using PR_CAPBSET_DROP.
Lastly, if available, we drop the capabilities from the bset and
inheritted masks exposed at /proc/sys/kernel/usermodehelper if available
(introduced in v3.0.0).

In all paths, we treat errors as fatal, as we do not want to continue to
boot if there was a problem dropping capabilities.   The only exception
to this rule is the handling of /proc/sys/kernel/usermodehelper, where
we print out a warning if we notice that the kernel is new enough to
support this interface, but could not find the proc file (as it may or
may not be available after the pivot, depending on early portions of the
boot strap process).

Signed-off-by: Mike Waychison <mikew@google.com>
---
 usr/kinit/kinit.c                 |    4 -
 usr/kinit/run-init/Kbuild         |    2 
 usr/kinit/run-init/capabilities.c |  278 +++++++++++++++++++++++++++++++++++++
 usr/kinit/run-init/capabilities.h |    6 +
 usr/kinit/run-init/run-init.c     |   11 +
 usr/kinit/run-init/run-init.h     |    3 
 usr/kinit/run-init/runinitlib.c   |   11 +
 7 files changed, 307 insertions(+), 8 deletions(-)
 create mode 100644 usr/kinit/run-init/capabilities.c
 create mode 100644 usr/kinit/run-init/capabilities.h

diff --git a/usr/kinit/kinit.c b/usr/kinit/kinit.c
index 4a1f40b..ae50ed6 100644
--- a/usr/kinit/kinit.c
+++ b/usr/kinit/kinit.c
@@ -307,7 +307,9 @@ int main(int argc, char *argv[])
 
 	init_argv[0] = strrchr(init_path, '/') + 1;
 
-	errmsg = run_init("/root", "/dev/console", init_path, init_argv);
+	errmsg = run_init("/root", "/dev/console",
+			  get_arg(cmdc, cmdv, "drop_capabilities="),
+			  init_path, init_argv);
 
 	/* If run_init returned, something went bad */
 	fprintf(stderr, "%s: %s: %s\n", progname, errmsg, strerror(errno));
diff --git a/usr/kinit/run-init/Kbuild b/usr/kinit/run-init/Kbuild
index bf6e140..6451dd4 100644
--- a/usr/kinit/run-init/Kbuild
+++ b/usr/kinit/run-init/Kbuild
@@ -6,7 +6,7 @@ static-y := static/run-init
 shared-y := shared/run-init
 
 # common .o files
-objs := run-init.o runinitlib.o
+objs := run-init.o runinitlib.o capabilities.o
 
 # TODO - do we want a stripped version
 # TODO - do we want the static.g + shared.g directories?
diff --git a/usr/kinit/run-init/capabilities.c b/usr/kinit/run-init/capabilities.c
new file mode 100644
index 0000000..d262c01
--- /dev/null
+++ b/usr/kinit/run-init/capabilities.c
@@ -0,0 +1,278 @@
+/*
+ * Copyright 2011 Google Inc. All Rights Reserved
+ * Author: mikew@google.com (Mike Waychison)
+ */
+
+/*
+ * We have to include the klibc types.h here to keep the kernel's
+ * types.h from being used.
+ */
+#include <sys/types.h>
+
+#include <linux/version.h>
+#include <sys/capability.h>
+#include <sys/prctl.h>
+#include <sys/utsname.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "capabilities.h"
+
+#define ARRAY_SIZE(x)  (sizeof(x) / sizeof(x[0]))
+
+#define MAKE_CAP(cap) [cap] = { .cap_name = #cap }
+
+struct capability {
+	const char *cap_name;
+} capabilities[] = {
+	MAKE_CAP(CAP_CHOWN),
+	MAKE_CAP(CAP_DAC_OVERRIDE),
+	MAKE_CAP(CAP_DAC_READ_SEARCH),
+	MAKE_CAP(CAP_FOWNER),
+	MAKE_CAP(CAP_FSETID),
+	MAKE_CAP(CAP_KILL),
+	MAKE_CAP(CAP_SETGID),
+	MAKE_CAP(CAP_SETUID),
+	MAKE_CAP(CAP_SETPCAP),
+	MAKE_CAP(CAP_LINUX_IMMUTABLE),
+	MAKE_CAP(CAP_NET_BIND_SERVICE),
+	MAKE_CAP(CAP_NET_BROADCAST),
+	MAKE_CAP(CAP_NET_ADMIN),
+	MAKE_CAP(CAP_NET_RAW),
+	MAKE_CAP(CAP_IPC_LOCK),
+	MAKE_CAP(CAP_IPC_OWNER),
+	MAKE_CAP(CAP_SYS_MODULE),
+	MAKE_CAP(CAP_SYS_RAWIO),
+	MAKE_CAP(CAP_SYS_CHROOT),
+	MAKE_CAP(CAP_SYS_PTRACE),
+	MAKE_CAP(CAP_SYS_PACCT),
+	MAKE_CAP(CAP_SYS_ADMIN),
+	MAKE_CAP(CAP_SYS_BOOT),
+	MAKE_CAP(CAP_SYS_NICE),
+	MAKE_CAP(CAP_SYS_RESOURCE),
+	MAKE_CAP(CAP_SYS_TIME),
+	MAKE_CAP(CAP_SYS_TTY_CONFIG),
+	MAKE_CAP(CAP_MKNOD),
+	MAKE_CAP(CAP_LEASE),
+	MAKE_CAP(CAP_AUDIT_WRITE),
+	MAKE_CAP(CAP_AUDIT_CONTROL),
+	MAKE_CAP(CAP_SETFCAP),
+	MAKE_CAP(CAP_MAC_OVERRIDE),
+	MAKE_CAP(CAP_MAC_ADMIN),
+	MAKE_CAP(CAP_SYSLOG),
+};
+
+static void fail(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vfprintf(stderr, fmt, args);
+	va_end(args);
+	exit(1);
+}
+
+/*
+ * Returns the currently running kernel version X.Y.Z in a format
+ * compatible with the KERNEL_VERSION macro.
+ */
+static unsigned kernel_version(void)
+{
+	struct utsname utsname;
+	int ret;
+	unsigned char version, patchlevel, sublevel;
+
+	ret = uname(&utsname);
+	if (ret != 0)
+		fail("uname returned %d\n", ret);
+
+	ret = sscanf(utsname.release, "%hhu.%hhu.%hhu",
+		     &version, &patchlevel, &sublevel);
+	if (ret != 3) {
+		/* Try two level name? */
+		sublevel = 0;
+		ret = sscanf(utsname.release, "%hhu.%hhu",
+			     &version, &patchlevel);
+		if (ret != 2)
+			fail("Couldn't parse kernel version \"%s\"\n",
+			     utsname.release);
+	}
+
+	return KERNEL_VERSION(version, patchlevel, sublevel);
+}
+
+/*
+ * Find the capability ordinal by name, and return its ordinal.
+ * Returns -1 on failure.
+ */
+static int find_capability(const char *s)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(capabilities); i++) {
+		if (capabilities[i].cap_name
+		 && strcasecmp(s, capabilities[i].cap_name) == 0) {
+			return i;
+		}
+	}
+	return -1;
+}
+
+static void do_capset(int cap_ordinal)
+{
+	struct __user_cap_header_struct hdr;
+	struct __user_cap_data_struct caps[2];
+
+	/* Get the current capability mask */
+	hdr.version = _LINUX_CAPABILITY_VERSION_3;
+	hdr.pid = getpid();
+	if (capget(&hdr, caps)) {
+		perror("capget()");
+		exit(1);
+	}
+
+	/* Drop the bits */
+	if (cap_ordinal < 32) {
+		caps[0].effective   &= ~(1U << cap_ordinal);
+		caps[0].permitted   &= ~(1U << cap_ordinal);
+		caps[0].inheritable &= ~(1U << cap_ordinal);
+	} else {
+		caps[1].effective   &= ~(1U << (cap_ordinal - 32));
+		caps[1].permitted   &= ~(1U << (cap_ordinal - 32));
+		caps[1].inheritable &= ~(1U << (cap_ordinal - 32));
+	}
+
+	/* And drop the capability. */
+	hdr.version = _LINUX_CAPABILITY_VERSION_3;
+	hdr.pid = getpid();
+	if (capset(&hdr, caps))
+		fail("Couldn't drop the capability \"%s\"\n",
+		     capabilities[cap_ordinal].cap_name);
+}
+
+static void do_bset(int cap_ordinal)
+{
+	int ret;
+
+	ret = prctl(PR_CAPBSET_READ, cap_ordinal);
+	if (ret == 1) {
+		ret = prctl(PR_CAPBSET_DROP, cap_ordinal);
+		if (ret != 0)
+			fail("Error dropping capability %s from bset\n",
+			     capabilities[cap_ordinal].cap_name);
+	} else if (ret < 0)
+		fail("Kernel doesn't recognize capability %d\n", cap_ordinal);
+}
+
+static void do_usermodehelper_file(const char *filename, int cap_ordinal)
+{
+	uint32_t lo32, hi32;
+	FILE *file;
+	static const size_t buf_size = 80;
+	char buf[buf_size];
+	char tail;
+	size_t bytes_read;
+	int ret;
+
+	/* Try and open the file */
+	file = fopen(filename, "r+");
+	if (!file && errno == ENOENT) {
+		/* Check if this kernel even supports this interface. */
+		if (kernel_version() >= KERNEL_VERSION(3, 0, 0)) {
+			static int printed_once;
+			if (!printed_once++)
+				fprintf(stderr, "WARNING: Could not disable "
+					"capabilities for usermode helpers!\n");
+		}
+		return;
+	}
+	if (!file)
+		fail("Failed to access file %s errno %d\n", filename, errno);
+
+	/* Read and process the current bits */
+	bytes_read = fread(buf, 1, buf_size - 1, file);
+	if (bytes_read == 0)
+		fail("Trouble reading %s\n", filename);
+	buf[bytes_read] = '\0';
+	ret = sscanf(buf, "%u %u%c", &lo32, &hi32, &tail);
+	if (ret != 2)
+		fail("Failed to understand %s\n", filename);
+
+	/* Clear the bits in the local copy */
+	if (cap_ordinal < 32)
+		lo32 &= ~(1 << cap_ordinal);
+	else
+		hi32 &= ~(1 << (cap_ordinal - 32));
+
+	/* Commit the new bit masks to the kernel */
+	sprintf(buf, "%u %u", lo32, hi32);
+	ret = fwrite(buf, 1, strlen(buf) + 1, file);
+	if (ret != strlen(buf) + 1)
+		fail("Failed to commit usermode helper bitmasks: %d\n", ret);
+
+	/* Cleanup */
+	fclose(file);
+}
+
+static void do_usermodehelper(int cap_ordinal)
+{
+	static const char * const files[] = {
+		"/proc/sys/kernel/bset",
+		"/proc/sys/kernel/inheritable",
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(files); i++)
+		do_usermodehelper_file(files[i], cap_ordinal);
+}
+
+static void drop_capability(int cap_ordinal)
+{
+	do_usermodehelper(cap_ordinal);
+	do_bset(cap_ordinal);
+	do_capset(cap_ordinal);
+
+	printf("Dropped capability: %s\n", capabilities[cap_ordinal].cap_name);
+}
+
+int do_capabilities(const char *drop_capabilities)
+{
+	char *s, *saveptr = NULL;
+	char *token;
+	int drop_setpcap = 0;
+
+	if (!drop_capabilities)
+		return 0;
+
+	/* Create a duplicate string that can be modified. */
+	s = strdup(drop_capabilities);
+	if (!s)
+		fail("Failed to drop caps as requested.  Exiting\n");
+
+	token = strtok_r(s, ",", &saveptr);
+	while (token) {
+		int cap_ordinal = find_capability(token);
+
+		if (cap_ordinal < 0)
+			fail("Could not understand capability name \"%s\" "
+			     "on command line, failing init\n", token);
+
+		/* We handle CAP_SETPCAP last because it is needed to
+		 * drop all other caps. */
+		if (cap_ordinal == CAP_SETPCAP)
+			drop_setpcap = 1;
+		else
+			drop_capability(cap_ordinal);
+
+		token = strtok_r(NULL, ",", &saveptr);
+	}
+
+	if (drop_setpcap)
+		drop_capability(CAP_SETPCAP);
+
+	free(s);
+	return 0;
+}
diff --git a/usr/kinit/run-init/capabilities.h b/usr/kinit/run-init/capabilities.h
new file mode 100644
index 0000000..bf51eec
--- /dev/null
+++ b/usr/kinit/run-init/capabilities.h
@@ -0,0 +1,6 @@
+#ifndef CAPABILITIES_H
+#define CAPABILITIES_H
+
+int do_capabilities(const char *drop_capabilities);
+
+#endif				/* CAPABILITIES_H */
diff --git a/usr/kinit/run-init/run-init.c b/usr/kinit/run-init/run-init.c
index 0f150dd..cc602ef 100644
--- a/usr/kinit/run-init/run-init.c
+++ b/usr/kinit/run-init/run-init.c
@@ -35,6 +35,7 @@
  * - Remounts /real-root onto the root filesystem;
  * - Chroots;
  * - Opens /dev/console;
+ * - Drops capabilities
  * - Spawns the specified init program (with arguments.)
  */
 
@@ -50,7 +51,8 @@ static const char *program;
 static void __attribute__ ((noreturn)) usage(void)
 {
 	fprintf(stderr,
-		"Usage: exec %s [-c consoledev] /real-root /sbin/init [args]\n",
+		"Usage: exec %s [-c consoledev] [-d <CAP_NAME,...>] "
+		"/real-root /sbin/init [args]\n",
 		program);
 	exit(1);
 }
@@ -62,6 +64,7 @@ int main(int argc, char *argv[])
 	const char *realroot;
 	const char *init;
 	const char *error;
+	const char *drop_capabilities = NULL;
 	char **initargs;
 
 	/* Variables... */
@@ -70,9 +73,11 @@ int main(int argc, char *argv[])
 	/* Parse the command line */
 	program = argv[0];
 
-	while ((o = getopt(argc, argv, "c:")) != -1) {
+	while ((o = getopt(argc, argv, "c:d:")) != -1) {
 		if (o == 'c') {
 			console = optarg;
+		} else if (o == 'd') {
+			drop_capabilities = optarg;
 		} else {
 			usage();
 		}
@@ -85,7 +90,7 @@ int main(int argc, char *argv[])
 	init = argv[optind + 1];
 	initargs = argv + optind + 1;
 
-	error = run_init(realroot, console, init, initargs);
+	error = run_init(realroot, console, drop_capabilities, init, initargs);
 
 	/* If run_init returns, something went wrong */
 	fprintf(stderr, "%s: %s: %s\n", program, error, strerror(errno));
diff --git a/usr/kinit/run-init/run-init.h b/usr/kinit/run-init/run-init.h
index a95328e..30f78bf 100644
--- a/usr/kinit/run-init/run-init.h
+++ b/usr/kinit/run-init/run-init.h
@@ -29,6 +29,7 @@
 #define RUN_INIT_H
 
 const char *run_init(const char *realroot, const char *console,
-		     const char *init, char **initargs);
+		     const char *drop_capabilities, const char *init,
+		     char **initargs);
 
 #endif
diff --git a/usr/kinit/run-init/runinitlib.c b/usr/kinit/run-init/runinitlib.c
index 8f1562f..a5cb10c 100644
--- a/usr/kinit/run-init/runinitlib.c
+++ b/usr/kinit/run-init/runinitlib.c
@@ -26,7 +26,7 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * run_init(consoledev, realroot, init, initargs)
+ * run_init(consoledev, realroot, drop_capabilities, init, initargs)
  *
  * This function should be called as the last thing in kinit,
  * from initramfs, it does the following:
@@ -35,6 +35,7 @@
  * - Remounts /real-root onto the root filesystem;
  * - Chroots;
  * - Opens /dev/console;
+ * - Drops capabilities if needed;
  * - Spawns the specified init program (with arguments.)
  *
  * On failure, returns a human-readable error message.
@@ -52,7 +53,9 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/vfs.h>
+
 #include "run-init.h"
+#include "capabilities.h"
 
 /* Make it possible to compile on glibc by including constants that the
    always-behind shipped glibc headers may not include.  Classic example
@@ -154,7 +157,8 @@ static int nuke(const char *what)
 }
 
 const char *run_init(const char *realroot, const char *console,
-		     const char *init, char **initargs)
+		     const char *drop_capabilities, const char *init,
+		     char **initargs)
 {
 	struct stat rst, cst;
 	struct statfs sfs;
@@ -203,6 +207,9 @@ const char *run_init(const char *realroot, const char *console,
 	dup2(confd, 2);
 	close(confd);
 
+	/* Drop capabilities */
+	do_capabilities(drop_capabilities);
+
 	/* Spawn init */
 	execv(init, initargs);
 	return init;		/* Failed to spawn init */

