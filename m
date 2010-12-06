Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab0LFCn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 21:43:58 -0500
Received: from THUNK.ORG ([69.25.196.29]:50560 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab0LFCn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 21:43:56 -0500
Date: Sun, 5 Dec 2010 21:42:31 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Hellwig <hch@lst.de>, linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Tang, Feng" <feng.tang@intel.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 01/13] writeback: IO-less balance_dirty_pages()
Message-ID: <20101206024231.GG4273@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>, Mel Gorman <mel@csn.ul.ie>,
	Rik van Riel <riel@redhat.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Christoph Hellwig <hch@lst.de>, linux-mm <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Tang, Feng" <feng.tang@intel.com>, linux-ext4@vger.kernel.org
References: <20101117042720.033773013@intel.com>
 <20101117042849.410279291@intel.com>
 <1290085474.2109.1480.camel@laptop>
 <20101129151719.GA30590@localhost>
 <1291064013.32004.393.camel@laptop>
 <20101130043735.GA22947@localhost>
 <1291156522.32004.1359.camel@laptop>
 <1291156765.32004.1365.camel@laptop>
 <20101201133818.GA13377@localhost>
 <20101205161435.GA1421@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101205161435.GA1421@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 12:14:35AM +0800, Wu Fengguang wrote:
> 
> Ah I seem to find the root cause. See the attached graphs. Ext4 should
> be calling redirty_page_for_writepage() to redirty ~300MB pages on
> every ~10s. The redirties happen in big bursts, so not surprisingly
> the dd task's dirty weight will suddenly drop to 0.
> 
> It should be the same ext4 issue discussed here:
> 
>         http://www.spinics.net/lists/linux-fsdevel/msg39555.html

Yeah, unfortunately the fix suggested isn't the right one.

The right fix is going to involve making much more radical changes to
the ext4 write submission path, which is on my todo queue.  For now,
if people don't like these nasty writeback dynamics, my suggestion for
now is to mount the filesystem data=writeback.

This is basically the clean equivalent of the patch suggested by Feng
Tang in his e-mail referenced above.  Given that ext4 uses delayed
allocation, most of the time unwritten blocks are not allocated, and
so stale data isn't exposed.

The case which you're seeing here is where both the jbd2 data=order
forced writeback is colliding with the writeback thread, and
unfortunately, the forced writeback in the jbd2 layer is done in an
extremely inefficient manner.  So data=writeback is the workaround,
and unlike ext3, it's not a serious security leak.  It is possible for
some stale data to get exposed if you get unlucky when you crash,
though, so there is a potential for some security exposure.

The long-term solution to this problem is to rework the ext4 writeback
path so that we write the data blocks when they are newly allocated,
and then only update fs metadata once they are written.  As I said,
it's on my queue.  Until then, the only suggestion I can give folks is
data=writeback.

						- Ted
