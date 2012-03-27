Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2C0NQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:16:54 -0400
Received: from countercultured.net ([209.51.175.25]:52896 "HELO
	countercultured.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753238Ab2C0NQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:16:49 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2012 09:16:49 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Mar 2012 09:10:07 -0400
From: David Quigley <selinux@davequigley.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: David Howells <dhowells@redhat.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <valerie.aurora@gmail.com>, <linux-kernel@vger.kernel.org>,
        <sds@tycho.nsa.gov>, <selinux@tycho.nsa.gov>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: copy-up xattr (Re: [RFC][PATCH 00/73] Union Mount [ver #2])
In-Reply-To: <4F714463.7090508@schaufler-ca.com>
References: <18418.1330238913@jrobl>
 <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
 <9343.1332771770@redhat.com> <4F714463.7090508@schaufler-ca.com>
Message-ID: <12cbdde6e0fb9e497d7cd9c277ab9cf5@countercultured.net>
User-Agent: RoundCube Webmail/0.8-svn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2012 00:38, Casey Schaufler wrote:
> On 3/26/2012 7:22 AM, David Howells wrote:
>> J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>>
>>>>  (4) Added some code to override the credentials around upper 
>>>> inode
>>>>      creation to make sure the inode gets the right UID/GID.  This 
>>>> doesn't
>>>>      help if the lower inode has some sort of foreign user 
>>>> identifier.
>>>>
>>>>      Also, I'm not sure whether the LSM xattrs should be blindly 
>>>> copied up.
>>>>      Should the LSM policies applicable to the lower fs's apply to 
>>>> the upper
>>>>      fs too?
>>> Obviously the xattr entry may not have its meanings on the upper 
>>> fs,
>> True.  I'm not sure what's the best way to deal with that.  Possibly 
>> add an
>> extra flag to vfs_setxattr() and have the fs vet them...  OTOH, this 
>> gives us
>> files on the lowerfs that may well differ in appearance to files on 
>> the
>> upperfs with respect to their xattrs.
>
> Are you suggesting that you would have heterogeneous filesystems
> with different xattr behavior stacked at the same time as you're
> using an LSM that cares about the behavior of xattrs? Oh dear. As
> I typed that sentence I identified a viable use case.

The most common use case for union mounts is a livecd. In this case the 
livecd iso has a tmpfs rw mount above it for copyup. I don't know how 
useful having a smart xattr copyup mechanism is in that place as most of 
the labels will be whatever is assigned to the iso. Another usecase is 
snapshotting of a filesystem for rollback. In this case it is probably 
important to retain the existing label as the copyup is supposed to be 
to the same location. The last case which is similar to the snapshotting 
case but with a persistant upper branch would be to have an NFS mount 
and have local configuration changes stored locally. In that case as 
well I can see simple copy up as being ok to do since you're using it 
more as an overlay than a union mount.

Now the tricky case is when you have two filesystems with two different 
directories with the same name. You're going to merge those namespaces. 
The problem occurs when the parent directories have different labels.

For example /mnt/upper/foo is labeled foo_t and /mnt/lower/foo is 
labeled foo2_t. What do you use for the label for files created in 
/mnt/union/foo?

>
>>> or the upper fs may return an error when setting the xattr. 
>>> Additionally the
>>> returned errno may not follow the generic semantics (ENOTSUP, 
>>> ENOSPC, or
>>> EDQUOT) since the fs may return fs-specific error.
>> Also true.  It's possible that the best way is just to ignore 
>> everything but a
>> medium-related error such as EIO, ENOSPC and EDQUOT: We tried...  Oh 
>> well.
>>
>>> On the other hand, users may expect that the all xattrs are 
>>> copied-up,
>>> particulary when he knows that the xattrs works well on the upper 
>>> fs too.
>>> In copy-up, it will be hard to support all cases.
>> Yeah.  Ideally, the copied-up file would be indistinguishable from 
>> the lower
>> file, but in practice that's not possible unless inode numbers and 
>> other
>> physical characteristics of the lower file are recorded in the upper 
>> fs (say
>> on an xattr).
>>
>>> In order to leave users how to handle the xattrs, I'd suggest
>>> introducing some mount options, which are similar to cp(1).
>>> cp(1) has several options
>>> 	--preserve=mode,ownership,timestamps,context,links,xattr,all
>>> 	('mode' includes acl which are based upon xattr)
>>>
>>> Since the mode (without acl), ownership and timestamps should 
>>> always be
>>> copied-up, the new mount options will be something like
>>> 	cpup-xattr=acl,context,all
>> I would suggest 'cpyup' or 'copyup' rather than 'cpup' - the latter 
>> looks like
>> something to do with CPUs, but yes, it's worth considering.
>>
>>> And only when the option is specfied, the xattrs are copied up. No
>>> special error handling is necessary, all the errors should be 
>>> returned
>>> to users unconditionally.
>> That's not necessarily good enough.  What if and LSM, say SELinux, 
>> is in
>> force?  Now SELinux will happily label the files for you - but 
>> there's a
>> reasonable chance they won't be correct.  OTOH, they may not be 
>> correct even
>> if they are copied up.
>
> The underlying storage (the "real" file) has to have the xattr 
> attached
> to it.
> Any other behavior is incorrect. If the underlying filesystem does 
> not
> support
> xattrs that lack of support has to be propagated upwards even if the 
> higher
> layer filesystem supports xattrs.
>
> In the case of Smack filesystems that don't support xattrs are still 
> given
> labels based on mount options. If the lower filesystem is NTFS and 
> the upper
> ext4 you've got to respect the NTFS labeling behavior for files 
> there.
>
>>> Does union-mount preserve mtime? If not, it is critical for some
>>> applications such like "make" I am afraid.
>> Ummm...  Interesting question.  If it copies up a file, then that 
>> file must
>> have been opened for writing.  Is the mtime altered by such an 
>> event, or only
>> by a write() having been issued?  Also, what about ctime?  That 
>> doesn't seem
>> to have been copied up either.
>
> What is the expected behavior of union mounts for all attributes? Is 
> it
> specified anywhere?
>

I would assume its under their documentation patch. I tried to lookup 
up what we did for our copyup semantics for file attributes. Its not 
simple or straight forward in the original UnionFS. I think its safe to 
say all the first class attributes need to be copied up. When possible 
we also copied the xattrs as well. Its important to realize though that 
union mounts are namespace unification and not fileunification so if you 
copy one xattr up you need to copy them all because any that don't get 
copied will get left behind.

>>
>> David
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
> --
> This message was distributed to subscribers of the selinux mailing 
> list.
> If you no longer wish to subscribe, send mail to 
> majordomo@tycho.nsa.gov with
> the words "unsubscribe selinux" without quotes as the message.

