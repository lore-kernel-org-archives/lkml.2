Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab1EYUtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:49:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:50398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932590Ab1EYUtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:49:31 -0400
Date: Wed, 25 May 2011 20:49:19 GMT
From: tip-bot for Michal Marek <mmarek@suse.cz>
Message-ID: <tip-079f85e624189292d1c818b47764916bf8cf84a8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pebolle@tiscali.nl, hpa@zytor.com,
        mingo@redhat.com, mmarek@suse.cz, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mmarek@suse.cz,
        hpa@linux.intel.com
In-Reply-To: <1302607824-24699-1-git-send-email-mmarek@suse.cz>
References: <1302607824-24699-1-git-send-email-mmarek@suse.cz>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, build: Do not set the root_dev field in bzImage
Git-Commit-ID: 079f85e624189292d1c818b47764916bf8cf84a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 25 May 2011 20:49:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  079f85e624189292d1c818b47764916bf8cf84a8
Gitweb:     http://git.kernel.org/tip/079f85e624189292d1c818b47764916bf8cf84a8
Author:     Michal Marek <mmarek@suse.cz>
AuthorDate: Tue, 12 Apr 2011 13:30:24 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 25 May 2011 12:46:05 -0700

x86, build: Do not set the root_dev field in bzImage

This has been obsoleted by the root= commandline and the rdev utility
for many, many years.  People who still depend on this will surely
have a copy of the rdev utility around, the rest of the world gets rid
of another piece of buildhost-dependent data in the build. Thanks to
Paul Bolle for the build.c cleanup.

Cc: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Link: http://lkml.kernel.org/r/1302607824-24699-1-git-send-email-mmarek@suse.cz
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/Makefile      |    9 +--------
 arch/x86/boot/tools/build.c |   33 ++++-----------------------------
 2 files changed, 5 insertions(+), 37 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index f7cb086..95365a8 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -9,12 +9,6 @@
 # Changed by many, many contributors over the years.
 #
 
-# ROOT_DEV specifies the default root-device when making the image.
-# This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
-# the default of FLOPPY is used by 'build'.
-
-ROOT_DEV	:= CURRENT
-
 # If you want to preset the SVGA mode, uncomment the next line and
 # set SVGA_MODE to whatever number you want.
 # Set it to -DSVGA_MODE=NORMAL_VGA if you just want the EGA/VGA mode.
@@ -75,8 +69,7 @@ GCOV_PROFILE := n
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
 quiet_cmd_image = BUILD   $@
-cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin \
-	$(ROOT_DEV) > $@
+cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin > $@
 
 $(obj)/bzImage: $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/tools/build FORCE
 	$(call if_changed,image)
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index ee3a4ea..fdc60a0 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -130,7 +130,7 @@ static void die(const char * str, ...)
 
 static void usage(void)
 {
-	die("Usage: build setup system [rootdev] [> image]");
+	die("Usage: build setup system [> image]");
 }
 
 int main(int argc, char ** argv)
@@ -138,39 +138,14 @@ int main(int argc, char ** argv)
 	unsigned int i, sz, setup_sectors;
 	int c;
 	u32 sys_size;
-	u8 major_root, minor_root;
 	struct stat sb;
 	FILE *file;
 	int fd;
 	void *kernel;
 	u32 crc = 0xffffffffUL;
 
-	if ((argc < 3) || (argc > 4))
+	if (argc != 3)
 		usage();
-	if (argc > 3) {
-		if (!strcmp(argv[3], "CURRENT")) {
-			if (stat("/", &sb)) {
-				perror("/");
-				die("Couldn't stat /");
-			}
-			major_root = major(sb.st_dev);
-			minor_root = minor(sb.st_dev);
-		} else if (strcmp(argv[3], "FLOPPY")) {
-			if (stat(argv[3], &sb)) {
-				perror(argv[3]);
-				die("Couldn't stat root device.");
-			}
-			major_root = major(sb.st_rdev);
-			minor_root = minor(sb.st_rdev);
-		} else {
-			major_root = 0;
-			minor_root = 0;
-		}
-	} else {
-		major_root = DEFAULT_MAJOR_ROOT;
-		minor_root = DEFAULT_MINOR_ROOT;
-	}
-	fprintf(stderr, "Root device is (%d, %d)\n", major_root, minor_root);
 
 	/* Copy the setup code */
 	file = fopen(argv[1], "r");
@@ -193,8 +168,8 @@ int main(int argc, char ** argv)
 	memset(buf+c, 0, i-c);
 
 	/* Set the default root device */
-	buf[508] = minor_root;
-	buf[509] = major_root;
+	buf[508] = DEFAULT_MINOR_ROOT;
+	buf[509] = DEFAULT_MAJOR_ROOT;
 
 	fprintf(stderr, "Setup is %d bytes (padded to %d bytes).\n", c, i);
 
