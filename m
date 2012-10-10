Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2JJUHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:07:19 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53981 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2JJUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:07:13 -0400
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
	<20121009204433.GB24622@quack.suse.cz> <878vbf5nez.fsf@xmission.com>
	<20121010114227.GC32581@quack.suse.cz>
Date: Wed, 10 Oct 2012 13:06:59 -0700
In-Reply-To: <20121010114227.GC32581@quack.suse.cz> (Jan Kara's message of
	"Wed, 10 Oct 2012 13:42:27 +0200")
Message-ID: <87a9vurt0c.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18vQHMVKPtaLVTLgYAhnYWuJelS52rmYUg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0260]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jan Kara <jack@suse.cz>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 16/27] userns: Convert vfs posix_acl support to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Tue 09-10-12 14:46:28, Eric W. Biederman wrote:
>> Jan Kara <jack@suse.cz> writes:
>> >> diff --git a/fs/xattr.c b/fs/xattr.c
>> >> index 4d45b71..c111745 100644
>> >> --- a/fs/xattr.c
>> >> +++ b/fs/xattr.c
>> >> @@ -20,6 +20,7 @@
>> >>  #include <linux/fsnotify.h>
>> >>  #include <linux/audit.h>
>> >>  #include <linux/vmalloc.h>
>> >> +#include <linux/posix_acl_xattr.h>
>> >>  
>> >>  #include <asm/uaccess.h>
>> >>  
>> >> @@ -347,6 +348,9 @@ setxattr(struct dentry *d, const char __user *name, const void __user *value,
>> >>  			error = -EFAULT;
>> >>  			goto out;
>> >>  		}
>> >> +		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
>> >> +		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
>> >> +			posix_acl_fix_xattr_from_user(kvalue, size);
>> >>  	}
>> >>  
>> >>  	error = vfs_setxattr(d, kname, kvalue, size, flags);
>> >> @@ -450,6 +454,9 @@ getxattr(struct dentry *d, const char __user *name, void __user *value,
>> >>  
>> >>  	error = vfs_getxattr(d, kname, kvalue, size);
>> >>  	if (error > 0) {
>> >> +		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
>> >> +		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
>> >> +			posix_acl_fix_xattr_to_user(kvalue, size);
>> >>  		if (size && copy_to_user(value, kvalue, error))
>> >>  			error = -EFAULT;
>> >>  	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
>> >> diff --git a/fs/xattr_acl.c b/fs/xattr_acl.c
>> >> index 69d06b0..bf472ca 100644
>> >> --- a/fs/xattr_acl.c
>> >> +++ b/fs/xattr_acl.c
>> >> @@ -9,7 +9,65 @@
>> >>  #include <linux/fs.h>
>> >>  #include <linux/posix_acl_xattr.h>
>> >>  #include <linux/gfp.h>
>> >> +#include <linux/user_namespace.h>
>> >>  
>> >> +/*
>> >> + * Fix up the uids and gids in posix acl extended attributes in place.
>> >> + */
>> >> +static void posix_acl_fix_xattr_userns(
>> >> +	struct user_namespace *to, struct user_namespace *from,
>> >> +	void *value, size_t size)
>> >> +{
>> >> +	posix_acl_xattr_header *header = (posix_acl_xattr_header *)value;
>> >> +	posix_acl_xattr_entry *entry = (posix_acl_xattr_entry *)(header+1), *end;
>> >> +	int count;
>> >> +	kuid_t uid;
>> >> +	kgid_t gid;
>> >> +
>> >> +	if (!value)
>> >> +		return;
>> >> +	if (size < sizeof(posix_acl_xattr_header))
>> >> +		return;
>> >> +	if (header->a_version != cpu_to_le32(POSIX_ACL_XATTR_VERSION))
>> >> +		return;
>> >> +
>> >> +	count = posix_acl_xattr_count(size);
>> >> +	if (count < 0)
>> >> +		return;
>> >> +	if (count == 0)
>> >> +		return;
>> >> +
>> >> +	for (end = entry + count; entry != end; entry++) {
>> >> +		switch(le16_to_cpu(entry->e_tag)) {
>> >> +		case ACL_USER:
>> >> +			uid = make_kuid(from, le32_to_cpu(entry->e_id));
>> 
>>   
>> >   This should have some error checking I guess... The initial checks done
>> > in posix_acl_from_xattr() are for init_user_ns (why?) and only duplicated
>> > in posix_acl_valid().
>> 
>> The flow from userspace:
>>   posix_acl_fix_xattr_from_user
>>   posix_acl_from_xattr
>>   posix_acl_valid
>> 
>> The flow to userspace:
>>   posix_acl_to_xattr
>>   posix_acl_fix_xattr_to_user
>> 
>> The existence of the posix_acl_fix_xattr_from_user and
>> posix_fix_xattr_to_user ensure that filesystems only see xattrs encoded
>> in the initial user namespace. Which is why posix_acl_from_xattr only
>> takes init_user_ns as a parameter.
>>
>> How filesystems handle xattrs that deal with acls is spread all across
>> the map.  Some filesystems do the reasonable thing and translate the
>> xattr from userspace into an acl and then translate the acl into their
>> on-disk format.  Other filesystems just stuff the acl onto the disk or
>> onto the fileserver without looking at it.
>> 
>> As for checks my interpretation was that a filesystem should already
>> be calling posix_acl_from_xattr and posix_acl_valid, and that
>> duplicating those checks in posix_acl_fix_xattr_to/from_user would
>> be redundnant and confusing.
>> 
>> What does happen is that any uid or gid that does not map gets
>> translated into -1, which should always fail the latter sanity
>> check.
>   Ah, I got lost in the maze of xattr callbacks. You are right, things work
> as you say. Thanks for explanation.

No problem.  I realized after writing this there is another interesting
bit of explanation I left out.

In the user -> kernel direction posix_acl_fix_xattr_from_user will not
introduce any new failure modes because the destination is the
init_user_ns. 

In the the kernel -> user direction (reads) posix_acl_fix_xattr_to_user
will introduce new failure modes (the uids and gids that don't map and
are replaced by -1).  Strategically returning a defined uid that indicates
the mapping didn't happen seems preferable to completely failing the
system call.

So since posix_acl_fix_xattr_from_user and posix_acl_fix_xattr_to_user
don't introduce any new failure modes I am comfortable with them not
returning error codes.

>> >> +			entry->e_id = cpu_to_le32(from_kuid(to, uid));
>> >> +			break;
>> >> +		case ACL_GROUP:
>> >> +			gid = make_kgid(from, le32_to_cpu(entry->e_id));
>> >> +			entry->e_id = cpu_to_le32(from_kuid(to, uid));
>> >                                              here should be gid ^^^
>> Ugh.  Yes.  That is a very real bug. :(  The &init_user_ns short circuit
>> likely protects against regressions but I will fix this.
>   Actually, it will cause a regression because you will end up converting
> uninitialized 'uid' variable.

I mean the check for init_user_ns in posix_acl_fix_xattr_from_user and
posix_acl_fix_xattr_to_user that causes this code to not be executed.

Since the code is not executed except when you mix user namespaces we
don't have the potential for regressions.  The code is most definitely
wrong if it gets executed.

I have the obvious fix queued up in my for-next branch and I intend to
ask Linus to pull it in a little bit.

>> > Also what about the following scenario:
>> >
>> > We have namespace A with user U1 and namespace B which does not have a
>> > valid representation for U1.
>> 
>> > There is a file F which can be seen from both
>> > namespaces. In namespace A we create acl for user U1 attached to F. Now in
>> > namespace B we modify the acl via setfacl(1) command. What it does is
>> > getxattr(2) - returns mangled acl because U1 has no representation in B. We
>> > add something to xattr and call setxattr(2) - results in removing the
>> > original acl for U1 and instead adding acl for uid -1. That is a security
>> > bug I'd say.
>> 
>> What will happen in most reasonable filesystems is that
>> posix_acl_from_xattr or posix_acl_valid will see the -1 for the unmapped
>> uid or gid.  Realize that the -1 does not map, and return -EINVAL before
>> setting the xattr.  So I do not think the failure mode you are worried
>> about can happen.
>   Hum, so for filesystems as ext4 or xfs you won't be able to modify acls
> from namespace B on F. I guess this is a modest option (although I can
> imagine users will ponder hard to find out while setfacl fails without
> apparent reason for some files) until someone cares enough to implement
> something more clever.

I expect the -1 when they read back an acl will be a reasonable clue.
In practice cross namespace accesses don't happen often so I don't
expect it will be much of an issue.  But yeah I understand the possible
conflusion.

>  But filesystems such as ubifs or nfs4 will just
> silently corrupt the acl. I don't think that is acceptable... I think you
> should fix these to fail setting the acl or fail compilation with
> CONFIG_USER_NS or whatever. Anything is better than corrupting on disk
> data.

There is an interesting twist on your concern.  For a filesystem to
implement posix acls the filesystem must call posix_acl_from_xattr when
the acl is set.  So only a filesystem that sets the acl and then calls
posix_acl_from_xattr is susceptible to the failure mode you describe.

ubifs is a weird case because ubifs has implemented general xattr
support but ubifs does not implement posix acls.  You can read and write
posix acls on ubifs but posix acls on ubifs are ignored by permission
checks.

nfs4 still does not compile with CONFIG_USER_NS.  I have patches in my
development tree but those patches were just a touch short of being
ready by the merge window.

nfsd-4 acls map themselves down to posix acls, and go through the
customary posix_acl_from_xattr path.

nfs4 client support is interesting.  nfs4 client support does not
support posix acls but instead passes the acl to the nfs server for
setting and validation.  So there is no chance of corruption there.
Although it could get weird if the uid to username mappings are not
consistent.  But that has little to do with user namespaces.

So in net I don't think nfs4 will have problems.

The rest of the network filesystems are in a similar boat to nfs4.  They
have not been merged yet they were the trickest and they still need a
bit more review before they can be merged.  My plan is to send them out
for review after 3.7-rc1 is released and stage them for 3.8.

Now filesystems like ubifs and fuse are interesting.  Looking at those
filesystems raises the question: How should we handle filesystems that
don't implement posix acls but accept xattrs with the name of posix
acls?  My take: "Don't do that".  Filesystems doing that are that silly just
need to be fixed.

Eric
