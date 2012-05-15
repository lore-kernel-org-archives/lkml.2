Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263Ab2EOCpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:45:05 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53456 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965225Ab2EOCRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 115/179] bridge: send proper message_age in config BPDU
Date: Mon, 14 May 2012 22:13:31 -0400
Message-ID: <1337048075-6132-116-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: stephen hemminger <shemminger@vyatta.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0c03150e7ea8f7fcd03cfef29385e0010b22ee92 upstream.

A bridge topology with three systems:

      +------+  +------+
      | A(2) |--| B(1) |
      +------+  +------+
           \    /
          +------+
          | C(3) |
          +------+

What is supposed to happen:
 * bridge with the lowest ID is elected root (for example: B)
 * C detects that A->C is higher cost path and puts in blocking state

What happens. Bridge with lowest id (B) is elected correctly as
root and things start out fine initially. But then config BPDU
doesn't get transmitted from A -> C. Because of that
the link from A-C is transistioned to the forwarding state.

The root cause of this is that the configuration messages
is generated with bogus message age, and dropped before
sending.

In the standardmessage_age is supposed to be:
  the time since the generation of the Configuration BPDU by
  the Root that instigated the generation of this Configuration BPDU.

Reimplement this by recording the timestamp (age + jiffies) when
recording config information. The old code incorrectly used the time
elapsed on the ageing timer which was incorrect.

See also:
  https://bugzilla.vyatta.com/show_bug.cgi?id=7164

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/bridge/br_private.h |    1 +
 net/bridge/br_stp.c     |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 846d7d1..2af6d75 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -110,6 +110,7 @@ struct net_bridge_port
 	bridge_id			designated_bridge;
 	u32				path_cost;
 	u32				designated_cost;
+	unsigned long			designated_age;
 
 	struct timer_list		forward_delay_timer;
 	struct timer_list		hold_timer;
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index edcf14b..7c16198 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -165,8 +165,7 @@ void br_transmit_config(struct net_bridge_port *p)
 	else {
 		struct net_bridge_port *root
 			= br_get_port(br, br->root_port);
-		bpdu.message_age = br->max_age
-			- (root->message_age_timer.expires - jiffies)
+		bpdu.message_age = (jiffies - root->designated_age)
 			+ MESSAGE_AGE_INCR;
 	}
 	bpdu.max_age = br->max_age;
@@ -190,6 +189,7 @@ static inline void br_record_config_information(struct net_bridge_port *p,
 	p->designated_cost = bpdu->root_path_cost;
 	p->designated_bridge = bpdu->bridge_id;
 	p->designated_port = bpdu->port_id;
+	p->designated_age = jiffies + bpdu->message_age;
 
 	mod_timer(&p->message_age_timer, jiffies
 		  + (p->br->max_age - bpdu->message_age));
-- 
1.7.9.6

