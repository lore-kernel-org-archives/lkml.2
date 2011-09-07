Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab1IGQWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:22:54 -0400
Received: from verein.lst.de ([213.95.11.211]:48494 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab1IGQWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:22:51 -0400
Date: Wed, 7 Sep 2011 08:56:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/18] writeback: fix dirtied pages accounting on
	redirty
Message-ID: <20110907065635.GA12619@lst.de>
References: <20110904015305.367445271@intel.com> <20110904020916.841463184@intel.com> <1315325936.14232.22.camel@twins> <20110907002222.GF31945@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907002222.GF31945@quack.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 02:22:22AM +0200, Jan Kara wrote:
> > So wtf is ext4 doing? Shouldn't a page stay dirty until its written out?
> > 
> > That is, should we really frob around this behaviour or fix ext4 because
> > its on crack?
>   Fengguang, could you please verify your findings with recent kernel? I
> believe ext4 got fixed in this regard some time ago already (and yes, old
> delalloc writeback code in ext4 was terrible).

The pattern we do in writeback is:

in pageout / write_cache_pages:
	lock_page();
	clear_page_dirty_for_io();

in ->writepage:
	set_page_writeback();
	unlock_page();
	end_page_writeback();

So whenever ->writepage decides it doesn't want to write things back
we have to redirty pages.  We have this happen quite a bit in every
filesystem, but ext4 hits it a lot more than usual because it refuses
to write out delalloc pages from plain ->writepage and only allows
->writepages to do it.

