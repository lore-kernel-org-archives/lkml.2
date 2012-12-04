Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab2LDGX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 01:23:29 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47031 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2LDGX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 01:23:28 -0500
MIME-Version: 1.0
In-Reply-To: <87hao35uqz.fsf@devron.myhome.or.jp>
References: <1353504277-5947-1-git-send-email-linkinjeon@gmail.com>
	<87hao35uqz.fsf@devron.myhome.or.jp>
Date: Tue, 4 Dec 2012 15:23:27 +0900
Message-ID: <CAKYAXd_X8Jkq=PdV+dVPTO_EAPHoZ37MynpjvkrPTDahWyUOTA@mail.gmail.com>
Subject: Re: [PATCH v5 5/8] fat: restructure export_operations
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/3, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +	if (MSDOS_SB(inode->i_sb)->options.nfs == FAT_NFS_NOSTALE_RO) {
>> +		/* Use i_pos for ino. This is used as fileid of nfs. */
>> +		stat->ino = fat_i_pos_read(MSDOS_SB(inode->i_sb), inode);
>
> BTW, what number is used for root dir? If it is 0 (0 is special ino in
> glibc), we have to use MSDOS_ROOT_INO instead.
we have used default root ino number which is MSDOS_ROOT_INO.
>
>> +#define FAT_FID_SIZE_WITHOUT_PARENT (offsetof(struct fat_fid, \
>> +					      parent_i_pos_hi)/4)
>
> (offset parent_i_pos_hi) / 4 == 2. Wrong.
 Yes, this needs correction. Since, at all the places the condition
was for ‘fh_len < 2’ so this error condition was never caught.
>
>> +#define FAT_FID_SIZE_WITH_PARENT (sizeof(struct fat_fid)/4)
>
> 4 should be sizeof(u32). Or simplely use immediate value.
Okay.
>
>> +static int
>> +fat_encode_fh_nostale(struct inode *inode, __u32 *fh, int *lenp,
>> +		      struct inode *parent)
>> +{
>> +	int len = *lenp;
>> +	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
>> +	struct fat_fid *fid = (struct fat_fid *) fh;
>> +	loff_t i_pos;
>> +	int type = FILEID_FAT_WITHOUT_PARENT;
>> +
>> +	if (parent && (len < FAT_FID_SIZE_WITH_PARENT)) {
>> +		*lenp = FAT_FID_SIZE_WITH_PARENT;
>> +		return 255;
>
> 255 is now FILEID_INVALID, I think.
Yes, right.
>
>> +	} else if (len < FAT_FID_SIZE_WITHOUT_PARENT) {
>> +		*lenp = FAT_FID_SIZE_WITHOUT_PARENT;
>> +		return 255;
>> +	}
>> +
>> +	i_pos = fat_i_pos_read(sbi, inode);
>> +	*lenp = FAT_FID_SIZE_WITHOUT_PARENT;
>> +	fid->i_gen = inode->i_generation;
>> +	fid->i_pos_low = i_pos & 0xFFFFFFFF;
>> +	fid->i_pos_hi = (i_pos >> 32) & 0xFFFF;
>> +	if (parent) {
>> +		i_pos = fat_i_pos_read(sbi, parent);
>> +		fid->parent_i_pos_hi = (i_pos >> 32) & 0xFFFF;
>> +		fid->parent_i_pos_low = i_pos & 0xFFFFFFFF;
>> +		fid->parent_i_gen = parent->i_generation;
>> +		type = FILEID_FAT_WITH_PARENT;
>> +		*lenp = FAT_FID_SIZE_WITH_PARENT;
>> +	}
>> +
>> +	return type;
>> +}
>> +
>>  /**
>>   * Map a NFS file handle to a corresponding dentry.
>>   * The dentry may or may not be connected to the filesystem root.
>>   */
>> -struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fid,
>> +static struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid
>> *fid,
>>  				int fh_len, int fh_type)
>>  {
>>  	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
>>  				    fat_nfs_get_inode);
>>  }
>>
>> +static struct dentry *fat_fh_to_dentry_nostale(struct super_block *sb,
>> +					       struct fid *fh, int fh_len,
>> +					       int fh_type)
>> +{
>> +	struct inode *inode = NULL;
>> +	struct fat_fid *fid = (struct fat_fid *)fh;
>> +	loff_t i_pos;
>> +
>> +	switch (fh_type) {
>> +	case FILEID_FAT_WITHOUT_PARENT:
>> +		if (fh_len < FAT_FID_SIZE_WITHOUT_PARENT)
>> +			return NULL;
>> +	case FILEID_FAT_WITH_PARENT:
>> +		if ((fh_len < FAT_FID_SIZE_WITH_PARENT) &&
>> +			(fh_type == FILEID_FAT_WITH_PARENT))
>> +			return NULL;
>
> Do we have to care (FILEID_FAT_WITH_PARENT and fh_len < 5) here?
>
> 	if (fh_len < 2)
> 		return NULL;
>
> 	switch (fh_type) {
> 	case FILEID_INO32_GEN:
> 	case FILEID_INO32_GEN_PARENT:
> 		inode = get_inode(sb, fid->i32.ino, fid->i32.gen);
> 		break;
> 	}
>
> 	return d_obtain_alias(inode);
>
> generic_fh_to_dentry() is above. I wonder why we have to care
> fat_fid->parent* here.
Let me think, if ‘subtree’ checking is enabled then we should check
the length condition over here also? Please share if there are any
other comments also.

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
