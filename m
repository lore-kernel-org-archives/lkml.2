Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab2JIVqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:46:44 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:39584 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932Ab2JIVql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:46:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
References: <871uhx1n71.fsf@xmission.com>
	<1348105949-25454-1-git-send-email-ebiederm@xmission.com>
	<1348105949-25454-16-git-send-email-ebiederm@xmission.com>
	<20121009204433.GB24622@quack.suse.cz>
Date: Tue, 09 Oct 2012 14:46:28 -0700
In-Reply-To: <20121009204433.GB24622@quack.suse.cz> (Jan Kara's message of
	"Tue, 9 Oct 2012 22:44:33 +0200")
Message-ID: <878vbf5nez.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+vT3TkJOzOJRuUq1PCb8zwOTiq6sw7/bc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Jan Kara <jack@suse.cz>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 16/27] userns: Convert vfs posix_acl support to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Wed 19-09-12 18:52:18, Eric W. Biederman wrote:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> - In setxattr if we are setting a posix acl convert uids and gids from
>>   the current user namespace into the initial user namespace, before
>>   the xattrs are passed to the underlying filesystem.
>> 
>>   Untranslatable uids and gids are represented as -1 which
>>   posix_acl_from_xattr will represent as INVALID_UID or INVALID_GID.
>>   posix_acl_valid will fail if an acl from userspace has any
>>   INVALID_UID or INVALID_GID values.  In net this guarantees that
>>   untranslatable posix acls will not be stored by filesystems.
>> 
>> - In getxattr if we are reading a posix acl convert uids and gids from
>>   the initial user namespace into the current user namespace.
>> 
>>   Uids and gids that can not be tranlsated into the current user namespace
>>   will be represented as -1.
>> 
>> - Replace e_id in struct posix_acl_entry with an anymouns union of
>>   e_uid and e_gid.  For the short term retain the e_id field
>>   until all of the users are converted.
>> 
>> - Don't set struct posix_acl.e_id in the cases where the acl type
>>   does not use e_id.  Greatly reducing the use of ACL_UNDEFINED_ID.
>> 
>> - Rework the ordering checks in posix_acl_valid so that I use kuid_t
>>   and kgid_t types throughout the code, and so that I don't need
>>   arithmetic on uid and gid types.
>> 
>> Cc: Theodore Tso <tytso@mit.edu>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>   I know this got merged but I got to seriously looking into it only now
> and frankly I think the push was a hurried one...


