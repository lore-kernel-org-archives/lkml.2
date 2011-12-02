Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1LBDzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 22:55:41 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41176 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab1LBDzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 22:55:39 -0500
Date: Thu, 01 Dec 2011 22:55:33 -0500 (EST)
Message-Id: <20111201.225533.1697648312581583377.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 01 Dec 2011 19:55:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB23tsAa023848


Lots of tiny fixes, pretty much everywhere.  Nothing really stands out, but
each bug is certainly a bummer if you happen to run into it.

I hope all the PMTU and redirect regressions I added to the ipv4 code
are really fixed now :-)  A huge thanks to Steffen Klassert, Eric Dumazet,
and others for helping to resolve these problems.

The netfilter ADVANCED depency adjustments are, of course, in here too.

1) ARCNET and PHYLIB were inadvertantly changed to bool, revert back to
   tristate.  From Ben Hutchings.

2) Two netfilter ADVANCED adjustments.

3) Cached route lookups must validate referenced inetpeer.

4) Revert old udp_recvmsg() 'redundant variable' change, because in fact
   the 'copied' variable was not redundant and this broke things when
   encountering UDP packets with bad checksums.

5) TCP ipv6 input packet processing could crash under various
   circumstances in error paths, fixes from Eric Dumazet.

6) Fix bad decnet socket refcounting, also from Eric Dumazet.

7) L2TP needs to validate attached socket route, fix from Florian Westphal.

8) Proxy ARP entries listed improperly in network namespace, fix from
   Jorge Boncompte.

9) IGMP's ip_mc_add_src() incorrectly decrements the entry refcount,
   fix from Jun Zhao.

10) bnx2x LED handling fix from Yaniv Rosner.

11) TX descriptor list was mis-sized in qlge driver, fix from Thadeu
    Lima de Souza Cascardo.

12) ehea per-TX-queue memory consumption was enormous, scale it
    down to be more reasonable, from Anton Blanchard.

13) We have to adjust the IP header ->daddr in ip_forward_options()
    not ip_options_rcv_srr() as the latter is too early.  Fix from
    Li Wei.

14) Netlabel adds to ipv4 map list in ipv6 code :-)  Fix from
    Dan Carpenter.

15) Several MTU handling regression fixes in ipv4 from Steffen Klassert.

16) DM9000 driver tests bit using && instead of &.  Fix from Mark Brown.

17) Concurrent stream socket reads may cause poll() to incorrectly block
    for AF_UNIX sockets, report and fix from Alexey Moiseytsev.

18) Invalidate cached ipv4 redirects properly, fix from Eric Dumazet.

19) Some 802.11 netlink attributes were not being validated properly,
    fix from Eliad Peller.

20) Wireless TX aggregation accidental double-stop fix from Johannes Berg.

21) rtlwifi can deadlock on lps_lock, fix from Stanislaw Gruszka.

