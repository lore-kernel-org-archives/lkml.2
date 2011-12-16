Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab1LPQNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:13:17 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:7156 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756507Ab1LPQMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:12:46 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWB110-01-6GT-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <mingo@elte.hu>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bebl@mageta.org>,
        Benjamin Block <benjamin.block@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Date: Fri, 16 Dec 2011 17:12:22 +0100
Message-ID: <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
References: <20111216160757.GL665@escobedo.osrc.amd.com>
 <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Block <benjamin.block@amd.com>

Implements a basic integration of LWP into perf. Permits a way to create
a perf-event that will be backed by LWP. The PMU creates the required
structures and userspace-memories. The PMU also collects the samples
from the ring-buffer, but as there is currently no interrupt- and
overflow-implementation, they are not reported (TODO).

Signed-off-by: Benjamin Block <benjamin.block@amd.com>
Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/processor.h         |    4 +-
 arch/x86/kernel/cpu/perf_event_amd_lwp.c | 1179 +++++++++++++++++++++++++++++-
 include/linux/perf_event.h               |    5 +
 kernel/events/core.c                     |   28 +
 4 files changed, 1213 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index bb31ab6..d5240e7 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -353,7 +353,7 @@ struct ymmh_struct {
 	u32 ymmh_space[64];
 };
 
