Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1ECASr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:18:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42173
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402Ab1ECASp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:18:45 -0400
Date: Mon, 02 May 2011 17:18:12 -0700 (PDT)
Message-Id: <20110502.171812.232761473.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p430J5Sf022212


The commit count here is not as low as I would have liked, but it is the
usual smattering of one-liners fixing problems people are actually
running into.  Considering the fact that the last networking pull
request was nearly 2 weeks ago, the hit count isn't that bad.

Along with the straight-out fixes, there are a few reverts for changes
that caused clear regressions.

Anyways:

1) Revert veth change, breaks configuration of veth devices, from Jiri
   Pirko.

2) WoL by default isn't done properly in tg3 driver, from Rafael
   J. Wysocki.

3) fs_enet driver doesn't configure multicast into the chip properly,
   from Andrea Galbusera.

4) Fix QoS config send halting TX in iwlwifi, from Daniel Halperin.

5) atl1c manages async work events using non-atomic bit field, use
   atomic bitops to fix these races, from Tim Gardner.

6) Revert bridging change which broke 802.3ad bonding inside of
   bridge.

7) Removing a net driver can wedge in netconsole due to recursive
   locking, fix from Neil Horman.

8) bnx2x blindly dereferences packets as if they were all TCP,
   fix to check protocol type properly and handle UDP correctly
   as well.  From Eric Dumazet and Vladislav Zolotarov.

9) Fix r8169 to not request firmware before userspace is even
   present, from Francois Romieu.

10) Blackhole routes need to provide ->cow_metrics() op otherwise
    we OOPS, from Held Benhard.

11) IPSEC replay window handling fixes from Steffen Klassert.

12) usbnet can wedge on resume because a pending interrupt URB
    gets lost, resubmit it on resume.  From Paul Stewart.

13) Pending timer on remove results in OOPS in bnx2 driver, fix
    from Neil Horman.

14) ftmac100 does usleep_range() in non-sleepable contexts, fix
    to use udelay() for now.  From Adam Jaremko.

15) AF_UNIX sockets use a dummy packet send in order to implement
    connect() and accept().  We want to completely ignore these
    pseudo-packets in recvmsg() otherwise we can OOPS.  Fix
    from Eric W. Biederman.

16) Every net namespace creation emits an annoying log message from
    the fib_trie code, kill it.  From Alexey Dobriyan.

17) Invalid ioctl commands should emit -ENOTTY not -EINVAL.  From
    Lifeng Sun.

18) smsc95xx driver checks BMCR register bit improperly, it's
    actually using a register address (which is zero and thus
    the test never passes) :-)  Sharp eyed fix from Rabin Vincent.

19) Calls to register_net_sysctl_table() should be consistently
    paired with unregister_net_sysctl_table().  Fix broken cases,
    from Lucian Adrian Grijincu.

20) RAW CAN socket release can OOPS due to missing 'sk' check, from
    Oliver Hartkopp.

    The BCM CAN code has an identical bug, also fixed here, as
    was originally reported by Dave Jones.

    These bugs were uncovered thanks to Dave's syscall stresser.

21) SKB use after free fixes in iwlwifi and iwl4965, from Stanislaw
    Gruszka.

22) udp6_ufo_fragment() mis-calculates SKB headroom, from Shan Wei.

23) A conversion of how the RTAX_HOPLIMIT mertric is handled in ipv6
    missed one case, resulting in addrconf routes always using
    "255" as the hop limit.  Fix from Thomas Egerer.

24) Missing counter bump in be2net driver results in temperature
    sense happening way too often, from Ivan Vecera.

25) agg_device_up() in the bonding code uses the wrong method to find
    the aggregator of the bond, it should use agg->lag_ports->slave
    instead of agg->slave.  Fix from Jiri Bohac.

26) Bluetooth HCI connect code does one refcount grab too many,
    fix from Ville Tervo.

Please pull, thanks a lot!

The following changes since commit adadfe48df3858c3c1ba52963502f38885ab2f3c:

  Merge branch 'for-linus' of git://git.infradead.org/ubifs-2.6 (2011-05-02 12:17:29 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Adam Jaremko (1):
      net: ftmac100: fix scheduling while atomic during PHY link status change

Alexey Dobriyan (1):
      ipv4: don't spam dmesg with "Using LC-trie" messages

Andrea Galbusera (1):
      powerpc: Fix multicast problem in fs_enet driver

Breno Leitao (1):
      ehea: Fix a DLPAR bug on ehea_rereg_mrs().

Dan Williams (1):
      usbnet: add support for some Huawei modems with cdc-ether ports

Daniel Halperin (1):
      iwlwifi: fix frame injection for HT channels

Dave Jones (1):
      can: Add missing socket check in can/bcm release.

David S. Miller (4):
      Revert "bridge: Forward reserved group addresses if !STP"
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'davem.r8169' of git://git.kernel.org/.../romieu/netdev-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

Eric W. Biederman (1):
      af_unix: Only allow recv on connected seqpacket sockets.

Felix Fietkau (1):
      ath9k: fix the return value of ath_stoprecv

Fran√ßois Romieu (1):
      r8169: don't request firmware when there's no userspace.

Hans Petter Selasky (1):
      cdc_ncm: fix short packet issue on some devices

Held Bernhard (1):
      net: provide cow_metrics() methods to blackhole dst_ops

Ivan Vecera (1):
      be2net: increment work_counter in be_worker

Jiri Bohac (1):
      bonding: 802.3ad - fix agg_device_up

