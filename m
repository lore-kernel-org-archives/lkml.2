Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1D3D2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 23:28:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48348 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946Ab1D3D2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 23:28:06 -0400
Date: Sat, 30 Apr 2011 04:27:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>, Dave Chinner <dchinner@redhat.com>,
        werner <w.landgraf@ru.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110430032759.GK9487@ZenIV.linux.org.uk>
References: <web-515866242@zbackend1.aha.ru>
 <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com>
 <20110430025545.GI9487@ZenIV.linux.org.uk>
 <20110430030243.GJ9487@ZenIV.linux.org.uk>
 <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 08:09:16PM -0700, Linus Torvalds wrote:
> On Fri, Apr 29, 2011 at 8:02 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Wait a bit; _can_ we get there with non-NULL ->s_master_inode et.al.?
> > iput(NULL) is a noop... ?I don't think so, since logfs_init_journal()
> > is not called until after we initialize that list.
> >
> > Not that I'd object against taking that initialization earlier, of course,
> > but there seems to be something else going on... ?Which iput() it is?
> 
> Not something I can guess from the oops, sadly. Gcc has inlined
> everything into logfs_mount, and the "0x44f/0x5cc" offset isn't very
> helpful (with the same compiler version and config options it would be
> possible to figure it out).
> 
> But looking at it, logfs_init_mapping() is currently called before
> "s_freeing_list" is initialized, and it sets up at least
> s_mapping_inode. So if anything fails between that point and the point
> where we initialize s_freeing_list, I think we're toast.
> 
> I didn't check the other inodes, but at least that one does seem to be
> potentially non-NULL. No?

Ho-hum...  Point.  Let's take that initialization up to the beginning of
logfs_read_sb(), see if oops goes away and then try to figure out WTF
we hadn't been seeing it all along.  I don't see anything recent affecting
that area, but then logfs goes through many odd places during mount (including,
IIRC, mtd).  So there might be many sources of the failure where we used to
have none and failure in that spot would, indeed, fuck the things up that
way...

In any case, taking that initialization to the beginning of logfs_read_sb()
(if not up to its only caller where we set ->s_op et.al. anyway) seems to be
the obviously right thing to do.  Unless logfs folks have some subtle
objections?
