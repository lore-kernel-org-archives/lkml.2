Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2JJTX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 15:23:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32965 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755632Ab2JJTX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 15:23:28 -0400
Message-ID: <1349897005.2035.24.camel@joe-AO722>
Subject: [PATCH net-next? V2] pktgen: Use simpler test for non-zero ipv6
 address
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Brian Haley <brian.haley@hp.com>
Date: Wed, 10 Oct 2012 12:23:25 -0700
In-Reply-To: <1349895710.21172.7235.camel@edumazet-glaptop>
References: <1349894559.2035.12.camel@joe-AO722>
	 <1349895710.21172.7235.camel@edumazet-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces object size and should be slightly faster.

allyesconfig: 
$ size net/core/pktgen.o*
   text	   data	    bss	    dec	    hex	filename
  52284	   4321	  11840	  68445	  10b5d	net/core/pktgen.o.new
  52310	   4293	  11848	  68451	  10b63	net/core/pktgen.o.old
 
Signed-off-by: Joe Perches <joe@perches.com>
---
> What about ipv6_addr_any() ?

That's better I guess.
I forgot about it and didn't see it.
I saw the IPV6_ADDR_ANY type tests and
didn't look further.

Anyway, it's odd that it generates slightly larger code
than the original patch's direct tests in 32bit with
gcc 4.7.2.  Perhaps an interesting lack of optimization?

cheers, Joe

 net/core/pktgen.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 148e73d..a811a7d 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2422,11 +2422,7 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 		}
 	} else {		/* IPV6 * */
 
-		if (pkt_dev->min_in6_daddr.s6_addr32[0] == 0 &&
-		    pkt_dev->min_in6_daddr.s6_addr32[1] == 0 &&
-		    pkt_dev->min_in6_daddr.s6_addr32[2] == 0 &&
-		    pkt_dev->min_in6_daddr.s6_addr32[3] == 0) ;
-		else {
+		if (!ipv6_addr_any(&pkt_dev->min_in6_daddr)) {
 			int i;
 
 			/* Only random destinations yet */


