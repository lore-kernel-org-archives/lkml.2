Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1BREVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:21:48 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58906 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab1BREVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:21:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uVlLJ3PDRIeZX5Pilnidz8JthVVBym4H2Fxxm77N8UzjVGanLkws69n1Ih8A2eCRtk
         Filg+myX+T1PiWP2I9kLlmIrX4jMxi7YN7smfdIq375/QCH1ZXOiAL8O13UEg4QwQOCi
         uBzWviYxyiOdlk0dd0/kS3EOazxBrUyLkohi8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1102171205570.14479@dhcp-27-109.brq.redhat.com>
References: <20110217052220.GA1372@july>
	<alpine.LFD.2.00.1102171116210.9277@dhcp-27-109.brq.redhat.com>
	<AANLkTim=NEmcdQtAs1vfL5We4bqyexPWyvkHJjh5CN6F@mail.gmail.com>
	<alpine.LFD.2.00.1102171205570.14479@dhcp-27-109.brq.redhat.com>
Date: Fri, 18 Feb 2011 13:21:41 +0900
X-Google-Sender-Auth: G7p3e5yHLYNQsIxEoaJ1XgoWrSU
Message-ID: <AANLkTimEZduo8J7z-QbdQ_Ca9t8cTSQ9uWfgU9PRV4KC@mail.gmail.com>
Subject: Re: [PATCH] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 8:16 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Thu, 17 Feb 2011, Kyungmin Park wrote:
>
>> On Thu, Feb 17, 2011 at 7:48 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>> > On Thu, 17 Feb 2011, Kyungmin Park wrote:
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
>> >
>> > Hi Kyungmin,
>> >
>> > this is really great to see more and more filesystemS ADDING this. I can
>> > not really comment on fat specific code, but anyway I have couple of
>> > comments bellow.
>> >
>> > Thanks!
>> > -Lukas
>> >
>> >>
>> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> >> ---
>> >> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
>> >> index f504089..08b53e1 100644
>> >> --- a/fs/fat/fat.h
>> >> +++ b/fs/fat/fat.h
>> >> @@ -299,6 +299,7 @@ extern int fat_alloc_clusters(struct inode *inode, int *cluster,
>> >> á á á á á á á á á á á á á á int nr_cluster);
>> >> áextern int fat_free_clusters(struct inode *inode, int cluster);
>> >> áextern int fat_count_free_clusters(struct super_block *sb);
>> >> +extern int fat_trim_fs(struct super_block *sb, struct fstrim_range *range);
>> >>
>> >> á/* fat/file.c */
>> >> áextern long fat_generic_ioctl(struct file *filp, unsigned int cmd,
>> >> diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
>> >> index b47d2c9..777094b 100644
>> >> --- a/fs/fat/fatent.c
>> >> +++ b/fs/fat/fatent.c
>> >> @@ -1,6 +1,8 @@
>> >> á/*
>> >> á * Copyright (C) 2004, OGAWA Hirofumi
>> >> á * Released under GPL v2.
>> >> + *
>> >> + * Batched discard support by Kyungmin Park <kyungmin.park@samsung.com>
>> >> á */
>> >>
>> >> á#include <linux/module.h>
>> >> @@ -541,6 +543,16 @@ out:
>> >> á á á return err;
>> >> á}
>> >>
>> >> +static int fat_issue_discard(struct super_block *sb, int cluster, int nr_clus)
>> >> +{
>> >> + á á struct msdos_sb_info *sbi = MSDOS_SB(sb);
>> >> + á á sector_t block, nr_blocks;
>> >> +
>> >> + á á á áblock = fat_clus_to_blknr(sbi, cluster);
>> >> + á á á ánr_blocks = nr_clus * sbi->sec_per_clus;
>> >> + á á á áreturn sb_issue_discard(sb, block, nr_blocks, GFP_NOFS, 0);
>> >
>> > Use tabs for code indent.
>> >
>> >> +}
>> >> +
>> >> áint fat_free_clusters(struct inode *inode, int cluster)
>> >> á{
>> >> á á á struct super_block *sb = inode->i_sb;
>> >> @@ -575,11 +587,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
>> >> á á á á á á á á á á á if (cluster != fatent.entry + 1) {
>> >> á á á á á á á á á á á á á á á int nr_clus = fatent.entry - first_cl + 1;
>> >>
>> >> - á á á á á á á á á á á á á á sb_issue_discard(sb,
>> >> - á á á á á á á á á á á á á á á á á á fat_clus_to_blknr(sbi, first_cl),
>> >> - á á á á á á á á á á á á á á á á á á nr_clus * sbi->sec_per_clus,
>> >> - á á á á á á á á á á á á á á á á á á GFP_NOFS, 0);
>> >> -
>> >> + á á á á á á á á á á á á á á fat_issue_discard(sb, first_cl, nr_clus);
>> >> á á á á á á á á á á á á á á á first_cl = cluster;
>> >> á á á á á á á á á á á }
>> >> á á á á á á á }
>> >> @@ -683,3 +691,73 @@ out:
>> >> á á á unlock_fat(sbi);
>> >> á á á return err;
>> >> á}
>> >> +
>> >> +int fat_trim_fs(struct super_block *sb, struct fstrim_range *range)
>> >> +{
>> >> + á á struct msdos_sb_info *sbi = MSDOS_SB(sb);
>> >> + á á struct fatent_operations *ops = sbi->fatent_ops;
>> >> + á á struct fat_entry fatent;
>> >> + á á unsigned long reada_blocks, reada_mask, cur_block;
>> >> + á á int err = 0, free;
>> >> + á á unsigned int start, len, minlen, trimmed;
>> >> + á á int entry = 0;
>> >> +
>> >> + á á start = range->start >> sb->s_blocksize_bits;
>> >
>> > Start is not used anywhere either. Let me just explain the reason for
>> > having start, and len.
>> >
>> > start - address the first Byte of the filesystem (or better, the device,
>> > áor part of the device underneath the filesystem itself). You are
>> > ásupposed to use this as a starting point for doing discard.
>> >
>> > len - defines the length in Bytes of the filesystem (or better, the
>> > ádevice, or part of the device underneath the filesystem itself), user
>> > áwant to discard from the "start".
>>
>> Good explanation. yes I know it's not used at current patch but it's
>> added for ext4 does.
>> If anyone complaint it, I can remove it for this time.
>
> Well, I think you misunderstood the reason behind having one ioctl for
> all the filesystems. The reason is, that the behavior is the same! for
> all the filesystems which implements it, so the user can use one interface
> an can rely on the fact that it will do the same thing! So simply
> removing start and len is not really a solution!
>
> It just has to be done the way it accepts "start" and "len" and use it
> as it is suppose to.

Updated. next version handles the "start" and "len" properly.

Are there any fat specific comments?

Thank you,
Kyungmin Park

>
>>
>> >
>> > This two values gives us more flexibility in the way we are discarding
>> > the filesystem's free blocks. For example, if you have huge filesystem,
>> > or your device has bad discard performance, you probably do not want to
>> > do the FITRIM all-at-once, but rather per-partes, to not disturb other
>> > ongoing IO too much. Basically it allows you to spread the load through
>> > longer period of time.
>> >
>> > Also, for bigger filesystems we might want to inform user that something
>> > is really happening in the form of progress bar (or whatever), which you
>> > can not do otherwise.
>> >
>> >> + á á len = range->len >> sb->s_blocksize_bits;
>> >
>> > "len" does not seem to be used anywhere, does it mean that you are
>> > discarding free extents on the whole filesystem with one run ? This
>> > operation can take pretty long time on devices with slow discard
>> > capability. Can you consider doing it per-partes as we are doing in
>> > ext4 for example ? I really can't say how much work does it mean in
>> > fat, but it might be worth it. Especially because of ... ->
>> >
>> >> + á á minlen = range->minlen >> sb->s_blocksize_bits;
>> >> + á á trimmed = 0;
>> >> +
>> >> + á á minlen = minlen / sbi->sec_per_clus;
>> >> +
>> >> + á á lock_fat(sbi);
>> > á á á á^^^^^^^^^^^^^^
>> > á á á á-> this
>> > You are holding this mutex the whole time you are discarding free
>> > extents and I think it would be devastating, because the users will see
>> > long stalls. The bigger the filesystem is and the worse discard
>> > performance of the device is, the longer stall will be. Please correct
>> > me I am mistaken. Have you done any testing ?
>> Now I assume it's not perform during fat operation at normal case.
>> It's performed at specific time instead of parallel IO as ext4 does.
>> e.g., it's performed after disconnected from windows and so on.
>> another reason is can't guarantee the fat table entry consistency
>> during trim, I just lock the fat at start time as count the free space
>> at fat codes.
>
> Ok, if there is no way around the mutex I am ok with that. However, you
> really need to implement the per-partes approach FITRIM interface forces
> you to.
>
> By the way, you can not just rely on users not using the filesystem
> while FITRIM is going on, because they just will not care, especially if
> FITRIM will be invoked periodically form cron (for example).
>
>> >
>> >> + á á if (sbi->free_clusters != -1 && sbi->free_clus_valid)
>> >> + á á á á á á goto out;
>> >> +
>> >> + á á reada_blocks = FAT_READA_SIZE >> sb->s_blocksize_bits;
>> >> + á á reada_mask = reada_blocks - 1;
>> >> + á á cur_block = 0;
>> >> +
>> >> + á á free = 0;
>> >> + á á fatent_init(&fatent);
>> >> +
>> >> + á á /*
>> >> + á á á* REVISIT: scan from the last free block.
>> >> + á á á*/
>> >> + á á fatent_set_entry(&fatent, FAT_START_ENT);
>> >> + á á while (fatent.entry < sbi->max_cluster) {
>> >> + á á á á á á /* readahead of fat blocks */
>> >> + á á á á á á if ((cur_block & reada_mask) == 0) {
>> >> + á á á á á á á á á á unsigned long rest = sbi->fat_length - cur_block;
>> >> + á á á á á á á á á á fat_ent_reada(sb, &fatent, min(reada_blocks, rest));
>> >> + á á á á á á }
>> >> + á á á á á á cur_block++;
>> >> +
>> >> + á á á á á á err = fat_ent_read_block(sb, &fatent);
>> >> + á á á á á á if (err)
>> >> + á á á á á á á á á á goto out;
>> >> +
>> >> + á á á á á á do {
>> >> + á á á á á á á á á á if (ops->ent_get(&fatent) == FAT_ENT_FREE) {
>> >> + á á á á á á á á á á á á á á free++;
>> >> + á á á á á á á á á á á á á á if (!entry)
>> >> + á á á á á á á á á á á á á á á á á á entry = fatent.entry;
>> >> + á á á á á á á á á á } else if (entry) {
>> >> + á á á á á á á á á á á á á á if (free >= minlen) {
>> >> + á á á á á á á á á á á á á á á á á á fat_issue_discard(sb, entry, free);
>> >> + á á á á á á á á á á á á á á á á á á trimmed += free;
>> >> + á á á á á á á á á á á á á á }
>> >> + á á á á á á á á á á á á á á free = 0;
>> >> + á á á á á á á á á á á á á á entry = 0;
>> >> + á á á á á á á á á á }
>> >> + á á á á á á } while (fat_ent_next(sbi, &fatent));
>> >> + á á }
>> >> + á á if (free >= minlen) {
>> >> + á á á á á á fat_issue_discard(sb, entry, free);
>> >> + á á á á á á trimmed += free;
>> >> + á á }
>> >> + á á range->len = (trimmed * sbi->sec_per_clus) * sb->s_blocksize;
>> >> + á á fatent_brelse(&fatent);
>> >> +out:
>> >> + á á unlock_fat(sbi);
>> >> + á á return err;
>> >> +}
>> >> diff --git a/fs/fat/file.c b/fs/fat/file.c
>> >> index 7257752..bfdd558 100644
>> >> --- a/fs/fat/file.c
>> >> +++ b/fs/fat/file.c
>> >> @@ -125,6 +125,30 @@ long fat_generic_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>> >> á á á á á á á return fat_ioctl_get_attributes(inode, user_attr);
>> >> á á á case FAT_IOCTL_SET_ATTRIBUTES:
>> >> á á á á á á á return fat_ioctl_set_attributes(filp, user_attr);
>> >> + á á case FITRIM:
>> >> + á á {
>> >> + á á á á á á struct super_block *sb = inode->i_sb;
>> >> + á á á á á á struct fstrim_range range;
>> >> + á á á á á á int ret = 0;
>> >> +
>> >> + á á á á á á if (!capable(CAP_SYS_ADMIN))
>> >> + á á á á á á á á á á return -EPERM;
>> >
>> > You might want to add check whether the device actually support discard.
>> > See: http://www.spinics.net/lists/linux-ext4/msg23144.html
>>
>> Good. I didn't see the patch, next version I'll add it.
>>
>> Thank you,
>> Kyungmin Park
>> >
>> >> +
>> >> + á á á á á á if (copy_from_user(&range, (struct fstrim_range *)arg,
>> >> + á á á á á á á á á á á á á á á á á á sizeof(range)))
>> >> + á á á á á á á á á á return -EFAULT;
>> >> +
>> >> + á á á á á á ret = fat_trim_fs(sb, &range);
>> >> + á á á á á á if (ret < 0)
>> >> + á á á á á á á á á á return ret;
>> >> +
>> >> + á á á á á á if (copy_to_user((struct fstrim_range *)arg, &range,
>> >> + á á á á á á á á á á á á á á á á á á sizeof(range)))
>> >> + á á á á á á á á á á return -EFAULT;
>> >> +
>> >> + á á á á á á return 0;
>> >> + á á }
>> >> +
>> >> á á á default:
>> >> á á á á á á á return -ENOTTY; /* Inappropriate ioctl for device */
>> >> á á á }
>> >>
>> >
>> > --
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
