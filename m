Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1G0VxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:53:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:16747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763Ab1G0Vtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826601"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: xufeng.zhang@windriver.com, paul.gortmaker@windriver.com,
        davem@davemloft.net, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [93/99] ipv6/udp: Use the correct variable to determine non-blocking condition
Message-Id: <20110727214932.F171D2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Xufeng Zhang <xufeng.zhang@windriver.com>

[ Upstream commit 32c90254ed4a0c698caa0794ebb4de63fcc69631 ]

udpv6_recvmsg() function is not using the correct variable to determine
whether or not the socket is in non-blocking operation, this will lead
to unexpected behavior when a UDP checksum error occurs.

Consider a non-blocking udp receive scenario: when udpv6_recvmsg() is
called by sock_common_recvmsg(), MSG_DONTWAIT bit of flags variable in
udpv6_recvmsg() is cleared by "flags & ~MSG_DONTWAIT" in this call:

    err = sk->sk_prot->recvmsg(iocb, sk, msg, size, flags & MSG_DONTWAIT,
                   flags & ~MSG_DONTWAIT, &addr_len);

i.e. with udpv6_recvmsg() getting these values:

	int noblock = flags & MSG_DONTWAIT
	int flags = flags & ~MSG_DONTWAIT

So, when udp checksum error occurs, the execution will go to
csum_copy_err, and then the problem happens:

    csum_copy_err:
            ...............
            if (flags & MSG_DONTWAIT)
                    return -EAGAIN;
            goto try_again;
            ...............

But it will always go to try_again as MSG_DONTWAIT has been cleared
from flags at call time -- only noblock contains the original value
of MSG_DONTWAIT, so the test should be:

            if (noblock)
                    return -EAGAIN;

This is also consistent with what the ipv4/udp code does.

Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/ipv6/udp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/net/ipv6/udp.c
===================================================================
--- linux-2.6.35.y.orig/net/ipv6/udp.c
+++ linux-2.6.35.y/net/ipv6/udp.c
@@ -445,7 +445,7 @@ csum_copy_err:
 	}
 	unlock_sock_fast(sk, slow);
 
-	if (flags & MSG_DONTWAIT)
+	if (noblock)
 		return -EAGAIN;
 	goto try_again;
 }
