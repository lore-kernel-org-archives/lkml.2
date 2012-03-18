Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2CRT2E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 15:28:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37704 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab2CRT2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 15:28:02 -0400
Date: Sun, 18 Mar 2012 19:27:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [3.3-rc7] sys_poll use after free (hibernate)
Message-ID: <20120318192755.GB6589@ZenIV.linux.org.uk>
References: <20120313005855.GA24639@redhat.com>
 <CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 12:02:04PM -0700, Linus Torvalds wrote:
> and that load is from
> 
>     poll_wait(filp, &table->poll->wait, wait);
> 
> where the testing of %rsi and %rcx are the "if (p && wait_address)"
> check in poll_wait(), and %rsi is "table->poll" if I read it all
> correctly.
> 
> And the 6b6b6b6b6b6b6b6b pattern is obviously POISON_FREE, so
> apparently 'table' has already been freed.
> 
> I suspect the whole sysctl 'poll' code is seriously broken, since it
> seems to depend on those ctl_table pointers being stable over the
> whole open/close sequence, but if somebody unregisters the sysctl,
> it's all gone. The ctl_table doesn't have any refcounting etc, and I
> suspect that your hibernate sequence ends up unregistering some sysctl
> (perhaps as part of a module unload?)

Ewww...  The way it was supposed to work (prio to ->poll() madness) was
that actual IO gets wrapped into grab_header()/sysctl_head_finish()
pair.  proc_sys_poll() doesn't do it, so yes, that post-mortem is
very likely to be correct.

Looking at that sucker a bit more: what the hell is proc_sys_setattr()
doing with vmtruncate(), of all things???  Unless something has changed
very much and very badly, it does *not* use page cache at all...

Incidentally, I wonder if we want the whole thing in fs/proc; the argument
against splitoff to a separate fs used to be "that would break userland
setups - can't ask people to update /etc/fstab or init scripts to mount
that thing on /proc/sys".  Fair enough, but... what's to stop us from slapping
->d_automount() on /proc/sys like that:
	struct vfsmount *mnt = vfs_kern_mount(&sysctlfs_type, 0, "sysctl", 0);
	if (!IS_ERR(mnt))
		mntget(mnt);
	return mnt;
and we are all set.  IOW, now that ->d_automount() stuff is there, we can
do that easily without any userland breakage.  Comments?
