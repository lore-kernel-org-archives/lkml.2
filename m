Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab1DZM1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:27:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52658 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab1DZM1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:27:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bYgqN8/Yovy9i6IZdXEib/lYY6Jw5dnsfAc9BRaLlpX4nL7AvngGAWSe5CC9Ir+N+N
         IsCDC8IONe4tF8A690Beo6L58N9/xlKB9Gg21jZ/wU3O5Duka11a/eiXAU422YS2Jk5y
         L6zGXDEFLlKS5RUIHaVq8WCVsNIjVMW9W22Jc=
Subject: Re: [BUG] perf and kmemcheck : fatal combination
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1303813668.3358.22.camel@edumazet-laptop>
References: <1303747731.2747.182.camel@edumazet-laptop>
	 <1303803525.20212.20.camel@twins> <20110426080443.GA806@elte.hu>
	 <1303808257.3012.3.camel@edumazet-laptop>
	 <1303811635.3358.21.camel@edumazet-laptop>
	 <BANLkTinOUFrJuauoxnRTkvrhZRxdYd05Mw@mail.gmail.com>
	 <1303813668.3358.22.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 14:27:35 +0200
Message-ID: <1303820855.3358.49.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 26 avril 2011 à 12:27 +0200, Eric Dumazet a écrit :
> Le mardi 26 avril 2011 à 13:08 +0300, Pekka Enberg a écrit :
> 
> > That's just kmemcheck fault handler warning about in_nmi(). You could
> > try to make the relevant perf allocations use __GFP_NOTRACK and/or
> > SLAB_NOTRACK to avoid page faulting in the perf nmi handler.
> 
> Yes, I am going to try that, thanks
> 

Thats far from trivial, maybe because we dont have NOTRACK api for
percpu allocations ?

I tried without success following patch

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 632e5dc..bea4949 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1632,7 +1632,7 @@ static int validate_event(struct perf_event *event)
 	struct event_constraint *c;
 	int ret = 0;
 
-	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
+	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO | ___GFP_NOTRACK);
 	if (!fake_cpuc)
 		return -ENOMEM;
 
@@ -1667,7 +1667,7 @@ static int validate_group(struct perf_event *event)
 	int ret, n;
 
 	ret = -ENOMEM;
-	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO);
+	fake_cpuc = kmalloc(sizeof(*fake_cpuc), GFP_KERNEL | __GFP_ZERO | ___GFP_NOTRACK);
 	if (!fake_cpuc)
 		goto out;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 43fa20b..a659b61 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1209,7 +1209,7 @@ static int intel_pmu_cpu_prepare(int cpu)
 		return NOTIFY_OK;
 
 	cpuc->per_core = kzalloc_node(sizeof(struct intel_percore),
-				      GFP_KERNEL, cpu_to_node(cpu));
+				      GFP_KERNEL | ___GFP_NOTRACK, cpu_to_node(cpu));
 	if (!cpuc->per_core)
 		return NOTIFY_BAD;
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index bab491b..e921a2f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -84,7 +84,7 @@ static int alloc_pebs_buffer(int cpu)
 	if (!x86_pmu.pebs)
 		return 0;
 
-	buffer = kmalloc_node(PEBS_BUFFER_SIZE, GFP_KERNEL | __GFP_ZERO, node);
+	buffer = kmalloc_node(PEBS_BUFFER_SIZE, GFP_KERNEL | __GFP_ZERO | ___GFP_NOTRACK, node);
 	if (unlikely(!buffer))
 		return -ENOMEM;
 
@@ -122,7 +122,7 @@ static int alloc_bts_buffer(int cpu)
 	if (!x86_pmu.bts)
 		return 0;
 
-	buffer = kmalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL | __GFP_ZERO, node);
+	buffer = kmalloc_node(BTS_BUFFER_SIZE, GFP_KERNEL | __GFP_ZERO | ___GFP_NOTRACK, node);
 	if (unlikely(!buffer))
 		return -ENOMEM;
 
@@ -155,7 +155,7 @@ static int alloc_ds_buffer(int cpu)
 	int node = cpu_to_node(cpu);
 	struct debug_store *ds;
 
