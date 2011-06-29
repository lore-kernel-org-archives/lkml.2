Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab1F2Rlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:41:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab1F2Rll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:41:41 -0400
Message-ID: <4E0B63B5.5070404@redhat.com>
Date: Wed, 29 Jun 2011 13:41:09 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
References: <1309275310-10987-1-git-send-email-josef@redhat.com> <20110629163825.GE17590@quack.suse.cz>
In-Reply-To: <20110629163825.GE17590@quack.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 12:38 PM, Jan Kara wrote:
> On Tue 28-06-11 11:35:10, Josef Bacik wrote:
>> Btrfs needs to be able to control how filemap_write_and_wait_range() is called
>> in fsync to make it less of a painful operation, so push down taking i_mutex and
>> the calling of filemap_write_and_wait() down into the ->fsync() handlers.  Some
>> file systems can drop taking the i_mutex altogether it seems, like ext3 and
>> ocfs2.  For correctness sake I just pushed everything down in all cases to make
>> sure that we keep the current behavior the same for everybody, and then each
>> individual fs maintainer can make up their mind about what to do from there.
>> Thanks,
>>
>> Signed-off-by: Josef Bacik <josef@redhat.com>
> ...
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 1921392..fa44df8 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1758,7 +1758,7 @@ extern int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
>>  extern void ext4_htree_free_dir_info(struct dir_private_info *p);
>>  
>>  /* fsync.c */
>> -extern int ext4_sync_file(struct file *, int);
>> +extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
>>  extern int ext4_flush_completed_IO(struct inode *);
>>  
>>  /* hash.c */
>> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
>> index ce66d2f..afab2e4 100644
>> --- a/fs/ext4/fsync.c
>> +++ b/fs/ext4/fsync.c
>> @@ -165,7 +165,7 @@ static int ext4_sync_parent(struct inode *inode)
>>   * i_mutex lock is held when entering and exiting this function
>>   */
>>  
>> -int ext4_sync_file(struct file *file, int datasync)
>> +int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>>  {
>>  	struct inode *inode = file->f_mapping->host;
>>  	struct ext4_inode_info *ei = EXT4_I(inode);
>> @@ -178,15 +178,22 @@ int ext4_sync_file(struct file *file, int datasync)
>>  
>>  	trace_ext4_sync_file_enter(file, datasync);
>>  
>> +	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
>> +	if (ret)
>> +		return ret;
>> +	mutex_lock(&inode->i_mutex);
>> +
>>  	if (inode->i_sb->s_flags & MS_RDONLY)
>> -		return 0;
>> +		goto out;
>>  
>>  	ret = ext4_flush_completed_IO(inode);
>>  	if (ret < 0)
>>  		goto out;
>>  
>>  	if (!journal) {
>> -		ret = generic_file_fsync(file, datasync);
>> +		if (inode->i_state & I_DIRTY ||
>> +		    (datasync && (inode->i_state & I_DIRTY_DATASYNC)))
>> +			ret = sync_inode_metadata(inode, 1);
>   Umm, how did you get to this change? It is actually wrong - ext4 in
> nojournal mode really seems to need to call generic_file_fsync() (so that
> sync_buffers_list() is called).
> 

Ah oops sorry about that, I will fix that, I was trying to be clever and
encapsulate generic_file_fsync()'s behavior into here but I missed the
sync_mapping_buffers() call.  Thanks,

Josef
