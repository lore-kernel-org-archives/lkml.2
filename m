Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965348Ab1C3VKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:10:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:38679 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965285Ab1C3VKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903737072"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: pablo@netfilter.org, stable@kernel.org, kaber@trash.net,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [257/275] netfilter: arpt_mangle: fix return values of checkentry
Message-Id: <20110330210824.45DFF3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
In 135367b "netfilter: xtables: change xt_target.checkentry return type",
the type returned by checkentry was changed from boolean to int, but the
return values where not adjusted.

arptables: Input/output error

This broke arptables with the mangle target since it returns true
under success, which is interpreted by xtables as >0, thus
returning EIO.

The following Linux kernels are affected:
* 2.6.35.9
* 2.6.36.4
* 2.6.37.3

Cc: stable@kernel.org
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
(cherry picked from commit 9d0db8b6b1da9e3d4c696ef29449700c58d589db)
---
 net/ipv4/netfilter/arpt_mangle.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/net/ipv4/netfilter/arpt_mangle.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/netfilter/arpt_mangle.c	2011-01-13 09:47:51.000000000 -0800
+++ linux-2.6.35.y/net/ipv4/netfilter/arpt_mangle.c	2011-03-29 23:12:09.451240810 -0700
@@ -60,12 +60,12 @@
 
 	if (mangle->flags & ~ARPT_MANGLE_MASK ||
 	    !(mangle->flags & ARPT_MANGLE_MASK))
-		return false;
+		return -EINVAL;
 
 	if (mangle->target != NF_DROP && mangle->target != NF_ACCEPT &&
 	   mangle->target != ARPT_CONTINUE)
-		return false;
-	return true;
+		return -EINVAL;
+	return 0;
 }
 
 static struct xt_target arpt_mangle_reg __read_mostly = {
