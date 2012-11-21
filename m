Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab2KUEPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 23:15:51 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:37420 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748Ab2KUEPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 23:15:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnIIAB9VrFB5LbLL/2dsb2JhbABEvFSCEoNvF3OCHgEBBScTHCMQCAMOCi4UJQMhE4d7AwYItUMMiVUUjCCEYgOVfZBCgwM
Date: Wed, 21 Nov 2012 14:59:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: trace filemap add and del
Message-ID: <20121121035924.GO2591@dastard>
References: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
 <20121120155735.905bbf9e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120155735.905bbf9e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 03:57:35PM -0800, Andrew Morton wrote:
> On Thu,  8 Nov 2012 20:54:10 +0100
> Robert Jarzmik <robert.jarzmik@free.fr> wrote:
.....
> > +		__field(dev_t, s_dev)
> 
> Perhaps use super_block.s_id here
> 
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->page = page;
> > +		__entry->i_no = page->mapping->host->i_ino;
> > +		__entry->pageofs = page->index;
> > +		if (page->mapping->host->i_sb)
> > +			__entry->s_dev = page->mapping->host->i_sb->s_dev;
> > +		else
> > +			__entry->s_dev = page->mapping->host->i_rdev;
> 
> and hence avoid all this stuff.

We actually have an informal convention for formating filesystem
trace events, and that is to use the device number....

> 
> > +	),
> > +
> > +	TP_printk("page=%p pfn=%lu blk=%d:%d inode+ofs=%lu+%lu",

... and to prefix messages like:

	TP_printk("dev %d:%d ino 0x%llx ....
		  MAJOR(__entry->dev), MINOR(__entry->dev),

i.e. the start of the event message has all the identifying
information where it is easy to grep for and get all the events for
a specific dev/inode combination without even having to think about
it.

XFS, ext3/4, jbd/jdb2 and gfs2 follow this convention, so we should
keep propagating that pattern in the name of consistency, rather
than having different trace formats for different parts of the
VFS/FS layers...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
