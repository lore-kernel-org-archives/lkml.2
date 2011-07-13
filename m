Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965174Ab1GMLTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:19:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964915Ab1GMLTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:19:32 -0400
Date: Wed, 13 Jul 2011 13:19:28 +0200
From: Jan Kara <jack@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] writeback: remove writeback_control.more_io
Message-ID: <20110713111928.GA21787@quack.suse.cz>
References: <20110607213236.634026193@intel.com>
 <20110607213854.888623315@intel.com>
 <alpine.LSU.2.00.1107111408060.13830@sister.anvils>
 <20110712062013.GA4654@localhost>
 <alpine.LSU.2.00.1107121207540.1752@sister.anvils>
 <alpine.LSU.2.00.1107122234460.3608@sister.anvils>
 <alpine.LSU.2.00.1107130350570.4184@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1107130350570.4184@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 13-07-11 03:57:40, Hugh Dickins wrote:
> On Tue, 12 Jul 2011, Hugh Dickins wrote:
> > On Tue, 12 Jul 2011, Hugh Dickins wrote:
> > > On Mon, 11 Jul 2011, Wu Fengguang wrote:
> > > > 
> > > > It's relatively easy to confirm, by reusing the below trace event to
> > > > show the inode (together with its state) being requeued.
> > > > 
> > > > If this is the root cause, it may equally be fixed by
> > > > 
> > > > -			requeue_io(inode, wb);
> > > > +			redirty_tail(inode, wb);
> > > > 
> > > > which would be useful in case the bug is so deadly that it's no longer
> > > > possible to do tracing.
> > > 
> > > I checked again this morning that I could reproduce it on two machines,
> > > one went in a few minutes, the other within the hour.  Then I made that
> > > patch changing the requeue_io to redirty_tail, and left home with them
> > > running the test with the new kernel: we'll see at the end of the day
> > > how they fared.
> > 
> > I think that fixes it.  The x86_64 is still running with that, but the
> > ppc64 gave up fairly early, hitting freeze in __slab_free() instead.
> > 
> > I've now, I believe, reconstituted what ChristophL intended from the
> > mm_types.h struct page patch he posted (which applied neither to mmotm,
> > nor to Pekka's for-next, so far as I could tell: maybe cl did some
> > intermediate tidying of some of the random indentation).  So now
> > testing that with redirty_tail on ppc64: will report in 9 hours.
> 
> Same result as before.  The x86_64 is still going fine, but the ppc64
> again seized up in __slab_free() after two and a half hours of load.
> 
> I think we should assume that your -requeue_io +redirty_tail is a good
> fix for the writeback freeze (if you can reassure us, that it does not
> risk postponing some writes indefinitely), and I move over to the other
> thread to pursue the struct page __slab_free() freeze.
  Well, I_FREEING or I_WILL_FREE inodes are written back by iput_final()
and it is reclaim code that is responsible for eventually removing them. So
writeback code can safely ignore them. I_NEW inodes should move out of this
state when they are fully set up and in the writeback round following that,
we will consider them for writeback. So I think the change really makes
sense.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
