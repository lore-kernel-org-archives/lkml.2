Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0EQM2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:28:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19625 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0EQM2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:28:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=m8RGhMcCvbuZx+zdMNwUkvkcovwXqDggUHy0QF02tB6ciHhx8jcbv0NT1aCQao3nN
	+L4nZ9RJfObxAoGLX7jtQ==
Message-ID: <4bf13674.014fd80a.6c82.ffffb20c@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 17 May 2010 12:46:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com, jkacur@redhat.com
Subject: [PATCH] perf_events: fix errors path in perf_output_begin() (take 3)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the sampling buffer has no "payload" pages, nr_pages is 0.
The problem is that the error path in perf_output_begin() skips to
a label which assumes perf_output_lock() has been issued which is
not the case. That triggers a WARN_ON() in perf_output_unlock().

This patch fixes the problem by skipping perf_output_unlock()
in case data->nr_pages is 0.

Signed-off-by: Stephane Eranian <eranian@google.com>

--

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a4fa381..4fdb919 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3036,7 +3036,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 	handle->sample	= sample;
 
 	if (!data->nr_pages)
-		goto fail;
+		goto out;
 
 	have_lost = atomic_read(&data->lost);
 	if (have_lost)
