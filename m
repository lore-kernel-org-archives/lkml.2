Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0LFMgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:36:11 -0500
Received: from THUNK.ORG ([69.25.196.29]:32976 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab0LFMgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:36:07 -0500
Date: Mon, 6 Dec 2010 07:34:48 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Dmitry <dmonakhov@openvz.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
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
Subject: Re: [PATCH 01/13] writeback: IO-less balance_dirty_pages()
Message-ID: <20101206123448.GI4273@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Dmitry <dmonakhov@openvz.org>,
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
References: <1290085474.2109.1480.camel@laptop>
 <20101129151719.GA30590@localhost>
 <1291064013.32004.393.camel@laptop>
 <20101130043735.GA22947@localhost>
 <1291156522.32004.1359.camel@laptop>
 <1291156765.32004.1365.camel@laptop>
 <20101201133818.GA13377@localhost>
 <20101205161435.GA1421@localhost>
 <20101206024231.GG4273@thunk.org>
 <87d3pf6xey.fsf@dmon-lap.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d3pf6xey.fsf@dmon-lap.sw.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 12:52:21PM +0300, Dmitry wrote:
> May be it is reasonable to introduce new mount option which control
> dynamic delalloc on/off behavior for example like this:
> 0) -odelalloc=off : analog of nodelalloc
> 1) -odelalloc=normal : Default mode (disable delalloc if close to full fs)
> 2) -odelalloc=force  : delalloc mode always enabled, so we have to do
>                      writeback more aggressive in case of ENOSPC.
> 
> So one can force delalloc and can safely use this writeback mode in 
> multi-user environment. Openvz already has this. I'll prepare the patch
> if you are interesting in that feature?

Yeah, I'd really rather not do that.  There are significant downsides
with your proposed odelalloc=force mode.  One of which is that we
could run out of space and not notice.  If the application doesn't
call fsync() and check the return value, and simply closes()'s the
file and then exits, when the writeback threads do get around to
writing the file, the block allocation could fail, and oops, data gets
lost.  There's a _reason_ why we disable delalloc when we're close to
a full fs.  The only alternative is to super conservative when doing
your block reservation calculations, and in that case, you end up
returning ENOSPC far too soon.

						- Ted
