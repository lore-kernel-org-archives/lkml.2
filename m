Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0C3XJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:09:30 -0400
Received: from kroah.org ([198.145.64.141]:48597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab0C3XJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:19 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:50:04 2010
Message-Id: <20100330225003.717663331@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Pirko <jpirko@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Jean Delvare <jdelvare@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [36/45] bonding: ignore updelay param when there is no active slave
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Pirko <jpirko@redhat.com>

commit 41f8910040639eb106b1a5b5301aab79ecde4940 upstream.

Pointed out by Sean E. Millichamp.

Quote from Documentation/networking/bonding.txt:
"Note that when a bonding interface has no active links, the
driver will immediately reuse the first link that goes up, even if the
updelay parameter has been specified (the updelay is ignored in this
case).  If there are slave interfaces waiting for the updelay timeout
to expire, the interface that first went into that state will be
immediately reused.  This reduces down time of the network if the
value of updelay has been overestimated, and since this occurs only in
cases with no connectivity, there is no additional penalty for
ignoring the updelay."

This patch actually changes the behaviour in this way.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bonding/bond_main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2228,6 +2228,9 @@ static int bond_miimon_inspect(struct bo
 {
 	struct slave *slave;
 	int i, link_state, commit = 0;
+	bool ignore_updelay;
+
+	ignore_updelay = !bond->curr_active_slave ? true : false;
 
 	bond_for_each_slave(bond, slave, i) {
 		slave->new_link = BOND_LINK_NOCHANGE;
@@ -2292,6 +2295,7 @@ static int bond_miimon_inspect(struct bo
 				       ": %s: link status up for "
 				       "interface %s, enabling it in %d ms.\n",
 				       bond->dev->name, slave->dev->name,
+				       ignore_updelay ? 0 :
 				       bond->params.updelay *
 				       bond->params.miimon);
 			}
@@ -2310,9 +2314,13 @@ static int bond_miimon_inspect(struct bo
 				continue;
 			}
 
+			if (ignore_updelay)
+				slave->delay = 0;
+
 			if (slave->delay <= 0) {
 				slave->new_link = BOND_LINK_UP;
 				commit++;
+				ignore_updelay = false;
 				continue;
 			}
 


