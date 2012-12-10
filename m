Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab2LJC3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 21:29:21 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:64675 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab2LJC3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 21:29:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgLALBIxVB5LLDt/2dsb2JhbABEhU6zJIV5F3OCHgEBBTocIxAIAw4KLhQlAyETiBC/ExSMK4RDA5YFkEmDBw
Date: Mon, 10 Dec 2012 13:28:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alun <alun.linux@ty-penguin.org.uk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH reduce impact of FIFREEZE on userland processes
Message-ID: <20121210022853.GO15784@dastard>
References: <20121205211707.7ca3b94b@aspire.ty-penguin.org.uk>
 <20121207004255.GC27172@dastard>
 <20121208121204.GA18467@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121208121204.GA18467@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 07:12:04AM -0500, Christoph Hellwig wrote:
> On Fri, Dec 07, 2012 at 11:42:55AM +1100, Dave Chinner wrote:
> > The problem wth doing this is that the sync can delay the freeze
> > process by quite some time under the exact conditions you describe.
> > If you want freeze to take effect immediately (i.e instantly stop
> > new modifications), then adding a sync will break this semantic.
> > THere are existing users of freeze that require this behaviour...
> 
> But that's only because he uses the big hammer sync_filesystem() which
> actually waits for I/O completion.  I agree that this is a bad idea,
> but if we'd just do a writeback_inodes_sb() call in this place that
> starts asynchronous writeout I think everyone would benefit.

The problem with that is that async writeback will block on IO
submission as soon as the disk backs up on congestion. It's
effectively still waiting on IO completions to occur, only now
indirectly through the request queue submission process.

Hence I think for the heavily loaded situations that are causing
freeze latency related issues, sync or async pre-flushes are going
to cause exactly the same delays to freezing writes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
