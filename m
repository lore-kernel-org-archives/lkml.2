Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2HNPF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:05:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40617 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2HNPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:05:54 -0400
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
Subject: [patch net-next v2 00/15] net: introduce upper device lists and remove dev->master
Date: Tue, 14 Aug 2012 17:05:33 +0200
Message-Id: <1344956748-2099-1-git-send-email-jiri@resnulli.us>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

Recent discussion around
"[net-next] bonding: don't allow the master to become its slave"
forced me to think about upper<->lower device connections.

This patchset adds a possibility to record upper device linkage.
All upper<->lower devices are converted to use this mechanism right after.
That leads to dev->master removal because this info becomes redundant since
"unique links" have the same value.

After all changes, there is no longer possible to do:
"bond->someotherdevice->samebond"

Also I think that drivers like cxgb3, qlcnic, qeth would benefit by this
in future by being able to get more appropriate info about l3 addresses.

v1->v2:
- s/unique/master/ better naming + stays closer to the history
- fixed vlan err goto
- original patch 15 (WARN_ON change) is squashed into the first patch
- fixed netdev_unique_upper_dev_get_rcu() case of upper==NULL

Jiri Pirko (15):
  net: introduce upper device lists
  macvlan: add link to upper device
  vlan: add link to upper device
  rtnetlink: remove usage of dev->master
  team: remove usage of netdev_set_master()
  bridge: remove usage of netdev_set_master()
  netpoll: remove usage of dev->master
  cxgb3: remove usage of dev->master
  qlcnic: guard __vlan_find_dev_deep() by rcu_read_lock
  qeth: ensure that __vlan_find_dev_deep() is called with rcu_read_lock
  vlan: remove usage of dev->master in __vlan_find_dev_deep()
  nes: remove usage of dev->master
  bonding: remove usage of dev->master
  net: remove no longer used netdev_set_bond_master() and
    netdev_set_master()
  net: kill dev->master

 drivers/infiniband/hw/nes/nes.c                    |    8 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |    2 +-
 drivers/net/bonding/bond_3ad.c                     |   30 +--
 drivers/net/bonding/bond_alb.c                     |    6 +-
 drivers/net/bonding/bond_main.c                    |   94 ++++----
 drivers/net/bonding/bonding.h                      |   14 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |   11 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |    2 +
 drivers/net/macvlan.c                              |    9 +-
 drivers/net/team/team.c                            |   13 +-
 drivers/s390/net/qeth_l3_main.c                    |   21 +-
 include/linux/netdevice.h                          |   22 +-
 net/8021q/vlan.c                                   |   10 +-
 net/8021q/vlan_core.c                              |   18 +-
 net/bridge/br_if.c                                 |    6 +-
 net/core/dev.c                                     |  239 +++++++++++++++++---
 net/core/netpoll.c                                 |    8 +-
 net/core/rtnetlink.c                               |   45 ++--
 18 files changed, 391 insertions(+), 167 deletions(-)

-- 
1.7.10.4

