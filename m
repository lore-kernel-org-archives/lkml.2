Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab0H0FNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 01:13:23 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:51549 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753381Ab0H0FNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 01:13:21 -0400
Date: Fri, 27 Aug 2010 15:13:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] writeback: Do not congestion sleep when there are
 no congested BDIs
Message-ID: <20100827051316.GH705@dastard>
References: <1282835656-5638-1-git-send-email-mel@csn.ul.ie>
 <1282835656-5638-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282835656-5638-4-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 04:14:16PM +0100, Mel Gorman wrote:
> If congestion_wait() is called with no BDIs congested, the caller will
> sleep for the full timeout and this is an unnecessary sleep.

That, I think, is an invalid assumption. congestion_wait is used in
some places as a backoff mechanism that waits for some IO work to be
done, with congestion disappearing being a indication that progress
has been made and so we can retry sooner than the entire timeout.

For example, if _xfs_buf_lookup_pages() fails to allocate page cache
pages for a buffer, it will kick the xfsbufd to writeback dirty
buffers (so they can be freed) and immediately enter
congestion_wait(). If there isn't congestion when we enter
congestion_wait(), we still want to give the xfsbufds a chance to
clean some pages before we retry the allocation for the new buffer.
Removing the congestion_wait() sleep behaviour will effectively
_increase_ memory pressure with XFS on fast disk subsystems because
it now won't backoff between failed allocation attempts...

Perhaps a congestion_wait_iff_congested() variant is needed for the
VM? I can certainly see how it benefits the VM from a latency
perspective, but it is the opposite behaviour that is expected in
other places...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
