Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2JHRSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:18:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49381 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab2JHRSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:18:35 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 07/12] perf kvm: handle realloc failures
Date: Mon,  8 Oct 2012 11:17:31 -0600
Message-Id: <1349716656-48165-8-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save previous pointer and free on failure.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index a23db89..af74a97 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -327,6 +327,7 @@ static int kvm_events_hash_fn(u64 key)
 static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
 {
 	int old_max_vcpu = event->max_vcpu;
+	void *prev;
 
 	if (vcpu_id < event->max_vcpu)
 		return true;
@@ -334,9 +335,11 @@ static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
 	while (event->max_vcpu <= vcpu_id)
 		event->max_vcpu += DEFAULT_VCPU_NUM;
 
+	prev = event->vcpu;
 	event->vcpu = realloc(event->vcpu,
 			      event->max_vcpu * sizeof(*event->vcpu));
 	if (!event->vcpu) {
+		free(prev);
 		pr_err("Not enough memory\n");
 		return false;
 	}
-- 
1.7.10.1

