Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab1DSUpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:45:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57128
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356Ab1DSUpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:45:31 -0400
Date: Tue, 19 Apr 2011 13:44:57 -0700 (PDT)
Message-Id: <20110419.134457.242142987.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3JKk3Z6016296


It's the all new Linux networking, now with less OOPS:

1) inetpeer tree traversal uses an on-stack stack, which is fine, but
   when we miss and end up creating a new entry we can trigger into
   the tree cleanup code which will allocate yet another one of these
   stacks on the stack.

   Several reported crashes are believed to be caused by this.

   Fix by sharing the stack state between these two code paths, from
   Eric Dumazet.

2) igmp_max_memberships has real meaning even when CONFIG_IP_MULTICAST
   is not set, so do not use that config knob to control whether the
   sysctl for it is available or not.  Fix from Joakim Tjernlund.

3) Fix double skb free in connector, from Patrick McHardy.

4) sis900 and natsemi forget to store permanent mac address, fix from
   Otavio Salvador.

5) irda_sendmsg() has locking imbalance, fix from Dave Jones.

6) ieee802154 has bogus cflags overrides in it's makefile, causes build
   issues of various sorts (reported by Dave Jones).  Just kill them.

7) We properly disable TSO when scatter-gather is disabled for a device,
   but we forget to handle TSO6 too.

   Similarly, when both TSO features are turned off it makes no sense
   to have TSO_ECN turned on.

   Fixes from Ben Hutchings.

8) SCTP oops fixes wrt retransmits and transport references to retrans
   paths, from Wei Yongjun.

9) ipset bug fixes from Jozsef Kadlecsik.  Dumping order was wrong, and
   entry reclaim was buggy.

10) OF layer conversion of mpc5xxx_can driver broke the build, fix
    from Anatolij Gustschin.

11) qlcnic and netxen have fragment handling issues causing deadlocks,
    fixes from Amit Kumar Salecha.

12) CAIF needs to use list_for_each_entry_safe() in cfmuxl_ctrlcmd() since
    the loop removes nodes.  Fix from Sjur Br√¶ndeland.

13) Length check is busted, and assumes linear SKBs, in llc_fixup_skb().
    Fixes bugzilla #32872

14) sfc driver fixes from Ben Hutchings, loopback self-tests leave
    TX queues active, and online self-test had unintended side effects.

15) Comment and log message typo fixes from Weiping Pan.

16) Fix some more cases of IP option parsing when coming out of a
    bridge, from Eric Dumazet.  Also, make ip_options_compile()
    resilient to packets with no attached route.

17) FLAG_POINTTOPOINT and FLAG_MULTI_PACKET overlap in usbnet layer,
    oops.  Fix from Huajun Li.

18) RX path memory leak in ban driver, from Debashis Dutt.

19) Allowing VLAN over loopback causes crashes, particularly in ipv6
    routing, simply disallow this.  From Krishna Kumar.

20) Revert TCP bind() change that causes regressions for various
    programs, such as haproxy and amavisd.  Fixes kernel bugzilla 32832.

Please pull, thanks a lot!

The following changes since commit f0e615c3cb72b42191b558c130409335812621d8:

  Linux 2.6.39-rc4 (2011-04-18 21:26:00 -0700)

are available in the git repository at:
  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Amit Kumar Salecha (1):
      qlcnic: limit skb frags for non tso packet

Anatolij Gustschin (1):
      net: can: mscan: fix build breakage in mpc5xxx_can

Ben Hutchings (3):
      sfc: Do not use efx_process_channel_now() in online self-test
      net: Disable all TSO features when SG is disabled
      net: Disable NETIF_F_TSO_ECN when TSO is disabled

Brian Cavagnolo (1):
      mwl8k: do not free unrequested irq

Christian Lamparter (1):
      ath: add missing regdomain pair 0x5c mapping

Dave Jones (1):
      irda: fix locking unbalance in irda_sendmsg

David S. Miller (7):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      llc: Fix length check in llc_fixup_skb().
      ieee802154: Remove hacked CFLAGS in net/ieee802154/Makefile
      Merge branch 'sfc-2.6.39' of git://git.kernel.org/.../bwh/sfc-2.6
      Revert "tcp: disallow bind() to reuse addr/port"
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-2.6

Eric Dumazet (3):
      bridge: reset IPCB in br_parse_ip_options
      inetpeer: reduce stack usage
      ip: ip_options_compile() resilient to NULL skb route

Felix Fietkau (2):
      ath9k: fix missing ath9k_ps_wakeup/ath9k_ps_restore calls
      ath9k_hw: fix stopping rx DMA during resets

Francois Romieu (1):
      r8169: add Realtek as maintainer.

Giuseppe CAVALLARO (3):
      stmmac: fixed dma lib build when turn-on the debug option
      stmmac: fix open funct when exit on error
      stmmac: fix Transmit Underflow error

Jason Conti (1):
      p54: Initialize extra_len in p54_tx_80211

Joakim Tjernlund (1):
      net: Do not wrap sysctl igmp_max_memberships in IP_MULTICAST

Johannes Berg (1):
      iwlagn: override 5300 EEPROM # of chains

John W. Linville (1):
      iwlegacy: make iwl3945 and iwl4965 select IWLWIFI_LEGACY

Jozsef Kadlecsik (5):
      netfilter: ipset: list:set timeout variant fixes
      netfilter: ipset: References are protected by rwlock instead of mutex
      netfilter: ipset: bitmap:ip,mac type requires "src" for MAC
      netfilter: ipset: set match and SET target fixes
      netfilter: ipset: Fix the order of listing of sets

Krishna Kumar (1):
      ip6_pol_route panic: Do not allow VLAN on loopback

