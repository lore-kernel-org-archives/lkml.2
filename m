Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575Ab0FQRyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:54:49 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56486 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760543Ab0FQRyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:54:47 -0400
Date: Thu, 17 Jun 2010 18:54:29 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] d_ino considered harmful
Message-ID: <20100617175429.GC4979@shareable.org>
References: <20100616185913.GA15566@shell> <20100616195359.GA24382@shell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616195359.GA24382@shell>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valerie Aurora wrote:
>> Who needs d_ino anyway?  I am running a kernel with this patch -
>> Gnome, a browser, IRC, kernel compile, etc. and everything works.
> I'm running a kernel with the below patch and everything still works.
> Apparently "ls -i" is still using the bogus d_ino performance
> improvement mentioned here because it returns all 1's for inode
> number.

I'm surprised at "ls -i", as a patch to change that has been submitted:

    http://marc.info/?l=linux-kernel&m=125181054102075
    http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/17887

>
>     Use of d_ino without the corresponding st_dev is always buggy in the
>     presence of submounts, bind mounts, and union mounts.  E.g., the d_ino
>     of a mountpoint will be the inode number of the directory under the
>     mountpoint, not the mounted directory.

It's not surprising everything seems to work.

It can be useful as a performance hint, which you probably didn't test.

I have some "find"-style program ("treescan" if you want to Google;
it's ancient now), which shows a 50x speedup in some cold-cache cases
using d_ino to sort prior to stat() calls, to reduce disk seeking.
50x is unusual; usually it's more like 2x.  I still run that program
prior to "git status" on a directory in cold cache.

Others have mentioned other programs which benefit from the d_ino hint.

It is possible to use it in a "correct" way, too, because it is only
mountpoints where the value is incorrect.

When the value is correct, it's useful for detecting which files have
been renamed, linked or deleted in a directory, and you detect the
directory has changed (e.g. using mtime).  If you know (by agreement)
that there are no mount points and certain files aren't overwritten in
place, always replaced, that can be used to maintain application
caches too.

I strongly disagree that correct code must call stat().  Correct code
can check against the list of mountpoints in /proc/mounts, because it
is strictly only mountpoints where the number doesn't agree with
stat() -- prior to your patch :-)

Anyway, maybe your patch is not allowed by POSIX :-) as follows
(posted to linux-kernel some time ago):

    http://marc.info/?l=linux-kernel&m=125181054102075
    http://www.gossamer-threads.com/lists/linux/kernel/1124140

    The POSIX readdir spec says this:

	The structure dirent defined in the <dirent.h> header describes a
	directory entry. The value of the structure's d_ino member shall be set
	to the file serial number of the file named by the d_name member.

    The description for sys/stat.h makes the connection between
    "file serial number" and the stat.st_ino member:

	The <sys/stat.h> header shall define the stat structure, which shall
	include at least the following members:
	...
	    ino_t st_ino                File serial number.

Returning the covered inode's number at a mountpoint is apparently not
POSIX compliant either, but is widespread.  (I.e. all unixes except
Cygwin apparently.)

> Gosh, maybe it would help to patch the currently used readdir instead
> of just old_readdir() (thanks, Arnd).  And return 1 instead of 0 so ls
> doesn't think all files are deleted (thanks, Andreas).

It's not just ls.  Bash 3.0 ignores entries for completion if d_ino == 0.

> I'm running a kernel with the below patch and everything still works.
> Apparently "ls -i" is still using the bogus d_ino performance
> improvement mentioned here because it returns all 1's for inode
> number.
> 
> http://www.mail-archive.com/bug-findutils@gnu.org/msg02531.html

I'm intrigued by the mentioned in that report that Linux bind mounts
return the covering inode number in d_ino, not the covered inode number.

If true, that means mounts are already being checked when returning d_ino,
and suggests that doing it for all mounts isn't expensive.

Is it feasible to return a clear "this is a mount point" indicator in
d_ino and/or d_type?  For example, adding a DT_MOUNTED d_type, or
ORing that into the d_type value (both should be seen be programs as
"I don't know what type that is, I'd better call lstat()").

I agree that inode number without st_dev isn't good for correct code
(but still useful as a performance hint).  But when a program knows
which entries are mountpoints by any method, then it knows the st_dev
of all the other entries is identical to the directory being read.

-- Jamie
