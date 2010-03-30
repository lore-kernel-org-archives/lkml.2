Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab0C3X2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:28:34 -0400
Received: from kroah.org ([198.145.64.141]:46756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945Ab0C3XVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:21:52 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:48 2010
Message-Id: <20100330224848.313138010@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Guenter Roeck <guenter.roeck@ericsson.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [135/156] ipv4: Dont drop redirected route cache entry unless PTMU actually expired
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

[ Upstream commit 5e016cbf6cffd4a53b7922e0c91b775399d7fe47 ]

TCP sessions over IPv4 can get stuck if routers between endpoints
do not fragment packets but implement PMTU instead, and we are using
those routers because of an ICMP redirect.

Setup is as follows

       MTU1    MTU2   MTU1
    A--------B------C------D

with MTU1 > MTU2. A and D are endpoints, B and C are routers. B and C
implement PMTU and drop packets larger than MTU2 (for example because
DF is set on all packets). TCP sessions are initiated between A and D.
There is packet loss between A and D, causing frequent TCP
retransmits.

After the number of retransmits on a TCP session reaches tcp_retries1,
tcp calls dst_negative_advice() prior to each retransmit. This results
in route cache entries for the peer to be deleted in
ipv4_negative_advice() if the Path MTU is set.

If the outstanding data on an affected TCP session is larger than
MTU2, packets sent from the endpoints will be dropped by B or C, and
ICMP NEEDFRAG will be returned. A and D receive NEEDFRAG messages and
update PMTU.

Before the next retransmit, tcp will again call dst_negative_advice(),
causing the route cache entry (with correct PMTU) to be deleted. The
retransmitted packet will be larger than MTU2, causing it to be
dropped again.

This sequence repeats until the TCP session aborts or is terminated.

Problem is fixed by removing redirected route cache entries in
ipv4_negative_advice() only if the PMTU is expired.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/route.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1484,7 +1484,8 @@ static struct dst_entry *ipv4_negative_a
 			ip_rt_put(rt);
 			ret = NULL;
 		} else if ((rt->rt_flags & RTCF_REDIRECTED) ||
-			   rt->u.dst.expires) {
+			   (rt->u.dst.expires &&
+			    time_after_eq(jiffies, rt->u.dst.expires))) {
 			unsigned hash = rt_hash(rt->fl.fl4_dst, rt->fl.fl4_src,
 						rt->fl.oif,
 						rt_genid(dev_net(dst->dev)));


