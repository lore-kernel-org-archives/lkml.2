Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1AZXNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:13:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59056
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753467Ab1AZXNW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:13:22 -0500
Date: Wed, 26 Jan 2011 15:13:56 -0800 (PST)
Message-Id: <20110126.151356.48484154.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The ipv6 inetpeer support changes this merge window introduced a
few regressions, sorry about that, but all of the ones I am aware
of should be completely fixed here.

We also have a bug fix for an 11 year old TCP bug, that to me is
the definition of "awesome"

1) INET peer cache releases ipv6 peers using ipv4 tree root, oops.
   Based upon a report by Eric Dumazet.

2) GRO packet merging bug fix from Michal Schmidt.  If the GRO code
   gets a linear SKB then a paged one, we merge incorrectly.  This is
   possible with the SFC driver which packages RX frames dynamically
   based upon a flow's behavior.

3) /proc/net/tcp optimization regression fix, we walk the listener hash
   incorrectly such that if there are enough sockets we can loop
   essentially forever.  Fix from Eric Dumazet.

4) The ipv6 inetpeer support wants to always attach peers to cached routes
   only.  This is almost always true, except for some special case situations
   wrt. local network routes.  Fix by always cloning these routes into
   RTF_CACHE ones.  Based upon a report by PK <runningdoglackey@yahoo.com>

5) Due to some merging side effects, we ended up undoing a memory clear for
   the ethtool get-regs request structure.  One change (the original fix)
   went kmalloc --> kzalloc, the other change did kmalloc --> vmalloc,
   and this wasn't caught during the merge (my bad).  Luckily Eugene Teo caught
   it and submitted thsi fix.

6) Like ipv4 ipsec routes, ipv6 ones must propagate the inetpeer binding from
   the non-ipsec child route.

7) Fix tg3 driver VLAN regressions reported by Eric Dumazet by converting over
   to the new VLAN driver interface framework.  From Matt Carlson.

8) Fix a TCP bug that causes erroneous resets to be emitted on the
   final "data + FIN" packet.  This bug dates back to January, 2000 :-)
   Fix from Jerry Chu.

9) Revert a set of ipv6 interface address semantic changes from last
   January that have broken several things, in particular the "disable_ipv6"
   sysctl.

10) at91_can driver chip bug errata handling from Marc Kleine-Budde.

11) New softing CAN driver from Kurt Van Dijck.

12) arp_ioctl() locking regression fix from Eric Dumazet based upon a report
    by Jamie Heilman.

13) atm idt77105 driver copies wrong stats back to userspace, fix from
    Vasiliy Kulikov.

14) Work cancelling fixup in pch_gbe from Tejun Heo.

15) CNIC endianness bug fix from Michael Chan, based upon a report by Breno
    Leitao.

16) BNX2 driver barks in logs about AER even on platforms where AER isn't even
    supported, fix from Michael Chan.

17) cxgb4 driver need to call netif_carrier_off() after registering the device,
    not before.

18) bonding crashes because it performs pskb_may_pull() potentially on shared
    SKBs, fix from Neil Horman.

19) All packet schedulers that can drop previously enqueued packets over-estimate
    their stats because the rules concerning bstats updates keep up from being
    able to undo the increment at drop time.  This makes accurate rate estimation
    et al. basically impossible.  Fix this by creating a helper function and
    doing the bstats increment at dequeue instead of enqueue time, this way the
    dropped frames do not accidently get into the state.  From Eric Dumazet.

20) Various bluetooth regression and memory leak fixes from Alexander Holler,
    Gustavo F. Padovan, David Sterba, Johan Hedberg, and Lukas Turek.

21) EEPROM reading fix for older iwlwifi devices from Wey-Yi Guy.

22) Disable PARPD on ath9k wireless, it is causing regressions in both
    connectivity and performance.  From Luis R. Rodriguez.

23) Missing dev_alloc_skb() error checking in rtlwifi, from Jesper Juhl.

24) ieee80211_beacon_get_tim() crash fix from Felix Fietkau.

Please pull, thanks a lot!

