Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab0GZM5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 08:57:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:33177 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0GZM46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 08:56:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,261,1278313200"; 
   d="scan'208";a="821647529"
Date: Mon, 26 Jul 2010 20:56:35 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/6] writeback: sync expired inodes first in background
 writeback
Message-ID: <20100726125635.GC11947@localhost>
References: <20100722050928.653312535@intel.com>
 <20100722061822.906037624@intel.com>
 <20100726105736.GM5300@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726105736.GM5300@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -232,8 +232,15 @@ static void move_expired_inodes(struct l
> >  	while (!list_empty(delaying_queue)) {
> >  		inode = list_entry(delaying_queue->prev, struct inode, i_list);
> >  		if (expire_interval &&
> > -		    inode_dirtied_after(inode, older_than_this))
> > -			break;
> > +		    inode_dirtied_after(inode, older_than_this)) {
> > +			if (wbc->for_background &&
> > +			    list_empty(dispatch_queue) && list_empty(&tmp)) {
> > +				expire_interval >>= 1;
> > +				older_than_this = jiffies - expire_interval;
> > +				continue;
> > +			} else
> > +				break;
> > +		}
> 
> This needs a comment.
> 
> I think what it is saying is that if background flush is active but no
> inodes are old enough, consider newer inodes. This is on the assumption
> that page reclaim has encountered dirty pages and the dirty inodes are
> still too young.

Yes this should be commented. How about this one?

@@ -232,8 +232,20 @@ static void move_expired_inodes(struct l
        while (!list_empty(delaying_queue)) {
                inode = list_entry(delaying_queue->prev, struct inode, i_list);
                if (expire_interval &&
-                   inode_dirtied_after(inode, older_than_this))
+                   inode_dirtied_after(inode, older_than_this)) {
+                       /*
+                        * background writeback will start with expired inodes,
+                        * and then fresh inodes. This order helps reducing
+                        * the number of dirty pages reaching the end of LRU
+                        * lists and cause trouble to the page reclaim.
+                        */
+                       if (wbc->for_background &&
+                           list_empty(dispatch_queue) && list_empty(&tmp)) {
+                               expire_interval = 0;
+                               continue;
+                       }
                        break;
+               }
                if (sb && sb != inode->i_sb)
                        do_sb_sort = 1;
                sb = inode->i_sb;

Thanks,
Fengguang