-struct lwp_struct {
+struct lwp_state {
 	u64 lwpcb_addr;
 	u32 flags;
 	u32 buf_head_offset;
@@ -374,7 +374,7 @@ struct xsave_struct {
 	struct i387_fxsave_struct i387;
 	struct xsave_hdr_struct xsave_hdr;
 	struct ymmh_struct ymmh;
-	struct lwp_struct lwp;
+	struct lwp_state lwp;
 	/* new processor state extensions will go here */
 } __attribute__ ((packed, aligned (64)));
 
diff --git a/arch/x86/kernel/cpu/perf_event_amd_lwp.c b/arch/x86/kernel/cpu/perf_event_amd_lwp.c
index 9aa9a91..afc6c8d 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_lwp.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_lwp.c
@@ -1,12 +1,94 @@
 #include <linux/perf_event.h>
 #include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/kref.h>
+#include <linux/mm_types.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/mman.h>
+#include <linux/hardirq.h>
+#include <linux/highmem.h>
+#include <linux/bitops.h>
 
+#include <asm/xsave.h>
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
 
+/*
+ * The perf-config-vector (u64) contains 2 informations:
+ * * the event-id of the event that should be activated
+ * * filters for this class of event (lwp doesn't provide filters for
+ *   individual events)
+ *
+ * Event-ID: lwp_config_event_get(perf-config)
+ * Filters: lwp_config_filter_get(perf-config)
+ *
+ * Each event-class has its own filter-config.
+ *	for each class Filters contain:
+ *	Bit	0: IP Filter Invert
+ *		1: IP Filter
+ *	though it is possible to set the bits (for later implementations)
+ *	the current implementation does not support ip-filtering (see
+ *	get_filter_mask_for())
+ *	for branch retired:
+ *	Bit	2: No Mispredicted Branches
+ *		3: No Predicted Branches
+ *		4: No Absolute Branches
+ *		5: No Conditional Branches
+ *		6: No Unconditional Branches
+ *	for dcache misses:
+ *	Bit	2-9: MinLatency
+ *		10: Northbridge
+ *		11: Remote
+ *		12: Dram
+ *		13: Other
+ */
+#define LWP_CONFIG_EVENT_MASK		0x000000000000001FULL
+#define LWP_CONFIG_FILTER_MASK		0xFFFFF00000000000ULL
+#define LWP_CONFIG_MASK			(LWP_CONFIG_EVENT_MASK \
+					| LWP_CONFIG_FILTER_MASK)
+
+static inline int lwp_config_event_get(u64 config)
+{
+	return (config) & LWP_CONFIG_EVENT_MASK;
+}
+
+static inline int lwp_config_filter_get(u64 config)
+{
+	return ((config) & LWP_CONFIG_FILTER_MASK) >> 44;
+}
+
 /* masks only the events as of spec r3.08 (lwp v1) */
 #define LWP_EVENT_MASK		0x7E
 
+enum lwp_event_nr {
+	LWP_EVENT_INVALID	= 0,
+	LWP_EVENT_INSERT	= 1,
+	LWP_EVENT_INSTRURET,
+	LWP_EVENT_BRANCHRET,
+	LWP_EVENT_DCACHEMISS,
+	LWP_EVENT_CPUCLOCK,
+	LWP_EVENT_CPURCLOCK,
+	LWP_EVENT_MAX,
+	LWP_EVENT_PROGRAMMED	= 255 /* This is no mistake */
+};
+
+enum lwp_filter_nr {
+	LWP_FILTER_MIN_LATENCY		= 0,
+	LWP_FILTER_CACHE_LEVEL		= 8,
+	LWP_FILTER_CACHE_NORTHBRIDGE	= 9,
+	LWP_FILTER_CACHE_REMOTE		= 10,
+	LWP_FILTER_CACHE_DRAM		= 11,
+	LWP_FILTER_CACHE_OTHER		= 12,
+	LWP_FILTER_BRANCH_MISPREDICT	= 25,
+	LWP_FILTER_BRANCH_PREDICT	= 26,
+	LWP_FILTER_BRANCH_ABSOLUTE	= 27,
+	LWP_FILTER_BRANCH_COND		= 28,
+	LWP_FILTER_BRANCH_UNCOND	= 29,
+	LWP_FILTER_IP_FILTER_INV	= 30,
+	LWP_FILTER_IP_FILTER		= 31
+};
+
 struct lwp_capabilities {
 #define LWP_CAPS_LWP			0
 #define LWP_CAPS_THRESHOLD		31
@@ -35,7 +117,1096 @@ union lwp_cfg_msr {
 	u64 msr_value;
 };
 
+struct lwp_event {
+	/*
+	 * event id
+	 * 0 - Reserved - Invalid
+	 * 1 - Programmed value sample
+	 * 2 - Instructions retired
+	 * 3 - Branches retired
+	 * 4 - DCache misses
+	 * 5 - CPU clocks not halted
+	 * 6 - CPU reference clocks not halted
+	 * 255 - Programmed event
+	 */
+	u8	event_id;
+	u8	core_id;
+	u16	flags; /* per-event flags; see spec. */
+	u32	data1;
+	u64	inst_adr;
+	u64	data2;
+	u64	data3;
+} __attribute__((packed));
+
+struct lwpcb_head {
+	u32	flags;
+	u32	buffer_size : 28;
+
+	/*
+	 * If set, lwp-HW will randomize every event-interval by making
+	 * the first 'random' bits random.
+	 * Could be used to prevent fixed event-pattern.
+	 */
+	u32	random : 4;
+	u64	buffer_base; /* has to be a userspace effective address */
+
+	/*
+	 * buffer_head_offset is held by HW and must never changed by SW.
+	 * It can be updated by executing slwpcb. <wiki:Circular_buffer>
+	 */
+	u32	buffer_head_offset;
+	u32	reserved_1;
+	u64	missed_events; /* increases if buffer is full */
+
+	/*
+	 * If the threshold-interrupt is active this size is evaluated as:
+	 * threshold >= (buffer_head_offset - buffer_tail_offset) % buffer_size
+	 * Should be a multiple of event_size, if not it is rounded down by HW.
+	 */
+	u32	threshold;
+	u32	filters;
+
+	/*
+	 * base_ip and limit_ip are only validated if instruction-pointer-filter
+	 * is active.
+	 */
+	u64	base_ip;
+	u64	limit_ip;
+	u64	reserved_2;
+
+	/*
+	 * The tail-pointer of the ringbuffer, should point to the oldest event
+	 * and has to be maintained by the software.
+	 * If bto > buffer_size; then bto = 0; fi
+	 */
+	u32	buffer_tail_offset;
+	u32	reserved_3;
+	u64	software_data_1; /* can be used by software */
+	u64	software_data_2;
+}  __attribute__((packed));
+
+/*
+ * Between lwpcb_head and lwpcb_event is a undefined space
+ * which has to be read from hardware before allocating it.
+ * LwpEventOffset tells the startpoint of the events.
+ * lwpcb_event can be attached several times after that point.
+ */
+struct lwpcb_event {
+	s32	interval	: 26;
+	u32	reserved_1	: 6;
+	s32	counter		: 26;
+	u32	reserved_2	: 6;
+} __attribute__((packed));
+
+/* everything above is treated as 0 */
+#define LWP_EVENT_MAX_PERIOD	0x1FFFFFFULL
+/* we need a reasonable minimum as a to small value could start a intrp-strom */
+#define LWP_EVENT_MIN_PERIOD	0xFULL
+
+struct lwp_userspace {
+	void __user	*addr;
+	struct page	**pages;
+	size_t		length; /* in pages */
+};
+
+struct lwp_struct {
+	struct { /* lwpcb */
+		void			*lwpcb_base;
+
+		/*
+		 * The actual size of the lwpcb.
+		 * At least:
+		 * sizeof(lwpcb_head) + lwp_caps.max_event_id *
+		 * sizeof(lwpcb_event)
+		 * But the hardware can request more,
+		 * so better use lwp_caps.size_lwpcb * 8
+		 */
+		size_t			size;
+
+		struct lwpcb_head	*head;
+		struct lwpcb_event	*events;
+	} lwpcb;
+
+	/* the ringbuffer used by lwp to store the event_records */
+	struct { /* buffer */
+		void			*buffer_base;
+		size_t			size;
+	} buffer;
+
+	struct { /* userspace mappings */
+		struct mm_struct	*mm;
+
+		/* both should be PAGE_ALIGNED or at least 64 bit aligned */
+		struct lwp_userspace	lwpcb;
+		struct lwp_userspace	buffer;
+	} userspace;
+
+	struct task_struct		*owner;
+
+	/* This reflects caps.size_event at the time of creation */
+	size_t				eventsize;
+	/* Max event_id supported by this lwp-instance */
+	size_t				eventmax;
+
+	/* Cached events that have been read from buffer */
+	u64				*event_counter;
+	/*
+	 * Cached xsave-values, to prevent lose of already counted but not
+	 * submitted events.
+	 */
+	u32				xstate_counter[LWP_EVENT_MAX-1];
+
+	u8				active;
+
+	struct kref			ref_count;
+	raw_spinlock_t			lock;
+};
+
+static inline int vector_test(unsigned int bit_nr, u32 vector)
+{
+	return (1U << bit_nr) & vector;
+}
+
 static struct lwp_capabilities	lwp_caps;
+static struct pmu		perf_lwp_pmu;
+
+static u16 get_filter_mask_for(u32 eventnr)
+{
+	/*
+	 * IP-filtering is currently not supported by this PMU,
+	 * as it would cause every active event to be affected
+	 *
+	 * if (test_bit(LWP_FILTER_IP, &lwp_caps.features))
+	 *	u32 mask = 0x3;
+	 */
+	u32 mask = 0x0;
+
+	switch (eventnr) {
+	case LWP_EVENT_BRANCHRET:
+		mask |= 0x70U;
+		if (test_bit(LWP_CAPS_FILTER_BRANCH, &lwp_caps.features))
+			mask |= 0xCU;
+		break;
+	case LWP_EVENT_DCACHEMISS:
+		if (test_bit(LWP_CAPS_FILTER_CACHE_LAT,	&lwp_caps.features))
+			mask |= 0x3FCU;
+		if (test_bit(LWP_CAPS_FILTER_CACHE_LVL, &lwp_caps.features))
+			mask |= 0x3C00U;
+		break;
+	default:
+		break;
+	}
+
+	return mask;
+}
+
+static u32 get_filter_vector(u32 eventnr, u16 filter)
+{
+	u32 vector = 0;
+
+	filter &= get_filter_mask_for(eventnr);
+	if (!filter)
+		return 0;
+
+	/*
+	 * ugly... but we have to use the given perf-config-fields
+	 * maybe I will integrate this into a bitfield or enum
+	 */
+	switch (eventnr) {
+	case LWP_EVENT_BRANCHRET:
+		/* branch-filter start at position 25 */
+		vector |= (filter << 23);
+		/* the following combinations would prevent any event */
+		if (vector_test(LWP_FILTER_BRANCH_MISPREDICT, vector) &&
+		    vector_test(LWP_FILTER_BRANCH_PREDICT, vector))
+			return 0;
+		if (vector_test(LWP_FILTER_BRANCH_ABSOLUTE, vector) &&
+		    vector_test(LWP_FILTER_BRANCH_COND, vector) &&
+		    vector_test(LWP_FILTER_BRANCH_UNCOND, vector))
+			return 0;
+		break;
+	case LWP_EVENT_DCACHEMISS:
+		if (filter & 0x3C00)
+			vector |= (((filter & 0x3C00) >> 2) | 0x100);
+		vector |= ((filter & 0x3FC) >> 2);
+		break;
+	default:
+		break;
+	}
+
+	return vector;
+}
+
+static int
+get_userspace_mapping(struct lwp_userspace *l, struct mm_struct *mm,
+			size_t size)
+{
+	int err = 0,
+	    pages = 0;
+
+	l->length = PAGE_ALIGN(size) / PAGE_SIZE;
+	if (l->length <= 0) {
+		err = -EFAULT;
+		goto err;
+	}
+
+	l->pages = kmalloc(l->length * sizeof(*l->pages), GFP_ATOMIC);
+	if (!l->pages) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	down_write(&mm->mmap_sem);
+
+	l->addr = (void __user *) do_mmap(NULL, 0, l->length * PAGE_SIZE,
+			PROT_READ | PROT_WRITE,	MAP_PRIVATE | MAP_ANONYMOUS, 0);
+	if (IS_ERR(l->addr)) {
+		err = -ENOMEM;
+		goto err_sem;
+	}
+
+	WARN_ON(!IS_ALIGNED((unsigned long) l->addr, PAGE_SIZE));
+
+	pages = get_user_pages(current, mm, (unsigned long) l->addr, l->length,
+				1, 0, l->pages, NULL);
+	if (pages != l->length) {
+		err = -EFAULT;
+		goto err_mmap;
+	}
+
+	up_write(&mm->mmap_sem);
+
+	return 0;
+err_mmap:
+	do_munmap(mm, (unsigned long) l->addr, l->length * PAGE_SIZE);
+err_sem:
+	up_write(&mm->mmap_sem);
+	kfree(l->pages);
+err:
+	return err;
+}
+
+static int free_userspace_mapping(struct lwp_userspace *l, struct mm_struct *mm)
+{
+	int err = 0, i;
+
+	for (i = 0; i < l->length; i++)
+		put_page(l->pages[i]);
+
+	kfree(l->pages);
+
+	down_write(&mm->mmap_sem);
+	err = do_munmap(mm, (unsigned long) l->addr, l->length * PAGE_SIZE);
+	if (err)
+		goto err_sem;
+	up_write(&mm->mmap_sem);
+
+	return 0;
+err_sem:
+	up_write(&mm->mmap_sem);
+	return err;
+}
+
+static int userspace_write(struct page **dest, void *source, size_t length)
+{
+	int page;
+	size_t chk;
+	void *addr;
+	char *src = source;
+
+	for (page = 0, chk = 0; length > 0; page++, length -= chk) {
+		addr = __kmap_atomic(dest[page]);
+		if (!addr)
+			return -EFAULT;
+
+		chk = min(length, PAGE_SIZE);
+
+		memcpy(addr, src, chk);
+		src += chk;
+
+		__kunmap_atomic(addr);
+	}
+
+	return 0;
+}
+
+static int userwrite_lwpcb(struct lwp_struct *l)
+{
+	BUG_ON(l->active);
+	return userspace_write(l->userspace.lwpcb.pages, l->lwpcb.lwpcb_base,
+			l->lwpcb.size);
+}
+
+static int userwrite_buffer(struct lwp_struct *l)
+{
+	BUG_ON(l->active);
+	return userspace_write(l->userspace.buffer.pages,
+			l->buffer.buffer_base,
+			l->buffer.size);
+}
+
+static int userread_buffer(struct lwp_struct *l, u32 start_offset, u32 end_offset)
+{
+	int page;
+	size_t run, page_offset, length, chk;
+	size_t size = l->buffer.size;
+	char *kern_buf = l->buffer.buffer_base;
+	char *user_buf;
+	size_t page_count = l->userspace.buffer.length; /* in pages */
+	struct page **pages = l->userspace.buffer.pages;
+
+	/* start == end means that the interval is empty */
+	if (start_offset == end_offset)
+		return 0;
+
+	/*
+	 * The first case is the 'usual', but since this is a ringbuffer, the
+	 * end-Pointer could be below the start-Pointer. In this case we have
+	 * to read from start to ringbuffer-end and then from ringbuffer-start
+	 * to end.
+	 */
+	if(start_offset < end_offset)
+		length = end_offset - start_offset;
+	else
+		length = (size - start_offset) + end_offset;
+
+	/* end_offset points to the start of the last event */
+	length = min(length + l->eventsize, size);
+
+	run = start_offset;
+	/* region between start_offset and the its containing page */
+	page_offset = start_offset - rounddown(start_offset, PAGE_SIZE);
+
+	for (page = start_offset / PAGE_SIZE; length > 0;
+			length -= chk,
+			page = (page + 1) % page_count,
+			run = (run + chk) % size) {
+		user_buf = __kmap_atomic(pages[page]);
+		if (!user_buf)
+			return -EFAULT;
+
+		chk = min3(size - run, PAGE_SIZE - page_offset, length);
+		memcpy(kern_buf + run, user_buf + page_offset, chk);
+
+		/* after the first round we don't need the offset anymore */
+		page_offset ^= page_offset;
+
+		__kunmap_atomic(user_buf);
+	}
+
+	return 0;
+}
+
+static int userwrite_buffer_tail_offset(struct lwp_struct *l)
+{
+	struct lwpcb_head *head;
+
+	head = (struct lwpcb_head *)
+		kmap_atomic(l->userspace.lwpcb.pages[0], KM_USER0);
+
+	if (!head)
+		return -EFAULT;
+
+	head->buffer_tail_offset = l->lwpcb.head->buffer_tail_offset;
+
+	kunmap_atomic((void *) head, KM_USER0);
+
+	return 0;
+}
+
+static int lwp_active(struct lwp_struct *l)
+{
+	u64 lwpcb_addr;
+	rdmsrl(MSR_AMD64_LWP_CBADDR, lwpcb_addr);
+
+	if (lwpcb_addr) {
+		if (lwpcb_addr == (u64) l->userspace.lwpcb.addr)
+			return 1;
+		else
+			return -1;
+	}
+	return 0;
+}
+
+static int lwp_xsave_check(struct lwp_struct *l)
+{
+	struct lwp_state *xlwp = &current->thread.fpu.state->xsave.lwp;
+
+	/* TODO: correct conversion */
+	if (xlwp->lwpcb_addr &&
+			(xlwp->lwpcb_addr != (u64) l->userspace.lwpcb.addr))
+		return 1;
+
+	return 0;
+}
+
+static int lwp_read_head_offset(struct lwp_struct *l, u32 *bufferHeadOffset)
+{
+	int rc;
+
+	rc = lwp_active(l);
+	if (rc < 0) {
+		return 1;
+	} else if (rc > 0) {
+		/* flush hw-states */
+		save_xstates(current);
+	} else if (lwp_xsave_check(l)) {
+		return 1;
+	}
+
+	*bufferHeadOffset =
+		current->thread.fpu.state->xsave.lwp.buf_head_offset;
+
+	return 0;
+}
+
+static int lwp_stop(struct lwp_struct *l)
+{
+	int rc, i;
+	struct lwp_state *xlwp;
+
+	xlwp = &current->thread.fpu.state->xsave.lwp;
+
+	/*
+	 * this might set xsave_hdr.xstate_bv[62] to 0, which should be 1 if
+	 * we want to restore the area later (with new values or not)
+	 *
+	 * saves all states into the xstate area
+	 */
+	rc = lwp_active(l);
+	if (rc < 0) {
+		return 1;
+	} else if (rc > 0) {
+		save_xstates(current);
+		/* turns lwp off immediately */
+		wrmsrl(MSR_AMD64_LWP_CBADDR, 0);
+
+		for (i = 0; i < l->eventmax; i++) {
+			if (vector_test(i+1, xlwp->flags))
+				l->xstate_counter[i] = xlwp->event_counter[i];
+		}
+	} else if (lwp_xsave_check(l)) {
+		return 1;
+	}
+
+	l->active = 0;
+
+	return 0;
+}
+
+static int lwp_clear(struct lwp_struct *l)
+{
+	struct lwp_state *xlwp;
+
+	if (lwp_stop(l))
+		return 1;
+
+	xlwp = &current->thread.fpu.state->xsave.lwp;
+	memset(xlwp, 0, sizeof(*xlwp));
+
+	/* indicate the lwp-xsave-area is no longer valid */
+	current->thread.fpu.state->xsave.xsave_hdr.xstate_bv &=
+		~(((u64) 1) << 62);
+	restore_xstates(current, task_thread_info(current)->xstate_mask);
+
+	return 0;
+}
+
+static int lwp_start(struct lwp_struct *l, int update)
+{
+	int i;
+	struct lwp_state *xlwp;
+	struct lwpcb_head *head = l->lwpcb.head;
+
+	if (lwp_active(l))
+		return 1;
+
+	xlwp = &current->thread.fpu.state->xsave.lwp;
+
+	if (!xlwp->lwpcb_addr) {
+		xlwp->lwpcb_addr = (u64) l->userspace.lwpcb.addr;
+		xlwp->flags = head->flags & LWP_EVENT_MASK;
+		xlwp->buf_head_offset = head->buffer_head_offset;
+		xlwp->buf_base = head->buffer_base;
+		xlwp->buf_size = head->buffer_size;
+		xlwp->filters = head->filters;
+		memset(xlwp->saved_event_record, 0,
+				sizeof(xlwp->saved_event_record));
+		memset(xlwp->event_counter, 0,
+				sizeof(xlwp->event_counter));
+	} else {
+		if (update) {
+			xlwp->flags = head->flags & LWP_EVENT_MASK;
+			xlwp->filters = head->filters;
+		}
+	}
+
+	for (i = 0; i < l->eventmax; i++) {
+		if (vector_test(i+1, xlwp->flags))
+			xlwp->event_counter[i] = l->xstate_counter[i];
+	}
+
+	/*
+	 * if we used lwp_stop without lwp being enabled
+	 * ???: is xstate_bv used or is it just a copy of the last xsave?
+	 */
+	current->thread.fpu.state->xsave.xsave_hdr.xstate_bv |=
+		((u64) 1) << 62;
+	restore_xstates(current, task_thread_info(current)->xstate_mask);
+
+	l->active = 1;
+
+	return 0;
+}
+
+static int perf_lwp_event_init(struct perf_event *event)
+{
+	return -EINVAL;
+}
+
+static struct lwp_struct *lwpcb_get(struct perf_event *event)
+{
+	struct lwp_struct *lwpcb;
+
+	/* TODO: has to be locked in later cross-lwp-implementations */
+	lwpcb = (struct lwp_struct *) event->hw.config;
+	kref_get(&lwpcb->ref_count);
+
+	return lwpcb;
+}
+
+static struct lwp_struct *lwpcb_new(void)
+{
+	int err;
+	char *lwpcb_base;
+	struct lwp_struct *l;
+
+	l = kmalloc(sizeof(*l), GFP_ATOMIC);
+	if (!l)
+		return ERR_PTR(-ENOMEM);
+	memset(l, 0, sizeof(*l));
+
+	l->owner = current;
+	l->active = 0;
+
+	l->eventsize = lwp_caps.size_event;
+	l->eventmax = lwp_caps.size_max_event_id;
+
+	/* l->cap.size_lwpcb contains expected size in quadwords */
+	l->lwpcb.size = lwp_caps.size_lwpcb * 8;
+	kref_init(&l->ref_count);
+	raw_spin_lock_init(&l->lock);
+
+	/* the kernel-space is cloned into the per-task-user-space */
+	lwpcb_base = kmalloc(l->lwpcb.size, GFP_ATOMIC);
+	if (!lwpcb_base) {
+		err = -ENOMEM;
+		goto err_lwpcb_alloc;
+	}
+	memset(lwpcb_base, 0, l->lwpcb.size);
+
+	l->lwpcb.lwpcb_base = lwpcb_base;
+	l->lwpcb.head = (struct lwpcb_head *) lwpcb_base;
+	l->lwpcb.events = (struct lwpcb_event *)
+		(lwpcb_base + lwp_caps.size_event_offset);
+
+	/*
+	 * the spec requires at least
+	 * 32 * caps.size_buffer_min * l->eventsize
+	 * we let 128 records be our minimum (1 Page)
+	 * = 32KB (v1)
+	 */
+	l->buffer.size = (32 * ((lwp_caps.features >> 16) & 0xFF));
+	if (l->buffer.size < 128)
+		l->buffer.size = 128;
+	l->buffer.size *= l->eventsize;
+	l->buffer.buffer_base = kmalloc(l->buffer.size, GFP_ATOMIC);
+	if (!l->buffer.buffer_base) {
+		err = -ENOMEM;
+		goto err_lwpcbspace_alloc;
+	}
+	memset(l->buffer.buffer_base, 0, l->buffer.size);
+
+	l->event_counter = kmalloc(l->eventmax * sizeof(*l->event_counter),
+				   GFP_ATOMIC);
+	if(!l->event_counter) {
+		err = -ENOENT;
+		goto err_lwpcbbuffer_alloc;
+	}
+	memset(l->event_counter, 0, l->eventmax * sizeof(*l->event_counter));
+
+	l->userspace.mm = get_task_mm(current);
+
+	err = get_userspace_mapping(&l->userspace.lwpcb, l->userspace.mm,
+			l->lwpcb.size);
+	if (err)
+		goto err_mm;
+
+	err = get_userspace_mapping(&l->userspace.buffer, l->userspace.mm,
+			l->buffer.size);
+	if (err)
+		goto err_ulwpcb;
+
+	/* modified on event-start */
+	l->lwpcb.head->flags = 0;
+	l->lwpcb.head->buffer_size = l->buffer.size;
+	l->lwpcb.head->buffer_base = (u64) l->userspace.buffer.addr;
+	/* currently not supported by this pmu */
+	l->lwpcb.head->random = 0;
+	/* l->lwpcb.head->buffer_head_offset = 0;
+	 * l->lwpcb.head->missed_events = 0; */
+	l->lwpcb.head->threshold = 1 * l->eventsize;
+	/* modified on event-start */
+	l->lwpcb.head->filters = 0;
+	/* l->lwpcb.head->base_ip = 0;
+	 * l->lwpcb.head->limit_ip = 0; */
+	l->lwpcb.head->buffer_tail_offset = 0;
+
+	/* init userspace */
+	err = userwrite_lwpcb(l);
+	if (err)
+		goto err_ubuffer;
+
+	err = userwrite_buffer(l);
+	if (err)
+		goto err_ubuffer;
+
+	return l;
+err_ubuffer:
+	free_userspace_mapping(&l->userspace.buffer, l->userspace.mm);
+err_ulwpcb:
+	free_userspace_mapping(&l->userspace.lwpcb, l->userspace.mm);
+err_mm:
+	mmput(l->userspace.mm);
+
+	kfree(l->event_counter);
+err_lwpcbbuffer_alloc:
+	kfree(l->buffer.buffer_base);
+err_lwpcbspace_alloc:
+	kfree(l->lwpcb.lwpcb_base);
+err_lwpcb_alloc:
+	kfree(l);
+	return ERR_PTR(err);
+}
+
+static void lwpcb_destory(struct kref *kref)
+{
+	struct lwp_struct *l = container_of(kref, struct lwp_struct,
+						ref_count);
+
+	/*
+	 * we are the last one still standing, no locking required
+	 * (if we use kref correctly)
+	 */
+
+	BUG_ON(l->active);
+	BUG_ON(in_interrupt());
+
+	if (lwp_clear(l))
+		BUG();
+
+	free_userspace_mapping(&l->userspace.lwpcb, l->userspace.mm);
+	free_userspace_mapping(&l->userspace.buffer, l->userspace.mm);
+	mmput(l->userspace.mm);
+
+	kfree(l->event_counter);
+	kfree(l->buffer.buffer_base);
+	kfree(l->lwpcb.lwpcb_base);
+	kfree(l);
+}
+
+static void lwpcb_add_event(struct lwp_struct *lwps, u32 eventnr, u16 filter,
+		u64 sample)
+{
+	struct lwpcb_head *head = lwps->lwpcb.head;
+	struct lwpcb_event *events = lwps->lwpcb.events;
+	u32 filters = head->filters;
+
+	WARN_ON(lwps->active);
+
+	if (filter)
+		filters |= get_filter_vector(eventnr, filter);
+
+	head->filters = filters;
+	events[eventnr-1].interval = sample;
+	events[eventnr-1].counter = 0;
+}
+
+static void lwpcb_remove_event(struct lwp_struct *lwps, u32 eventnr)
+{
+	WARN_ON(lwps->active);
+
+	lwps->lwpcb.events[eventnr-1].interval = 0;
+	lwps->lwpcb.events[eventnr-1].counter = 0;
+}
+
+static int lwpcb_read_buffer(struct lwp_struct *l)
+{
+	u32 bho, bto, bz;
+	int count, i;
+	char *buffer = l->buffer.buffer_base;
+	struct lwp_event *event;
+
+	bz = l->lwpcb.head->buffer_size;
+
+	bto = l->lwpcb.head->buffer_tail_offset;
+	buffer += bto;
+
+	/*
+	 * the last two checks are to prevent user-manipulations that could
+	 * cause damage
+	 */
+	if (lwp_read_head_offset(l, &bho) || (bho > bz) || (bho % l->eventsize))
+		BUG();
+
+	count = (((bho - bto) % bz) / l->eventsize);
+	if(count <= 0)
+		return 0;
+
+	/* todo read only needed chunks */
+	if (userread_buffer(l, bto, bho))
+		BUG();
+
+	for (i = 0; i < count; i++) {
+		event = (struct lwp_event *) (buffer + bto);
+
+		/*
+		 * The opposite COULD be a programmed lwp-event (id=255), but we
+		 * ignore them for now.
+		 */
+		if ((event->event_id > LWP_EVENT_INVALID) ||
+				(event->event_id < LWP_EVENT_MAX)) {
+			l->event_counter[event->event_id - 1] +=
+				l->lwpcb.events[event->event_id - 1].interval;
+		}
+
+		bto += l->eventsize;
+		if (bto >= bz)
+			bto = 0;
+	}
+
+	l->lwpcb.head->buffer_tail_offset = bto;
+
+	if (userwrite_buffer_tail_offset(l))
+		BUG();
+
+	return 0;
+}
+
+static void perf_lwp_event_destroy(struct perf_event *event)
+{
+	struct lwp_struct *l = (struct lwp_struct *) event->hw.config;
+	/* ???: is it possible to modify event->attr.config at runtime? */
+	u32 eventnr = lwp_config_event_get(event->attr.config);
+	unsigned long flags;
+
+	/* this event has already a valid copy of the lwpcb */
+
+	WARN_ON(!(event->hw.state & PERF_HES_STOPPED));
+	BUG_ON(current != l->owner);
+
+	raw_spin_lock_irqsave(&l->lock, flags);
+
+	if (lwp_stop(l))
+		BUG();
+
+	lwpcb_remove_event(l, eventnr);
+
+	if (userwrite_lwpcb(l))
+		BUG();
+
+	l->event_counter[eventnr-1] = 0;
+	l->xstate_counter[eventnr-1] = 0;
+
+	if ((l->lwpcb.head->flags & LWP_EVENT_MASK) && lwp_start(l, 1))
+		BUG();
+
+	raw_spin_unlock_irqrestore(&l->lock, flags);
+
+	/* for future with cross-lwp-creation this needs to be locked */
+	kref_put(&l->ref_count, lwpcb_destory);
+}
+
+static int
+perf_lwp_event_init_for(struct perf_event *event, int cpu,
+		    struct task_struct *task)
+{
+	int err;
+	unsigned long flags;
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_event_attr *attr = &event->attr;
+	struct task_struct *target, *observer;
+	struct perf_event_context *ctx;
+	struct perf_event *e;
+	struct lwp_struct *lwpcb;
+	u32 eventnr;
+	u16 filter;
+
+	if (perf_lwp_pmu.type != event->attr.type)
+		return -ENOENT;
+
+	observer = current;
+
+	if (event->attach_state != PERF_ATTACH_TASK || event->cpu != -1)
+		return -EINVAL;
+
+	target = task;
+
+	/* current restriction, till the mmap-problem is solved */
+	if (target != observer)
+		return -EINVAL;
+
+	if (attr->config & ~LWP_CONFIG_MASK)
+		return -EINVAL;
+
+	eventnr = (u32) lwp_config_event_get(attr->config);
+	if ((eventnr <= LWP_EVENT_INVALID) || (eventnr >= LWP_EVENT_MAX) ||
+		(eventnr > lwp_caps.size_max_event_id) ||
+		(!test_bit(eventnr, &lwp_caps.available_events)))
+		return -EINVAL;
+
+	filter = lwp_config_filter_get(attr->config);
+	if (filter & get_filter_mask_for(eventnr))
+		return -EINVAL;
+
+	/* either to big (>26 Bit) or to small (<16) */
+	if ((hwc->sample_period < 0xF) || (hwc->sample_period >= 0x2000000))
+		return -EINVAL;
+
+	/*
+	 * we need to check if there is already a lwp-event running for this
+	 * task, if so, we don't need to create a new lwpcb, just update it
+	 *
+	 * to do so, first get the context of the task and lock it
+	 */
+
+	ctx = perf_find_get_context(&perf_lwp_pmu, task, cpu);
+	/* strange but possible, most likely due to memory-shortage */
+	if (IS_ERR(ctx))
+		return (int) PTR_ERR(ctx);
+
+	/*
+	 * now we have a valid context, lets lock the event-list so it can't be
+	 * modified
+	 */
+	mutex_lock(&ctx->mutex);
+	rcu_read_lock();
+
+	/* ok, lets look for a lwp-event */
+	list_for_each_entry_rcu(e, &ctx->event_list, event_entry) {
+		if (e->pmu == &perf_lwp_pmu)
+			break;
+	}
+
+	if (e->pmu != &perf_lwp_pmu) {
+		/* there is currently no running lwp-event */
+
+		/*
+		 * TODO: for later implementation of cross-lwp-creation we need
+		 * to introduce a lock here, to prevent other threads from
+		 * racing the creation of the lwpcb
+		 *
+		 * maybe we would better introduce a lwp-field in the
+		 * event-context to prevent two events racing this
+		 */
+
+		rcu_read_unlock();
+
+		lwpcb = lwpcb_new();
+		if (IS_ERR(lwpcb)) {
+			err = -ENOMEM;
+			goto err_lwpcbnew_failed;
+		}
+	} else {
+		/* found a running lwp-event */
+
+		lwpcb = lwpcb_get(e);
+		rcu_read_unlock();
+	}
+
+	hwc->config = (u64) lwpcb;
+	hwc->state = PERF_HES_STOPPED;
+
+	raw_spin_lock_irqsave(&lwpcb->lock, flags);
+
+	if (lwpcb->lwpcb.events[eventnr-1].interval) {
+		err = -EINVAL;
+		goto err_add_failed;
+	}
+
+	if (lwp_stop(lwpcb)) {
+		err = -EFAULT;
+		goto err_add_failed;
+	}
+
+	lwpcb_add_event(lwpcb, eventnr, filter, hwc->sample_period);
+	if(userwrite_lwpcb(lwpcb))
+		BUG();
+
+	lwpcb->event_counter[eventnr-1] = 0;
+	lwpcb->xstate_counter[eventnr-1] = 0;
+
+	event->destroy = perf_lwp_event_destroy;
+
+	if ((lwpcb->lwpcb.head->flags & LWP_EVENT_MASK) && lwp_start(lwpcb, 1))
+		BUG();
+
+	raw_spin_unlock_irqrestore(&lwpcb->lock, flags);
+
+	mutex_unlock(&ctx->mutex);
+	perf_release_context(ctx);
+
+	return 0;
+err_add_failed:
+	raw_spin_unlock_irqrestore(&lwpcb->lock, flags);
+	perf_lwp_event_destroy(event);
+err_lwpcbnew_failed:
+	mutex_unlock(&ctx->mutex);
+	perf_release_context(ctx);
+
+	return err;
+}
+
+static void perf_lwp_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct lwp_struct *l = (struct lwp_struct *) event->hw.config;
+	u32 eventnr = lwp_config_event_get(event->attr.config);
+	u32 lwpflags;
+	unsigned long lockflags = 0;
+
+	/* update cached values, before updating freq */
+	raw_spin_lock_irqsave(&l->lock, lockflags);
+	lwpcb_read_buffer(l);
+	raw_spin_unlock_irqrestore(&l->lock, lockflags);
+
+	lockflags = 0;
+	raw_spin_lock_irqsave(&l->lock, lockflags);
+
+	/* TODO: need a good way to handle takeovers of lwp by current */
+	if (lwp_stop(l))
+		BUG();
+
+	hwc->state = 0;
+
+	/* counters get reloaded every lwp_start
+	if (flags & PERF_EF_RELOAD) { DEBUG("reload counter"); }	*/
+
+	/* This implies that we currently not support 64 Bit-Counter */
+	if (hwc->sample_period < LWP_EVENT_MIN_PERIOD) {
+		__WARN();
+		hwc->sample_period = LWP_EVENT_MIN_PERIOD;
+	} else if (hwc->sample_period > LWP_EVENT_MAX_PERIOD) {
+		__WARN();
+		hwc->sample_period = LWP_EVENT_MAX_PERIOD;
+	}
+	l->lwpcb.events[eventnr-1].interval = hwc->sample_period;
+
+	lwpflags = l->lwpcb.head->flags;
+	lwpflags |= (1U << eventnr);
+	l->lwpcb.head->flags = lwpflags;
+
+	/* TODO: need a good way to handle mm-changes by current */
+	if (userwrite_lwpcb(l))
+		BUG();
+
+	if (lwp_start(l, 1))
+		BUG();
+
+	raw_spin_unlock_irqrestore(&l->lock, lockflags);
+
+	perf_event_update_userpage(event);
+}
+
+static void perf_lwp_stop(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct lwp_struct *l = (struct lwp_struct *) event->hw.config;
+	u32 eventnr = lwp_config_event_get(event->attr.config);
+	u32 lwpflags;
+	unsigned long lockflags = 0;
+
+	raw_spin_lock_irqsave(&l->lock, lockflags);
+
+	if (lwp_stop(l))
+		BUG();
+
+	/* counter get updated every stop, for each active event */
+	hwc->state = PERF_HES_STOPPED | PERF_HES_UPTODATE;
+
+	lwpflags = l->lwpcb.head->flags;
+	lwpflags &= ~(1U << eventnr);
+	l->lwpcb.head->flags = lwpflags;
+
+	if (userwrite_lwpcb(l))
+		BUG();
+
+	if (lwpflags & LWP_EVENT_MASK) {
+		if (lwp_start(l, 1))
+			BUG();
+	}
+
+	raw_spin_unlock_irqrestore(&l->lock, lockflags);
+
+	/* update cached values */
+	lockflags = 0;
+	raw_spin_lock_irqsave(&l->lock, lockflags);
+	lwpcb_read_buffer(l);
+	raw_spin_unlock_irqrestore(&l->lock, lockflags);
+
+	perf_event_update_userpage(event);
+}
+
+static int perf_lwp_add(struct perf_event *event, int flags)
+{
+	if (flags & PERF_EF_START)
+		perf_lwp_start(event, flags);
+
+	return 0;
+}
+
+static void perf_lwp_del(struct perf_event *event, int flags)
+{
+	perf_lwp_stop(event, flags);
+}
+
+static void perf_lwp_read(struct perf_event *event)
+{
+	struct lwp_struct *l = (struct lwp_struct *) event->hw.config;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&l->lock, flags);
+
+	lwpcb_read_buffer(l);
+
+	raw_spin_unlock_irqrestore(&l->lock, flags);
+}
+
+static struct pmu perf_lwp_pmu = {
+	.task_ctx_nr	= perf_permanent_context,
+
+	.event_init	= perf_lwp_event_init,
+	.event_init_for = perf_lwp_event_init_for,
+	.add		= perf_lwp_add,
+	.del		= perf_lwp_del,
+	.start		= perf_lwp_start,
+	.stop		= perf_lwp_stop,
+	.read		= perf_lwp_read,
+};
+
+static int perf_lwp_init_pmu(void)
+{
+	int ret;
+
+	ret = perf_pmu_register(&perf_lwp_pmu, "lwp", -1);
+	if (ret)
+		return ret;
+
+	printk(KERN_INFO "perf: registered LWP-PMU (type-id: %d)",
+			perf_lwp_pmu.type);
+
+	return 0;
+}
 
 static void get_lwp_caps(struct lwp_capabilities *caps)
 {
@@ -111,6 +1282,12 @@ static __init int amd_lwp_init(void)
 
 	get_online_cpus();
 
+	/*
+	 * The global 'lwp_caps' has to be known to all functions after this.
+	 *
+	 * For the SMP-case we relay on the implicit fence of smp_call_function
+	 * and in the none-SMP-case on the barrier afterwards.
+	 */
 	barrier();
 
 	perf_cpu_notifier(lwp_cpu_notifier);
@@ -132,7 +1309,7 @@ static __init int amd_lwp_init(void)
 			lwp_caps.size_event_offset, lwp_caps.features,
 			lwp_caps.supported_events);
 
