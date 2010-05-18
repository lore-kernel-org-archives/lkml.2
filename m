Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab0ERPMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:12:48 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:59226 "EHLO
	mail85-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757867Ab0ERPMq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:12:46 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lab9bhzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0L2MFKK-02-B61-02
X-M-MSG: 
Date: Tue, 18 May 2010 17:12:27 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] perf: align raw sample data on 64-bit boundaries
Message-ID: <20100518151227.GJ21799@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-13-git-send-email-robert.richter@amd.com>
 <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.10 14:19:57, Stephane Eranian wrote:
> > +       perf_sample_data_init(&data, 0);
> > +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> > +               for (i = 1; i < size; i++)
> > +                       rdmsrl(msr++, *buf++);
> > +               raw.size = sizeof(u64) * size;
> > +               raw.data = buffer;
> > +               data.raw = &raw;
> > +       }
> > +
> 
> Need to add the padding: raw.size = sizeof(u64) * size + sizeof(u32);

When thinking about this I was wondering if it wouldn't make sense to
better fix the alignment and move the data buffer to a 64 bit
boundary. So take a look at the enclosed RFC patch. Though it breaks
the ABI it would solve some problems. I think more than it introduces.
Hopefully I found all effected code locations using it.

-Robert

--

>From 2427dda67b072f27ecff678f8829b9e2fc537988 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 7 May 2010 15:32:45 +0200
Subject: [PATCH] perf: align raw sample data on 64-bit boundaries

In the current implementation 64 bit raw sample data values are not
aligned due to the 32 bit size header. The size header is located
before the data buffer on a 64 bit boundary. This leads to unaligned
memory access to the data buffer for arrays or structures containing
64 bit values. To avoid this, the patch adds a 32 bit reserved value
to the raw sample data header. The data buffer starts then at a 64 bit
boundary.

This changes the ABI and requires changes in the userland tools. For
tools/perf this is at a single location in event.c only. This could
also introduce some overhead on smaller architectures, but currently
this is only used on x86 or for transferring raw tracepoint
data. Though an ABI change should be avoided, it is worth to align raw
sample data on 64-bit boundaries as the change fixes unaligned memory
access, eases the implementation for raw sample data and reduces the
risk of data corruption due to different pad structures inserted by
the compiler.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/linux/perf_event.h    |    1 +
 kernel/perf_event.c           |   21 ++++++++++-----------
 kernel/trace/trace_kprobe.c   |    6 ++----
 kernel/trace/trace_syscalls.c |    6 ++----
 tools/perf/util/event.c       |    4 ++--
 5 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 3fd5c82..016969c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -431,6 +431,7 @@ enum perf_event_type {
 	 *	#
 	 *
 	 *	{ u32			size;
+	 *	  u32			reserved;
 	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
 	 * };
 	 */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a4fa381..12bb53d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3252,18 +3252,19 @@ void perf_output_sample(struct perf_output_handle *handle,
 	}
 
 	if (sample_type & PERF_SAMPLE_RAW) {
+		struct {
+			u32	size;
+			u32	reserved;
+		} raw = {
+			.size = 0,
+			.reserved = 0,
+		};
 		if (data->raw) {
-			perf_output_put(handle, data->raw->size);
+			raw.size = data->raw->size;
+			perf_output_put(handle, raw);
 			perf_output_copy(handle, data->raw->data,
 					 data->raw->size);
 		} else {
-			struct {
-				u32	size;
-				u32	data;
-			} raw = {
-				.size = sizeof(u32),
-				.data = 0,
-			};
 			perf_output_put(handle, raw);
 		}
 	}
@@ -3344,12 +3345,10 @@ void perf_prepare_sample(struct perf_event_header *header,
 	}
 
 	if (sample_type & PERF_SAMPLE_RAW) {
-		int size = sizeof(u32);
+		int size = sizeof(u64);
 
 		if (data->raw)
 			size += data->raw->size;
-		else
-			size += sizeof(u32);
 
 		WARN_ON_ONCE(size & (sizeof(u64)-1));
 		header->size += size;
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index a751432..00172b0 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1347,8 +1347,7 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	int rctx;
 
 	__size = sizeof(*entry) + tp->size;
-	size = ALIGN(__size + sizeof(u32), sizeof(u64));
-	size -= sizeof(u32);
+	size = ALIGN(__size, sizeof(u64));
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
 		     "profile buffer not large enough"))
 		return;
@@ -1378,8 +1377,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	int rctx;
 
 	__size = sizeof(*entry) + tp->size;
-	size = ALIGN(__size + sizeof(u32), sizeof(u64));
-	size -= sizeof(u32);
+	size = ALIGN(__size, sizeof(u64));
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
 		     "profile buffer not large enough"))
 		return;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4d6d711..ad7e713 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -453,8 +453,7 @@ static void perf_syscall_enter(struct pt_regs *regs, long id)
 
 	/* get the size after alignment with the u32 buffer size field */
 	size = sizeof(unsigned long) * sys_data->nb_args + sizeof(*rec);
-	size = ALIGN(size + sizeof(u32), sizeof(u64));
-	size -= sizeof(u32);
+	size = ALIGN(size, sizeof(u64));
 
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
 		      "perf buffer not large enough"))
@@ -524,8 +523,7 @@ static void perf_syscall_exit(struct pt_regs *regs, long ret)
 		return;
 
 	/* We can probably do that at build time */
-	size = ALIGN(sizeof(*rec) + sizeof(u32), sizeof(u64));
-	size -= sizeof(u32);
+	size = ALIGN(sizeof(*rec), sizeof(u64));
 
 	/*
 	 * Impossible, but be paranoid with the future
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 50771b5..6902b85 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -790,8 +790,8 @@ int event__parse_sample(event_t *event, u64 type, struct sample_data *data)
 	if (type & PERF_SAMPLE_RAW) {
 		u32 *p = (u32 *)array;
 		data->raw_size = *p;
-		p++;
-		data->raw_data = p;
+		array++;
+		data->raw_data = array;
 	}
 
 	return 0;
-- 
1.7.1

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

