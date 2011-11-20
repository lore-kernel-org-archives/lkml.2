Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1KTUdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 15:33:21 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54816 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1KTUdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 15:33:19 -0500
Date: Sun, 20 Nov 2011 15:33:14 -0500 (EST)
Message-Id: <20111120.153314.1776640087722636315.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 20 Nov 2011 12:33:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAKKXSke021020


It's been about two weeks since the last batch of networking fixes.

The majority is driver stuff, as is usually the case.

Some small corrections here and there for the drivers/net/
rearrangement.  And then the usual collection of fixes for core crashes
and misbehaviors.

1) Kill references to removed NET_ETHERNET kconfig variable, this was removed
   during Jeff Kirsher's drivers/net/ rearrangement during this merge window.

2) Revert L2CAP connection establishment change as it causes regressions,
   from Arek Lichwa.

3) Bluetooth's l2cap_set_timer() expects timeouts in miliseconds, but callers
   were not adjusted correctly.  Fix from Andrzej Kaczmarek.

4) pm_schedule_suspend() in r8169 needs an increased delay parameter in order
   to handle all cases properly, from Hayes Wang.

5) IPV6 must drop all packets using a multicast source address, fix from
   Brian Haley.

6) NET_IP_ALIGN is not a fixed vlaue, but the smsc75xx USB driver treated it
   as such.  It wants to use a fixed value of '2' so create and use a local
   macro in this driver to achieve that.  From Nico Erfurth.

7) l2tp_udp_recv_core() needs to sample skb->data after any potential header
   reallocation, otherwise we could be referencing free'd up data.  Fix
   from Eric Dumazet.

8) Don't accidently report a negative PMTU expire time in rt_fill_info(), fix
   from Steffen Klassert.

9) Wireless connection monitor can race with suspend, cancel the monitor work
   earlier in STA quiesce to avoid the problem.  Fix from Johannes Berg.

10) TEMAC driver enables interrupts before the chip is fully programmed and
    ready, fix from Ricardo Ribalda.

11) IPSEC AH code doesn't propagate error codes correctly, breaking things
    when using async crypto hashing.  Fixes from Nick Bowler.

12) Fix crash when using RF kill to disable the radio in iwlwifi, from
    Emmanuel Grumbach.

13) ipv6 tunnel driver doesn't record the right device name in it's
    parameters due to how the driver now makes use of register_netdevice()
    to take care of what explicit calls to dev_alloc_name() use to do.
    Fix by copying out the name at a later point in time, from Josh Boyer.

14) Bridge needs to take ->multicast_lock with softirq disabled in order
    to avoid deadlocks, fix from Andrey Vagin.

15) IPV6 has a completely seperate type-of-service value it maintains, so we
    need to report this using a seperate netlink attribute alongsize ipv4's TOS
    in the socket dumping code.  Fix from Maciej ≈ªenczyowski.

16) Missing includes lead to compiler error of MIPS lantiq driver.
    From John Crispin.

17) A set of bug fixes to the long maligned and not well maintained ASIX
    driver from Grant Grundler.  The good news is that the vendor is working
    together with Grant and others to get this driver back into well-maintained
    shape.

18) The "missing bh_unlock_sock()" fix in tcp_v4_syn_recv_sock() was not
    complete, timers could be running too so we have to kill those off as
    well otherwise we crash.  Fix from Eric Dumazet, tested by Simon Kirby
    who could reproduce these timer crashes.

19) Partial checksums aren't adjusted corrected after pulling the ipv6
    multicast headers in the bridging code.  Fix from Stephen Hemminger
    and tested by Martin Volf.

20) r6040 uses "&&" instead of "&" in bitwise test, fix from Florian Fainelli.

21) SKY2 bug fixes from Stephen Hemminger, in particular failed shutdowns should
    be fixed now.

22) stmmac timeout loop depends upon the time it takes readl() to occur, use
    a proper mdelay() instead.  Fix from Francesco Virlinzi.

