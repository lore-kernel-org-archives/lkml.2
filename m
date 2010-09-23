Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0IWDcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:32:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42430 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab0IWDcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:32:18 -0400
Date: Thu, 23 Sep 2010 13:32:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20100923133214.81014faf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/sparc/kernel/perf_event.c between commit
b343ae51c116dffaef07a8596661774c12212b66 ("sparc64: Support RAW perf
events") from Linus' tree and commit
b0a873ebbf87bf38bf70b5e39a7cadc96099fa13 ("perf: Register PMU
implementations") from the tip tree.

I fixed it up (I think - see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sparc/kernel/perf_event.c
index 6318e62,f9a7067..0000000
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@@ -1038,8 -1062,8 +1062,9 @@@ static int sparc_pmu_event_init(struct 
  	if (atomic_read(&nmi_active) < 0)
  		return -ENODEV;
  
 +	pmap = NULL;
- 	if (attr->type == PERF_TYPE_HARDWARE) {
+ 	switch (attr->type) {
+ 	case PERF_TYPE_HARDWARE:
  		if (attr->config >= sparc_pmu->max_events)
  			return -EINVAL;
  		pmap = sparc_pmu->event_map(attr->config);
@@@ -1047,18 -1073,16 +1074,25 @@@
  		pmap = sparc_map_cache_event(attr->config);
  		if (IS_ERR(pmap))
  			return PTR_ERR(pmap);
- 	} else if (attr->type != PERF_TYPE_RAW)
- 		return -EOPNOTSUPP;
+ 		break;
+ 
+ 	case PERF_TYPE_RAW:
 -		return -EOPNOTSUPP;
++		break;
+ 
+ 	default:
+ 		return -ENOENT;
+ 
+ 	}
  
 +	if (pmap) {
 +		hwc->event_base = perf_event_encode(pmap);
 +	} else {
 +		/* User gives us "(encoding << 16) | pic_mask" for
 +		 * PERF_TYPE_RAW events.
 +		 */
 +		hwc->event_base = attr->config;
 +	}
 +
  	/* We save the enable bits in the config_base.  */
  	hwc->config_base = sparc_pmu->irq_bit;
  	if (!attr->exclude_user)
