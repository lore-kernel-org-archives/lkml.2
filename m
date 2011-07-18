Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1GRLz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 07:55:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40167 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab1GRLzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 07:55:55 -0400
MIME-Version: 1.0
In-Reply-To: <1310979967-13470-1-git-send-email-levinsasha928@gmail.com>
References: <1310979967-13470-1-git-send-email-levinsasha928@gmail.com>
Date: Mon, 18 Jul 2011 14:55:53 +0300
X-Google-Sender-Auth: 7g4TV4uf_xv75_pjOYc7E_27s5k
Message-ID: <CAOJsxLG9h_L8x6-W67bMT1ObQKc=ZoLUKO8ocY4QQs=0rhw5ZQ@mail.gmail.com>
Subject: Re: [PATCH] init: Support mounting devices from kernel command line
From: Pekka Enberg <penberg@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 12:06 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> This patch adds support to mounting devices using a kernel parameter.
>
> Such feature is usefull for virtual guests. It allows easily automating
> mounts without having to change the base image (which can be read-only).
>
> In /tools/kvm we are interested in such feature to allow us to automatically
> mount user home directory using virtio-9p from the host to the guest
> filesystem under '/hostfs'.
>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Lets CC fsdevel.

> ---
>  Documentation/kernel-parameters.txt |    6 +++
>  init/do_mounts.c                    |   61 +++++++++++++++++++++++++++++++++++
>  2 files changed, 67 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index aa47be7..e1955fb 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1476,6 +1476,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                        log everything. Information is printed at KERN_DEBUG
>                        so loglevel=8 may also need to be specified.
>
> +       mount=
> +                       [KNL] Mount a device to a mount point after loading
> +                       rootfs and setting up devices. Can be used to mount
> +                       up to 16 devices.
> +                       Format: <source>,<destination>,<fs>[,<params>]
> +
>        mousedev.tap_time=
>                        [MOUSE] Maximum time between finger touching and
>                        leaving touchpad surface for touch to be considered
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index c0851a8..0948f1d 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -29,9 +29,24 @@ int root_mountflags = MS_RDONLY | MS_SILENT;
>  static char * __initdata root_device_name;
>  static char __initdata saved_root_name[64];
>  static int __initdata root_wait;
> +static char * __initdata user_mount[16];
> +static int __initdata user_mount_count;
>
>  dev_t ROOT_DEV;
>
> +static int __init setup_user_mount(char *str)
> +{
> +       if (user_mount_count > 15) {
> +               printk(KERN_ERR "More than 16 'mount=' options specified.")
> +               return 1;
> +       }
> +
> +       user_mount[user_mount_count++] = str;
> +
> +       return 1;
> +}
> +__setup("mount=", setup_user_mount);
> +
>  static int __init load_ramdisk(char *str)
>  {
>        rd_doload = simple_strtol(str,NULL,0) & 3;
> @@ -431,6 +446,51 @@ void __init mount_root(void)
>  #endif
>  }
>
> +int __init do_user_mounts(void)
> +{
> +       int i, res;
> +       char *src, *dst, *fs, *params, *cur;
> +
> +       for (i = 0; i < user_mount_count; i++) {
> +               src = user_mount[i];
> +               cur = strstr(user_mount[i], ",");
> +               if (!cur)
> +                       goto fail_str;
> +
> +               *cur = '\0';
> +               dst = ++cur;
> +
> +               cur = strstr(cur, ",");
> +               if (!cur)
> +                       goto fail_str;
> +
> +               *cur = '\0';
> +               fs = ++cur;
> +
> +               cur = strstr(cur, ",");
> +               if (cur) {
> +                       *cur = '\0';
> +                       params = ++cur;
> +               } else {
> +                       params = NULL;
> +               }
> +
> +               res = sys_mount(src, dst, fs, 0, params);
> +               if (res == 0)
> +                       printk(KERN_INFO "Mounted (%s filesystem) %s to %s\n",
> +                               fs, src, dst);
> +               else
> +                       printk(KERN_ERR "Failed mounting (%s filesystem) %s to"
> +                               " %s. Err: %d\n", fs, src, dst, res);
> +       }
> +
> +       return 0;
> +
> +fail_str:
> +       printk(KERN_ERR "Bad mount str: %s\n", user_mount[i]);
> +       return -1;
> +}
> +
>  /*
>  * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
>  */
> @@ -490,4 +550,5 @@ out:
>        devtmpfs_mount("dev");
>        sys_mount(".", "/", NULL, MS_MOVE, NULL);
>        sys_chroot((const char __user __force *)".");
> +       do_user_mounts();
>  }
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
