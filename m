Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2FDAHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 20:07:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab2FDAHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 20:07:49 -0400
Date: Sun, 3 Jun 2012 20:07:44 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120604000744.GB14144@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120603223617.GB7707@redhat.com>
 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk>
 <20120603232820.GQ30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120603232820.GQ30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 12:28:20AM +0100, Al Viro wrote:
 > On Mon, Jun 04, 2012 at 12:17:09AM +0100, Al Viro wrote:
 > > 
 > > > Also, sysrq-w is usually way more interesting than 't' when there are
 > > > processes stuck on a mutex.
 > > > 
 > > > Because yes, it looks like you have a boattload of trinity processes
 > > > stuck on an inode mutex. Looks like every single one of them is in
 > > > 'lock_rename()'. It *shouldn't* be an ABBA deadlock, since lockdep
 > > > should have noticed that, but who knows.
 > > 
 > > lock_rename() is a bit of a red herring here - they appear to be all
 > > within-directory renames, so it's just a "trying to rename something
 > > in a directory that has ->i_mutex held by something else".
 > > 
 > > IOW, something else in there is holding ->i_mutex - something that
 > > either hadn't been through lock_rename() at all or has already
 > > passed through it and still hadn't got around to unlock_rename().
 > > In either case, suspects won't have lock_rename() in the trace...
 > 
 > Everything in lock_rename() appears to be at lock_rename+0x3e.  Unless
 > there's a really huge amount of filesystems on that box, this has to
 > be
 >                 mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
 > and everything on that sucker is not holding any locks yet.  IOW, that's
 > the tail hanging off whatever deadlock is there.
 > 
 > One possibility is that something has left the kernel without releasing
 > i_mutex on some directory, which would make atomic_open patches the most
 > obvious suspects.
 > 
 > Which kernel it is and what filesystems are there?  Is there nfsd anywhere
 > in the mix?

Linus tree as of rc1, with 5ceb9ce6fe94 reverted, and a bunch of patches to
shut up noisy printk's that get spewed during fuzz testing.

No active nfs exports/mounts, though something caused nfsd.ko to get loaded
at some point (module use count of 13, weird).

	Dave