The following changes since commit c723fdab8aa728dc2bf0da6a0de8bb9c3f588d84:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6 (2011-01-25 14:23:54 +1000)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Alexander Holler (1):
      Bluetooth: ath3k: reduce memory usage

David S. Miller (7):
      Merge branch 'master' of master.kernel.org:/.../torvalds/linux-2.6
      inetpeer: Use correct AVL tree base pointer in inet_getpeer().
      Merge branch 'can/at91_can-for-net-2.6' of git://git.pengutronix.de/git/mkl/linux-2.6
      ipv6: Always clone offlink routes.
      ipv6: Revert 'administrative down' address handling changes.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      xfrm6: Don't forget to propagate peer into ipsec route.

David Sterba (1):
      Bluetooth: l2cap: fix misuse of logical operation in place of bitop

Dimitris Michailidis (1):
      cxgb4: fix reported state of interfaces without link

Eric Dumazet (3):
      net_sched: accurate bytes/packets stats/rates
      net: arp_ioctl() must hold RTNL
      tcp: fix bug in listening_get_next()

Eugene Teo (1):
      net: clear heap allocation for ethtool_get_regs()

Felix Fietkau (2):
      ath9k: add missing ps wakeup/restore calls
      mac80211: fix a crash in ieee80211_beacon_get_tim on change_interface

Greg Kroah-Hartman (1):
      rt2x00: add device id for windy31 usb device

Jerry Chu (1):
      TCP: fix a bug that triggers large number of TCP RST by mistake

Jesper Dangaard Brouer (1):
      textsearch: doc - fix spelling in lib/textsearch.c.

Jesper Juhl (2):
      rtlwifi: Fix possible NULL dereference
      USB NET KL5KUSB101: Fix mem leak in error path of kaweth_download_firmware()

Johan Hedberg (6):
      Bluetooth: Fix leaking blacklist when unregistering a hci device
      Revert "Bluetooth: Update sec_level/auth_type for already existing connections"
      Bluetooth: Fix MITM protection requirement preservation
      Bluetooth: Create a unified auth_type evaluation function
      Bluetooth: Fix authentication request for L2CAP raw sockets
      Bluetooth: Fix race condition with conn->sec_level

John Fastabend (1):
      dcbnl: make get_app handling symmetric for IEEE and CEE DCBx

Kurt Van Dijck (2):
      can: add driver for Softing card
      can: add driver for Softing card

Luis R. Rodriguez (1):
      ath9k_hw: disabled PAPRD for AR9003

Luká¨ Turek (1):
      Bluetooth: Never deallocate a session when some DLC points to it

Marc Kleine-Budde (3):
      can: at91_can: clean up usage of AT91_MB_RX_FIRST and AT91_MB_RX_NUM
      can: at91_can: don't use mailbox 0
      can: at91_can: make can_id of mailbox 0 configurable

Matt Carlson (1):
      tg3: Use new VLAN code

Michael Chan (3):
      bnx2: Always set ETH_FLAG_TXVLAN
      cnic: Fix big endian bug
      bnx2: Eliminate AER error messages on systems not supporting it

Michal Schmidt (1):
      GRO: fix merging a paged skb after non-paged skbs

Neil Horman (1):
      bonding: Ensure that we unshare skbs prior to calling pskb_may_pull

Nicolas de Pesloüan (1):
      bonding: update documentation - alternate configuration.

Reinette Chatre (1):
      MAINTAINERS: remove Reinette Chatre as iwlwifi maintainer

Tejun Heo (1):
      pch_gbe: don't use flush_scheduled_work()

Vasiliy Kulikov (1):
      atm: idt77105: fix fetch_stats() result

