Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1IGQmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:42:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab1IGQm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:42:29 -0400
Date: Wed, 7 Sep 2011 18:42:16 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/18] writeback: fix dirtied pages accounting on
 redirty
Message-ID: <20110907164216.GA7725@quack.suse.cz>
References: <20110904015305.367445271@intel.com>
 <20110904020916.841463184@intel.com>
 <1315325936.14232.22.camel@twins>
 <20110907002222.GF31945@quack.suse.cz>
 <20110907065635.GA12619@lst.de>
 <1315383587.11101.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315383587.11101.18.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-09-11 10:19:47, Peter Zijlstra wrote:
> On Wed, 2011-09-07 at 08:56 +0200, Christoph Hellwig wrote:
> > On Wed, Sep 07, 2011 at 02:22:22AM +0200, Jan Kara wrote:
> > > > So wtf is ext4 doing? Shouldn't a page stay dirty until its written out?
> > > > 
> > > > That is, should we really frob around this behaviour or fix ext4 because
> > > > its on crack?
> > >   Fengguang, could you please verify your findings with recent kernel? I
> > > believe ext4 got fixed in this regard some time ago already (and yes, old
> > > delalloc writeback code in ext4 was terrible).
> > 
> > The pattern we do in writeback is:
> > 
> > in pageout / write_cache_pages:
> > 	lock_page();
> > 	clear_page_dirty_for_io();
> > 
> > in ->writepage:
> > 	set_page_writeback();
> > 	unlock_page();
> > 	end_page_writeback();
> > 
> > So whenever ->writepage decides it doesn't want to write things back
> > we have to redirty pages.  We have this happen quite a bit in every
> > filesystem, but ext4 hits it a lot more than usual because it refuses
> > to write out delalloc pages from plain ->writepage and only allows
> > ->writepages to do it.
> 
> Ah, right, so it is a fairly common thing and not something easily fixed
> in filesystems.
  Well, it depends on what you call common - usually, ->writepage is called
from kswapd which shouldn't be common compared to writeback from a flusher
thread. But now I've realized that JBD2 also calls ->writepage to fulfill
data=ordered mode guarantees and that's what causes most of redirtying of
pages on ext4. That's going away eventually but it will take some time. So
for now writeback has to handle redirtying...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
