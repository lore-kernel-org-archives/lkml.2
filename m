Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2BEXla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 18:41:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:22999 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab2BEXl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 18:41:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103594698"
Date: Mon, 6 Feb 2012 07:31:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] writeback: fix dereferencing NULL bdi->dev on
 trace_writeback_queue
Message-ID: <20120205233121.GA30168@localhost>
References: <20120115152806.GA32106@debian>
 <20120117033253.GA399@localhost>
 <CAH+eYFDR8wpdo2RayfH6G30rnSm6T5g3qSBiC8eVvn1j98sQ6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH+eYFDR8wpdo2RayfH6G30rnSm6T5g3qSBiC8eVvn1j98sQ6w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 01:39:21AM +0530, Rabin Vincent wrote:
> On Tue, Jan 17, 2012 at 09:02, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > On Sun, Jan 15, 2012 at 08:58:06PM +0530, Rabin Vincent wrote:
> >>  Unable to handle kernel NULL pointer dereference at virtual address 0000002c
> >>  pgd = c0004000
> >>  [0000002c] *pgd=00000000
> >>  Internal error: Oops: 17 [#1] PREEMPT SMP
> >>  PC is at ftrace_raw_event_writeback_single_inode_template+0x60/0xe4
> >>  LR is at ftrace_raw_event_writeback_single_inode_template+0x50/0xe4
> >>
> >> The full trace+log is attached.  My kernel (current linus) has a delay
> >> inserted in __mark_inode_dirty, to easily trigger the condition:
> >
> > Rabin, thanks for showing the helpful details! It should be fixable by
> > the use of inode_to_bdi():
> 
> Thanks, this fixes that one.
> 
> However, I've found one more race condition leading to a crash when
> tracing is enabled, this time from the writeback:queue trace point from
> bdi_queue_work().  The cause is the same, i.e.  bdi->dev is NULL.  This
> was produced with the help of the following delay patch.  trace+log is
> attached.

Rabin, this should fix the bug. Note that I take no efforts to remove
the to-be-queued and already-queued works. I'm also a bit afraid if
the traces in the balance_dirty_pages() path (trace_balance_dirty_pages,
trace_bdi_dirty_ratelimit and writeback_wake_background) will have
similar NULL dereference bug. Do you test it by physically hot
removing a SD card, or with some detach command or emulation?

Thanks,
Fengguang

---
Subject: writeback: fix dereferencing NULL bdi->dev on trace_writeback_queue 
Date: Sat Feb 04 20:54:03 CST 2012

When the SD card is hot removed without umount, del_gendisk() will call
bdi_unregister() but not destroy/free it. This leaves the bdi in the
bdi->dev = NULL, bdi->wb.task = NULL, bdi->bdi_list removed state.

If someone gets the bdi before bdi_unregister() and calls
bdi_queue_work() after the unregister, trace_writeback_queue will be
dereferencing the NULL bdi->dev. Fix it with a simple test for NULL.

LKML-reference: http://lkml.org/lkml/2012/1/18/346
Reported-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/trace/events/writeback.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-next.orig/include/trace/events/writeback.h	2012-02-04 20:51:01.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2012-02-04 20:54:00.000000000 +0800
@@ -47,7 +47,10 @@ DECLARE_EVENT_CLASS(writeback_work_class
 		__field(int, reason)
 	),
 	TP_fast_assign(
-		strncpy(__entry->name, dev_name(bdi->dev), 32);
+		struct device *dev = bdi->dev;
+		if (!dev)
+			dev = default_backing_dev_info.dev;
+		strncpy(__entry->name, dev_name(dev), 32);
 		__entry->nr_pages = work->nr_pages;
 		__entry->sb_dev = work->sb ? work->sb->s_dev : 0;
 		__entry->sync_mode = work->sync_mode;