22) /proc/*/net/dev_mcast output corruption fix from Anton Blanchard.

23) "-1" means default for multicast hops in ipv6, fix from Li Wei.

24) Integer overflow fix in SCTP from Xi Wang, although it took me two
    tries to get it committed properly, my bad.

25) ISDN string NULL termination fixes from Dan Carpenter.

26) TEQL driver needs to perform dst_get_neighbour() under proper
    RCU protection, fix from Eric Dumazet.

27) Likewise, fix a similar lockdep splat in rt_cache_seq_show, also
    from Eric Dumazet.

28) When the PSCHED_SHIFT was adjusted from 10 to 6 the RED packet scheduler did
    not have it's idle period handling adjusted properly.  Fix from Eric Dumazet.
    
29) When bridge user-stp mode is used, we can get the device stuck in no-carrier
    state forever.  Fix from Vitalii Demianets.

30) When the RED packet scheduler was made classful, we didn't update the test
    for queue empty.  It must check q->qdisc->q.len not whether sch->q is empty.
    Fix from Eric Dumazet.

31) Missing spin_lock_init() and workqueue deadlock fix in p54spi driver from
    Michael Buesch.

32) ip_route_me_harder() in netfilter needs to use HH_DATA_ALIGN when expanding
    the SKB header area, otherwise packet headers become misaligned.  Fix
    from Paul Guo.

33) iseries_veth uses wrong length argument to memset() call, from Thomas Jarosch.

34) When DCCP ipv4 connect fails to lookup a route, we don't record the error
    from the 'rt' error pointer properly, fix from RongQing Li.

35) Fix namespace based OOPS in nf_conntrack by making event callback
    registration per-ns.  Fix from Pablo Neira Ayuso.

36) In netlink socket dumps, report the TOS attribute of inet sockets,
    regardless of whether they are ipv4 or ipv6, because this value
    has meaning for ipv4 mapped ipv6 connections.  Fix from Maciej
    Å»enczykowski.

37) ndisc_send_redirect() has reversed rate limiting check, oops.  Fix from
    Li Wei.

38) B44 needs to use dev_kfree_skb_irq() when releasing TX buffers because
    the free runs with an IRQ safe spinlock held, fix from Xander Hover.

39) If we reuse a TCP time-wait socket in ipv6, we erroneously drop the SYN
    because treq->iif is not set early enough in tcp_v6_conn_request().  Fix
    from Eric Dumazet.  This was largely not noticed because 1 second later the
    client would resend the SYN and that would work since the first SYN
    killed off the time-wait entry.

40) Fix PHY initialization in jme driver, from Aries Lee.

Please pull, thanks a lot.

The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

  Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

Alexey Moiseytsev (1):
      AF_UNIX: Fix poll blocking problem when reading from a stream socket

Anton Blanchard (3):
      ehea: Reduce memory usage in buffer pools
      ehea: Use round_jiffies_relative to align workqueue
      net: Fix corruption in /proc/*/net/dev_mcast

Aries Lee (1):
      jme: PHY configuration for compatible issue

Ben Greear (1):
      mac80211: Fix AMSDU rate printout in debugfs.

Ben Hutchings (1):
      net: Revert ARCNET and PHYLIB to tristate options

Dan Carpenter (5):
      prism54: potential memory corruption in prism54_get_essid()
      caif: fix endian conversion in cffrml_transmit()
      net/netlabel: copy and paste bug in netlbl_cfg_unlbl_map_add()
      isdn: make sure strings are null terminated
      isdn: avoid copying too long drvid

David S. Miller (5):
      netfilter: Remove NOTRACK/RAW dependency on NETFILTER_ADVANCED.
      Merge branch 'nf' of git://1984.lsi.us.es/net
      ipv4: Perform peer validation on cached route lookup.
      Revert "udp: remove redundant variable"
      netfilter: Remove ADVANCED dependency from NF_CONNTRACK_NETBIOS_NS

Eliad Peller (1):
      nl80211: fix MAC address validation

Emmanuel Grumbach (1):
      mac80211: fix race between the AGG SM and the Tx data path

Eric Dumazet (8):
      ipv6: tcp: fix panic in SYN processing
      ipv6: tcp: fix tcp_v6_conn_request()
      decnet: proper socket refcounting
      inet: add a redirect generation id in inetpeer
      sch_teql: fix lockdep splat
      ipv4: fix lockdep splat in rt_cache_seq_show
      sch_red: fix red_calc_qavg_from_idle_time
      sch_red: fix red_change

Fabio Estevam (1):
      net: fec: Select the FEC driver by default for i.MX SoCs

Feng King (1):
      net: correct comments of skb_shift

Florian Westphal (1):
      l2tp: ensure sk->dst is still valid

Gertjan van Wingerde (1):
      rt2x00: Fix efuse EEPROM reading on PPC32.

Giuseppe CAVALLARO (1):
      stmmac: mask mmc interrupts

Helmut Schaa (1):
      mac80211: Fix endian bug in radiotap header generation

