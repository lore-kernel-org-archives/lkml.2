Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab1G0Vst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:12903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569Ab1G0Vsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="33043661"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: error27@gmail.com, konrad.wilk@oracle.com, jeremy.fitzhardinge@citrix.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [46/99] xen: off by one errors in multicalls.c
Message-Id: <20110727214845.26E2F2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Carpenter <error27@gmail.com>

commit f124c6ae59e193705c9ddac57684d50006d710e6 upstream.

b->args[] has MC_ARGS elements, so the comparison here should be
">=" instead of ">".  Otherwise we read past the end of the array
one space.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/xen/multicalls.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.35.y/arch/x86/xen/multicalls.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/xen/multicalls.c
+++ linux-2.6.35.y/arch/x86/xen/multicalls.c
@@ -189,10 +189,10 @@ struct multicall_space __xen_mc_entry(si
 	unsigned argidx = roundup(b->argidx, sizeof(u64));
 
 	BUG_ON(preemptible());
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 
 	if (b->mcidx == MC_BATCH ||
-	    (argidx + args) > MC_ARGS) {
+	    (argidx + args) >= MC_ARGS) {
 		mc_stats_flush(b->mcidx == MC_BATCH ? FL_SLOTS : FL_ARGS);
 		xen_mc_flush();
 		argidx = roundup(b->argidx, sizeof(u64));
@@ -206,7 +206,7 @@ struct multicall_space __xen_mc_entry(si
 	ret.args = &b->args[argidx];
 	b->argidx = argidx + args;
 
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 	return ret;
 }
 
@@ -216,7 +216,7 @@ struct multicall_space xen_mc_extend_arg
 	struct multicall_space ret = { NULL, NULL };
 
 	BUG_ON(preemptible());
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 
 	if (b->mcidx == 0)
 		return ret;
@@ -224,14 +224,14 @@ struct multicall_space xen_mc_extend_arg
 	if (b->entries[b->mcidx - 1].op != op)
 		return ret;
 
-	if ((b->argidx + size) > MC_ARGS)
+	if ((b->argidx + size) >= MC_ARGS)
 		return ret;
 
 	ret.mc = &b->entries[b->mcidx - 1];
 	ret.args = &b->args[b->argidx];
 	b->argidx += size;
 
-	BUG_ON(b->argidx > MC_ARGS);
+	BUG_ON(b->argidx >= MC_ARGS);
 	return ret;
 }
 
