Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab1DZVTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:19:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50863 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab1DZVTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:19:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mRNNhYIuPN5M7429mYILzDRvjx6ywutgwSLKQyEiikz+kD451mA0Xhhnfku0xpy15u
         rL1yMxbk9/u7iZLKrGRUaQixNUGQ4OC2FgMb5KUnvoJ83019lwxktk3FmPTAX/pZOTfz
         GBzwaoSYon8YHAElBHMELtRTv5k4c8+KGrszE=
Message-ID: <4DB736CB.6040109@gmail.com>
Date: Wed, 27 Apr 2011 01:19:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Vince Weaver <vweaver1@eecs.utk.edu>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for config1/config2
References: <1303407662-15564-1-git-send-email-acme@infradead.org>  <1303407662-15564-2-git-send-email-acme@infradead.org>  <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu>  <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu> <1303809958.20212.219.camel@twins> <alpine.DEB.2.00.1104261617320.32482@cl320.eecs.utk.edu>
In-Reply-To: <alpine.DEB.2.00.1104261617320.32482@cl320.eecs.utk.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 12:33 AM, Vince Weaver wrote:
...
> 
> I spent a lot of time trying to fix P4 support back in the 2.6.35 days.
> I only have so much time to spend on this stuff. 
> 
> When people complain about p4 support, I direct them to Cyrill et al.  I 
> can't force them to become kernel developers.  Usually they want immediate 
> results, which they can get with perfctr.
> 

  Vince I've not read the whole thread so no idea what is all about, but if you
have some p4 machines and have some will to help -- mind to test the patch below,
it should fix nmi-watchdog and cycles conflict. It's utter raw RFC (and i know there
is a nit i should update) but still might be interesting to see the results.
Untested.
-- 
perf, x86: P4 PMU -- Introduce alternate events v3

Alternate events are used to increase perf subsystem counter usage.
In general the idea is to find an "alternate" event (if there is
one) which do count the same magnitude as former event but use
different counter allowing them to run simultaneously with original
event.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/perf_event_p4.h |    6 ++
 arch/x86/kernel/cpu/perf_event_p4.c  |   74 ++++++++++++++++++++++++++++++++++-
 2 files changed, 78 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -36,6 +36,10 @@
 #define P4_ESCR_T1_OS		0x00000002U
 #define P4_ESCR_T1_USR		0x00000001U

+#define P4_ESCR_USR_MASK			\
+	(P4_ESCR_T0_OS | P4_ESCR_T0_USR |	\
+	P4_ESCR_T1_OS | P4_ESCR_T1_USR)
+
 #define P4_ESCR_EVENT(v)	((v) << P4_ESCR_EVENT_SHIFT)
 #define P4_ESCR_EMASK(v)	((v) << P4_ESCR_EVENTMASK_SHIFT)
 #define P4_ESCR_TAG(v)		((v) << P4_ESCR_TAG_SHIFT)
@@ -839,5 +843,7 @@ enum P4_PEBS_METRIC {
  *       31:                    reserved (HT thread)
  */

+#define P4_INVALID_CONFIG	(u64)~0
+
 #endif /* PERF_EVENT_P4_H */

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -609,6 +609,31 @@ static u64 p4_general_events[PERF_COUNT_
 	p4_config_pack_cccr(P4_CCCR_EDGE | P4_CCCR_COMPARE),
 };

+/*
+ * Alternate events allow us to find substitution for an event if
+ * it's already borrowed, so they may be considered as event aliases.
+ */
+struct p4_alt_event {
+	unsigned int	event;
+	u64		config;
+} p4_alternate_events[]= {
+	{
+		.event		= P4_EVENT_GLOBAL_POWER_EVENTS,
+		.config		=
+			p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
+				P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)		|
+				P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)		|
+				P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)		|
+				P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)		|
+				P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)		|
+				P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)		|
+				P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)		|
+				P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))		|
+			p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT		|
+				P4_CCCR_COMPARE),
+	},
+};
+
 static struct p4_event_bind *p4_config_get_bind(u64 config)
 {
 	unsigned int evnt = p4_config_unpack_event(config);
@@ -620,6 +645,18 @@ static struct p4_event_bind *p4_config_g
 	return bind;
 }

+static u64 p4_find_alternate_config(unsigned int evnt)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(p4_alternate_events); i++) {
+		if (evnt == p4_alternate_events[i].event)
+			return p4_alternate_events[i].config;
+	}
+
+	return P4_INVALID_CONFIG;
+}
+
 static u64 p4_pmu_event_map(int hw_event)
 {
 	struct p4_event_bind *bind;
@@ -1133,8 +1170,41 @@ static int p4_pmu_schedule_events(struct
 		}

 		cntr_idx = p4_next_cntr(thread, used_mask, bind);
-		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask))
-			goto done;
+		if (cntr_idx == -1 || test_bit(escr_idx, escr_mask)) {
+
+			/*
+			 * So the former event already accepted to run
+			 * and the only way to success here is to use
+			 * an alternate event.
+			 */
+			const u64 usr_mask = p4_config_pack_escr(P4_ESCR_USR_MASK);
+			u64 alt_config;
+			unsigned int event;
+
+			event		= p4_config_unpack_event(hwc->config);
+			alt_config	= p4_find_alternate_config(event);
+
+			if (alt_config == P4_INVALID_CONFIG)
+				goto done;
+
+			bind = p4_config_get_bind(alt_config);
+			escr_idx = p4_get_escr_idx(bind->escr_msr[thread]);
+			if (unlikely(escr_idx == -1))
+				goto done;
+
+			cntr_idx = p4_next_cntr(thread, used_mask, bind);
+			if (cntr_idx == -1 || test_bit(escr_idx, escr_mask))
+				goto done;
+
+			/*
+			 * This is a destructive operation we're going
+			 * to make. We substitute the former config with
+			 * alternate one to continue tracking it after.
+			 * Be carefull and don't kill the custom bits
+			 * in the former config.
+			 */
+			hwc->config = (hwc->config & usr_mask) | alt_config;
+		}

 		p4_pmu_swap_config_ts(hwc, cpu);
 		if (assign)
