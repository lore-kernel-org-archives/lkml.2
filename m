Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1C1F50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 01:57:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36249 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1C1F5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 01:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gV90Bi0UvQfkl3+WLZA4U7Hn4+Wq/9tA8z7mHVaHKcVEVQ501MVQjrR05rdiueWm/m
         y9jYZiKdBjucESSdVs6Ib8HFPEHAJnpkdHK4DJMB3Lo97pjeZk84fQWnIOgzLsFt/F5k
         QBoeTt1SdylLzuIoEh0HhJYQKndz2wz8+Be5U=
MIME-Version: 1.0
In-Reply-To: <877hbkpo7v.fsf@devron.myhome.or.jp>
References: <20110318020433.GA27263@july>
	<877hbkpo7v.fsf@devron.myhome.or.jp>
Date: Mon, 28 Mar 2011 14:57:22 +0900
X-Google-Sender-Auth: 6_H026txwMXLQafY1nisLpu0Nlg
Message-ID: <AANLkTimxojxAKbOE6XYa5DctNMpU8ob4+eAG05iwN=3P@mail.gmail.com>
Subject: Re: [PATCH v5] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 12:39 AM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Kyungmin Park <kmpark@infradead.org> writes:
>
>> From: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> FAT supports batched discard as ext4.
>>
>> Cited from Lukas words.
>> "The current solution is not ideal because of its bad performance impact.
>> So basic idea to improve things is to avoid discarding every time some
>> blocks are freed. and instead batching is together into bigger trims,
>> which tends to be more effective."
>>
>> You can find an information in detail at following URLs.
>> http://lwn.net/Articles/397538/
>> http://lwn.net/Articles/383933/
>>
>> Clearify the meaning of "len" (Cited form Lukas mail)
>>
>> Let the "O" be free (bytes, blocks, whatever), and "=" be used.
>> Now, we have a filesystem like this.
>>
>>   OOOO==O===OO===OOOOO==O===O===OOOOOOO===
>>   ^                                      ^
>>   0                                      40
>>
>> This is how it supposed to wotk if you have called FITIRM with parameters:
>>
>> start = 0
>> minlen = 2
>> len = 20
>>
>> So you will go through (blocks, bytes...) 0 -> 20
>>
>>   OOOO==O===OO===OOOOO==O===O===OOOOOOO===
>>   ^                   ^
>>   0                   20
>>
>> So, you will call discard on extents:
>>
>> 0-3
>> You'll skip 6 because is smaller than minlen
>> 10-11
>> 15-19
>>
>> instead of
>>
>> 0-3
>> 10-11
>> 15-19
>> 30-36
>>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> Changelog v5:
>>       Exit when start cluster is grater than max cluster
>>
>> Changelog v4:
>>       Simplify the exit condition
>>
>> Changelog v3:
>>       Adjust the minlen from queue discard_granularity
>>       Use the corrent len usage
>> Changelog v2:
>>       Use the given start and len as Lukas comments
>>       Check the queue supports discard feature
>> ---
>> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
>> index f504089..08b53e1 100644
>> --- a/fs/fat/fat.h
>> +++ b/fs/fat/fat.h
>> @@ -299,6 +299,7 @@ extern int fat_alloc_clusters(struct inode *inode, int *cluster,
>>                             int nr_cluster);
>>  extern int fat_free_clusters(struct inode *inode, int cluster);
>>  extern int fat_count_free_clusters(struct super_block *sb);
>> +extern int fat_trim_fs(struct super_block *sb, struct fstrim_range *range);
>>
>>  /* fat/file.c */
>>  extern long fat_generic_ioctl(struct file *filp, unsigned int cmd,
>> diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
>> index b47d2c9..cc89ea6 100644
>> --- a/fs/fat/fatent.c
>> +++ b/fs/fat/fatent.c
>> @@ -1,6 +1,8 @@
>>  /*
>>   * Copyright (C) 2004, OGAWA Hirofumi
>>   * Released under GPL v2.
>> + *
>> + * Batched discard support by Kyungmin Park <kyungmin.park@samsung.com>
>>   */
>>
>>  #include <linux/module.h>
>> @@ -541,6 +543,16 @@ out:
>>       return err;
>>  }
>>
>> +static int fat_issue_discard(struct super_block *sb, int cluster, int nr_clus)
>> +{
>> +     struct msdos_sb_info *sbi = MSDOS_SB(sb);
>> +     sector_t block, nr_blocks;
>> +
>> +     block = fat_clus_to_blknr(sbi, cluster);
>> +     nr_blocks = nr_clus * sbi->sec_per_clus;
>> +     return sb_issue_discard(sb, block, nr_blocks, GFP_NOFS, 0);
>> +}
>> +
>>  int fat_free_clusters(struct inode *inode, int cluster)
>>  {
>>       struct super_block *sb = inode->i_sb;
>> @@ -575,11 +587,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
>>                       if (cluster != fatent.entry + 1) {
>>                               int nr_clus = fatent.entry - first_cl + 1;
>>
>> -                             sb_issue_discard(sb,
>> -                                     fat_clus_to_blknr(sbi, first_cl),
>> -                                     nr_clus * sbi->sec_per_clus,
>> -                                     GFP_NOFS, 0);
>> -
>> +                             fat_issue_discard(sb, first_cl, nr_clus);
>>                               first_cl = cluster;
>>                       }
>>               }
>> @@ -683,3 +691,86 @@ out:
>>       unlock_fat(sbi);
>>       return err;
>>  }
>> +
>> +int fat_trim_fs(struct super_block *sb, struct fstrim_range *range)
>> +{
>> +     struct msdos_sb_info *sbi = MSDOS_SB(sb);
>> +     struct fatent_operations *ops = sbi->fatent_ops;
>> +     struct fat_entry fatent;
>> +     unsigned long reada_blocks, reada_mask, cur_block;
>> +     int err, free, count, entry;
>> +     int start, len, minlen, trimmed;
>> +
>> +     start = range->start >> sb->s_blocksize_bits;
>> +     start = start / sbi->sec_per_clus;
>
> start is round-down, I think it's strange interface. E.g. user specified
> the range as "start=10 len=1024". So the range should be 10-1034,
> i.e. (assume cluster-size is 512) 512-1024, right?

I don't know what's the correct way? If you're right. it's better to round-up.
If cluster-size is 32KiB and start sector is in the middle of cluster,
then which is better. round-down or round-up?
>
>> +     len = range->len >> sb->s_blocksize_bits;
>> +     len = len / sbi->sec_per_clus;
>
> And the end cluster should be round_down(start+len), right?
> i.e. start=10 len=1014, the end should be 1024 not 512.
will fix it.
>
>> +     minlen = range->minlen >> sb->s_blocksize_bits;
>> +     minlen = minlen / sbi->sec_per_clus;
>> +     trimmed = 0;
>> +     count = 0;
>> +     err = -EINVAL;
>> +
>> +     lock_fat(sbi);
>> +     if (sbi->free_clusters != -1 && sbi->free_clus_valid)
>> +             goto out;
>
> free clusters count validation doesn't matter here. If you want to check
> free cluster count, you should check free_clusters==0 or not (after
> validation).

I borrowed it from "fat_count_free_clusters()". anyway fill fix it.
>
>> +     if (start >= sbi->max_cluster)
>> +             goto out;
>
> This check can be done outside lock. And don't we need to check other
> parameters from userland?
I refereed it from ext4. it checked at ext4 codes.
>
>> +     if (start < FAT_START_ENT)
>> +             start = FAT_START_ENT;
>
> Valid data cluster is 2 - max_cluster, but it should be mapped to 0 -
> (max_cluster - FAT_START_ENT). Otherwise this interface's abstraction is
> useless, right?

user program don't know the filesystem internals. The same program is
used for ext4 and fat. so it should be handled at filesystem.
>
>> +     fatent_set_entry(&fatent, start);
>> +
>> +     while (count < sbi->max_cluster) {
>> +             if (fatent.entry >= sbi->max_cluster)
>> +                     fatent.entry = FAT_START_ENT;
>
> Why do we cyclic this?
If the start is middle and len is the whole disk size, then check the
all clusters.
>
>> +             /* readahead of fat blocks */
>> +             if ((cur_block & reada_mask) == 0) {
>> +                     unsigned long rest = sbi->fat_length - cur_block;
>> +                     fat_ent_reada(sb, &fatent, min(reada_blocks, rest));
>> +             }
>> +             cur_block++;
>> +
>> +             err = fat_ent_read_block(sb, &fatent);
>> +             if (err)
>> +                     goto out;
>> +
>> +             do {
>> +                     if (ops->ent_get(&fatent) == FAT_ENT_FREE) {
>> +                             free++;
>> +                             if (!entry)
>> +                                     entry = fatent.entry;
>> +                     } else if (entry) {
>> +                             if (free >= minlen) {
>> +                                     fat_issue_discard(sb, entry, free);
>> +                                     trimmed += free;
>> +                             }
>> +                             free = 0;
>> +                             entry = 0;
>> +                     }
>> +                     count++;
>> +                     if (count >= len)
>> +                             goto done;
>> +             } while (fat_ent_next(sbi, &fatent));
>> +     }
>> +done:
>> +     if (free >= minlen) {
>> +             fat_issue_discard(sb, entry, free);
>> +             trimmed += free;
>> +     }
>> +     range->len = (trimmed * sbi->sec_per_clus) << sb->s_blocksize_bits;
>
> this doesn't need cast?
>
>        range->len = (u64)(trimmed * sbi->sec_per_clus) << sb->s_blocksize_bits;
will fix it.
>
>> +     fatent_brelse(&fatent);
>> +out:
>> +     unlock_fat(sbi);
>> +     return err;
>> +}
>> diff --git a/fs/fat/file.c b/fs/fat/file.c
>> index 7257752..9910aba 100644
>> --- a/fs/fat/file.c
>> +++ b/fs/fat/file.c
>> @@ -125,6 +125,36 @@ long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>>               return fat_ioctl_get_attributes(inode, user_attr);
>>       case FAT_IOCTL_SET_ATTRIBUTES:
>>               return fat_ioctl_set_attributes(filp, user_attr);
>> +     case FITRIM:
>> +     {
>> +             struct super_block *sb = inode->i_sb;
>> +             struct request_queue *q = bdev_get_queue(sb->s_bdev);
>> +             struct fstrim_range range;
>> +             int ret = 0;
>> +
>> +             if (!capable(CAP_SYS_ADMIN))
>> +                     return -EPERM;
>> +
>> +             if (!blk_queue_discard(q))
>> +                     return -EOPNOTSUPP;
>> +
>> +             if (copy_from_user(&range, (struct fstrim_range *)arg,
>> +                                     sizeof(range)))
>> +                     return -EFAULT;
>
> Please use __user annotation.
Okay
>
>> +             range.minlen = max((unsigned int)range.minlen,
>> +                                     q->limits.discard_granularity);
>
> Please use max_t() instead.
Okay
>
>> +             ret = fat_trim_fs(sb, &range);
>> +             if (ret < 0)
>> +                     return ret;
>> +
>> +             if (copy_to_user((struct fstrim_range *)arg, &range,
>> +                                     sizeof(range)))
>> +                     return -EFAULT;
>> +
>> +             return 0;
>> +     }
>> +
>>       default:
>>               return -ENOTTY; /* Inappropriate ioctl for device */
>>       }
>
> This doesn't need compat_ioctl?
I'm not sure it's needed?
I don't see other filesystem does.

Thank you,
Kyungmin Park
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
