Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab2JRXjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:39:33 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46690 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2JRXjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:39:32 -0400
Date: Thu, 18 Oct 2012 16:39:28 -0700
From: Tejun Heo <tj@kernel.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] workqueue: cancel_delayed_work() should return %NULL if
 work item is idle
Message-ID: <20121018233928.GY13370@google.com>
References: <444a6439-b1a4-4740-9e7e-bc37267cfe73@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <444a6439-b1a4-4740-9e7e-bc37267cfe73@default>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e65120fcfc1cb9697655d29ecd7982451c05d3c2 Mon Sep 17 00:00:00 2001
From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Thu, 18 Oct 2012 16:31:37 -0700

57b30ae77b ("workqueue: reimplement cancel_delayed_work() using
try_to_grab_pending()") made cancel_delayed_work() always return %true
unless someone else is also trying to cancel the work item, which is
broken - if the target work item is idle, the return value should be
%false.

try_to_grab_pending() indicates that the target work item was idle by
zero return value.  Use it for return.  Note that this brings
cancel_delayed_work() in line with __cancel_work_timer() in return
value handling.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <444a6439-b1a4-4740-9e7e-bc37267cfe73@default>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d951daa..042d221 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2982,7 +2982,7 @@ bool cancel_delayed_work(struct delayed_work *dwork)
 
 	set_work_cpu_and_clear_pending(&dwork->work, work_cpu(&dwork->work));
 	local_irq_restore(flags);
-	return true;
+	return ret;
 }
 EXPORT_SYMBOL(cancel_delayed_work);
 
-- 
1.7.7.3