Neil Turton (2):
      sfc: Stop the TX queues during loopback self-tests
      sfc: Use rmb() to ensure reads occur in order

Otavio Salvador (2):
      net/sis900: store MAC into perm_addr for SiS 900, 630E, 635 and 96x variants
      net/natsami: store MAC into perm_addr

Patrick McHardy (2):
      connector: fix skb double free in cn_rx_skb()
      Merge branch 'master' of ssh://master.kernel.org/.../kaber/nf-2.6

Peter Pan(ÊΩòÂç´Âπ≥) (5):
      bonding:set save_load to 0 when initializing
      bonding:delete unused alb_timer
      bonding:delete unused rlb_interval_counter
      net: fix tranmitted/tranmitting typo
      bonding:fix two typos

Rasesh Mody (2):
      bna: fix for clean fw re-initialization
      bna: fix memory leak during RX path cleanup

Sjur Br√¶ndeland (2):
      caif: Bugfix use for_each_safe when removing list nodes.
      caif: performance bugfix - allow radio stack to prioritize packets.

Stanislaw Gruszka (1):
      iwlegacy: fix tx_power initialization

Sujith Manoharan (1):
      ath9k_htc: Fix ethtool reporting

Vlad Yasevich (1):
      sctp: fix oops when updating retransmit path with DEBUG on

Wei Yongjun (1):
      sctp: fix oops while removed transport still using as retran path

Yaniv Rosner (1):
      bnx2x: Fix port identification problem

amit salecha (1):
      netxen: limit skb frags for non tso packet

huajun li (1):
      usbnet: Fix up 'FLAG_POINTTOPOINT' and 'FLAG_MULTI_PACKET' overlaps.

 MAINTAINERS                                  |    1 +
 drivers/connector/connector.c                |    1 +
 drivers/net/bna/bfa_ioc.c                    |   31 +++++++++-------
 drivers/net/bna/bfa_ioc.h                    |    1 +
 drivers/net/bna/bfa_ioc_ct.c                 |   28 +++++++++++++++
 drivers/net/bna/bfi.h                        |    6 ++-
 drivers/net/bna/bnad.c                       |    1 -
 drivers/net/bnx2x/bnx2x_ethtool.c            |    9 ++---
 drivers/net/bonding/bond_alb.c               |    6 ++--
 drivers/net/bonding/bond_alb.h               |    4 +--
 drivers/net/can/mscan/mpc5xxx_can.c          |    2 +-
 drivers/net/loopback.c                       |    3 +-
 drivers/net/natsemi.c                        |    3 ++
 drivers/net/netxen/netxen_nic.h              |    4 +-
 drivers/net/netxen/netxen_nic_main.c         |   17 +++++++++
 drivers/net/qlcnic/qlcnic.h                  |    1 +
 drivers/net/qlcnic/qlcnic_main.c             |   14 +++++++
 drivers/net/sfc/efx.c                        |    6 ++-
 drivers/net/sfc/io.h                         |    2 +
 drivers/net/sfc/net_driver.h                 |    2 -
 drivers/net/sfc/nic.c                        |   22 ++++++++----
 drivers/net/sfc/nic.h                        |    1 +
 drivers/net/sfc/selftest.c                   |   25 +++----------
 drivers/net/sfc/tx.c                         |    3 +-
 drivers/net/sis900.c                         |   23 ++++++++++--
 drivers/net/stmmac/dwmac_lib.c               |   28 +++++++-------
 drivers/net/stmmac/stmmac_main.c             |   49 +++++++++++++++-----------
 drivers/net/tokenring/3c359.c                |    4 +-
 drivers/net/tokenring/lanstreamer.c          |    2 +-
 drivers/net/tokenring/olympic.c              |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c     |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c          |    9 -----
 drivers/net/wireless/ath/ath9k/mac.c         |   25 +++++++++++--
 drivers/net/wireless/ath/ath9k/mac.h         |    2 +-
 drivers/net/wireless/ath/ath9k/main.c        |   12 +++++-
 drivers/net/wireless/ath/ath9k/recv.c        |    6 ++--
 drivers/net/wireless/ath/regd_common.h       |    1 +
 drivers/net/wireless/iwlegacy/Kconfig        |    9 +++--
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h  |    2 -
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h  |    3 --
 drivers/net/wireless/iwlegacy/iwl-core.c     |   17 ++++++---
 drivers/net/wireless/iwlegacy/iwl-eeprom.c   |    7 ----
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    4 --
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    6 ---
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    3 ++
 drivers/net/wireless/mwl8k.c                 |    9 ++++-
 drivers/net/wireless/p54/txrx.c              |    2 +-
 include/linux/usb/usbnet.h                   |    4 +-
 net/bridge/br_netfilter.c                    |    6 +--
 net/caif/cfdgml.c                            |    6 +++-
 net/caif/cfmuxl.c                            |    4 +-
 net/core/dev.c                               |   10 ++++--
 net/ieee802154/Makefile                      |    2 -
 net/ipv4/inet_connection_sock.c              |    5 +--
 net/ipv4/inetpeer.c                          |   13 ++++---
 net/ipv4/ip_options.c                        |    6 ++--
 net/ipv4/sysctl_net_ipv4.c                   |    3 --
 net/ipv6/inet6_connection_sock.c             |    2 +-
 net/irda/af_irda.c                           |    3 +-
 net/llc/llc_input.c                          |    3 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c    |    4 ++
 net/netfilter/ipset/ip_set_core.c            |   18 +++++----
 net/netfilter/xt_set.c                       |   18 ++++++++-
 net/sctp/associola.c                         |    4 ++
 64 files changed, 330 insertions(+), 203 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
