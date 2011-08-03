Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1HCBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 21:16:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26949 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab1HCBQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 21:16:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=k7C+6FDUvISE9tg4EKSiIunARc8vGv+0e1ppzbgAGK01vSaoz8MdOg36Rh6m3mmmp
	j2dp5J3VoDzcICu/nASvQ==
Subject: [PATCH v2] kinit: Add drop_capabilities support.
To: "H. Peter Anvin" <hpa@zytor.com>, Maximilian Attems <max@stro.at>,
        "Andrew G. Morgan" <agm@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Eric Northup <digitaleric@google.com>
From: Mike Waychison <mikew@google.com>
Cc: Eric Paris <eparis@parisplace.org>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Date: Tue, 02 Aug 2011 18:16:40 -0700
Message-ID: <20110803011640.15597.16377.stgit@mike2.sea.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to kinit to allow the dropping of POSIX
capabilities.

kinit is modified by this change, such that it understands the new
kernel command line "drop_capabilities=" that specifies a comma
separated list of capability names that should be dropped before
switching over to the next init in the boot strap (typically on the root
disk).

When processing capabilities to drop, CAP_SETPCAP is special cased to be
dropped last, so that the order that capabilities are given does not
cause dropping of later enumerated capabilities to fail if it is listed
early on.

Dropping of capabilities happens in three parts.  We explicitly drop the
capability from init's inherited masks.  We also drop the capability
from the bounding set using PR_CAPBSET_DROP so that later setuid execs
are bounded.  Lastly, we drop the capabilities from the bset and
inheritted masks exposed at /proc/sys/kernel/usermodehelper if available
(introduced in Linux v3.0.0).

In all paths, we treat errors as fatal, as we do not want to continue to
boot if there was a problem dropping capabilities.  We fail because the
new drop_capabilities= option on the command line mandates enforcement
of a security policy, and we should err on the side of caution if we
ever fail to satisfy the administrator's intention.

Signed-off-by: Mike Waychison <mikew@google.com>
---
v2
    - Only drop from the inherited capabilities mask.  Only this mask
      was required as per Andrew Morgan.  This also allows us to
      continue having capabilities to call run-init later on, allowing
      the following:
    - Moved dropping of capabilities out of run-init and into kinit.
      This was required to ensure access to the proc filesystem, which
      is required for manipulating the masks the kernel uses when
      spawning new tasks on the kernel's behalf via the
      call_usermodehelper() routine.
    - Fixed paths to the usermodehelper settings files.
    - Fixed sscanf to allow for a newline character when reading the
      usermodehelper capability mask settings.
    - Fixed the return check of the write to the usermodehelper files.
      These proc files return 0 on successful write(2).
    - Added a format atttribute to the fail() wrapper for better
      compiler warnings.
    - Removed kernel version check.  The boot will now always fail if we
      could not manipulate the usermodehelper settings.
    - Sent as a single patch as capset/capget are now in klibc master.
---
 usr/kinit/Kbuild         |    1 
 usr/kinit/capabilities.c |  237 ++++++++++++++++++++++++++++++++++++++++++++++
 usr/kinit/kinit.c        |    2 
 usr/kinit/kinit.h        |    2 
 4 files changed, 242 insertions(+), 0 deletions(-)
 create mode 100644 usr/kinit/capabilities.c

diff --git a/usr/kinit/Kbuild b/usr/kinit/Kbuild
index ff1d449..8f6d08e 100644
--- a/usr/kinit/Kbuild
+++ b/usr/kinit/Kbuild
@@ -10,6 +10,7 @@ kinit-y  := lib.a
 kinit-y  += kinit.o do_mounts.o ramdisk_load.o initrd.o
 kinit-y  += getintfile.o readfile.o xpio.o
 kinit-y  += do_mounts_md.o do_mounts_mtd.o nfsroot.o
+kinit-y  += capabilities.o
 
 kinit-y  += ipconfig/
 kinit-y  += nfsmount/
diff --git a/usr/kinit/capabilities.c b/usr/kinit/capabilities.c
new file mode 100644
index 0000000..ad4d6ea
--- /dev/null
+++ b/usr/kinit/capabilities.c
@@ -0,0 +1,237 @@
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
+#include <sys/capability.h>
+#include <sys/prctl.h>
+#include <sys/utsname.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "kinit.h"
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
+static void fail(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
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
+	if (cap_ordinal < 32)
+		caps[0].inheritable &= ~(1U << cap_ordinal);
+	else
+		caps[1].inheritable &= ~(1U << (cap_ordinal - 32));
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
+	if (!file && errno == ENOENT)
+		fail("Could not disable usermode helpers capabilities as "
+		     "%s is not available\n", filename);
+	if (!file)
+		fail("Failed to access file %s errno %d\n", filename, errno);
+
+	/* Read and process the current bits */
+	bytes_read = fread(buf, 1, buf_size - 1, file);
+	if (bytes_read == 0)
+		fail("Trouble reading %s\n", filename);
+	buf[bytes_read] = '\0';
+	ret = sscanf(buf, "%u %u %c", &lo32, &hi32, &tail);
+	if (ret != 2)
+		fail("Failed to understand %s \"%s\"\n", filename, buf);
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
+	if (ret != 0)
+		fail("Failed to commit usermode helper bitmasks: %d\n", ret);
+
+	/* Cleanup */
+	fclose(file);
+}
+
+static void do_usermodehelper(int cap_ordinal)
+{
+	static const char * const files[] = {
+		"/proc/sys/kernel/usermodehelper/bset",
+		"/proc/sys/kernel/usermodehelper/inheritable",
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
+int drop_capabilities(const char *caps)
+{
+	char *s, *saveptr = NULL;
+	char *token;
+	int drop_setpcap = 0;
+
+	if (!caps)
+		return 0;
+
+	/* Create a duplicate string that can be modified. */
+	s = strdup(caps);
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
diff --git a/usr/kinit/kinit.c b/usr/kinit/kinit.c
index 4a1f40b..098873b 100644
--- a/usr/kinit/kinit.c
+++ b/usr/kinit/kinit.c
@@ -288,6 +288,8 @@ int main(int argc, char *argv[])
 	check_path("/root");
 	do_mounts(cmdc, cmdv);
 
+	drop_capabilities(get_arg(cmdc, cmdv, "drop_capabilities="));
+
 	if (mnt_procfs) {
 		umount2("/proc", 0);
 		mnt_procfs = 0;
diff --git a/usr/kinit/kinit.h b/usr/kinit/kinit.h
index c2e67b7..85960d8 100644
--- a/usr/kinit/kinit.h
+++ b/usr/kinit/kinit.h
@@ -65,4 +65,6 @@ static inline void dump_args(int argc, char *argv[])
 }
 #endif
 
+int drop_capabilities(const char *caps);
+
 #endif				/* KINIT_H */

