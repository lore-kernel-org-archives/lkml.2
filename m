Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2JPUio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:38:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47906 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2JPUin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:38:43 -0400
Message-ID: <1350419915.1958.39.camel@kjgkr>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Dave Chinner'" <david@fromorbit.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
Date: Wed, 17 Oct 2012 05:38:35 +0900
In-Reply-To: <201210161138.35388.arnd@arndb.de>
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
	 <20121015223409.GE2739@dastard>
	 <015901cdab42$06deac20$149c0460$%kim@samsung.com>
	 <201210161138.35388.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-16 (화), 11:38 +0000, Arnd Bergmann:
> On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> > On Monday 15 October 2012, Dave Chinner wrote:
> > > On Sun, Oct 14, 2012 at 03:19:37PM +0000, Arnd Bergmann wrote:
> > > > On Sunday 14 October 2012, Vyacheslav Dubeyko wrote:
> > > > > On Oct 14, 2012, at 11:09 AM, Jaegeuk Kim wrote:
> > > > > > 2012-10-14 (일), 02:21 +0400, Vyacheslav Dubeyko:
> > > 
> > > > The main reason I can see against extended attributes is that they are not stored
> > > > very efficiently in f2fs, unless a lot of work is put into coming up with a good
> > > > implementation. A single flags bit can trivially be added to the inode in
> > > > comparison (if it's not there already).
> > > 
> > > That's a deficiency that should be corrected, then, because xattrs
> > > are very common these days.
> > 
> > IMO, most file systems including f2fs have some inefficiency to store
> > and retrieve xattrs, since they have to allocate an additional block.
> > The only distinct problem in f2fs is that there is a cleaning overhead.
> > So, that's the why xattr is not an efficient way in f2fs.
> 
> I would hope that there is a better way to encode extented attributes
> if the current method is not efficient enough. Maybe Dave or someone
> else who is experienced with this can make suggestions.
> 
> What is the "expected" size of the attributes normally? Does it
> make sense to put attributes for multiple files into a single block?
>  

IMHO, this is an issue on global vs. local management approaches.
Yes, it is possible to manage xattrs globally, but my concern is how
to efficiently store, retrieve, and search xattrs without lock
contention, when users create and remove so many xattrs dynamically.
It may need to adopt an additional index structure like b+tree.

Well, the important thing that I focus is that xattrs need additional
blocks whatever they are compacted or not, resulting in cleaning
overhead in f2fs.

> > OTOH, I think xattr itself is for users, not for communicating
> > between file system and users.
> 
> No, you are mistaken in that point, as Dave explained.

I meant the original use-cases of xattr like below.
"Typical uses can be storing the author of a document, the character
encoding of a plain-text document, a checksum, cryptographic hash or
digital signature."
from http://en.wikipedia.org/wiki/Extended_file_attributes
Would you please give me some existing use-cases for the
communicating purpose?

> > Moreover, I'm not sure in the current android, but I saw ICS android
> > did not call any xattr operations, even if mount option was enabled.
> 
> I realize that Android is currently your main target, but to get
> the file system merged into Linux, it needs to fit in with the
> overall strategy for file systems, which includes more than just
> Android.

Definitely, yes.
I just wanted to say that xattr is not common on all the platforms yet.

> 
> > > And given that stuff like access frequency tracking is being
> > > implemented at the VFS level, access policy hints should also be VFS
> > > functionality. A bad filesystem implementation should not dictate
> > > the interface for generically useful functionality....
> 
> Agreed.
> 
> > > An xattr on the root inode that holds a list like this is something
> > > that could be set at mkfs time, but then also updated easily by new
> > > software packages that are installed...
> 
> Yes, good idea.

Likewise many file systems, f2fs also supports xattr as a configurable
Kconfig option.
If user disables the xattr feature, how can we do this?

> 
> > > > We should also take the kinds of access we have seen on a file into account.
> > > 
> > > Yes, but it should be done at the VFS level, not in the filesystem
> > > itself. Integrated into the current hot inode/range tracking that is
> > > being worked on right now, I'd suggest.
> > > 
> > > IOWs, these access policy issues are not unique to F2FS or it's use
> > > case. Anything to do with access hints, policy, tracking, file
> > > classification, etc that can influence data locality, reclaim,
> > > migration, etc need to be dealt with at the VFS, independently of a
> > > specific filesystem. Filesystems can make use of that information
> > > how they please (whether in the kernel or via userspace tools), but
> > > having filesystem specific interfaces and implementations of the
> > > same functionality is extremely wasteful. Let's do it once, and do
> > > it right the first time. ;)
> > 
> > I agree that VFS should support something, but before then, it needs
> > to do something by the file system first.
> > Because, we have to figure out what kind of information are really useful.
> 
> As mentioned before, such tuning can still be done after the file system
> is merged, as long as the on-disk structure is flexible enough.
> 
> As you said yourself, imlpementing the hints by detecting access patterns
> from the file system itself as I suggested would be a lot of work, and
> if the VFS can give us that information for free in the future, we can
> wait for that to happen (or help out on the implementation if necessary)
> and then implement it based on those APIs.
> 

Ok, agreed.

> 	Arnd

-- 
Jaegeuk Kim
Samsung

