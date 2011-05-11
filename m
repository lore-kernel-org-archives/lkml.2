Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab1EKP6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:58:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:52238 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756486Ab1EKP6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:58:18 -0400
Message-ID: <4DCAA99B.1070208@suse.cz>
Date: Wed, 11 May 2011 17:22:03 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: linux-kbuild@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v2] x86: Do not set the root_dev field in bzImage
References: <20110411150820.GA22004@sepie.suse.cz> <1302607824-24699-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1302607824-24699-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.4.2011 13:30, Michal Marek wrote:
> This has been obsoleted by the root= commandline for several years.
> People who still depend on this will surely have a copy of the rdev
> command around, the rest of the world gets rid of another piece of
> buildhost-dependent data in the build. Thanks to Paul Bolle for the
> build.c cleanup.
>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Ingo Molnar<mingo@redhat.com>
> Cc: "H. Peter Anvin"<hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Paul Bolle<pebolle@tiscali.nl>
> Signed-off-by: Michal Marek<mmarek@suse.cz>

Hi,

Is this patch OK for the tip tree?

Michal

>
> diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
> index f7cb086..95365a8 100644
> --- a/arch/x86/boot/Makefile
> +++ b/arch/x86/boot/Makefile
> @@ -9,12 +9,6 @@
>   # Changed by many, many contributors over the years.
>   #
>
> -# ROOT_DEV specifies the default root-device when making the image.
> -# This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
> -# the default of FLOPPY is used by 'build'.
> -
> -ROOT_DEV	:= CURRENT
> -
>   # If you want to preset the SVGA mode, uncomment the next line and
>   # set SVGA_MODE to whatever number you want.
>   # Set it to -DSVGA_MODE=NORMAL_VGA if you just want the EGA/VGA mode.
> @@ -75,8 +69,7 @@ GCOV_PROFILE := n
>   $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
>
>   quiet_cmd_image = BUILD   $@
> -cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin \
> -	$(ROOT_DEV)>  $@
> +cmd_image = $(obj)/tools/build $(obj)/setup.bin $(obj)/vmlinux.bin>  $@
>
>   $(obj)/bzImage: $(obj)/setup.bin $(obj)/vmlinux.bin $(obj)/tools/build FORCE
>   	$(call if_changed,image)
> diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
> index ee3a4ea..fdc60a0 100644
> --- a/arch/x86/boot/tools/build.c
> +++ b/arch/x86/boot/tools/build.c
> @@ -130,7 +130,7 @@ static void die(const char * str, ...)
>
>   static void usage(void)
>   {
> -	die("Usage: build setup system [rootdev] [>  image]");
> +	die("Usage: build setup system [>  image]");
>   }
>
>   int main(int argc, char ** argv)
> @@ -138,39 +138,14 @@ int main(int argc, char ** argv)
>   	unsigned int i, sz, setup_sectors;
>   	int c;
>   	u32 sys_size;
> -	u8 major_root, minor_root;
>   	struct stat sb;
>   	FILE *file;
>   	int fd;
>   	void *kernel;
>   	u32 crc = 0xffffffffUL;
>
> -	if ((argc<  3) || (argc>  4))
> +	if (argc != 3)
>   		usage();
> -	if (argc>  3) {
> -		if (!strcmp(argv[3], "CURRENT")) {
> -			if (stat("/",&sb)) {
> -				perror("/");
> -				die("Couldn't stat /");
> -			}
> -			major_root = major(sb.st_dev);
> -			minor_root = minor(sb.st_dev);
> -		} else if (strcmp(argv[3], "FLOPPY")) {
> -			if (stat(argv[3],&sb)) {
> -				perror(argv[3]);
> -				die("Couldn't stat root device.");
> -			}
> -			major_root = major(sb.st_rdev);
> -			minor_root = minor(sb.st_rdev);
> -		} else {
> -			major_root = 0;
> -			minor_root = 0;
> -		}
> -	} else {
> -		major_root = DEFAULT_MAJOR_ROOT;
> -		minor_root = DEFAULT_MINOR_ROOT;
> -	}
> -	fprintf(stderr, "Root device is (%d, %d)\n", major_root, minor_root);
>
>   	/* Copy the setup code */
>   	file = fopen(argv[1], "r");
> @@ -193,8 +168,8 @@ int main(int argc, char ** argv)
>   	memset(buf+c, 0, i-c);
>
>   	/* Set the default root device */
> -	buf[508] = minor_root;
> -	buf[509] = major_root;
> +	buf[508] = DEFAULT_MINOR_ROOT;
> +	buf[509] = DEFAULT_MAJOR_ROOT;
>
>   	fprintf(stderr, "Setup is %d bytes (padded to %d bytes).\n", c, i);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

