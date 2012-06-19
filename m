Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2FSInz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:43:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57737 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab2FSInw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:43:52 -0400
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        util-linux@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Rob Landley <rob@landley.net>,
        Bernhard Voelker <mail@bernhard-voelker.de>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: [PATCH] docs: block: update ioprio.txt
Date: Tue, 19 Jun 2012 16:51:37 +0800
Message-Id: <1340095897-9014-1-git-send-email-wenqing.lz@taobao.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

The ionice.c in ioprio.txt document needed updating for the latest util-linux
version.

CC: Jens Axboe <axboe@kernel.dk>
CC: Rob Landley <rob@landley.net>
CC: Bernhard Voelker <mail@bernhard-voelker.de>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 Documentation/block/ioprio.txt |  174 +++++++++++++++++++++++++---------------
 1 files changed, 109 insertions(+), 65 deletions(-)

diff --git a/Documentation/block/ioprio.txt b/Documentation/block/ioprio.txt
index 8ed8c59..4aa59d6 100644
--- a/Documentation/block/ioprio.txt
+++ b/Documentation/block/ioprio.txt
@@ -64,36 +64,19 @@ will change pid 100 to run at the realtime scheduling class, at priority 2.
 #include <errno.h>
 #include <getopt.h>
 #include <unistd.h>
