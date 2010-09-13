Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab0IMOih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:38:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:36502 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0IMOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:38:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=lch5ZWwBAoH2T4bqCYtznwbjQ9uzgdDqnelVFfcQWCJxD9bn9ROzVh+oy9fdoVBbr
	Y0g4VutpQad6g1RDpv0zA==
Message-ID: <4c8e3766.991ce30a.32cd.fffff5f0@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 13 Sep 2010 16:36:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf_events: fix NULL point in free_event()
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the following patch, perf top as non-root and
paranoid cpu set causes a NULL pointer dereference in
free_event() because event->ctx is NULL.

free_event() may be called, on the error path, before
event->ctx is set.

Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f29b525..a7d5e7a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2150,7 +2150,8 @@ static void free_event(struct perf_event *event)
 	if (event->destroy)
 		event->destroy(event);
 
-	put_ctx(event->ctx);
+	if (event->ctx)
+		put_ctx(event->ctx);
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
 
