Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab1LWWL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 17:11:28 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47166 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab1LWWL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 17:11:27 -0500
Date: Fri, 23 Dec 2011 17:11:20 -0500 (EST)
Message-Id: <20111223.171120.2294828186632073149.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 23 Dec 2011 14:11:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) If no options are provided to mqprio packet scheduler config operation,	
   which is valid, we crash.  Fix from Thomas Graf.

2) The bridge layer's fake route entry needs to provide a ->mtu()
   method in it's fake_dst_ops, fix from Eric Dumazet.

3) Add a DST_NOPEER flag for cases like the bridge fake route entry so
   that we elide inetpeer based operations on such objects, also from
   Eric Dumazet.

4) More careful skb->trusize and socket buffer allotment tracking caused
   regressions f.e. when a device at jumbo MTU doesn't do copybreak and
   we try to perform a ping using busybox.  Busybox sets the socket send
   buffer real low, to something like 6K, and therefore the full 9K buffer
   (only a small amount of which is actually used) won't fit in the socket
   limits.

   Fix this using a compromise.  Always allow one packet to be queued to
   the socket, regardless of the buffer limits.

   From Eric Dumazet.

5) xt_connbytes netfilter module implements negation of rules incorrectly,
   fix from Florian Westphal.

Please pull, thanks a lot!

The following changes since commit b3b1b70e62a603f473619dbebc3b3d23f535e6f8:

  Merge branch 'usb-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2011-12-22 12:59:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

David S. Miller (1):
      Merge branch 'nf' of git://1984.lsi.us.es/net

Eric Dumazet (3):
      bridge: provide a mtu() method for fake_dst_ops
      net: introduce DST_NOPEER dst flag
      net: relax rcvbuf limits

Florian Westphal (1):
      netfilter: xt_connbytes: handle negation correctly

Thomas Graf (1):
      mqprio: Avoid panic if no options are provided

Xi Wang (1):
      rps: fix insufficient bounds checking in store_rps_dev_flow_table_cnt()

 include/net/dst.h            |    1 +
 include/net/sock.h           |    4 +++-
 net/bridge/br_netfilter.c    |    8 +++++++-
 net/core/net-sysfs.c         |    7 +++++--
 net/core/sock.c              |    6 +-----
 net/ipv4/route.c             |    4 ++--
 net/ipv6/ip6_output.c        |    2 +-
 net/netfilter/xt_connbytes.c |    6 +++---
 net/packet/af_packet.c       |    6 ++----
 net/sched/sch_mqprio.c       |    2 +-
 10 files changed, 26 insertions(+), 20 deletions(-)
