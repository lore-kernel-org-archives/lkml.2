Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1AEHLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 02:11:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:62016 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab1AEHLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 02:11:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,276,1291622400"; 
   d="scan'208";a="370251991"
Subject: Re: [PATCH 7/7] perf: Add load latency monitoring on Intel
 Nehalem/Westmere v2
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1294142361.2016.131.camel@laptop>
References: <1293464397.2695.109.camel@localhost>
	 <1294142361.2016.131.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 15:12:06 +0800
Message-ID: <1294211526.9261.39.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 19:59 +0800, Peter Zijlstra wrote:
> On Mon, 2010-12-27 at 23:39 +0800, Lin Ming wrote:
> 
> > +/*
> > + * Load latency data source encoding
> > + */
> > +
> > +/* Bits(0-1) {L1, L2, L3, RAM} or {unknown, IO, uncached} */
> > +#define LD_LAT_L1			0x00
> > +#define LD_LAT_L2			0x01
> > +#define LD_LAT_L3			0x02
> > +#define LD_LAT_RAM			0x03
> > +#define LD_LAT_UNKNOWN			0x00
> > +#define LD_LAT_IO			0x01
> > +#define LD_LAT_UNCACHED			0x02
> > +
> > +/* Bits(2-3) {not-used, snoop, local, remote} */
> > +#define LD_LAT_NOT_USED			(0x00 << 2)
> > +#define LD_LAT_SNOOP			(0x01 << 2)
> > +#define LD_LAT_LOCAL			(0x02 << 2)
> > +#define LD_LAT_REMOTE			(0x03 << 2)
> > +
> > +/* Bits(4-5) {modified, exclusive, shared, invalid} */
> > +#define LD_LAT_MODIFIED			(0x00 << 4)
> > +#define LD_LAT_EXCLUSIVE		(0x01 << 4)
> > +#define LD_LAT_SHARED			(0x02 << 4)
> > +#define LD_LAT_INVALID			(0x03 << 4)
> > +
> > +#define LD_LAT_RESERVED			0x3F
> 
> Hmm, why is that RESREVED? From what I can see that ends up being:
>   RAM-remote-invalid

My bad, will fix this.

> 
> Which brings us to the NOT_USED thing, from what I can see its the value
> that toggles between {L1, L2, L3, RAM} and {unknown, IO, uncached},
> that's not NOT_USED.

Right,

-#define LD_LAT_NOT_USED                 (0x00 << 2)
+#define LD_LAT_TOGGLE                   (0x00 << 2)

But this name sounds strange, do you have a better name?

> 
> There's still room for a {reserved} value in that alternative set,
> making it: {unknown, IO, uncached, reserved}
> 
> Which would make
> 
> #define EXTRA_SRC_RESERVED 0x03

OK

> 
> 
> > @@ -384,6 +387,10 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
> >  		if (extra & ~er->valid_mask)
> >  			return -EINVAL;
> >  		event->hw.extra_config = extra;
> > +
> > +		/* The minimum value that may be programmed into MSR_PEBS_LD_LAT is 3 */
> > +		if (er->msr == MSR_PEBS_LD_LAT_THRESHOLD && extra < 3)
> > +			event->hw.extra_config = 3;
> >  		break;
> >  	}
> >  	return 0;
> 
> I'm not really sure about this, should we silently fix up or bail on
> invalid values?

Bailing on invalid values makes more sense.

> 
> > +/* Indexed by Intel load latency data source encoding value */
> > +
> > +static u64 intel_load_latency_data[] = {
> > +	LD_LAT_UNKNOWN,					/* 0x00: Unknown L3 */
> > +	LD_LAT_L1 | LD_LAT_LOCAL,			/* 0x01: L1-local */
> > +	LD_LAT_L2 | LD_LAT_SNOOP,			/* 0x02: L2-snoop */
> 
> I bet Stephane wants to argue more on this ;-)

Stephane, what do you think? :)

