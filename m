Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119Ab1ESX3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:29:15 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1248 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933315Ab1ESX3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:29:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsADABak1U15LCoegWdsb2JhbACmFxUBARYmJcZ7DoMJgwIElzyHXA
Date: Fri, 20 May 2011 09:29:10 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/18] writeback: make writeback_control.nr_to_write
 straight
Message-ID: <20110519232910.GK32466@dastard>
References: <20110519214530.939830917@intel.com>
 <20110519214746.038765568@intel.com>
 <20110519220643.GA27247@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519220643.GA27247@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 06:06:44AM +0800, Wu Fengguang wrote:
> :                 writeback_single_inode(inode, wb, &wbc);
> :                 work->nr_pages -= write_chunk - wbc.nr_to_write;
> :                 wrote += write_chunk - wbc.nr_to_write;
> :                 if (wbc.pages_skipped) {
> :                         /*
> :                          * writeback is not making progress due to locked
> :                          * buffers.  Skip this inode for now.
> :                          */
> :                         redirty_tail(inode, wb);
> : -               }
> : +               } else if (!(inode->i_state & I_DIRTY))
> : +                       wrote++;
> 
> It looks a bit more clean to do
> 
> :                 wrote += write_chunk - wbc.nr_to_write;
> : +               if (!(inode->i_state & I_DIRTY))
> : +                       wrote++;
> :                 if (wbc.pages_skipped) {
> :                         /*
> :                          * writeback is not making progress due to locked
> :                          * buffers.  Skip this inode for now.
> :                          */
> :                         redirty_tail(inode, wb);
> :                 }

But it's still in the wrong place - such post-write inode dirty
processing is supposed to be isolated to writeback_single_inode().
Spreading it across multiple locations is not, IMO, the nicest thing
to do...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
