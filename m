Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030711Ab2HQD1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:27:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46733 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030548Ab2HQD0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:55 -0400
Message-Id: <20120817030245.067689226@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 08/37] tcp: Add TCP_USER_TIMEOUT negative value check
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 42493570100b91ef663c4c6f0c0fdab238f9d3c2 ]

TCP_USER_TIMEOUT is a TCP level socket option that takes an unsigned int. But
patch "tcp: Add TCP_USER_TIMEOUT socket option"(dca43c75) didn't check the negative
values. If a user assign -1 to it, the socket will set successfully and wait
for 4294967295 miliseconds. This patch add a negative value check to avoid
this issue.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 11ba922..ad466a7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2391,7 +2391,10 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		/* Cap the max timeout in ms TCP will retry/retrans
 		 * before giving up and aborting (ETIMEDOUT) a connection.
 		 */
-		icsk->icsk_user_timeout = msecs_to_jiffies(val);
+		if (val < 0)
+			err = -EINVAL;
+		else
+			icsk->icsk_user_timeout = msecs_to_jiffies(val);
 		break;
 	default:
 		err = -ENOPROTOOPT;


