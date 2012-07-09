Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab2GIUwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:52:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:50794 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2GIUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:51:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: Dilip Daya <dilip.daya@hp.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <1340900320.3441.88.camel@pro6455b.example.com>
	<20120705220749.GA11255@mail.hallyn.com> <87ehopu3e5.fsf@xmission.com>
	<20120706170538.GA31679@mail.hallyn.com> <87fw94g1kq.fsf@xmission.com>
	<20120706194741.GA22113@mail.hallyn.com>
Date: Mon, 09 Jul 2012 13:51:45 -0700
In-Reply-To: <20120706194741.GA22113@mail.hallyn.com> (Serge E. Hallyn's
	message of "Fri, 6 Jul 2012 19:47:41 +0000")
Message-ID: <87y5ms3bfi.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/PnspgN/d3xLWFDtn+iTPG8GlpbMxjjP0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: [PATCH 1/2] bonding: Manage /proc/net/bonding/ entries from the netdev events
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It was recently reported that moving a bonding device between network
namespaces causes warnings from /proc.  It turns out after the move we
were trying to add and to remove the /proc/net/bonding entries from the
wrong network namespace.

Move the bonding /proc registration code into the NETDEV_REGISTER and
NETDEV_UNREGISTER events where the proc registration and unregistration
will always happen at the right time.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/net/bonding/bond_main.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2ee8cf9..50de0fe 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3226,6 +3226,12 @@ static int bond_master_netdev_event(unsigned long event,
 	switch (event) {
 	case NETDEV_CHANGENAME:
 		return bond_event_changename(event_bond);
+	case NETDEV_UNREGISTER:
+		bond_remove_proc_entry(event_bond);
+		break;
+	case NETDEV_REGISTER:
+		bond_create_proc_entry(event_bond);
+		break;
 	default:
 		break;
 	}
@@ -4410,8 +4416,6 @@ static void bond_uninit(struct net_device *bond_dev)
 
 	bond_work_cancel_all(bond);
 
-	bond_remove_proc_entry(bond);
-
 	bond_debug_unregister(bond);
 
 	__hw_addr_flush(&bond->mc_list);
@@ -4813,7 +4817,6 @@ static int bond_init(struct net_device *bond_dev)
 
 	bond_set_lockdep_class(bond_dev);
 
-	bond_create_proc_entry(bond);
 	list_add_tail(&bond->bond_list, &bn->dev_list);
 
 	bond_prepare_sysfs_group(bond);
-- 
1.7.5.4

