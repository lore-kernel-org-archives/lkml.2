Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab2BQA7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:59:43 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44234 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756621Ab2BQA7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:59:41 -0500
X-Sasl-enc: +sRl+5yrVzLtKAkTwkN6q9+z3j06XMkacKIrjvCP20hJ 1329440380
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:11 2012
Message-Id: <20120217005511.008575233@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rabin Vincent <rabin@rab.in>,
        Namjae Jeon <linkinjeon@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [08/15] writeback: fix dereferencing NULL bdi->dev on trace_writeback_queue
In-Reply-To: <20120217005650.GA17119@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 977b7e3a52a7421ad33a393a38ece59f3d41c2fa upstream.

When a SD card is hot removed without umount, del_gendisk() will call
bdi_unregister() without destroying/freeing it. This leaves the bdi in
the bdi->dev = NULL, bdi->wb.task = NULL, bdi->bdi_list removed state.

When sync(2) gets the bdi before bdi_unregister() and calls
bdi_queue_work() after the unregister, trace_writeback_queue will be
dereferencing the NULL bdi->dev. Fix it with a simple test for NULL.

LKML-reference: http://lkml.org/lkml/2012/1/18/346
Reported-by: Rabin Vincent <rabin@rab.in>
Tested-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/writeback.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -23,7 +23,10 @@ DECLARE_EVENT_CLASS(writeback_work_class
 		__field(int, for_background)
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