-	return 0;
+	return perf_lwp_init_pmu();
 }
 
 device_initcall(amd_lwp_init);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0c6fae6..2539f6f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -971,6 +971,11 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr,
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
 
+extern struct perf_event_context *
+perf_find_get_context(struct pmu *pmu, struct task_struct *task,
+		     int cpu);
+extern void perf_release_context(struct perf_event_context *ctx);
+
 struct perf_sample_data {
 	u64				type;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index fd18d70..99715c0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2920,6 +2920,34 @@ errout:
 	return ERR_PTR(err);
 }
 
+/*
+ * Returns a matching context with refcount and pincount incremented.
+ * Tries to find a matching context for the given combination of PMU, task
+ * and CPU, which is a tasks context if task is given and a CPU-context if
+ * not.
+ *
+ * If a matching context is found, the pin-count and the ref-count of the
+ * context will be incremented. You have to decrement them again, if you're
+ * done with the context.
+ * They both protect the context from being freed and from being swapped away
+ * from the task/cpu.
+ */
+struct perf_event_context *
+perf_find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
+{
+	return find_get_context(pmu, task, cpu);
+}
+
+/*
+ * Release your valid pointer to the context, it will be invalid afterwards!
+ */
+void
+perf_release_context(struct perf_event_context *ctx)
+{
+	perf_unpin_context(ctx);
+	put_ctx(ctx);
+}
+
 static void perf_event_free_filter(struct perf_event *event);
 
 static void free_event_rcu(struct rcu_head *head)
-- 
1.7.7


