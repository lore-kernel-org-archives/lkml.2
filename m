Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab1BQLQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 06:16:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab1BQLQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 06:16:23 -0500
Date: Thu, 17 Feb 2011 12:16:12 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Kyungmin Park <kmpark@infradead.org>
cc: Lukas Czerner <lczerner@redhat.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fat: Batched discard support for fat
In-Reply-To: <AANLkTim=NEmcdQtAs1vfL5We4bqyexPWyvkHJjh5CN6F@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1102171205570.14479@dhcp-27-109.brq.redhat.com>
References: <20110217052220.GA1372@july> <alpine.LFD.2.00.1102171116210.9277@dhcp-27-109.brq.redhat.com> <AANLkTim=NEmcdQtAs1vfL5We4bqyexPWyvkHJjh5CN6F@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="571140353-356662392-1297941375=:14479"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571140353-356662392-1297941375=:14479
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 17 Feb 2011, Kyungmin Park wrote:

> On Thu, Feb 17, 2011 at 7:48 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> > On Thu, 17 Feb 2011, Kyungmin Park wrote:
> >
> >> From: Kyungmin Park <kyungmin.park@samsung.com>
> >>
> >> FAT supports batched discard as ext4.
> >>
> >> Cited from Lukas words.
> >> "The current solution is not ideal because of its bad performance impact.
> >> So basic idea to improve things is to avoid discarding every time some
> >> blocks are freed. and instead batching is together into bigger trims,
> >> which tends to be more effective."
> >>
> >> You can find an information in detail at following URLs.
> >> http://lwn.net/Articles/397538/
> >> http://lwn.net/Articles/383933/
> >
> > Hi Kyungmin,
> >
> > this is really great to see more and more filesystemS ADDING this. I can
> > not really comment on fat specific code, but anyway I have couple of
> > comments bellow.
> >
> > Thanks!
> > -Lukas
> >
> >>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> >> index f504089..08b53e1 100644
> >> --- a/fs/fat/fat.h
> >> +++ b/fs/fat/fat.h
> >> @@ -299,6 +299,7 @@ extern int fat_alloc_clusters(struct inode *inode, int *cluster,
> >>                             int nr_cluster);
> >>  extern int fat_free_clusters(struct inode *inode, int cluster);
> >>  extern int fat_count_free_clusters(struct super_block *sb);
> >> +extern int fat_trim_fs(struct super_block *sb, struct fstrim_range *range);
> >>
> >>  /* fat/file.c */
> >>  extern long fat_generic_ioctl(struct file *filp, unsigned int cmd,
> >> diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
> >> index b47d2c9..777094b 100644
> >> --- a/fs/fat/fatent.c
> >> +++ b/fs/fat/fatent.c
> >> @@ -1,6 +1,8 @@
> >>  /*
> >>   * Copyright (C) 2004, OGAWA Hirofumi
> >>   * Released under GPL v2.
> >> + *
> >> + * Batched discard support by Kyungmin Park <kyungmin.park@samsung.com>
> >>   */
> >>
> >>  #include <linux/module.h>
> >> @@ -541,6 +543,16 @@ out:
> >>       return err;
> >>  }
> >>
> >> +static int fat_issue_discard(struct super_block *sb, int cluster, int nr_clus)
> >> +{
> >> +     struct msdos_sb_info *sbi = MSDOS_SB(sb);
> >> +     sector_t block, nr_blocks;
> >> +
> >> +        block = fat_clus_to_blknr(sbi, cluster);
> >> +        nr_blocks = nr_clus * sbi->sec_per_clus;
> >> +        return sb_issue_discard(sb, block, nr_blocks, GFP_NOFS, 0);
> >
> > Use tabs for code indent.
> >
> >> +}
> >> +
> >>  int fat_free_clusters(struct inode *inode, int cluster)
> >>  {
> >>       struct super_block *sb = inode->i_sb;
> >> @@ -575,11 +587,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
> >>                       if (cluster != fatent.entry + 1) {
> >>                               int nr_clus = fatent.entry - first_cl + 1;
> >>
> >> -                             sb_issue_discard(sb,
> >> -                                     fat_clus_to_blknr(sbi, first_cl),
> >> -                                     nr_clus * sbi->sec_per_clus,
> >> -                                     GFP_NOFS, 0);
> >> -
> >> +                             fat_issue_discard(sb, first_cl, nr_clus);
> >>                               first_cl = cluster;
> >>                       }
> >>               }
> >> @@ -683,3 +691,73 @@ out:
> >>       unlock_fat(sbi);
> >>       return err;
> >>  }
> >> +
> >> +int fat_trim_fs(struct super_block *sb, struct fstrim_range *range)
> >> +{
> >> +     struct msdos_sb_info *sbi = MSDOS_SB(sb);
> >> +     struct fatent_operations *ops = sbi->fatent_ops;
> >> +     struct fat_entry fatent;
> >> +     unsigned long reada_blocks, reada_mask, cur_block;
> >> +     int err = 0, free;
> >> +     unsigned int start, len, minlen, trimmed;
> >> +     int entry = 0;
> >> +
> >> +     start = range->start >> sb->s_blocksize_bits;
> >
> > Start is not used anywhere either. Let me just explain the reason for
> > having start, and len.
> >
> > start - address the first Byte of the filesystem (or better, the device,
> >  or part of the device underneath the filesystem itself). You are
> >  supposed to use this as a starting point for doing discard.
> >
> > len - defines the length in Bytes of the filesystem (or better, the
> >  device, or part of the device underneath the filesystem itself), user
> >  want to discard from the "start".
> 
> Good explanation. yes I know it's not used at current patch but it's
> added for ext4 does.
> If anyone complaint it, I can remove it for this time.

Well, I think you misunderstood the reason behind having one ioctl for
all the filesystems. The reason is, that the behavior is the same! for
all the filesystems which implements it, so the user can use one interface
an can rely on the fact that it will do the same thing! So simply
removing start and len is not really a solution!

It just has to be done the way it accepts "start" and "len" and use it
as it is suppose to.

> 
> >
> > This two values gives us more flexibility in the way we are discarding
> > the filesystem's free blocks. For example, if you have huge filesystem,
> > or your device has bad discard performance, you probably do not want to
> > do the FITRIM all-at-once, but rather per-partes, to not disturb other
> > ongoing IO too much. Basically it allows you to spread the load through
> > longer period of time.
> >
> > Also, for bigger filesystems we might want to inform user that something
> > is really happening in the form of progress bar (or whatever), which you
> > can not do otherwise.
> >
> >> +     len = range->len >> sb->s_blocksize_bits;
> >
> > "len" does not seem to be used anywhere, does it mean that you are
> > discarding free extents on the whole filesystem with one run ? This
> > operation can take pretty long time on devices with slow discard
> > capability. Can you consider doing it per-partes as we are doing in
> > ext4 for example ? I really can't say how much work does it mean in
> > fat, but it might be worth it. Especially because of ... ->
> >
> >> +     minlen = range->minlen >> sb->s_blocksize_bits;
> >> +     trimmed = 0;
> >> +
> >> +     minlen = minlen / sbi->sec_per_clus;
> >> +
> >> +     lock_fat(sbi);
> >        ^^^^^^^^^^^^^^
> >        -> this
> > You are holding this mutex the whole time you are discarding free
> > extents and I think it would be devastating, because the users will see
> > long stalls. The bigger the filesystem is and the worse discard
> > performance of the device is, the longer stall will be. Please correct
> > me I am mistaken. Have you done any testing ?
> Now I assume it's not perform during fat operation at normal case.
> It's performed at specific time instead of parallel IO as ext4 does.
> e.g., it's performed after disconnected from windows and so on.
> another reason is can't guarantee the fat table entry consistency
> during trim, I just lock the fat at start time as count the free space
> at fat codes.

Ok, if there is no way around the mutex I am ok with that. However, you
really need to implement the per-partes approach FITRIM interface forces
you to.

By the way, you can not just rely on users not using the filesystem
while FITRIM is going on, because they just will not care, especially if
FITRIM will be invoked periodically form cron (for example).

> >
> >> +     if (sbi->free_clusters != -1 && sbi->free_clus_valid)
> >> +             goto out;
> >> +
> >> +     reada_blocks = FAT_READA_SIZE >> sb->s_blocksize_bits;
> >> +     reada_mask = reada_blocks - 1;
> >> +     cur_block = 0;
> >> +
> >> +     free = 0;
> >> +     fatent_init(&fatent);
> >> +
> >> +     /*
> >> +      * REVISIT: scan from the last free block.
> >> +      */
> >> +     fatent_set_entry(&fatent, FAT_START_ENT);
> >> +     while (fatent.entry < sbi->max_cluster) {
> >> +             /* readahead of fat blocks */
> >> +             if ((cur_block & reada_mask) == 0) {
> >> +                     unsigned long rest = sbi->fat_length - cur_block;
> >> +                     fat_ent_reada(sb, &fatent, min(reada_blocks, rest));
> >> +             }
> >> +             cur_block++;
> >> +
> >> +             err = fat_ent_read_block(sb, &fatent);
> >> +             if (err)
> >> +                     goto out;
> >> +
> >> +             do {
> >> +                     if (ops->ent_get(&fatent) == FAT_ENT_FREE) {
> >> +                             free++;
> >> +                             if (!entry)
> >> +                                     entry = fatent.entry;
> >> +                     } else if (entry) {
> >> +                             if (free >= minlen) {
> >> +                                     fat_issue_discard(sb, entry, free);
> >> +                                     trimmed += free;
> >> +                             }
> >> +                             free = 0;
> >> +                             entry = 0;
> >> +                     }
> >> +             } while (fat_ent_next(sbi, &fatent));
> >> +     }
> >> +     if (free >= minlen) {
> >> +             fat_issue_discard(sb, entry, free);
> >> +             trimmed += free;
> >> +     }
> >> +     range->len = (trimmed * sbi->sec_per_clus) * sb->s_blocksize;
> >> +     fatent_brelse(&fatent);
> >> +out:
> >> +     unlock_fat(sbi);
> >> +     return err;
> >> +}
> >> diff --git a/fs/fat/file.c b/fs/fat/file.c
> >> index 7257752..bfdd558 100644
> >> --- a/fs/fat/file.c
> >> +++ b/fs/fat/file.c
> >> @@ -125,6 +125,30 @@ long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> >>               return fat_ioctl_get_attributes(inode, user_attr);
> >>       case FAT_IOCTL_SET_ATTRIBUTES:
> >>               return fat_ioctl_set_attributes(filp, user_attr);
> >> +     case FITRIM:
> >> +     {
> >> +             struct super_block *sb = inode->i_sb;
> >> +             struct fstrim_range range;
> >> +             int ret = 0;
> >> +
> >> +             if (!capable(CAP_SYS_ADMIN))
> >> +                     return -EPERM;
> >
> > You might want to add check whether the device actually support discard.
> > See: http://www.spinics.net/lists/linux-ext4/msg23144.html
> 
> Good. I didn't see the patch, next version I'll add it.
> 
> Thank you,
> Kyungmin Park
> >
> >> +
> >> +             if (copy_from_user(&range, (struct fstrim_range *)arg,
> >> +                                     sizeof(range)))
> >> +                     return -EFAULT;
> >> +
> >> +             ret = fat_trim_fs(sb, &range);
> >> +             if (ret < 0)
> >> +                     return ret;
> >> +
> >> +             if (copy_to_user((struct fstrim_range *)arg, &range,
> >> +                                     sizeof(range)))
> >> +                     return -EFAULT;
> >> +
> >> +             return 0;
> >> +     }
> >> +
> >>       default:
> >>               return -ENOTTY; /* Inappropriate ioctl for device */
> >>       }
> >>
> >
> > --
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
--571140353-356662392-1297941375=:14479--
