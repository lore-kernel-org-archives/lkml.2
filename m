Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1DLFB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 01:01:57 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:34708 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1DLFB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 01:01:56 -0400
Subject: Re: [PATCH 09/34] x86: Allow to override the ROOT_DEV variable
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
In-Reply-To: <20110411150820.GA22004@sepie.suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
	 <1302015561-21047-10-git-send-email-mmarek@suse.cz>
	 <4D9B3581.6080105@zytor.com> <4D9C1AA0.9030008@suse.cz>
	 <20110411150820.GA22004@sepie.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 07:01:10 +0200
Message-ID: <1302584470.26451.11.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 17:08 +0200, Michal Marek wrote:
> Subject: [PATCH] x86: Do not set the rood_dev field in bzImage
> 
> This has been obsoleted by the root= commandline for several years.
> People who still depend on this will surely have a copy of the rdev
> command around, the rest of the world gets rid of another piece of
> buildhost-dependent data in the build.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  arch/x86/boot/Makefile |    9 +--------
>  1 files changed, 1 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index f7cb086..95365a8 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -9,12 +9,6 @@
>  # Changed by many, many contributors over the years.
>  #
>  
> -# ROOT_DEV specifies the default root-device when making the image.
> -# This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
> -# the default of FLOPPY is used by 'build'.
> -
> -ROOT_DEV	:= CURRENT
> -
>  # If you want to preset the SVGA mode, uncomment the next line and
>  # set SVGA_MODE to whatever number you want.
>  # Set it to -DSVGA_MODE=NORMAL_VGA if you just want the EGA/VGA mode.
> @@ -75,8 +69,7 @@ GCOV_PROFILE := n
>  $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
>  
>  quiet_cmd_image = BUILD   $@
> -cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin \
> -	$(ROOT_DEV) > $@
> +cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin > $@
>  
>  $(obj)/bzImage: $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/tools/build FORCE
>  	$(call if_changed,image)

I'm not familiar with the rdev command. I assume it allows one to
manipulate the two rootdev bytes in a kernel image. Anyhow, shouldn't
the above patch be complemented with something like the following?

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
 


