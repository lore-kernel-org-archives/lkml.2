Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab2C1Kuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:50:35 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50867 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758025Ab2C1Kud convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:50:33 -0400
MIME-Version: 1.0
In-Reply-To: <1330863946-3136-1-git-send-email-linkinjeon@gmail.com>
References: <1330863946-3136-1-git-send-email-linkinjeon@gmail.com>
Date: Wed, 28 Mar 2012 16:20:31 +0530
Message-ID: <CADDb1s3mZNd0GV3P_W1E+5F3UTptqE_mZVjf1yU==SW41a1z8A@mail.gmail.com>
Subject: Re: [RESEND][PATCH] ext4: add error handling when discarding is fail
 in FITRIM ioctl.
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: tytso@mit.edu
Cc: Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

Can you please update us about the status of this patch? Please let us
know in case there are any suggestions about this.
Looking forward to hear your opinion about the same.

Thanks & Regards,
Amit Sahrawat

On Sun, Mar 4, 2012 at 5:55 PM, Namjae Jeon <linkinjeon@gmail.com> wrote:
> Although free extents is proper not trimmed(mmc driver return error code while sending trim command), currently FITRIM ioctl return success.
> I tried to add exception routine to inform user error code.
>
> #> ./fitrim_test
> end_request: I/O error, dev mmcblk0, sector 27232
> EXT4-fs warning (device mmcblk0): ext4_trim_all_free:4857: Discard command returned error -5
> #>
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/mballoc.c |   24 ++++++++++++++++--------
>  1 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index cb990b2..94182d4 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4901,10 +4901,11 @@ error_return:
>  * one will allocate those blocks, mark it as used in buddy bitmap. This must
>  * be called with under the group lock.
>  */
> -static void ext4_trim_extent(struct super_block *sb, int start, int count,
> +static int ext4_trim_extent(struct super_block *sb, int start, int count,
>                             ext4_group_t group, struct ext4_buddy *e4b)
>  {
>        struct ext4_free_extent ex;
> +       int err;
>
>        trace_ext4_trim_extent(sb, group, start, count);
>
> @@ -4920,9 +4921,10 @@ static void ext4_trim_extent(struct super_block *sb, int start, int count,
>         */
>        mb_mark_used(e4b, &ex);
>        ext4_unlock_group(sb, group);
> -       ext4_issue_discard(sb, group, start, count);
> +       err = ext4_issue_discard(sb, group, start, count);
>        ext4_lock_group(sb, group);
>        mb_free_blocks(NULL, e4b, start, ex.fe_len);
> +       return err;
>  }
>
>  /**
> @@ -4951,7 +4953,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
>        void *bitmap;
>        ext4_grpblk_t next, count = 0, free_count = 0;
>        struct ext4_buddy e4b;
> -       int ret;
> +       int ret = 0;
>
>        trace_ext4_trim_all_free(sb, group, start, max);
>
> @@ -4978,15 +4980,21 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
>                next = mb_find_next_bit(bitmap, max, start);
>
>                if ((next - start) >= minblocks) {
> -                       ext4_trim_extent(sb, start,
> -                                        next - start, group, &e4b);
> -                       count += next - start;
> +                       ret = ext4_trim_extent(sb, start,
> +                                               next - start, group, &e4b);
> +                       if (ret < 0) {
> +                               if (ret != -EOPNOTSUPP)
> +                                       ext4_warning(sb, "Discard command "
> +                                                "returned error %d\n", ret);
> +                               break;
> +                       } else
> +                               count += next - start;
>                }
>                free_count += next - start;
>                start = next + 1;
>
>                if (fatal_signal_pending(current)) {
> -                       count = -ERESTARTSYS;
> +                       ret = -ERESTARTSYS;
>                        break;
>                }
>
> @@ -5009,7 +5017,7 @@ out:
>        ext4_debug("trimmed %d blocks in the group %d\n",
>                count, group);
>
> -       return count;
> +       return (ret < 0) ? ret : count;
>  }
>
>  /**
> --
> 1.7.5.4
>
