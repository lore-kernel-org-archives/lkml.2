Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1EPMV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:21:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:40136 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab1EPMVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:21:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,374,1301900400"; 
   d="scan'208";a="747832782"
Date: Mon, 16 May 2011 20:21:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/17] writeback: trace event writeback_single_inode
Message-ID: <20110516122121.GA6605@localhost>
References: <20110512135706.937596128@intel.com>
 <20110512140032.677908992@intel.com>
 <20110512232051.GN19446@dastard>
 <20110513053659.GF8016@localhost>
 <20110516001448.GS19446@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516001448.GS19446@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 08:14:48AM +0800, Dave Chinner wrote:
> On Fri, May 13, 2011 at 01:37:00PM +0800, Wu Fengguang wrote:
> > On Fri, May 13, 2011 at 07:20:51AM +0800, Dave Chinner wrote:
> > > On Thu, May 12, 2011 at 09:57:22PM +0800, Wu Fengguang wrote:
> > > > It is valuable to know how the dirty inodes are iterated and their IO size.
> > > > 
> > > > "writeback_single_inode: bdi 8:0: ino=134246746 state=I_DIRTY_SYNC|I_SYNC age=414 index=0 to_write=1024 wrote=0"
> > > > 
> > > > - "state" reflects inode->i_state at the end of writeback_single_inode()
> > > > - "index" reflects mapping->writeback_index after the ->writepages() call
> > > > - "to_write" is the wbc->nr_to_write at entrance of writeback_single_inode()
> > > > - "wrote" is the number of pages actually written
> > > > 
> > > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > > ---
> > > >  fs/fs-writeback.c                |    6 ++-
> > > >  include/trace/events/writeback.h |   56 +++++++++++++++++++++++++++++
> > > >  2 files changed, 61 insertions(+), 1 deletion(-)
> > > > 
> > > > --- linux-next.orig/include/trace/events/writeback.h	2011-05-12 11:46:27.000000000 +0800
> > > > +++ linux-next/include/trace/events/writeback.h	2011-05-12 11:48:55.000000000 +0800
> > > > @@ -8,6 +8,19 @@
> > > >  #include <linux/device.h>
> > > >  #include <linux/writeback.h>
> > > >  
> > > > +#define show_inode_state(state)					\
> > > > +	__print_flags(state, "|",				\
> > > > +		{I_DIRTY_SYNC,		"I_DIRTY_SYNC"},	\
> > > > +		{I_DIRTY_DATASYNC,	"I_DIRTY_DATASYNC"},	\
> > > > +		{I_DIRTY_PAGES,		"I_DIRTY_PAGES"},	\
> > > > +		{I_NEW,			"I_NEW"},		\
> > > > +		{I_WILL_FREE,		"I_WILL_FREE"},		\
> > > > +		{I_FREEING,		"I_FREEING"},		\
> > > > +		{I_CLEAR,		"I_CLEAR"},		\
> > > > +		{I_SYNC,		"I_SYNC"},		\
> > > > +		{I_REFERENCED,		"I_REFERENCED"}		\
> > > > +	)
> > > > +
> > > >  struct wb_writeback_work;
> > > >  
> > > >  DECLARE_EVENT_CLASS(writeback_work_class,
> > > > @@ -201,6 +214,49 @@ DEFINE_EVENT(writeback_congest_waited_te
> > > >  	TP_ARGS(usec_timeout, usec_delayed)
> > > >  );
> > > >  
> > > > +TRACE_EVENT(writeback_single_inode,
> > > > +
> > > > +	TP_PROTO(struct inode *inode,
> > > > +		 struct writeback_control *wbc,
> > > > +		 unsigned long nr_to_write
> > > > +	),
> > > > +
> > > > +	TP_ARGS(inode, wbc, nr_to_write),
> > > > +
> > > > +	TP_STRUCT__entry(
> > > > +		__array(char, name, 32)
> > > > +		__field(unsigned long, ino)
> > > > +		__field(unsigned long, state)
> > > > +		__field(unsigned long, age)
> > > > +		__field(unsigned long, writeback_index)
> > > > +		__field(long, nr_to_write)
> > > > +		__field(unsigned long, wrote)
> > > > +	),
> > > > +
> > > > +	TP_fast_assign(
> > > > +		strncpy(__entry->name,
> > > > +			dev_name(inode->i_mapping->backing_dev_info->dev), 32);
> > > > +		__entry->ino		= inode->i_ino;
> > > > +		__entry->state		= inode->i_state;
> > > > +		__entry->age		= (jiffies - inode->dirtied_when) *
> > > > +								1000 / HZ;
> > > > +		__entry->writeback_index = inode->i_mapping->writeback_index;
> > > > +		__entry->nr_to_write	= nr_to_write;
> > > > +		__entry->wrote		= nr_to_write - wbc->nr_to_write;
> > > > +	),
> > > > +
> > > > +	TP_printk("bdi %s: ino=%lu state=%s age=%lu "
> > > > +		  "index=%lu to_write=%ld wrote=%lu",
> > > > +		  __entry->name,
> > > > +		  __entry->ino,
> > > > +		  show_inode_state(__entry->state),
> > > > +		  __entry->age,
> > > > +		  __entry->writeback_index,
> > > > +		  __entry->nr_to_write,
> > > > +		  __entry->wrote
> > > > +	)
> > > > +);
> > > > +
> > > >  #endif /* _TRACE_WRITEBACK_H */
> > > >  
> > > >  /* This part must be outside protection */
> > > > --- linux-next.orig/fs/fs-writeback.c	2011-05-12 11:46:27.000000000 +0800
> > > > +++ linux-next/fs/fs-writeback.c	2011-05-12 11:48:55.000000000 +0800
> > > > @@ -356,6 +356,7 @@ writeback_single_inode(struct inode *ino
> > > >  		       struct writeback_control *wbc)
> > > >  {
> > > >  	struct address_space *mapping = inode->i_mapping;
> > > > +	long nr_to_write = wbc->nr_to_write;
> > > >  	unsigned dirty;
> > > >  	int ret;
> > > >  
> > > > @@ -378,7 +379,8 @@ writeback_single_inode(struct inode *ino
> > > >  		 */
> > > >  		if (wbc->sync_mode != WB_SYNC_ALL) {
> > > >  			requeue_io(inode, wb);
> > > > -			return 0;
> > > > +			ret = 0;
> > > > +			goto out;
> > > >  		}
> > > >  
> > > >  		/*
> > > > @@ -476,6 +478,8 @@ writeback_single_inode(struct inode *ino
> > > >  		}
> > > >  	}
> > > >  	inode_sync_complete(inode);
> > > > +out:
> > > > +	trace_writeback_single_inode(inode, wbc, nr_to_write);
> > > >  	return ret;
> > > >  }
> > > 
> > > I think I'd prefer two separate trace calls rather than jumping to
> > > one. That is, a trace_writeback_single_inode_requeue() event and a
> > > trace_writeback_single_inode_done() event so we can see the separate
> > > conditions in the trace....
> > 
> > The requeue events are likely to disappear when IO-less
> > balance_dirty_pages() are upstream. Do you still feel like adding a
> > trace for it?
> 
> Requeue events are not specific to balance_dirty_pages() based
> writeback. background/kupdate writeback can trigger them because a
> sync write, fsync or sync is in progress. So yes, please add a
> separate trace for it.

OK, here is the incremental change.

I noticed that I_SYNC won't be set in fsync, but could possibly be set
outside of the flusher thread via write_inode_now() and sync_inode().

Thanks,
Fengguang
---

 fs/fs-writeback.c                |    5 +++--
 include/trace/events/writeback.h |   16 +++++++++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

--- linux-next.orig/fs/fs-writeback.c	2011-05-16 20:12:04.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-16 20:12:08.000000000 +0800
@@ -385,8 +385,9 @@ writeback_single_inode(struct inode *ino
 		 */
 		if (wbc->sync_mode != WB_SYNC_ALL) {
 			requeue_io(inode, wb);
-			ret = 0;
-			goto out;
+			trace_writeback_single_inode_requeue(inode, wbc,
+							     nr_to_write);
+			return 0;
 		}
 
 		/*
--- linux-next.orig/include/trace/events/writeback.h	2011-05-16 20:12:26.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2011-05-16 20:15:42.000000000 +0800
@@ -239,7 +239,7 @@ DEFINE_EVENT(writeback_congest_waited_te
 	TP_ARGS(usec_timeout, usec_delayed)
 );
 
-TRACE_EVENT(writeback_single_inode,
+DECLARE_EVENT_CLASS(writeback_single_inode_template,
 
 	TP_PROTO(struct inode *inode,
 		 struct writeback_control *wbc,
@@ -282,6 +282,20 @@ TRACE_EVENT(writeback_single_inode,
 	)
 );
 
+DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode_requeue,
+	TP_PROTO(struct inode *inode,
+		 struct writeback_control *wbc,
+		 unsigned long nr_to_write),
+	TP_ARGS(inode, wbc, nr_to_write)
+);
+
+DEFINE_EVENT(writeback_single_inode_template, writeback_single_inode,
+	TP_PROTO(struct inode *inode,
+		 struct writeback_control *wbc,
+		 unsigned long nr_to_write),
+	TP_ARGS(inode, wbc, nr_to_write)
+);
+
 #endif /* _TRACE_WRITEBACK_H */
 
 /* This part must be outside protection */
