Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab2HMPbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:31:55 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55454 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2HMP12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:27:28 -0400
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@google.com, faisal.latif@intel.com,
        roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        fubar@us.ibm.com, andy@greyhouse.net, divy@chelsio.com,
        jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, bhutchings@solarflare.com, therbert@google.com,
        xiyou.wangcong@gmail.com, joe@perches.com, gregory.v.rose@intel.com,
        john.r.fastabend@intel.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        bridge@lists.linux-foundation.org, fbl@redhat.com
Subject: [patch net-next 03/16] vlan: add link to upper device
Date: Mon, 13 Aug 2012 17:27:02 +0200
Message-Id: <1344871635-1052-4-git-send-email-jiri@resnulli.us>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344871635-1052-1-git-send-email-jiri@resnulli.us>
References: <1344871635-1052-1-git-send-email-jiri@resnulli.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 net/8021q/vlan.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 9096bcb..739665e 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -105,6 +105,8 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
 	 */
 	unregister_netdevice_queue(dev, head);
 
+	netdev_upper_dev_unlink(real_dev, dev);
+
 	if (grp->nr_vlan_devs == 0)
 		vlan_gvrp_uninit_applicant(real_dev);
 
@@ -162,9 +164,13 @@ int register_vlan_dev(struct net_device *dev)
 	if (err < 0)
 		goto out_uninit_applicant;
 
+	err = netdev_upper_dev_link(real_dev, dev);
+	if (err)
+		goto out_uninit_applicant;
+
 	err = register_netdevice(dev);
 	if (err < 0)
-		goto out_uninit_applicant;
+		goto out_upper_dev_unlink;
 
 	/* Account for reference in struct vlan_dev_priv */
 	dev_hold(real_dev);
@@ -180,6 +186,8 @@ int register_vlan_dev(struct net_device *dev)
 
 	return 0;
 
+upper_dev_unlink:
+	netdev_upper_dev_unlink(real_dev, dev);
 out_uninit_applicant:
 	if (grp->nr_vlan_devs == 0)
 		vlan_gvrp_uninit_applicant(real_dev);
-- 
1.7.10.4