Wey-Yi Guy (1):
      iwlwifi: don't read sku information from EEPROM for 4965

 Documentation/ABI/testing/sysfs-platform-at91 |   25 +
 Documentation/networking/bonding.txt          |   83 ++-
 MAINTAINERS                                   |    1 -
 drivers/atm/idt77105.c                        |    2 +-
 drivers/bluetooth/ath3k.c                     |   75 +--
 drivers/net/bnx2.c                            |   21 +-
 drivers/net/bnx2.h                            |    1 +
 drivers/net/bonding/bond_3ad.c                |    4 +
 drivers/net/bonding/bond_alb.c                |    4 +
 drivers/net/bonding/bond_main.c               |    4 +
 drivers/net/can/Kconfig                       |    2 +
 drivers/net/can/Makefile                      |    1 +
 drivers/net/can/at91_can.c                    |  138 +++-
 drivers/net/can/softing/Kconfig               |   30 +
 drivers/net/can/softing/Makefile              |    6 +
 drivers/net/can/softing/softing.h             |  167 +++++
 drivers/net/can/softing/softing_cs.c          |  359 ++++++++++
 drivers/net/can/softing/softing_fw.c          |  691 +++++++++++++++++++
 drivers/net/can/softing/softing_main.c        |  893 +++++++++++++++++++++++++
 drivers/net/can/softing/softing_platform.h    |   40 ++
 drivers/net/cnic.c                            |   12 +-
 drivers/net/cxgb4/cxgb4_main.c                |    3 +-
 drivers/net/pch_gbe/pch_gbe_main.c            |    2 +-
 drivers/net/tg3.c                             |   95 +---
 drivers/net/tg3.h                             |    3 -
 drivers/net/usb/kaweth.c                      |    1 +
 drivers/net/wireless/ath/ath9k/hw.c           |    6 +-
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 drivers/net/wireless/ath/ath9k/main.c         |    8 +-
 drivers/net/wireless/ath/ath9k/xmit.c         |    2 -
 drivers/net/wireless/iwlwifi/iwl-4965.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   11 +-
 drivers/net/wireless/rt2x00/rt73usb.c         |    1 +
 drivers/net/wireless/rtlwifi/pci.c            |   11 +-
 include/net/bluetooth/hci_core.h              |    1 +
 include/net/sch_generic.h                     |    8 +-
 lib/textsearch.c                              |   10 +-
 net/bluetooth/hci_conn.c                      |   16 +-
 net/bluetooth/hci_core.c                      |    4 +
 net/bluetooth/hci_event.c                     |    9 +-
 net/bluetooth/l2cap.c                         |   84 +--
 net/bluetooth/rfcomm/core.c                   |    3 +-
 net/core/dev.c                                |    3 +-
 net/core/ethtool.c                            |    2 +-
 net/core/skbuff.c                             |    8 +-
 net/dcb/dcbnl.c                               |   13 +-
 net/ipv4/arp.c                                |   11 +-
 net/ipv4/inetpeer.c                           |    2 +-
 net/ipv4/tcp_input.c                          |    2 +-
 net/ipv4/tcp_ipv4.c                           |    1 -
 net/ipv6/addrconf.c                           |   81 +--
 net/ipv6/route.c                              |    9 +-
 net/ipv6/xfrm6_policy.c                       |    6 +
 net/mac80211/tx.c                             |    3 +
 net/sched/sch_cbq.c                           |    3 +-
 net/sched/sch_drr.c                           |    2 +-
 net/sched/sch_dsmark.c                        |    2 +-
 net/sched/sch_fifo.c                          |    5 +-
 net/sched/sch_hfsc.c                          |    2 +-
 net/sched/sch_htb.c                           |   12 +-
 net/sched/sch_multiq.c                        |    2 +-
 net/sched/sch_netem.c                         |    3 +-
 net/sched/sch_prio.c                          |    2 +-
 net/sched/sch_red.c                           |   11 +-
 net/sched/sch_sfq.c                           |    5 +-
 net/sched/sch_tbf.c                           |    2 +-
 net/sched/sch_teql.c                          |    3 +-
 67 files changed, 2650 insertions(+), 384 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-at91
 create mode 100644 drivers/net/can/softing/Kconfig
 create mode 100644 drivers/net/can/softing/Makefile
 create mode 100644 drivers/net/can/softing/softing.h
 create mode 100644 drivers/net/can/softing/softing_cs.c
 create mode 100644 drivers/net/can/softing/softing_fw.c
 create mode 100644 drivers/net/can/softing/softing_main.c
 create mode 100644 drivers/net/can/softing/softing_platform.h
