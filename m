Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750856Ab0HQVGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0HQVGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:06:35 -0400
Date: Tue, 17 Aug 2010 17:06:10 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Union mounts and file locks (was Re: [PATCH 14/39] union-mount: Union mounts documentation)
Message-ID: <20100817210610.GF5556@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 10:51:52AM +0900, J. R. Okajima wrote:
> 
> Also here is my concern about UnionMount. All these issues have been
> reported before.
> - for users, the inode number may change silently. eg. copy-up.
> - link(2) may break by copy-up.
> - read(2) may get an obsoleted filedata (fstat(2) too).
> - fcntl(F_SETLK) may be broken by copy-up.
> - unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
>   open(O_RDWR).

You forgot fchmod()/fchown()/fsetxattr()/utimensat() failing on
O_RDONLY file descriptors. :)

These are all known limitations of union mounts, with the exception of
fcntl(F_SETLK).  Several people asked about this at the LSF workshop
and I said I'd look into it.

The short version is that in-kernel file copyup will affect locks the
same way as a concurrent rename() over the target.  If an application
opens a file read-only and gets a lock on it, and another application
(or the same one) opens the file read-write and takes a lock on it,
the first lock will be on the read-only file on the lower layer, and
the second lock will be on the file copied up to the top layer.  This
isn't what you want, obviously.

Union mounts behaves this way with locks for the same reason as
fchmod(), etc. on O_RDONLY file descriptors fails.  In-kernel copyup
only happens before a file descriptor is open.  Once it is open, it is
very difficult to switch the open file with the newly copied up file
("very difficult" meaning "Al Viro refuses to even discuss it").
fcntl() is called on an open file descriptor, so the decision to
copyup or not has already been made, based on the mode given to
open().

However, fcntl(F_SETLK) on a file opened read-write will behave
exactly as expected.  The question is how many applications call
fcntl(F_SETLK) on a read-only file descriptor as the first lock
operation on a file?  Of those applications, how many could easily be
rewritten to open that file descriptor with write permissions?

-VAL