-	ds = kmalloc_node(sizeof(*ds), GFP_KERNEL | __GFP_ZERO, node);
+	ds = kmalloc_node(sizeof(*ds), GFP_KERNEL | __GFP_ZERO | ___GFP_NOTRACK, node);
 	if (unlikely(!ds))
 		return -ENOMEM;
 
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index ba36217..8c2e3e6 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -211,7 +211,6 @@ extern void irq_exit(void);
 #define nmi_enter()						\
 	do {							\
 		ftrace_nmi_enter();				\
-		BUG_ON(in_nmi());				\
 		add_preempt_count(NMI_OFFSET + HARDIRQ_OFFSET);	\
 		lockdep_off();					\
 		rcu_nmi_enter();				\
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8e81a98..b09ba81 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2589,14 +2589,14 @@ static int alloc_callchain_buffers(void)
 	 */
 	size = offsetof(struct callchain_cpus_entries, cpu_entries[nr_cpu_ids]);
 
-	entries = kzalloc(size, GFP_KERNEL);
+	entries = kzalloc(size, GFP_KERNEL | ___GFP_NOTRACK);
 	if (!entries)
 		return -ENOMEM;
 
 	size = sizeof(struct perf_callchain_entry) * PERF_NR_CONTEXTS;
 
 	for_each_possible_cpu(cpu) {
-		entries->cpu_entries[cpu] = kmalloc_node(size, GFP_KERNEL,
+		entries->cpu_entries[cpu] = kmalloc_node(size, GFP_KERNEL | ___GFP_NOTRACK,
 							 cpu_to_node(cpu));
 		if (!entries->cpu_entries[cpu])
 			goto fail;
@@ -2756,7 +2756,8 @@ alloc_perf_context(struct pmu *pmu, struct task_struct *task)
 {
 	struct perf_event_context *ctx;
 
-	ctx = kzalloc(sizeof(struct perf_event_context), GFP_KERNEL);
+	ctx = kzalloc(sizeof(struct perf_event_context),
+		      GFP_KERNEL | ___GFP_NOTRACK);
 	if (!ctx)
 		return NULL;
 
@@ -3451,7 +3452,7 @@ static void *perf_mmap_alloc_page(int cpu)
 	int node;
 
 	node = (cpu == -1) ? cpu : cpu_to_node(cpu);
-	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+	page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO | ___GFP_NOTRACK, 0);
 	if (!page)
 		return NULL;
 
@@ -3468,7 +3469,7 @@ perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 	size = sizeof(struct perf_buffer);
 	size += nr_pages * sizeof(void *);
 
-	buffer = kzalloc(size, GFP_KERNEL);
+	buffer = kzalloc(size, GFP_KERNEL | ___GFP_NOTRACK);
 	if (!buffer)
 		goto fail;
 
@@ -3585,7 +3586,7 @@ perf_buffer_alloc(int nr_pages, long watermark, int cpu, int flags)
 	size = sizeof(struct perf_buffer);
 	size += sizeof(void *);
 
-	buffer = kzalloc(size, GFP_KERNEL);
+	buffer = kzalloc(size, GFP_KERNEL | ___GFP_NOTRACK);
 	if (!buffer)
 		goto fail;
 
@@ -4841,7 +4842,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		 * need to add enough zero bytes after the string to handle
 		 * the 64bit alignment we do later.
 		 */
-		buf = kzalloc(PATH_MAX + sizeof(u64), GFP_KERNEL);
+		buf = kzalloc(PATH_MAX + sizeof(u64), GFP_KERNEL | ___GFP_NOTRACK);
 		if (!buf) {
 			name = strncpy(tmp, "//enomem", sizeof(tmp));
 			goto got_name;
@@ -5385,7 +5386,7 @@ static int swevent_hlist_get_cpu(struct perf_event *event, int cpu)
 	if (!swevent_hlist_deref(swhash) && cpu_online(cpu)) {
 		struct swevent_hlist *hlist;
 
-		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL);
+		hlist = kzalloc(sizeof(*hlist), GFP_KERNEL | ___GFP_NOTRACK);
 		if (!hlist) {
 			err = -ENOMEM;
 			goto exit;
@@ -5969,7 +5970,7 @@ static int pmu_dev_alloc(struct pmu *pmu)
 {
 	int ret = -ENOMEM;
 
-	pmu->dev = kzalloc(sizeof(struct device), GFP_KERNEL);
+	pmu->dev = kzalloc(sizeof(struct device), GFP_KERNEL | ___GFP_NOTRACK);
 	if (!pmu->dev)
 		goto out;
 
@@ -6170,7 +6171,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 			return ERR_PTR(-EINVAL);
 	}
 
-	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	event = kzalloc(sizeof(*event), GFP_KERNEL | ___GFP_NOTRACK);
 	if (!event)
 		return ERR_PTR(-ENOMEM);
 
@@ -7222,7 +7223,8 @@ static void __cpuinit perf_event_init_cpu(int cpu)
 	if (swhash->hlist_refcount > 0) {
 		struct swevent_hlist *hlist;
 
-		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL, cpu_to_node(cpu));
+		hlist = kzalloc_node(sizeof(*hlist), GFP_KERNEL | ___GFP_NOTRACK,
+				     cpu_to_node(cpu));
 		WARN_ON(!hlist);
 		rcu_assign_pointer(swhash->swevent_hlist, hlist);
 	}


