Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab2JIRiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:38:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2JIRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:38:47 -0400
Date: Tue, 9 Oct 2012 10:37:26 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-2aa8eab029b319b2b458b3ba393bbba31961ea96@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1349716656-48165-12-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-12-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm:
  Only process events for vcpus of interest
Git-Commit-ID: 2aa8eab029b319b2b458b3ba393bbba31961ea96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:37:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2aa8eab029b319b2b458b3ba393bbba31961ea96
Gitweb:     http://git.kernel.org/tip/2aa8eab029b319b2b458b3ba393bbba31961ea96
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 8 Oct 2012 11:17:35 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Oct 2012 17:14:13 -0300

perf kvm: Only process events for vcpus of interest

Minimizing processing overhead for each sample - which becomes important
for the upcoming live mode when it has to deal with 100+k events per
second.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1349716656-48165-12-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 260abc5..b98095e 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -416,7 +416,10 @@ static double kvm_event_rel_stddev(int vcpu_id, struct kvm_event *event)
 static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 			     u64 time_diff)
 {
-	kvm_update_event_stats(&event->total, time_diff);
+	if (vcpu_id == -1) {
+		kvm_update_event_stats(&event->total, time_diff);
+		return true;
+	}
 
 	if (!kvm_event_expand(event, vcpu_id))
 		return false;
@@ -432,6 +435,12 @@ static bool handle_end_event(struct perf_kvm *kvm,
 {
 	struct kvm_event *event;
 	u64 time_begin, time_diff;
+	int vcpu;
+
+	if (kvm->trace_vcpu == -1)
+		vcpu = -1;
+	else
+		vcpu = vcpu_record->vcpu_id;
 
 	event = vcpu_record->last_event;
 	time_begin = vcpu_record->start_time;
@@ -461,7 +470,7 @@ static bool handle_end_event(struct perf_kvm *kvm,
 	BUG_ON(timestamp < time_begin);
 
 	time_diff = timestamp - time_begin;
-	return update_kvm_event(event, vcpu_record->vcpu_id, time_diff);
+	return update_kvm_event(event, vcpu, time_diff);
 }
 
 static
@@ -498,6 +507,11 @@ static bool handle_kvm_event(struct perf_kvm *kvm,
 	if (!vcpu_record)
 		return true;
 
+	/* only process events for vcpus user cares about */
+	if ((kvm->trace_vcpu != -1) &&
+	    (kvm->trace_vcpu != vcpu_record->vcpu_id))
+		return true;
+
 	if (kvm->events_ops->is_begin_event(evsel, sample, &key))
 		return handle_begin_event(kvm, vcpu_record, &key, sample->time);
 
