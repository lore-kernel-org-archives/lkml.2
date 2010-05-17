Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0EQKrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:47:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27366 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0EQKrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:47:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=cGqynIj/+L02lkmAbDU4zOVngm+8cGrddq3GSEKNHSC7/NZ4kpQMtCB3FJ+GSx3s4
	IVxSixawQtKRZxqGLpnvg==
Message-ID: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 17 May 2010 12:46:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf_events: fix errors path in perf_output_begin()
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  In case the sampling buffer has no "payload" pages, nr_pages is 0.
  The problem is that the error path in perf_output_begin() skips to
  a label which assumes perf_output_lock() has been issued which is
  not the case. That triggers a WARN_ON() is perf_output_unlock().

  This patch fixes the problem by adding a new label and skipping
  perf_task_unlock() in case data->nr_pages is 0. 

  Signed-off-by: Stephane Eranian <eranian@google.com>

--
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a4fa381..95137b6 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3035,8 +3035,10 @@ int perf_output_begin(struct perf_output_handle *handle,
 	handle->nmi	= nmi;
 	handle->sample	= sample;
 
-	if (!data->nr_pages)
-		goto fail;
+	if (!data->nr_pages) {
+		atomic_inc(&data->lost);
+		goto out;
+	}
 
 	have_lost = atomic_read(&data->lost);
 	if (have_lost)
