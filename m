Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1HCQGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:06:15 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:7949 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab1HCQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:06:08 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:160.36.179.113;KIP:(null);UIP:(null);IPVD:NLI;H:kedge4.utk.tennessee.edu;RD:kedge4.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 3 Aug 2011 12:05:54 -0400
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [perf] enable raw OFFCORE_EVENTS for non-perf userspace
Message-ID: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-OriginatorOrg: utk.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I propose we just enable raw OFFCORE_EVENT support and get it over with.

There is a lot of demand for this from PAPI users, and so we encourage 
them to apply the below patch.  PAPI supports this out of the box.

The current "block" against using this feature *DOES NOT WORK*.
It silently fails if you try to use the config1 field to set it.

Even worse, if some previous user has set the OFFCORE_RSP_0 msr
(say by running "perf stat -e LLC-load-misses") then
the msr *stays set* and if you try to set the config1 field on your own
it looks like it worked, but instead it is using whatever value the
kernel last used.

So there's a lot of userspace confusion about this, and you can't even 
reliably tell if the feature is turned off or not because it fails 
silently in unpredictable ways.

Thanks

Vince
vweaver1@eecs.utk.edu

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4ee3abf..28f9ca9 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -604,12 +604,8 @@ static int x86_setup_perfctr(struct perf_event *event)
 			return -EOPNOTSUPP;
 	}
 
-	/*
-	 * Do not allow config1 (extended registers) to propagate,
-	 * there's no sane user-space generalization yet:
-	 */
 	if (attr->type == PERF_TYPE_RAW)
-		return 0;
+		return x86_pmu_extra_regs(event->attr.config, event);
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, event);

