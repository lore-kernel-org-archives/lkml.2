Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0DMBVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:21:17 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:49757 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754522Ab0DMBUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:20:51 -0400
Date: Mon, 12 Apr 2010 10:47:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Denys Fedorysychenko <nuclearcat@nuclearcat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Message-ID: <20100412004738.GC2493@dastard>
References: <201003311907.31342.nuclearcat@nuclearcat.com>
 <20100408092850.GA20488@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408092850.GA20488@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 11:28:50AM +0200, Jan Kara wrote:
> On Wed 31-03-10 19:07:31, Denys Fedorysychenko wrote:
> > I have a proxy server with "loaded" squid. On some moment i did sync, and 
> > expecting it to finish in reasonable time. Waited more than 30 minutes, still 
> > "sync". Can be reproduced easily.
....
> > 
> > SUPERPROXY ~ # cat /proc/1753/stack
> > [<c019a93c>] bdi_sched_wait+0x8/0xc
> > [<c019a807>] wait_on_bit+0x20/0x2c
> > [<c019a9af>] sync_inodes_sb+0x6f/0x10a
> > [<c019dd53>] __sync_filesystem+0x28/0x49
> > [<c019ddf3>] sync_filesystems+0x7f/0xc0
> > [<c019de7a>] sys_sync+0x1b/0x2d
> > [<c02f7a25>] syscall_call+0x7/0xb
> > [<ffffffff>] 0xffffffff
>   Hmm, I guess you are observing the problem reported in
> https://bugzilla.kernel.org/show_bug.cgi?id=14830
>   There seem to be several issues in the per-bdi writeback code that
> cause sync on a busy filesystem to last almost forever. To that bug are
> attached two patches that fix two issues but apparently it's not all.
> I'm still looking into it...

Jan, just another data point that i haven't had a chance to look
into yet - I noticed that 2.6.34-rc1 writeback patterns have changed
on XFS from looking at blocktrace.

The bdi-flush background write threadi almost never completes - it
blocks in get_request() and it is doing 1-2 page IOs. If I do a
large dd write, the writeback thread starts with 512k IOs for a
short while, then suddenly degrades to 1-2 page IOs that get merged
in the elevator to 512k IOs.

My theory is that the inode is getting dirtied by the concurrent
write() and the inode is never moving back to the dirty list and
having it's dirtied_when time reset  - it's being moved to the
b_more_io list in writeback_single_inode(), wbc->more_io is being
set, and then we re-enter writeback_inodes_wb() which splices the
b_more_io list back onto the b_io list and we try to write it out
again.

Because I have so many dirty pages in memory, nr_pages is quite high
and this pattern continues for some time until it is exhausted, at
which time throttling triggers background sync to run again and the
1-2 page IO pattern continues.

And for sync(), nr_pages is set to LONG_MAX, so regardless of how
many pages were dirty, if we keep dirtying pages it will stay in
this loop until LONG_MAX pages are written....

Anyway, that's my theory - if we had trace points in the writeback
code, I could confirm/deny this straight away. First thing I need to
do, though, is to forward port the original writeback tracng code
Jens posted a while back....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
