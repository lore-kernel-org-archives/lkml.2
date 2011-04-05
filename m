Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1DEPGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:06:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab1DEO7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:35 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/34] initramfs: Use KBUILD_BUILD_TIMESTAMP for generated entries
Date: Tue,  5 Apr 2011 16:58:55 +0200
Message-Id: <1302015561-21047-9-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gen_init_cpio uses the current time for symlinks, special files and
directories. Make it possible to override this with the
KBUILD_BUILD_TIMESTAMP variable for reproducible builds.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/gen_initramfs_list.sh |    4 ++++
 usr/gen_init_cpio.c           |   17 +++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 4a43fe1..18cde32 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -283,6 +283,10 @@ while [ $# -gt 0 ]; do
 	esac
 done
 
+if test -n "$KBUILD_BUILD_TIMESTAMP"; then
+	export CPIO_TIMESTAMP=$(date -d"$KBUILD_BUILD_TIMESTAMP" +%s)
+fi
+
 # If output_file is set we will generate cpio archive and compress it
 # we are carefull to delete tmp files
 if [ ! -z ${output_file} ]; then
diff --git a/usr/gen_init_cpio.c b/usr/gen_init_cpio.c
index 7f06884..11f604d 100644
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
@@ -529,6 +527,7 @@ int main (int argc, char *argv[])
 	char *args, *type;
 	int ec = 0;
 	int line_nr = 0;
+	const char *env;
 
 	if (2 != argc) {
 		usage(argv[0]);
@@ -544,6 +543,12 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
+	env = getenv("CPIO_TIMESTAMP");
+	if (env)
+		default_mtime = atol(env);
+	if (!default_mtime)
+		default_mtime = time(NULL);
+
 	while (fgets(line, LINE_SIZE, cpio_list)) {
 		int type_idx;
 		size_t slen = strlen(line);
-- 
1.7.4.1

