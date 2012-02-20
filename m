Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab2BTGHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 01:07:55 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:53696 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2BTGHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 01:07:54 -0500
Message-ID: <1329718066.3448.33.camel@ThinkPad-T61>
Subject: [PATCH 2/2 x86] fix page faults by perf events in nmi if kmemcheck
 is enabled
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Date: Mon, 20 Feb 2012 14:07:46 +0800
In-Reply-To: <1329717879.3448.30.camel@ThinkPad-T61>
References: <1329717665.3448.28.camel@ThinkPad-T61>
	 <1329717879.3448.30.camel@ThinkPad-T61>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12022006-8256-0000-0000-0000015196CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to use __get_free_pages for the perf_event and it's
callchain buffers if CONFIG_KMEMCHECK is enabled. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 kernel/events/callchain.c |   29 +++++++++++++++++++++++++++++
 kernel/events/core.c      |   13 +++++++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 6581a04..57f5eaa 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -38,13 +38,25 @@ static void release_callchain_buffers_rcu(struct
rcu_head *head)
 {
 	struct callchain_cpus_entries *entries;
 	int cpu;
+#ifdef CONFIG_KMEMCHECK
+	int size;
+
+	size = sizeof(struct perf_callchain_entry) * PERF_NR_CONTEXTS;
+#endif
 
 	entries = container_of(head, struct callchain_cpus_entries, rcu_head);
 
 	for_each_possible_cpu(cpu)
+#ifdef CONFIG_KMEMCHECK
+		free_pages((unsigned long)entries->cpu_entries[cpu],
+			get_order(size));
+	size = offsetof(struct callchain_cpus_entries,
cpu_entries[nr_cpu_ids]);
+	free_pages((unsigned long)entries, get_order(size));
+#else
 		kfree(entries->cpu_entries[cpu]);
 
 	kfree(entries);
+#endif
 }
 
 static void release_callchain_buffers(void)
@@ -69,15 +81,25 @@ static int alloc_callchain_buffers(void)
 	 */
 	size = offsetof(struct callchain_cpus_entries,
cpu_entries[nr_cpu_ids]);
 
+#ifdef CONFIG_KMEMCHECK
+	entries = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+					get_order(size));
+#else
 	entries = kzalloc(size, GFP_KERNEL);
+#endif
 	if (!entries)
 		return -ENOMEM;
 
 	size = sizeof(struct perf_callchain_entry) * PERF_NR_CONTEXTS;
 
 	for_each_possible_cpu(cpu) {
+#ifdef CONFIG_KMEMCHECK
+		entries->cpu_entries[cpu] = (void *)__get_free_pages(
+				GFP_KERNEL, get_order(size));
+#else
 		entries->cpu_entries[cpu] = kmalloc_node(size, GFP_KERNEL,
 							 cpu_to_node(cpu));
+#endif
 		if (!entries->cpu_entries[cpu])
 			goto fail;
 	}
@@ -88,8 +110,15 @@ static int alloc_callchain_buffers(void)
 
 fail:
 	for_each_possible_cpu(cpu)
+#ifdef CONFIG_KMEMCHECK
+		free_pages((unsigned long)entries->cpu_entries[cpu],
+				get_order(size));
+	size = offsetof(struct callchain_cpus_entries,
cpu_entries[nr_cpu_ids]);
+	free_pages((unsigned long)entries, get_order(size));
+#else
 		kfree(entries->cpu_entries[cpu]);
 	kfree(entries);
+#endif
 
 	return -ENOMEM;
 }
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ba36013..841c2ab 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2758,7 +2758,11 @@ static void free_event_rcu(struct rcu_head *head)
 	if (event->ns)
 		put_pid_ns(event->ns);
 	perf_event_free_filter(event);
+#ifdef CONFIG_KMEMCHECK
+	free_pages((unsigned long)event, get_order(sizeof(*event)));
+#else
 	kfree(event);
+#endif
 }
 
 static void ring_buffer_put(struct ring_buffer *rb);
@@ -5723,7 +5727,12 @@ perf_event_alloc(struct perf_event_attr *attr,
int cpu,
 			return ERR_PTR(-EINVAL);
 	}
 
+#ifdef CONFIG_KMEMCHECK
+	event = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+				get_order(sizeof(*event)));
+#else
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
+#endif
 	if (!event)
 		return ERR_PTR(-ENOMEM);
 
@@ -5810,7 +5819,11 @@ done:
 	if (err) {
 		if (event->ns)
 			put_pid_ns(event->ns);
+#ifdef CONFIG_KMEMCHECK
+		free_pages((unsigned long)event, get_order(sizeof(*event)));
+#else
 		kfree(event);
+#endif
 		return ERR_PTR(err);
 	}
 
-- 
1.7.5.4

