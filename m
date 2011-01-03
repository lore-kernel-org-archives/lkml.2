Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab1ACF6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 00:58:35 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:48107 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1ACF6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 00:58:34 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=c/XFevczzUoebyvqT+jDkQbuJdAAxuTGoZVbuGUMSf4= c=1 sm=1
 a=nokSTlOSMgUA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=VwQbUJbxAAAA:8 a=jxIhvcvVB5oj1joUCb0A:9
 a=rDuf3DyPhVDFiBDrBdMA:7 a=zonU7EBjTdA8APVq8rPuJ7hDJ2wA:4 a=CjuIK1q_8ugA:10
 a=x8gzFH9gYPwA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
References: <1285332494-12756-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1285332494-12756-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100924115423.530813c3@tlielax.poochiereds.net> <201009271514.00279.agruen@suse.de> <20110102232101.GB11955@thunk.org> <B0449E28-B18A-4009-B6CA-8AEED22F4CD7@dilger.ca>
In-Reply-To: <B0449E28-B18A-4009-B6CA-8AEED22F4CD7@dilger.ca>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <181ED6EE-0B9F-4090-A911-B6053FF28BAC@dilger.ca>
Cc: "Ted Ts'o" <tytso@mit.edu>, Andreas Gruenbacher <agruen@suse.de>,
        Jeff Layton <jlayton@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "sfrench@us.ibm.com" <sfrench@us.ibm.com>,
        "ffilz@us.ibm.com" <ffilz@us.ibm.com>,
        "sandeen@redhat.com" <sandeen@redhat.com>,
        "bfields@citi.umich.edu" <bfields@citi.umich.edu>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "nfsv4@linux-nfs.org" <nfsv4@linux-nfs.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (8C148a)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH -V4 08/11] vfs: Add new file and directory create permission flags
Date: Sun, 2 Jan 2011 22:59:00 -0700
To: Andreas Dilger <adilger@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Never mind, I didn't notice this was only for hard linking directories...

Cheers, Andreas

On 2011-01-02, at 22:20, Andreas Dilger <adilger@dilger.ca> wrote:

> Actually, I think it is required by POSIX that EXDEV is returned when cross-linking files. For mv calling rename() at least it uses a return EXDEV to copy the file to the target filesystem instead of just giving up and returning an error. It may be other applications like tar have a similar dependency for link(). 
> 
> Cheers, Andreas
> 
> On 2011-01-02, at 16:21, Ted Ts'o <tytso@mit.edu> wrote:
> 
>> I was going through some old patches in the ext4 patchwork list, and
>> came across this.  It looks like this patch has never been applied to
>> mainline.  If it's a "clear improvement", any reason not to submit it?
>> 
>> Regards,
>> 
>>                                        - Ted
>> 
>> On Mon, Sep 27, 2010 at 03:14:00PM +0200, Andreas Gruenbacher wrote:
>>> 
>>> Ah, you mean this:
>>> 
>>> --- a/fs/namei.c
>>> +++ b/fs/namei.c
>>> @@ -2450,7 +2450,9 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
>>>   if (!inode)
>>>       return -ENOENT;
>>> 
>>> -    error = may_create(dir, new_dentry, S_ISDIR(inode->i_mode));
>>> +    if (S_ISDIR(inode->i_mode))
>>> +        return -EPERM;
>>> +    error = may_create(dir, new_dentry, 0);
>>>   if (error)
>>>       return error;
>>> 
>>> @@ -2464,8 +2466,6 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
>>>       return -EPERM;
>>>   if (!dir->i_op->link)
>>>       return -EPERM;
>>> -    if (S_ISDIR(inode->i_mode))
>>> -        return -EPERM;
>>> 
>>>   error = security_inode_link(old_dentry, dir, new_dentry);
>>>   if (error)
>>> 
>>> This is a clear improvement; I don't think it matters that user-space will
>>> get -EPERM instead of -EXDEV when trying to hard-link a directory across
>>> devices.
>>> 
>>> Thanks,
>>> Andreas
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
