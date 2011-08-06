Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1HFAKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:10:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab1HFAKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:10:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:12 2011
Message-Id: <20110806000412.847636558@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephen Hemminger <shemminger@vyatta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [13/50] bridge: send proper message_age in config BPDU
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: stephen hemminger <shemminger@vyatta.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bridge/br_private.h |    1 +
 net/bridge/br_stp.c     |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -75,6 +75,7 @@ struct net_bridge_port
 	bridge_id			designated_bridge;
 	u32				path_cost;
 	u32				designated_cost;
+	unsigned long			designated_age;
 
 	struct timer_list		forward_delay_timer;
 	struct timer_list		hold_timer;
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -165,8 +165,7 @@ void br_transmit_config(struct net_bridg
 	else {
 		struct net_bridge_port *root
 			= br_get_port(br, br->root_port);
-		bpdu.message_age = br->max_age
-			- (root->message_age_timer.expires - jiffies)
+		bpdu.message_age = (jiffies - root->designated_age)
 			+ MESSAGE_AGE_INCR;
 	}
 	bpdu.max_age = br->max_age;
@@ -190,6 +189,7 @@ static inline void br_record_config_info
 	p->designated_cost = bpdu->root_path_cost;
 	p->designated_bridge = bpdu->bridge_id;
 	p->designated_port = bpdu->port_id;
+	p->designated_age = jiffies + bpdu->message_age;
 
 	mod_timer(&p->message_age_timer, jiffies
 		  + (p->br->max_age - bpdu->message_age));