>> diff --git a/fs/xattr.c b/fs/xattr.c
>> index 4d45b71..c111745 100644
>> --- a/fs/xattr.c
>> +++ b/fs/xattr.c
>> @@ -20,6 +20,7 @@
>>  #include <linux/fsnotify.h>
>>  #include <linux/audit.h>
>>  #include <linux/vmalloc.h>
>> +#include <linux/posix_acl_xattr.h>
>>  
>>  #include <asm/uaccess.h>
>>  
>> @@ -347,6 +348,9 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
>>  			error = -EFAULT;
>>  			goto out;
>>  		}
>> +		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
>> +		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
>> +			posix_acl_fix_xattr_from_user(kvalue, size);
>>  	}
>>  
>>  	error = vfs_setxattr(d, kname, kvalue, size, flags);
>> @@ -450,6 +454,9 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
>>  
>>  	error = vfs_getxattr(d, kname, kvalue, size);
>>  	if (error > 0) {
>> +		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
>> +		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
>> +			posix_acl_fix_xattr_to_user(kvalue, size);
>>  		if (size && copy_to_user(value, kvalue, error))
>>  			error = -EFAULT;
>>  	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
>> diff --git a/fs/xattr_acl.c b/fs/xattr_acl.c
>> index 69d06b0..bf472ca 100644
>> --- a/fs/xattr_acl.c
>> +++ b/fs/xattr_acl.c
>> @@ -9,7 +9,65 @@
>>  #include <linux/fs.h>
>>  #include <linux/posix_acl_xattr.h>
>>  #include <linux/gfp.h>
>> +#include <linux/user_namespace.h>
>>  
>> +/*
>> + * Fix up the uids and gids in posix acl extended attributes in place.
>> + */
>> +static void posix_acl_fix_xattr_userns(
>> +	struct user_namespace *to, struct user_namespace *from,
>> +	void *value, size_t size)
>> +{
>> +	posix_acl_xattr_header *header = (posix_acl_xattr_header *)value;
>> +	posix_acl_xattr_entry *entry = (posix_acl_xattr_entry *)(header+1), *end;
>> +	int count;
>> +	kuid_t uid;
>> +	kgid_t gid;
>> +
>> +	if (!value)
>> +		return;
>> +	if (size < sizeof(posix_acl_xattr_header))
>> +		return;
>> +	if (header->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
>> +		return;
>> +
>> +	count = posix_acl_xattr_count(size);
>> +	if (count < 0)
>> +		return;
>> +	if (count == 0)
>> +		return;
>> +
>> +	for (end = entry + count; entry != end; entry++) {
>> +		switch(le16_to_cpu(entry->e_tag)) {
>> +		case ACL_USER:
>> +			uid = make_kuid(from, le32_to_cpu(entry->e_id));

  
>   This should have some error checking I guess... The initial checks done
> in posix_acl_from_xattr() are for init_user_ns (why?) and only duplicated
> in posix_acl_valid().

The flow from userspace:
  posix_acl_fix_xattr_from_user
  posix_acl_from_xattr
  posix_acl_valid

The flow to userspace:
  posix_acl_to_xattr
  posix_acl_fix_xattr_to_user

The existence of the posix_acl_fix_xattr_from_user and
posix_fix_xattr_to_user ensure that filesystems only see xattrs encoded
in the initial user namespace. Which is why posix_acl_from_xattr only
takes init_user_ns as a parameter.

How filesystems handle xattrs that deal with acls is spread all across
the map.  Some filesystems do the reasonable thing and translate the
xattr from userspace into an acl and then translate the acl into their
on-disk format.  Other filesystems just stuff the acl onto the disk or
onto the fileserver without looking at it.

As for checks my interpretation was that a filesystem should already
be calling posix_acl_from_xattr and posix_acl_valid, and that
duplicating those checks in posix_acl_fix_xattr_to/from_user would
be redundnant and confusing.

What does happen is that any uid or gid that does not map gets
translated into -1, which should always fail the latter sanity
check.

>> +			entry->e_id = cpu_to_le32(from_kuid(to, uid));
>> +			break;
>> +		case ACL_GROUP:
>> +			gid = make_kgid(from, le32_to_cpu(entry->e_id));
>> +			entry->e_id = cpu_to_le32(from_kuid(to, uid));
>                                              here should be gid ^^^
Ugh.  Yes.  That is a very real bug. :(  The &init_user_ns short circuit
likely protects against regressions but I will fix this.

>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +	}
>> +}
> Also what about the following scenario:
>
> We have namespace A with user U1 and namespace B which does not have a
> valid representation for U1.

> There is a file F which can be seen from both
> namespaces. In namespace A we create acl for user U1 attached to F. Now in
> namespace B we modify the acl via setfacl(1) command. What it does is
> getxattr(2) - returns mangled acl because U1 has no representation in B. We
> add something to xattr and call setxattr(2) - results in removing the
> original acl for U1 and instead adding acl for uid -1. That is a security
> bug I'd say.

What will happen in most reasonable filesystems is that
posix_acl_from_xattr or posix_acl_valid will see the -1 for the unmapped
uid or gid.  Realize that the -1 does not map, and return -EINVAL before
setting the xattr.  So I do not think the failure mode you are worried
about can happen.

Looking back at this I realize I have pretty much repeated my changelog
description.  Hopefully saying the same thing in different words makes
it clearer.

Eric
