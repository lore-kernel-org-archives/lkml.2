Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1DSDQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:16:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54104 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab1DSDQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:16:26 -0400
Date: Tue, 19 Apr 2011 13:16:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yaniv Rosner <yanivr@broadcom.com>,
        stephen hemminger <shemminger@vyatta.com>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20110419131618.a474326a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/bnx2x/bnx2x_ethtool.c between commit 70dda99c41fc ("bnx2x:
Fix port identification problem") from the net-current tree and commit
32d3613475d8 ("bnx2x: convert to set_phys_id") from the net tree.

I fixed it up (maybe - see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/bnx2x/bnx2x_ethtool.c
index 89cb977,e711a22..0000000
--- a/drivers/net/bnx2x/bnx2x_ethtool.c
+++ b/drivers/net/bnx2x/bnx2x_ethtool.c
@@@ -2097,35 -2013,38 +2013,36 @@@ static void bnx2x_get_ethtool_stats(str
  	}
  }
  
- static int bnx2x_phys_id(struct net_device *dev, u32 data)
+ static int bnx2x_set_phys_id(struct net_device *dev,
+ 			     enum ethtool_phys_id_state state)
  {
  	struct bnx2x *bp = netdev_priv(dev);
- 	int i;
  
  	if (!netif_running(dev))
- 		return 0;
+ 		return -EAGAIN;
  
  	if (!bp->port.pmf)
- 		return 0;
+ 		return -EOPNOTSUPP;
  
- 	if (data == 0)
- 		data = 2;
+ 	switch (state) {
+ 	case ETHTOOL_ID_ACTIVE:
+ 		return 1;	/* cycle on/off once per second */
  
- 	for (i = 0; i < (data * 2); i++) {
- 		if ((i % 2) == 0)
- 			bnx2x_set_led(&bp->link_params, &bp->link_vars,
- 				      LED_MODE_ON, SPEED_1000);
- 		else
- 			bnx2x_set_led(&bp->link_params, &bp->link_vars,
- 				      LED_MODE_FRONT_PANEL_OFF, 0);
+ 	case ETHTOOL_ID_ON:
+ 		bnx2x_set_led(&bp->link_params, &bp->link_vars,
 -			      LED_MODE_OPER, SPEED_1000);
++			      LED_MODE_ON, SPEED_1000);
+ 		break;
  
- 		msleep_interruptible(500);
- 		if (signal_pending(current))
- 			break;
- 	}
+ 	case ETHTOOL_ID_OFF:
+ 		bnx2x_set_led(&bp->link_params, &bp->link_vars,
 -			      LED_MODE_OFF, 0);
++			      LED_MODE_FRONT_PANEL_OFF, 0);
+ 
+ 		break;
  
- 	bnx2x_set_led(&bp->link_params, &bp->link_vars,
- 		      LED_MODE_OPER, bp->link_vars.line_speed);
+ 	case ETHTOOL_ID_INACTIVE:
 -		if (bp->link_vars.link_up)
 -			bnx2x_set_led(&bp->link_params, &bp->link_vars,
 -				      LED_MODE_OPER,
 -				      bp->link_vars.line_speed);
++		bnx2x_set_led(&bp->link_params, &bp->link_vars,
++			      LED_MODE_OPER, bp->link_vars.line_speed);
+ 	}
  
  	return 0;
  }
