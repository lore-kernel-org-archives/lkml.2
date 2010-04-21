Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0DUJwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:52:33 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56996 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0DUJwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:52:31 -0400
Date: Wed, 21 Apr 2010 10:52:21 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jblunck@suse.de, vaurora@redhat.com, dwmw2@infradead.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 13/35] fallthru: ext2 fallthru support
Message-ID: <20100421095221.GD13114@shareable.org>
References: <1271682168.14748.718.camel@macbook.infradead.org> <20100419132344.GI10776@bolzano.suse.de> <20100419133028.GA3631@shareable.org> <20100419141248.GK10776@bolzano.suse.de> <20100419142315.GA2688@shell> <E1O3sLi-0008EA-QW@pomaz-ex.szeredi.hu> <20100420213450.GM11723@shareable.org> <20100421084211.GB22741@bolzano.suse.de> <20100421092235.GB13114@shareable.org> <E1O4WKa-0003Pp-0y@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1O4WKa-0003Pp-0y@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Wed, 21 Apr 2010, Jamie Lokier wrote:
> > Hmm.  I smell potential confusion for some otherwise POSIX-friendly
> > userspaces.
> > 
> > When I open /path/to/foo, call fstat (st_dev=2, st_ino=5678), and then
> > keep the file open, then later do a readdir which includes foo
> > (dir.st_dev=1, d_ino=1234), I'm going to immediately assume a rename
> > or unlink happened, close the file, abort streaming from it, refresh
> > the GUI windows, refresh application caches for that name entry, etc.
> > 
> > Because in the POSIX world I think open files have stable inode
> > numbers (as long as they are open), and I don't think that an open
> > file can have it's name's d_ino not match the inode number unless it's
> > a mount point, which my program would know about.
> > 
> > This plays into inotify, where you have to know if you are monitoring
> > every directory that contains a link to a file, to know if you need to
> > monitor the file itself directly instead.
> > 
> > Now I think it's fair enough that a union mount doesn't play all the
> > traditional rules :-)  C'est la vie.
> > 
> > This mismatch of (dir.st_dev,d_ino) and st_ino strongly resembles a
> > file-bind-mount.  Like bind mounts, it's quite annoying for programs
> > that like to assume they've seen all of a file's links when they've
> > seen i_nlink of them.
> > 
> > Bind mounts can be detected by looking in /proc/mounts.  st_dev
> > changing doesn't work because it can be a binding of the same
> > filesystem.
> > 
> > How would I go about detecting when a union mount's directory entry
> > has similar behaviour, without calling stat() on each entry?  Is it
> > just a matter of recognising a particular filesystem name in
> > /proc/mounts, or something more?
> 
> Detecting mount points is best done by comparing st_dev for the parent
> directory with st_dev of the child.  This is much simpler than parsing
> /proc/mounts and will work for bind mounts as well as union mounts.

Sorry, no: That does not work for bind mounts.  Both layers can have
the same st_dev.  Nor does O_NOFOLLOW stop traversal in the middle of
a path, there is no handy O_NOCROSSMOUNTS, and no st_mode flag or
d_type to say it's a bind mount.  Bind mounts are really a big pain
for i_nlink+inotify name counting.

Besides, calling stat() on every entry in a large directory to check
st_ino can be orders of magnitude slower than readdir() on a large
directory - especially with a cold cache.  It is quicker, but much
more complicated, to parse /proc/mounts and apply arcane rules to find
the exceptions.

Can a union mount overlap two parts of the same filesystem?

> I think there's no question that union mounts might break apps (POSIX
> or not).  But I think there's hope that they are few and can easily be
> fixed.

I agree, and union moint is a very useful feature that's worth
breaking a few apps for :-)

I'm curious if there's a clear way to go about it in this case, or
if it'll involve a certain amount of pattern recognition in /proc/mounts.

Basically I'm wondering if it's been thought about already.

-- Jamie
