Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab0DSBhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 21:37:37 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:50818 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753866Ab0DSBhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 21:37:35 -0400
Date: Mon, 19 Apr 2010 11:37:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Denys Fedorysychenko <nuclearcat@nuclearcat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Message-ID: <20100419013702.GE2520@dastard>
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

So Jen's writeback tracing shows this for a normal cycle during a
large dd:

           <...>-6030  [005] 604446.696454: writeback_sched: work=38c0, task=task
    flush-253:16-6029  [002] 604446.696492: writeback_exec: work=38c0 pages=9223372036854775807, sb=0, kupdate=0, range_cyclic=-1 for_background=-1
    flush-253:16-6029  [002] 604446.696493: writeback_clear: work=ffff88011f1a38c0, refs=1
    flush-253:16-6029  [003] 604446.784240: writeback_pages_written: 1024

There were 100 of these traces (102400 pages (400MB) which is exactly 10% of
RAM) before this:

           <...>-6030  [000] 604462.346329: writeback_sched: work=6c0, task=task
    flush-253:16-6029  [002] 604462.267098: writeback_exec: work=6c0 pages=9223372036854775807, sb=0, kupdate=0, range_cyclic=-1 for_background=-1
    flush-253:16-6029  [002] 604462.267101: writeback_clear: work=ffff88011e8006c0, refs=1
    flush-253:16-6029  [001] 604465.406331: writeback_pages_written: 160771

which shows 160771 pages written in a single iteration (650MB). I suspect some
interaction between foreground and background writeout is occurring here.

The flusher thread appears to be getting stuck on congestion - the wchan
it is sitting on indicates it is blocking in get_request().  I'm going to
extend this tracing further down into the writeback code so that what is
happening is clearer...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
