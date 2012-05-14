Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab2ENW7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:59:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40562 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab2ENW7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:59:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120514142918.GA17915@potato.own3d.co.uk>
References: <20120514142918.GA17915@potato.own3d.co.uk>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Mon, 14 May 2012 17:58:40 -0500
Message-ID: <CAFkjPTmP4n5FiE2Qxksq11iPScyXSaZ79Wsg3Gb5gf71NWtB=g@mail.gmail.com>
Subject: Re: [V9fs-developer] [PATCH] Add support for 9P as a root filesystem
To: Ian Kirk <blob@blob.co.uk>
Cc: v9fs-developer@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this still strictly necessary?  I thought the guys booting with a
root using virtfs didn't need this -- but perhaps their approach
depends on specific configurations in an initrd and this doesn't?

        -eric

(Add cc: linux-fs and cc: linux-kernel)

On Mon, May 14, 2012 at 9:29 AM, Ian Kirk <blob@blob.co.uk> wrote:
> This patch adds support for running a 9P filesystem as root using a method
> similar to NFS root. Passing root=9p to the Kernel command line works
> in a comparable way to passing root=nfs
>
> Signed-off-by: Ian Kirk <blob@blob.co.uk>
> ---
>  fs/9p/Kconfig            |    7 +++++++
>  include/linux/root_dev.h |    1 +
>  init/do_mounts.c         |   25 +++++++++++++++++++++++++
>  3 files changed, 33 insertions(+), 0 deletions(-)
>
> diff --git a/fs/9p/Kconfig b/fs/9p/Kconfig
> index 0a93dc1..ffd73f5 100644
> --- a/fs/9p/Kconfig
> +++ b/fs/9p/Kconfig
> @@ -31,4 +31,11 @@ config 9P_FS_POSIX_ACL
>
>          If you don't know what Access Control Lists are, say N
>
> +config ROOT_9P
> +       bool "9p root filesystem"
> +       depends on 9P_FS=m || 9P_FS=y
> +       help
> +         Permits you to pass root=9p to the kernel command line and have the
> +         root filesystem on 9p
> +
>  endif
> diff --git a/include/linux/root_dev.h b/include/linux/root_dev.h
> index ed241aa..61633ed 100644
> --- a/include/linux/root_dev.h
> +++ b/include/linux/root_dev.h
> @@ -7,6 +7,7 @@
>
>  enum {
>        Root_NFS = MKDEV(UNNAMED_MAJOR, 255),
> +       Root_9P = MKDEV(UNNAMED_MAJOR, 254),
>        Root_RAM0 = MKDEV(RAMDISK_MAJOR, 0),
>        Root_RAM1 = MKDEV(RAMDISK_MAJOR, 1),
>        Root_FD0 = MKDEV(FLOPPY_MAJOR, 0),
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index 2974c8b..4ec8dce 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -212,6 +212,9 @@ dev_t name_to_dev_t(char *name)
>        res = Root_RAM0;
>        if (strcmp(name, "ram") == 0)
>                goto done;
> +       res = Root_9P;
> +       if (strcmp(name, "9p") == 0)
> +               goto done;
>
>        if (strlen(name) > 31)
>                goto fail;
> @@ -439,6 +442,18 @@ static int __init mount_nfs_root(void)
>  }
>  #endif
>
> +#ifdef CONFIG_ROOT_9P
> +static int __init mount_9p_root(void)
> +{
> +       int err = do_mount_root("root", "9p", root_mountflags, root_mount_data);
> +
> +       if (err == 0)
> +               return 1;
> +
> +       return 0;
> +}
> +#endif
> +
>  #if defined(CONFIG_BLK_DEV_RAM) || defined(CONFIG_BLK_DEV_FD)
>  void __init change_floppy(char *fmt, ...)
>  {
> @@ -471,6 +486,16 @@ void __init change_floppy(char *fmt, ...)
>
>  void __init mount_root(void)
>  {
> +#ifdef CONFIG_ROOT_9P
> +       if (MAJOR(ROOT_DEV) == UNNAMED_MAJOR) {
> +               if (mount_9p_root())
> +                       return;
> +
> +               printk(KERN_ERR "VFS: Unable to mount root fs via 9p\n");
> +
> +               ROOT_DEV = Root_FD0;
> +       }
> +#endif
>  #ifdef CONFIG_ROOT_NFS
>        if (MAJOR(ROOT_DEV) == UNNAMED_MAJOR) {
>                if (mount_nfs_root())
> --
> 1.7.1
>
>
> ------------------------------------------------------------------------------
> Live Security Virtual Conference
> Exclusive live event will cover all the ways today's security and
> threat landscape has changed and how IT managers can respond. Discussions
> will include endpoint security, mobile security and the latest in malware
> threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
