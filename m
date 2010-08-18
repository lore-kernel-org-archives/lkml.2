Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0HRSyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 14:54:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56634 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0HRSyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 14:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=O9GhTKpFVdL4V5YpXJNuE3dhmX25dDvAEZffjp5ByEG6wdPMq8Liei5PxT6uji0NVL
         yG3eFkyiqQH3j56pFuF2UARumdlOtDsqsi07Q0Wv5caFmH6uOqG8jy7oohnhTH5pnQW0
         vvLKr1TvG9sR9Xi10QwcD31aIpFzoqMGNTPg8=
Date: Wed, 18 Aug 2010 22:54:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] perf, x86: P4 PMU - check for INSTR_COMPLETED being
	supported by cpu
Message-ID: <20100818185445.GA11949@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INSTR_COMPLETED is supported on particular cpu models of Netburst family,
add a check for that.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Stephane Eranian <eranian@google.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frédéric Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
---

Hi Ming, please review this patch, and if you happened to have this
cpu models give it a try please (if you manage to find some spare time
of course). To test it we need RAW event P4_EVENT_INSTR_COMPLETED passed
on any model not mentioned in p4_event_match_cpu_model, and reverse ;)

 arch/x86/kernel/cpu/perf_event_p4.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -350,6 +350,11 @@ static __initconst const u64 p4_hw_cache
  },
 };
 
+/*
+ * If general events will ever have a reference to the
+ * P4_EVENT_INSTR_COMPLETED we would ought to check for
+ * cpu model match (see how it's done for RAW events)
+ */
 static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
   /* non-halted CPU clocks */
   [PERF_COUNT_HW_CPU_CYCLES] =
@@ -428,6 +433,27 @@ static u64 p4_pmu_event_map(int hw_event
 	return config;
 }
 
+/* check cpu model specifics */
+static bool p4_event_match_cpu_model(unsigned int event_idx)
+{
+	/* INSTR_COMPLETED event only exist for model 3, 4, 6 (Prescott) */
+	if (event_idx == P4_EVENT_INSTR_COMPLETED) {
+		if (boot_cpu_data.x86_model	!= 3 &&
+			boot_cpu_data.x86_model	!= 4 &&
+			boot_cpu_data.x86_model	!= 6) {
+			pr_warning("P4 PMU: Unsupported event: INSTR_COMPLETED\n");
+			return false;
+		}
+	}
+
+	/*
+	 * note the IQ_ESCR0, IQ_ESCR1 are available on models 1 and 2
+	 * only but since we don't use them at moment -- no check
+	 */
+
+	return true;
+}
+
 static int p4_validate_raw_event(struct perf_event *event)
 {
 	unsigned int v;
@@ -439,6 +465,10 @@ static int p4_validate_raw_event(struct 
 		return -EINVAL;
 	}
 
+	/* it may be unsupported */
+	if (!p4_event_match_cpu_model(v))
+		return -EINVAL;
+
 	/*
 	 * it may have some screwed PEBS bits
 	 */
