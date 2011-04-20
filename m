Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab1DTU4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:56:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47355 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab1DTUv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:51:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=IezjG6m1MvZaRx+ZsEyoxO85tD5kkr7sP8ouLHg5X0gZ6qmvIAzM0DMvDyHjvYfoG
	k8Mf+Hh0Rzlg3euEIEt6g==
From: Nikhil Rao <ncrao@google.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org, Nikhil Rao <ncrao@google.com>
Subject: [RFC][Patch 09/18] sched: update division in cpu_avg_load_per_task to use div_u64
Date: Wed, 20 Apr 2011 13:51:28 -0700
Message-Id: <1303332697-16426-10-git-send-email-ncrao@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the division in cpu_avg_load_per_task() to use div_u64, so
that it works on 32-bit. We do not convert avg_load_per_task to u64 since this
can be atmost 2^28, and fits into unsigned long on 32-bit.

Signed-off-by: Nikhil Rao <ncrao@google.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f0adb0e..8047f10 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1525,7 +1525,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		rq->avg_load_per_task = rq->load.weight / nr_running;
+		rq->avg_load_per_task = div_u64(rq->load.weight, nr_running);
 	else
 		rq->avg_load_per_task = 0;
 
-- 
1.7.3.1