Henrik Saavedra Persson (1):
      bonding: only use primary address for ARP

Jan Beulich (1):
      xen-netback: use correct index for invalidation in xen_netbk_tx_check_gop()

Jesper Juhl (1):
      net, sja1000: Don't include version.h in peak_pci.c when not needed

Johannes Berg (2):
      cfg80211: fix regulatory NULL dereference
      mac80211: don't stop a single aggregation session twice

John W. Linville (4):
      Revert "rt2x00: handle spurious pci interrupts"
      Revert "rt2800pci: handle spurious interrupts"
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Jorge Boncompte [DTI2] (1):
      netns: fix proxy ARP entries listing on a netns

Jozsef Kadlecsik (1):
      netfilter: ipset: suppress compile-time warnings in ip_set_hash_ipport*.c

Jun Zhao (1):
      ipv4 : igmp : fix error handle in ip_mc_add_src()

Li Wei (3):
      ipv6: fix a bug in ndisc_send_redirect
      ipv4: Save nexthop address of LSRR/SSRR option to IPCB.
      ipv6: Set mcast_hops to IPV6_DEFAULT_MCASTHOPS when -1 was given.

Maciej Å»enczykowski (1):
      net-netlink: fix diag to export IPv4 tos for dual-stack IPv6 sockets

Mark Brown (1):
      dm9000: Fix check for disabled wake on LAN

Michael Buesch (2):
      p54spi: Add missing spin_lock_init
      p54spi: Fix workqueue deadlock

Nikolay Martynov (1):
      mac80211: fix race condition caused by late addBA response

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack: make event callback registration per-netns

Paul Guo (1):
      netfilter: possible unaligned packet header in ip_route_me_harder

Paul Moore (1):
      netlabel: Fix build problems when IPv6 is not enabled

Peter Pan(æ½˜å«å¹³) (1):
      ipv4: flush route cache after change accept_local

Rafael J. Wysocki (1):
      ath9k: Revert change that broke AR928X on Acer Ferrari One

RongQing.Li (2):
      dccp: fix error propagation in dccp_v4_connect
      net/core: fix rollback handler in register_netdevice_notifier

Stanislaw Gruszka (3):
      rt2800pci: handle spurious interrupts
      rt2x00: handle spurious pci interrupts
      rtlwifi: fix lps_lock deadlock

Steffen Klassert (5):
      route: Use the device mtu as the default for blackhole routes
      net: Rename the dst_opt default_mtu method to mtu
      net: Move mtu handling down to the protocol depended handlers
      route: struct rtable can be const in rt_is_input_route and rt_is_output_route
      ipv4: Don't use the cached pmtu informations for input routes

Thadeu Lima de Souza Cascardo (1):
      qlge: fix size of external list for TX address descriptors

Thomas Jarosch (1):
      iseries_veth: Fix wrong parameter given to sizeof call

Vitalii Demianets (1):
      bridge: master device stuck in no-carrier state forever when in user-stp mode

Xander Hover (1):
      b44: Use dev_kfree_skb_irq() in b44_tx()

Xi Wang (2):
      sctp: integer overflow in sctp_auth_create_key()
      sctp: better integer overflow check in sctp_auth_create_key()

Yaniv Rosner (1):
      bnx2x: Fix 5461x LED

