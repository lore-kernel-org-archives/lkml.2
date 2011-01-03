Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab1ACFTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 00:19:42 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:21338 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1ACFTl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 00:19:41 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=cUTwMia+6fMZF7bjUHU44PO5dfBASsAn9IQPzcMrg/g= c=1 sm=1
 a=nokSTlOSMgUA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=VwQbUJbxAAAA:8 a=MC3XVy2y1B9GCZv2rooA:9
 a=gKtaiL8WpeEjnUOkKR4A:7 a=7bD4m929_6EHe8PMGPLdbvDofP8A:4 a=CjuIK1q_8ugA:10
 a=x8gzFH9gYPwA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1285332494-12756-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100924115423.530813c3@tlielax.poochiereds.net> <201009271514.00279.agruen@suse.de> <20110102232101.GB11955@thunk.org>
In-Reply-To: <20110102232101.GB11955@thunk.org>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <B0449E28-B18A-4009-B6CA-8AEED22F4CD7@dilger.ca>
Cc: Andreas Gruenbacher <agruen@suse.de>, Jeff Layton <jlayton@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "sfrench@us.ibm.com" <sfrench@us.ibm.com>,
        "ffilz@us.ibm.com" <ffilz@us.ibm.com>,
        "adilger@sun.com" <adilger@sun.com>,
        "sandeen@redhat.com" <sandeen@redhat.com>,
        "bfields@citi.umich.edu" <bfields@citi.umich.edu>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "nfsv4@linux-nfs.org" <nfsv4@linux-nfs.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8C148a)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH -V4 08/11] vfs: Add new file and directory create permission flags
Date: Sun, 2 Jan 2011 22:20:08 -0700
To: "Ted Ts'o" <tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, I think it is required by POSIX that EXDEV is returned when cross-linking files. For mv calling rename() at least it uses a return EXDEV to copy the file to the target filesystem instead of just giving up and returning an error. It may be other applications like tar have a similar dependency for link(). 

Cheers, Andreas

On 2011-01-02, at 16:21, Ted Ts'o <tytso@mit.edu> wrote:

> I was going through some old patches in the ext4 patchwork list, and
> came across this.  It looks like this patch has never been applied to
> mainline.  If it's a "clear improvement", any reason not to submit it?
> 
> Regards,
> 
>                                         - Ted
> 
> On Mon, Sep 27, 2010 at 03:14:00PM +0200, Andreas Gruenbacher wrote:
>> 
>> Ah, you mean this:
>> 
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -2450,7 +2450,9 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
>>    if (!inode)
>>        return -ENOENT;
>> 
>> -    error = may_create(dir, new_dentry, S_ISDIR(inode->i_mode));
>> +    if (S_ISDIR(inode->i_mode))
>> +        return -EPERM;
>> +    error = may_create(dir, new_dentry, 0);
>>    if (error)
>>        return error;
>> 
>> @@ -2464,8 +2466,6 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
>>        return -EPERM;
>>    if (!dir->i_op->link)
>>        return -EPERM;
>> -    if (S_ISDIR(inode->i_mode))
>> -        return -EPERM;
>> 
>>    error = security_inode_link(old_dentry, dir, new_dentry);
>>    if (error)
>> 
>> This is a clear improvement; I don't think it matters that user-space will
>> get -EPERM instead of -EXDEV when trying to hard-link a directory across
>> devices.
>> 
>> Thanks,
>> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
