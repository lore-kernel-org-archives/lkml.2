Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1DKPGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:06:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:35784 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801Ab1DKPGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:06:45 -0400
From: Michal Marek <mmarek@suse.cz>
To: miltonm@bga.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] initramfs: Use KBUILD_BUILD_TIMESTAMP for generated entries
Date: Mon, 11 Apr 2011 17:06:22 +0200
Message-Id: <1302534382-20077-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <gen-initramfs-timestamp@mdm.bga.com>
References: <gen-initramfs-timestamp@mdm.bga.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gen_init_cpio gets the current time and uses it for each symlink,
special file, and directory.  Grab the current time once and make it
possible to override it with the KBUILD_BUILD_TIMESTAMP variable for
reproducible builds.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Documentation/kbuild/kbuild.txt |    3 +-
 scripts/gen_initramfs_list.sh   |    9 ++++++-
 usr/gen_init_cpio.c             |   53 +++++++++++++++++++++++++++++---------
 3 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 27d7928..46e6cb8 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -200,7 +200,8 @@ To get all available archs you can also specify all. E.g.:
 KBUILD_BUILD_TIMESTAMP
 --------------------------------------------------
 Setting this to a date string overrides the timestamp used in the
-UTS_VERSION definition (uname -v in the running kernel). The default value
+UTS_VERSION definition (uname -v in the running kernel). The value has to
+be a string that can be passed to date -d. The default value
 is the output of the date command at one point during build.
 
 KBUILD_BUILD_USER, KBUILD_BUILD_HOST
diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 4a43fe1..d44cf67 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -287,8 +287,15 @@ done
 # we are carefull to delete tmp files
 if [ ! -z ${output_file} ]; then
 	if [ -z ${cpio_file} ]; then
+		timestamp=
+		if test -n "$KBUILD_BUILD_TIMESTAMP"; then
+			timestamp="$(date -d"$KBUILD_BUILD_TIMESTAMP" +%s || :)"
+			if test -n "$timestamp"; then
+				timestamp="-t $timestamp"
+			fi
+		fi
 		cpio_tfile="$(mktemp ${TMPDIR:-/tmp}/cpiofile.XXXXXX)"
-		usr/gen_init_cpio ${cpio_list} > ${cpio_tfile}
+		usr/gen_init_cpio $timestamp ${cpio_list} > ${cpio_tfile}
 	else
 		cpio_tfile=${cpio_file}
 	fi
diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index 7f06884..af0f22f 100644
--- a/usr/gen_init_cpio.c
+++ b/usr/gen_init_cpio.c
@@ -22,6 +22,7 @@
 
 static unsigned int offset;
 static unsigned int ino = 721;
+static time_t default_mtime;
 
 struct file_handler {
 	const char *type;
@@ -102,7 +103,6 @@ static int cpio_mkslink(const char *name, const char *target,
 			 unsigned int mode, uid_t uid, gid_t gid)
 {
 	char s[256];
-	time_t mtime = time(NULL);
 
 	if (name[0] == '/')
 		name++;
@@ -114,7 +114,7 @@ static int cpio_mkslink(const char *name, const char *target,
 		(long) uid,		/* uid */
 		(long) gid,		/* gid */
 		1,			/* nlink */
-		(long) mtime,		/* mtime */
+		(long) default_mtime,	/* mtime */
 		(unsigned)strlen(target)+1, /* filesize */
 		3,			/* major */
 		1,			/* minor */
@@ -152,7 +152,6 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 		       uid_t uid, gid_t gid)
 {
 	char s[256];
-	time_t mtime = time(NULL);
 
 	if (name[0] == '/')
 		name++;
@@ -164,7 +163,7 @@ static int cpio_mkgeneric(const char *name, unsigned int mode,
 		(long) uid,		/* uid */
 		(long) gid,		/* gid */
 		2,			/* nlink */
-		(long) mtime,		/* mtime */
+		(long) default_mtime,	/* mtime */
 		0,			/* filesize */
 		3,			/* major */
 		1,			/* minor */
@@ -242,7 +241,6 @@ static int cpio_mknod(const char *name, unsigned int mode,
 		       unsigned int maj, unsigned int min)
 {
 	char s[256];
-	time_t mtime = time(NULL);
 
 	if (dev_type == 'b')
 		mode |= S_IFBLK;
@@ -259,7 +257,7 @@ static int cpio_mknod(const char *name, unsigned int mode,
 		(long) uid,		/* uid */
 		(long) gid,		/* gid */
 		1,			/* nlink */
-		(long) mtime,		/* mtime */
+		(long) default_mtime,	/* mtime */
 		0,			/* filesize */
 		3,			/* major */
 		1,			/* minor */
@@ -460,7 +458,7 @@ static int cpio_mkfile_line(const char *line)
 static void usage(const char *prog)
 {
 	fprintf(stderr, "Usage:\n"
-		"\t%s <cpio_list>\n"
+		"\t%s [-t <timestamp>] <cpio_list>\n"
 		"\n"
 		"<cpio_list> is a file containing newline separated entries that\n"
 		"describe the files to be included in the initramfs archive:\n"
@@ -491,7 +489,11 @@ static void usage(const char *prog)
 		"nod /dev/console 0600 0 0 c 5 1\n"
 		"dir /root 0700 0 0\n"
 		"dir /sbin 0755 0 0\n"
-		"file /sbin/kinit /usr/src/klibc/kinit/kinit 0755 0 0\n",
+		"file /sbin/kinit /usr/src/klibc/kinit/kinit 0755 0 0\n"
+		"\n"
+		"<timestamp> is time in seconds since Epoch that will be used\n"
+		"as mtime for symlinks, special files and directories. The default\n"
+		"is to use the current time for these entries.\n",
 		prog);
 }
 
@@ -529,17 +531,42 @@ int main (int argc, char *argv[])
 	char *args, *type;
 	int ec = 0;
 	int line_nr = 0;
+	const char *filename;
+
+	default_mtime = time(NULL);
+	while (1) {
+		int opt = getopt(argc, argv, "t:h");
+		char *invalid;
 
-	if (2 != argc) {
+		if (opt == -1)
+			break;
+		switch (opt) {
+		case 't':
+			default_mtime = strtol(optarg, &invalid, 10);
+			if (!*optarg || *invalid) {
+				fprintf(stderr, "Invalid timestamp: %s\n",
+						optarg);
+				usage(argv[0]);
+				exit(1);
+			}
+			break;
+		case 'h':
+		case '?':
+			usage(argv[0]);
+			exit(opt == 'h' ? 0 : 1);
+		}
+	}
+
+	if (argc - optind != 1) {
 		usage(argv[0]);
 		exit(1);
 	}
-
-	if (!strcmp(argv[1], "-"))
+	filename = argv[optind];
+	if (!strcmp(filename, "-"))
 		cpio_list = stdin;
-	else if (! (cpio_list = fopen(argv[1], "r"))) {
+	else if (!(cpio_list = fopen(filename, "r"))) {
 		fprintf(stderr, "ERROR: unable to open '%s': %s\n\n",
-			argv[1], strerror(errno));
+			filename, strerror(errno));
 		usage(argv[0]);
 		exit(1);
 	}
-- 
1.7.4.1

