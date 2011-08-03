Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1HCRAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 13:00:22 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:33048
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754283Ab1HCRAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 13:00:19 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.36.179.132;KIP:(null);UIP:(null);IPVD:NLI;H:kedge1.utk.tennessee.edu;RD:kedge1.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 3 Aug 2011 13:00:12 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [perf] enable raw OFFCORE_EVENTS for non-perf userspace
In-Reply-To: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
Message-ID: <alpine.DEB.2.00.1108031254120.4627@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginatorOrg: utk.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


and in case we don't want to be nice to userspace and want to brutally 
suppress anyone not using the "perf" tool, here's a patch that 
returns EINVAL for any raw access that sets config1.

I actually tested to make sure the patch doesn't break PAPI, unlike my 
last attempt.

Currently we "block" access to setting the config1 value from userspace
by silently failing.  This can cause unexpected behavior (especially if
the kernel is using the OFFCORE_RSP_0 msr internally) and also makes it 
impossible to test if OFFCORE_RESPONSE events are being blocked or not.

This hackish patch causes an EINVAL to propogate back to userspace
by setting an invalid value to the config1 field.

I personally think this patch is a step backward, and the right thing to 
do is give users full access to their own hardware.  But the current state 
of affairs is bad for tools like PAPI too.



diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4ee3abf..72baf25 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -608,8 +608,11 @@ static int x86_setup_perfctr(struct perf_event *event)
 	 * Do not allow config1 (extended registers) to propagate,
 	 * there's no sane user-space generalization yet:
 	 */
-	if (attr->type == PERF_TYPE_RAW)
-		return 0;
+	if (attr->type == PERF_TYPE_RAW) {
+		/* I HATE THIS PATCH AND EVERYTHING IT STANDS FOR.  --  VMW */
+		event->attr.config1=0xffffffff;  /* invalid, will be caught */
+		return x86_pmu_extra_regs(event->attr.config, event);
+	}
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, event);

