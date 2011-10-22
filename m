Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab1JVFj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 01:39:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:40824 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875Ab1JVFjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 01:39:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,390,1315206000"; 
   d="scan'208";a="65187600"
Date: Sat, 22 Oct 2011 13:38:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] writeback: avoid touching dirtied_when on blocked
 inodes
Message-ID: <20111022053851.GA23033@localhost>
References: <20111020152240.751936131@intel.com>
 <20111020232116.GB20542@quack.suse.cz>
 <20111021104049.GA3784@localhost>
 <20111021195448.GA10166@quack.suse.cz>
 <20111022031135.GA4823@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111022031135.GA4823@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 22, 2011 at 11:11:35AM +0800, Wu Fengguang wrote:
> > > btw, with the I_SYNC case converted, it's actually no longer necessary
> > > to keep a standalone b_more_io_wait. It should still be better to keep
> > > the list and the above error check for catching possible errors and
> > > the flexibility of adding policies like "don't retry possible blocked
> > > inodes in N seconds as long as there are other inodes to work with".
> > > 
> > > The below diff only intends to show the _possibility_ to remove
> > > b_more_io_wait:
> >   Good observation. So should we introduce b_more_io_wait in the end? We
> > could always introduce it when the need for some more complicated policy
> > comes...
> > 
> 
> I have no problem removing it if you liked it more. Anyway, let me
> test the idea out first (just kicked off the tests).

When removing b_more_io_wait, performance is slightly dropped
comparing to the full more_io_wait patchset.

3.1.0-rc9-ioless-full-more_io_wait-next-20111014+  3.1.0-rc9-ioless-full-more_io_wait-x-next-20111014+  
------------------------  ------------------------  
                   45.30        +6.3%        48.14  thresh=1G/ext3-1dd-4k-8p-4096M-1024M:10-X
                   48.23        -2.0%        47.27  thresh=1G/ext4-100dd-4k-8p-4096M-1024M:10-X
                   54.21        -2.6%        52.80  thresh=1G/ext4-10dd-4k-8p-4096M-1024M:10-X
                   56.07        -0.3%        55.91  thresh=1G/ext4-1dd-4k-8p-4096M-1024M:10-X
                   45.12        -5.8%        42.49  thresh=1G/xfs-100dd-4k-8p-4096M-1024M:10-X
                   53.94        -1.2%        53.27  thresh=1G/xfs-10dd-4k-8p-4096M-1024M:10-X
                   55.66        -0.1%        55.63  thresh=1G/xfs-1dd-4k-8p-4096M-1024M:10-X
                  358.53        -0.8%       355.51  TOTAL write_bw

I'll try to reduce the changes and retest.

In general it looks better we first root case the "decreasing wrote
pages by writeback_single_inode() over time" problem before looking
into further steps..

Thanks,
Fengguang
