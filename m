Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab0EaHVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:21:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:42512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab0EaHVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:21:09 -0400
Date: Mon, 31 May 2010 07:20:44 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1274988898-5639-1-git-send-regression-fweisbec@gmail.com>
References: <1274988898-5639-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix unincremented buffer base on partial copy
Message-ID: <tip-74048f895fa8cbf8119b4999f1f44881a825f954@git.kernel.org>
Git-Commit-ID: 74048f895fa8cbf8119b4999f1f44881a825f954
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 07:20:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74048f895fa8cbf8119b4999f1f44881a825f954
Gitweb:     http://git.kernel.org/tip/74048f895fa8cbf8119b4999f1f44881a825f954
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 27 May 2010 21:34:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 May 2010 08:46:10 +0200

perf_events: Fix unincremented buffer base on partial copy

If a sample size crosses to the next page boundary, the copy
will be made in more than one step. However we forget to advance
the source offset for the next copy, leading to unexpected double
copies that completely mess up the traces.

This fixes various kinds of bad traces that have irrelevant
data inside, as an example:

	geany-4979  [001]  5758.077775: sched_switch: prev_comm=! prev_pid=121
		prev_prio=0 prev_state=S|D|Z|X|x ==> next_comm= next_pid=7497072
		next_prio=0

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1274988898-5639-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 42a0e91..858f56f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3064,6 +3064,7 @@ __always_inline void perf_output_copy(struct perf_output_handle *handle,
 
 		len -= size;
 		handle->addr += size;
+		buf += size;
 		handle->size -= size;
 		if (!handle->size) {
 			struct perf_mmap_data *data = handle->data;
