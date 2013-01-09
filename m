Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3AIUhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:37:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:41597 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933021Ab3AIUhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 12/80] inet_diag: validate port comparison byte code to prevent unsafe reads
Date: Wed,  9 Jan 2013 12:35:04 -0800
Message-Id: <20130109201501.962241594@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 5e1f54201cb481f40a04bc47e1bc8c093a189e23 ]

Add logic to verify that a port comparison byte code operation
actually has the second inet_diag_bc_op from which we read the port
for such operations.

Previously the code blindly referenced op[1] without first checking
whether a second inet_diag_bc_op struct could fit there. So a
malicious user could make the kernel read 4 bytes beyond the end of
the bytecode array by claiming to have a whole port comparison byte
code (2 inet_diag_bc_op structs) when in fact the bytecode was not
long enough to hold both.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_diag.c |   31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -548,6 +548,17 @@ static bool valid_hostcond(const struct
 	return true;
 }
 
+/* Validate a port comparison operator. */
+static inline bool valid_port_comparison(const struct inet_diag_bc_op *op,
+					 int len, int *min_len)
+{
+	/* Port comparisons put the port in a follow-on inet_diag_bc_op. */
+	*min_len += sizeof(struct inet_diag_bc_op);
+	if (len < *min_len)
+		return false;
+	return true;
+}
+
 static int inet_diag_bc_audit(const void *bytecode, int bytecode_len)
 {
 	const void *bc = bytecode;
@@ -563,24 +574,30 @@ static int inet_diag_bc_audit(const void
 		case INET_DIAG_BC_D_COND:
 			if (!valid_hostcond(bc, len, &min_len))
 				return -EINVAL;
-			/* fall through */
-		case INET_DIAG_BC_AUTO:
+			break;
 		case INET_DIAG_BC_S_GE:
 		case INET_DIAG_BC_S_LE:
 		case INET_DIAG_BC_D_GE:
 		case INET_DIAG_BC_D_LE:
-		case INET_DIAG_BC_JMP:
-			if (op->no < min_len || op->no > len + 4 || op->no & 3)
-				return -EINVAL;
-			if (op->no < len &&
-			    !valid_cc(bytecode, bytecode_len, len - op->no))
+			if (!valid_port_comparison(bc, len, &min_len))
 				return -EINVAL;
 			break;
+		case INET_DIAG_BC_AUTO:
+		case INET_DIAG_BC_JMP:
 		case INET_DIAG_BC_NOP:
 			break;
 		default:
 			return -EINVAL;
 		}
+
+		if (op->code != INET_DIAG_BC_NOP) {
+			if (op->no < min_len || op->no > len + 4 || op->no & 3)
+				return -EINVAL;
+			if (op->no < len &&
+			    !valid_cc(bytecode, bytecode_len, len - op->no))
+				return -EINVAL;
+		}
+
 		if (op->yes < min_len || op->yes > len + 4 || op->yes & 3)
 			return -EINVAL;
 		bc  += op->yes;