stephen hemminger (1):
      tc: comment spelling fixes

 drivers/isdn/divert/divert_procfs.c               |    6 +
 drivers/isdn/i4l/isdn_net.c                       |    3 +
 drivers/net/arcnet/Kconfig                        |    2 +-
 drivers/net/bonding/bond_main.c                   |   33 +-----
 drivers/net/can/sja1000/peak_pci.c                |    1 -
 drivers/net/ethernet/broadcom/b44.c               |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c  |   39 +++++++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h   |    1 +
 drivers/net/ethernet/davicom/dm9000.c             |    2 +-
 drivers/net/ethernet/freescale/Kconfig            |    1 +
 drivers/net/ethernet/ibm/ehea/ehea.h              |    4 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c         |    6 +-
 drivers/net/ethernet/ibm/iseries_veth.c           |    2 +-
 drivers/net/ethernet/jme.c                        |  113 ++++++++++++++++++++-
 drivers/net/ethernet/jme.h                        |   19 ++++
 drivers/net/ethernet/qlogic/qlge/qlge.h           |    8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   14 ++-
 drivers/net/phy/Kconfig                           |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c               |    3 +-
 drivers/net/wireless/p54/p54spi.c                 |    5 +-
 drivers/net/wireless/prism54/isl_ioctl.c          |    2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c           |    2 +-
 drivers/net/wireless/rtlwifi/ps.c                 |   17 ++--
 drivers/net/xen-netback/netback.c                 |    2 +-
 include/linux/netdevice.h                         |    2 +
 include/linux/pkt_sched.h                         |    6 +-
 include/net/dst.h                                 |    7 +-
 include/net/dst_ops.h                             |    2 +-
 include/net/inet_sock.h                           |    2 +
 include/net/inetpeer.h                            |    1 +
 include/net/netfilter/nf_conntrack_ecache.h       |   19 ++--
 include/net/netns/conntrack.h                     |    2 +
 include/net/red.h                                 |   15 +--
 include/net/route.h                               |    4 +-
 net/bridge/br_netlink.c                           |    6 +
 net/bridge/br_stp.c                               |   29 +++---
 net/caif/cffrml.c                                 |   11 +-
 net/core/dev.c                                    |    9 ++-
 net/core/dev_addr_lists.c                         |    3 +-
 net/core/neighbour.c                              |    5 +-
 net/core/skbuff.c                                 |    2 +-
 net/dccp/ipv4.c                                   |    1 +
 net/decnet/dn_route.c                             |   10 +-
 net/decnet/dn_timer.c                             |   17 +--
 net/ipv4/devinet.c                                |    5 +
 net/ipv4/igmp.c                                   |    3 +-
 net/ipv4/inet_diag.c                              |   14 ++-
 net/ipv4/ip_forward.c                             |    2 +-
 net/ipv4/ip_options.c                             |    5 +-
 net/ipv4/netfilter.c                              |    3 +-
 net/ipv4/netfilter/Kconfig                        |    1 -
 net/ipv4/route.c                                  |   67 +++++++++----
 net/ipv4/udp.c                                    |   15 ++--
 net/ipv6/inet6_connection_sock.c                  |    2 +-
 net/ipv6/ipv6_sockglue.c                          |    2 +-
 net/ipv6/ndisc.c                                  |    2 +-
 net/ipv6/netfilter/Kconfig                        |    1 -
 net/ipv6/route.c                                  |   21 +++--
 net/ipv6/tcp_ipv6.c                               |   13 ++-
 net/ipv6/udp.c                                    |   15 ++--
 net/l2tp/l2tp_core.c                              |    2 +-
 net/mac80211/agg-tx.c                             |   42 +++++++-
 net/mac80211/debugfs_sta.c                        |    4 +-
 net/mac80211/status.c                             |    8 +-
 net/netfilter/Kconfig                             |    2 -
 net/netfilter/ipset/ip_set_hash_ipport.c          |    2 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c        |    2 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c       |    2 +-
 net/netfilter/nf_conntrack_ecache.c               |   37 ++++----
 net/netfilter/nf_conntrack_netlink.c              |   73 ++++++++++----
 net/netlabel/netlabel_kapi.c                      |   26 +++--
 net/sched/sch_red.c                               |    4 +-
 net/sched/sch_teql.c                              |   31 ++++--
 net/sctp/auth.c                                   |    2 +-
 net/unix/af_unix.c                                |    4 +
 net/wireless/nl80211.c                            |    4 +-
 net/wireless/reg.c                                |    4 +
 net/xfrm/xfrm_policy.c                            |   10 +-
 78 files changed, 591 insertions(+), 281 deletions(-)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
