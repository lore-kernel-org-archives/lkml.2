Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1GAPTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:19:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:33246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab1GAPTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:19:01 -0400
Date: Fri, 1 Jul 2011 15:18:44 GMT
From: tip-bot for Vince Weaver <vweaver1@eecs.utk.edu>
Message-ID: <tip-4ec8363dfc1451f8c8f86825731fe712798ada02@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        vweaver1@eecs.utk.edu, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        vweaver1@eecs.utk.edu, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1106011506390.5384@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106011506390.5384@cl320.eecs.utk.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix perf buffer watermark setting
Git-Commit-ID: 4ec8363dfc1451f8c8f86825731fe712798ada02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:18:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ec8363dfc1451f8c8f86825731fe712798ada02
Gitweb:     http://git.kernel.org/tip/4ec8363dfc1451f8c8f86825731fe712798ada02
Author:     Vince Weaver <vweaver1@eecs.utk.edu>
AuthorDate: Wed, 1 Jun 2011 15:15:36 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:32 +0200

perf_events: Fix perf buffer watermark setting

Since 2.6.36 (specifically commit d57e34fdd60b ("perf: Simplify the
ring-buffer logic: make perf_buffer_alloc() do everything needed"),
the perf_buffer_init_code() has been mis-setting the buffer watermark
if perf_event_attr.wakeup_events has a non-zero value.

This is because perf_event_attr.wakeup_events is a union with
perf_event_attr.wakeup_watermark.

This commit re-enables the check for perf_event_attr.watermark being
set before continuing with setting a non-default watermark.

This bug is most noticable when you are trying to use PERF_IOC_REFRESH
with a value larger than one and perf_event_attr.wakeup_events is set to
one.  In this case the buffer watermark will be set to 1 and you will
get extraneous POLL_IN overflows rather than POLL_HUP as expected.

[ avoid using attr.wakeup_events when attr.watermark is set ]

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1106011506390.5384@cl320.eecs.utk.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c        |    6 ++++--
 kernel/events/ring_buffer.c |   16 +++++++++-------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5e70f62..e4aee51 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3569,8 +3569,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_flags & VM_WRITE)
 		flags |= RING_BUFFER_WRITABLE;
 
-	rb = rb_alloc(nr_pages, event->attr.wakeup_watermark,
-				   event->cpu, flags);
+	rb = rb_alloc(nr_pages, 
+		event->attr.watermark ? event->attr.wakeup_watermark : 0,
+		event->cpu, flags);
+
 	if (!rb) {
 		ret = -ENOMEM;
 		goto unlock;
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index fde5259..fc2701c 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -199,13 +199,15 @@ void perf_output_end(struct perf_output_handle *handle)
 	struct perf_event *event = handle->event;
 	struct ring_buffer *rb = handle->rb;
 
-	int wakeup_events = event->attr.wakeup_events;
-
-	if (handle->sample && wakeup_events) {
-		int events = local_inc_return(&rb->events);
-		if (events >= wakeup_events) {
-			local_sub(wakeup_events, &rb->events);
-			local_inc(&rb->wakeup);
+	if (handle->sample && !event->attr.watermark) {
+		int wakeup_events = event->attr.wakeup_events;
+
+		if (wakeup_events) {
+			int events = local_inc_return(&rb->events);
+			if (events >= wakeup_events) {
+				local_sub(wakeup_events, &rb->events);
+				local_inc(&rb->wakeup);
+			}
 		}
 	}
 
