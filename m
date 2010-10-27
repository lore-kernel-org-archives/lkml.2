Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab0J0Rdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:33:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49367 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab0J0Rds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GoFHadzpUEO7pU2L41wh6U6zZHbmNr2W9quS5/mI4iRlIvo+dRvTO5otONfUpzsKah
         soJK8pqhiLUoglpTlKyzdDXOfCSclAEBtcMAfuSvxt2Q9SmMq2Q2MpgpFMkZNVwIK+4s
         jtJilsCZq03f0WqxclPKxdXmFAHg++luP3E7M=
Subject: [PATCH] numa: fix slab_node(MPOL_BIND)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <1288195668.2709.167.camel@edumazet-laptop>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>
	 <1288187870.2709.128.camel@edumazet-laptop>  <4CC83067.5000009@kernel.org>
	 <1288189461.2709.144.camel@edumazet-laptop>
	 <1288190387.2709.147.camel@edumazet-laptop>  <4CC83A85.3070608@kernel.org>
	 <1288192868.2709.152.camel@edumazet-laptop>  <4CC846D5.50106@kernel.org>
	 <1288195668.2709.167.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 19:33:43 +0200
Message-ID: <1288200823.5619.46.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 18:07 +0200, Eric Dumazet a écrit :

> So I tried following experiment :
> 
> # swapoff
> # numactl --membind=0 swapon -a
> # grep swap /proc/vmallocinfo 
> 0xf9bf3000-0xf9cf4000 1052672 sys_swapon+0x4aa/0xb24 pages=256 vmalloc N0=256
> # swapoff -a
> # numactl --membind=1 swapon -a
> 
> <<FREEZE>>
> 

Crash in fact, not freeze, in slab_node()

Problem is : we dereference a NULL zone pointer.

(node 1 has HighMem only)

Following patch seems to solve the problem for me

# swapoff -a
# numactl --membind=1 swapon -a
# grep swap /proc/vmallocinfo 
0xf9da5000-0xf9ea6000 1052672 sys_swapon+0x3f9/0xa34 pages=256 vmalloc N1=256


Thanks


[PATCH] numa: fix slab_node(MPOL_BIND) 

When a node contains only HighMem memory, slab_node(MPOL_BIND)
dereferences a NULL pointer.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 81a1276..4a57f13 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1597,7 +1597,7 @@ unsigned slab_node(struct mempolicy *policy)
 		(void)first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->v.nodes,
 							&zone);
-		return zone->node;
+		return zone ? zone->node : numa_node_id();
 	}
 
 	default:


