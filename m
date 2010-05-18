Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab0ERRSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:18:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:60774 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0ERRR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:17:56 -0400
Date: Tue, 18 May 2010 17:17:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize perf_output_*() by avoiding local_xchg()
Message-ID: <tip-6d1acfd5c6bfd5231c13a8f2858d7f2afbaa1b62@git.kernel.org>
Git-Commit-ID: 6d1acfd5c6bfd5231c13a8f2858d7f2afbaa1b62
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 17:17:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d1acfd5c6bfd5231c13a8f2858d7f2afbaa1b62
Gitweb:     http://git.kernel.org/tip/6d1acfd5c6bfd5231c13a8f2858d7f2afbaa1b62
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 18 May 2010 11:12:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 18:35:49 +0200

perf: Optimize perf_output_*() by avoiding local_xchg()

Since the x86 XCHG ins implies LOCK, avoid the use by
using a sequence count instead.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ce76676..fe50347 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -804,6 +804,7 @@ struct perf_output_handle {
 	struct perf_mmap_data		*data;
 	unsigned long			head;
 	unsigned long			offset;
+	unsigned long			wakeup;
 	int				nmi;
 	int				sample;
 };
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 1f98c78..7e3bcf1 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2917,6 +2917,7 @@ static void perf_output_get_handle(struct perf_output_handle *handle)
 
 	preempt_disable();
 	local_inc(&data->nest);
+	handle->wakeup = local_read(&data->wakeup);
 }
 
 static void perf_output_put_handle(struct perf_output_handle *handle)
@@ -2950,7 +2951,7 @@ again:
 		goto again;
 	}
 
-	if (local_xchg(&data->wakeup, 0))
+	if (handle->wakeup != local_read(&data->wakeup))
 		perf_output_wakeup(handle);
 
 	preempt_enable();
