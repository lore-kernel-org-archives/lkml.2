Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1BXLTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 06:19:40 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:60852 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641Ab1BXLTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 06:19:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DkGGacd/1mDCYsmCt3KoA6XPK+WSuLf0TM/D6QwI3EzC8qEpgd2WLJj7HP5nmedPif
         YQOYJT87RaKPkzT2Adx96EuvD2py9vkrN5ELWxPzk/YUj2MKUEZ1VEsehuyIimk+rzvH
         dCRDVMIPz83C8lGxyuw32oQL6WX9S9Ux2VIJ4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1102241158320.3190@dhcp-27-109.brq.redhat.com>
References: <20110224051046.GA30130@july>
	<alpine.LFD.2.00.1102240934360.3190@dhcp-27-109.brq.redhat.com>
	<AANLkTi==xJLbqSs6E-+cqxRNZqb4ANayCaqUfST_MoqO@mail.gmail.com>
	<alpine.LFD.2.00.1102241158320.3190@dhcp-27-109.brq.redhat.com>
Date: Thu, 24 Feb 2011 20:19:37 +0900
X-Google-Sender-Auth: OTTAuvSRVkXaOb00sReGfcFnAJY
Message-ID: <AANLkTimnj1Cq1ojs6RkVxqsus1Ab4ycebfcdL05XLrjQ@mail.gmail.com>
Subject: Re: [PATCH v2] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 8:03 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Thu, 24 Feb 2011, Kyungmin Park wrote:
>
>> On Thu, Feb 24, 2011 at 5:53 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>> > On Thu, 24 Feb 2011, Kyungmin Park wrote:
>> >
>> >> From: Kyungmin Park <kyungmin.park@samsung.com>
>> >>
>> >> FAT supports batched discard as ext4.
>> >>
>> >> Cited from Lukas words.
>> >> "The current solution is not ideal because of its bad performance impact.
>> >> So basic idea to improve things is to avoid discarding every time some
>> >> blocks are freed. and instead batching is together into bigger trims,
>> >> which tends to be more effective."
>> >>
>> >> You can find an information in detail at following URLs.
>> >> http://lwn.net/Articles/397538/
>> >> http://lwn.net/Articles/383933/
>> >>
>> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> >
>> > Hi Kyungmin,
>> > thanks to second version. How did you test it ? You can try xtestest
>> > 251 for simple verification.
>> > I can not really comment on FAT specific code, however I have couple of
>> > comments bellow.
>> >
>> > Thanks!
>> > -Lukas
>> >
>> >> ---
>> >> Changelog V2:
>> >>       Use the given start and len as Lukas comments
>> >>       Check the queue supports discard feature
>> >> ---
>> >> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
>> >> index f504089..08b53e1 100644
>> >> --- a/fs/fat/fat.h
>> >> +++ b/fs/fat/fat.h
>> >> @@ -299,6 +299,7 @@ extern int fat_alloc_clusters(struct inode *inode, int *cluster,
>> >>                             int nr_cluster);
>> >>  extern int fat_free_clusters(struct inode *inode, int cluster);
>> >>  extern int fat_count_free_clusters(struct super_block *sb);
>> >> +extern int fat_trim_fs(struct super_block *sb, struct fstrim_range *range);
>> >>
>> >>  /* fat/file.c */
>> >>  extern long fat_generic_ioctl(struct file *filp, unsigned int cmd,
>> >> diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
>> >> index b47d2c9..ea31ee4 100644
>> >> --- a/fs/fat/fatent.c
>> >> +++ b/fs/fat/fatent.c
>> >> @@ -1,6 +1,8 @@
>> >>  /*
>> >>   * Copyright (C) 2004, OGAWA Hirofumi
>> >>   * Released under GPL v2.
>> >> + *
>> >> + * Batched discard support by Kyungmin Park <kyungmin.park@samsung.com>
>> >>   */
>> >>
>> >>  #include <linux/module.h>
>> >> @@ -541,6 +543,16 @@ out:
>> >>       return err;
>> >>  }
>> >>
>> >> +static int fat_issue_discard(struct super_block *sb, int cluster, int nr_clus)
>> >> +{
>> >> +     struct msdos_sb_info *sbi = MSDOS_SB(sb);
>> >> +     sector_t block, nr_blocks;
>> >> +
>> >> +        block = fat_clus_to_blknr(sbi, cluster);
>> >> +        nr_blocks = nr_clus * sbi->sec_per_clus;
>> >> +        return sb_issue_discard(sb, block, nr_blocks, GFP_NOFS, 0);
>> >   ^^^^^^^^
>> > This patch does not pass checkpatch.pl script. Use tabs for indention.
>> right, I will fix it. now passed the checkpatch.pl.
>>
>> >
>> >> +}
>> >> +
>> >>  int fat_free_clusters(struct inode *inode, int cluster)
>> >>  {
>> >>       struct super_block *sb = inode->i_sb;
>> >> @@ -575,11 +587,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
>> >>                       if (cluster != fatent.entry + 1) {
>> >>                               int nr_clus = fatent.entry - first_cl + 1;
>> >>
>> >> -                             sb_issue_discard(sb,
>> >> -                                     fat_clus_to_blknr(sbi, first_cl),
>> >> -                                     nr_clus * sbi->sec_per_clus,
>> >> -                                     GFP_NOFS, 0);
>> >> -
>> >> +                             fat_issue_discard(sb, first_cl, nr_clus);
>> >>                               first_cl = cluster;
>> >>                       }
>> >>               }
>> >> @@ -683,3 +691,88 @@ out:
>> >>       unlock_fat(sbi);
>> >>       return err;
>> >>  }
>> >> +
>> >> +int fat_trim_fs(struct super_block *sb, struct fstrim_range *range)
>> >> +{
>> >> +     struct msdos_sb_info *sbi = MSDOS_SB(sb);
>> >> +     struct fatent_operations *ops = sbi->fatent_ops;
>> >> +     struct fat_entry fatent;
>> >> +     unsigned long reada_blocks, reada_mask, cur_block;
>> >> +     int err = 0, free, count, entry;
>> >> +     int start, len, minlen, trimmed;
>> >> +
>> >> +     start = range->start >> sb->s_blocksize_bits;
>> >> +     start = start / sbi->sec_per_clus;
>> >> +     len = range->len >> sb->s_blocksize_bits;
>> >> +     len = len / sbi->sec_per_clus;
>> >> +     minlen = range->minlen >> sb->s_blocksize_bits;
>> >> +     minlen = minlen / sbi->sec_per_clus;
>> >
>> > I should have mention that earlier, but you can also adjust mineln
>> > according to the discard_granularity, because extents smaller than that
>> > would not be discarded anyway.
>> I adjust the minlen granularity with fat cluster unit. and FAT don't
>> know what's the effected  block size. it's role of user side.
>
> Actually it is not and you should check
> request_queue->limits.discard_granularity

Okay, it's simple one, I will add it.
>
> see: http://www.spinics.net/lists/linux-ext4/msg23145.html
>
>> >
>> >> +     trimmed = 0;
>> >> +     count = 0;
>> >> +
>> >> +     lock_fat(sbi);
>> >> +     if (sbi->free_clusters != -1 && sbi->free_clus_valid)
>> >> +             goto out;
>> >> +
>> >> +     reada_blocks = FAT_READA_SIZE >> sb->s_blocksize_bits;
>> >> +     reada_mask = reada_blocks - 1;
>> >> +     cur_block = 0;
>> >> +
>> >> +     entry = 0;
>> >> +     free = 0;
>> >> +     fatent_init(&fatent);
>> >> +
>> >> +     if (start < FAT_START_ENT)
>> >> +             start = FAT_START_ENT;
>> >
>> > You're not using start anywhere.
>> >
>> >> +
>> >> +     fatent_set_entry(&fatent, FAT_START_ENT);
>> It should be fatent_set_entry(&fatent, start);
>> >> +
>> >> +     while (count < sbi->max_cluster) {
>> >> +             if (fatent.entry >= sbi->max_cluster)
>> >> +                     fatent.entry = FAT_START_ENT;
>> >> +             /* readahead of fat blocks */
>> >> +             if ((cur_block & reada_mask) == 0) {
>> >> +                     unsigned long rest = sbi->fat_length - cur_block;
>> >> +                     fat_ent_reada(sb, &fatent, min(reada_blocks, rest));
>> >> +             }
>> >> +             cur_block++;
>> >> +
>> >> +             err = fat_ent_read_block(sb, &fatent);
>> >> +             if (err)
>> >> +                     goto out;
>> >> +
>> >> +             do {
>> >> +                     if (ops->ent_get(&fatent) == FAT_ENT_FREE) {
>> >> +                             free++;
>> >> +                             if (!entry)
>> >> +                                     entry = fatent.entry;
>> >> +                             if (free >= (len - trimmed) && free >= minlen) {
>> >
>> > It seems to me that you are using len as number of bytes to trim. This
>> > is not right and I am sorry for not explaining it correctly. "len" is
>> > supposed to be a number of bytes you want to "investigate" from the start.
>> > So it means that you will trim every single free extent bigger than minlen
>> > between "start" byte and "start + len" byte of the underlying device, or
>> > partition.
>> No. len is adjusted at fat cluster number. it's not used byte unit.
>> I think it's easy to compare with fat internal units.
>
> Does not matter what units are you using for len. I it just that you are
> checking for (free >= (len - trimmed)) which is wrong because len is not
> meant to be "overall length of trimmed data" but rather "overall length
> of data to walk through and check for free extents" see ext4
> implementation for reference.
I think I used it as you said. e.g., I want to trim 256 (* minimum
discard granularity),
First time, I can find 10 entries. and trimmed has 10 and len has still 256.
next time, I found the 246 free entries then trim remaining 246 one.

do you want to trim it more than given len?

Thank you,
Kyungmin Park
>
> Thanks!
> -Lukas
>
>>
>> I hope fat peoples comment this one.
>>
>> Thank you,
>> Kyungmin Park
>> >
>> >> +                                     fat_issue_discard(sb, entry, free);
>> >> +                                     trimmed += free;
>> >> +                             }
>> >> +                             if (trimmed >= len)
>> >> +                                     goto done;
>> >> +                     } else if (entry) {
>> >> +                             if (free >= minlen) {
>> >> +                                     fat_issue_discard(sb, entry, free);
>> >> +                                     trimmed += free;
>> >> +                             }
>> >> +                             if (trimmed >= len)
>> >> +                                     goto done;
>> >> +                             free = 0;
>> >> +                             entry = 0;
>> >> +                     }
>> >> +                     count++;
>> >> +             } while (fat_ent_next(sbi, &fatent));
>> >> +     }
>> >> +     if (free >= minlen) {
>> >> +             fat_issue_discard(sb, entry, free);
>> >> +             trimmed += free;
>> >> +     }
>> >> +done:
>> >> +     range->len = (trimmed * sbi->sec_per_clus) << sb->s_blocksize_bits;
>> >> +     fatent_brelse(&fatent);
>> >> +out:
>> >> +     unlock_fat(sbi);
>> >> +     return err;
>> >> +}
>> >> diff --git a/fs/fat/file.c b/fs/fat/file.c
>> >> index 7257752..05e6545 100644
>> >> --- a/fs/fat/file.c
>> >> +++ b/fs/fat/file.c
>> >> @@ -125,6 +125,34 @@ long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>> >>               return fat_ioctl_get_attributes(inode, user_attr);
>> >>       case FAT_IOCTL_SET_ATTRIBUTES:
>> >>               return fat_ioctl_set_attributes(filp, user_attr);
>> >> +     case FITRIM:
>> >> +     {
>> >> +             struct super_block *sb = inode->i_sb;
>> >> +             struct request_queue *q = bdev_get_queue(sb->s_bdev);
>> >> +             struct fstrim_range range;
>> >> +             int ret = 0;
>> >> +
>> >> +             if (!capable(CAP_SYS_ADMIN))
>> >> +                     return -EPERM;
>> >> +
>> >> +             if (!blk_queue_discard(q))
>> >> +                     return -EOPNOTSUPP;
>> >> +
>> >> +             if (copy_from_user(&range, (struct fstrim_range *)arg,
>> >> +                                     sizeof(range)))
>> >> +                     return -EFAULT;
>> >> +
>> >> +             ret = fat_trim_fs(sb, &range);
>> >> +             if (ret < 0)
>> >> +                     return ret;
>> >> +
>> >> +             if (copy_to_user((struct fstrim_range *)arg, &range,
>> >> +                                     sizeof(range)))
>> >> +                     return -EFAULT;
>> >> +
>> >> +             return 0;
>> >> +     }
>> >> +
>> >>       default:
>> >>               return -ENOTTY; /* Inappropriate ioctl for device */
>> >>       }
>> >>
>> >
>> > --
>> >
>>
>
> --
