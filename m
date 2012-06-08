Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445Ab2FHUUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:20:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42583 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473Ab2FHUUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:20:08 -0400
Date: Fri, 8 Jun 2012 21:20:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120608202000.GP30000@ZenIV.linux.org.uk>
References: <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk>
 <873966n2c2.fsf@xmission.com>
 <CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com>
 <20120608003604.GK30000@ZenIV.linux.org.uk>
 <20120608005935.GL30000@ZenIV.linux.org.uk>
 <87bokugysl.fsf@xmission.com>
 <20120608054838.GO30000@ZenIV.linux.org.uk>
 <87pq9a9r3b.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pq9a9r3b.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 12:54:00AM -0700, Eric W. Biederman wrote:
> > Please, explain.  link/unlink pair in which sense? 
> 
> In the sense that if we don't use d_move.  A rename will look to
> userspace like a pair of sys_link and sys_unlink operations.
> 
> If I happen to have a file open with the old name and the dentry passes
> through d_drop.  The /proc/self/fd/N will show the filename as
> "...(deleted)".

Um... reality check, please - you were talking about symlinks until now.  Sure,
these days we *can* open them (with O_PATH), but...  And unless I'm misreading
something, none of those sysfs_rename() callers are acting on regular files.

In any case, symlinks or no symlinks, what do you expect to happen if
something in userland does lookup at the old location before anyone gets
around to lookup at the new one?  It's not as if that had been under
kernel control...

> In the little corner case user visible details the current state of vfs
> support for distributed filesystems looks nuts to me, especially where
> we can't apply an appropriate d_move onto a renamed dentry.

Reread your own code, please.  You are *not* guaranteed that lookup triggering
that d_move() of yours will come before ->d_revalidate().  In other words,
the current scheme is not any different in that respect.  And nothing in
userland really cares - scenario is too convoluted.

> Speaking of I just found a small unhandled case in __d_unalias.  We need
> to deny renaming of mount points.

Umm...  Agreed, fix pushed into the same branch.
