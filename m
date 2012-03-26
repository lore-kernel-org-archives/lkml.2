Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab2CZOXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:23:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab2CZOW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:22:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <18418.1330238913@jrobl>
References: <18418.1330238913@jrobl> <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, valerie.aurora@gmail.com,
        linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov
Subject: Re: copy-up xattr (Re: [RFC][PATCH 00/73] Union Mount [ver #2])
Date: Mon, 26 Mar 2012 15:22:50 +0100
Message-ID: <9343.1332771770@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. R. Okajima <hooanon05@yahoo.co.jp> wrote:

> >  (4) Added some code to override the credentials around upper inode
> >      creation to make sure the inode gets the right UID/GID.  This doesn't
> >      help if the lower inode has some sort of foreign user identifier.
> >
> >      Also, I'm not sure whether the LSM xattrs should be blindly copied up.
> >      Should the LSM policies applicable to the lower fs's apply to the upper
> >      fs too?
> 
> Obviously the xattr entry may not have its meanings on the upper fs,

True.  I'm not sure what's the best way to deal with that.  Possibly add an
extra flag to vfs_setxattr() and have the fs vet them...  OTOH, this gives us
files on the lowerfs that may well differ in appearance to files on the
upperfs with respect to their xattrs.

> or the upper fs may return an error when setting the xattr. Additionally the
> returned errno may not follow the generic semantics (ENOTSUP, ENOSPC, or
> EDQUOT) since the fs may return fs-specific error.

Also true.  It's possible that the best way is just to ignore everything but a
medium-related error such as EIO, ENOSPC and EDQUOT: We tried...  Oh well.

> On the other hand, users may expect that the all xattrs are copied-up,
> particulary when he knows that the xattrs works well on the upper fs too.
> In copy-up, it will be hard to support all cases.

Yeah.  Ideally, the copied-up file would be indistinguishable from the lower
file, but in practice that's not possible unless inode numbers and other
physical characteristics of the lower file are recorded in the upper fs (say
on an xattr).

> In order to leave users how to handle the xattrs, I'd suggest
> introducing some mount options, which are similar to cp(1).
> cp(1) has several options
> 	--preserve=mode,ownership,timestamps,context,links,xattr,all
> 	('mode' includes acl which are based upon xattr)
> 
> Since the mode (without acl), ownership and timestamps should always be
> copied-up, the new mount options will be something like
> 	cpup-xattr=acl,context,all

I would suggest 'cpyup' or 'copyup' rather than 'cpup' - the latter looks like
something to do with CPUs, but yes, it's worth considering.

> And only when the option is specfied, the xattrs are copied up. No
> special error handling is necessary, all the errors should be returned
> to users unconditionally.

That's not necessarily good enough.  What if and LSM, say SELinux, is in
force?  Now SELinux will happily label the files for you - but there's a
reasonable chance they won't be correct.  OTOH, they may not be correct even
if they are copied up.

> Does union-mount preserve mtime? If not, it is critical for some
> applications such like "make" I am afraid.

Ummm...  Interesting question.  If it copies up a file, then that file must
have been opened for writing.  Is the mtime altered by such an event, or only
by a write() having been issued?  Also, what about ctime?  That doesn't seem
to have been copied up either.

David
