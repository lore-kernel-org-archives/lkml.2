Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0I2PvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 11:51:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59681 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab0I2PvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 11:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gaYa6yQRANPiTWe9s0VG+O+RRXGyRGwhzsvUr6kA/f1XItHwY2GNduC/OILRCW8xff
         UWIKkb9IIABjGgMyVDJ/5IGCf/JvrEiGejalkCPPj7V7HFkjpYbNJmazHWQu/cC9Y6GU
         HuZzPA08ZPRdx4xs0ZI44WOaX5Q4xq+YtLPDI=
Date: Wed, 29 Sep 2010 19:51:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
	disabling counters
Message-ID: <20100929155102.GE9440@lenovo>
References: <AANLkTimB2gf=2zYCwiKEgozt_Rsa1Cpb6JuLSzmHusFX@mail.gmail.com> <20100929125301.GG13563@erda.amd.com> <20100929125453.GH13563@erda.amd.com> <AANLkTimoE8wAhT+yxXBPnZvTTGrAtDjdaXPBN3Xg28eL@mail.gmail.com> <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com> <20100929150140.GK13563@erda.amd.com> <20100929151253.GL13563@erda.amd.com> <20100929152745.GC9440@lenovo> <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com> <20100929154528.GD9440@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929154528.GD9440@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 07:45:28PM +0400, Cyrill Gorcunov wrote:
... 
> Btw, since x86 architectural and p4 are using same tests for
> running I presume better to have some helper rather then
> open coded pile?
> 
> Cyrill

Something like this (with some better comment in middle)?

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6526a86..73a07fb 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1147,6 +1147,16 @@ static void x86_pmu_del(struct perf_event *event, int flags)
 	perf_event_update_userpage(event);
 }
 
+static inline int x86_pmu_spurious_irq(int idx, struct cpu_hw_events *cpuc)
+{
+	/*
+	 * Though we deactivated the counter some cpus
+	 * might still deliver spurious interrupts still
+	 * in flight. Catch them:
+	 */
+	return __test_and_clear_bit(idx, cpuc->running);
+}
+
 static int x86_pmu_handle_irq(struct pt_regs *regs)
 {
 	struct perf_sample_data data;
@@ -1162,13 +1172,7 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask)) {
-			/*
-			 * Though we deactivated the counter some cpus
-			 * might still deliver spurious interrupts still
-			 * in flight. Catch them:
-			 */
-			if (__test_and_clear_bit(idx, cpuc->running))
-				handled++;
+			handled += x86_pmu_spurious_irq(idx, cpuc);
 			continue;
 		}
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index c70c878..524325c 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -904,8 +904,10 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		int overflow;
 
-		if (!test_bit(idx, cpuc->active_mask))
+		if (!test_bit(idx, cpuc->active_mask)) {
+			handled += x86_pmu_spurious_irq(idx, cpuc);
 			continue;
+		}
 
 		event = cpuc->events[idx];
 		hwc = &event->hw;
