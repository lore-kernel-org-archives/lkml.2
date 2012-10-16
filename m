Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab2JPUoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:44:17 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:11796 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752333Ab2JPUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:44:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkIoAE3GfVB5LJyt/2dsb2JhbABFhhG0FIRkAoEAgQmCIAEBBAEjDwEjIwULCAMYAgImAgIUJQMhE4d+Bagmkn8UgQ2KLiCBR4NEMmADlWqQM4MBgUc
Date: Wed, 17 Oct 2012 07:44:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Message-ID: <20121016204412.GF2864@dastard>
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
 <20121015223409.GE2739@dastard>
 <015901cdab42$06deac20$149c0460$%kim@samsung.com>
 <201210161138.35388.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201210161138.35388.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 11:38:35AM +0000, Arnd Bergmann wrote:
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
> What is the "expected" size of the attributes normally?

Most attributes are small. Even "large" user attributes don't
generally get to be more than a couple of hundred bytes, though the
maximum size for a single xattr is 64K.

> Does it
> make sense to put attributes for multiple files into a single block?

There are two main ways of dealing with attributes. The first is a
tree-like structure to index and store unique xattrs, and have the
inode siimply keep pointers to the main xattr tree. This is great
for keeping space down when there are lots of identical xattrs, but
is a serialisation point for modification an modification can be
complex (i.e. shared entries in the tree need COW semantics.) This
is the approach ZFS takes, IIRC, and is the most space efficient way
of dealing with xattrs. It's not the most performance efficient way,
however, and the reference counting means frequent tree rewrites.

The second is the XFS/ext4 approach, where xattrs are stored in a
per-inode tree, with no sharing. The attribute tree holds the
attributes in it's leaves, and the tree grows and shrinks as you add
or remove xattrs. There are optimisations on top of this - e.g. for
XFS if the xattrs fit in the spare space in the inode, they are
packed into the inode ("shortform") and don't require an external
block. IIUC, there are patches to implement this optimisation for
ext4 floating around at the moment. This is a worthwhile
optimisation, because with a 512 byte inode size on XFS there is
enough spare space (roughly 380 bytes) for most systems to store all
their xattrs in the inode itself. XFS also has "remote attr storage"
for large xattrs (i.e. larger than a leaf block), where the tree
just keeps a pointer to an external extent that holds the xattr.

IIRC, fs2fs uses 4k inodes, so IMO per-inode xattr tress with
internal storage before spilling to an external block is probably
the best approach to take...

> > OTOH, I think xattr itself is for users, not for communicating
> > between file system and users.
> 
> No, you are mistaken in that point, as Dave explained.

e.g. selinux, IMA, ACLs, capabilities, etc all communicate
information that the kernel uses for access control. That's why
xattrs have different namespaces like "system", "security" and
"user". Only user attributes are truly for user data
- the rest are for communicating information to the kernel....

A file usage policy xattr would definitely exist under the "system"
namespace - it's not a user xattr at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