> 
> > +	LD_LAT_L2 | LD_LAT_LOCAL,			/* 0x03: L2-local */
> > +	LD_LAT_L3 | LD_LAT_SNOOP | LD_LAT_INVALID,	/* 0x04: L3-snoop, no coherency actions */
> > +	LD_LAT_L3 | LD_LAT_SNOOP | LD_LAT_SHARED,	/* 0x05: L3-snoop, found no M */
> > +	LD_LAT_L3 | LD_LAT_SNOOP | LD_LAT_MODIFIED,	/* 0x06: L3-snoop, found M */
> > +	LD_LAT_RESERVED,				/* 0x07: reserved */
> > +	LD_LAT_RAM | LD_LAT_SNOOP | LD_LAT_SHARED,	/* 0x08: L3-miss, snoop, shared */
> > +	LD_LAT_RESERVED,				/* 0x09: reserved */
> > +	LD_LAT_RAM | LD_LAT_LOCAL | LD_LAT_SHARED,	/* 0x0A: L3-miss, local, shared */
> > +	LD_LAT_RAM | LD_LAT_REMOTE | LD_LAT_SHARED,	/* 0x0B: L3-miss, remote, shared */
> > +	LD_LAT_RAM | LD_LAT_LOCAL | LD_LAT_EXCLUSIVE,	/* 0x0C: L3-miss, local, exclusive */
> > +	LD_LAT_RAM | LD_LAT_REMOTE | LD_LAT_EXCLUSIVE,	/* 0x0D: L3-miss, remote, exclusive */
> > +	LD_LAT_IO,					/* 0x0E: IO */
> > +	LD_LAT_UNCACHED,				/* 0x0F: Uncached */
> > +};
> 
> 
> > @@ -541,14 +567,10 @@ static int intel_pmu_save_and_restart(struct perf_event *event);
> >  static void __intel_pmu_pebs_event(struct perf_event *event,
> >  				   struct pt_regs *iregs, void *__pebs)
> >  {
> > -	/*
> > -	 * We cast to pebs_record_core since that is a subset of
> > -	 * both formats and we don't use the other fields in this
> > -	 * routine.
> > -	 */
> > -	struct pebs_record_core *pebs = __pebs;
> > +	struct pebs_record_nhm *pebs = __pebs;
> 
> 
> So you cast to the biggest and make sure you don't peek past the end of
> the actual data.. that might want to have a comment.

Will add a comment.

> 
> 
> > @@ -556,6 +578,19 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
> >  	perf_sample_data_init(&data, 0);
> >  	data.period = event->hw.last_period;
> >  
> > +	if (event->hw.extra_reg == MSR_PEBS_LD_LAT_THRESHOLD) {
> 
> This is what stops us from peeking past the end of the pebs record,
> since core would never end up having the LD_LAT extra_reg.
> 
> > +		sample_type = event->attr.sample_type;
> > +
> > +		if (sample_type & PERF_SAMPLE_ADDR)
> > +			data.addr = pebs->dla;
> > +
> > +		if (sample_type & PERF_SAMPLE_LATENCY)
> > +			data.latency = pebs->lat;
> > +
> > +		if (sample_type & PERF_SAMPLE_LATENCY_DATA)
> > +			data.latency_data = intel_load_latency_data[pebs->dse];
> 
> 
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index d24d9ab..9428a1b 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -124,9 +124,11 @@ enum perf_event_sample_format {
> >  	PERF_SAMPLE_CPU				= 1U << 7,
> >  	PERF_SAMPLE_PERIOD			= 1U << 8,
> >  	PERF_SAMPLE_STREAM_ID			= 1U << 9,
> > -	PERF_SAMPLE_RAW				= 1U << 10,
> > +	PERF_SAMPLE_LATENCY			= 1U << 10,
> > +	PERF_SAMPLE_LATENCY_DATA		= 1U << 11,
> > +	PERF_SAMPLE_RAW				= 1U << 12,
> >  
> > -	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
> > +	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
> >  };
> >  
> >  /*
> > @@ -958,6 +960,8 @@ struct perf_sample_data {
> >  	}				tid_entry;
> >  	u64				time;
> >  	u64				addr;
> > +	u64				latency;
> > +	u64				latency_data;
> >  	u64				id;
> >  	u64				stream_id;
> >  	struct {
> 
> Right, so I think I want this in 3 patches, one adding the load-latency
> extra reg thing and PERF_SAMPLE_ADDR usage, one adding
> PERF_SAMPLE_LATENCY and one adding PERF_SAMPLE_EXTRA, I really dislike
> the LATENCY_DATA name since that ties the extra data to the latency
> thing, which isn't at all true for other platforms.

OK, will use the EXTRA name and split the patches.

Thanks for review.
Below is the incremental patch. I'll send new version later.

Thanks,

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index e01259f..54a8bf9 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -79,7 +79,7 @@ union cpuid10_edx {
  * Load latency data source encoding
  */
 
-/* Bits(0-1) {L1, L2, L3, RAM} or {unknown, IO, uncached} */
+/* Bits(0-1) {L1, L2, L3, RAM} or {unknown, IO, uncached, reserved} */
 #define LD_LAT_L1			0x00
 #define LD_LAT_L2			0x01
 #define LD_LAT_L3			0x02
@@ -87,9 +87,10 @@ union cpuid10_edx {
 #define LD_LAT_UNKNOWN			0x00
 #define LD_LAT_IO			0x01
 #define LD_LAT_UNCACHED			0x02
+#define LD_LAT_RESERVED			0x03
 
-/* Bits(2-3) {not-used, snoop, local, remote} */
-#define LD_LAT_NOT_USED			(0x00 << 2)
+/* Bits(2-3) {toggle, snoop, local, remote} */
+#define LD_LAT_TOGGLE			(0x00 << 2)
 #define LD_LAT_SNOOP			(0x01 << 2)
 #define LD_LAT_LOCAL			(0x02 << 2)
 #define LD_LAT_REMOTE			(0x03 << 2)
@@ -100,7 +101,7 @@ union cpuid10_edx {
 #define LD_LAT_SHARED			(0x02 << 4)
 #define LD_LAT_INVALID			(0x03 << 4)
 
-#define LD_LAT_RESERVED			0x3F
+#define EXTRA_SRC_RESERVED		0x03
 
 /*
  * Fixed-purpose performance events:
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 713695e..cf2e12e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -386,11 +386,12 @@ static int x86_pmu_extra_regs(u64 config, struct perf_event *event)
 		extra = config >> er->extra_shift;
 		if (extra & ~er->valid_mask)
 			return -EINVAL;
-		event->hw.extra_config = extra;
 
 		/* The minimum value that may be programmed into MSR_PEBS_LD_LAT is 3 */
 		if (er->msr == MSR_PEBS_LD_LAT_THRESHOLD && extra < 3)
-			event->hw.extra_config = 3;
+			return -EINVAL;
+
+		event->hw.extra_config = extra;
 		break;
 	}
 	return 0;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 06c6107..f555f9f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -3,7 +3,7 @@
 /* Indexed by Intel load latency data source encoding value */
 
 static u64 intel_load_latency_data[] = {
-	LD_LAT_UNKNOWN,					/* 0x00: Unknown L3 */
+	LD_LAT_UNKNOWN | LD_LAT_TOGGLE,			/* 0x00: Unknown L3 */
 	LD_LAT_L1 | LD_LAT_LOCAL,			/* 0x01: L1-local */
 	LD_LAT_L2 | LD_LAT_SNOOP,			/* 0x02: L2-snoop */
 	LD_LAT_L2 | LD_LAT_LOCAL,			/* 0x03: L2-local */
@@ -17,8 +17,8 @@ static u64 intel_load_latency_data[] = {
 	LD_LAT_RAM | LD_LAT_REMOTE | LD_LAT_SHARED,	/* 0x0B: L3-miss, remote, shared */
 	LD_LAT_RAM | LD_LAT_LOCAL | LD_LAT_EXCLUSIVE,	/* 0x0C: L3-miss, local, exclusive */
 	LD_LAT_RAM | LD_LAT_REMOTE | LD_LAT_EXCLUSIVE,	/* 0x0D: L3-miss, remote, exclusive */
-	LD_LAT_IO,					/* 0x0E: IO */
-	LD_LAT_UNCACHED,				/* 0x0F: Uncached */
+	LD_LAT_IO | LD_LAT_TOGGLE,			/* 0x0E: IO */
+	LD_LAT_UNCACHED | LD_LAT_TOGGLE,		/* 0x0F: Uncached */
 };
 
 /* The maximal number of PEBS events: */
@@ -567,6 +567,10 @@ static int intel_pmu_save_and_restart(struct perf_event *event);
 static void __intel_pmu_pebs_event(struct perf_event *event,
 				   struct pt_regs *iregs, void *__pebs)
 {
+	/*
+	 * We cast to pebs_record_nhm to get the load latency data
+	 * if extra_reg MSR_PEBS_LD_LAT_THRESHOLD used
+	 */
 	struct pebs_record_nhm *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
@@ -587,8 +591,8 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 		if (sample_type & PERF_SAMPLE_LATENCY)
 			data.latency = pebs->lat;
 
-		if (sample_type & PERF_SAMPLE_LATENCY_DATA)
-			data.latency_data = intel_load_latency_data[pebs->dse];
+		if (sample_type & PERF_SAMPLE_EXTRA)
+			data.extra = intel_load_latency_data[pebs->dse];
 	}
 
 	/*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 9428a1b..0d80e0d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -125,7 +125,7 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_LATENCY			= 1U << 10,
-	PERF_SAMPLE_LATENCY_DATA		= 1U << 11,
+	PERF_SAMPLE_EXTRA			= 1U << 11,
 	PERF_SAMPLE_RAW				= 1U << 12,
 
 	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
@@ -960,8 +960,6 @@ struct perf_sample_data {
 	}				tid_entry;
 	u64				time;
 	u64				addr;
-	u64				latency;
-	u64				latency_data;
 	u64				id;
 	u64				stream_id;
 	struct {
@@ -969,6 +967,8 @@ struct perf_sample_data {
 		u32	reserved;
 	}				cpu_entry;
 	u64				period;
+	u64				latency;
+	u64				extra;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 };


