Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2FCX7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 19:59:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60938 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab2FCX7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 19:59:07 -0400
Date: Mon, 4 Jun 2012 00:59:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120603235904.GS30000@ZenIV.linux.org.uk>
References: <20120603223617.GB7707@redhat.com>
 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk>
 <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120603234042.GR30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120603234042.GR30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 12:40:42AM +0100, Al Viro wrote:
> On Mon, Jun 04, 2012 at 12:28:20AM +0100, Al Viro wrote:
> 
> > Everything in lock_rename() appears to be at lock_rename+0x3e.  Unless
> > there's a really huge amount of filesystems on that box, this has to
> > be
> >                 mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
> > and everything on that sucker is not holding any locks yet.  IOW, that's
> > the tail hanging off whatever deadlock is there.
> 
> Er...  After another look, probably not - it's ->s_vfs_rename_mutex,
> so we are seeing one cross-directory rename stuck on something with
> all subsequent ones blocked on attempt to grab said mutex.
> 
> The interesting one is the guy stuck at lock_rename+0xc9/0xf0, everything
> else in lock_rename() is the consequence.

BTW, another suspicious patch is d_splice_alias() one; note that if we
_ever_ pick a dentry that isn't disconnected, we are deeply fucked.
d_move() without the old parent locked is a Bad Thing(tm).  I don't see
how that could've triggered without another bug somewhere, but what's
happening in d_splice_alias() right now is wrong.