23) stmmac cannot take the priv->lock in stmmac_ioctl()'s PHY layer calls,
    because those sleep.  Thankfully the priv->lock isn't actually needed
    here, so simply stop taking it.  Fix from Srinivas Kandagatla.

24) f_phonet driver appends page to the wrong SKB fragment slot, fix from
    R√©mi Denis-Courmont.

25) ICMP redirect in ipv4 were not propagating properly into all existing
    routing cache entries.  Flavio Leitner earlier tried to cure this problem
    but his fix turned out to be insufficient.  From Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit a767835f6dc85277e40fbfe69a29c18817d6c00b:

  Merge branch 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging (2011-11-19 10:56:01 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

Amitkumar Karwar (1):
      mwifiex: fix association issue with AP configured in hidden SSID mode

Andrey Vagin (1):
      bridge: Fix potential deadlock on br->multicast_lock

Andrzej Kaczmarek (1):
      Bluetooth: Use miliseconds for L2CAP channel timeouts

Arek Lichwa (1):
      Bluetooth: Revert: Fix L2CAP connection establishment

Arend van Spriel (1):
      brcm80211: smac: eliminate a null pointer dereference in dma.c

Brian Haley (1):
      ipv6: drop packets when source address is multicast

Christian Borntraeger (1):
      qeth: remove WARN_ON leftover

David S. Miller (4):
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless
      net: Fix references to deleted NET_ETHERNET Kconfig setting.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless

Dmitry Kravkov (1):
      bnx2x: cache-in compressed fw image

Einar Lueck (1):
      qeth: Reduce CPU consumption through less SIGA-r calls

Eliad Peller (1):
      mac80211: use min rate as basic rate for buggy APs

Emmanuel Grumbach (1):
      iwlwifi: avoid a panic when unloading the module with RF Kill

Eric Dumazet (5):
      l2tp: fix l2tp_udp_recv_core()
      net: min_pmtu default is 552
      tcp: clear xmit timers in tcp_v4_syn_recv_sock()
      ping: dont increment ICMP_MIB_INERRORS
      ipv4: fix redirect handling

Eyal Shapira (1):
      wl12xx: fix wl12xx_scan_sched_scan_ssid_list() check that all given ssids are in filters

Feng King (1):
      tcp: Fix comments for Nagle algorithm

Florian Fainelli (1):
      r6040: fix check against MCRO_HASHEN bit in r6040_multicast_list

Francesco Virlinzi (2):
      stmmac: use mdelay on timeout of sw reset
      stmmac: fix pm functions avoiding sleep on spinlock

Frank Blaschka (1):
      qeth: l3 fix rcu splat in xmit

Gertjan van Wingerde (2):
      rt2x00: Add USB device ID of Buffalo WLI-UC-GNHP.
      rt2x00: Fix sleep-while-atomic bug in powersaving code.

Giuseppe CAVALLARO (1):
      stmmac: parameters auto-tuning through HW cap reg

Grant Grundler (5):
      net-next:asix:PHY_MODE_RTL8211CL should be 0xC
      net-next:asix:poll in asix_get_phyid in case phy not ready
      net-next:asix: reduce AX88772 init time by about 2 seconds
      net-next:asix: V2 more fixes for ax88178 phy init sequence
      net-next:asix: V2 Update VERSION

Helmut Schaa (1):
      ath: Fix NULL ptr dereference in ath_reg_apply_world_flags

Janusz.Dziedzic@tieto.com (1):
      mac80211: uAPSD - fix IEEE80211_FCTL_MOREDATA bit setting

Jean-Christophe PLAGNIOL-VILLARD (1):
      net/cadence: enable by default NET_ATMEL

Jesper Juhl (4):
      net, wireless, mwifiex: Fix mem leak in mwifiex_update_curr_bss_params()
      net/packet: remove dead code and unneeded variable from prb_setup_retire_blk_timer()
      net/packet: Revert incorrect dead-code changes to prb_setup_retire_blk_timer
      Net, libertas: Resolve memory leak in if_spi_host_to_card()

Joe Perches (1):
      pch_gbe: Move #include of module.h

Johannes Berg (7):
      nl80211: fix HT capability attribute validation
      cfg80211: allow setting TXQ parameters only in AP mode
      cfg80211: fix cmp_ies
      cfg80211: fix missing kernel-doc
      mac80211: fix NULL dereference in radiotap code
      mac80211: fix bug in ieee80211_build_probe_req
      mac80211: fix race between connection monitor & suspend

John Crispin (1):
      NET: MIPS: lantiq: fix etop compile error

John W. Linville (4):
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth
      Merge branch 'master' of ssh://ra.kernel.org/.../linville/wireless into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Josh Boyer (1):
      ip6_tunnel: copy parms.name after register_netdevice

Li Wei (1):
      ipv4: fix for ip_options_rcv_srr() daddr update.

Luis R. Rodriguez (1):
      cfg80211: fix bug on regulatory core exit on access to last_request

Maciej ≈ªenczykowski (1):
      net-netlink: Add a new attribute to expose TCLASS values via netlink

Mark Kamichoff (1):
      net/usb: Misc. fixes for the LG-VL600 LTE USB modem

Nick Bowler (3):
      ah: Correctly pass error codes in ahash output callback.
      ah: Read nexthdr value before overwriting it in ahash input callback.
      ah: Don't return NET_XMIT_DROP on input.

Nico Erfurth (1):
      Fix incorrect usage of NET_IP_ALIGN

Paul Bolle (2):
      net: drivers/net/hippi/Kconfig should be sourced
      rds: drop "select LLIST"

Rafa≈Ç Mi≈Çecki (2):
      b43: fill ctl1 word on all newer PHYs, fix PHY errors
      b43: HT-PHY: report signal to mac80211

Ricardo Ribalda (2):
      net/temac: FIX segfault when process old irqs
      net/ll_temac: FIX : Wait for indirect wait to end

Robert Marklund (1):
      net/smsc911x: Always wait for the chip to be ready

R√©mi Denis-Courmont (1):
      f_phonet: fix page offset of first received fragment

Srinivas Kandagatla (2):
      stmmac: fix advertising 1000Base capabilties for non GMII iface
      stmmac: remove spin_lock in stmmac_ioctl.

Steffen Klassert (1):
      ipv4: Fix inetpeer expire time information

Stephen Hemminger (1):
      MAINTAINERS: change email address for shemminger

Steven Miao (1):
      wireless: libertas: fix unaligned le64 accesses

Ursula Braun (2):
      qeth: return with -EPERM if sniffing is not enabled
      netiucv: reinsert dev_alloc_name for device naming

Veaceslav Falico (1):
      bonding: Don't allow mode change via sysfs with slaves present

Wen-chien Jesse Sung (1):
      Bluetooth: Add support for Broadcom BCM20702A0

Yevgeny Petrilin (1):
      mlx4_en: Remove FCS bytes from packet length.

david decotigny (1):
      forcedeth: fix stats on hardware without extended stats support

hayeswang (1):
      r8169: increase the delay parameter of pm_schedule_suspend

oftedal (1):
      sunhme: Allow usage on SBI based SBus systems

stephen hemminger (9):
      bridge: correct IPv6 checksum after pull
      sky2: fix hang on shutdown (and other irq issues)
      sky2: pci posting issues
      sky2: rename up/down functions
      sky2: reduce default Tx ring size
      sky2: used fixed RSS key
      sky2: version 1.30
      sky2: enforce minimum ring size
      sky2: fix hang in napi_disable

 Documentation/networking/ip-sysctl.txt             |    2 +-
 MAINTAINERS                                        |    6 +-
 arch/cris/arch-v10/drivers/Kconfig                 |    2 +-
 arch/cris/arch-v32/drivers/Kconfig                 |    2 +-
 drivers/bluetooth/btusb.c                          |    3 +
 drivers/net/Kconfig                                |    2 +
 drivers/net/bonding/bond_sysfs.c                   |    7 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   50 +++++----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c     |   15 +--
 drivers/net/ethernet/cadence/Kconfig               |    1 +
 drivers/net/ethernet/lantiq_etop.c                 |    2 +
 drivers/net/ethernet/marvell/sky2.c                |  106 +++++++++++------
 drivers/net/ethernet/marvell/sky2.h                |    1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    6 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |    1 +
 drivers/net/ethernet/nvidia/forcedeth.c            |   36 +++++--
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c  |    2 +-
 drivers/net/ethernet/rdc/r6040.c                   |    2 +-
 drivers/net/ethernet/realtek/r8169.c               |    2 +-
 drivers/net/ethernet/smsc/smsc911x.c               |   12 ++
 .../net/ethernet/stmicro/stmmac/dwmac1000_dma.c    |    3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c |    3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |    6 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  117 ++++++++++++-------
 drivers/net/ethernet/sun/sunhme.c                  |    2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |    7 +-
 drivers/net/hippi/Kconfig                          |    2 +-
 drivers/net/usb/asix.c                             |   68 +++++++++---
 drivers/net/usb/cdc_ether.c                        |    2 +-
 drivers/net/usb/lg-vl600.c                         |   25 ++---
 drivers/net/usb/smsc75xx.c                         |    7 +-
 drivers/net/wireless/ath/regd.c                    |    2 +
 drivers/net/wireless/b43/xmit.c                    |   15 ++-
 drivers/net/wireless/b43/xmit.h                    |   16 +++-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |    5 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      |   33 +++---
 drivers/net/wireless/libertas/cfg.c                |    2 +-
 drivers/net/wireless/libertas/if_spi.c             |    1 +
 drivers/net/wireless/mwifiex/scan.c                |    9 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h               |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   22 ++++-
 drivers/net/wireless/wl12xx/scan.c                 |    2 +-
 drivers/s390/net/Kconfig                           |    2 +-
 drivers/s390/net/lcs.c                             |    6 +-
 drivers/s390/net/netiucv.c                         |    2 +
 drivers/s390/net/qeth_core.h                       |    3 +-
 drivers/s390/net/qeth_core_main.c                  |    1 -
 drivers/s390/net/qeth_l3_main.c                    |    7 +
 drivers/s390/net/qeth_l3_sys.c                     |    4 +-
 drivers/usb/gadget/f_phonet.c                      |    2 +-
 include/linux/inet_diag.h                          |    3 +-
 include/net/bluetooth/l2cap.h                      |    7 +-
 include/net/cfg80211.h                             |    4 +
 net/bluetooth/hci_conn.c                           |    2 +-
 net/bluetooth/l2cap_core.c                         |   16 ++--
 net/bridge/br_multicast.c                          |    6 +-
 net/ipv4/ah4.c                                     |    8 +-
 net/ipv4/inet_diag.c                               |    4 +-
 net/ipv4/ip_options.c                              |    1 +
 net/ipv4/ping.c                                    |    2 -
 net/ipv4/route.c                                   |  120 +++++++++++---------
 net/ipv4/tcp_ipv4.c                                |    1 +
 net/ipv4/tcp_output.c                              |    2 +-
 net/ipv6/ah6.c                                     |    8 +-
 net/ipv6/ip6_input.c                               |    8 ++
 net/ipv6/ip6_tunnel.c                              |    8 +-
 net/l2tp/l2tp_core.c                               |    8 +-
 net/mac80211/mlme.c                                |   21 ++++-
 net/mac80211/rx.c                                  |    9 +-
 net/mac80211/sta_info.c                            |    8 +-
 net/mac80211/util.c                                |    4 +
 net/rds/Kconfig                                    |    1 -
 net/wireless/nl80211.c                             |    9 +-
 net/wireless/reg.c                                 |    3 +
 net/wireless/scan.c                                |   13 ++-
 77 files changed, 604 insertions(+), 312 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
