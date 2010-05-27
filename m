Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab0E0TfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 15:35:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44837 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0E0TfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 15:35:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=VlxMVKyKgBQDXeqTTk2zB1Mod8S8yrZQF5zIrsAxgt+KLEDUSj8z4u+59stm6bf2Y3
         0B5KdtO1hWTPZjh41pZjepJHOWlERe+qUon1bwHivD5qW7IJJ8LR2oSBANbv+eAVMrJ7
         sHf9meAdd82MConWme/VjlUaHosP+HYJA/vY4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Fix unincremented buffer base on partial copy
Date: Thu, 27 May 2010 21:34:58 +0200
Message-Id: <1274988898-5639-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a sample size crosses to the next page boundary, the copy
will be made in more than one step. However we forget to advance
the source offset for the next copy, leading to unexpected double
copies that completely mess up the traces.

This fixes various kinds of bad traces that have irrelevant
datas inside, as an example:

	geany-4979  [001]  5758.077775: sched_switch: prev_comm=! prev_pid=121
		prev_prio=0 prev_state=S|D|Z|X|x ==> next_comm= next_pid=7497072
		next_prio=0

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 kernel/perf_event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e099650..3d82e1a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2977,6 +2977,7 @@ __always_inline void perf_output_copy(struct perf_output_handle *handle,
 
 		len -= size;
 		handle->addr += size;
+		buf += size;
 		handle->size -= size;
 		if (!handle->size) {
 			struct perf_mmap_data *data = handle->data;
-- 
1.6.2.3

