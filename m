Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2BCRBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:01:37 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37119 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab2BCRBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:01:36 -0500
Subject: [RFC PATCH] Perf: Fix an issue where perf report fails to show the
	proper percentage
To: acme@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: robert.richter@amd.com, ananth@in.ibm.com, srikar@linux.vnet.ibm.com
Date: Fri, 03 Feb 2012 22:31:13 +0530
Message-ID: <20120203170113.5190.25558.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12020317-9574-0000-0000-0000013A79F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an issue where perf report shows nan% for certain
perf.data files. The below is from a report for a do_fork probe:

   -nan%           sshd  [kernel.kallsyms]  [k] do_fork
   -nan%    packagekitd  [kernel.kallsyms]  [k] do_fork
   -nan%    dbus-daemon  [kernel.kallsyms]  [k] do_fork
   -nan%           bash  [kernel.kallsyms]  [k] do_fork

A git bisect shows commit f3bda2c as the cause. However, looking back through
the git history, I saw commit 640c03c which seems to have removed the
required initialization for perf_sample->period. The problem only started
showing after commit f3bda2c. The below patch re-introduces the
initialization and it fixes the problem for me.

With the below patch, for the same perf.data:

  73.08%             bash  [kernel.kallsyms]  [k] do_fork
   8.97%      11-dhclient  [kernel.kallsyms]  [k] do_fork
   6.41%             sshd  [kernel.kallsyms]  [k] do_fork
   3.85%        20-chrony  [kernel.kallsyms]  [k] do_fork
   2.56%         sendmail  [kernel.kallsyms]  [k] do_fork

This patch applies over current linux-tip commit 9949284.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 tools/perf/util/evsel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index dcfefab..9a11f9e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -463,6 +463,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
+	data->period = 1;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!sample_id_all)

