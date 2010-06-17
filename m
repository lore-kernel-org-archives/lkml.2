Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760676Ab0FQTLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 15:11:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757354Ab0FQTLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 15:11:12 -0400
Date: Thu, 17 Jun 2010 15:10:26 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Andreas Dilger <adilger@sun.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] d_ino considered harmful
Message-ID: <20100617191026.GE14389@shell>
References: <20100616185913.GA15566@shell> <20100616195359.GA24382@shell> <20100617175429.GC4979@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617175429.GC4979@shareable.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 06:54:29PM +0100, Jamie Lokier wrote:
> Valerie Aurora wrote:
> >> Who needs d_ino anyway?  I am running a kernel with this patch -
> >> Gnome, a browser, IRC, kernel compile, etc. and everything works.
> > I'm running a kernel with the below patch and everything still works.
> > Apparently "ls -i" is still using the bogus d_ino performance
> > improvement mentioned here because it returns all 1's for inode
> > number.
> 
> I'm surprised at "ls -i", as a patch to change that has been submitted:
> 
>     http://marc.info/?l=linux-kernel&m=125181054102075
>     http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/17887

I was surprised too.  I guess people still want to optimize ls -i,
even at the cost of wrong results.

> >     Use of d_ino without the corresponding st_dev is always buggy in the
> >     presence of submounts, bind mounts, and union mounts.  E.g., the d_ino
> >     of a mountpoint will be the inode number of the directory under the
> >     mountpoint, not the mounted directory.
> 
> It's not surprising everything seems to work.
> 
> It can be useful as a performance hint, which you probably didn't test.

I'm afraid I wasn't entirely serious with that patch. :) But it was an
interesting exercise.

> I strongly disagree that correct code must call stat().  Correct code
> can check against the list of mountpoints in /proc/mounts, because it
> is strictly only mountpoints where the number doesn't agree with
> stat() -- prior to your patch :-)

If you are assuming that the application is parsing /proc/mounts (does
anyone actually do this?), then the application can also learn about
union mounts and not trust d_ino in any directory below the union
mount point. :)

> Anyway, maybe your patch is not allowed by POSIX :-) as follows
> (posted to linux-kernel some time ago):
> 
>     http://marc.info/?l=linux-kernel&m=125181054102075
>     http://www.gossamer-threads.com/lists/linux/kernel/1124140
> 
>     The POSIX readdir spec says this:
> 
> 	The structure dirent defined in the <dirent.h> header describes a
> 	directory entry. The value of the structure's d_ino member shall be set
> 	to the file serial number of the file named by the d_name member.
> 
>     The description for sys/stat.h makes the connection between
>     "file serial number" and the stat.st_ino member:
> 
> 	The <sys/stat.h> header shall define the stat structure, which shall
> 	include at least the following members:
> 	...
> 	    ino_t st_ino                File serial number.
> 
> Returning the covered inode's number at a mountpoint is apparently not
> POSIX compliant either, but is widespread.  (I.e. all unixes except
> Cygwin apparently.)
> 
> > Gosh, maybe it would help to patch the currently used readdir instead
> > of just old_readdir() (thanks, Arnd).  And return 1 instead of 0 so ls
> > doesn't think all files are deleted (thanks, Andreas).
> 
> It's not just ls.  Bash 3.0 ignores entries for completion if d_ino == 0.
> 
> > I'm running a kernel with the below patch and everything still works.
> > Apparently "ls -i" is still using the bogus d_ino performance
> > improvement mentioned here because it returns all 1's for inode
> > number.
> > 
> > http://www.mail-archive.com/bug-findutils@gnu.org/msg02531.html
> 
> I'm intrigued by the mentioned in that report that Linux bind mounts
> return the covering inode number in d_ino, not the covered inode number.
> 
> If true, that means mounts are already being checked when returning d_ino,
> and suggests that doing it for all mounts isn't expensive.

This surprises me too.  I will check into it further.

-VAL
