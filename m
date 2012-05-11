Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab2EKOZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:25:12 -0400
Received: from mail.grid-net.com ([97.65.115.2]:15755 "EHLO mail.grid-net.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab2EKOZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:25:10 -0400
Message-ID: <4FAD2144.2000902@grid-net.com>
Date: Fri, 11 May 2012 07:25:08 -0700
From: Subodh Nijsure <snijsure@grid-net.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: <linux-mtd@lists.infradead.org>, <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] Add security.* XATTR support for the UBIFS
References: <1336691842-32281-1-git-send-email-snijsure@grid-net.com> <201205112101.AGA05306.JOOFFSHOQMLFtV@I-love.SAKURA.ne.jp>
In-Reply-To: <201205112101.AGA05306.JOOFFSHOQMLFtV@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.0.242]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 05:01 AM, Tetsuo Handa wrote:
> Subodh Nijsure wrote:
>> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
>> index ad6e550..cec3ffab 100644
>> --- a/fs/ubifs/dir.c
>> +++ b/fs/ubifs/dir.c
>> @@ -292,6 +292,14 @@ static int ubifs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>>
> According to 3.4-rc6,
>
> 	mutex_unlock() is here.
>
>>   	ubifs_release_budget(c,&req);
>>   	insert_inode_hash(inode);
>> +
>> +	err = ubifs_init_security(dir, inode,&dentry->d_name);
>> +	if (err) {
>> +		ubifs_err("cannot initialize extended attribute, error %d",
>> +			  err);
>> +		goto out_cancel;
>> +	}
>> +
>>   	d_instantiate(dentry, inode);
>>   	return 0;
> out_cancel:
> 	mutex_unlock() is also here...
>
> Same for the rest.
I will double check, my tree is based off linux-rc2, may be I messed up 
things.
>> diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
>> index 85b2722..49c426a 100644
>> --- a/fs/ubifs/xattr.c
>> +++ b/fs/ubifs/xattr.c
>> @@ -568,3 +600,91 @@ out_free:
>>   	kfree(xent);
>>   	return err;
>>   }
>> +
>> +size_t
>> +ubifs_security_listxattr(struct dentry *d, char *list, size_t list_size,
>> +			 const char *name, size_t name_len, int flags)
>> +{
>> +	const int prefix_len = XATTR_SECURITY_PREFIX_LEN;
>> +	const size_t total_len = prefix_len + name_len + 1;
>> +	if (list&&  total_len<= list_size) {
>> +		memcpy(list, XATTR_SECURITY_PREFIX, prefix_len);
>> +		memcpy(list+prefix_len, name, name_len);
>> +		list[prefix_len + name_len] = '\0';
>> +	}
> If (list&&  total_len>  list_size), the caller will see total_len
> but no data is copied to list. Is it OK?
the above condition you referred to implies that caller passed in buffer 
that was too short, in that case we don't need to copy the data. Typical 
usage would be caller call listxattr with null and list size of zero, we 
return size of the buffer etc.

man listxattr
ssize_t listxattr (const char *path, char *list, size_t size);

        An empty buffer of size zero can be passed into these calls to 
return the current size of the list  of  extende attribute names, which 
can be used to estimate the size of a buffer which is sufficiently large 
to hold the list of names.

so the above code should be okay?
>> +	return total_len;
>> +}
>> +static int ubifs_initxattrs(struct inode *inode,
>> +			    const struct xattr *xattr_array, void *fs_info)
>> +{
>> +	const struct xattr *xattr;
>> +	char *name;
>> +	int err = 0;
>> +
>> +	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
>> +		name = kmalloc(XATTR_SECURITY_PREFIX_LEN +
>> +			       strlen(xattr->name) + 1, GFP_NOFS);
> Maybe nice to have kstrdup2(const char *str1, const char *str2, gfp_t flags).
  I will modify that.
>> +		if (!name) {
>> +			err = -ENOMEM;
>> +			break;
>> +		}
>> +		strcpy(name, XATTR_SECURITY_PREFIX);
>> +		strcpy(name + XATTR_SECURITY_PREFIX_LEN, xattr->name);
>> +		err = __ubifs_setxattr(inode, name, xattr->value,
>> +				       xattr->value_len, 0);
>> +		kfree(name);
>> +		if (err<  0)
>> +			break;
>> +	}
>> +	return err;
>> +}
-Subodh
