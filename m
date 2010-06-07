Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab0FGTIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:08:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59153 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab0FGTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:08:42 -0400
Date: Mon, 7 Jun 2010 20:08:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm fixes
Message-ID: <20100607190837.GM31073@ZenIV.linux.org.uk>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
 <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
 <20100607182640.GL31073@ZenIV.linux.org.uk>
 <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 11:53:28AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 7 Jun 2010, Al Viro wrote:
> > 
> > Ho-hum...  Speaking of which, what about leak fixes?  There's a long-standing
> > in-core inode leak in jffs2; basically, if you fail directory modification
> > in symlink() et.al., you get a leaked inode and whinge at umount.  Found
> > after -rc1, had been there since all the way back (similar bug in creat()
> > had been fixed in 2003, mkdir()/mknod()/symlink() were not).  Fix sits in
> > jffs2-fixes now...
> 
> I think a leak that is trivial easily falls under "security issue" as a 
> potential DoS issue.
> 
> On the other hand, if it's not trivially fixed (say it needs big 
> re-organizing of some locking or refcounting or whatever), and it's a 
> really slow leak of a pretty small data structure, and is not triggered by 
> normal users (say, you need to mount a filesystem or it needs some very 
> specific timing), I think it falls under "we haven't seen in the previous 
> five years, we might as well make sure the fix is tested in the next merge 
> window".

You need something like IO errors or device being full to trigger it.
As for the fix, it's basically a matter of "set i_nlink to 0 and iput()
instead of manual jffs2_clear_inode(); sure, you want to kill the on-disk
inode, but you want in-core one gone too".

Basically, that's what all local filesystems are doing to clean up after
such error and that's what jffs2 is doing for ->create().

As for the other stuff in that tree...  There's a fix for nfsd/create race
(rather narrow and not trivial to hit, but capable of fs corruption) and
there's mtd stuff I've no fscking clue about.

If not for the mtd part I'd simply pulled it in my tree.  As it is...  I
still can do that (done that for current semi-private branch), but I'd
prefer to avoid feeding mtd stuff through vfs tree, for all the obvious
reasons.
