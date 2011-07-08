Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1GHFAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:00:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab1GHFAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:54 2011
Message-Id: <20110708001654.033393330@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [013/107] inet_diag: fix inet_diag_bc_audit()
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
---
 net/ipv4/inet_diag.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
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


