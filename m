Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab1IHIuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:50:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab1IHIuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:50:16 -0400
Subject: Re: [PATCH 17/18] writeback: fix dirtied pages accounting on
 redirty
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110907164619.GA10593@lst.de>
References: <20110904015305.367445271@intel.com>
	 <20110904020916.841463184@intel.com> <1315325936.14232.22.camel@twins>
	 <20110907002222.GF31945@quack.suse.cz> <20110907065635.GA12619@lst.de>
	 <1315383587.11101.18.camel@twins> <20110907164216.GA7725@quack.suse.cz>
	 <20110907164619.GA10593@lst.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 08 Sep 2011 09:51:15 +0100
Message-ID: <1315471875.2814.3.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2011-09-07 at 18:46 +0200, Christoph Hellwig wrote:
> On Wed, Sep 07, 2011 at 06:42:16PM +0200, Jan Kara wrote:
> >   Well, it depends on what you call common - usually, ->writepage is called
> > from kswapd which shouldn't be common compared to writeback from a flusher
> > thread. But now I've realized that JBD2 also calls ->writepage to fulfill
> > data=ordered mode guarantees and that's what causes most of redirtying of
> > pages on ext4. That's going away eventually but it will take some time. So
> > for now writeback has to handle redirtying...
> 
> Under the "right" loads it may also happen for xfs because we can't
> take lock non-blockingly in the fluser thread for example.
> 

GFS2 uses this trick for journaled data pages - the lock ordering is
transaction lock before page lock, so we cannot handle pages which are
already locked before they are handed to the fs if a transaction is
required. So we have our own ->writepages which gets the locks in the
correct order, and ->writepage will simply redirty the page if it would
have required a transaction in order to write out the page,

Steve.


