Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0FPIvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:51:24 -0400
Received: from gate.uk.cyberscience.com ([81.2.73.194]:54111 "EHLO
	gate.uk.cyberscience.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab0FPIvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:51:21 -0400
X-Greylist: delayed 1551 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jun 2010 04:51:21 EDT
From: Tom Hughes <tom@compton.nu>
To: netdev@vger.kernel.org
Cc: akpm@linux-foundation.org, Tom Hughes <tom@compton.nu>,
       Jamal Hadi Salim <hadi@cyberus.ca>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Clear IFF_XMIT_DST_RELEASE for teql interfaces
Date: Wed, 16 Jun 2010 09:24:28 +0100
Message-Id: <1276676668-10256-1-git-send-email-tom@compton.nu>
X-Mailer: git-send-email 1.7.0.1
X-Spam-Cyberscience-Checked: by gate.uk.cyberscience.com
X-Spam-Score: -1.9 (-)
X-Spam-Report: Spam detection software, running on the system "dellow.uk.cyberscience.com", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  The sch_teql module, which can be used to load balance over
    a set of underlying interfaces, stopped working after 2.6.30 and has been
    broken in all kernels since then for any underlying interface which requires
    the addition of link level headers. [...] 
 Content analysis details:   (-1.9 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -0.0 T_RP_MATCHES_RCVD      Envelope sender domain matches handover relay
                             domain
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sch_teql module, which can be used to load balance over a set of
underlying interfaces, stopped working after 2.6.30 and has been
broken in all kernels since then for any underlying interface which
requires the addition of link level headers.

The problem is that the transmit routine relies on being able to
access the destination address in the skb in order to do address
resolution once it has decided which underlying interface it is going
to transmit through.

In 2.6.31 the IFF_XMIT_DST_RELEASE flag was introduced, and set by
default for all interfaces, which causes the destination address to be
released before the transmit routine for the interface is called.

The solution is to clear that flag for teql interfaces.

Signed-off-by: Tom Hughes <tom@compton.nu>
---
 net/sched/sch_teql.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 3415b6c..807643b 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -449,6 +449,7 @@ static __init void teql_master_setup(struct net_device *dev)
 	dev->tx_queue_len	= 100;
 	dev->flags		= IFF_NOARP;
 	dev->hard_header_len	= LL_MAX_HEADER;
+	dev->priv_flags		&= ~IFF_XMIT_DST_RELEASE;
 }
 
 static LIST_HEAD(master_dev_list);
-- 
1.7.0.1

