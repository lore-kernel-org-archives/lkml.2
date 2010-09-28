Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0I1W4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 18:56:20 -0400
Received: from flusers.ccur.com ([173.221.59.2]:59758 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752709Ab0I1W4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 18:56:19 -0400
X-Greylist: delayed 3167 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 18:56:19 EDT
Date: Tue, 28 Sep 2010 18:03:11 -0400
From: Joe Korty <joe.korty@ccur.com>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, john.blackwood@ccur.com
Cc: linux-kernel@vger.kernel.org
Subject: [PERF EVENTS] fix incorrect copy_from_user usage
Message-ID: <20100928220311.GA18145@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf events: repair incorrect use of copy_from_user

This makes the perf_event_period() return 0 instead of
-EFAULT on success.

Developed-by: John Blackwood <john.blackwood@ccur.com>
Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.36-rc5/kernel/perf_event.c
===================================================================
--- 2.6.36-rc5.orig/kernel/perf_event.c	2010-09-28 17:38:16.000000000 -0400
+++ 2.6.36-rc5/kernel/perf_event.c	2010-09-28 17:48:10.000000000 -0400
@@ -2202,15 +2202,13 @@
 static int perf_event_period(struct perf_event *event, u64 __user *arg)
 {
 	struct perf_event_context *ctx = event->ctx;
-	unsigned long size;
 	int ret = 0;
 	u64 value;
 
 	if (!event->attr.sample_period)
 		return -EINVAL;
 
-	size = copy_from_user(&value, arg, sizeof(value));
-	if (size != sizeof(value))
+	if (copy_from_user(&value, arg, sizeof(value)))
 		return -EFAULT;
 
 	if (!value)
