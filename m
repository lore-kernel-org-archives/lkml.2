Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1GHFBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:01:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab1GHFA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:56 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:54 2011
Message-Id: <20110708001654.230531692@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Xufeng Zhang <xufeng.zhang@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [015/107] ipv6/udp: Use the correct variable to determine non-blocking condition
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
---
 net/ipv6/udp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -453,7 +453,7 @@ csum_copy_err:
 	}
 	unlock_sock_fast(sk, slow);
 
-	if (flags & MSG_DONTWAIT)
+	if (noblock)
 		return -EAGAIN;
 	goto try_again;
 }


