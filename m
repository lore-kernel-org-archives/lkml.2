Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1G0VvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:51:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:10471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab1G0Vtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="30901124"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: eric.dumazet@gmail.com, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [87/99] inet_diag: fix inet_diag_bc_audit()
Message-Id: <20110727214926.D703A2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit eeb1497277d6b1a0a34ed36b97e18f2bd7d6de0d ]

A malicious user or buggy application can inject code and trigger an
infinite loop in inet_diag_bc_audit()

Also make sure each instruction is aligned on 4 bytes boundary, to avoid
unaligned accesses.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/ipv4/inet_diag.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6.35.y/net/ipv4/inet_diag.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/inet_diag.c
+++ linux-2.6.35.y/net/ipv4/inet_diag.c
@@ -437,7 +437,7 @@ static int valid_cc(const void *bc, int 
 			return 0;
 		if (cc == len)
 			return 1;
-		if (op->yes < 4)
+		if (op->yes < 4 || op->yes & 3)
 			return 0;
 		len -= op->yes;
 		bc  += op->yes;
@@ -447,11 +447,11 @@ static int valid_cc(const void *bc, int 
 
 static int inet_diag_bc_audit(const void *bytecode, int bytecode_len)
 {
-	const unsigned char *bc = bytecode;
+	const void *bc = bytecode;
 	int  len = bytecode_len;
 
 	while (len > 0) {
-		struct inet_diag_bc_op *op = (struct inet_diag_bc_op *)bc;
+		const struct inet_diag_bc_op *op = bc;
 
 //printk("BC: %d %d %d {%d} / %d\n", op->code, op->yes, op->no, op[1].no, len);
 		switch (op->code) {
@@ -462,22 +462,20 @@ static int inet_diag_bc_audit(const void
 		case INET_DIAG_BC_S_LE:
 		case INET_DIAG_BC_D_GE:
 		case INET_DIAG_BC_D_LE:
-			if (op->yes < 4 || op->yes > len + 4)
-				return -EINVAL;
 		case INET_DIAG_BC_JMP:
-			if (op->no < 4 || op->no > len + 4)
+			if (op->no < 4 || op->no > len + 4 || op->no & 3)
 				return -EINVAL;
 			if (op->no < len &&
 			    !valid_cc(bytecode, bytecode_len, len - op->no))
 				return -EINVAL;
 			break;
 		case INET_DIAG_BC_NOP:
-			if (op->yes < 4 || op->yes > len + 4)
-				return -EINVAL;
 			break;
 		default:
 			return -EINVAL;
 		}
+		if (op->yes < 4 || op->yes > len + 4 || op->yes & 3)
+			return -EINVAL;
 		bc  += op->yes;
 		len -= op->yes;
 	}
