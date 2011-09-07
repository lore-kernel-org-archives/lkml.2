Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab1IGQeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:34:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:38314 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab1IGQdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:33:37 -0400
Subject: Re: [PATCH 17/18] writeback: fix dirtied pages accounting on redirty
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 07 Sep 2011 10:19:47 +0200
In-Reply-To: <20110907065635.GA12619@lst.de>
References: <20110904015305.367445271@intel.com>
	 <20110904020916.841463184@intel.com> <1315325936.14232.22.camel@twins>
	 <20110907002222.GF31945@quack.suse.cz> <20110907065635.GA12619@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315383587.11101.18.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 08:56 +0200, Christoph Hellwig wrote:
> On Wed, Sep 07, 2011 at 02:22:22AM +0200, Jan Kara wrote:
> > > So wtf is ext4 doing? Shouldn't a page stay dirty until its written out?
> > > 
> > > That is, should we really frob around this behaviour or fix ext4 because
> > > its on crack?
> >   Fengguang, could you please verify your findings with recent kernel? I
> > believe ext4 got fixed in this regard some time ago already (and yes, old
> > delalloc writeback code in ext4 was terrible).
> 
> The pattern we do in writeback is:
> 
> in pageout / write_cache_pages:
> 	lock_page();
> 	clear_page_dirty_for_io();
> 
> in ->writepage:
> 	set_page_writeback();
> 	unlock_page();
> 	end_page_writeback();
> 
> So whenever ->writepage decides it doesn't want to write things back
> we have to redirty pages.  We have this happen quite a bit in every
> filesystem, but ext4 hits it a lot more than usual because it refuses
> to write out delalloc pages from plain ->writepage and only allows
> ->writepages to do it.

Ah, right, so it is a fairly common thing and not something easily fixed
in filesystems.

Ok so I guess the patch is good. Thanks!
