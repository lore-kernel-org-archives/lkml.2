Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0LHDHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 22:07:43 -0500
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:44780 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216Ab0LHDHl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 22:07:41 -0500
X-AuditID: 1209190c-b7ba9ae0000009f8-59-4cfef67c121c
Subject: Re: ext4 memory leak?
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20101208024019.GA14424@localhost>
Date: Tue, 7 Dec 2010 22:07:24 -0500
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Hellwig <hch@lst.de>, linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <A9D7CD0F-0A46-4EE6-9454-8689CD3FC03D@MIT.EDU>
References: <20101205064430.GA15027@localhost> <4CFB9BE1.3030902@redhat.com> <20101207131136.GA20366@localhost> <20101207143351.GA23377@localhost> <20101207152120.GA28220@localhost> <20101207163820.GF24607@thunk.org> <20101208024019.GA14424@localhost>
To: Wu Fengguang <fengguang.wu@intel.com>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 7, 2010, at 9:40 PM, Wu Fengguang wrote:

> Here is the full data collected with "mem=512M", where the reclaimable
> memory size still declines slowly. slabinfo is also collected.
> 
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/tests/512M/ext4-10dd-1M-8p-442M-2.6.37-rc4+-2010-12-08-09-19/
> 
> The increase of nr_slab_reclaimable roughly equals to the decrease of
> nr_dirty_threshold. So it may be either the VM not able to reclaim the
> slabs fast enough, or the slabs are not reclaimable at the time.

Can you try running this with CONFIG_SLAB instead of the SLUB allocator?   One of the things I hate about the SLUB allocator is it tries too hard to prevent cache line ping-pong effects, which is fine if you have lots of memory, but if you have 8 processors and memory constrained to 256 megs, I suspect it doesn't work too well because it leaves too many slabs allocated so that every single CPU has its own portion of the slab cache.   In the case of slabs like ext4_io_end, which is 8 pages per slab, if you have 8 cpu's, and memory constrained down to 256 megs, memory starts getting wasted like it was going out of style.

Worse yet, with the SLUB allocator, you can't trust the number of active objects (I've had cases where it would swear up and down that all 16000 out of 16000 objects were in use, but then I'd run "slabinfo -s", and all of the slabs would be shrunk down to zero.  Grrr.... I wasted a lot of time looking for a memory leak before I realized that you can't trust # of active objects information in /proc/slabinfo when you enable CONFIG_SLUB.)

-- Ted



