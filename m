Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1ARKoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 05:44:21 -0500
Received: from ozlabs.org ([203.10.76.45]:52743 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab1ARKoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 05:44:20 -0500
Date: Tue, 18 Jan 2011 21:44:04 +1100
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Scott Wood <scottwood@freescale.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: perf: Fix frequency calculation for overflowing
 counters (FSL version)
Message-ID: <20110118214404.2f42e634@kryten>
In-Reply-To: <1295285881.30950.218.camel@laptop>
References: <20110117161742.5feb3761@kryten>
	<20110117113250.48098aaa@udp111988uds.am.freescale.net>
	<1295285881.30950.218.camel@laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Does perf_event_fsl_emb.c need this as well (it has almost the same
> > record_and_restart code)? 
> 
> I would think so.

Good point:


When fixing the frequency calculations for perf on powerpc I forgot
to fix the FSL version.

If we dont set event->hw.last_period the frequency to period calculations
in perf go haywire and we continually throttle/unthrottle the PMU.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

This is only compile tested.

Index: powerpc.git/arch/powerpc/kernel/perf_event_fsl_emb.c
===================================================================
--- powerpc.git.orig/arch/powerpc/kernel/perf_event_fsl_emb.c	2011-01-18 21:23:57.761644115 +1100
+++ powerpc.git/arch/powerpc/kernel/perf_event_fsl_emb.c	2011-01-18 21:25:28.994477247 +1100
@@ -596,6 +596,7 @@ static void record_and_restart(struct pe
 			if (left <= 0)
 				left = period;
 			record = 1;
+			event->hw.last_period = event->hw.sample_period;
 		}
 		if (left < 0x80000000LL)
 			val = 0x80000000LL - left;


