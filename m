Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab0LJJvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 04:51:43 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47179 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0LJJvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 04:51:39 -0500
Subject: [RFC PATCH V2 0/5] macvtap TX zero copy between guest and host
 kernel
From: Shirley Ma <mashirle@us.ibm.com>
To: Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>, mst@redhat.com
Cc: xiaohui.xin@intel.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 01:51:31 -0800
Message-ID: <1291974691.2167.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add supports for TX zero-copy between guest and host
kernel through vhost. It significantly reduces CPU utilization on the
local host on which the guest is located (It reduced 30-50% CPU usage
for vhost thread for single stream test). The patchset is based on
previous submission and comments from the community regarding when/how
to handle guest kernel buffers to be released. This is the simplest
approach I can think of after comparing with several other solutions.

This patchset includes:

1. Induce a new sock zero-copy flag, SOCK_ZEROCOPY;

2. Induce a new device flag, NETIF_F_ZEROCOPY for device can support
zero-copy;

3. Add a new struct skb_ubuf_info in skb_share_info for userspace
buffers release callback when device DMA has done for that skb;

4. Add vhost zero-copy callback in vhost when skb last refcnt is gone;
   add vhost_zerocopy_add_used_and_signal to notify guest to release TX
skb buffers.

5. Add macvtap zero-copy in lower device when sending packet is greater
than 128 bytes.

The patchset has passed netperf/netserver test on Chelsio, and
continuing test on other 10GbE NICs, like Intel ixgbe, Mellanox mlx4...
I will provide guest to host, host to guest performance data next week.

However when running stress test, vhost & virtio_net seems out of sync,
and virito_net interrupt was disabled somehow, and it stopped to send
any packet. This problem has bothered me for a long long time, I will
continue to look at this.

Please review this.

Thanks
Shirley

