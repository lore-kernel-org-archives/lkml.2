Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab0JLNJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:09:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:46663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab0JLNJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:09:07 -0400
Date: Tue, 12 Oct 2010 13:08:33 GMT
From: tip-bot for John Blackwood <john.blackwood@ccur.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, joe.korty@ccur.com, tglx@linutronix.de,
        john.blackwood@ccur.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, joe.korty@ccur.com,
        john.blackwood@ccur.com, mingo@elte.hu
In-Reply-To: <20100928220311.GA18145@tsunami.ccur.com>
References: <20100928220311.GA18145@tsunami.ccur.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix incorrect copy_from_user() usage
Message-ID: <tip-ad0cf3478de8677f720ee06393b3147819568d6a@git.kernel.org>
Git-Commit-ID: ad0cf3478de8677f720ee06393b3147819568d6a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Oct 2010 13:08:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad0cf3478de8677f720ee06393b3147819568d6a
Gitweb:     http://git.kernel.org/tip/ad0cf3478de8677f720ee06393b3147819568d6a
Author:     John Blackwood <john.blackwood@ccur.com>
AuthorDate: Tue, 28 Sep 2010 18:03:11 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 12 Oct 2010 11:45:01 +0200

perf: Fix incorrect copy_from_user() usage

perf events: repair incorrect use of copy_from_user

This makes the perf_event_period() return 0 instead of
-EFAULT on success.

Signed-off-by: John Blackwood<john.blackwood@ccur.com>
Signed-off-by: Joe Korty <joe.korty@ccur.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100928220311.GA18145@tsunami.ccur.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index db5b560..b98bed3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2202,15 +2202,13 @@ static void perf_event_for_each(struct perf_event *event,
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
