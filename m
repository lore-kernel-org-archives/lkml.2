Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab0EDRE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:04:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:49585 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab0EDRE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:04:57 -0400
Date: Tue, 4 May 2010 17:04:12 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       anton@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, ebmunson@us.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, ebmunson@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100504111915.GB14636@kryten>
References: <20100504111915.GB14636@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix performance issue with perf report
Message-ID: <tip-02bf60aad7d5912dfcdbe0154f1bd67ea7a8301e@git.kernel.org>
Git-Commit-ID: 02bf60aad7d5912dfcdbe0154f1bd67ea7a8301e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 17:04:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02bf60aad7d5912dfcdbe0154f1bd67ea7a8301e
Gitweb:     http://git.kernel.org/tip/02bf60aad7d5912dfcdbe0154f1bd67ea7a8301e
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Tue, 4 May 2010 21:19:15 +1000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 4 May 2010 10:54:09 -0300

perf: Fix performance issue with perf report

On a large machine we spend a lot of time in perf_header__find_attr when
running perf report.

If we are parsing a file without PERF_SAMPLE_ID then for each sample we call
perf_header__find_attr and loop through all counter IDs, never finding a match.
As the machine gets larger there are more per cpu counters and we spend an
awful lot of time in there.

The patch below initialises each sample id to -1ULL and checks for this in
perf_header__find_attr. We may need to do something more intelligent eventually
(eg a hash lookup from counter id to attr) but this at least fixes the most
common usage of perf report.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Acked-by: Eric B Munson <ebmunson@us.ibm.com>
LKML-Reference: <20100504111915.GB14636@kryten>
Signed-off-by: Anton Blanchard <anton@samba.org>
--
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |    1 +
 tools/perf/util/header.c |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 1757b0f..2477270 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -713,6 +713,7 @@ int event__parse_sample(event_t *event, u64 type, struct sample_data *data)
 		array++;
 	}
 
+	data->id = -1ULL;
 	if (type & PERF_SAMPLE_ID) {
 		data->id = *array;
 		array++;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2b9f898..8847bec 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -922,6 +922,14 @@ perf_header__find_attr(u64 id, struct perf_header *header)
 {
 	int i;
 
+	/*
+	 * We set id to -1 if the data file doesn't contain sample
+	 * ids. Check for this and avoid walking through the entire
+	 * list of ids which may be large.
+	 */
+	if (id == -1ULL)
+		return NULL;
+
 	for (i = 0; i < header->attrs; i++) {
 		struct perf_header_attr *attr = header->attr[i];
 		int j;
