Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab0ERRRw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:17:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:60759 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492Ab0ERRRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:17:45 -0400
Date: Tue, 18 May 2010 17:16:01 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       eranian@google.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4bf13674.014fd80a.6c82.ffffb20c@mx.google.com>
References: <4bf13674.014fd80a.6c82.ffffb20c@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix errors path in perf_output_begin()
Message-ID: <tip-00d1d0b095ba4e5c0958cb228b2a9c445d4a339d@git.kernel.org>
Git-Commit-ID: 00d1d0b095ba4e5c0958cb228b2a9c445d4a339d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 17:16:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00d1d0b095ba4e5c0958cb228b2a9c445d4a339d
Gitweb:     http://git.kernel.org/tip/00d1d0b095ba4e5c0958cb228b2a9c445d4a339d
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 17 May 2010 12:46:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 18:35:47 +0200

perf: Fix errors path in perf_output_begin()

In case the sampling buffer has no "payload" pages,
nr_pages is 0. The problem is that the error path in
perf_output_begin() skips to a label which assumes
perf_output_lock() has been issued which is not the
case. That triggers a WARN_ON() in
perf_output_unlock().

This patch fixes the problem by skipping
perf_output_unlock() in case data->nr_pages is 0.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4bf13674.014fd80a.6c82.ffffb20c@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 17ac47f..8d61d29 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3036,7 +3036,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 	handle->sample	= sample;
 
 	if (!data->nr_pages)
-		goto fail;
+		goto out;
 
 	have_lost = atomic_read(&data->lost);
 	if (have_lost)
