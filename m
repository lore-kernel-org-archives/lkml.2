Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2LKIXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:23:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:24227 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab2LKIXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:23:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,256,1355126400"; 
   d="scan'208";a="260375460"
Date: Tue, 11 Dec 2012 16:23:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Jones <davej@redhat.com>, linux-mm@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org
Subject: Re: livelock in __writeback_inodes_wb ?
Message-ID: <20121211082327.GA15706@localhost>
References: <20121128145515.GA26564@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121128145515.GA26564@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 09:55:15AM -0500, Dave Jones wrote:
> We had a user report the soft lockup detector kicked after 22
> seconds of no progress, with this trace..

Where is the original report? The reporter may help provide some clues
on the workload that triggered the bug.

> :BUG: soft lockup - CPU#1 stuck for 22s! [flush-8:16:3137]
> :Pid: 3137, comm: flush-8:16 Not tainted 3.6.7-4.fc17.x86_64 #1
> :RIP: 0010:[<ffffffff812eeb8c>]  [<ffffffff812eeb8c>] __list_del_entry+0x2c/0xd0
> :Call Trace:
> : [<ffffffff811b783e>] redirty_tail+0x5e/0x80
> : [<ffffffff811b8212>] __writeback_inodes_wb+0x72/0xd0
> : [<ffffffff811b980b>] wb_writeback+0x23b/0x2d0
> : [<ffffffff811b9b5c>] wb_do_writeback+0xac/0x1f0
> : [<ffffffff8106c0e0>] ? __internal_add_timer+0x130/0x130
> : [<ffffffff811b9d2b>] bdi_writeback_thread+0x8b/0x230
> : [<ffffffff811b9ca0>] ? wb_do_writeback+0x1f0/0x1f0
> : [<ffffffff8107fde3>] kthread+0x93/0xa0
> : [<ffffffff81627e04>] kernel_thread_helper+0x4/0x10
> : [<ffffffff8107fd50>] ? kthread_freezable_should_stop+0x70/0x70
> : [<ffffffff81627e00>] ? gs_change+0x13/0x13
> 
> Looking over the code, is it possible that something could be
> dirtying pages faster than writeback can get them written out,
> keeping us in this loop indefitely ?

The bug reporter should know best whether there are heavy IO.

However I suspect it's not directly caused by heavy IO: we will
release &wb->list_lock before each __writeback_single_inode() call,
which starts writeback IO for each inode.

> Should there be something in this loop periodically poking
> the watchdog perhaps ?

It seems we failed to release &wb->list_lock in wb_writeback() for
long time (dozens of seconds). That is, the inode_sleep_on_writeback()
is somehow not called. However it's not obvious to me how come this
can happen..

Thanks,
Fengguang
