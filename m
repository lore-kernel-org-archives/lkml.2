Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab2BGTgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:36:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40757 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2BGTgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:36:54 -0500
Date: Tue, 7 Feb 2012 11:36:13 -0800
From: "tip-bot for Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Message-ID: <tip-a4a03fc7ef89020baca4f19174e6a43767c6d78a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, ananth@in.ibm.com, robert.richter@amd.com,
        srikar@linux.vnet.ibm.com, naveen.n.rao@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: ananth@in.ibm.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        srikar@linux.vnet.ibm.com, naveen.n.rao@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120203170113.5190.25558.stgit@localhost6.localdomain6>
References: <20120203170113.5190.25558.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Fix an issue where perf report fails to show the proper percentage
Git-Commit-ID: a4a03fc7ef89020baca4f19174e6a43767c6d78a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:36:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4a03fc7ef89020baca4f19174e6a43767c6d78a
Gitweb:     http://git.kernel.org/tip/a4a03fc7ef89020baca4f19174e6a43767c6d78a
Author:     Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
AuthorDate: Fri, 3 Feb 2012 22:31:13 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Feb 2012 18:59:38 -0200

perf evsel: Fix an issue where perf report fails to show the proper percentage

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
