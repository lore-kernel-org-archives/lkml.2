Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab2JXKE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:04:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2JXKEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:04:54 -0400
Date: Wed, 24 Oct 2012 03:03:36 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-8300daa26755c9a194776778bd822acf1fa2dbf6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, jolsa@redhat.com
In-Reply-To: <1349873598-12583-3-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Filter out undefined events from sysfs events attribute
Git-Commit-ID: 8300daa26755c9a194776778bd822acf1fa2dbf6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:03:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8300daa26755c9a194776778bd822acf1fa2dbf6
Gitweb:     http://git.kernel.org/tip/8300daa26755c9a194776778bd822acf1fa2dbf6
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 10 Oct 2012 14:53:12 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:41:24 +0200

perf/x86: Filter out undefined events from sysfs events attribute

The sysfs events group attribute currently shows all hw events,
including also undefined ones.

This patch filters out all undefined events out of the sysfs events
group attribute, so they don't even show up.

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349873598-12583-3-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 9fa4c45..39737a6 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1321,6 +1321,26 @@ struct perf_pmu_events_attr {
 	u64 id;
 };
 
+/*
+ * Remove all undefined events (x86_pmu.event_map(id) == 0)
+ * out of events_attr attributes.
+ */
+static void __init filter_events(struct attribute **attrs)
+{
+	int i, j;
+
+	for (i = 0; attrs[i]; i++) {
+		if (x86_pmu.event_map(i))
+			continue;
+
+		for (j = i; attrs[j]; j++)
+			attrs[j] = attrs[j + 1];
+
+		/* Check the shifted attr. */
+		i--;
+	}
+}
+
 ssize_t events_sysfs_show(struct device *dev, struct device_attribute *attr,
 			  char *page)
 {
@@ -1420,6 +1440,8 @@ static int __init init_hw_perf_events(void)
 
 	if (!x86_pmu.events_sysfs_show)
 		x86_pmu_events_group.attrs = &empty_attrs;
+	else
+		filter_events(x86_pmu_events_group.attrs);
 
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
