Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0FTWJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 18:09:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47413 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab0FTWJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 18:09:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cuHN21haVKqdNstsVNQnawQ4zPwxIXyLgJp8wtdBCQchTJj+OW2fnK3PCFbOp0ZnpU
         IQQOFvN7BsvVmJbSpIHEzq96rG53K1HvuK88ibv7+rXN0cEaDqlDfqVMFtdaf211u7jO
         NJho7hfS/AIqVbGowGokvAS1DbDNjMPY5HXT4=
Message-ID: <4C1E9194.7020904@gmail.com>
Date: Sun, 20 Jun 2010 15:09:24 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeff Layton <jlayton@samba.org>
CC: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6 v2]cifs Fix warnings variables set but not used
References: <1276980427-24728-1-git-send-email-justinmattock@gmail.com> <20100620171713.782e9104@tlielax.poochiereds.net>
In-Reply-To: <20100620171713.782e9104@tlielax.poochiereds.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2010 02:17 PM, Jeff Layton wrote:
> On Sat, 19 Jun 2010 13:47:07 -0700
> "Justin P. Mattock"<justinmattock@gmail.com>  wrote:
>
>> This is a resend of the original, to fix whitespace issues
>> and to maybe do a better job with the issue.
>>
>> The patch below fixes the warning messages from
>> gcc 4.6.0 and compiling the kernel.
>>    CC [M]  fs/cifs/cifssmb.o
>> fs/cifs/cifssmb.c: In function 'CIFSSMBSetFileSize':
>> fs/cifs/cifssmb.c:4855:8: warning: variable 'data_offset' set but not used
>>    CC [M]  fs/cifs/cifs_debug.o
>>
>>    CC [M]  fs/cifs/dir.o
>> fs/cifs/dir.c: In function 'cifs_lookup':
>> fs/cifs/dir.c:641:15: warning: variable 'filp' set but not used
>>
>>    CC [M]  fs/cifs/file.o
>> fs/cifs/file.c: In function 'cifs_partialpagewrite':
>> fs/cifs/file.c:1315:23: warning: variable 'pTcon' set but not used
>>
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   fs/cifs/cifssmb.c |    2 +-
>>   fs/cifs/dir.c     |    3 +--
>>   fs/cifs/file.c    |    2 +-
>>   3 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index c65c341..197349c 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -4852,7 +4852,7 @@ CIFSSMBSetFileSize(const int xid, struct cifsTconInfo *tcon, __u64 size,
>>   		   __u16 fid, __u32 pid_of_opener, bool SetAllocation)
>>   {
>>   	struct smb_com_transaction2_sfi_req *pSMB  = NULL;
>> -	char *data_offset;
>> +	char *data_offset __attribute__((unused));
>
> It would be better to just remove this variable and the place where it
> gets set.
>

I'll resend an update patch for cifssmb.c and file.c and just wait until 
dir.c get's updated with the new stuff..

>>   	struct file_end_of_file_info *parm_data;
>>   	int rc = 0;
>>   	__u16 params, param_offset, offset, byte_count, count;
>> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> index 391816b..b3d1be2 100644
>> --- a/fs/cifs/dir.c
>> +++ b/fs/cifs/dir.c
>> @@ -638,7 +638,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>>   	struct cifsTconInfo *pTcon;
>>   	struct inode *newInode = NULL;
>>   	char *full_path = NULL;
>> -	struct file *filp;
>>
>>   	xid = GetXid();
>>
>> @@ -734,7 +733,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>>   			direntry->d_op =&cifs_dentry_ops;
>>   		d_add(direntry, newInode);
>>   		if (posix_open)
>> -			filp = lookup_instantiate_filp(nd, direntry, NULL);
>> +			lookup_instantiate_filp(nd, direntry, NULL);
>
> This part of the patch will conflict with some changes that are coming
> to this area. With those, "filp" will actually be used. You may want to
> wait until Linus pulls the latest fixes from Steve F's tree (or just
> base your patch on Steve's tree in the first place).
>

I'll just wait then..

>
>>   		/* since paths are not looked up by component - the parent
>>   		   directories are presumed to be good here */
>>   		renew_parental_timestamps(direntry);
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 75541af..73e540b 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1312,7 +1312,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
>>   	int rc = -EFAULT;
>>   	int bytes_written = 0;
>>   	struct cifs_sb_info *cifs_sb;
>> -	struct cifsTconInfo *pTcon;
>> +	struct cifsTconInfo *pTcon __attribute__((unused));
>
> This variable can just be removed (along with the spot where it gets
> set later).
>
>>   	struct inode *inode;
>>   	struct cifsFileInfo *open_file;
>>
>
>

cheers,

Justin P. Mattock
