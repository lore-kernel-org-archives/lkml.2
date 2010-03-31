Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab0CaQPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 12:15:32 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:37401 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546Ab0CaQPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 12:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vk80LI2708pZGq3RnUqEVU2/QxHamBZ3xpdke6Tx+Lgjl3aRbZo1YvchIfDGgekKmu
         Riu5wf9ior8P3A/mM7CvQxINxDF3ah4S75ZohAtFmU52DfuTuCyRvmmpHXAI+kv3B7d1
         O8MR0MgA12IIkVDuwrOjLhlZJxRYAMxqh/HmY=
Date: Wed, 31 Mar 2010 20:15:23 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
Message-ID: <20100331161523.GA9058@lenovo>
References: <1269880612-25800-1-git-send-email-robert.richter@amd.com> <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com> <20100330134145.GI11907@erda.amd.com> <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com> <1269961255.5258.221.camel@laptop> <20100330155949.GJ11907@erda.amd.com> <1269968113.5258.442.camel@laptop> <20100330182906.GD5211@lenovo> <1269975840.5258.609.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269975840.5258.609.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 09:04:00PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-03-30 at 22:29 +0400, Cyrill Gorcunov wrote:
[...]
> > 
> > I'll try to find out an easy way to satisfy this "ANY" bit request
> > though it would require some time (perhaps today later or rather
> > tomorrow).
> 
> Right, so don't worry about actively supporting ANY on regular events,
> wider than logical cpu counting is a daft thing.
> 
> What would be nice to detect is if the raw event provided would be a TI
> (ANY) event, in which case we should apply the extra paranoia.
> 

ok, here is a version ot top of your patches. Compile tested
only (have no p4 under my hands)

	-- Cyrill
---
x86, perf: P4 PMU -- check for permission granted on ANY event requested

In case if a caller (user) asked us to count events with
some weird mask we should check if this priviledge has been
granted since this could be a mix of mask bits we not like
which but allow if caller insist.

By ANY event term the combination of USR/OS bits in ESCR
register is assumed.

CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/perf_event_p4.h |   19 +++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_p4.c  |   24 +++++++++++++++++++++---
 2 files changed, 40 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -33,6 +33,9 @@
 #define P4_ESCR_T1_OS		0x00000002U
 #define P4_ESCR_T1_USR		0x00000001U
 
+#define P4_ESCR_T0_ANY		(P4_ESCR_T0_OS | P4_ESCR_T0_USR)
+#define P4_ESCR_T1_ANY		(P4_ESCR_T1_OS | P4_ESCR_T1_USR)
+
 #define P4_ESCR_EVENT(v)	((v) << P4_ESCR_EVENT_SHIFT)
 #define P4_ESCR_EMASK(v)	((v) << P4_ESCR_EVENTMASK_SHIFT)
 #define P4_ESCR_TAG(v)		((v) << P4_ESCR_TAG_SHIFT)
@@ -134,6 +137,22 @@
 #define P4_CONFIG_HT_SHIFT		63
 #define P4_CONFIG_HT			(1ULL << P4_CONFIG_HT_SHIFT)
 
+/*
+ * typically we set USR or/and OS bits for one of the
+ * threads only at once, any other option is treated
+ * as "odd"
+ */
+static inline bool p4_is_odd_cpl(u32 escr)
+{
+	unsigned int t0 = (escr & P4_ESCR_T0_ANY) << 0;
+	unsigned int t1 = (escr & P4_ESCR_T1_ANY) << 2;
+
+	if ((t0 ^ t1) != t0)
+		return true;
+
+	return false;
+}
+
 static inline bool p4_is_event_cascaded(u64 config)
 {
 	u32 cccr = p4_config_unpack_cccr(config);
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -443,13 +443,18 @@ static int p4_hw_config(struct perf_even
 		return 0;
 
 	/*
+	 * a caller may ask for something definitely weird and
+	 * screwed, sigh...
+	 */
+	escr = p4_config_unpack_escr(event->attr.config);
+	if (p4_is_odd_cpl(escr) && perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	/*
 	 * We don't control raw events so it's up to the caller
 	 * to pass sane values (and we don't count the thread number
 	 * on HT machine but allow HT-compatible specifics to be
 	 * passed on)
-	 *
-	 * XXX: HT wide things should check perf_paranoid_cpu() &&
-	 *      CAP_SYS_ADMIN
 	 */
 	event->hw.config |= event->attr.config &
 		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
@@ -630,6 +635,19 @@ static void p4_pmu_swap_config_ts(struct
 	escr = p4_config_unpack_escr(hwc->config);
 	cccr = p4_config_unpack_cccr(hwc->config);
 
+	/*
+	 * for non-standart configs we don't clobber cpl
+	 * related bits so it's preferred the caller don't
+	 * use this mode
+	 */
+	if (unlikely(p4_is_odd_cpl(escr))) {
+		if (p4_ht_thread(cpu))
+			hwc->config |= P4_CONFIG_HT;
+		else
+			hwc->config &= ~P4_CONFIG_HT;
+		return;
+	}
+
 	if (p4_ht_thread(cpu)) {
 		cccr &= ~P4_CCCR_OVF_PMI_T0;
 		cccr |= P4_CCCR_OVF_PMI_T1;
