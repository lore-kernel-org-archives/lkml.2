Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1JJKGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 06:06:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58253 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab1JJKGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 06:06:40 -0400
MIME-Version: 1.0
In-Reply-To: <e72525141cf56c5add8c3fda53f89641bd09a848.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	<cover.1318233879.git.joe@perches.com>
	<e72525141cf56c5add8c3fda53f89641bd09a848.1318233879.git.joe@perches.com>
Date: Mon, 10 Oct 2011 19:06:39 +0900
Message-ID: <CAKYAXd9GGEyS5Wy4fzB1uHbjdeR8qae0MbU3FpRR1_KTkBme-Q@mail.gmail.com>
Subject: Re: [PATCH 1/6] udf: Promote some debugging messages to udf_error
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/10 Joe Perches <joe@perches.com>:
> If there is a problem with a scratched disc or loader,
> it's valuable to know which error occurred.
>
> Convert some debug messages to udf_error, neaten those messages too.
> Add the calculated tag checksum and the read checksum to error message.
> Make udf_error a public function and move the logging prototypes together.
>
> Original-patch-by: NamJae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: NamJae Jeon <linkinjeon@gmail.com>
> ---
>  fs/udf/misc.c    |   21 ++++++++++++++-------
>  fs/udf/super.c   |    6 ++----
>  fs/udf/udfdecl.h |    9 +++++++--
>  3 files changed, 23 insertions(+), 13 deletions(-)
>
> diff --git a/fs/udf/misc.c b/fs/udf/misc.c
> index 9215700..87667f8 100644
> --- a/fs/udf/misc.c
> +++ b/fs/udf/misc.c
> @@ -204,6 +204,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
>  {
>        struct tag *tag_p;
>        struct buffer_head *bh = NULL;
> +       u8 checksum;
>
>        /* Read the block */
>        if (block == 0xFFFFFFFF)
> @@ -211,7 +212,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
>
>        bh = udf_tread(sb, block);
>        if (!bh) {
> -               udf_debug("block=%d, location=%d: read failed\n",
> +               udf_error(sb, __func__, "read failed, block=%u, location=%d\n",
>                          block, location);
>                return NULL;
>        }
> @@ -221,21 +222,26 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
>        *ident = le16_to_cpu(tag_p->tagIdent);
>
>        if (location != le32_to_cpu(tag_p->tagLocation)) {
> -               udf_debug("location mismatch block %u, tag %u != %u\n",
> +               udf_error(sb, __func__,
> +                         "location mismatch, block %u, tag %u != %u\n",
>                          block, le32_to_cpu(tag_p->tagLocation), location);
>                goto error_out;
>        }
>
>        /* Verify the tag checksum */
> -       if (udf_tag_checksum(tag_p) != tag_p->tagChecksum) {
> -               printk(KERN_ERR "udf: tag checksum failed block %d\n", block);
> +       checksum = udf_tag_checksum(tag_p);
> +       if (checksum != tag_p->tagChecksum) {
> +               udf_error(sb, __func__,
> +                         "tag checksum failed, block %u: 0x%02x != 0x%02x\n",
> +                         block, checksum, tag_p->tagChecksum);
>                goto error_out;
>        }
>
>        /* Verify the tag version */
>        if (tag_p->descVersion != cpu_to_le16(0x0002U) &&
>            tag_p->descVersion != cpu_to_le16(0x0003U)) {
> -               udf_debug("tag version 0x%04x != 0x0002 || 0x0003 block %d\n",
> +               udf_error(sb, __func__,
> +                         "tag version 0x%04x != 0x0002 || 0x0003, block %u\n",
>                          le16_to_cpu(tag_p->descVersion), block);
>                goto error_out;
>        }
> @@ -247,8 +253,9 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
>                                        le16_to_cpu(tag_p->descCRCLength)))
>                return bh;
>
> -       udf_debug("Crc failure block %d: crc = %d, crclen = %d\n", block,
> -           le16_to_cpu(tag_p->descCRC), le16_to_cpu(tag_p->descCRCLength));
> +       udf_error(sb, __func__, "crc failure, block %u: crc = %d, crclen = %d\n",
> +                 block, le16_to_cpu(tag_p->descCRC),
> +                 le16_to_cpu(tag_p->descCRCLength));
>
>  error_out:
>        brelse(bh);
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 7b27b06..80f47ce 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -92,8 +92,6 @@ static void udf_close_lvid(struct super_block *);
>  static unsigned int udf_count_free(struct super_block *);
>  static int udf_statfs(struct dentry *, struct kstatfs *);
>  static int udf_show_options(struct seq_file *, struct vfsmount *);
> -static void udf_error(struct super_block *sb, const char *function,
> -                     const char *fmt, ...);
>
>  struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi)
>  {
> @@ -2096,8 +2094,8 @@ error_out:
>        return -EINVAL;
>  }
>
> -static void udf_error(struct super_block *sb, const char *function,
> -                     const char *fmt, ...)
> +void udf_error(struct super_block *sb, const char *function,
> +              const char *fmt, ...)
>  {
>        va_list args;
>
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index dbd52d4b..81e66af 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -29,6 +29,13 @@ do { \
>  #define udf_debug(f, a...) /**/
>  #endif
>
> +__attribute__((format(printf, 3, 4)))
> +extern void udf_warning(struct super_block *, const char *, const char *, ...);
> +
> +__attribute__((format(printf, 3, 4)))
> +extern void udf_error(struct super_block *sb, const char *function,
> +                     const char *fmt, ...);
> +
>  #define udf_info(f, a...) \
>        printk(KERN_INFO "UDF-fs INFO " f, ##a);
>
> @@ -112,8 +119,6 @@ struct extent_position {
>
>  /* super.c */
>
> -__attribute__((format(printf, 3, 4)))
> -extern void udf_warning(struct super_block *, const char *, const char *, ...);
>  static inline void udf_updated_lvid(struct super_block *sb)
>  {
>        struct buffer_head *bh = UDF_SB(sb)->s_lvid_bh;
> --
> 1.7.6.405.gc1be0
>
>
