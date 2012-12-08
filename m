Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250Ab2LHAGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:06:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:52956 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177Ab2LHAGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:06:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,241,1355126400"; 
   d="scan'208";a="230560352"
From: Joseph Gasparakis <joseph.gasparakis@intel.com>
To: davem@davemloft.net, shemminger@vyatta.com, chrisw@sous-sol.org,
        gospo@redhat.com
Cc: Joseph Gasparakis <joseph.gasparakis@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry@broadcom.com,
        saeed.bishara@gmail.com, bhutchings@solarflare.com
Subject: [PATCH v4 net-next 0/5] tunneling: Add support for hardware-offloaded encapsulation
Date: Fri,  7 Dec 2012 16:14:13 -0800
Message-Id: <1354925658-24115-1-git-send-email-joseph.gasparakis@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series contains updates to add in the NIC Rx and Tx checksumming support
for encapsulated packets.

The sk_buff needs to somehow have information of the inner packet, and adding
three fields for the inner mac, network and transport headers was the prefered
approach. 

Not adding these fields would mean that the drivers would need to parse the
sk_buff data in hot-path, having a negative impact in the performance.

Adding in sk_buff a pointer to the skbuff of the inner packet made sense, but
would be a complicated change as assumptions needed to be made with regards to
helper functions such as skb_clone() skb_copy(). Also code for the existing
encapsulation protocols (such as VXLAN and IP GRE) had to be reworked, so the
decision was to have the simple approach of adding these three fields.

v2 Makes sure that checksumming for IP GRE does not take place if the offload
   flag is set in the skb's netdev features

v3 Fixes issues picked up by the community in v2 and is intended to provide
   ability to demo vxlan Tx offloading with Intel's ixgbe. As part of this, 
   it provides an RFC patch for ixgbe to take advantage of the offloading
   mechanism

   Now it is possible to create a vxlan interface like this:
    #ip link add vxlan0 type vxlan id 40 ttl 10 group 239.1.1.1 dev eth0

   Then turn on/off the encapsulation offload mechanism by doing:
    #ethtool -K eth0 tx-checksum-ip-generic on

   In v3 ipgre work got paused (and therefore patches not included) and I will
   come back to it when vxlan is accepted by the community.

v4 Added more detailed commit logs and code comments as per request in v3
   Also now the Rx offload encapsulation patch is included in the series.
