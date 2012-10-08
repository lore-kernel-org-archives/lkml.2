Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab2JHWeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:34:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:41440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2JHWdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/25] perf kvm: Only process events for vcpus of interest
Date: Mon,  8 Oct 2012 19:32:44 -0300
Message-Id: <1349735570-19339-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
 1 file changed, 16 insertions(+), 2 deletions(-)

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
 
-- 
1.7.9.2.358.g22243

