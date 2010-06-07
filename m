Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab0FGTdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:33:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:48798 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0FGTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:32:58 -0400
Subject: Re: [git pull] drm fixes
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1006070404510.29029@skynet.skynet.ie>
	 <alpine.LFD.2.00.1006071057300.3515@i5.linux-foundation.org>
	 <20100607182640.GL31073@ZenIV.linux.org.uk>
	 <alpine.LFD.2.00.1006071146451.3515@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 20:32:45 +0100
Message-ID: <1275939165.17903.5100.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 11:53 -0700, Linus Torvalds wrote:
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
> 
> So I think it's a judgement call.

The fix is fairly trivial. There's a "big" patch to fs/jffs2/dir.c which
accounts for the bulk of my pull request, but if you look harder you'll
see it's mostly just a bunch of removing 'return ret;' and adding 
'goto fail;' so the error cleanup happens properly.

Al pointed out a second problem at the same time, fixed by commit
e72e6497 in the tree I asked you to pull. That involved adding an
unlock_new_inode() to the same error paths that the first patch used.

Between the two bugs, I figured it was worth pushing the fixes for
2.6.35.

The third jffs2 patch in that tree is a fix for ctime semantics which is
a two-liner. Again not a regression but worth fixing, and -stable
fodder.

Al also pointed out that I could use iget_failed(), but I figured that
cleanup could wait for 2.6.36.

> I seem to have a jffs2 pull request that I haven't yet processed, exactly 
> because it wasn't clear. It's much bigger than I would have wished for, 
> and it's not clear it's all regressions at all.
> 
> DavidW? It's
> 
> 	 7 files changed, 107 insertions(+), 91 deletions(-)
> 
> and while that's in the size range that I didn't just reject it like the 
> drm pull, I still do want to know if that's really just true major 
> bugfixes and regressions.

 Documentation/DocBook/mtdnand.tmpl |    2 +-
 drivers/mtd/mtdchar.c              |   11 +--
 drivers/mtd/nand/Kconfig           |   21 +++---
 drivers/mtd/nand/r852.c            |   27 +++++---
 fs/jffs2/acl.c                     |    3 +-
 fs/jffs2/dir.c                     |  127 +++++++++++++++++++-----------------
 fs/jffs2/fs.c                      |    7 ++-
 7 files changed, 107 insertions(+), 91 deletions(-)

The patches to r852 are fixing the fact that suspend/resume wasn't
working. Not strictly a regression, as it's a new driver in 2.6.35 --
but I judged that it was best to fix it.

The Kconfig patch fixes a problem with the menu nesting, introduced with
the SmartMedia support. That one is a regression.

I'll concede that I could probably have lived without the DocBook patch,
and the patch to use memdup_user() in mtdchar.c, but they're so trivial
that it seemed pointless rebasing the tree to exclude them once I
concluded I should to try my luck at getting the other stuff into -rc2.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

