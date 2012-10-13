Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab2JMOCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 10:02:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61892 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2JMOCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 10:02:10 -0400
MIME-Version: 1.0
In-Reply-To: <87bog6925r.fsf@devron.myhome.or.jp>
References: <1349598747-3218-1-git-send-email-linkinjeon@gmail.com>
	<87bog6925r.fsf@devron.myhome.or.jp>
Date: Sat, 13 Oct 2012 23:02:09 +0900
Message-ID: <CAKYAXd-9gm_2Xx1N7VZMu9DyBwwNGFvYsbqAEnPxG23W6AjYFw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] fat (exportfs): rebuild inode if ilookup() fails
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. OGAWA.
2012/10/13 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> --- a/fs/fat/fat.h
>> +++ b/fs/fat/fat.h
>> @@ -214,6 +214,13 @@ static inline sector_t fat_clus_to_blknr(struct msdos_sb_info *sbi, int clus)
>>               + sbi->data_start;
>>  }
>>
>> +static inline void fat_get_blknr_offset(struct msdos_sb_info *sbi,
>> +                             loff_t i_pos, sector_t *blknr, int *offset)
>> +{
>> +     *blknr = i_pos >> sbi->dir_per_block_bits;
>> +     *offset = i_pos & (sbi->dir_per_block - 1);
>> +}
>> +
>
> Let's separate fat_get_blknr_offset() cleanup and others.
Okay.
>
>> +extern loff_t fat_i_pos_read(struct msdos_sb_info *sbi, struct inode *inode);
>
> [...]
>
>> -static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
>> +loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
>>                                   struct inode *inode)
>>  {
>>       loff_t i_pos;
>
> Let's move fat_i_pos_read() to fat.h to make consists with
> fat_get_blknr_offset().
Okay.
>
>>  static const struct export_operations fat_export_ops = {
>> +     .encode_fh      = fat_encode_fh,
>>       .fh_to_dentry   = fat_fh_to_dentry,
>>       .fh_to_parent   = fat_fh_to_parent,
>>       .get_parent     = fat_get_parent,
>> diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
>> index ef4b5fa..156903b 100644
>> --- a/fs/fat/nfs.c
>> +++ b/fs/fat/nfs.c
>> @@ -14,6 +14,14 @@
>>  #include <linux/exportfs.h>
>>  #include "fat.h"
>>
>> +struct fat_fid {
>> +     u32 ino;
>> +     u32 gen;
>> +     u64 i_pos;
>> +     u32 parent_ino;
>> +     u32 parent_gen;
>> +} __packed;
>
> This is sizeof(fat_fid)/sizoef(u32) == 6. IIRC, nfsv2 is not supporting
> FH > 6, true?
I will check and share the result.
>
>> +int
>> +fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
>> +{
>> +     int len = *lenp;
>> +     struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
>> +     struct fat_fid *fid = (struct fat_fid *) fh;
>> +     loff_t i_pos;
>> +     int type = FILEID_INO32_GEN;
>> +
>> +     if (parent && (len < 5)) {
>> +             *lenp = 5;
>> +             return 255;
>> +     } else if (len < 3) {
>> +             *lenp = 3;
>> +             return 255;
>> +     }
>> +
>> +     i_pos = fat_i_pos_read(sbi, inode);
>> +     *lenp = 3;
>> +     fid->ino = inode->i_ino;
>> +     fid->gen = inode->i_generation;
>> +     fid->i_pos = i_pos;
>> +     if (parent) {
>> +             fid->parent_ino = parent->i_ino;
>> +             fid->parent_gen = parent->i_generation;
>> +             type = FILEID_INO32_GEN_PARENT;
>> +             *lenp = 5;
>> +     }
>> +
>> +     return type;
>> +}
>
> I was also thinking to use same FH though, because of limitation of FH
> size. It looks like to be better to separate with "stale_rw".
>
> So, how about to separate at export_operations level?
Good idea!
>
> I.e. (move export_operations to fat/nfs.c)
>
> For stale_rw,
>
> const struct export_operations fat_export_ops = {
>         .fh_to_dentry   = fat_fh_to_dentry,
>         .fh_to_parent   = fat_fh_to_parent,
>         .get_parent     = fat_get_parent,
> }
>
> For nostale_ro,
>
> const struct export_operations fat_export_ops = {
>         .fh_to_dentry   = fat_encode_fh,
>         .fh_to_dentry   = fat_fh_to_dentry,
>         .fh_to_parent   = fat_fh_to_parent,
>         .get_parent     = fat_get_parent,
> }
>
> And we have to think about FH format. I guess we don't need to
> inode->i_ino for nostale_ro.
>
> Maximum i_pos is 40bits, and i_gen is 32bit. So, inode and parent inode
> fits to FH of 5 len, we have to pack those though.
>
> I.e.
>
> struct fat_fid {
>         u32 i_gen;
>         u32 i_pos_low;
>         u16 i_pos_hi;
>         u16 parent_i_pos_hi;
>         u32 parent_i_pos_low;
>         u32 parent_i_gen;
> } __packed;
>
> And define FILEID_FAT_WITHOUT_PARENT and FILEID_FAT_WITH_PARENT.
>
> User of i_ino is only ilookup, right? So, we can add fat_ilookup() for it.
Okay.
>
> struct inode *fat_ilookup(struct super_block *sb, u64 ino)
> {
>         if (stale_rw)
>                 return ilookup(sb, ino);
>
>         return fat_iget(sb, i_pos);
> }
>
> And I noticed we need lock for fat_build_inode() for nostale_ro. Because
> fat_nfs_get_inode() doesn't hold i_mutex of parent dir, right? So, add
> lock to fat_build_inode()
>
> static inline void fat_build_inode_lock(struct msdos_sb_info *sbi)
> {
>         if (sbi->options.nfs == FAT_NFS_NOSTALE_RO)
>                 mutex_lock(&sbi->nfs_build_inode_lock);
> }
>
> static inline void fat_build_inode_unlock(struct msdos_sb_info *sbi)
> {
>         if (sbi->options.nfs == FAT_NFS_NOSTALE_RO)
>                 mutex_unlock(&sbi->nfs_build_inode_lock);
> }
Thanks for specific review and suggestion. :)
I will change the patches as your suggestion.
Hum.. And currently these patch-set was pushed to -mm tree and linux-next.
I am confusing I should request to revert these patch-set or make new
patches base on these patch-set....

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
