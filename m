Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2JHRTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:19:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49381 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab2JHRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:18:53 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 11/12] perf kvm: only process events for vcpus of interest
Date: Mon,  8 Oct 2012 11:17:35 -0600
Message-Id: <1349716656-48165-12-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimizing processing overhead for each sample - which becomes important
for the upcoming live mode when it has to deal with 100+k events per
second.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 6412694..dcbbcc7 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -420,7 +420,10 @@ static double kvm_event_rel_stddev(int vcpu_id, struct kvm_event *event)
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
@@ -436,6 +439,12 @@ static bool handle_end_event(struct perf_kvm *kvm,
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
@@ -465,7 +474,7 @@ static bool handle_end_event(struct perf_kvm *kvm,
 	BUG_ON(timestamp < time_begin);
 
 	time_diff = timestamp - time_begin;
-	return update_kvm_event(event, vcpu_record->vcpu_id, time_diff);
+	return update_kvm_event(event, vcpu, time_diff);
 }
 
 static
@@ -502,6 +511,11 @@ static bool handle_kvm_event(struct perf_kvm *kvm,
 	if (!vcpu_record)
 		return true;
 
+	/* only process events for vcpus user cares about */
+	if ((kvm->trace_vcpu != -1) &&
+	    (kvm->trace_vcpu != vcpu_record->vcpu_id))
+		return true;
+
 	if (kvm->events_ops->is_begin_event(evsel, sample, &key))
 		return handle_begin_event(kvm, vcpu_record, &key, sample->time);
 
-- 
1.7.10.1

