Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2BFVgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:36:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:56115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab2BFVge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:36:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Robert Richter <robert.richter@amd.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stable@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf evsel: Fix an issue where perf report fails to show the proper percentage
Date: Mon,  6 Feb 2012 19:36:09 -0200
Message-Id: <1328564169-26517-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1328564169-26517-1-git-send-email-acme@infradead.org>
References: <1328564169-26517-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>

This patch fixes an issue where perf report shows nan% for certain
perf.data files. The below is from a report for a do_fork probe:

   -nan%           sshd  [kernel.kallsyms]  [k] do_fork
   -nan%    packagekitd  [kernel.kallsyms]  [k] do_fork
   -nan%    dbus-daemon  [kernel.kallsyms]  [k] do_fork
   -nan%           bash  [kernel.kallsyms]  [k] do_fork

A git bisect shows commit f3bda2c as the cause. However, looking back
through the git history, I saw commit 640c03c which seems to have
removed the required initialization for perf_sample->period. The problem
only started showing after commit f3bda2c. The below patch re-introduces
the initialization and it fixes the problem for me.

With the below patch, for the same perf.data:

  73.08%             bash  [kernel.kallsyms]  [k] do_fork
   8.97%      11-dhclient  [kernel.kallsyms]  [k] do_fork
   6.41%             sshd  [kernel.kallsyms]  [k] do_fork
   3.85%        20-chrony  [kernel.kallsyms]  [k] do_fork
   2.56%         sendmail  [kernel.kallsyms]  [k] do_fork

This patch applies over current linux-tip commit 9949284.

Problem introduced in:

$ git describe 640c03c
v2.6.37-rc3-83-g640c03c

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/20120203170113.5190.25558.stgit@localhost6.localdomain6
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 667f3b7..7132ee8 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -463,6 +463,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
+	data->period = 1;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!sample_id_all)
-- 
1.7.9.rc2.1.g69204

