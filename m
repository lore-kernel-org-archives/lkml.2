Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030736Ab2HGWka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:40:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030705Ab2HGWkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:40:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amir Hanania <amir.hanania@intel.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 080/109] net: Fix memory leak - vlan_info struct
Date: Tue,  7 Aug 2012 15:35:39 -0700
Message-Id: <20120807222050.116059350@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Amir Hanania <amir.hanania@intel.com>

[ Upstream commit efc73f4bbc238d4f579fb612c04c8e1dd8a82979 ]

In driver reload test there is a memory leak.
The structure vlan_info was not freed when the driver was removed.
It was not released since the nr_vids var is one after last vlan was removed.
The nr_vids is one, since vlan zero is added to the interface when the interface
is being set, but the vlan zero is not deleted at unregister.
Fix - delete vlan zero when we unregister the device.

Signed-off-by: Amir Hanania <amir.hanania@intel.com>
Acked-by: John Fastabend <john.r.fastabend@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -403,6 +403,9 @@ static int vlan_device_event(struct noti
 		break;
 
 	case NETDEV_DOWN:
+		if (dev->features & NETIF_F_HW_VLAN_FILTER)
+			vlan_vid_del(dev, 0);
+
 		/* Put all VLANs for this dev in the down state too.  */
 		for (i = 0; i < VLAN_N_VID; i++) {
 			vlandev = vlan_group_get_device(grp, i);


