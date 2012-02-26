Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab2BZGsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 01:48:38 -0500
Received: from mail05-md.ns.itscom.net ([175.177.155.115]:40973 "EHLO
	mail05-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab2BZGsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 01:48:37 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: copy-up xattr (Re: [RFC][PATCH 00/73] Union Mount [ver #2])
To: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
Date: Sun, 26 Feb 2012 15:48:33 +0900
Message-ID: <18418.1330238913@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David Howells:
>  (4) Added some code to override the credentials around upper inode creation
>      to make sure the inode gets the right UID/GID.  This doesn't help if the
>      lower inode has some sort of foreign user identifier.
>
>      Also, I'm not sure whether the LSM xattrs should be blindly copied up.
>      Should the LSM policies applicable to the lower fs's apply to the upper
>      fs too?

Obviously the xattr entry may not have its meanings on the upper fs, or
the upper fs may return an error when setting the xattr. Additionally
the returned errno may not follow the generic semantics (ENOTSUP,
ENOSPC, or EDQUOT) since the fs may return fs-specific error.
On the other hand, users may expect that the all xattrs are copied-up,
particulary when he knows that the xattrs works well on the upper fs
too.
In copy-up, it will be hard to support all cases.

In order to leave users how to handle the xattrs, I'd suggest
introducing some mount options, which are similar to cp(1).
cp(1) has several options
	--preserve=mode,ownership,timestamps,context,links,xattr,all
	('mode' includes acl which are based upon xattr)

Since the mode (without acl), ownership and timestamps should always be
copied-up, the new mount options will be something like
	cpup-xattr=acl,context,all

And only when the option is specfied, the xattrs are copied up. No
special error handling is necessary, all the errors should be returned
to users unconditionally.

Does union-mount preserve mtime? If not, it is critical for some
applications such like "make" I am afraid.


J. R. Okajima
