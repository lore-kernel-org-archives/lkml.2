Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab2GIGnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:43:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45162 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab2GIGnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <87sjd2766n.fsf@devron.myhome.or.jp>
References: <1341716859-6768-1-git-send-email-linkinjeon@gmail.com>
	<87sjd2766n.fsf@devron.myhome.or.jp>
Date: Mon, 9 Jul 2012 15:43:04 +0900
Message-ID: <CAKYAXd9mDfDpUj1T1NrY2LUKfwvk94CTXUh5xrEGq8b_rW41rA@mail.gmail.com>
Subject: Re: [PATCH] fat: Support fallocate on fat.
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Ogawa.
2012/7/8, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +/*
>> + * preallocate space for a file. This implements fat's fallocate file
>> + * operation, which gets called from sys_fallocate system call. User
>> + * space requests len bytes at offset.If FALLOC_FL_KEEP_SIZE is set
>> + * we just allocate clusters without zeroing them out.Otherwise we
>> + * allocate and zero out clusters via an expanding truncate.
>> + */
>> +static long fat_fallocate(struct file *file, int mode,
>> +		loff_t offset, loff_t len)
>> +{
>> +	int err = 0;
>> +	struct inode *inode = file->f_mapping->host;
>> +	int cluster, nr_cluster, fclus, dclus, free_bytes, nr_bytes;
>> +	struct super_block *sb = inode->i_sb;
>> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>
> What happens if called for directory? And does this guarantee it never
> expose the uninitialized data userland?
It cannot be called for directory because in do_fallocate (which calls
fat_fallocate), there is check to open the file in write mode.
If it is opened in read only mode, it returns bad file descriptor:
---------------------------------------------------------------------------------------------------------------------
do_fallocate()
{
        ...
        ..
        if (!(file->f_mode & FMODE_WRITE))
                return -EBADF;
         ....
         ..
-----------------------------------------------------------------------------------------------------------------
We cannot open a directory in write mode. So fallocate can never be
called for a directory.
As long as user appends data to file (instead of seeking to an offset
greater than inode->i_size and writing to it), it can guarantee.
But if user use random offset, it can not..
>
>> +	/* No support for hole punch or other fallocate flags. */
>> +	if (mode & ~FALLOC_FL_KEEP_SIZE)
>> +		return -EOPNOTSUPP;
>>
>> +	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
>> +		fat_msg(sb, KERN_ERR,
>> +				"fat_fallocate():Blocks already allocated");
>> +		return -EINVAL;
>> +	}
>
> Please don't output any message by user error. And EINVAL is right
> behavior if (offset + len) < allocated size? Sounds like strange design.
Okay, I will remove message.
and I will change return sucess instead of EINVAL.
>
>> +	if ((mode & FALLOC_FL_KEEP_SIZE)) {
>> +		/* First compute the number of clusters to be allocated */
>> +		if (inode->i_size > 0) {
>> +			err = fat_get_cluster(inode, FAT_ENT_EOF,
>> +					&fclus, &dclus);
>> +			if (err < 0) {
>> +				fat_msg(sb, KERN_ERR,
>> +						"fat_fallocate():fat_get_cluster() error");
>
> Use "%s" and __func__. And looks like the error is normal
> (e.g. ENOSPC), so I don't see why it needs to report.
okay, I will remove it.
>
> [...]
>
>> +	/*
>> +	 * calculate i_blocks and mmu_private from the actual number of
>> +	 * allocated clusters instead of doing it from file size.This ensures
>> +	 * that the preallocated disk space using FALLOC_FL_KEEP_SIZE is
>> +	 * persistent across remounts and writes go into the allocated
>> clusters.
>> +	 */
>> +	fat_calc_dir_size(inode);
>
> Looks like the wrong. If you didn't initialize preallocated space, the
> data never be exposed to userland. It is security bug.
As explained above, if we do append write instead of seeking into a
random offset, there is no security risk. The main disadvantage with
initializing the
preallocated space (as is done in case of without FALLOC_FL_KEEP_SIZE
) is it takes long time for bigger allocation sizes. It took ~70
seconds to preallocate 2GB on our target if FALLOC_FL_KEEP_SIZE  is
not set.

Thanks.
>
>>  	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
>>  			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
>> +	MSDOS_I(inode)->mmu_private = inode->i_size;
>> +	/* restore i_size */
>> +	inode->i_size = le32_to_cpu(de->size);
>>
>>  	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
>>  	if (sbi->options.isvfat) {
>
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
