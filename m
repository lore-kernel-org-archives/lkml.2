Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab1G0Vt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:36412 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776Ab1G0Vte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="35258487"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: xufeng.zhang@windriver.com, paul.gortmaker@windriver.com,
        davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [94/99] udp/recvmsg: Clear MSG_TRUNC flag when starting over for a new packet
Message-Id: <20110727214934.01BDE2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Xufeng Zhang <xufeng.zhang@windriver.com>

[ Upstream commit 9cfaa8def1c795a512bc04f2aec333b03724ca2e ]

Consider this scenario: When the size of the first received udp packet
is bigger than the receive buffer, MSG_TRUNC bit is set in msg->msg_flags.
However, if checksum error happens and this is a blocking socket, it will
goto try_again loop to receive the next packet.  But if the size of the
next udp packet is smaller than receive buffer, MSG_TRUNC flag should not
be set, but because MSG_TRUNC bit is not cleared in msg->msg_flags before
receive the next packet, MSG_TRUNC is still set, which is wrong.

Fix this problem by clearing MSG_TRUNC flag when starting over for a
new packet.

Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/ipv4/udp.c |    3 +++
 net/ipv6/udp.c |    3 +++
 2 files changed, 6 insertions(+)

Index: linux-2.6.35.y/net/ipv4/udp.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv4/udp.c
+++ linux-2.6.35.y/net/ipv4/udp.c
@@ -1206,6 +1206,9 @@ csum_copy_err:
 
 	if (noblock)
 		return -EAGAIN;
+
+	/* starting over for a new packet */
+	msg->msg_flags &= ~MSG_TRUNC;
 	goto try_again;
 }
 
Index: linux-2.6.35.y/net/ipv6/udp.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv6/udp.c
+++ linux-2.6.35.y/net/ipv6/udp.c
@@ -447,6 +447,9 @@ csum_copy_err:
 
 	if (noblock)
 		return -EAGAIN;
+
+	/* starting over for a new packet */
+	msg->msg_flags &= ~MSG_TRUNC;
 	goto try_again;
 }
 
