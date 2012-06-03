Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2FCX2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 19:28:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50679 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2FCX2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 19:28:22 -0400
Date: Mon, 4 Jun 2012 00:28:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120603232820.GQ30000@ZenIV.linux.org.uk>
References: <20120603223617.GB7707@redhat.com>
 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120603231709.GP30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 12:17:09AM +0100, Al Viro wrote:
> 
> > Also, sysrq-w is usually way more interesting than 't' when there are
> > processes stuck on a mutex.
> > 
> > Because yes, it looks like you have a boattload of trinity processes
> > stuck on an inode mutex. Looks like every single one of them is in
> > 'lock_rename()'. It *shouldn't* be an ABBA deadlock, since lockdep
> > should have noticed that, but who knows.
> 
> lock_rename() is a bit of a red herring here - they appear to be all
> within-directory renames, so it's just a "trying to rename something
> in a directory that has ->i_mutex held by something else".
> 
> IOW, something else in there is holding ->i_mutex - something that
> either hadn't been through lock_rename() at all or has already
> passed through it and still hadn't got around to unlock_rename().
> In either case, suspects won't have lock_rename() in the trace...

Everything in lock_rename() appears to be at lock_rename+0x3e.  Unless
there's a really huge amount of filesystems on that box, this has to
be
                mutex_lock_nested(&p1->d_inode->i_mutex, I_MUTEX_PARENT);
and everything on that sucker is not holding any locks yet.  IOW, that's
the tail hanging off whatever deadlock is there.

One possibility is that something has left the kernel without releasing
i_mutex on some directory, which would make atomic_open patches the most
obvious suspects.

Which kernel it is and what filesystems are there?  Is there nfsd anywhere
in the mix?
