Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab0FMHI0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 03:08:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:64763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab0FMHIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 03:08:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,410,1272870000"; 
   d="scan'208";a="526372962"
Subject: BUG: aim7/specjbb2005/fio hang due to commit:
 597a264b1a9c7e36d1728f
From: "Alex,Shi" <alex.shi@intel.com>
To: john.r.fastabend@intel.com
Cc: davem@davemloft.net, yanmin.zhang@intel.com, tim.c.chen@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jun 2010 14:14:00 +0800
Message-ID: <1276409640.9452.49.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The listed benchmark using loopback mode netio and all hang in 35-rc3
testing. Yanmin and I found it is due to the commit
597a264b1a9c7e36d1728f677c66c5c1f7e3b837. 
After revert this patch, all benchmarks can be recovered. Seems the
following line is the suspicious. 



+       /*
+        * bonding note: skbs received on inactive slaves should only
+        * be delivered to pkt handlers that are exact matches.  Also
+        * the deliver_no_wcard flag will be set.  If packet handlers
+        * are sensitive to duplicate packets these skbs will need to
+        * be dropped at the handler.  The vlan accel path may have
+        * already set the deliver_no_wcard flag.
+        */
        null_or_orig = NULL;
        orig_dev = skb->dev;
        master = ACCESS_ONCE(orig_dev->master);
-       if (master) {
-               if (skb_bond_should_drop(skb, master))
+       if (skb->deliver_no_wcard)
+               null_or_orig = orig_dev;
+       else if (master) {
+               if (skb_bond_should_drop(skb, master)) {
+                       skb->deliver_no_wcard = 1;
                        null_or_orig = orig_dev; /* deliver only exact
match */
-               else
+               } else
                        skb->dev = master;
        }

Thanks
Alex 

