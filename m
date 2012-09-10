Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2IJJat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:30:49 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:36460
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756704Ab2IJJak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:30:40 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202h1d1ahzz8275bh8275dhz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h1155h)
X-WSS-ID: 0MA4NQT-01-16X-02
X-M-MSG: 
Date: Mon, 10 Sep 2012 11:30:18 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2] perf, ibs: Check syscall attribute flags
Message-ID: <20120910093018.GO8285@erda.amd.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120906190238.GA29278@erda.amd.com>
 <5048F6BF.70106@gmail.com>
 <20120906195645.GD8285@erda.amd.com>
 <20120907164114.GJ8285@erda.amd.com>
 <1347036987.2124.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1347036987.2124.3.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.09.12 18:56:27, Peter Zijlstra wrote:
> > @@ -215,6 +215,14 @@ static int perf_ibs_init(struct perf_event *event)
> >         struct perf_ibs *perf_ibs;
> >         u64 max_cnt, config;
> >         int ret;
> > +       struct perf_event_attr notsupp = {
> 
> static const ?
> 
> > +               .exclude_user   = 1,
> > +               .exclude_kernel = 1,
> > +               .exclude_hv     = 1,
> > +               .exclude_idle   = 1,
> > +               .exclude_host   = 1,
> > +               .exclude_guest  = 1,

Version 2 below with static const used.

-Robert


>From faf80df002709ec95178cf8a6f3f7298200ac1a7 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 25 Jul 2012 19:12:45 +0200
Subject: [PATCH] perf, ibs: Check syscall attribute flags

Current implementation simply ignores attribute flags. Thus, there is
no notification to userland of unsupported features. Check syscall's
attribute flags to let userland know if a feature is supported by the
kernel. This is also needed to distinguish between future kernels what
might support a feature.

Cc: <stable@vger.kernel.org> v3.5..
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   12 ++++++++++++
 include/linux/perf_event.h               |    2 ++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 7bfb5be..eebd5ff 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -209,6 +209,15 @@ static int perf_ibs_precise_event(struct perf_event *event, u64 *config)
 	return -EOPNOTSUPP;
 }
 
+static const struct perf_event_attr ibs_notsupp = {
+	.exclude_user	= 1,
+	.exclude_kernel	= 1,
+	.exclude_hv	= 1,
+	.exclude_idle	= 1,
+	.exclude_host	= 1,
+	.exclude_guest	= 1,
+};
+
 static int perf_ibs_init(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -229,6 +238,9 @@ static int perf_ibs_init(struct perf_event *event)
 	if (event->pmu != &perf_ibs->pmu)
 		return -ENOENT;
 
+	if (perf_flags(&event->attr) & perf_flags(&ibs_notsupp))
+		return -EINVAL;
+
 	if (config & ~perf_ibs->config_mask)
 		return -EINVAL;
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 28f9cee..c36a04f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -304,6 +304,8 @@ struct perf_event_attr {
 	__u32	__reserved_2;
 };
 
+#define perf_flags(attr)	(*(&(attr)->read_format + 1))
+
 /*
  * Ioctls that can be done on a perf event fd:
  */
-- 
1.7.8.6




-- 
Advanced Micro Devices, Inc.
Operating System Research Center

