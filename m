Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2FML51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:57:27 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64356 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2FML5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <1334609838-14831-1-git-send-email-mjg@redhat.com>
References: <1334609838-14831-1-git-send-email-mjg@redhat.com>
Date: Wed, 13 Jun 2012 07:57:24 -0400
Message-ID: <CA+5PVA5EAi7O3nLGdxxJo5Hrp3+NJeBuW_Rtxj0QowpUKeGnYw@mail.gmail.com>
Subject: Re: [PATCH V2] hfsplus: Fix bless ioctl when used with hardlinks
From: Josh Boyer <jwboyer@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 4:57 PM, Matthew Garrett <mjg@redhat.com> wrote:
> HFS+ doesn't really implement hard links - instead, hardlinks are indicated
> by a magic file type which refers to an indirect node in a hidden
> directory. The spec indicates that stat() should return the inode number
> of the indirect node, but it turns out that this doesn't satisfy the
> firmware when it's looking for a bootloader - it wants the catalog ID of
> the hardlink file instead. Fix up this case.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>
> V2 cleans up the casting.

Did this patch get dropped on the floor?  It's been almost 2 months
since it was submitted.

josh


>  fs/hfsplus/ioctl.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
> index c640ba5..09addc8 100644
> --- a/fs/hfsplus/ioctl.c
> +++ b/fs/hfsplus/ioctl.c
> @@ -31,6 +31,7 @@ static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)
>        struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
>        struct hfsplus_vh *vh = sbi->s_vhdr;
>        struct hfsplus_vh *bvh = sbi->s_backup_vhdr;
> +       u32 cnid = (unsigned long)dentry->d_fsdata;
>
>        if (!capable(CAP_SYS_ADMIN))
>                return -EPERM;
> @@ -41,8 +42,12 @@ static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)
>        vh->finder_info[0] = bvh->finder_info[0] =
>                cpu_to_be32(parent_ino(dentry));
>
> -       /* Bootloader */
> -       vh->finder_info[1] = bvh->finder_info[1] = cpu_to_be32(inode->i_ino);
> +       /*
> +        * Bootloader. Just using the inode here breaks in the case of
> +        * hard links - the firmware wants the ID of the hard link file,
> +        * but the inode points at the indirect inode
> +        */
> +       vh->finder_info[1] = bvh->finder_info[1] = cpu_to_be32(cnid);
>
>        /* Per spec, the OS X system folder - same as finder_info[0] here */
>        vh->finder_info[5] = bvh->finder_info[5] =
> --
> 1.7.10
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
