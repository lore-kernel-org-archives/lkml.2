Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab1CCVX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:23:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36174 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883Ab1CCVX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:23:56 -0500
Date: Thu, 3 Mar 2011 21:23:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
Message-ID: <20110303212355.GO22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
 <AANLkTin5GpLSvNnLb_=2wMS9w6RjHa=q8p0gOENtNjfq@mail.gmail.com>
 <20110303060352.GK22723@ZenIV.linux.org.uk>
 <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=85DJo-Qy0bABKg1J_j0s=8HfTt1m+rq4E5GqS@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 12:05:43PM -0800, Linus Torvalds wrote:

> The thing is, I don't think it's a QoI question at all - since any
> user that _depends_ on this kind of behavior is simply broken. We
> aren't going to guarantee it, exactly because some filesystems simply
> will not ever guarantee it.

Umm...  Not really.  "If you decide to use idiotify, at least retain some
measure of sanity and keep it to local filesystems" is more or less
feasible.  "Just say no to CONFIG_INOTIFY" is getting harder and harder -
recent udev won't run without that and recent X depends on udev.

And inotify *does* expose that to userland.  Set inotify watch on a
directory.  Ask to be notified of IN_DELETE_SELF.  Then do overwriting
rename() (note that it doesn't have to be busy - just sitting there
being watched).  You will get event on most of the local filesystems,
same as you would from rmdir().  However, do that on jffs2 and event
will be generated only on rmdir().  Directory itself will be killed
by rename() just as thoroughly as by rmdir(); it's not something like
silllyrename on NFS where we really have different behaviour.

> Now, for FAT we do in fact try rather hard to fake the i_nlink count,
> but I'm not at all convinced that's a good idea. It makes reading
> directory inodes on FAT much more expensive (we have to basically do a
> readdir for each open). So I'd hate to make that whole "you need to
> emulate i_nlink even if you really don't care" be something that we
> actually end up thinking is a quality issue.

That is completely separate story; keeping st_nlink for live directories
equal to 2 + number of subdirectories is, IMO, fairly silly on such
filesystems.  The only reason for doing that was to allow find(1) some
optimizations, IIRC.

But we are talking about a very different thing - not "I can tell if it's
a leaf directory by looking at st_nlink", but "link count 0 means that it's
only kept alive by being busy".  And it's trivial to maintain.

Look, in rename() we *must* check that victim is empty anyway.  IOW, any
instance on a local fs will have the place where it has decided that we
are killing a directory.  Ditto for successful rmdir().  We don't need
to count subdirectories or anything like that - it's a matter of saying
victim->i_nlink = 0 instead of victim->i_nlink-- in a specific place in
foo_rename().

> There are other filesystems where i_nlink can be even _less_
> meaningful, ie if the filesystem does any kind of fancy
> content-indexing thing or lazy COW (think "union filesystem within the
> filesystem") or whatever, I could easily see i_nlink not having any
> traditional unix filesystem semantics.
> 
> Seriously - how did you even notice this?

Code review.  Went crawling through i_nlink users in the tree after the
ext2_rename() fun caught by Josh, found a bunch of obvious bugs and
this oddity.

> I'm not opposed to fix actual bugs, but I _do_ think it is
> questionable to make this kind of nonsense semantic issue be an issue.

See above re exposure to userland via inotify.  I don't think that it's
an earth-shattering problem, obviously, but since fixing it really doesn't
cost anything on few local fs that have it...