-#include <sys/ptrace.h>
-#include <asm/unistd.h>
-
-extern int sys_ioprio_set(int, int, int);
-extern int sys_ioprio_get(int, int);
-
-#if defined(__i386__)
-#define __NR_ioprio_set		289
-#define __NR_ioprio_get		290
-#elif defined(__ppc__)
-#define __NR_ioprio_set		273
-#define __NR_ioprio_get		274
-#elif defined(__x86_64__)
-#define __NR_ioprio_set		251
-#define __NR_ioprio_get		252
-#elif defined(__ia64__)
-#define __NR_ioprio_set		1274
-#define __NR_ioprio_get		1275
-#else
-#error "Unsupported arch"
-#endif
+#include <sys/syscall.h>
+#include <ctype.h>
+
+static int tolerant;
 
 static inline int ioprio_set(int which, int who, int ioprio)
 {
-	return syscall(__NR_ioprio_set, which, who, ioprio);
+	return syscall(SYS_ioprio_set, which, who, ioprio);
 }
 
 static inline int ioprio_get(int which, int who)
 {
-	return syscall(__NR_ioprio_get, which, who);
+	return syscall(SYS_ioprio_get, which, who);
 }
 
 enum {
@@ -109,72 +92,133 @@ enum {
 	IOPRIO_WHO_USER,
 };
 
-#define IOPRIO_CLASS_SHIFT	13
+#define IOPRIO_CLASS_SHIFT	(13)
+#define IOPRIO_PRIO_MASK	((1UL << IOPRIO_CLASS_SHIFT) - 1)
 
-const char *to_prio[] = { "none", "realtime", "best-effort", "idle", };
+#define IOPRIO_PRIO_CLASS(mask)	((mask) >> IOPRIO_CLASS_SHIFT)
+#define IOPRIO_PRIO_DATA(mask)	((mask) & IOPRIO_PRIO_MASK)
+#define IOPRIO_PRIO_VALUE(class, data)	(((class) << IOPRIO_CLASS_SHIFT) | data)
 
-int main(int argc, char *argv[])
-{
-	int ioprio = 4, set = 0, ioprio_class = IOPRIO_CLASS_BE;
-	int c, pid = 0;
+const char *to_prio[] = {
+	[IOPRIO_CLASS_NONE] = "none",
+	[IOPRIO_CLASS_RT]   = "realtime",
+	[IOPRIO_CLASS_BE]   = "best-effort",
+	[IOPRIO_CLASS_IDLE] = "idle"
+};
 
-	while ((c = getopt(argc, argv, "+n:c:p:")) != EOF) {
+int main(int argc, char **argv)
+{
+	int data = 4, set = 0, ioclass = IOPRIO_CLASS_BE, c;
+	pid_t pid = 0;
+
+	static const struct option longopts[] = {
+		{ "classdata", required_argument, NULL, 'n' },
+		{ "class",     required_argument, NULL, 'c' },
+		{ "help",      no_argument,       NULL, 'h' },
+		{ "ignore",    no_argument,       NULL, 't' },
+		{ "pid",       required_argument, NULL, 'p' },
+		{ "version",   no_argument,       NULL, 'V' },
+		{ NULL, 0, NULL, 0 }
+	};
+
+	setlocale(LC_ALL, "");
+	bindtextdomain(PACKAGE, LOCALEDIR);
+	textdomain(PACKAGE);
+	atexit(close_stdout);
+
+	while ((c = getopt_long(argc, argv, "+n:c:p:tVh", longopts, NULL)) != EOF)
 		switch (c) {
 		case 'n':
-			ioprio = strtol(optarg, NULL, 10);
-			set = 1;
+			data = strtos32_or_err(optarg, _("invalid class data argument"));
+			set |= 1;
 			break;
 		case 'c':
-			ioprio_class = strtol(optarg, NULL, 10);
-			set = 1;
+			if (isdigit(*optarg))
+				ioclass = strtos32_or_err(optarg,
+						_("invalid class argument"));
+			else {
+				ioclass = parse_ioclass(optarg);
+				if (ioclass < 0)
+					errx(EXIT_FAILURE,
+						_("unknown scheduling class: '%s'"),
+						optarg);
+			}
+			set |= 2;
 			break;
 		case 'p':
-			pid = strtol(optarg, NULL, 10);
+			pid = strtos32_or_err(optarg, _("invalid PID argument"));
 			break;
+		case 't':
+			tolerant = 1;
+			break;
+		case 'V':
+			printf(_("%s from %s\n"),
+				program_invocation_short_name, PACKAGE_STRING);
+			return EXIT_SUCCESS;
+		case 'h':
+			usage(stdout);
+		default:
+			usage(stderr);
 		}
-	}
 
-	switch (ioprio_class) {
+	switch (ioclass) {
 		case IOPRIO_CLASS_NONE:
-			ioprio_class = IOPRIO_CLASS_BE;
+			if ((set & 1) && !tolerant)
+				warnx(_("ignoring given class data for none class"));
+			data = 0;
 			break;
 		case IOPRIO_CLASS_RT:
 		case IOPRIO_CLASS_BE:
 			break;
 		case IOPRIO_CLASS_IDLE:
-			ioprio = 7;
+			if ((set & 1) && !tolerant)
+				warnx(_("ignoring given class data for idle class"));
+			data = 7;
 			break;
 		default:
-			printf("bad prio class %d\n", ioprio_class);
-			return 1;
+			if (!tolerant)
+				warnx(_("unknown prio class %d"), ioclass);
+			break;
 	}
 
-	if (!set) {
-		if (!pid && argv[optind])
-			pid = strtol(argv[optind], NULL, 10);
-
-		ioprio = ioprio_get(IOPRIO_WHO_PROCESS, pid);
-
-		printf("pid=%d, %d\n", pid, ioprio);
-
-		if (ioprio == -1)
-			perror("ioprio_get");
-		else {
-			ioprio_class = ioprio >> IOPRIO_CLASS_SHIFT;
-			ioprio = ioprio & 0xff;
-			printf("%s: prio %d\n", to_prio[ioprio_class], ioprio);
+	if (!set && !pid && optind == argc)
+		/*
+		 * ionice without options, print the current ioprio
+		 */
+		ioprio_print(0);
+
+	else if (!set && pid) {
+		/*
+		 * ionice -p PID [PID ...]
+		 */
+		ioprio_print(pid);
+
+		for(; argv[optind]; ++optind) {
+			pid = strtos32_or_err(argv[optind], _("invalid PID argument"));
+			ioprio_print(pid);
 		}
-	} else {
-		if (ioprio_set(IOPRIO_WHO_PROCESS, pid, ioprio | ioprio_class << IOPRIO_CLASS_SHIFT) == -1) {
-			perror("ioprio_set");
-			return 1;
+	} else if (set && pid) {
+		/*
+		 * ionice -c CLASS -p PID [PID ...]
+		 */
+		ioprio_setpid(pid, ioclass, data);
+
+		for(; argv[optind]; ++optind) {
+			pid = strtos32_or_err(argv[optind], _("invalid PID argument"));
+			ioprio_setpid(pid, ioclass, data);
 		}
-
-		if (argv[optind])
-			execvp(argv[optind], &argv[optind]);
-	}
-
-	return 0;
+	} else if (argv[optind]) {
+		/*
+		 * ionice [-c CLASS] COMMAND
+		 */
+		ioprio_setpid(0, ioclass, data);
+		execvp(argv[optind], &argv[optind]);
+		err(EXIT_FAILURE, _("executing %s failed"), argv[optind]);
+	} else
+		usage(stderr);
+
+
+	return EXIT_SUCCESS;
 }
 
 ---> snip ionice.c tool <---
-- 
1.7.4.1

