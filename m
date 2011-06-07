Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab1FGVIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:08:02 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:33366 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab1FGVIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:08:00 -0400
Date: Tue, 7 Jun 2011 17:07:48 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [patch] perf_events: even more wrong events for AMD fam10h
In-Reply-To: <alpine.DEB.2.00.1106071532250.21714@cl320.eecs.utk.edu>
Message-ID: <alpine.DEB.2.00.1106071701560.21714@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106071532250.21714@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are two more problems I found with the superlative "generalized" 
events on AMD fam10h.

The "l1-dcache-loads" event measures loads *and* stores.
    This might be as close as you can get on AMD, but it's still wrong
      as it's not what Intel measures.  
    My patch removes it.  Better might be to add a proper
    "l1-dcache-access" event.

The "l1-dcache-load-miss" event is an invalid event. (0x141).
    From what I can tell that event (DATA_CACHE_MISSES) does not
    take a mask.  It should be 0x41.  And it's actually measuring
    all misses, not just load misses, see above.

The "l1-dcache-stores" event does not work.  See the
     ./validation/l1-dcache-stores test found in 
     http://web.eecs.utk.edu/~vweaver1/projects/perf-events/validation.html
   So remove it until we figure out why.


Also, is the value for "no such event" 0 or -1?  The perf_event_amd.c
file seems to use them interchangably from what I can tell.

Thanks,

Vince

Signed-off-by: Vince Weaver <vweaver1@eecs.utk.edu>

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index fe29c1d..71987d5 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -7,11 +7,11 @@ static __initconst const u64 amd_hw_cache_event_ids
 {
  [ C(L1D) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
-		[ C(RESULT_MISS)   ] = 0x0141, /* Data Cache Misses          */
+		[ C(RESULT_ACCESS) ] = 0,      /* Not available on AMD       */
+		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0142, /* Data Cache Refills :system */
+		[ C(RESULT_ACCESS) ] = 0,      /* Data Cache Refills :system doesn't work */
 		[ C(RESULT_MISS)   ] = 0,
 	},
 	[ C(OP_PREFETCH) ] = {

