Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab1GWJMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 05:12:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53163 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab1GWJMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 05:12:30 -0400
Date: Sat, 23 Jul 2011 11:11:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/build change for v3.1
Message-ID: <20110723091148.GA17713@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-build-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-build-for-linus

 Thanks,

	Ingo

------------------>
Michal Marek (1):
      x86, build: Do not set the root_dev field in bzImage


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
 
