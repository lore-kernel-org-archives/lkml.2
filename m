Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab2C0EjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 00:39:06 -0400
Received: from nm24.access.bullet.mail.mud.yahoo.com ([66.94.237.89]:37660
	"HELO nm24.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751862Ab2C0EjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 00:39:02 -0400
X-Yahoo-Newman-Id: 288521.85814.bm@smtp103.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: CrRhcM4VM1nacgDFYfWepHL30xF4xrZABzAT3dWh4nUc5h8
 gicWf4PifGv2ufOyDvtj3lNxW_duDpyoClVcw2Ds5DjbvcbldtJ5PsOutYwq
 lBcgTIoFX26NDy.LNm4ZI8k2wnwTGN_N3cQjJ9AFTwey6IHZDWGyXcFi1T_s
 kO.lP.4HzMU9Xaq2zo_7SyU1eCIYGo09dwYII6vC34v.7cI83y5QAQN._HZC
 82O10..zuiSQhFYaWaANnJPoojH5DbK6r.Fs8qRcHUCqu9weMJf_nXnfXrFp
 YEKgzsggdCf0EAhEYvcUcWZ16XMnRV4v6r7WSuPvu6td.286lPNFKdPL5UBT
 nuaNGD71x5TkQDF1w3ulL4QDtl39DZZ8HqvjBtgFqSdAsSjH1AUQuCGuTHKl
 7Ylt7_eOTFlRTGDDECj.3VcAQcBSqIZkqWet0LFe03Yc5lJR_W2.TrtSDi0n
 m5sxw0Mpq3zJYEUQ7F6TDF0KXGnn9eIWnw2vVFR9sMM30lVkc9Im5OA--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F714463.7090508@schaufler-ca.com>
Date: Mon, 26 Mar 2012 21:38:59 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: "J. R. Okajima" <hooanon05@yahoo.co.jp>, linux-fsdevel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, valerie.aurora@gmail.com,
        linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        Casey Schaufler <casey@schaufler-ca.com>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: copy-up xattr (Re: [RFC][PATCH 00/73] Union Mount [ver #2])
References: <18418.1330238913@jrobl> <20120221175721.25235.8901.stgit@warthog.procyon.org.uk> <9343.1332771770@redhat.com>
In-Reply-To: <9343.1332771770@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/2012 7:22 AM, David Howells wrote:
> J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
>>>  (4) Added some code to override the credentials around upper inode
>>>      creation to make sure the inode gets the right UID/GID.  This doesn't
>>>      help if the lower inode has some sort of foreign user identifier.
>>>
>>>      Also, I'm not sure whether the LSM xattrs should be blindly copied up.
>>>      Should the LSM policies applicable to the lower fs's apply to the upper
>>>      fs too?
>> Obviously the xattr entry may not have its meanings on the upper fs,
> True.  I'm not sure what's the best way to deal with that.  Possibly add an
> extra flag to vfs_setxattr() and have the fs vet them...  OTOH, this gives us
> files on the lowerfs that may well differ in appearance to files on the
> upperfs with respect to their xattrs.

Are you suggesting that you would have heterogeneous filesystems
with different xattr behavior stacked at the same time as you're
using an LSM that cares about the behavior of xattrs? Oh dear. As
I typed that sentence I identified a viable use case.

>> or the upper fs may return an error when setting the xattr. Additionally the
>> returned errno may not follow the generic semantics (ENOTSUP, ENOSPC, or
>> EDQUOT) since the fs may return fs-specific error.
> Also true.  It's possible that the best way is just to ignore everything but a
> medium-related error such as EIO, ENOSPC and EDQUOT: We tried...  Oh well.
>
>> On the other hand, users may expect that the all xattrs are copied-up,
>> particulary when he knows that the xattrs works well on the upper fs too.
>> In copy-up, it will be hard to support all cases.
> Yeah.  Ideally, the copied-up file would be indistinguishable from the lower
> file, but in practice that's not possible unless inode numbers and other
> physical characteristics of the lower file are recorded in the upper fs (say
> on an xattr).
>
>> In order to leave users how to handle the xattrs, I'd suggest
>> introducing some mount options, which are similar to cp(1).
>> cp(1) has several options
>> 	--preserve=mode,ownership,timestamps,context,links,xattr,all
>> 	('mode' includes acl which are based upon xattr)
>>
>> Since the mode (without acl), ownership and timestamps should always be
>> copied-up, the new mount options will be something like
>> 	cpup-xattr=acl,context,all
> I would suggest 'cpyup' or 'copyup' rather than 'cpup' - the latter looks like
> something to do with CPUs, but yes, it's worth considering.
>
>> And only when the option is specfied, the xattrs are copied up. No
>> special error handling is necessary, all the errors should be returned
>> to users unconditionally.
> That's not necessarily good enough.  What if and LSM, say SELinux, is in
> force?  Now SELinux will happily label the files for you - but there's a
> reasonable chance they won't be correct.  OTOH, they may not be correct even
> if they are copied up.

The underlying storage (the "real" file) has to have the xattr attached
to it.
Any other behavior is incorrect. If the underlying filesystem does not
support
xattrs that lack of support has to be propagated upwards even if the higher
layer filesystem supports xattrs.

In the case of Smack filesystems that don't support xattrs are still given
labels based on mount options. If the lower filesystem is NTFS and the upper
ext4 you've got to respect the NTFS labeling behavior for files there.

>> Does union-mount preserve mtime? If not, it is critical for some
>> applications such like "make" I am afraid.
> Ummm...  Interesting question.  If it copies up a file, then that file must
> have been opened for writing.  Is the mtime altered by such an event, or only
> by a write() having been issued?  Also, what about ctime?  That doesn't seem
> to have been copied up either.

What is the expected behavior of union mounts for all attributes? Is it
specified anywhere?

>
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

