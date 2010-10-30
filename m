Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0J3DTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 23:19:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab0J3DTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 23:19:34 -0400
Date: Fri, 29 Oct 2010 20:18:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Engelhardt <jengelh@medozas.de>, Jan Kara <jack@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Greg KH <gregkh@suse.de>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Sync writeback still broken
Message-Id: <20101029201835.c79348da.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikEpV7GWG9fd3=zfrhOZtbPvxJWfXAO30iN8aae@mail.gmail.com>
References: <20100212091609.GB1025@kernel.dk>
	<alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
	<alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
	<20100215144938.GD3434@quack.suse.cz>
	<alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
	<alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
	<alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
	<AANLkTikBmewDmBJWHzdTerJE2W4GqRYMxLCdAJyz5JDB@mail.gmail.com>
	<AANLkTikEpV7GWG9fd3=zfrhOZtbPvxJWfXAO30iN8aae@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010 18:16:48 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Oct 29, 2010 at 5:57 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Guys, what is the status of this?
> >
> > The original patch in that email thread still makes no sense and the
> > commit log for it cannot be the real issue. But the _problem_ seems to
> > be real, and the code is apparently a total mess, still.
> 
> Btw, is the problem just that insane WB_SYNC_ALL thing?
> 
> The problem with WB_SYNC_ALL seems to be that it synchrnously writes
> out one inode at a time. And it's not just the data, it's the inode
> itself.
> 
> So rather than write out all pages for _all_ inodes, and then wait for
> them, and write out _all_ metadata, and then wait for that, it seems
> like the WB_SYNC_ALL code does the truly stupid thing, which is to
> "write out some data for one inode, then _synchronously_ wait for
> that, then write out the metadata for that single inode, then
> _synchronously_ wait for THAT" and then rinse and repeat for each
> inode.
> 
> The sane thing for "WB_SYNC_ALL" would be to:
>  - for_each_inode: write out all data (no waiting)
>  - for_each_inode: wait for the data for that inode, write out the inode
>  - for_each_inode: wait for the inode
> 
> so that you avoid the whole synchronous wait thing, and can do all
> inodes in one go.

The way I originally implemented all this was that the top level would
do two passes.  The first was as async as possible, to get lots of IO
underway against lots of devices.  Then the second pass was WB_SYNC_ALL
to get any straggler IO started and then to wait on everything.  eg
(2.6.20):

static void do_sync(unsigned long wait)
{
	wakeup_pdflush(0);
	sync_inodes(0);		/* All mappings, inodes and their blockdevs */
	DQUOT_SYNC(NULL);
	sync_supers();		/* Write the superblocks */
	sync_filesystems(0);	/* Start syncing the filesystems */
	sync_filesystems(wait);	/* Waitingly sync the filesystems */
	sync_inodes(wait);	/* Mappings, inodes and blockdevs, again. */
	if (!wait)
		printk("Emergency Sync complete\n");
	if (unlikely(laptop_mode))
		laptop_sync_completion();
}


note the two sync_inodes() calls and the two sync_filesystems() calls.

This used to work reasonably well.  Maybe it got broken, who knows.


