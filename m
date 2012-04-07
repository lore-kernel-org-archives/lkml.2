Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab2DGB1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 21:27:32 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:41288 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752409Ab2DGB1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 21:27:30 -0400
From: "[PATCH 1/2]"@fess.ebiederm.org, "net:In"@fess.ebiederm.org,
        unregister_netdevice_notifier@fess.ebiederm.org,
        unregister@fess.ebiederm.org, the@fess.ebiederm.org,
        "netdevices."@fess.ebiederm.org
To: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>, Dave Jones <davej@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?utf-8?Q?R=C3=A9mi?= Denis-Courmont 
	<remi.denis-courmont@nokia.com>,
        Sasha Levin <levinsasha928@gmail.com>
References: <1333664446.3538.12.camel@lappy>
	<m1aa2pwxap.fsf@fess.ebiederm.org>
	<CA+1xoqdi4QOhRJvBA64pxiN3EphhThjPkf4eLRkYM8jxcJjh=w@mail.gmail.com>
	<m1mx6otk85.fsf@fess.ebiederm.org>
Date: Fri, 06 Apr 2012 18:31:14 -0700
In-Reply-To: <m1mx6otk85.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Fri, 06 Apr 2012 18:16:10 -0700")
Message-ID: <m1iphctjj1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19EUszNEh97OjpeJbHMY+xp8hLO7pgVBjc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 XMNumbers Suspicious email with numbers in From & Subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: **
Subject: Re: net: kernel BUG() in net/netns/generic.h:45
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We already synthesize events in register_netdevice_notifier and synthesizing
events in unregister_netdevice_notifier allows to us remove the need for
special case cleanup code.

This change should be trivially safe as it adds no new cases for
existing callers of unregister_netdevice_notifier to handle.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/core/dev.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 452db70..77c0a87 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1410,14 +1410,34 @@ EXPORT_SYMBOL(register_netdevice_notifier);
  *	register_netdevice_notifier(). The notifier is unlinked into the
  *	kernel structures and may then be reused. A negative errno code
  *	is returned on a failure.
+ *
+ * 	After unregistering unregister and down device events are synthesized
+ *	for all devices on the device list to the removed notifier to remove
+ *	the need for special case cleanup code.
  */
 
 int unregister_netdevice_notifier(struct notifier_block *nb)
 {
+	struct net_device *dev;
+	struct net *net;
 	int err;
 
 	rtnl_lock();
 	err = raw_notifier_chain_unregister(&netdev_chain, nb);
+	if (err)
+		goto unlock;
+
+	for_each_net(net) {
+		for_each_netdev(net, dev) {
+			if (dev->flags & IFF_UP) {
+				nb->notifier_call(nb, NETDEV_GOING_DOWN, dev);
+				nb->notifier_call(nb, NETDEV_DOWN, dev);
+			}
+			nb->notifier_call(nb, NETDEV_UNREGISTER, dev);
+			nb->notifier_call(nb, NETDEV_UNREGISTER_BATCH, dev);
+		}
+	}
+unlock:
 	rtnl_unlock();
 	return err;
 }
-- 
1.7.2.5

