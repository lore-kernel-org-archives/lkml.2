Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030249Ab2CMA2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:28:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:49008 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965271Ab2CMAZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 189/196] inet_diag: fix inet_diag_bc_audit()
Date: Mon, 12 Mar 2012 20:21:42 -0400
Message-Id: <1331598109-31424-144-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit eeb1497277d6b1a0a34ed36b97e18f2bd7d6de0d upstream.

A malicious user or buggy application can inject code and trigger an
infinite loop in inet_diag_bc_audit()

Also make sure each instruction is aligned on 4 bytes boundary, to avoid
unaligned accesses.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/ipv4/inet_diag.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 7403b9b..99366cb 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -437,7 +437,7 @@ static int valid_cc(const void *bc, int len, int cc)
 			return 0;
 		if (cc == len)
 			return 1;
-		if (op->yes < 4)
+		if (op->yes < 4 || op->yes & 3)
 			return 0;
 		len -= op->yes;
 		bc  += op->yes;
@@ -447,11 +447,11 @@ static int valid_cc(const void *bc, int len, int cc)
 
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
@@ -462,22 +462,20 @@ static int inet_diag_bc_audit(const void *bytecode, int bytecode_len)
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
-- 
1.7.9.3