Jiri Pirko (1):
      Revert: veth: remove unneeded ifname code from veth_newlink()

Joe Perches (1):
      amd8111e: trivial typo spelling: Negotitate -> Negotiate

Johannes Berg (1):
      mac80211: fix SMPS debugfs locking

John W. Linville (1):
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-2.6

Lifeng Sun (1):
      networking: inappropriate ioctl operation should return ENOTTY

Lucian Adrian Grijincu (1):
      sysctl: net: call unregister_net_sysctl_table where needed

Luiz Augusto von Dentz (1):
      Bluetooth: fix shutdown on SCO sockets

Neil Horman (2):
      netconsole: fix deadlock when removing net driver that netconsole is using (v2)
      bnx2: cancel timer on device removal

Oliver Hartkopp (1):
      can: add missing socket check in can/raw release

Oliver Neukum (1):
      usbnet: Transfer of maintainership

Paul Stewart (1):
      usbnet: Resubmit interrupt URB if device is open

Peter Korsgaard (1):
      dsa/mv88e6131: fix unknown multicast/broadcast forwarding on mv88e6085

Rabin Vincent (1):
      smsc95xx: fix reset check

Rafael J. Wysocki (1):
      tg3: Fix failure to enable WoL by default when possible

Rafa≈Ç Mi≈Çecki (1):
      b43: trivial: update module info about ucode16_mimo firmware

Ruiyi Zhang (1):
      Bluetooth: Only keeping SAR bits when retransmitting one frame.

Shan Wei (1):
      ipv6: udp: fix the wrong headroom check

Stanislaw Gruszka (5):
      iwlwifi: fix skb usage after free
      iwl4965: fix skb usage after free
      iwl4965: fix "TX Power requested while scanning"
      iwlagn: fix "Received BA when not expected"
      iwl4965: fix "Received BA when not expected"

Steffen Klassert (3):
      xfrm: Fix replay window size calculation on initialization
      esp6: Fix scatterlist initialization
      xfrm: Check for the new replay implementation if an esn state is inserted

Thomas Egerer (1):
      ipv6: Remove hoplimit initialization to -1

Tim Gardner (1):
      atl1c: Fix work event interrupt/task races

Ville Tervo (1):
      Bluetooth: Fix refcount balance for hci connection

Vinicius Costa Gomes (1):
      Bluetooth: Fix keeping the command timer running

Vladislav Zolotarov (1):
      bnx2x: fix UDP csum offload

Wey-Yi Guy (1):
      iwlegacy: led stay solid on when no traffic

artpol (1):
      mii: add support of pause frames in mii_get_an

 MAINTAINERS                                  |    2 +-
 arch/powerpc/include/asm/8xx_immap.h         |    4 +-
 drivers/net/amd8111e.c                       |    2 +-
 drivers/net/atl1c/atl1c.h                    |    6 +-
 drivers/net/atl1c/atl1c_main.c               |   14 ++---
 drivers/net/benet/be_main.c                  |    1 +
 drivers/net/bnx2.c                           |    2 +
 drivers/net/bnx2x/bnx2x_cmn.c                |   34 ++++++---
 drivers/net/bonding/bond_3ad.c               |    7 ++-
 drivers/net/ehea/ehea_main.c                 |    9 ++-
 drivers/net/fs_enet/mac-fec.c                |    8 +-
 drivers/net/ftmac100.c                       |    8 +-
 drivers/net/mii.c                            |    4 +
 drivers/net/netconsole.c                     |    8 ++
 drivers/net/r8169.c                          |   99 ++++++++++++++++++-------
 drivers/net/tg3.c                            |    8 ++-
 drivers/net/usb/cdc_ether.c                  |   14 +++-
 drivers/net/usb/cdc_ncm.c                    |    4 +-
 drivers/net/usb/smsc95xx.c                   |    2 +-
 drivers/net/usb/usbnet.c                     |    8 ++
 drivers/net/veth.c                           |   12 +++
 drivers/net/wireless/ath/ath9k/recv.c        |    2 +-
 drivers/net/wireless/b43/main.c              |    1 +
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c  |   28 +++++---
 drivers/net/wireless/iwlegacy/iwl-led.c      |   20 +++++-
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    7 +--
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   27 +++++---
 include/linux/usb/usbnet.h                   |    1 +
 net/bluetooth/hci_core.c                     |    5 +-
 net/bluetooth/hci_event.c                    |    2 -
 net/bluetooth/l2cap_core.c                   |    1 +
 net/bluetooth/sco.c                          |    9 +++
 net/bridge/br_input.c                        |    2 +-
 net/can/bcm.c                                |    7 ++-
 net/can/raw.c                                |    7 ++-
 net/core/dev.c                               |    6 +-
 net/dsa/Kconfig                              |    4 +-
 net/dsa/mv88e6131.c                          |   26 ++++++--
 net/ipv4/devinet.c                           |    2 +-
 net/ipv4/fib_trie.c                          |    3 -
 net/ipv4/route.c                             |    7 ++
 net/ipv6/addrconf.c                          |    2 +-
 net/ipv6/esp6.c                              |    2 +-
 net/ipv6/route.c                             |    8 ++-
 net/ipv6/udp.c                               |    2 +-
 net/mac80211/cfg.c                           |    2 +
 net/mac80211/debugfs_netdev.c                |    4 +-
 net/unix/af_unix.c                           |   16 ++++-
 net/xfrm/xfrm_replay.c                       |    2 +-
 net/xfrm/xfrm_user.c                         |    3 +
 51 files changed, 338 insertions(+), 134 deletions(-)
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
