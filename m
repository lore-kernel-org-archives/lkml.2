Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2EUIrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:47:18 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35984 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab2EUIrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:47:03 -0400
Date: Mon, 21 May 2012 04:46:55 -0400 (EDT)
Message-Id: <20120521.044655.2240789432987862555.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 21 May 2012 01:47:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4L8lXr7008967


Major highlights:

1) Get rid of the error prone NLA_PUT*() macros that used an
   embedded goto.

2) Kill off the token-ring and MCA networking drivers, from
   Paul Gortmaker.

3) Reduce high-order allocations made by datagram AF_UNIX sockets,
   from Eric Dumazet.

4) Add PTP hardware clock support to IGB and IXGBE, from Richard
   Cochran and Jacob Keller.

5) Allow users to query timestamping capabilities of a card via
   ethtool, from Richard Cochran.

6) Add loadbalance mode to the teaming driver, from Jiri Pirko.
   Part of this is that we can now have BPF filters not attached
   to sockets, and the loadbalancing function is calculated
   using one.

7) Francois Romieu went through the network drivers removing
   gratuitous uses of netdev->base_addr, perhaps some day we
   can remove it completely but it's used for ISA probing
   still.

8) Add a BPF JIT for sparc.  I know, who cares, right? :-)

9) Move networking sysctl registry away from using the compatability
   mode interfaces in the sysctl code.  From Eric W. Biederman.

10) Pavel Emelyanov added a way to save and restore TCP socket
    state via TCP_REPAIR, TCP_REPAIR_QUEUE, and TCP_QUEUE_SEQ
    socket options as well as a way to forcefully bind a socket
    to a port via the sk->sk_reuse value SK_FORCE_REUSE.  There
    is also a TCP_REPAIR_OPTIONS which allows to reinstante the
    TCP options enabled on the connection.

11) Several enhancements from Eric Dumazet that, in particular,
    can enhance splice performance on TCP sockets significantly.

    a) Reset the offset of the per-socket sendmsg page when
       we know we're the only use of the page in linear_to_page().

    b) Add facilities such that skb->data can be backed a page rather
       than SLAB kmalloc'd memory.  In particular devices which were
       receiving into linear RX buffers can now end up providing paged
       data.

       The big result is that code like splice and GRO do not have to
       copy any more.

12) Allow a pure sender to more gracefully handle ACK backlogs in
    TCP.  What can happen at high rates is that the sender hasn't
    grown his receive buffer limits at all (he's not receiving data
    so really doesn't need to), but the non-data ACKs consume
    receive buffer space.

    sk_add_backlog() is too aggressive in dropping frames in this
    case, so relax it's requirements by using the receive buffer
    plus the send buffer limit as the backlog limit instead of just
    the former.

    Also from Eric Dumazet.

13) Add ipv6 support to L2TP, from Benjamin LaHaise, James Chapman,
    and Chris Elston.

14) Implement TCP early retransmit (RFC 5827), from Yuchung Cheng.
    Basically, we can start fast retransmit before hiting the
    dupack threshold under certain conditions.

15) New CODEL active queue management packet scheduler, from
    Eric Dumazet based upon initial work by Dave Taht.

    Basically, the big feature is that packets are dropped (or
    ECN bits are set) based upon how long packets live in the
    queue, rather than the queue length (which is what RED uses).

Please pull, thanks a lot!

The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:

  Linux 3.4 (2012-05-20 15:29:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to 74863948f925d9f3bb4e3d3a783e49e9c662d839:

  drivers/net/stmmac: seq_file fix memory leak (2012-05-21 03:37:56 -0400)

----------------------------------------------------------------
Aarthi Thiruvengadam (2):
      ath6kl: handle probe response from P2P device in P2P GO mode
      ath6kl: add debug log for AP MLME operations

Ajit Khaparde (4):
      be2net: fix ethtool get settings
      be2net: Ignore status of some ioctls during driver load
      be2net: fix speed displayed by ethtool on certain SKUs
      be2net: update the driver version

Akinobu Mita (1):
      ppp: use for_each_set_bit_from

Alan Cox (1):
      dummy: documentation is stale

Alex Copot (1):
      tcp: bind() use stronger condition for bind_conflict

Alexander Duyck (18):
      net: Stop decapitating clones that have a head_frag
      tcp: Fix truesize accounting in tcp_try_coalesce
      tcp: Move code related to head frag in tcp_try_coalesce
      tcp: move stats merge to the end of tcp_try_coalesce
      ixgbe: Fix use after free on module remove
      skb: Add skb_head_is_locked helper function
      ixgbe: Track instances of buffer available but no DMA resources present
      ixgbe: Reorder the ring to q_vector mapping to improve performance
      ixgbe: Make ixgbe_fc_autoneg return void and always set current_mode
      ixgbe: Use __free_pages instead of put_page to release pages
      ixgbe: Reorder link flow control functions in ixgbe_common.c
      ixgbe: Update link flow control to correctly handle multiple packet buffer DCB
      skb: Drop bad code from pskb_expand_head
      skb: Drop "fastpath" variable for skb_cloned check in pskb_expand_head
      skb: Add inline helper for getting the skb end offset from head
      ixgbe: Exit on error case in VF message processing
      ixgbe: Clean up priority based flow control
      ixgbe: Set Drop_EN bit when multiple Rx queues are present w/o flow control

Alexey I. Froloff (1):
      Treat ND option 31 as userland (DNSSL support)

Allan Stephens (25):
      tipc: introduce publication lists struct
      tipc: Factor out name publication code to a separate function
      tipc: Separate cluster-scope and zone-scope names into distinct lists
      tipc: Update node-scope publications when network address is assigned
      tipc: Don't record failed publication attempt as a success
      tipc: Add routines for safe checking of node's network address
      tipc: Ensure network address change doesn't impact name table updates
      tipc: Optimize re-initialization of port message header templates
      tipc: Ensure network address change doesn't impact new port
      tipc: delete duplicate peerport/peernode helper functions
      tipc: Ensure network address change doesn't impact local connections
      tipc: take lock while updating node network address
      tipc: properly handle off-node send requests with invalid addr
      tipc: handle <0.0.0> as an alias for this node on outgoing msgs
      tipc: Ensure network address change doesn't impact rejected message
      tipc: Ensure network address change doesn't impact configuration service
      tipc: Optimize re-initialization of configuration service
      tipc: Optimize initialization of configuration service
      tipc: Optimize termination of configuration service
      tipc: Enhance re-initialization of network topology service
      tipc: Optimize initialization of network topology service
      tipc: remove redundant memset and stale comment from subscr.c
      tipc: Create helper routine to delete unused name sequence structure
      tipc: Enhance error checking of published names
      tipc: Reject payload messages with invalid message type

Amir Vadai (9):
      net/mlx4_en: Force user priority by QP attribute
      net/mlx4_core: set port QoS attributes
      net/mlx4_en: DCB QoS support
      net/mlx4_en: sk_prio <=> UP for untagged traffic
      net/route: export symbol ip_tos2prio
      IB/rdma_cm: TOS <=> UP mapping for IBoE
      net/dcb: Add an optional max rate attribute
      net/mlx4_en: Set max rate-limit for a TC
      net/mlx4_en: num cores tx rings for every UP

Amit Beka (1):
      iwlwifi: added HBUS_TARG_TEST_REG

Amitkumar Karwar (12):
      mwifiex: update signal strength in mBm units
      mwifiex: add cfg80211 dump_station handler
      mwifiex: remove redundant signal handling code
      mwifiex: support STATION_INFO_SIGNAL_AVG
      mwifiex: add set_cqm_rssi_config handler support
      mwifiex: set default regulatory domain
      mwifiex: display correct country information in debugfs "info"
      mwifiex: use asynchronous firmware loading
      mwifiex: code cleanup in BSS handling
      mwifiex: corrections in timestamp related code
      mwifiex: add support for Marvell USB8797 chipset
      mwifiex: fix static checker warnings

Andreas Eversberg (7):
      mISDN: Fix NULL pointer bug in if-condition of mISDN_dsp
      mISDN: Fixed hardware bridging/conference check routine of mISDN_dsp.ko.
      mISDN: Fixed false interruption of audio during bridging change.
      mISDN: Using FLG_ACTIVE flag to determine if layer 1 is active or not.
      mISDN: Rework of LED status display for HFC-4S/8S/E1 cards.
      mISDN: Added support for fragmentation of E1 interfaces of hfcmulti driver.
      mISDN: Added PH_* state info to tei manager.

Andreas Hartmann (1):
      rt2x00: Don't let mac80211 send a BAR when an AMPDU subframe fails

Andrei Emeltchenko (1):
      mac80211: Adds clean sdata helper

Andrew Bird (Sphere Systems) (4):
      net: cdc_ether: Add ZTE WWAN matches before generic Ethernet
      USB: qmi_wwan: Make forced int 4 whitelist generic
      USB: qmi_wwan: Add ZTE (Vodafone) K3765-Z
      USB: qmi_wwan: Add ZTE (Vodafone) K3520-Z

Andrew Victor (1):
      AT91: Remove fixed mapping for AT91RM9200 ethernet

Anisse Astier (4):
      rt2800: debugfs register access: BBP is 256 bytes big
      rt2800: add chipset revision RT5390R support
      rt2x00: debugfs support - allow a register to be empty
      rt2x00: Add debugfs access for rfcsr register

Antonio Quartulli (15):
      b43: claim support for IBSS RSN
      MAINTAINERS: add additional maintainer for net/batman-adv
      batman-adv: clean up Kconfig
      batman-adv: use ETH_ALEN instead of hardcoded numeric constants
      batman-adv: convert the tt_crc to network order
      batman-adv: remove duplicated line in comment
      batman-adv: use ETH_HLEN instead of sizeof(struct ethhdr)
      batman-adv: print OGM seq numbers as unsigned int
      batman-adv: skip the window protection test when the originator has no neighbours
      batman-adv: fix wrong dhcp option list browsing
      batman-adv: update copyright years
      batman-adv: add contributor name
      batman-adv: avoid skb_linearise() if not needed
      batman-adv: improve unicast packet (re)routing
      batman-adv: unset the TT_CLIENT_PENDING flag if the new local entry already exists

Arend van Spriel (5):
      brcm80211: fmac: make brcmf_net_attach() static
      brcm80211: fmac: remove primary mac address handling from brcmf_net_attach
      brcm80211: fmac: register primary net device with device mac address
      brcm80211: smac: do not use US as fallback regulatory hint
      brcm80211: smac: only provide valid regulatory hint

Arik Nemtsov (19):
      wlcore/wl12xx: create per-chip-family private storage
      wlcore/wl12xx: set the number of Tx descriptors per chip family
      wlcore/wl12xx: change GEM Tx-spare blocks per-vif
      wlcore/wl12xx: add hw op for calculating hw block count per packet
      wlcore/wl12xx: add hw op for setting blocks in hw_tx_desc
      wlcore/wl12xx: add hw op for setting frame length in tx_hw_desc
      wlcore/wl12xx: add global elements to convert hw-rates to standard rates
      wlcore: introduce Rx block-size alignment HW quirk
      wlcore/wl12xx: add hw op for getting rx buffer data alignment
      wlcore/wl12xx: add hw op for getting rx packet data length
      wlcore/wl12xx: split Tx completion to immediate/delayed
      wlcore/wl12xx: turn no-Tx-align quirk into Tx-align
      wlcore/wl12xx: add hw op for vif init
      wlcore/wl12xx: expand functionality of cmd_trigger HW op
      wlcore/wl12xx: add hw op to get rate-mask for AP-link in STA mode
      wlcore/wl12xx: set HT capabilities per chip-family
      wlcore: set max_rx_agg_subframes in mac80211 according to HT conf
      wlcore: add module param to prevent HW recovery
      wlcore/wl12xx: adapt FW status for multiple families

Arnd Bergmann (8):
      davinci_cpdma: export symbols used by other drivers
      drivers/net: add missing __devexit_p() annotations
      caif: include linux/io.h
      drivers/net: iwmc3200 depends on EXPERIMENTAL
      8390: select CRC32 support
      donauboe: replace excessive udelay with msleep
      sungem: use mdelay instead of udelay where necessary
      drivers/net: decouple ISA and ISA_DMA_API

Ashok Nagarajan (8):
      mac80211: Use mandatory rates as basic rates when starting mesh
      mac80211: Indicate basic rates when adding rate IEs
      mac80211: Modify sta_get_rates to give basic rates
      mac80211: Check basic rates when peering
      mac80211: Advertise HT protection mode in IEs
      mac80211: Implement HT mixed protection mode
      mac80211: Allow nonHT/HT peering in mesh
      {nl,cfg,mac}80211: Allow user to see/configure HT protection mode

Avinash Patil (1):
      mwifiex: add support for WPS2.0

Axel Lin (4):
      net/tokenring: use module_pci_driver
      net/wan: use module_pci_driver
      net/wireless: use module_pci_driver
      net/can: use module_pci_driver

Bala Shanmugam (2):
      ath6kl: Set background scan period.
      cfg80211: Validate legacy rateset.

Barak Witkowski (3):
      bnx2x: Added support for a new device - 57811
      bnx2x: add afex support
      bnx2x: Update driver version to 1.72.50-0

Ben Greear (13):
      net: Report dev->promiscuity in netlink reports.
      e1000: Support RX-ALL flag.
      mac80211: Add iface name when calling WARN-ON.
      ath9k: Add tx-failed counter.
      ath9k: Add more recv stats.
      ath9k: Use macro to decrease code when priting recv stats.
      ath9k: Gather and report IRQ sync_cause errors.
      mac80211: Support on-channel scan option.
      ath9k: Fix compile warnings when DEBUGFS is disabled.
      cfg80211: Add framework to support ethtool stats.
      mac80211: Support getting sta_info stats via ethtool.
      mac80211: Framework to get wifi-driver stats via ethtool.
      mac80211: Add more ethtools stats: survey, rates, etc

Ben Hutchings (5):
      ipw2200: Fix order of device registration
      ipw2100: Fix order of device registration
      sfc: Fix missing cleanup in failure path of efx_pci_probe()
      ethtool: Split ethtool_get_eeprom() to allow for additional EEPROM accessors
      sfc: Implement module EEPROM access for SFE4002 and SFN4112F

Benjamin LaHaise (4):
      net/ipv6/udp: UDP encapsulation: break backlog_rcv into __udpv6_queue_rcv_skb
      net/ipv6/udp: UDP encapsulation: move socket locking into udpv6_queue_rcv_skb()
      net/ipv6/udp: UDP encapsulation: introduce encap_rcv hook into IPv6
      net/l2tp: add support for L2TP over IPv6 UDP

Bing Zhao (1):
      mwifiex: fix typo in RSSI_HIGH event handling

Bj√∏rn Mork (2):
      net: of/phy: fix build error when phylib is built as a module
      net: qmi_wwan: Add Vodafone/Huawei K5005 support

Bruce Allan (16):
      e1000e: cleanup NAPI routine
      e1000e: cleanup indexed register arrays
      e1000e: update driver version number
      e1000e: cleanup remaining strings split across multiple lines
      e1000e: cleanup boolean logic
      e1000e: 82579 packet drop workaround
      e1000e: 82579 potential system hang on stress when ME enabled
      e1000e: workaround EEPROM configuration change on 82579
      e1000e: PHY initialization flow changes for 82577/8/9
      e1000e: fix .ndo_set_rx_mode for 82579
      e1000e: suggest a possible workaround to a device hang on 82577/8
      e1000e: cleanup long [read|write]_reg_locked PHY ops function pointers
      e1000e: initial support for i217
      e1000e: enable forced master/slave on 82577
      e1000e: increase version number
      e1000e: fix typo in definition of E1000_CTRL_EXT_FORCE_SMBUS

Carolyn Wyborny (3):
      igb: Update version to 3.4.7.
      igb: Add function and pointers for 82580 low power state settings.
      igb: Add Support for new i210/i211 devices.

Chris Boot (2):
      e1000e: Disable ASPM L1 on 82574
      e1000e: Remove special case for 82573/82574 ASPM L1 disablement

Chris Elston (4):
      l2tp: show IPv6 addresses in l2tp debugfs file
      l2tp: netlink api for l2tpv3 ipv6 unmanaged tunnels
      ipv6: Export ipv6 functions for use by other protocols
      l2tp: introduce L2TPv3 IP encapsulation support for IPv6

Christian Lamparter (1):
      p54: only unregister ieee80211_hw when it has been registered

Chun-Yeow Yeoh (3):
      mac80211: fix the sparse warnings on endian handling in RANN propagation
      mac80211: fix the RANN propagation issues
      mac80211: fix the assignment of PREQ's MAC address for Proactive RANN

Dan Carpenter (3):
      wireless: at76c50x: allocating too much data
      netfilter: xt_HMARK: potential NULL dereference in get_inner_hdr()
      isdn: remove duplicate NULL check

Daniel Baluta (2):
      ipv4: fix checkpatch errors
      can: fix sparse warning for cgw_list

Daniel Drake (6):
      libertas: Firmware loading simplifications
      libertas: harden-up exit paths
      libertas: add asynchronous firmware loading capability
      libertas SDIO: convert to asynchronous firmware loading
      libertas USB: convert to asynchronous firmware loading
      libertas CS: convert to asynchronous firmware loading

David Daney (4):
      netdev/of/phy: New function: of_mdio_find_bus().
      netdev/of/phy: Add MDIO bus multiplexer support.
      netdev/of/phy: Add MDIO bus multiplexer driven by GPIO lines.
      netdev/phy: Make get_phy_id() static and quit EXPORTing it.

David Riddoch (2):
      sfc: Fill RX rings completely full, rather than to 95% full
      sfc: By default refill RX rings as soon as space for a batch

David S. Miller (96):
      xfrm_user: Stop using NLA_PUT*().
      wireless: Stop using NLA_PUT*().
      pkt_sched: Stop using NLA_PUT*().
      phonet: Stop using NLA_PUT*().
      netlink: Add nla_put_be{16,32,64}() helpers.
      openvswitch: Stop using NLA_PUT*().
      nfc: Stop using NLA_PUT*().
      genetlink: Stop using NLA_PUT*().
      nfnetlink_queue: Stop using NLA_PUT*().
      nfnetlink_log: Stop using NLA_PUT*().
      nfnetlink_cttimeout: Stop using NLA_PUT*().
      nfnetlink_acct: Stop using NLA_PUT*().
      nf_conntrack_proto_udp{,lite}: Stop using NLA_PUT*().
      nf_conntrack_proto_tcp: Stop using NLA_PUT*().
      nf_conntrack_proto_sctp: Stop using NLA_PUT*().
      nf_conntrack_proto_gre: Stop using NLA_PUT*().
      nf_conntrack_proto_generic: Stop using NLA_PUT*().
      nf_conntrack_proto_dccp: Stop using NLA_PUT*().
      nf_conntrack_netlink: Stop using NLA_PUT*().
      nf_conntrack_core: Stop using NLA_PUT*().
      ipvs: Stop using NLA_PUT*().
      netlink: Add nla_put_net{16,32,64}() helpers.
      ipset: Stop using NLA_PUT*().
      l2tp: Stop using NLA_PUT*().
      dcbnl: Stop using NLA_PUT*().
      neighbour: Stop using NLA_PUT*().
      rtnetlink: Stop using NLA_PUT*().
      netlink: Add nla_put_le{16,32,64}() helpers.
      decnet: Stop using NLA_PUT*().
      crypto: Stop using NLA_PUT*().
      infiniband: Stop using NLA_PUT*().
      can: Stop using NLA_PUT*().
      enic: Stop using NLA_PUT*().
      macvlan: Stop using NLA_PUT*().
      team: Stop using NLA_PUT*().
      ipv6: Stop using NLA_PUT*().
      netfilter: ipv6: Stop using NLA_PUT*().
      ipv4: Stop using NLA_PUT*().
      netfilter: ipv4: Stop using NLA_PUT*().
      ieee802154: Stop using NLA_PUT*().
      fib_rules: Stop using NLA_PUT*().
      gen_stats: Stop using NLA_PUT*().
      caif: Stop using NLA_PUT*().
      bridge: Stop using NLA_PUT*().
      vlan: Stop using NLA_PUT*().
      ath6kl: Stop using NLA_PUT*().
      iwlwifi: Stop using NLA_PUT*().
      mac80211_hwsim: Stop using NLA_PUT*().
      wl12xx: Stop using NLA_PUT*().
      xfrm: Stop using NLA_PUT*().
      netlink: Delete all NLA_PUT*() macros.
      bfin: Fix build failure due to get_ts_info() changes.
      gianfar: Include linux/net_tstamp.h
      fealnx: Remove unused local label 'out' in netdev_open().
      wiznet: Fix Kconfig dependencies.
      Merge git://git.kernel.org/.../davem/net
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge git://git.kernel.org/.../davem/net
      rtnetlink: ops->get_tx_queue() cannot take a const 'tb'.
      bonding: Fixup get_tx_queue() op second arg type.
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      ipv6: Remove unused argument to addrconf_dad_start().
      Merge git://git.kernel.org/.../davem/net
      net: filter: Just In Time compiler for sparc
      Merge branch 'master' of git://gitorious.org/linux-can/linux-can-next
      net: filter: Fix some minor issues in sparc JIT.
      net: filter: Fix some more small issues in sparc JIT.
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'tipc_net-next' of git://git.kernel.org/.../paulg/linux
      tcp: Fix build warning after tcp_{v4,v6}_init_sock consolidation.
      net: Use bool and remove inline in skb_splice_bits() code.
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      l2tp: Add missing net/net/ip6_checksum.h include.
      Merge branch 'tipc_net-next' of git://git.kernel.org/.../paulg/linux
      net: Add missing linux/prefetch.h include to net/core/sock.c
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'vhost-net-next' of git://git.kernel.org/.../mst/vhost
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://1984.lsi.us.es/net-next
      Merge git://1984.lsi.us.es/net-next
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      xfrm: Convert several xfrm policy match functions to bool.
      Merge branch 'delete-tokenring' of git://git.kernel.org/.../paulg/linux
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      net: Remove netdevice ec_ptr, no longer used.
      ipx: Remove spurious NULL checking in ipx_ioctl().
      Merge git://git.kernel.org/.../davem/net

David Spinadel (10):
      iwlwifi: phy_db structure
      iwlwifi: set size of ucode section
      iwlwifi: remove double verification of ucode sections
      iwlwifi: phy db channel to tx power channel group
      iwlwifi: expose static methods for MVM use
      iwlwifi: Change disable calibration bit-set to enum
      iwlwifi: Added foreward declaration for iwl_cfg in op_mode
      iwlwifi: Remove inconsistent and redundant declaration
      iwlwifi: Remove inconsistent and redundant declaration
      iwlwifi: Added debugfs calib disabled write

David Ward (1):
      net/garp: fix GID rbtree ordering

David Woodhouse (1):
      pppoatm: Fix excessive queue bloat

Deepak SIKRI (5):
      stmmac: Define CSUM offload engine Types
      stmmac: sanitize the rx coe and add the type-1 csum (v2)
      stmmac: Define MDC clock selection macros
      stmmac: re-work the internal GMAC DMA platf parameters
      stmmac: Replace infinite loops by timeouts in mdio r/w

Djalal Harouni (1):
      drivers/net/stmmac: seq_file fix memory leak

Dmitry Kravkov (5):
      bnx2x: added support for working with one msix irq.
      bnx2x: change to the rss engine
      bnx2x: add missing parenthesis to prevent u32 overflow
      bnx2x: remove gro workaround
      bnx2x: fix handling single MSIX mode for 57710/57711

Dmitry Tarnyagin (2):
      caif: set traffic class for caif packets
      caif-hsi: robust frame aggregation for HSI

Don Fry (6):
      iwlwifi: move FW_ERROR to priv
      iwlwifi: split POWER_PMI status bit
      iwlwifi: complete STATUS_READY refactoring
      iwlwifi: move HCMD_ACTIVE to trans
      iwlwifi: move status definitions from iwl-shared
      iwlwifi: revert workaround to restore 1000 rx throughput

Don Skidmore (5):
      ixgbe: add I2C clock stretching
      ixgbe: add support functions to access thermal data
      ixgbe: add hwmon interface to export thermal data
      ixgbe: cleanup the hwmon function calls
      ixgbe: update version number

Dor Shaish (1):
      iwlwifi: Disabling calibrations variable

Eldad Zack (16):
      net/ipv6/sit.c: Checkpatch cleanup
      net/ipv6/addrconf_core.c: Checkpatch cleanup
      net/ipv6/datagram.c: Checkpatch cleanups
      net/ipv6/exthdrs.c: Checkpatch cleanups
      net/ipv6/exthdrs_core.c: Checkpatch cleanups
      net/ipv6/fib6_rules.c: Checkpatch cleanup
      net/ipv6/icmp.c: Checkpatch cleanups
      net/ipv6/addrconf.c: Checkpatch cleanups
      net/ipv6/ipv6_sockglue.c: Removed redundant extern
      net/ipv6/exthdrs.c: Strict PadN option checking
      net/ipv6/af_inet6.c: checkpatch cleanup
      netfilter: xt_CT: remove redundant header include
      ipv6: correct the ipv6 option name - Pad0 to Pad1
      net/ipv4/ipconfig: neaten __setup placement
      net/ipv4: replace simple_strtoul with kstrtoul
      ipv6/exthdrs: strict Pad1 and PadN check

Eliad Peller (2):
      wl12xx: set do_join on BSS_CHANGED_ASSOC
      wl12xx: free ap keys only in ap mode

Emil Tantilov (1):
      ixgbe: consolidate reporting of MSIX vectors into a single function

Emmanuel Grumbach (20):
      iwlwifi: remove uneeded include from iwl-pci.c
      iwlwifi: kill shrd->drv, driver points to transport
      iwlwifi: op_mode holds its pointer to the transport
      iwlwifi: op_mode holds its pointer to the config
      iwlwifi: driver holds its pointer to the config
      iwlwifi: transport holds its pointer to the config
      iwlwifi: driver holds its pointer to the transport
      iwlwifi: don't use shared for the logger any more
      iwlwifi: remove the shared area
      iwlwifi: remove unneeded includes
      iwlwifi: split between AGG_ON and AGG_STARTING
      iwlwifi: move iwl_rxon_context_id to user
      iwlwifi: make a static inline to read the RF kill register
      iwlwifi: first enable RF kill interrupt, then check register
      iwlwifi: enable RF kill interrupt in start_hw
      iwlwifi: check RF kill register when interrupts have been disabled
      iwlwifi: provide proper API to disable all interrupts
      iwlwifi: use IWL_* instead of dev_printk when possible
      iwlwifi: don't init trans->reg_lock from the op_mode
      cfg80211: fix BSS comparison

Eric Dumazet (71):
      af_unix: reduce high order page allocations
      net: lpc_eth: no need to reserve 8 extra bytes in rx skb
      net: remove k{un}map_skb_frag()
      udp: intoduce udp_encap_needed static_key
      tcp: RFC6298 supersedes RFC2988bis
      inet: makes syn_ack_timeout mandatory
      net: cleanup unsigned to unsigned int
      net: filter: remove unused cpu_off in sparc JIT
      ip6_tunnel: dont drop packet but consume it
      netlink: dont drop packet but consume it
      ipv6: tcp: dont drop packet but consume it
      packet: dont drop packet but consume it
      ipv6: dccp: dont drop packet but consume it
      net: dont drop packet but consume it
      net: gro: GRO_MERGED_FREE consumes packets
      ipv4: dont drop packet in defrag but consume it
      nf_bridge: remove holes in struct nf_bridge_info
      net: change big iov allocations
      net: allow better page reuse in splice(sock -> pipe)
      af_packet: packet_getsockopt() cleanup
      net: add a limit parameter to sk_add_backlog()
      tcp: sk_add_backlog() is too agressive for TCP
      tcp: introduce tcp_try_coalesce
      net: speedup skb_splice_bits()
      net: make spd_fill_page() linear argument a bool
      tcp: tcp_try_coalesce returns a boolean
      net: skb_can_coalesce returns a boolean
      af_netlink: cleanups
      af_netlink: drop_monitor/dropwatch friendly
      ipv6: call consume_skb() in frag/reassembly
      ipv6: RTAX_FEATURE_ALLFRAG causes inefficient TCP segment sizing
      net: cleanups in sock_setsockopt()
      net: allow skb->head to be a page fragment
      tg3: provide frags as skb head
      net: make GRO aware of skb->head_frag
      tcp: makes tcp_try_coalesce aware of skb->head_frag
      net: makes skb_splice_bits() aware of skb->head_frag
      bnx2x: remove some bloat
      net: add a prefetch in socket backlog processing
      net: skb_peek()/skb_peek_tail() cleanups
      netem: add ECN capability
      net: take care of cloned skbs in tcp_try_coalesce()
      net: implement tcp coalescing in tcp_queue_rcv()
      net: Fix truesize accounting in skb_gro_receive()
      net: sched: factorize code (qdisc_drop())
      tcp: be more strict before accepting ECN negociation
      netfilter: nf_conntrack: use this_cpu_inc()
      net_sched: update bstats in dequeue()
      codel: Controlled Delay AQM
      codel: use Newton method instead of sqrt() and divides
      fq_codel: Fair Queue Codel AQM
      codel: use u16 field instead of 31bits for rec_inv_sqrt
      fq_codel: should use qdisc backlog as threshold
      net: sock_flag() cleanup
      net: include/net/sock.h cleanup
      tcp: bool conversions
      net: netdev_alloc_skb() use build_skb()
      ip_frag: struct inet_frags match() method returns a bool
      ipv6: bool conversions phase1
      iwlwifi: dont pull too much payload in skb head
      net: introduce netdev_alloc_frag()
      ipv6: remove csummode in ip6_append_data()
      ipv6: ip6_fragment() should check CHECKSUM_PARTIAL
      ipv6: bool/const conversions phase2
      ppp: avoid false drop_monitor false positives
      net: napi_frags_skb() is static
      tg3: use netdev_alloc_frag() API
      ipv6: disable GSO on sockets hitting dst_allfrag
      net: introduce skb_try_coalesce()
      ipv4: use skb coalescing in defragmentation
      ipv6: use skb coalescing in reassembly

Eric Lapuyade (7):
      NFC: Export target lost function
      NFC: HCI support
      NFC: SHDLC implementation
      NFC: Add HCI documentation
      NFC: Fix next target_idx type and rename for clarity
      NFC: Changed target activated state logic
      NFC: Add Core support to generate tag lost event

Eric Leblond (1):
      netfilter: nf_ct_helper: allow to disable automatic helper assignment

Eric W. Biederman (21):
      net: Implement register_net_sysctl.
      net sysctl: Register an empty /proc/sys/net
      net sysctl: Initialize the network sysctls sooner to avoid problems.
      net: Kill register_sysctl_rotable
      net: Move all of the network sysctls without a namespace into init_net.
      net core: Remove unneded creation of an empty net/core sysctl directory
      net ipv6: Remove unneded registration of an empty net/ipv6/neigh
      net ipv4: Remove the unneeded registration of an empty net/ipv4/neigh
      net ax25: Simplify and cleanup the ax25 sysctl handling.
      net llc: Don't use sysctl tables with .child entries.
      net ipv6: Don't use sysctl tables with .child entries.
      net neighbour: Convert to use register_net_sysctl
      net decnet: Convert to use register_net_sysctl
      net ipv6: Convert addrconf to use register_net_sysctl
      net ipv4: Convert devinet to use register_net_sysctl
      net: Convert nf_conntrack_proto to use register_net_sysctl
      net: Convert all sysctl registrations to register_net_sysctl
      net: Delete all remaining instances of ctl_path
      net: Remove register_net_sysctl_table
      net sysctl: Add place holder functions for when sysctl support is compiled out of the kernel.
      net ax25: Fix the build when sysctl support is disabled.

Eyal Shapira (4):
      wl12xx: fix race between suspend/resume and recovery
      wl12xx: fix a memory leak of probereq template upon recovery
      wl12xx: adaptive sched scan dwell times
      wl12xx: increase scan timeout to 30s

Felix Fietkau (18):
      cfg80211: use compare_ether_addr on MAC addresses instead of memcmp
      mac80211: reduce code duplication in debugfs code
      mac80211: optimize aggregation session timeout handling
      ath9k_hw: add support for 8 AP mode interfaces
      ath9k: do not register LEDs on AR913x
      ath9k: optimize the hardware hang check
      ath9k: add possible wiphy interface combinations
      libertas: add missing include
      ath9k_hw: use standard SIFS time as reference for half/quarter channels
      ath9k_hw: increase ACK timeout for half/quarter channels
      ath9k_hw: set the PHY mode for half/quarter channels on AR9003
      ath9k_hw: increase symbol overlap window for half/quarter channels
      ath9k_hw: fix and clean up PHY activation delay
      ath9k_hw: disable Tx IQ calibration on half/quarter channels
      ath9k_hw: disable fast channel change when changing from/to half/quarter mode
      ath9k_hw: increase tx abort timeout for half/quarter channels
      mac80211: rename AP variable num_sta_authorized to num_mcast_sta
      mac80211: fix num_mcast_sta counting issues

Florian Fainelli (8):
      r6040: consolidate MAC reset to its own function
      r6040: remove unused variable mcr1 from private structure
      r6040: add a MAC operation timeout define
      r6040: fix typo on stats update in tx path
      r6040: define and use MLSR register bits
      r6040: define and use MTPR transmit enable bit
      r6040: define and use bits of register PHY_CC
      r6040: update copyright from 2007 to now

Florian Westphal (4):
      netfilter: limit, hashlimit: avoid duplicated inline
      netfilter: hashlimit: move rateinfo initialization to helper
      netfilter: hashlimit: byte-based limit mode
      netfilter: xt_hashlimit: use _ALL macro to reject unknown flag bits

Forest Bond (2):
      rtl8192de: Clean up and fix 92D cut version constants and macros.
      rtl8192de: Recognize 92D E-CUT version.

Francesco Virlinzi (2):
      stmmac: use custom init/exit functions in pm ops
      stmmac: Move the mdio_register/_unregister in probe/remove

Francois Romieu (41):
      sungem: stop using net_device.{base_addr, irq}.
      tehuti: stop using net_device.{base_addr, irq}.
      forcedeth: stop using net_device.{base_addr, irq}.
      atl1c: stop using net_device.{base_addr, irq}.
      via-rhine: stop using net_device.{base_addr, irq}.
      hamachi: stop using net_device.{base_addr, irq}.
      via-velocity: stop using net_device.{base_addr, irq}.
      sundance: stop using net_device.{base_addr, irq}.
      vxge: stop using net_device.{base_addr, irq}.
      fealnx: stop using net_device.{base_addr, irq}.
      atl1e: stop using net_device.{base_addr, irq}.
      s2io: stop using net_device.{base_addr, irq}.
      8139cp: stop using net_device.{base_addr, irq}.
      yellowfin: stop using net_device.{base_addr, irq}.
      starfire: stop using net_device.{base_addr, irq}.
      starfire: remove deprecated options.
      bnx2: stop using net_device.{base_addr, irq}.
      winbond840: stop using net_device.{base_addr, irq}.
      sc92031: stop using net_device.{base_addr, irq}
      sis190: stop using net_device.{base_addr, irq}
      tulip_core: stop using net_device.{base_addr, irq}.
      sunhme: stop using net_device.{base_addr, irq}.
      uli526x: fix regions leak in driver probe error path.
      xircom_cb: fix device probe error path.
      xircom_cb: stop using net_device.{base_addr, irq} and convert to __iomem.
      de2104x: stop using net_device.{base_addr, irq}.
      smsc9420: stop using net_device.{base_addr, irq}.
      natsemi: stop using net_device.{base_addr, irq}.
      8139too: dev->{base_addr, irq} removal.
      dl2k: stop using net_device.{base_addr, irq} and convert to __iomem.
      uli526x: stop using net_device.{base_addr, irq} and convert to __iomem.
      epic100: stop using net_device.{base_addr, irq} and convert to __iomem.
      dmfe: stop using net_device.{base_addr, irq} and convert to __iomem.
      sis900: stop using net_device.{base_addr, irq} and convert to __iomem.
      myri10ge: stop using net_device.{base_addr, irq}.
      rrunner: stop using net_device.{base_addr, irq}.
      ipw2200: stop using net_device.{base_addr, irq}.
      ipw2100: stop using net_device.base_addr.
      ipw2100: remove useless tests in the PCI device remove path.
      r8169: Config1 is read-only on 8168c and later.
      r8169: 8168c and later require bit 0x20 to be set in Config2 for PME signaling.

Frank Blaschka (1):
      qeth: remove token ring part 2

Franky Lin (7):
      brcm80211: fmac: add frame header extension support
      brcm80211: fmac: postpone dongle RF enabling.
      brcm80211: fmac: clean up chip id table
      brcmfmac: stop releasing sdio host in irq handler
      brcmfmac: check bus state for status
      brcmfmac: postpone interrupt register function
      brcmfmac: add out of band interrupt support

Gabor Juhos (9):
      ath9k: use ath9k_hw_update_regulatory_maxpower in ath9k_hw_def_set_txpower
      ath9k: use consistent value for REDUCE_SCALED_POWER_BY_THREE_CHAIN
      ath9k: introduce ath9k_hw_get_scaled_power helper
      ath9k: simplify ath9k_hw_get_scaled_power function
      ath9k: merge power correction constants
      ath9k: remove unused PWRINC_*_TO_*_CHAIN defines
      ath9k: move ath9k_hw_fbin2freq function to eeprom.h
      ath9k: use ath9k_hw_fbin2freq instead of FBIN2FREQ
      ath9k: fix TX power reporting on AR9003 chips

Geert Uytterhoeven (2):
      wiznet: Add missing #include <linux/irq.h>
      net/codel: Add missing #include <linux/prefetch.h>

Giuseppe CAVALLARO (9):
      stmmac: add clk management support
      stmmac: extend CSR Clock Range programming
      stmmac: MDC clock dynamically based on the csr clock input
      stmmac: update the driver version March 2012
      stmmac: verify the dma_cfg platform fields
      stmmac: do not fail when probe and there is no csr clk defined
      stmmac: extend mac addr reg and fix perfect filering
      stmmac: add mixed burst for DMA
      stmmac: fix suspend/resume locking

Giuseppe Cavallaro (1):
      stmmac: fix build when CONFIG_OF is enable

Greg Rose (7):
      ixgbe: UTA table incorrectly programmed
      ixgbe: Deny MACVLAN requests from VFs with admin set MAC
      ixgbe: Reset max_vfs to zero when user request is out of range
      ixgbevf: Add support to recognize 100mb link speed
      ixgbevf: Make sure jumbo frames are set correctly after PF reset
      ixgbevf: Update version string
      ixgbe: Fix bogus error message

H Hartley Sweeten (2):
      ipvs: ip_vs_ftp: local functions should not be exposed globally
      ipvs: ip_vs_proto: local functions should not be exposed globally

Haiyang Zhang (1):
      net/hyperv: Add flow control based on hi/low watermark

Hans Schillstrom (3):
      net: export sysctl_[r|w]mem_max symbols needed by ip_vs_sync
      netfilter: ip6_tables: add flags parameter to ipv6_find_hdr()
      netfilter: add xt_hmark target for hash-based skb marking

Hayes Wang (5):
      r8169: modify pll power function
      r8169: add device specific CSI access helpers.
      r8169: support the new RTL8402 chip.
      r8169: adjust some functions of 8111f
      r8169: support the new RTL8411 chip.

Helmut Schaa (1):
      rt2x00: Use GFP_KERNEL for rx buffer allocation on USB devices

Herbert Xu (4):
      bridge: Add br_multicast_start_querier
      bridge: Restart queries when last querier expires
      bridge: Add multicast_querier toggle and disable queries by default
      bridge: Fix fatal typo in setup of multicast_querier_expired

Hiroaki SHIMODA (1):
      neighbour: Make neigh_table_init_no_netlink() static.

Huang, Xiong (42):
      atl1c: update author contact info & company/driver desciption
      atl1c: remove multiple-RX-Q code
      atl1c: remove HDS register
      atl1c: remove VPD register
      atl1c: remove SMB/CMB DMA related code
      atl1c: split 2 32bit registers of TPD to 4 16bit registers
      atl1c: remove code related to rxq 1/2/3
      atl1c: wrong register used to stop TXQ
      atl1c: correct wrong definition of REG_DMA_CTRL
      atl1c: remove dmaw_block
      atl1c: using fixed TXQ configuration for l2cb and l1c
      atl1c: restore max-read-request-size in Device Conrol Register
      atl1c: threshold for ASPM is changed based on chip capability
      atl1c: add module parameter for l1c_wait_until_idle
      atl1c: update right threshold for TSO
      atl1c: remove dmar_dly_cnt and dmaw_dly_cnt
      atl1c: clear PCIE error status in atl1c_reset_pcie
      atl1c: refine reg definition of REG_MASTER_CTRL
      atl1c: clear bit MASTER_CTRL_CLK_SEL_DIS in atl1c_pcie_patch
      atl1c: refine/update ASPM configuration
      atl1c: refine atl1c_pcie_patch
      atl1c: fix WoL(magic) issue for l2cb 1.1
      atl1c: remove MDIO_REG_ADDR_MASK in atl1c_mdio_read/write
      atl1c: remove REG_PHY_STATUS
      atl1c: refine phy-register read/write function
      atl1c: remove PHY contrl in atl1c_reset_pcie
      atl1c: refine SERDES-clock related code
      atl1c: remove PHY polling from atl1c_open
      atl1c: update PHY reset related routine
      atl1c: remove PHY reset/init for link down event
      atl1c: add function atl1c_power_saving
      atl1c: refine start/enable code for MAC module
      atl1c: add workaround for issue of bit INTX-disable for MSI interrupt
      atl1c: add PHY link event(up/down) patch
      atl1c: clear WoL status when reset pcie
      atl1c: remove code of closing register writable attribution
      atl1c: refine mac address related code
      atl1c: enlarge L1 response waiting timer
      atl1c: cancel task when interface closed
      atl1c: do MAC-reset when PHY link down
      atl1c: Disable L0S when no cable link
      atl1c: remove PHY polling from atl1c_change_mtu

Jaccon Bastiaansen (1):
      CS89x0 : Use ioread16/iowrite16 on all platforms

Jack Morgenstein (7):
      net/mlx4_core: Fix init_port mask state for slaves
      net/mlx4_core: Change SYNC_TPT to be native (not wrapped)
      net/mlx4_core: Remove unused *_str functions from the resource tracker
      net/mlx4_core: Do not reset module-parameter num_vfs when fail to enable sriov
      net/mlx4_core: Fix potential kernel Oops in res tracker during Dom0 driver unload
      net/mlx4_core: Add XRC domains and counters to resource tracker
      net/mlx4_core: Fixed error flow in rem_slave_eqs

Jacob E Keller (1):
      ixgbe: Enable timesync clock-out feature for PPS support on X540

Jacob Keller (5):
      ixgbe: check for WoL support in single function
      ixgbe: Hardware Timestamping + PTP Hardware Clock (PHC)
      ixgbe: correct disable_rx_buff timeout
      ixgbe: add support for get_ts_info
      ixgbe: support software timestamping

Jakub Kicinski (5):
      rt2x00: increase led's name buffer length
      rt2800: introduce wpdma_disable function
      rt2800: add disabling of DMA before loading firmware
      rt2800: initialize queues before giving up due to DMA error
      rt2800: zero registers of unused TX rings

James Chapman (8):
      l2tp: fix locking of 64-bit counters for smp
      l2tp: Use ip4_datagram_connect() in l2tp_ip_connect()
      l2tp: remove unused stats from l2tp_ip socket
      pppox: Replace __attribute__((packed)) in if_pppox.h
      l2tp: pppol2tp_connect() handles ipv6 sockaddr variants
      l2tp: let iproute2 create L2TPv3 IP tunnels using IPv6
      l2tp: fix reorder timeout recovery
      l2tp: fix data packet sequence number handling

Jan Beulich (2):
      xfrm: make xfrm_algo.c a module
      xfrm_algo: drop an unnecessary inclusion

Jason Wang (10):
      virtio-net: send gratuitous packets when needed
      macvtap: zerocopy: fix offset calculation when building skb
      macvtap: zerocopy: fix truesize underestimation
      macvtap: zerocopy: put page when fail to get all requested user pages
      macvtap: zerocopy: set SKBTX_DEV_ZEROCOPY only when skb is built successfully
      macvtap: zerocopy: validate vectors before building skb
      vhost_net: zerocopy: fix possible NULL pointer dereference of vq->bufs
      vhost_net: re-poll only on EAGAIN or ENOBUFS
      vhost_net: zerocopy: adding and signalling immediately when fully copied
      vhost: zerocopy: poll vq in zerocopy callback

Javier Cardona (9):
      mac80211_hwsim: Fill timestamp beacon at the time it is transmitted
      mac80211: Allow tsf increments via debugfs
      mac80211: Implement mesh synchronization framework
      {nl,cfg}80211: Support for mesh synchronization
      mac80211: Set the correct values for hwmp (1) and airtimeLinkMetric (1)
      mac80211_hwsim: fixup for tsf setting
      mac80211: Choose a new toffset setpoint if a big tsf jump is detected.
      mac80211: Take into account TSF adjustment latency in Toffset setpoint
      mac80211: fixup for mesh TSF adjustment latency in Toffset setpoint

Jeff Kirsher (3):
      e1000e: Fix merge conflict (net->net-next)
      e1000e: Fix merge conflict (net->net-next)
      Merge branch 'master' of git://git.kernel.org/.../davem/net-next

Jeffrin Jose (4):
      net: Fixed coding style issues relating to braces.
      net: Fixed a coding style issue related to spaces.
      net:ipv6:fixed a trailing white space issue.
      net:ipv6:fixed space issues relating to operators.

Jesper Juhl (7):
      wireless, at76c50x:: Don't needlessly test for NULL before calling release_firmware()
      wireless, atmel: remove pointless test for NULL before release_firmware() call
      ipw2200: remove a redundant NULL check before calling release_firmware()
      wireless, libertas: remove redundant NULL tests before calling release_firmware()
      wireless, mwifiex: drop redundant NULL test before call to release_firmware()
      wireless, orinoco: release_firmware() tests for NULL, remove explicit tests before calls
      ipw2100: remove a redundant NULL check before calling release_firmware()

Jim Cromie (5):
      brcm80211: replace open-coded ARRAY_SIZE with the macro
      prism54: replace open-coded ARRAY_SIZE with macro
      broadcom: replace open-coded ARRAY_SIZE with macro
      enic: replace open-coded ARRAY_SIZE with macro
      ethernet: replace open-coded ARRAY_SIZE with macro

Jing Huang (7):
      bna: Serialize smem access during adapter initialization
      bna: Flash controller ioc pll init fixes
      bna: ioc cleanups
      bna: tx rx cleanup fix
      bna: Remove tx tasklet
      bna: Function name changes and cleanups
      bna: Update driver version to 3.0.23.0

Jiri Pirko (13):
      filter: Allow to create sk-unattached filters
      filter: add XOR operation
      team: add binary option type
      team: add loadbalance mode
      team: add support for per-port options
      team: add bool option type
      team: add user_linkup and user_linkup_enabled per-port option
      team: ab: walk through port list non-rcu
      team: add missed "statics"
      team: lb: let userspace care about port macs
      team: allow to enable/disable ports
      team: add per-port option for enabling/disabling ports
      net: IP_MULTICAST_IF setsockopt now recognizes struct mreq

Jitendra Kalsaria (1):
      qlcnic: Adding mac statistics to ethtool.

Joe Perches (41):
      ath6kl: Add __printf verification to ath6kl_printk
      vxge: Remove unnecessary ; in do {} while (0) macro
      vxge: Convert macro to inline function
      rtlwifi: Use is_zero_ether_addr, remove line continuation
      rtlwifi: Simplify rtl_get/set inline functions
      ath: Add and use pr_fmt, convert printks to pr_<level>
      ath5k: Introduce _ath5k_printk to reduce code/text
      iwlwifi: Add pr_fmt
      wireless: Remove unnecessary ; from while (0) macros
      etherdev.h: Convert int is_<foo>_ether_addr to bool
      etherdevice.h: Add ether_addr_equal
      802: Convert compare_ether_addr to ether_addr_equal
      8021q: Convert compare_ether_addr to ether_addr_equal
      bridge: netfilter: Convert compare_ether_addr to ether_addr_equal
      bridge: Convert compare_ether_addr to ether_addr_equal
      atm: Convert compare_ether_addr to ether_addr_equal
      bluetooth: Convert compare_ether_addr to ether_addr_equal
      mac80211: Convert compare_ether_addr to ether_addr_equal
      mac80211: Convert compare_ether_addr to ether_addr_equal by hand
      netfilter: Convert compare_ether_addr to ether_addr_equal
      wireless: Convert compare_ether_addr to ether_addr_equal
      wireless: Convert compare_ether_addr to ether_addr_equal by hand
      dsa: Convert compare_ether_addr to ether_addr_equal
      drivers/net: Convert compare_ether_addr to ether_addr_equal
      etherdevice.h: Add ether_addr_equal_64bits
      net, drivers/net: Convert compare_ether_addr_64bits to ether_addr_equal_64bits
      etherdevice: Remove now unused compare_ether_addr_64bits
      net: Add net_ratelimited_function and net_<level>_ratelimited macros
      net: Convert net_ratelimit uses to net_<level>_ratelimited
      net: ipv6: Standardize prefixes for message logging
      net: ipv4 and ipv6: Convert printk(KERN_DEBUG to pr_debug
      net: l2tp: Standardize logging styles
      pktgen: Use pr_debug
      net: ipv6: ndisc: Neaten ND_PRINTx macros
      net: core: Use pr_<level>
      lapb: Neaten debugging
      cirrus: cs89x0: Code style neatening
      cirrus: cs89x0: Convert printks to pr_<level>
      cirrus: cs89x0: Code neatening
      cirrus: cs89x0: Neaten debugging and logging
      cirrus: cs89x0: Remove function prototypes and reorder declarations

Johannes Berg (77):
      wireless: rename ht_info to ht_operation
      iwlwifi: process multiple frames per RXB
      iwlwifi: extend notification wait
      iwlwifi: simplify calibration collection
      iwlwifi: add trailing newline to various messages
      iwlwifi: clarify config struct comments
      iwlwifi: remove support_wimax_coexist
      iwlwifi: remove iq_invert config param
      iwlwifi: remove scan_rx_antennas
      iwlwifi: use scan while idle
      iwlwifi: move queue mapping out of transport
      iwlwifi: move valid_contexts to priv
      mac80211: don't always advertise remain-on-channel
      mwifiex: don't use IEEE80211_MAX_QUEUES
      mac80211: fix mesh TX coding style
      mac80211: clean up uAPSD TX code
      mac80211: make ieee80211_downgrade_queue static
      mac80211: inline ieee80211_add_pending_skbs
      mac80211: use AC constants
      mac80211: set HT channel before association
      mac80211: remove channel type argument from rate_update
      mac80211: remove queue stop on rate control update
      mac80211: notify driver of rate control updates
      mac80211: remove antenna_sel_tx TX info field
      cfg80211/nl80211: clarify TX queue API
      mac80211: refuse TX queue configuration on non-QoS HW
      mac80211: decouple # of netdev queues from HW queues
      mac80211: debounce queue stop/wake
      mac80211: lazily stop queues in add_pending
      mac80211: use IEEE80211_NUM_ACS
      mac80211: manage AP netdev carrier state
      mac80211: add explicit monitor interface if needed
      mac80211: add improved HW queue control
      mac80211: clean up an ieee80211_do_open error path
      cfg80211/mac80211: enable proper device_set_wakeup_enable handling
      iwlwifi: move rx_page_order into transport
      iwlwifi: remove watchdog debugfs file
      iwlwifi: remove unneeded struct declarations
      iwlwifi: move queue watchdog into transport
      iwlwifi: move hw_params into priv
      iwlwifi: remove ack_check module parameter
      iwlwifi: split force_reset debugfs file
      iwlwifi: move eeprom into priv
      iwlwifi: create device configuration header file
      iwlwifi: introduce device family enum
      iwlwifi: dynamically determine lib_ops
      iwlwifi: make iwl_sta_fill_lq static
      iwlwifi: calculate active legacy rates per station
      cfg80211: enforce lack of interface combinations
      iwlwifi: remove no_sleep_autoadjust
      iwlwifi: remove uCode alternatives mechanism
      iwlwifi: remove antenna from mod params struct
      iwlwifi: remove iwl_tx_queue declaration
      iwlwifi: optimize struct iwl_cmd_meta layout
      iwlwifi: remove get_cmd_string
      iwlwifi: improve TX cache footprint
      iwlwifi: properly set basic rates
      iwlwifi: remove debugfs logspam
      iwlwifi: move debugfs registration function declarations
      iwlwifi: move iwl_have_debug_level
      iwlwifi: clean up iwl-shared.h includes
      iwlwifi: remove bt_siso_mode declaration
      iwlwifi: move TIME_UNIT
      iwlwifi: move iwl_cmd_echo_test
      iwlwifi: remove traffic log
      iwlwifi: remove TX/RX frame statistics
      iwlwifi: remove duplicate iwlagn_mod_params declaration
      iwlwifi: move driver defines to iwl-drv.h
      iwlwifi: move PLCP defines to config
      iwlwifi: move watchdog definitions to config
      iwlwifi: move eeprom versions to HW files
      iwlwifi: move antenna definitions to config
      iwlwifi: move OTP defines
      iwlwifi: clean up some hw file includes
      iwlwifi: use direct calls for transport free
      iwlwifi: clean up module parameters
      iwlwifi: use new mac80211 queue scheme

John Fastabend (9):
      net: add generic PF_BRIDGE:RTM_ FDB hooks
      net: addr_list: add exclusive dev_uc_add and dev_mc_add
      net: add fdb generic dump routine
      net: rtnetlink notify events for FDB NTF_SELF adds and deletes
      ixgbe: enable FDB netdevice ops
      ixgbe: allow RAR table to be updated in promisc mode
      macvlan: add FDB bridge ops and macvlan flags
      net: dcb: add CEE notify calls
      ixgbe: dcb: IEEE PFC stats and reset logic incorrect

John W. Linville (8):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' into for-davem
      Merge branch 'for-linville' of git://github.com/kvalo/ath6kl
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'wireless-next' of git://git.kernel.org/.../iwlwifi/iwlwifi
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      iwlwifi: fix-up some merge damage from commit 0d6c4a2

Jonathan Bither (1):
      ath5k: use compare_ether_addr on MAC addresses instead of memcmp

Jozsef Kadlecsik (1):
      netfilter: ipset: fix timeout value overflow bug

Julia Lawall (1):
      drivers/net/wireless/libertas/if_usb.c: add missing debugging code

Julian Anastasov (11):
      ipvs: timeout tables do not need GFP_ATOMIC allocation
      ipvs: LBLC scheduler does not need GFP_ATOMIC allocation on init
      ipvs: DH scheduler does not need GFP_ATOMIC allocation
      ipvs: WRR scheduler does not need GFP_ATOMIC allocation
      ipvs: LBLCR scheduler does not need GFP_ATOMIC allocation on init
      ipvs: SH scheduler does not need GFP_ATOMIC allocation
      ipvs: ignore IP_VS_CONN_F_NOOUTPUT in backup server
      ipvs: remove check for IP_VS_CONN_F_SYNC from ip_vs_bind_dest
      ipvs: fix ip_vs_try_bind_dest to rebind app and transmitter
      ipvs: always update some of the flags bits in backup
      ipvs: reduce sync rate with time thresholds

Jussi Kivilinna (4):
      rndis_host: cleanup: byteswap data from device instead of RNDIS_* defines
      rndis_wlan: cleanup: byteswap data from device instead of RNDIS_* defines
      rndis_host: cleanup: change oid from __le32 to u32 in rndis_query()
      rndis_wlan: cleanup: change oid from __le32 to u32 in various places

Kalle Valo (11):
      ath6kl: abort normal scan when scheduled scan is started
      Merge remote branch 'wireless-next/master' into ath6kl-next
      ath6kl: set ram reserved size only for ar6003
      ath6kl: Add tx_complete() to struct htc_ep_callbacks
      ath6kl: add tx_comp_multi() to struct htc_ep_callbacks
      ath6kl: add pointer to the skb in htc_packet
      ath6kl: add rx data padding support
      ath6kl: remove void pointer from ath6kl_credit_setup()
      ath6kl: add htc ops
      ath6kl: Add HTC pipe implementation
      ath6kl: add full USB support

Karsten Keil (14):
      mISDN: Fix division by zero
      mISDN: DSP scheduling fix (version 2)
      mISDN: Fix refcounting bug
      mISDN: L2 timeouts need to be queued as L2 event
      mISDN: Make layer1 timer 3 value configurable
      mISDN: Layer1 statemachine fix
      mISDN: Help to identify the card
      mISDN: Cleanup channel also if it already was deactivated
      mISDN: Early confirm for transparent data
      mISDN: avmfritz use the bigger fifo of chip version 2
      mISDN: Reduce RX buffer allocation for transparent data
      mISDN: Allow to set a minimum length for transparent data
      mISDN: Implement MISDN_CTRL_FILL_EMPTY for more drivers
      mISDN: Implement MISDN_CTRL_RX_OFF for more drivers

Kelvie Wong (1):
      netfilter: nf_ct_expect: partially implement ctnetlink_change_expect

Koki Sanagi (1):
      igb: output register's information related to RX/TX queue[4-15]

Larry Finger (10):
      p54usb: Load firmware asynchronously
      rtlwifi: Preallocate USB read buffers and eliminate kalloc in read routine
      rtlwifi: Add missing DMA buffer unmapping for PCI drivers
      rtlwifi: rtl8192ce: Remove false positives for kmemleak
      rtlwifi: Move dig_t and ps_t structs
      rtlwifi: Add dm structs to private structure
      rtlwifi: rtl8192c: Convert driver to use private dm structs
      rtlwifi: rtl8192c: Convert driver to use private ps_t struct
      rtlwifi: rtl8192de: Convert driver to use private dm structs
      rtlwifi: rtl8192se: Convert driver to use private dm struct

Lars-Peter Clausen (1):
      net: Remove redundant spi driver bus initialization

Lino Sanfilippo (1):
      sky2: fix missing register reset on error path in sky2_test_msi()

Linus Luessing (1):
      batman-adv: Adding hard_iface specific sysfs wrapper macros for UINT

Linus Walleij (14):
      NET: smsc-ircc2: mark non-experimental
      usb/net: rndis: inline the cpu_to_le32() macro
      usb/net: rndis: break out <linux/rndis.h> defines
      usb/net: rndis: remove ambigous status codes
      usb/net: rndis: eliminate first set of duplicate OIDs
      usb/net: rndis: merge duplicate 802_* OIDs
      usb/net: rndis: delete surplus defines
      usb/net: rndis: group all status codes together
      usb/net: rndis: merge media type definitions
      usb/net: rndis: delete duplicate packet types
      usb/net: rndis: move and namespace PnP defines
      usb/net: rndis: merge command codes
      usb/net: rndis: fixup a few name prefixes
      usb/net: rndis: move bus message definition

Lorenzo Bianconi (2):
      rtlwifi: support for Belkin Surf N300 XR
      mac80211: fix an issue in ieee80211_tx_info count field management

Luciano Coelho (23):
      wireless/wl12xx/wl1251: move TI WLAN modules to a common ti subdirectory
      wl12xx/wlcore: rename wl12xx to wlcore
      wl12xx/wlcore: spin out the wl12xx probe from wlcore to a new wl12xx
      wl12xx/wlcore: initial split of probe
      wl12xx/wlcore: move wl1271 struct to wlcore and add ops
      wlcore/wl12xx: implement chip-specific partition tables
      wlcore/wl12xx: implement chip-specific register tables
      wlcore/wl12xx: add chip-specific identify chip operation
      wlcore/wl12xx: move get_pg_ver to the lower driver
      wlcore/wl12xx: move top initialization to wl12xx
      wlcore/wl12xx: move MAC address reading operation to lower driver
      wlcore/wl12xx: add command trigger and event ack operations
      wlcore/wl12xx: add quirk for legacy NVS support
      wlcore: remove some unnecessary event mailbox address reads
      wlcore: add quirk to disable ELP
      wlcore/wl12xx: add prepare_read hw op for Rx data
      wlcore/wl12xx: add hw_init operation
      wlcore/wl12xx: move runtime configuration struct to the lower driver
      wlcore/wl12xx: move extended radio configuration parameters to wl12xx
      wlcore/wl12xx: use a single memory config and reset if using wl127x
      wlcore/wl12xx: move identify firmware function to a lower driver op
      Merge branch 'wl12xx-next' into for-linville
      mac80211: check IEEE80211_HW_QUEUE_CONTROL in ieee80211_check_queues()

Luis R. Rodriguez (2):
      cfg80211: warn if db.txt is empty with CONFIG_CFG80211_INTERNAL_REGDB
      libertas: include sched.h on firmware.c

Manish Chopra (1):
      qlcnic: Allow a predefined set of capture masks for FW dump

Manish chopra (3):
      netxen_nic: Allow only useful and recommended firmware dump capture mask values
      linux/ethtool: Added macro ETH_FW_DUMP_DISABLE
      qlcnic-ethtool: set the ethtool_dump flag by ETH_FW_DUMP_DISABLE value that is zero, if firmware dump is disabled.

Marco Porsch (1):
      mac80211: end service period only after sending last buffered frame

Marek Lindner (22):
      batman-adv: encourage batman to take shorter routes by changing the default hop penalty
      batman-adv: move ogm initialization into the proper function
      batman-adv: refactoring API: find generalized name for bat_ogm_init callback
      batman-adv: randomize initial seqno to avoid collision
      batman-adv: add iface_disable() callback to routing API
      batman-adv: handle routing code initialization properly
      batman-adv: refactoring API: find generalized name for bat_ogm_init_primary callback
      batman-adv: rename BATMAN_OGM_LEN to BATMAN_OGM_HLEN
      batman-adv: mark existing ogm variables as batman iv
      batman-adv: introduce is_single_hop_neigh variable to increase readability
      batman-adv: introduce packet type handler array for incoming packets
      batman-adv: register batman ogm receive function during protocol init
      batman-adv: rename last_valid to last_seen
      batman-adv: replace HZ calculations with jiffies_to_msecs()
      batman-adv: split neigh_new function into generic and batman iv specific parts
      batman-adv: ignore protocol packets if the interface did not enable this protocol
      batman-adv: refactoring API: find generalized name for bat_ogm_update_mac callback
      batman-adv: rename sysfs macros to reflect the soft-interface dependency
      batman-adv: avoid temporary routing loops by being strict on forwarded OGMs
      batman-adv: fix checkpatch string complaint
      batman-adv: prepare lq_update_lock to be shared among different protocols
      batman-adv: refactor window_protected to avoid unnecessary return statement

Martin Bachem (1):
      mISDN: Bugfix hfcsusb: usb endpoint activation/deactivation

Masanari Iida (2):
      net: Fix spelling typo in net
      isdn: Fix typo in hfcmulti.c

Matt Renzelmann (1):
      hostap: GFP_ATOMIC/GFP_KERNEL cleanup

Matthew Vick (8):
      e1000e: Minor comment clean-up.
      e1000e: Disable Far-End LoopBack following reset on 80003ES2LAN.
      e1000e: Enable DMA Burst Mode on 82574 by default.
      igb: Force flow control off during reset when forcing speed.
      e1000e: Resolve intermittent negotiation issue on 82574/82583.
      e1000e: Driver workaround for IPv6 Header Extension Erratum.
      e1000e: Update driver version number
      igb: Disable the BMC-to-OS Watchdog Enable bit for DMAC.

Meenakshi Venkataraman (32):
      iwlwifi: use iwlagn_fw_error instead of iwl_nic_error
      iwlwifi: make iwl_nic_error static
      iwlwifi: move ucode error log reporting to op_mode
      iwlwifi: move ucode_type from shared to op_mode
      iwlwifi: move iwl_init_geos to iwl-agn.c
      iwlwifi: Move iwl_send_rxon_timing and make it static
      iwlwifi: move iwl_set_rxon_hwcrypto and mark it static
      iwlwifi: move iwl_check_rxon_cmd and mark it static
      iwlwifi: move iwl_full_rxon_required and mark it static
      iwlwifi: move iwl_get_single_channel_number and mark it static
      iwlwifi: remove firmware info from iwl_shared
      iwlwifi: move iwlagn_hw_valid_rtc_data_addr prototype
      iwlwifi: move channel switch related functions
      iwlwifi: move iwl_free_skb and mark it static
      iwlwifi: move iwl_set_hw_rfkill_state and mark it static
      iwlwifi: move iwl_is_ht40_tx_allowed out of iwl-core.c
      iwlwifi: move iwl_set_rxon_ht to iwl-agn-rxon.c
      iwlwifi: move iwl_set_rxon_channel to iwl-agn-rxon.c
      iwlwifi: move iwl_set_flags_for_band to iwl-agn-rxon.c
      iwlwifi: move iwl_connection_init_rx_config to iwl-agn-rxon.c
      iwlwifi: move iwl_set_rate to iwl-agn-rxon.c
      iwlwifi: move iwl_chswitch_done to iwl-mac80211.c
      iwlwifi: move iwlagn_fw_error to iwl-agn.c
      iwlwifi: move iwl_set_tx_power and make it static
      iwlwifi: move iwl_send_bt_config and mark it static
      iwlwifi: move iwl_print_rx_config_cmd to iwl-agn-rxon.c
      iwlwifi: move iwl_send_statistics_request to iwl-agn.c
      iwlwifi: move iwl_force_rf_reset to iwl-agn-rx.c
      iwlwifi: move iwl_bcast_addr to iwl-agn-sta.c
      iwlwifi: move utility functions out of iwl-core.h
      iwlwifi: move scan related declarations out of iwl-core.h
      iwlwifi: use correct released ucode version

Michael Liang (1):
      ath9k: don't strip mic on non-encrypted frames in tkip

Michael S. Tsirkin (1):
      virtio/tools: add delayed interupt mode

Michal Kazior (1):
      mac80211: remove hw.conf.channel usage where possible

Michal Kubeƒçek (1):
      bonding: start slaves with link down for ARP monitor

Mike Sinkovsky (4):
      Ethernet driver for the WIZnet W5300 chip
      Ethernet driver for the WIZnet W5100 chip
      drivers/net: Remove CONFIG_WIZNET_TX_FLOW option
      net: WIZnet drivers: fix possible NULL dereference

Mircea Gherzan (1):
      wl12xx: fix DMA-API-related warnings

Mohammed Shafi Shajakhan (1):
      mac80211: remove ieee80211_rx_bss_get

Neal Cardwell (2):
      tcp: restore formatting of macros for tcp_skb_cb sacked field
      tcp: move duplicate code from tcp_v4_init_sock()/tcp_v6_init_sock()

Neil Horman (1):
      drop_monitor: convert to modular building

Nicolas Ferre (1):
      net/at91_ether: use gpio_to_irq for phy IRQ line

Oliver Hartkopp (1):
      iwlwifi: fix unused variable warning

Or Gerlitz (1):
      net/mlx4: Address build warnings on set but not used variables

Pablo Neira Ayuso (9):
      netfilter: bridge: optionally set indev to vlan
      ipvs: wakeup master thread
      ipvs: add support for sync threads
      ipvs: optimize the use of flags in ip_vs_bind_dest
      netfilter: nf_conntrack: fix explicit helper attachment and NAT
      netfilter: remove ip_queue support
      netfilter: xt_HMARK: modulus is expensive for hash calculation
      netfilter: nf_ct_tcp: extend log message for invalid ignored packets
      netfilter: nf_ct_h323: fix usage of MODULE_ALIAS_NFCT_HELPER

Padmanabh Ratnakar (7):
      be2net: Fix VLAN/multicast packet reception
      be2net: Fix FW download in Lancer
      be2net: Fix ethtool self test for Lancer
      be2net: Fix traffic stall INTx mode
      be2net: Fix Lancer statistics
      be2net: Fix wrong status getting returned for MCC commands
      be2net: Fix FW download for BE

Paul Gortmaker (8):
      drivers/net: fix unresolved 64bit math in mellanox/mlx4/en_dcb_nl.c
      tipc: remove inline instances from C source files.
      tipc: compress out gratuitous extra carriage returns
      s390: delete any traces of token ring support
      atm: remove the coupling to token ring support
      net: delete all instances of special processing for token ring
      tokenring: delete all remaining driver support
      drivers/net: delete all code/drivers depending on CONFIG_MCA

Pavel Emelyanov (10):
      sock: Introduce named constants for sk_reuse
      tcp: Move code around
      tcp: Initial repair mode
      tcp: Repair socket queues
      tcp: Report mss_clamp with TCP_MAXSEG option in repair mode
      tcp: Repair connection-time negotiated parameters
      tcp repair: Fix unaligned access when repairing options (v2)
      tcp: Move rcvq sending to tcp_input.c
      tcp: Schedule rmem for rcvq repair send
      tcp: Out-line tcp_try_rmem_schedule

Peter H√ºwe (1):
      isdn/hysdn: Convert to kstrtoul_from_user

Pontus Fuchs (1):
      cfg80211: Add channel information to NL80211_CMD_GET_INTERFACE

Qasim Javed (1):
      ath5k: Remove extraneous statements from ath5k_hw_proc_4word_tx_status and ath5k_hw_proc_2word_status.

Raja Mani (4):
      ath6kl: Add ARP offload related statistic info in tgt_stats
      ath6kl: Isolate host sleep mode config part from ath6kl_wow_suspend
      ath6kl: Optimize target power in deep sleep suspend
      ath6kl: Store scan request info in-advance before sending SCAN request

Rajesh Borundia (1):
      netxen_nic: Fix estimation of recv MSS in case of LRO

Rajkumar Manoharan (14):
      ath9k_hw: improve ANI processing and rx desensitizing parameters
      ath9k: recover ar9380 chips from rare stuck state
      mac80211: do not send pspoll when powersave is disabled
      mac80211: flush to get the tx status of nullfunc frame immediately
      ath9k_hw: Update rx gain initval to improve rx sensitivity
      ath9k: fix ibss fair beacon distribution for AR9462
      ath9k: fix ibss beacon next tbtt
      cfg80211: increse bss expire time
      ath9k: reset noiseimmunity level to default
      ath9k: skip beaconing when reset work is pending
      ath9k: fix beacon descriptor
      ath9k: simplify beacon configuration for beaconing vifs
      ath9k_hw: remove ATH_BTCOEX_CFG_MCI
      mac80211: fix rate control update on 2040 bss change

Rami Rosen (2):
      net: remove unused icmp_ioctl() definition.
      pppoe: remove unused return value from two methods.

Randy Dunlap (1):
      hippi: fix printk format in rrunner.c

Richard Alpe (1):
      e1000e: clear REQ and GNT in EECD (82571 && 82572)

Richard Cochran (33):
      igb: add PTP Hardware Clock code
      igb: offer a PTP Hardware Clock instead of the timecompare method
      ptp: Add a method for obtaining the device index.
      ethtool: Introduce a method for getting time stamping capabilities.
      dp83640: Support the get_ts_info ethtool method.
      gianfar: Support the get_ts_info ethtool method.
      bfin_mac: Support the get_ts_info ethtool method.
      ixp4xx_eth: Support the get_ts_info ethtool method.
      ethtool: Add a common function for drivers with transmit time stamping.
      ax88796: Support the get_ts_info ethtool method.
      davinci_emac: Support the get_ts_info ethtool method.
      dnet: Support the get_ts_info ethtool method.
      etherh: Support the get_ts_info ethtool method.
      fec_mpc52xx: Support the get_ts_info ethtool method.
      fec: Support the get_ts_info ethtool method.
      fs_enet: Support the get_ts_info ethtool method.
      ll_temac: Support the get_ts_info ethtool method.
      macb: Support the get_ts_info ethtool method.
      mv643xx_eth: Support the get_ts_info ethtool method.
      pxa168_eth: Support the get_ts_info ethtool method.
      r6040: Support the get_ts_info ethtool method.
      r8169: Support the get_ts_info ethtool method.
      smsc911x: Support the get_ts_info ethtool method.
      smsc9420: Support the get_ts_info ethtool method.
      stmmac: Support the get_ts_info ethtool method.
      tg3: Support the get_ts_info ethtool method.
      ucc_geth: Support the get_ts_info ethtool method.
      usbnet: Support the get_ts_info ethtool method.
      ixp4xx_eth: Fix up the get_ts_info ethtool method.
      e100: Support the get_ts_info ethtool method.
      e100: enable transmit time stamping.
      pch_gbe: run the ptp bpf just once per packet
      pch_gbe: remove suspicious comment

Rick Jones (1):
      bonding: bond_update_speed_duplex() can return void since no callers check its return

Rob Herring (1):
      net: remove ixp2000 ethernet driver

Ronald Wahl (1):
      mac80211: when receiving DTIM disable power-save mode only if it was enabled

RongQing.Li (4):
      net: replace continue with break to reduce unnecessary loop in xxx_xmarksources
      drivers/net/oki-semi: Remove the definition of PCH_GBE_ETH_ALEN
      drivers/net/oki-semi: Donot recompute IP header checksum
      pch_gbe: reprogram multicast address register on reset

R√©mi Denis-Courmont (3):
      Phonet: phonet_net_id can be static (sparse)
      Phonet: missing headers (sparse)
      Phonet: change maintainer address

Samuel Ortiz (10):
      NFC: Add a target lost netlink event
      NFC: The core part should generate the target index
      NFC: Dump LLCP frames
      NFC: No need to apply twice the modulo op to LLCP's recv_n
      NFC: Fix LLCP TLV building routine
      NFC: Call llcp_add_header properly when sending LLCP DM or DISC
      NFC: Convert pn533 from tasklet to workqueues
      NFC: pn533 Rx chaining support
      NFC: Add MIUX to the local LLCP general bytes
      NFC: Fix LLCP link timeout typo

Santosh Nayak (1):
      Driver: Atm: Remove 'break' after 'return' statement.

Sasha Levin (2):
      ipvs: use GFP_KERNEL allocation where possible
      net: codel: fix build errors

Sathya Perla (1):
      be2net: avoid disabling sriov while VFs are assigned

Sebastian Andrzej Siewior (3):
      net/niu: remove one superfluous dma mask check
      e1000: remove workaround for Errata 23 from jumbo alloc
      e1000: look in the page and not in skb->data for the last byte

Shan Wei (3):
      net: fix compile error of leaking kmemleak.h header
      net: sock_diag_handler structs can be const
      net: doc: merge /proc/sys/net/core/* documents into one place

Shmulik Ladkani (1):
      ipv6: Fix 'inet6_rtm_getroute' to release 'rt->dst' in case of 'alloc_skb' failure

Shuah Khan (1):
      net/core: simple_strtoul cleanup

Simon Wunderlich (10):
      batman-adv: remove old bridge loop avoidance code
      batman-adv: add basic bridge loop avoidance code
      batman-adv: make bridge loop avoidance switchable
      batman-adv: export claim tables through debugfs
      batman-adv: allow multiple entries in tt_global_entries
      batman-adv: don't let backbone gateways exchange tt entries
      batman-adv: add broadcast duplicate check
      batman-adv: drop STP over batman
      batman-adv: form groups in the bridge loop avoidance
      batman-adv: add bridge loop avoidance compile option

Somnath Kotur (5):
      be2net: Fix to not set link speed for disabled functions of a UMC card
      be2net: Fix to apply duplex value as unknown when link is down.
      be2net: Record receive queue index in skb to aid RPS.
      be2net: Fix EEH error reset before a flash dump completes
      be2net: Fix to allow get/set of debug levels in the firmware.

Srinivas Kandagatla (4):
      net:phy:bcm63xx: remove unnecessary code
      net:phy:davicom: remove unnecessary code
      net:phy:marvell: remove unnecessary code
      stmmac: Allow stmmac to work with other PHY buses(v3).

Sritej Velaga (1):
      netxen_nic: disable minidump by default

Stanislav Yakovlev (4):
      net/wireless: ipw2x00: remove unused libipw_measurement_report struct
      net/wireless: ipw2x00: remove ssid_context struct
      net/wireless: ipw2x00: add supported cipher suites to wiphy initialization
      net/wireless: ipw2200: Fix WARN_ON occurring in wiphy_register called by ipw_pci_probe

Stanislaw Gruszka (6):
      mac80211: sanity check for null SSID
      rt2x00: configure different txdesc parameters for non HT channel
      rt2x00: do not generate seqno in h/w if QOS is disabled
      mac80211: do not scan and monitor connection in parallel
      mac80211: protect ->scanning by mutex in ieee80211_work_work()
      iwlwifi: add option to disable 5GHz band

Stephen Hemminger (1):
      econet: remove ancient bug ridden protocol

Stephen Rothwell (1):
      net/pasemi: fix compiler warning

Steve Glendinning (3):
      smsc75xx: replace 0xffff with PHY_INT_SRC_CLEAR_ALL
      smsc75xx: eliminate unnecessary phy register read
      smsc75xx: let EEPROM determine GPIO/LED settings

Steven King (1):
      dm9000: some coldfire boards need this

Stuart Hodgson (3):
      sfc: Do not attempt to flush queues if DMA is disabled
      ethtool: Extend the ethtool API to obtain plugin module eeprom data
      sfc: Added support for new ethtool APIs for obtaining module eeprom

Sucheta Chakraborty (2):
      qlcnic: Register device in FAILED state.
      netxen: added miniDIMM support in driver.

Sujith Manoharan (3):
      ath9k_hw: Remove BTCOEX initvals
      ath9k_htc: Add Panasonic N5HBZ0000055 device id
      ath9k: Fix IDLE Powersave

Sven Eckelmann (5):
      batman-adv: Replace bitarray operations with bitmap
      batman-adv: Remove declaration of only locally used functions
      batman-adv: use shorter pr_warn instead of pr_warning
      batman-adv: Start new development cycle
      batman-adv: README cleanups

Takahiro Shimizu (7):
      pch_gbe: scale time stamps to nanoseconds
      pch_gbe: simplify transmit time stamping flag test
      pch_gbe: reprogram multicast address register on reset
      pch_gbe: export a method to set the receive match address
      pch_gbe: improve coding style
      pch_gbe: do not set the channel control register
      pch_gbe: correct receive time stamp filtering

Thomas Pedersen (7):
      cfg80211: add channel switch notify event
      mac80211: refactor mesh peer initialization
      mac80211: refactor mesh peer rate handling
      mac80211: don't set mesh peer ht caps if ht disabled
      mac80211: fix STA channel width field
      mac80211: insert mesh peer after init
      mac80211: don't transmit 40MHz frames to 20MHz peer

Tilman Schmidt (8):
      isdn/gigaset: ratelimit CAPI message dumps
      isdn/gigaset: fix CAPI disconnect B3 handling
      isdn/gigaset: improve error handling querying firmware version
      isdn/gigaset: fix readability damage
      isdn/gigaset: internal function name cleanup
      isdn/gigaset: unify function return values
      isdn/capi: fix readability damage
      isdn/capi: elliminate capincci_find() in non-middleware case

Tony Zelenoff (11):
      atl1: handle rx in separate condition
      atl1: make driver napi compatible
      atl1: add napi process of tx interrupts
      atl1: use defined functions to disable irq
      atl1: make function to set imr of card
      atl1: add value to check ability of reenabling IRQs
      atl1: enable errors and link ints when rx/tx scheduled
      atl1: do not process interrupts in cycle in handler
      atl1: do not drop rx/tx interrupts before they are scheduled
      atl1: remove unused member from atl1_adapter structure
      netfilter: nf_ct_ecache: refactor notifier registration

Vasanthakumar Thiagarajan (7):
      ath6kl: Dump htc header when invalid Rx frame length is detected
      ath6kl: Configure inactivity timeout in fw
      ath6kl: Support net_stats.multicast
      ath6kl: Fix target assert in p2p bringup with multi vif
      ath6kl: Don't advertise HT40 support in 2.4 Ghz
      ath6kl: Configure htcap in fw based on the channel type in AP mode
      ath6kl: Fix 4-way handshake failure in AP and P2P GO mode

Victor Goldenshtein (1):
      wl12xx: fix station channel switch

Vijay Subramanian (1):
      tcp: Remove redundant code entering quickack mode

Vivek Natarajan (2):
      ath6kl: Use vmalloc instead of kmalloc for fw
      ath6kl: Fix scan related issue on suspend-resume

WarheadsSE (1):
      mwifiex: add support for SD8786 sdio

Wey-Yi Guy (22):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into wireless-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into wireless-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into wireless-next
      iwlwifi: remove un-needed parameter
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into wireless-next
      iwlwifi: more generic name for bluetooth command
      iwlwifi: change the default P2P support to "Yes"
      mac80211: add function retrieve average rssi
      mac80211: declare ieee80211_ave_rssi as EXPORT
      iwlwifi: include net/mac80211.h to avoid compiler error
      mac80211: check for non-managed interface
      iwlwifi: remove unused macros
      iwlwifi: add BT reduced tx power flag
      iwlwifi: add checking for the condition to reduce tx power
      iwlwifi: add reduced tx power threshold define
      iwlwifi: small define change
      iwlwifi: send reduce tx power info in command
      iwlwifi: change kill mask based on reduce power state
      iwlwifi: add loose coex lut
      iwlwifi: modify #ifdef to avoid sparse complain
      iwlwifi: remove the iwl_shared reference
      iwlwifi: use 6000G2B for 6030 device series

Willem de Bruijn (4):
      e1000: add transmit timestamping support
      e1000e: add transmit timestamping support
      bnx2x: add transmit timestamping support
      forcedeth: add transmit timestamping support

Wu Jiajun-B06378 (1):
      gianfar: add GRO support

Xose Vazquez Perez (4):
      wireless: rt2x00: rt{2500,73}usb.c put back duplicate id
      wireless: rt2x00: rt2800pci add more RT539x ids
      wireless: rt2x00: rt2800usb add more devices ids
      wireless: rt2x00: rt2800usb more devices were identified

Yaniv Rosner (2):
      bnx2x: Add remote-fault link detection
      bnx2x: Change comments and white spaces

Yevgeny Petrilin (3):
      mlx4_en: Added Ethtool support for TX Interrupt coalescing
      mlx4_en: Moving to Interrupts for TX completions
      mlx4_en: Byte Queue Limit support

Yoshihiro Shimoda (1):
      net: sh_eth: add support R8A7740

Yoshinori Sato (1):
      ath5k: add PCI id

Yuchung Cheng (3):
      tcp: early retransmit: tcp_enter_recovery()
      tcp: early retransmit
      tcp: early retransmit: delayed fast retransmit

Yuval Mintz (5):
      bnx2x: remove unnecessary .h dependencies
      bnx2x: remove unnecessary dmae code
      bnx2x: enable inta on the pci bus when used
      bnx2x: congestion management re-organization
      bnx2x: Change to driver version 1.72.10-0

Zefir Kurtisi (6):
      ath9k: add DFS pattern detector
      ath9k: add DFS pattern detector instance to ath_softc
      ath9k: update to DFS pattern detector interface
      ath9k: remove dead code
      ath9k: make DFS detector pools SMP safe
      ath9k: extend DFS detector stats in dfs_debugfs

alex.bluesman.smirnov@gmail.com (16):
      6lowpan: move frame allocation code to a separate function
      6lowpan: duplicate definition of IEEE802154_ALEN
      6lowpan: IPv6 link local address
      mac802154: basic ieee802.15.4 device structures
      mac802154: allocation of ieee802154 device
      mac802154: RX data path
      mac802154: TX data path
      mac802154: declare reduced mlme operations
      mac802154: slave interfaces declaration
      mac802154: basic MAC commands interface support
      mac802154: basic mib support
      ieee802154: interface type to be added
      mac802154: slaves management support
      mac802154: monitor device support
      drivers/ieee802154: IEEE 802.15.4 loopback driver
      Documentation/networking/ieee802154: update MAC chapter

frank.blaschka@de.ibm.com (1):
      qeth: recognize vlan devices in layer3 mode

fran√ßois romieu (1):
      dmfe: enforce consistent timing delay.

hartleys (2):
      isdn/eicon: use standard __init,__exit function markup
      crush: include header for global symbols

majianpeng (2):
      net/ipv4:Remove two memleak reports by kmemleak_not_leak.
      net/core:Remove memleak reports by kmemleak_not_leak.

sjur.brandeland@stericsson.com (2):
      caif-hsi: Remove stop/start of queue.
      caif-hsi: Postpone init of HSI until open()

stephen hemminger (4):
      rtnetlink & bonding: change args got get_tx_queues
      rtnetlink: fix comments
      tunnel: implement 64 bits statistics
      etherdevice: fix comments

 Documentation/ABI/removed/ip_queue                                |    9 +
 Documentation/ABI/testing/sysfs-class-net-mesh                    |    9 +
 Documentation/DocBook/80211.tmpl                                  |    2 +-
 Documentation/devicetree/bindings/net/mdio-mux-gpio.txt           |  127 +
 Documentation/devicetree/bindings/net/mdio-mux.txt                |  136 +
 Documentation/filesystems/proc.txt                                |    1 -
 Documentation/networking/00-INDEX                                 |    8 -
 Documentation/networking/3c359.txt                                |   58 -
 Documentation/networking/3c509.txt                                |    1 -
 Documentation/networking/batman-adv.txt                           |   22 +-
 Documentation/networking/fore200e.txt                             |    6 +-
 Documentation/networking/ieee802154.txt                           |   75 +-
 Documentation/networking/ip-sysctl.txt                            |   32 +-
 Documentation/networking/mac80211-auth-assoc-deauth.txt           |   10 +-
 Documentation/networking/olympic.txt                              |   79 -
 Documentation/networking/smctr.txt                                |   66 -
 Documentation/networking/stmmac.txt                               |   29 +-
 Documentation/networking/tms380tr.txt                             |  147 -
 Documentation/nfc/nfc-hci.txt                                     |  155 +
 Documentation/sysctl/net.txt                                      |    7 +
 MAINTAINERS                                                       |   36 +-
 arch/arm/mach-at91/at91rm9200.c                                   |   10 -
 arch/arm/mach-at91/at91rm9200_devices.c                           |    4 +-
 arch/arm/mach-at91/include/mach/hardware.h                        |    1 -
 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h                     |    3 +
 arch/mips/configs/mtx1_defconfig                                  |    4 -
 arch/sparc/Kconfig                                                |    1 +
 arch/sparc/Makefile                                               |    1 +
 arch/sparc/net/Makefile                                           |    4 +
 arch/sparc/net/bpf_jit.h                                          |   68 +
 arch/sparc/net/bpf_jit_asm.S                                      |  205 ++
 arch/sparc/net/bpf_jit_comp.c                                     |  802 +++++
 arch/xtensa/configs/common_defconfig                              |    5 -
 crypto/ablkcipher.c                                               |   12 +-
 crypto/aead.c                                                     |   12 +-
 crypto/ahash.c                                                    |    6 +-
 crypto/blkcipher.c                                                |    6 +-
 crypto/crypto_user.c                                              |   22 +-
 crypto/pcompress.c                                                |    6 +-
 crypto/rng.c                                                      |    6 +-
 crypto/shash.c                                                    |    6 +-
 drivers/atm/ambassador.c                                          |    2 +-
 drivers/atm/horizon.c                                             |    5 -
 drivers/atm/idt77252.c                                            |    2 +-
 drivers/block/drbd/drbd_receiver.c                                |    6 +-
 drivers/hv/ring_buffer.c                                          |   31 -
 drivers/ieee802154/Kconfig                                        |    8 +
 drivers/ieee802154/Makefile                                       |    1 +
 drivers/ieee802154/fakelb.c                                       |  294 ++
 drivers/infiniband/core/cma.c                                     |    6 +-
 drivers/infiniband/core/netlink.c                                 |    3 +-
 drivers/infiniband/core/ucma.c                                    |   10 +-
 drivers/isdn/capi/capi.c                                          |   50 +-
 drivers/isdn/capi/capidrv.c                                       |    8 +-
 drivers/isdn/gigaset/bas-gigaset.c                                |   44 +-
 drivers/isdn/gigaset/capi.c                                       |  118 +-
 drivers/isdn/gigaset/common.c                                     |   59 +-
 drivers/isdn/gigaset/dummyll.c                                    |    2 +-
 drivers/isdn/gigaset/ev-layer.c                                   |  319 +-
 drivers/isdn/gigaset/gigaset.h                                    |   30 +-
 drivers/isdn/gigaset/i4l.c                                        |   12 +-
 drivers/isdn/gigaset/isocdata.c                                   |   12 +-
 drivers/isdn/gigaset/ser-gigaset.c                                |   21 +-
 drivers/isdn/gigaset/usb-gigaset.c                                |   19 +-
 drivers/isdn/hardware/eicon/capifunc.c                            |    6 +-
 drivers/isdn/hardware/eicon/capimain.c                            |    4 +-
 drivers/isdn/hardware/eicon/diddfunc.c                            |    8 +-
 drivers/isdn/hardware/eicon/diva_didd.c                           |    6 +-
 drivers/isdn/hardware/eicon/divamnt.c                             |    6 +-
 drivers/isdn/hardware/eicon/divasfunc.c                           |    4 +-
 drivers/isdn/hardware/eicon/divasi.c                              |    8 +-
 drivers/isdn/hardware/eicon/divasmain.c                           |    6 +-
 drivers/isdn/hardware/eicon/idifunc.c                             |   10 +-
 drivers/isdn/hardware/eicon/mntfunc.c                             |    8 +-
 drivers/isdn/hardware/eicon/platform.h                            |    3 -
 drivers/isdn/hardware/mISDN/avmfritz.c                            |  228 +-
 drivers/isdn/hardware/mISDN/hfc_multi.h                           |   15 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c                            |  706 +++--
 drivers/isdn/hardware/mISDN/hfcpci.c                              |  103 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c                             |  137 +-
 drivers/isdn/hardware/mISDN/mISDNipac.c                           |  145 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c                           |  131 +-
 drivers/isdn/hardware/mISDN/netjet.c                              |  218 +-
 drivers/isdn/hardware/mISDN/speedfax.c                            |    5 +-
 drivers/isdn/hardware/mISDN/w6692.c                               |  140 +-
 drivers/isdn/hysdn/hysdn_proclog.c                                |   10 +-
 drivers/isdn/i4l/isdn_bsdcomp.c                                   |    2 +-
 drivers/isdn/mISDN/core.c                                         |   16 +
 drivers/isdn/mISDN/dsp.h                                          |    4 +-
 drivers/isdn/mISDN/dsp_cmx.c                                      |   19 +-
 drivers/isdn/mISDN/dsp_core.c                                     |    1 +
 drivers/isdn/mISDN/dsp_dtmf.c                                     |   19 +-
 drivers/isdn/mISDN/hwchannel.c                                    |  162 +-
 drivers/isdn/mISDN/l1oip_core.c                                   |    2 +-
 drivers/isdn/mISDN/layer1.c                                       |   36 +-
 drivers/isdn/mISDN/layer2.c                                       |  120 +-
 drivers/isdn/mISDN/tei.c                                          |   72 +-
 drivers/message/fusion/mptlan.h                                   |    1 -
 drivers/net/Kconfig                                               |    7 +-
 drivers/net/Makefile                                              |    1 -
 drivers/net/Space.c                                               |   62 +-
 drivers/net/bonding/bond_alb.c                                    |   58 +-
 drivers/net/bonding/bond_main.c                                   |   54 +-
 drivers/net/caif/caif_hsi.c                                       |  350 ++-
 drivers/net/caif/caif_shmcore.c                                   |    4 +
 drivers/net/can/dev.c                                             |   31 +-
 drivers/net/can/pch_can.c                                         |   12 +-
 drivers/net/can/sja1000/ems_pci.c                                 |   14 +-
 drivers/net/can/sja1000/kvaser_pci.c                              |   13 +-
 drivers/net/can/sja1000/peak_pci.c                                |   12 +-
 drivers/net/can/sja1000/plx_pci.c                                 |   13 +-
 drivers/net/ethernet/3com/3c509.c                                 |  123 +-
 drivers/net/ethernet/8390/Kconfig                                 |   25 +-
 drivers/net/ethernet/8390/Makefile                                |    1 -
 drivers/net/ethernet/8390/ax88796.c                               |    1 +
 drivers/net/ethernet/8390/etherh.c                                |    1 +
 drivers/net/ethernet/8390/ne2.c                                   |  798 -----
 drivers/net/ethernet/8390/smc-mca.c                               |  575 ----
 drivers/net/ethernet/Kconfig                                      |    1 +
 drivers/net/ethernet/Makefile                                     |    1 +
 drivers/net/ethernet/adaptec/starfire.c                           |   54 +-
 drivers/net/ethernet/adi/bfin_mac.c                               |   20 +
 drivers/net/ethernet/amd/depca.c                                  |  213 +-
 drivers/net/ethernet/atheros/atl1c/atl1c.h                        |   59 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c                |    9 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c                     |  569 ++--
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h                     |  983 ++++---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c                   | 1007 +++----
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c                   |   17 +-
 drivers/net/ethernet/atheros/atlx/atl1.c                          |  171 +-
 drivers/net/ethernet/atheros/atlx/atl1.h                          |   17 +-
 drivers/net/ethernet/atheros/atlx/atlx.c                          |   15 +-
 drivers/net/ethernet/broadcom/bnx2.c                              |   46 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                       |   45 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                   |  474 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                   |  383 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c               |   38 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h               |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h                   |  268 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h                  |  219 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c                  |  733 ++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h                  |    4 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                  | 1111 ++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h                   |    5 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c                    |  114 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h                    |   39 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c                 |  273 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h                 |   15 +
 drivers/net/ethernet/broadcom/tg3.c                               |   47 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c                        |   61 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc_ct.c                     |  142 +-
 drivers/net/ethernet/brocade/bna/bfi_reg.h                        |    6 +
 drivers/net/ethernet/brocade/bna/bnad.c                           |  316 +-
 drivers/net/ethernet/brocade/bna/bnad.h                           |   11 +-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c                   |    6 +-
 drivers/net/ethernet/cadence/at91_ether.c                         |  535 ++--
 drivers/net/ethernet/cadence/at91_ether.h                         |    1 +
 drivers/net/ethernet/cadence/macb.c                               |    1 +
 drivers/net/ethernet/cirrus/cs89x0.c                              | 2383 ++++++++-------
 drivers/net/ethernet/cisco/enic/enic_main.c                       |   34 +-
 drivers/net/ethernet/cisco/enic/enic_pp.c                         |    2 +-
 drivers/net/ethernet/davicom/Kconfig                              |    2 +-
 drivers/net/ethernet/dec/ewrk3.c                                  |    3 +-
 drivers/net/ethernet/dec/tulip/de2104x.c                          |   34 +-
 drivers/net/ethernet/dec/tulip/de4x5.c                            |    2 +-
 drivers/net/ethernet/dec/tulip/dmfe.c                             |  301 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c                       |   27 +-
 drivers/net/ethernet/dec/tulip/uli526x.c                          |  443 ++-
 drivers/net/ethernet/dec/tulip/winbond-840.c                      |   17 +-
 drivers/net/ethernet/dec/tulip/xircom_cb.c                        |  280 +-
 drivers/net/ethernet/dlink/dl2k.c                                 |  416 ++-
 drivers/net/ethernet/dlink/dl2k.h                                 |   19 +-
 drivers/net/ethernet/dlink/sundance.c                             |   12 +-
 drivers/net/ethernet/dnet.c                                       |    1 +
 drivers/net/ethernet/emulex/benet/be.h                            |   55 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                       |  166 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h                       |  101 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c                    |  326 +-
 drivers/net/ethernet/emulex/benet/be_hw.h                         |   76 +-
 drivers/net/ethernet/emulex/benet/be_main.c                       |  495 ++--
 drivers/net/ethernet/fealnx.c                                     |   14 +-
 drivers/net/ethernet/freescale/fec.c                              |    1 +
 drivers/net/ethernet/freescale/fec_mpc52xx.c                      |    1 +
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c             |    1 +
 drivers/net/ethernet/freescale/gianfar.c                          |   13 +-
 drivers/net/ethernet/freescale/gianfar.h                          |    3 +
 drivers/net/ethernet/freescale/gianfar_ethtool.c                  |   30 +
 drivers/net/ethernet/freescale/gianfar_ptp.c                      |    2 +
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c                 |    1 +
 drivers/net/ethernet/fujitsu/at1700.c                             |  120 +-
 drivers/net/ethernet/i825xx/3c523.c                               | 1312 ---------
 drivers/net/ethernet/i825xx/3c523.h                               |  355 ---
 drivers/net/ethernet/i825xx/3c527.c                               | 1660 -----------
 drivers/net/ethernet/i825xx/3c527.h                               |   81 -
 drivers/net/ethernet/i825xx/Kconfig                               |   22 -
 drivers/net/ethernet/i825xx/Makefile                              |    2 -
 drivers/net/ethernet/i825xx/eexpress.c                            |   60 +-
 drivers/net/ethernet/intel/Kconfig                                |   32 +-
 drivers/net/ethernet/intel/e100.c                                 |    2 +
 drivers/net/ethernet/intel/e1000/e1000_main.c                     |   58 +-
 drivers/net/ethernet/intel/e1000e/80003es2lan.c                   |   21 +-
 drivers/net/ethernet/intel/e1000e/82571.c                         |   41 +-
 drivers/net/ethernet/intel/e1000e/defines.h                       |    8 +
 drivers/net/ethernet/intel/e1000e/e1000.h                         |   51 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c                       |   88 +-
 drivers/net/ethernet/intel/e1000e/hw.h                            |   72 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c                       |  780 ++++-
 drivers/net/ethernet/intel/e1000e/mac.c                           |   12 +-
 drivers/net/ethernet/intel/e1000e/manage.c                        |    2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c                        |  184 +-
 drivers/net/ethernet/intel/e1000e/param.c                         |   10 +-
 drivers/net/ethernet/intel/e1000e/phy.c                           |  115 +-
 drivers/net/ethernet/intel/igb/Makefile                           |    4 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c                      |  276 +-
 drivers/net/ethernet/intel/igb/e1000_82575.h                      |    3 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h                    |   35 +
 drivers/net/ethernet/intel/igb/e1000_hw.h                         |   14 +
 drivers/net/ethernet/intel/igb/e1000_i210.c                       |  603 ++++
 drivers/net/ethernet/intel/igb/e1000_i210.h                       |   76 +
 drivers/net/ethernet/intel/igb/e1000_mac.c                        |    1 +
 drivers/net/ethernet/intel/igb/e1000_nvm.c                        |    1 -
 drivers/net/ethernet/intel/igb/e1000_phy.c                        |  147 +-
 drivers/net/ethernet/intel/igb/e1000_phy.h                        |   22 +
 drivers/net/ethernet/intel/igb/e1000_regs.h                       |   14 +
 drivers/net/ethernet/intel/igb/igb.h                              |   30 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c                      |  141 +-
 drivers/net/ethernet/intel/igb/igb_main.c                         |  299 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c                          |  385 +++
 drivers/net/ethernet/intel/ixgbe/Makefile                         |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                          |   65 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c                    |   92 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c                    |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c                   |  869 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h                   |   19 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c                |   69 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82599.c                |  104 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c                   |   91 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c                  |  122 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c                      |   35 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                     |  439 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                      |   20 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                      |  900 ++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                    |   13 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c                    |  245 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h                     |   97 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c                     |    2 +
 drivers/net/ethernet/intel/ixgbevf/defines.h                      |    2 +
 drivers/net/ethernet/intel/ixgbevf/ethtool.c                      |   18 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h                      |    2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c                 |   30 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c                           |   12 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c                        |    1 +
 drivers/net/ethernet/marvell/pxa168_eth.c                         |    1 +
 drivers/net/ethernet/marvell/sky2.c                               |    4 +-
 drivers/net/ethernet/mellanox/mlx4/Kconfig                        |   12 +
 drivers/net/ethernet/mellanox/mlx4/Makefile                       |    1 +
 drivers/net/ethernet/mellanox/mlx4/cmd.c                          |    7 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c                        |   14 +-
 drivers/net/ethernet/mellanox/mlx4/en_dcb_nl.c                    |  255 ++
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                   |   21 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c                      |    6 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                    |   59 +-
 drivers/net/ethernet/mellanox/mlx4/en_port.h                      |    2 +
 drivers/net/ethernet/mellanox/mlx4/en_resources.c                 |    6 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                        |    4 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                        |   95 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c                           |    3 +-
 drivers/net/ethernet/mellanox/mlx4/main.c                         |   47 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c                          |    2 -
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                         |   32 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                      |   45 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c                           |    5 +-
 drivers/net/ethernet/mellanox/mlx4/pd.c                           |   39 +-
 drivers/net/ethernet/mellanox/mlx4/port.c                         |   69 +-
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c             |  271 +-
 drivers/net/ethernet/micrel/ks8842.c                              |    2 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c                  |    7 +-
 drivers/net/ethernet/natsemi/Kconfig                              |   20 +-
 drivers/net/ethernet/natsemi/Makefile                             |    1 -
 drivers/net/ethernet/natsemi/natsemi.c                            |   67 +-
 drivers/net/ethernet/neterion/s2io.c                              |   14 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c                    |   24 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h                    |   15 +-
 drivers/net/ethernet/nvidia/forcedeth.c                           |    9 +-
 drivers/net/ethernet/nxp/lpc_eth.c                                |    6 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h                   |    1 +
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c              |   64 +-
 drivers/net/ethernet/packetengines/hamachi.c                      |   11 +-
 drivers/net/ethernet/packetengines/yellowfin.c                    |   32 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c                          |    2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h                   |   20 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c               |    5 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c           |   18 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hdr.h               |   26 +
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c              |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c              |  140 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h                       |   63 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c                   |   73 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c               |  208 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hdr.h                   |    6 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c                  |   56 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c                      |    2 +-
 drivers/net/ethernet/rdc/r6040.c                                  |   76 +-
 drivers/net/ethernet/realtek/8139cp.c                             |   21 +-
 drivers/net/ethernet/realtek/8139too.c                            |  136 +-
 drivers/net/ethernet/realtek/r8169.c                              |  698 ++++-
 drivers/net/ethernet/renesas/Kconfig                              |    7 +-
 drivers/net/ethernet/renesas/sh_eth.c                             |  114 +-
 drivers/net/ethernet/renesas/sh_eth.h                             |    5 +-
 drivers/net/ethernet/s6gmac.c                                     |    2 +-
 drivers/net/ethernet/sfc/efx.c                                    |   36 +-
 drivers/net/ethernet/sfc/ethtool.c                                |   37 +-
 drivers/net/ethernet/sfc/mcdi_phy.c                               |   76 +
 drivers/net/ethernet/sfc/net_driver.h                             |    8 +-
 drivers/net/ethernet/sfc/qt202x_phy.c                             |   33 +
 drivers/net/ethernet/sfc/rx.c                                     |   31 +-
 drivers/net/ethernet/silan/sc92031.c                              |   34 +-
 drivers/net/ethernet/sis/sis190.c                                 |   26 +-
 drivers/net/ethernet/sis/sis900.c                                 |  375 +--
 drivers/net/ethernet/smsc/epic100.c                               |  403 ++-
 drivers/net/ethernet/smsc/smsc911x.c                              |    1 +
 drivers/net/ethernet/smsc/smsc9420.c                              |   48 +-
 drivers/net/ethernet/stmicro/stmmac/common.h                      |   22 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h                   |   14 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c              |   15 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c               |   46 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c               |   14 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c                |    6 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h                   |    1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c                   |    8 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c                    |   13 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c                   |   13 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                      |   50 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c              |    1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                 |  163 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c                 |   36 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c                  |    6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c             |   18 +-
 drivers/net/ethernet/sun/niu.c                                    |    2 +-
 drivers/net/ethernet/sun/sungem.c                                 |    4 +-
 drivers/net/ethernet/sun/sunhme.c                                 |   18 +-
 drivers/net/ethernet/sun/sunhme.h                                 |    1 +
 drivers/net/ethernet/sun/sunvnet.c                                |    2 +-
 drivers/net/ethernet/tehuti/tehuti.c                              |    6 +-
 drivers/net/ethernet/ti/davinci_cpdma.c                           |   13 +-
 drivers/net/ethernet/ti/davinci_emac.c                            |    1 +
 drivers/net/ethernet/ti/tlan.c                                    |    2 +-
 drivers/net/ethernet/tile/tilepro.c                               |    2 +-
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c                 |    8 +-
 drivers/net/ethernet/via/via-rhine.c                              |   12 +-
 drivers/net/ethernet/via/via-velocity.c                           |    9 +-
 drivers/net/ethernet/wiznet/Kconfig                               |   73 +
 drivers/net/ethernet/wiznet/Makefile                              |    2 +
 drivers/net/ethernet/wiznet/w5100.c                               |  808 +++++
 drivers/net/ethernet/wiznet/w5300.c                               |  720 +++++
 drivers/net/ethernet/xilinx/ll_temac_main.c                       |    1 +
 drivers/net/ethernet/xscale/Kconfig                               |    6 +-
 drivers/net/ethernet/xscale/Makefile                              |    1 -
 drivers/net/ethernet/xscale/ixp2000/Kconfig                       |    6 -
 drivers/net/ethernet/xscale/ixp2000/Makefile                      |    3 -
 drivers/net/ethernet/xscale/ixp2000/caleb.c                       |  136 -
 drivers/net/ethernet/xscale/ixp2000/caleb.h                       |   22 -
 drivers/net/ethernet/xscale/ixp2000/enp2611.c                     |  232 --
 drivers/net/ethernet/xscale/ixp2000/ixp2400-msf.c                 |  212 --
 drivers/net/ethernet/xscale/ixp2000/ixp2400-msf.h                 |  115 -
 drivers/net/ethernet/xscale/ixp2000/ixp2400_rx.uc                 |  408 ---
 drivers/net/ethernet/xscale/ixp2000/ixp2400_rx.ucode              |  130 -
 drivers/net/ethernet/xscale/ixp2000/ixp2400_tx.uc                 |  272 --
 drivers/net/ethernet/xscale/ixp2000/ixp2400_tx.ucode              |   98 -
 drivers/net/ethernet/xscale/ixp2000/ixpdev.c                      |  437 ---
 drivers/net/ethernet/xscale/ixp2000/ixpdev.h                      |   29 -
 drivers/net/ethernet/xscale/ixp2000/ixpdev_priv.h                 |   57 -
 drivers/net/ethernet/xscale/ixp2000/pm3386.c                      |  351 ---
 drivers/net/ethernet/xscale/ixp2000/pm3386.h                      |   29 -
 drivers/net/ethernet/xscale/ixp4xx_eth.c                          |   29 +
 drivers/net/hippi/rrunner.c                                       |   83 +-
 drivers/net/hyperv/hyperv_net.h                                   |  290 +-
 drivers/net/hyperv/netvsc.c                                       |   41 +-
 drivers/net/hyperv/netvsc_drv.c                                   |    6 +-
 drivers/net/hyperv/rndis_filter.c                                 |   46 +-
 drivers/net/irda/Kconfig                                          |    4 +-
 drivers/net/irda/donauboe.c                                       |    2 +-
 drivers/net/irda/sh_irda.c                                        |    2 +-
 drivers/net/irda/sh_sir.c                                         |    2 +-
 drivers/net/irda/smsc-ircc2.c                                     |    1 -
 drivers/net/macvlan.c                                             |   83 +-
 drivers/net/macvtap.c                                             |   57 +-
 drivers/net/phy/Kconfig                                           |   19 +
 drivers/net/phy/Makefile                                          |    2 +
 drivers/net/phy/bcm63xx.c                                         |    5 +-
 drivers/net/phy/davicom.c                                         |    7 +-
 drivers/net/phy/dp83640.c                                         |   31 +
 drivers/net/phy/marvell.c                                         |   18 +-
 drivers/net/phy/mdio-mux-gpio.c                                   |  142 +
 drivers/net/phy/mdio-mux.c                                        |  192 ++
 drivers/net/phy/mdio_bus.c                                        |   32 +
 drivers/net/phy/phy_device.c                                      |    3 +-
 drivers/net/phy/spi_ks8995.c                                      |    1 -
 drivers/net/ppp/ppp_async.c                                       |    2 +-
 drivers/net/ppp/ppp_generic.c                                     |   14 +-
 drivers/net/ppp/ppp_synctty.c                                     |    4 +-
 drivers/net/ppp/pppoe.c                                           |   18 +-
 drivers/net/ppp/pptp.c                                            |    6 +-
 drivers/net/team/Kconfig                                          |   11 +
 drivers/net/team/Makefile                                         |    1 +
 drivers/net/team/team.c                                           |  523 +++-
 drivers/net/team/team_mode_activebackup.c                         |   20 +-
 drivers/net/team/team_mode_loadbalance.c                          |  174 ++
 drivers/net/team/team_mode_roundrobin.c                           |    2 +-
 drivers/net/tokenring/3c359.c                                     | 1843 ------------
 drivers/net/tokenring/3c359.h                                     |  291 --
 drivers/net/tokenring/Kconfig                                     |  199 --
 drivers/net/tokenring/Makefile                                    |   16 -
 drivers/net/tokenring/abyss.c                                     |  468 ---
 drivers/net/tokenring/abyss.h                                     |   58 -
 drivers/net/tokenring/ibmtr.c                                     | 1964 -------------
 drivers/net/tokenring/ibmtr_cs.c                                  |  370 ---
 drivers/net/tokenring/lanstreamer.c                               | 1917 ------------
 drivers/net/tokenring/lanstreamer.h                               |  343 ---
 drivers/net/tokenring/madgemc.c                                   |  761 -----
 drivers/net/tokenring/madgemc.h                                   |   70 -
 drivers/net/tokenring/olympic.c                                   | 1749 -----------
 drivers/net/tokenring/olympic.h                                   |  321 --
 drivers/net/tokenring/proteon.c                                   |  422 ---
 drivers/net/tokenring/skisa.c                                     |  432 ---
 drivers/net/tokenring/smctr.c                                     | 5717 ------------------------------------
 drivers/net/tokenring/smctr.h                                     | 1585 ----------
 drivers/net/tokenring/tms380tr.c                                  | 2306 ---------------
 drivers/net/tokenring/tms380tr.h                                  | 1141 -------
 drivers/net/tokenring/tmspci.c                                    |  248 --
 drivers/net/tun.c                                                 |    2 +-
 drivers/net/usb/cdc_ether.c                                       |   56 +
 drivers/net/usb/qmi_wwan.c                                        |   39 +-
 drivers/net/usb/rndis_host.c                                      |   83 +-
 drivers/net/usb/smsc75xx.c                                        |   26 +-
 drivers/net/usb/smsc75xx.h                                        |    1 +
 drivers/net/usb/usbnet.c                                          |    1 +
 drivers/net/virtio_net.c                                          |   64 +-
 drivers/net/wan/dscc4.c                                           |   13 +-
 drivers/net/wan/lmc/lmc_main.c                                    |   15 +-
 drivers/net/wimax/i2400m/Kconfig                                  |    3 +-
 drivers/net/wimax/i2400m/usb-rx.c                                 |    2 +-
 drivers/net/wimax/i2400m/usb.c                                    |    2 +-
 drivers/net/wireless/Kconfig                                      |    3 +-
 drivers/net/wireless/Makefile                                     |    4 +-
 drivers/net/wireless/adm8211.c                                    |   17 +-
 drivers/net/wireless/at76c50x-usb.c                               |   12 +-
 drivers/net/wireless/ath/ath5k/ani.c                              |   44 +-
 drivers/net/wireless/ath/ath5k/ath5k.h                            |   31 +-
 drivers/net/wireless/ath/ath5k/attach.c                           |    2 +
 drivers/net/wireless/ath/ath5k/base.c                             |   28 +-
 drivers/net/wireless/ath/ath5k/debug.c                            |   17 +-
 drivers/net/wireless/ath/ath5k/desc.c                             |    6 +-
 drivers/net/wireless/ath/ath5k/dma.c                              |    2 +
 drivers/net/wireless/ath/ath5k/eeprom.c                           |    2 +
 drivers/net/wireless/ath/ath5k/initvals.c                         |    5 +-
 drivers/net/wireless/ath/ath5k/led.c                              |    2 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c                     |    2 +
 drivers/net/wireless/ath/ath5k/pci.c                              |   29 +-
 drivers/net/wireless/ath/ath5k/pcu.c                              |    9 +-
 drivers/net/wireless/ath/ath5k/phy.c                              |    2 +
 drivers/net/wireless/ath/ath5k/qcu.c                              |   10 +-
 drivers/net/wireless/ath/ath5k/reset.c                            |    2 +
 drivers/net/wireless/ath/ath5k/sysfs.c                            |    2 +
 drivers/net/wireless/ath/ath6kl/Makefile                          |    3 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c                        |  419 ++-
 drivers/net/wireless/ath/ath6kl/common.h                          |    4 +-
 drivers/net/wireless/ath/ath6kl/core.c                            |   30 +-
 drivers/net/wireless/ath/ath6kl/core.h                            |   34 +-
 drivers/net/wireless/ath/ath6kl/debug.c                           |    6 +
 drivers/net/wireless/ath/ath6kl/debug.h                           |    1 +
 drivers/net/wireless/ath/ath6kl/hif-ops.h                         |   34 +
 drivers/net/wireless/ath/ath6kl/hif.h                             |    6 +
 drivers/net/wireless/ath/ath6kl/htc-ops.h                         |  113 +
 drivers/net/wireless/ath/ath6kl/htc.h                             |   98 +-
 drivers/net/wireless/ath/ath6kl/{htc.c => htc_mbox.c}             |   85 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c                        | 1713 +++++++++++
 drivers/net/wireless/ath/ath6kl/init.c                            |   59 +-
 drivers/net/wireless/ath/ath6kl/main.c                            |    6 +
 drivers/net/wireless/ath/ath6kl/sdio.c                            |    2 +-
 drivers/net/wireless/ath/ath6kl/testmode.c                        |    5 +-
 drivers/net/wireless/ath/ath6kl/txrx.c                            |   25 +-
 drivers/net/wireless/ath/ath6kl/usb.c                             |  785 ++++-
 drivers/net/wireless/ath/ath6kl/wmi.c                             |   80 +
 drivers/net/wireless/ath/ath6kl/wmi.h                             |   40 +
 drivers/net/wireless/ath/ath9k/Makefile                           |    5 +-
 drivers/net/wireless/ath/ath9k/ani.c                              |   57 +-
 drivers/net/wireless/ath/ath9k/ani.h                              |    6 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c                       |   56 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c                       |    1 +
 drivers/net/wireless/ath/ath9k/ar9002_phy.c                       |    1 -
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h              |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c                     |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                    |  116 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h                    |    1 -
 drivers/net/wireless/ath/ath9k/ar9003_hw.c                        |    5 -
 drivers/net/wireless/ath/ath9k/ar9003_mac.c                       |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                       |   91 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h                       |    3 +
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h              |   16 +-
 drivers/net/wireless/ath/ath9k/ath9k.h                            |    7 +-
 drivers/net/wireless/ath/ath9k/beacon.c                           |   17 +-
 drivers/net/wireless/ath/ath9k/btcoex.c                           |   14 +-
 drivers/net/wireless/ath/ath9k/btcoex.h                           |    1 -
 drivers/net/wireless/ath/ath9k/debug.c                            |  170 +-
 drivers/net/wireless/ath/ath9k/debug.h                            |   44 +
 drivers/net/wireless/ath/ath9k/dfs.c                              |   84 +-
 drivers/net/wireless/ath/ath9k/dfs.h                              |    8 +-
 drivers/net/wireless/ath/ath9k/dfs_debug.c                        |   46 +
 drivers/net/wireless/ath/ath9k/dfs_debug.h                        |   45 +-
 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c             |  300 ++
 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h             |  104 +
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c                 |  452 +++
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h                 |   52 +
 drivers/net/wireless/ath/ath9k/eeprom.c                           |   40 +-
 drivers/net/wireless/ath/ath9k/eeprom.h                           |   14 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c                      |   30 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c                       |   38 +-
 drivers/net/wireless/ath/ath9k/gpio.c                             |   24 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c                          |    2 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                     |   11 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c                          |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c                               |  169 +-
 drivers/net/wireless/ath/ath9k/hw.h                               |   19 +-
 drivers/net/wireless/ath/ath9k/init.c                             |   40 +-
 drivers/net/wireless/ath/ath9k/mac.c                              |   10 +-
 drivers/net/wireless/ath/ath9k/main.c                             |  165 +-
 drivers/net/wireless/ath/ath9k/pci.c                              |    9 +-
 drivers/net/wireless/ath/ath9k/rc.c                               |    7 +-
 drivers/net/wireless/ath/ath9k/recv.c                             |   40 +-
 drivers/net/wireless/ath/carl9170/cmd.h                           |    6 +-
 drivers/net/wireless/ath/carl9170/fw.c                            |    2 +
 drivers/net/wireless/ath/carl9170/rx.c                            |    2 +-
 drivers/net/wireless/ath/main.c                                   |    4 +-
 drivers/net/wireless/ath/regd.c                                   |    4 +-
 drivers/net/wireless/atmel.c                                      |    3 +-
 drivers/net/wireless/atmel_pci.c                                  |   13 +-
 drivers/net/wireless/b43/main.c                                   |   16 +
 drivers/net/wireless/b43/sdio.c                                   |    2 +-
 drivers/net/wireless/b43/xmit.c                                   |    5 +-
 drivers/net/wireless/b43legacy/main.c                             |    2 +
 drivers/net/wireless/b43legacy/xmit.c                             |   15 +-
 drivers/net/wireless/brcm80211/Kconfig                            |    9 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c                  |   97 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c            |  105 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h                     |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c                 |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c              |    4 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c               |  127 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c                |   45 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h               |   22 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                     |    8 -
 drivers/net/wireless/brcm80211/brcmsmac/channel.c                 |   36 +-
 drivers/net/wireless/brcm80211/brcmsmac/d11.h                     |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c             |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c             |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c               |   41 +-
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h              |   40 +-
 drivers/net/wireless/hostap/hostap_main.c                         |    3 +-
 drivers/net/wireless/hostap/hostap_pci.c                          |   16 +-
 drivers/net/wireless/hostap/hostap_plx.c                          |   16 +-
 drivers/net/wireless/ipw2x00/ipw.h                                |   23 +
 drivers/net/wireless/ipw2x00/ipw2100.c                            |  166 +-
 drivers/net/wireless/ipw2x00/ipw2100.h                            |   10 +-
 drivers/net/wireless/ipw2x00/ipw2200.c                            |   57 +-
 drivers/net/wireless/ipw2x00/libipw.h                             |   55 -
 drivers/net/wireless/ipw2x00/libipw_rx.c                          |   16 +-
 drivers/net/wireless/iwlegacy/3945.c                              |    4 +-
 drivers/net/wireless/iwlegacy/4965-mac.c                          |    6 +-
 drivers/net/wireless/iwlegacy/4965-rs.c                           |    2 +-
 drivers/net/wireless/iwlegacy/common.c                            |   14 +-
 drivers/net/wireless/iwlwifi/Kconfig                              |   33 +-
 drivers/net/wireless/iwlwifi/Makefile                             |    6 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c                           |  124 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c                           |  141 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c                           |  282 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c                           |  247 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c                      |   37 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h                      |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-devices.c                    |  755 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h                         |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c                        |  317 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c                         |   84 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h                         |   36 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c                         |  331 +--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c                       |  688 ++++-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c                        |  153 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c                         |   18 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c                         |  191 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c                            | 1267 ++++++--
 drivers/net/wireless/iwlwifi/iwl-agn.h                            |  221 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h                       |   25 +-
 drivers/net/wireless/iwlwifi/{iwl-shared.h => iwl-config.h}       |  282 +-
 drivers/net/wireless/iwlwifi/iwl-core.c                           | 1480 ----------
 drivers/net/wireless/iwlwifi/iwl-core.h                           |  234 --
 drivers/net/wireless/iwlwifi/iwl-csr.h                            |    3 +
 drivers/net/wireless/iwlwifi/iwl-debug.c                          |    1 +
 drivers/net/wireless/iwlwifi/iwl-debug.h                          |   34 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c                        |  509 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h                            |  192 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c                            |  233 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h                            |   25 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c                         |  246 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h                         |   67 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h                        |   15 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h                             |    1 +
 drivers/net/wireless/iwlwifi/iwl-io.h                             |    1 -
 drivers/net/wireless/iwlwifi/iwl-led.c                            |   21 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c                       |  221 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h                      |  126 +
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c                     |   44 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h                     |   21 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                        |   26 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c                            |   65 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c                         |  288 ++
 drivers/net/wireless/iwlwifi/iwl-phy-db.h                         |  129 +
 drivers/net/wireless/iwlwifi/iwl-power.c                          |   85 +-
 drivers/net/wireless/iwlwifi/iwl-power.h                          |    9 -
 drivers/net/wireless/iwlwifi/iwl-scan.c                           |   74 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c                       |  105 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h                 |  233 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c                  |  550 +---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c                  |  334 +--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c                     |  571 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.h                          |  163 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c                          |  172 +-
 drivers/net/wireless/iwmc3200wifi/Kconfig                         |    2 +-
 drivers/net/wireless/libertas/Makefile                            |    1 +
 drivers/net/wireless/libertas/decl.h                              |   11 +-
 drivers/net/wireless/libertas/dev.h                               |   10 +
 drivers/net/wireless/libertas/firmware.c                          |  224 ++
 drivers/net/wireless/libertas/if_cs.c                             |   90 +-
 drivers/net/wireless/libertas/if_sdio.c                           |  229 +-
 drivers/net/wireless/libertas/if_spi.c                            |   11 +-
 drivers/net/wireless/libertas/if_usb.c                            |  265 +-
 drivers/net/wireless/libertas/main.c                              |  117 +-
 drivers/net/wireless/mac80211_hwsim.c                             |   57 +-
 drivers/net/wireless/mwifiex/11n.c                                |   17 +-
 drivers/net/wireless/mwifiex/11n_aggr.c                           |   36 +-
 drivers/net/wireless/mwifiex/Kconfig                              |   15 +-
 drivers/net/wireless/mwifiex/Makefile                             |    3 +
 drivers/net/wireless/mwifiex/cfg80211.c                           |  112 +-
 drivers/net/wireless/mwifiex/cfp.c                                |   31 +
 drivers/net/wireless/mwifiex/cmdevt.c                             |   63 +-
 drivers/net/wireless/mwifiex/debugfs.c                            |    2 +-
 drivers/net/wireless/mwifiex/decl.h                               |    1 +
 drivers/net/wireless/mwifiex/fw.h                                 |   34 +-
 drivers/net/wireless/mwifiex/init.c                               |   66 +-
 drivers/net/wireless/mwifiex/ioctl.h                              |   52 +-
 drivers/net/wireless/mwifiex/join.c                               |   64 +-
 drivers/net/wireless/mwifiex/main.c                               |  132 +-
 drivers/net/wireless/mwifiex/main.h                               |   54 +-
 drivers/net/wireless/mwifiex/pcie.c                               |    3 +
 drivers/net/wireless/mwifiex/scan.c                               |   80 +-
 drivers/net/wireless/mwifiex/sdio.c                               |   10 +
 drivers/net/wireless/mwifiex/sdio.h                               |    9 +-
 drivers/net/wireless/mwifiex/sta_cmd.c                            |  100 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c                        |   80 +-
 drivers/net/wireless/mwifiex/sta_event.c                          |   15 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c                          |  120 +-
 drivers/net/wireless/mwifiex/sta_rx.c                             |   15 +-
 drivers/net/wireless/mwifiex/sta_tx.c                             |   12 +-
 drivers/net/wireless/mwifiex/txrx.c                               |   21 +-
 drivers/net/wireless/mwifiex/usb.c                                | 1052 +++++++
 drivers/net/wireless/mwifiex/usb.h                                |   99 +
 drivers/net/wireless/mwifiex/util.c                               |   22 +
 drivers/net/wireless/mwifiex/wmm.c                                |   18 +-
 drivers/net/wireless/mwl8k.c                                      |   15 +-
 drivers/net/wireless/orinoco/fw.c                                 |    7 +-
 drivers/net/wireless/p54/main.c                                   |   11 +-
 drivers/net/wireless/p54/p54.h                                    |    1 +
 drivers/net/wireless/p54/p54pci.c                                 |   13 +-
 drivers/net/wireless/p54/p54usb.c                                 |  197 +-
 drivers/net/wireless/p54/p54usb.h                                 |    3 +
 drivers/net/wireless/p54/txrx.c                                   |    5 +-
 drivers/net/wireless/prism54/oid_mgt.c                            |    6 +-
 drivers/net/wireless/rndis_wlan.c                                 |  373 ++-
 drivers/net/wireless/rt2x00/rt2400pci.c                           |   13 +-
 drivers/net/wireless/rt2x00/rt2500pci.c                           |   13 +-
 drivers/net/wireless/rt2x00/rt2500usb.c                           |    2 +-
 drivers/net/wireless/rt2x00/rt2800.h                              |    5 +-
 drivers/net/wireless/rt2x00/rt2800lib.c                           |   55 +-
 drivers/net/wireless/rt2x00/rt2800lib.h                           |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c                           |   28 +-
 drivers/net/wireless/rt2x00/rt2800usb.c                           |   25 +-
 drivers/net/wireless/rt2x00/rt2x00.h                              |    4 +-
 drivers/net/wireless/rt2x00/rt2x00config.c                        |    5 +
 drivers/net/wireless/rt2x00/rt2x00debug.c                         |   82 +-
 drivers/net/wireless/rt2x00/rt2x00debug.h                         |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c                           |   11 +-
 drivers/net/wireless/rt2x00/rt2x00leds.c                          |   16 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h                           |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c                           |   10 +
 drivers/net/wireless/rt2x00/rt2x00pci.c                           |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c                         |   47 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c                           |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c                             |   13 +-
 drivers/net/wireless/rt2x00/rt73usb.c                             |    1 +
 drivers/net/wireless/rtl818x/rtl8180/dev.c                        |   13 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c                        |    1 +
 drivers/net/wireless/rtlwifi/base.c                               |    2 +-
 drivers/net/wireless/rtlwifi/cam.c                                |    5 +-
 drivers/net/wireless/rtlwifi/pci.c                                |    2 +
 drivers/net/wireless/rtlwifi/ps.c                                 |    2 +-
 drivers/net/wireless/rtlwifi/rc.c                                 |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c                 |  290 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h                 |   35 -
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c                 |    3 +
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c                |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h                       |   35 -
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c                       |   19 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c                      |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h                      |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c                      |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c                       |    1 +
 drivers/net/wireless/rtlwifi/rtl8192de/def.h                      |   16 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c                       |  185 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.h                       |   51 -
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c                       |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c                      |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c                      |   11 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h                      |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192se/def.h                      |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c                       |  156 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.h                       |   44 -
 drivers/net/wireless/rtlwifi/rtl8192se/fw.h                       |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c                      |    7 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c                       |   19 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c                      |   11 +-
 drivers/net/wireless/rtlwifi/wifi.h                               |   87 +-
 drivers/net/wireless/ti/Kconfig                                   |   14 +
 drivers/net/wireless/ti/Makefile                                  |    4 +
 drivers/net/wireless/{ => ti}/wl1251/Kconfig                      |    0
 drivers/net/wireless/{ => ti}/wl1251/Makefile                     |    0
 drivers/net/wireless/{ => ti}/wl1251/acx.c                        |    0
 drivers/net/wireless/{ => ti}/wl1251/acx.h                        |    0
 drivers/net/wireless/{ => ti}/wl1251/boot.c                       |    0
 drivers/net/wireless/{ => ti}/wl1251/boot.h                       |    0
 drivers/net/wireless/{ => ti}/wl1251/cmd.c                        |    0
 drivers/net/wireless/{ => ti}/wl1251/cmd.h                        |    0
 drivers/net/wireless/{ => ti}/wl1251/debugfs.c                    |    0
 drivers/net/wireless/{ => ti}/wl1251/debugfs.h                    |    0
 drivers/net/wireless/{ => ti}/wl1251/event.c                      |    0
 drivers/net/wireless/{ => ti}/wl1251/event.h                      |    0
 drivers/net/wireless/{ => ti}/wl1251/init.c                       |    0
 drivers/net/wireless/{ => ti}/wl1251/init.h                       |    0
 drivers/net/wireless/{ => ti}/wl1251/io.c                         |    0
 drivers/net/wireless/{ => ti}/wl1251/io.h                         |    0
 drivers/net/wireless/{ => ti}/wl1251/main.c                       |    0
 drivers/net/wireless/{ => ti}/wl1251/ps.c                         |    0
 drivers/net/wireless/{ => ti}/wl1251/ps.h                         |    0
 drivers/net/wireless/{ => ti}/wl1251/reg.h                        |    0
 drivers/net/wireless/{ => ti}/wl1251/rx.c                         |    0
 drivers/net/wireless/{ => ti}/wl1251/rx.h                         |    0
 drivers/net/wireless/{ => ti}/wl1251/sdio.c                       |    0
 drivers/net/wireless/{ => ti}/wl1251/spi.c                        |    0
 drivers/net/wireless/{ => ti}/wl1251/spi.h                        |    0
 drivers/net/wireless/{ => ti}/wl1251/tx.c                         |    0
 drivers/net/wireless/{ => ti}/wl1251/tx.h                         |    0
 drivers/net/wireless/{ => ti}/wl1251/wl1251.h                     |    0
 drivers/net/wireless/{ => ti}/wl1251/wl12xx_80211.h               |    0
 drivers/net/wireless/ti/wl12xx/Kconfig                            |    8 +
 drivers/net/wireless/ti/wl12xx/Makefile                           |    3 +
 drivers/net/wireless/ti/wl12xx/acx.c                              |   53 +
 drivers/net/wireless/ti/wl12xx/acx.h                              |   36 +
 drivers/net/wireless/ti/wl12xx/cmd.c                              |  254 ++
 drivers/net/wireless/ti/wl12xx/cmd.h                              |  112 +
 drivers/net/wireless/ti/wl12xx/conf.h                             |   50 +
 drivers/net/wireless/ti/wl12xx/main.c                             | 1388 +++++++++
 drivers/net/wireless/{ => ti}/wl12xx/reg.h                        |  315 +-
 drivers/net/wireless/ti/wl12xx/wl12xx.h                           |   31 +
 drivers/net/wireless/ti/wlcore/Kconfig                            |   41 +
 drivers/net/wireless/ti/wlcore/Makefile                           |   15 +
 drivers/net/wireless/{wl12xx => ti/wlcore}/acx.c                  |   42 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/acx.h                  |   10 +-
 drivers/net/wireless/ti/wlcore/boot.c                             |  443 +++
 drivers/net/wireless/ti/wlcore/boot.h                             |   54 +
 drivers/net/wireless/{wl12xx => ti/wlcore}/cmd.c                  |  285 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/cmd.h                  |   98 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/conf.h                 |   85 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/debug.h                |    1 +
 drivers/net/wireless/{wl12xx => ti/wlcore}/debugfs.c              |    3 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/debugfs.h              |    2 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/event.c                |   31 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/event.h                |    3 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h                           |  122 +
 drivers/net/wireless/{wl12xx => ti/wlcore}/ini.h                  |    0
 drivers/net/wireless/{wl12xx => ti/wlcore}/init.c                 |   66 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/init.h                 |    2 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/io.c                   |  191 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/io.h                   |   88 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/main.c                 |  824 +-----
 drivers/net/wireless/{wl12xx => ti/wlcore}/ps.c                   |    8 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/ps.h                   |    2 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/rx.c                   |  130 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/rx.h                   |   12 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/scan.c                 |   30 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/scan.h                 |    4 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/sdio.c                 |    6 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/spi.c                  |    4 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/testmode.c             |   12 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/testmode.h             |    0
 drivers/net/wireless/{wl12xx => ti/wlcore}/tx.c                   |  125 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/tx.h                   |    7 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/wl12xx.h               |  271 +-
 drivers/net/wireless/{wl12xx => ti/wlcore}/wl12xx_80211.h         |    0
 drivers/net/wireless/{wl12xx => ti/wlcore}/wl12xx_platform_data.c |    0
 drivers/net/wireless/ti/wlcore/wlcore.h                           |  448 +++
 drivers/net/wireless/wl12xx/Kconfig                               |   48 -
 drivers/net/wireless/wl12xx/Makefile                              |   15 -
 drivers/net/wireless/wl12xx/boot.c                                |  786 -----
 drivers/net/wireless/wl12xx/boot.h                                |  120 -
 drivers/nfc/pn533.c                                               |  228 +-
 drivers/of/of_mdio.c                                              |    2 +
 drivers/pci/quirks.c                                              |   12 +
 drivers/ptp/Kconfig                                               |   10 +-
 drivers/ptp/ptp_clock.c                                           |    6 +
 drivers/ptp/ptp_ixp46x.c                                          |    3 +
 drivers/ptp/ptp_pch.c                                             |    7 +-
 drivers/s390/net/Kconfig                                          |    5 +-
 drivers/s390/net/lcs.c                                            |   21 +-
 drivers/s390/net/qeth_core.h                                      |    4 -
 drivers/s390/net/qeth_core_main.c                                 |    8 +-
 drivers/s390/net/qeth_core_mpc.h                                  |   10 -
 drivers/s390/net/qeth_l3_main.c                                   |   94 +-
 drivers/s390/net/qeth_l3_sys.c                                    |  112 -
 drivers/scsi/iscsi_tcp.c                                          |    2 +-
 drivers/staging/octeon/ethernet-tx.c                              |    2 +-
 drivers/staging/ramster/cluster/tcp.c                             |    2 +-
 drivers/usb/gadget/f_rndis.c                                      |    6 +-
 drivers/usb/gadget/ndis.h                                         |  164 --
 drivers/usb/gadget/rndis.c                                        |  271 +-
 drivers/usb/gadget/rndis.h                                        |   48 +-
 drivers/vhost/net.c                                               |    7 +-
 drivers/vhost/vhost.c                                             |    1 +
 firmware/3com/3C359.bin.ihex                                      | 1573 ----------
 firmware/Makefile                                                 |    2 -
 firmware/WHENCE                                                   |   38 -
 firmware/tr_smctr.bin.ihex                                        |  477 ---
 fs/ocfs2/cluster/tcp.c                                            |    2 +-
 include/linux/Kbuild                                              |    2 -
 include/linux/atmlec.h                                            |    7 -
 include/linux/dcbnl.h                                             |   12 +
 include/linux/dccp.h                                              |    2 +
 include/linux/etherdevice.h                                       |   60 +-
 include/linux/ethtool.h                                           |   69 +-
 include/linux/filter.h                                            |    7 +-
 include/linux/hyperv.h                                            |   27 +
 include/linux/ibmtr.h                                             |  373 ---
 include/linux/ieee80211.h                                         |   36 +-
 include/linux/if_arp.h                                            |    3 +-
 include/linux/if_ec.h                                             |   68 -
 include/linux/if_link.h                                           |    5 +
 include/linux/if_macvlan.h                                        |    1 +
 include/linux/if_pppol2tp.h                                       |   28 +-
 include/linux/if_pppox.h                                          |   20 +-
 include/linux/if_team.h                                           |   67 +-
 include/linux/if_tr.h                                             |  103 -
 include/linux/in6.h                                               |    2 +-
 include/linux/ip_vs.h                                             |   17 +-
 include/linux/ipx.h                                               |    2 +-
 include/linux/l2tp.h                                              |   19 +
 include/linux/mISDNhw.h                                           |   25 +-
 include/linux/mISDNif.h                                           |   16 +-
 include/linux/mdio-mux.h                                          |   21 +
 include/linux/mlx4/cmd.h                                          |    4 +
 include/linux/mlx4/device.h                                       |    3 +
 include/linux/mlx4/qp.h                                           |    3 +-
 include/linux/neighbour.h                                         |    3 +
 include/linux/net.h                                               |   23 +
 include/linux/netdevice.h                                         |   43 +-
 include/linux/netfilter.h                                         |    6 -
 include/linux/netfilter/ipset/ip_set.h                            |   54 +-
 include/linux/netfilter/ipset/ip_set_ahash.h                      |   21 +-
 include/linux/netfilter/ipset/ip_set_timeout.h                    |    4 +
 include/linux/netfilter/nf_conntrack_common.h                     |    4 +
 include/linux/netfilter/nf_conntrack_h323_types.h                 |   12 +-
 include/linux/netfilter/nfnetlink.h                               |    2 +-
 include/linux/netfilter/xt_HMARK.h                                |   45 +
 include/linux/netfilter/xt_hashlimit.h                            |   12 +-
 include/linux/netfilter_ipv4/Kbuild                               |    1 -
 include/linux/netfilter_ipv4/ip_queue.h                           |   72 -
 include/linux/netfilter_ipv6/ip6_tables.h                         |    7 +-
 include/linux/netlink.h                                           |    2 +-
 include/linux/nfc.h                                               |    1 +
 include/linux/nl80211.h                                           |   44 +-
 include/linux/nl802154.h                                          |   20 +
 include/linux/of_mdio.h                                           |    2 +
 include/linux/phy.h                                               |    4 +-
 include/linux/pkt_sched.h                                         |   81 +
 include/linux/platform_data/wiznet.h                              |   24 +
 include/linux/ptp_clock_kernel.h                                  |    8 +
 include/linux/rndis.h                                             |  390 +++
 include/linux/rtnetlink.h                                         |    4 +
 include/linux/skbuff.h                                            |  115 +-
 include/linux/sock_diag.h                                         |    4 +-
 include/linux/socket.h                                            |    4 +-
 include/linux/stmmac.h                                            |   57 +-
 include/linux/tcp.h                                               |   22 +-
 include/linux/trdevice.h                                          |   37 -
 include/linux/usb/rndis_host.h                                    |   66 +-
 include/linux/virtio_net.h                                        |   14 +
 include/net/addrconf.h                                            |   20 +-
 include/net/af_unix.h                                             |    2 +-
 include/net/ax25.h                                                |   10 +-
 include/net/caif/caif_hsi.h                                       |   19 +-
 include/net/caif/cfpkt.h                                          |    9 +-
 include/net/cfg80211.h                                            |   60 +-
 include/net/codel.h                                               |  342 +++
 include/net/compat.h                                              |    8 +-
 include/net/dcbnl.h                                               |    2 +
 include/net/dn.h                                                  |    2 +-
 include/net/dn_fib.h                                              |    6 +-
 include/net/dn_route.h                                            |    4 +-
 include/net/dst_ops.h                                             |    2 +-
 include/net/icmp.h                                                |    3 +-
 include/net/ieee802154_netdev.h                                   |   27 +-
 include/net/if_inet6.h                                            |   56 +-
 include/net/inet6_connection_sock.h                               |    2 +-
 include/net/inet_connection_sock.h                                |    5 +-
 include/net/inet_frag.h                                           |    3 +-
 include/net/ip.h                                                  |   20 -
 include/net/ip6_route.h                                           |    4 +-
 include/net/ip_fib.h                                              |    4 +-
 include/net/ip_vs.h                                               |  105 +-
 include/net/ipip.h                                                |    2 +
 include/net/ipv6.h                                                |   39 +-
 include/net/lapb.h                                                |    6 +
 include/net/llc_c_ev.h                                            |    2 +-
 include/net/llc_pdu.h                                             |    7 -
 include/net/mac80211.h                                            |  171 +-
 include/net/mac802154.h                                           |  136 +
 include/net/ndisc.h                                               |    1 +
 include/net/neighbour.h                                           |    5 +-
 include/net/net_namespace.h                                       |   21 +-
 include/net/netfilter/nf_conntrack.h                              |   10 +-
 include/net/netfilter/nf_conntrack_helper.h                       |    4 +-
 include/net/netfilter/nf_conntrack_l3proto.h                      |    2 +-
 include/net/netlink.h                                             |  169 +-
 include/net/netns/conntrack.h                                     |    3 +
 include/net/netns/hash.h                                          |    2 +-
 include/net/netns/ipv6.h                                          |    4 +-
 include/net/nfc/hci.h                                             |  198 ++
 include/net/nfc/nfc.h                                             |   14 +-
 include/net/nfc/shdlc.h                                           |  104 +
 include/net/pkt_sched.h                                           |    2 +-
 include/net/rawv6.h                                               |    2 +-
 include/net/route.h                                               |    6 +-
 include/net/rtnetlink.h                                           |   11 +-
 include/net/sctp/structs.h                                        |    8 +-
 include/net/sock.h                                                |  174 +-
 include/net/tcp.h                                                 |  116 +-
 include/net/udp.h                                                 |    6 +-
 include/net/wimax.h                                               |    4 +-
 include/net/wpan-phy.h                                            |   10 +-
 include/net/x25.h                                                 |    2 +-
 include/net/xfrm.h                                                |   17 +-
 net/802/Makefile                                                  |    1 -
 net/802/fc.c                                                      |    2 +-
 net/802/fddi.c                                                    |    2 +-
 net/802/garp.c                                                    |    8 +-
 net/802/hippi.c                                                   |    2 +-
 net/802/p8022.c                                                   |    3 +-
 net/802/stp.c                                                     |    2 +-
 net/802/tr.c                                                      |  676 -----
 net/8021q/vlan.c                                                  |   10 +-
 net/8021q/vlan_core.c                                             |    3 +-
 net/8021q/vlan_dev.c                                              |   10 +-
 net/8021q/vlan_netlink.c                                          |   16 +-
 net/9p/client.c                                                   |    6 +-
 net/9p/trans_fd.c                                                 |    2 +-
 net/Kconfig                                                       |    4 +-
 net/Makefile                                                      |    2 +-
 net/appletalk/ddp.c                                               |    6 +-
 net/appletalk/sysctl_net_atalk.c                                  |   10 +-
 net/atm/br2684.c                                                  |    2 +-
 net/atm/ioctl.c                                                   |    8 +-
 net/atm/lec.c                                                     |  144 +-
 net/atm/lec.h                                                     |    1 -
 net/atm/mpc.c                                                     |    3 +-
 net/atm/mpoa_proc.c                                               |    2 +-
 net/atm/pppoatm.c                                                 |   95 +-
 net/atm/signaling.c                                               |    2 +-
 net/ax25/af_ax25.c                                                |    2 -
 net/ax25/ax25_dev.c                                               |   10 +-
 net/ax25/ax25_ip.c                                                |    4 +-
 net/ax25/sysctl_net_ax25.c                                        |   82 +-
 net/batman-adv/Kconfig                                            |   27 +-
 net/batman-adv/Makefile                                           |    1 +
 net/batman-adv/bat_debugfs.c                                      |   23 +-
 net/batman-adv/bat_iv_ogm.c                                       |  257 +-
 net/batman-adv/bat_sysfs.c                                        |  110 +-
 net/batman-adv/bitarray.c                                         |  118 +-
 net/batman-adv/bitarray.h                                         |   26 +-
 net/batman-adv/bridge_loop_avoidance.c                            | 1580 ++++++++++
 net/batman-adv/bridge_loop_avoidance.h                            |   98 +
 net/batman-adv/gateway_client.c                                   |    6 +-
 net/batman-adv/hard-interface.c                                   |  170 +-
 net/batman-adv/icmp_socket.c                                      |    4 +-
 net/batman-adv/main.c                                             |  138 +-
 net/batman-adv/main.h                                             |   19 +-
 net/batman-adv/originator.c                                       |   55 +-
 net/batman-adv/originator.h                                       |    7 +-
 net/batman-adv/packet.h                                           |   50 +-
 net/batman-adv/routing.c                                          |   86 +-
 net/batman-adv/routing.h                                          |    5 +-
 net/batman-adv/send.c                                             |   20 +-
 net/batman-adv/soft-interface.c                                   |  500 +---
 net/batman-adv/soft-interface.h                                   |    2 -
 net/batman-adv/translation-table.c                                |  460 ++-
 net/batman-adv/translation-table.h                                |   12 +-
 net/batman-adv/types.h                                            |  108 +-
 net/batman-adv/unicast.c                                          |    8 +
 net/batman-adv/vis.c                                              |    8 +-
 net/bluetooth/bnep/core.c                                         |    6 +-
 net/bridge/br_device.c                                            |    5 +-
 net/bridge/br_fdb.c                                               |  150 +-
 net/bridge/br_forward.c                                           |    2 +-
 net/bridge/br_input.c                                             |    2 +-
 net/bridge/br_multicast.c                                         |   77 +-
 net/bridge/br_netfilter.c                                         |   38 +-
 net/bridge/br_netlink.c                                           |   39 +-
 net/bridge/br_private.h                                           |   17 +-
 net/bridge/br_private_stp.h                                       |    7 +-
 net/bridge/br_stp.c                                               |    4 +-
 net/bridge/br_stp_bpdu.c                                          |    2 +-
 net/bridge/br_stp_if.c                                            |   11 +-
 net/bridge/br_stp_timer.c                                         |    6 +-
 net/bridge/br_sysfs_br.c                                          |   20 +-
 net/bridge/netfilter/ebt_stp.c                                    |    4 +-
 net/caif/caif_socket.c                                            |   28 +-
 net/caif/cfctrl.c                                                 |    4 +
 net/caif/cfpkt_skbuff.c                                           |    7 +
 net/caif/cfsrvl.c                                                 |    3 +
 net/caif/chnl_net.c                                               |   14 +-
 net/can/gw.c                                                      |    2 +-
 net/ceph/auth_x.h                                                 |    6 +-
 net/ceph/ceph_common.c                                            |    4 +-
 net/ceph/ceph_hash.c                                              |    6 +-
 net/ceph/crush/mapper.c                                           |    9 +-
 net/ceph/debugfs.c                                                |    6 +-
 net/ceph/messenger.c                                              |   16 +-
 net/ceph/mon_client.c                                             |   10 +-
 net/ceph/osd_client.c                                             |    2 +-
 net/ceph/osdmap.c                                                 |   14 +-
 net/compat.c                                                      |   10 +-
 net/core/datagram.c                                               |    6 +-
 net/core/dev.c                                                    |   62 +-
 net/core/dev_addr_lists.c                                         |   97 +-
 net/core/drop_monitor.c                                           |   56 +-
 net/core/ethtool.c                                                |  130 +-
 net/core/fib_rules.c                                              |   32 +-
 net/core/filter.c                                                 |   72 +-
 net/core/gen_stats.c                                              |    3 +-
 net/core/kmap_skb.h                                               |   19 -
 net/core/neighbour.c                                              |  128 +-
 net/core/net-sysfs.c                                              |   13 +-
 net/core/net_namespace.c                                          |    6 +-
 net/core/netprio_cgroup.c                                         |    6 +-
 net/core/pktgen.c                                                 |   68 +-
 net/core/rtnetlink.c                                              |  359 ++-
 net/core/skbuff.c                                                 |  446 ++-
 net/core/sock.c                                                   |   95 +-
 net/core/sock_diag.c                                              |   12 +-
 net/core/sysctl_net_core.c                                        |   15 +-
 net/core/utils.c                                                  |    9 +-
 net/dcb/dcbnl.c                                                   |   94 +-
 net/dccp/ccids/ccid3.c                                            |   12 +-
 net/dccp/dccp.h                                                   |    8 +-
 net/dccp/input.c                                                  |   10 +-
 net/dccp/ipv4.c                                                   |    6 +
 net/dccp/ipv6.c                                                   |    3 +-
 net/dccp/proto.c                                                  |    4 +-
 net/dccp/sysctl.c                                                 |   11 +-
 net/decnet/af_decnet.c                                            |    6 +-
 net/decnet/dn_dev.c                                               |   35 +-
 net/decnet/dn_fib.c                                               |   10 +-
 net/decnet/dn_neigh.c                                             |   22 +-
 net/decnet/dn_nsp_in.c                                            |   13 +-
 net/decnet/dn_nsp_out.c                                           |    9 +-
 net/decnet/dn_route.c                                             |   33 +-
 net/decnet/dn_rules.c                                             |   14 +-
 net/decnet/dn_table.c                                             |    4 +-
 net/decnet/netfilter/dn_rtmsg.c                                   |    3 +-
 net/decnet/sysctl_net_decnet.c                                    |   10 +-
 net/dns_resolver/dns_key.c                                        |    2 +-
 net/dns_resolver/internal.h                                       |    2 +-
 net/dsa/slave.c                                                   |   10 +-
 net/econet/Kconfig                                                |   36 -
 net/econet/Makefile                                               |    7 -
 net/econet/af_econet.c                                            | 1172 --------
 net/ethernet/eth.c                                                |    7 +-
 net/ieee802154/6lowpan.c                                          |   87 +-
 net/ieee802154/6lowpan.h                                          |    3 -
 net/ieee802154/dgram.c                                            |    6 +-
 net/ieee802154/nl-mac.c                                           |  146 +-
 net/ieee802154/nl-phy.c                                           |   38 +-
 net/ieee802154/raw.c                                              |    2 +-
 net/ipv4/Kconfig                                                  |    8 +-
 net/ipv4/af_inet.c                                                |    4 +-
 net/ipv4/ah4.c                                                    |    6 +-
 net/ipv4/arp.c                                                    |   26 +-
 net/ipv4/devinet.c                                                |   66 +-
 net/ipv4/fib_frontend.c                                           |   10 +-
 net/ipv4/fib_rules.c                                              |   16 +-
 net/ipv4/fib_semantics.c                                          |   47 +-
 net/ipv4/icmp.c                                                   |   20 +-
 net/ipv4/igmp.c                                                   |   18 +-
 net/ipv4/inet_connection_sock.c                                   |   29 +-
 net/ipv4/inet_diag.c                                              |    4 +-
 net/ipv4/inet_hashtables.c                                        |    2 +-
 net/ipv4/inet_timewait_sock.c                                     |    6 +-
 net/ipv4/ip_forward.c                                             |    4 +-
 net/ipv4/ip_fragment.c                                            |   45 +-
 net/ipv4/ip_gre.c                                                 |  102 +-
 net/ipv4/ip_input.c                                               |   13 +-
 net/ipv4/ip_options.c                                             |   32 +-
 net/ipv4/ip_output.c                                              |    4 +-
 net/ipv4/ip_sockglue.c                                            |   19 +-
 net/ipv4/ipconfig.c                                               |   20 +-
 net/ipv4/ipip.c                                                   |   57 +-
 net/ipv4/ipmr.c                                                   |   12 +-
 net/ipv4/netfilter.c                                              |   12 +-
 net/ipv4/netfilter/Makefile                                       |    3 -
 net/ipv4/netfilter/arp_tables.c                                   |    7 +-
 net/ipv4/netfilter/ip_queue.c                                     |  639 ----
 net/ipv4/netfilter/ip_tables.c                                    |    5 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                                |    3 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c                    |    7 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c                      |   12 +-
 net/ipv4/netfilter/nf_nat_h323.c                                  |   26 +-
 net/ipv4/netfilter/nf_nat_sip.c                                   |    2 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c                            |    8 +-
 net/ipv4/ping.c                                                   |   10 +-
 net/ipv4/raw.c                                                    |    2 +-
 net/ipv4/route.c                                                  |  160 +-
 net/ipv4/sysctl_net_ipv4.c                                        |   26 +-
 net/ipv4/tcp.c                                                    |  311 +-
 net/ipv4/tcp_cong.c                                               |    6 +-
 net/ipv4/tcp_hybla.c                                              |   10 +-
 net/ipv4/tcp_input.c                                              |  612 ++--
 net/ipv4/tcp_ipv4.c                                               |  116 +-
 net/ipv4/tcp_minisocks.c                                          |   25 +-
 net/ipv4/tcp_output.c                                             |  151 +-
 net/ipv4/tcp_probe.c                                              |    4 +-
 net/ipv4/tcp_timer.c                                              |    5 +
 net/ipv4/udp.c                                                    |   28 +-
 net/ipv4/udp_impl.h                                               |    2 +-
 net/ipv4/xfrm4_policy.c                                           |    6 +-
 net/ipv6/Kconfig                                                  |    4 +-
 net/ipv6/addrconf.c                                               |  202 +-
 net/ipv6/addrconf_core.c                                          |    4 +-
 net/ipv6/addrlabel.c                                              |   26 +-
 net/ipv6/af_inet6.c                                               |   70 +-
 net/ipv6/ah6.c                                                    |   30 +-
 net/ipv6/anycast.c                                                |   12 +-
 net/ipv6/datagram.c                                               |   20 +-
 net/ipv6/esp6.c                                                   |   14 +-
 net/ipv6/exthdrs.c                                                |  101 +-
 net/ipv6/exthdrs_core.c                                           |    5 +-
 net/ipv6/fib6_rules.c                                             |   18 +-
 net/ipv6/icmp.c                                                   |   27 +-
 net/ipv6/inet6_connection_sock.c                                  |    2 +-
 net/ipv6/ip6_fib.c                                                |   25 +-
 net/ipv6/ip6_flowlabel.c                                          |   29 +-
 net/ipv6/ip6_input.c                                              |    9 +-
 net/ipv6/ip6_output.c                                             |   23 +-
 net/ipv6/ip6_tunnel.c                                             |   62 +-
 net/ipv6/ip6mr.c                                                  |   14 +-
 net/ipv6/ipcomp6.c                                                |   15 +-
 net/ipv6/ipv6_sockglue.c                                          |    3 +-
 net/ipv6/mcast.c                                                  |   71 +-
 net/ipv6/mip6.c                                                   |   32 +-
 net/ipv6/ndisc.c                                                  |  252 +-
 net/ipv6/netfilter/Kconfig                                        |   22 -
 net/ipv6/netfilter/Makefile                                       |    1 -
 net/ipv6/netfilter/ip6_queue.c                                    |  641 ----
 net/ipv6/netfilter/ip6_tables.c                                   |   41 +-
 net/ipv6/netfilter/ip6t_REJECT.c                                  |    6 +-
 net/ipv6/netfilter/ip6t_ah.c                                      |    4 +-
 net/ipv6/netfilter/ip6t_frag.c                                    |    4 +-
 net/ipv6/netfilter/ip6t_hbh.c                                     |    4 +-
 net/ipv6/netfilter/ip6t_rt.c                                      |    4 +-
 net/ipv6/netfilter/ip6table_mangle.c                              |    3 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c                    |   12 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c                    |   12 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c                           |   13 +-
 net/ipv6/raw.c                                                    |   10 +-
 net/ipv6/reassembly.c                                             |   47 +-
 net/ipv6/route.c                                                  |   74 +-
 net/ipv6/sit.c                                                    |   70 +-
 net/ipv6/sysctl_net_ipv6.c                                        |   83 +-
 net/ipv6/tcp_ipv6.c                                               |   75 +-
 net/ipv6/tunnel6.c                                                |   10 +-
 net/ipv6/udp.c                                                    |  180 +-
 net/ipv6/xfrm6_policy.c                                           |    4 +-
 net/ipv6/xfrm6_tunnel.c                                           |    6 +-
 net/ipx/af_ipx.c                                                  |   14 +-
 net/ipx/sysctl_net_ipx.c                                          |   11 +-
 net/irda/ircomm/ircomm_tty_ioctl.c                                |    2 +-
 net/irda/irsysctl.c                                               |   10 +-
 net/key/af_key.c                                                  |    4 +-
 net/l2tp/Makefile                                                 |    3 +
 net/l2tp/l2tp_core.c                                              |  525 ++--
 net/l2tp/l2tp_core.h                                              |   57 +-
 net/l2tp/l2tp_debugfs.c                                           |   14 +-
 net/l2tp/l2tp_eth.c                                               |   15 +-
 net/l2tp/l2tp_ip.c                                                |  101 +-
 net/l2tp/l2tp_ip6.c                                               |  787 +++++
 net/l2tp/l2tp_netlink.c                                           |  194 +-
 net/l2tp/l2tp_ppp.c                                               |  206 +-
 net/lapb/lapb_iface.c                                             |   22 +-
 net/lapb/lapb_in.c                                                |  320 +-
 net/lapb/lapb_out.c                                               |   38 +-
 net/lapb/lapb_subr.c                                              |   28 +-
 net/lapb/lapb_timer.c                                             |   32 +-
 net/llc/af_llc.c                                                  |   16 +-
 net/llc/llc_conn.c                                                |    2 +-
 net/llc/llc_output.c                                              |    3 -
 net/llc/llc_sap.c                                                 |    4 -
 net/llc/sysctl_net_llc.c                                          |   52 +-
 net/mac80211/Kconfig                                              |   11 +
 net/mac80211/Makefile                                             |    3 +-
 net/mac80211/agg-rx.c                                             |   31 +-
 net/mac80211/agg-tx.c                                             |   57 +-
 net/mac80211/cfg.c                                                |  267 +-
 net/mac80211/chan.c                                               |   26 -
 net/mac80211/debugfs_netdev.c                                     |   87 +-
 net/mac80211/debugfs_sta.c                                        |    5 +-
 net/mac80211/driver-ops.h                                         |   78 +-
 net/mac80211/driver-trace.h                                       |   70 +-
 net/mac80211/ht.c                                                 |   17 +-
 net/mac80211/ibss.c                                               |   44 +-
 net/mac80211/ieee80211_i.h                                        |   80 +-
 net/mac80211/iface.c                                              |  172 +-
 net/mac80211/main.c                                               |   16 +-
 net/mac80211/mesh.c                                               |   74 +-
 net/mac80211/mesh.h                                               |   37 +-
 net/mac80211/mesh_hwmp.c                                          |   47 +-
 net/mac80211/mesh_pathtbl.c                                       |   14 +-
 net/mac80211/mesh_plink.c                                         |  237 +-
 net/mac80211/mesh_sync.c                                          |  316 ++
 net/mac80211/mlme.c                                               |  379 +--
 net/mac80211/pm.c                                                 |    4 +
 net/mac80211/rate.h                                               |    7 +-
 net/mac80211/rc80211_minstrel.c                                   |   13 +-
 net/mac80211/rc80211_minstrel_ht.c                                |   20 +-
 net/mac80211/rx.c                                                 |   62 +-
 net/mac80211/scan.c                                               |  140 +-
 net/mac80211/sta_info.c                                           |   34 +-
 net/mac80211/sta_info.h                                           |   14 +-
 net/mac80211/status.c                                             |   10 +-
 net/mac80211/tx.c                                                 |  113 +-
 net/mac80211/util.c                                               |  251 +-
 net/mac80211/wme.c                                                |   46 +-
 net/mac80211/wme.h                                                |    3 -
 net/mac80211/work.c                                               |   15 +-
 net/mac802154/Kconfig                                             |   16 +
 net/mac802154/Makefile                                            |    2 +
 net/mac802154/ieee802154_dev.c                                    |  294 ++
 net/mac802154/mac802154.h                                         |  109 +
 net/mac802154/mac_cmd.c                                           |   45 +
 net/mac802154/mib.c                                               |   93 +
 net/mac802154/monitor.c                                           |  116 +
 net/mac802154/rx.c                                                |  114 +
 net/mac802154/tx.c                                                |  116 +
 net/netfilter/Kconfig                                             |   15 +
 net/netfilter/Makefile                                            |    1 +
 net/netfilter/core.c                                              |    9 -
 net/netfilter/ipset/ip_set_bitmap_ip.c                            |   33 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c                         |   47 +-
 net/netfilter/ipset/ip_set_bitmap_port.c                          |   29 +-
 net/netfilter/ipset/ip_set_core.c                                 |   49 +-
 net/netfilter/ipset/ip_set_hash_ip.c                              |   20 +-
 net/netfilter/ipset/ip_set_hash_ipport.c                          |   37 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c                        |   45 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c                       |   69 +-
 net/netfilter/ipset/ip_set_hash_net.c                             |   45 +-
 net/netfilter/ipset/ip_set_hash_netiface.c                        |   52 +-
 net/netfilter/ipset/ip_set_hash_netport.c                         |   61 +-
 net/netfilter/ipset/ip_set_list_set.c                             |   23 +-
 net/netfilter/ipvs/ip_vs_app.c                                    |    2 +-
 net/netfilter/ipvs/ip_vs_conn.c                                   |  104 +-
 net/netfilter/ipvs/ip_vs_core.c                                   |   32 +-
 net/netfilter/ipvs/ip_vs_ctl.c                                    |  214 +-
 net/netfilter/ipvs/ip_vs_dh.c                                     |    4 +-
 net/netfilter/ipvs/ip_vs_ftp.c                                    |    4 +-
 net/netfilter/ipvs/ip_vs_lblc.c                                   |   11 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                                  |   11 +-
 net/netfilter/ipvs/ip_vs_proto.c                                  |   18 +-
 net/netfilter/ipvs/ip_vs_sh.c                                     |    4 +-
 net/netfilter/ipvs/ip_vs_sync.c                                   |  668 +++--
 net/netfilter/ipvs/ip_vs_wrr.c                                    |    2 +-
 net/netfilter/nf_conntrack_acct.c                                 |    4 +-
 net/netfilter/nf_conntrack_amanda.c                               |    3 +-
 net/netfilter/nf_conntrack_core.c                                 |   25 +-
 net/netfilter/nf_conntrack_ecache.c                               |   13 +-
 net/netfilter/nf_conntrack_expect.c                               |    4 +-
 net/netfilter/nf_conntrack_h323_main.c                            |   15 +-
 net/netfilter/nf_conntrack_helper.c                               |  122 +-
 net/netfilter/nf_conntrack_irc.c                                  |    8 +-
 net/netfilter/nf_conntrack_netlink.c                              |   93 +-
 net/netfilter/nf_conntrack_proto.c                                |   10 +-
 net/netfilter/nf_conntrack_proto_dccp.c                           |   22 +-
 net/netfilter/nf_conntrack_proto_generic.c                        |    3 +-
 net/netfilter/nf_conntrack_proto_gre.c                            |    9 +-
 net/netfilter/nf_conntrack_proto_sctp.c                           |   22 +-
 net/netfilter/nf_conntrack_proto_tcp.c                            |   71 +-
 net/netfilter/nf_conntrack_proto_udp.c                            |    9 +-
 net/netfilter/nf_conntrack_proto_udplite.c                        |    9 +-
 net/netfilter/nf_conntrack_standalone.c                           |   14 +-
 net/netfilter/nf_conntrack_timestamp.c                            |    4 +-
 net/netfilter/nf_log.c                                            |    9 +-
 net/netfilter/nfnetlink.c                                         |    2 +-
 net/netfilter/nfnetlink_acct.c                                    |   10 +-
 net/netfilter/nfnetlink_cttimeout.c                               |   11 +-
 net/netfilter/nfnetlink_log.c                                     |  100 +-
 net/netfilter/nfnetlink_queue.c                                   |   68 +-
 net/netfilter/xt_CT.c                                             |    1 -
 net/netfilter/xt_HMARK.c                                          |  362 +++
 net/netfilter/xt_TCPMSS.c                                         |   10 +-
 net/netfilter/xt_TPROXY.c                                         |    4 +-
 net/netfilter/xt_hashlimit.c                                      |  132 +-
 net/netfilter/xt_limit.c                                          |    5 +-
 net/netfilter/xt_mac.c                                            |    2 +-
 net/netfilter/xt_recent.c                                         |    2 +-
 net/netfilter/xt_set.c                                            |   15 +-
 net/netfilter/xt_socket.c                                         |    4 +-
 net/netlink/af_netlink.c                                          |   75 +-
 net/netlink/genetlink.c                                           |   35 +-
 net/netrom/nr_dev.c                                               |    2 +-
 net/netrom/sysctl_net_netrom.c                                    |   10 +-
 net/nfc/Kconfig                                                   |    1 +
 net/nfc/Makefile                                                  |    1 +
 net/nfc/core.c                                                    |  144 +-
 net/nfc/hci/Kconfig                                               |   16 +
 net/nfc/hci/Makefile                                              |    8 +
 net/nfc/hci/command.c                                             |  354 +++
 net/nfc/hci/core.c                                                |  830 ++++++
 net/nfc/hci/hci.h                                                 |  139 +
 net/nfc/hci/hcp.c                                                 |  156 +
 net/nfc/hci/shdlc.c                                               |  945 ++++++
 net/nfc/llcp/commands.c                                           |    8 +-
 net/nfc/llcp/llcp.c                                               |   21 +-
 net/nfc/nci/core.c                                                |    2 +-
 net/nfc/nci/ntf.c                                                 |   11 +-
 net/nfc/netlink.c                                                 |  101 +-
 net/nfc/nfc.h                                                     |    3 +-
 net/nfc/rawsock.c                                                 |    6 +
 net/openvswitch/datapath.c                                        |   34 +-
 net/openvswitch/flow.c                                            |   18 +-
 net/openvswitch/vport-netdev.c                                    |   10 +-
 net/packet/af_packet.c                                            |   50 +-
 net/phonet/af_phonet.c                                            |    2 +-
 net/phonet/pep.c                                                  |    8 +-
 net/phonet/pn_dev.c                                               |    4 +-
 net/phonet/pn_netlink.c                                           |    8 +-
 net/phonet/socket.c                                               |   12 +-
 net/phonet/sysctl.c                                               |   17 +-
 net/rds/ib_sysctl.c                                               |   11 +-
 net/rds/iw_sysctl.c                                               |   11 +-
 net/rds/sysctl.c                                                  |   11 +-
 net/rds/tcp_listen.c                                              |    2 +-
 net/rose/rose_dev.c                                               |    2 +-
 net/rose/rose_subr.c                                              |    2 +-
 net/rose/sysctl_net_rose.c                                        |   10 +-
 net/rxrpc/af_rxrpc.c                                              |    8 +-
 net/rxrpc/ar-ack.c                                                |    6 +-
 net/rxrpc/ar-call.c                                               |    4 +-
 net/rxrpc/ar-input.c                                              |    2 +-
 net/rxrpc/ar-internal.h                                           |   16 +-
 net/rxrpc/ar-key.c                                                |   22 +-
 net/rxrpc/rxkad.c                                                 |    6 +-
 net/sched/Kconfig                                                 |   22 +
 net/sched/Makefile                                                |    2 +
 net/sched/act_api.c                                               |    9 +-
 net/sched/act_csum.c                                              |    8 +-
 net/sched/act_gact.c                                              |    9 +-
 net/sched/act_ipt.c                                               |   21 +-
 net/sched/act_mirred.c                                            |   11 +-
 net/sched/act_nat.c                                               |    6 +-
 net/sched/act_pedit.c                                             |    6 +-
 net/sched/act_police.c                                            |   13 +-
 net/sched/act_simple.c                                            |    8 +-
 net/sched/act_skbedit.c                                           |   27 +-
 net/sched/cls_api.c                                               |    3 +-
 net/sched/cls_basic.c                                             |    5 +-
 net/sched/cls_flow.c                                              |   35 +-
 net/sched/cls_fw.c                                                |   15 +-
 net/sched/cls_route.c                                             |   16 +-
 net/sched/cls_rsvp.h                                              |   16 +-
 net/sched/cls_tcindex.c                                           |   14 +-
 net/sched/cls_u32.c                                               |   43 +-
 net/sched/em_meta.c                                               |   19 +-
 net/sched/ematch.c                                                |   10 +-
 net/sched/sch_api.c                                               |   19 +-
 net/sched/sch_atm.c                                               |   25 +-
 net/sched/sch_cbq.c                                               |   18 +-
 net/sched/sch_choke.c                                             |   13 +-
 net/sched/sch_codel.c                                             |  276 ++
 net/sched/sch_drr.c                                               |    7 +-
 net/sched/sch_dsmark.c                                            |   21 +-
 net/sched/sch_fifo.c                                              |    3 +-
 net/sched/sch_fq_codel.c                                          |  626 ++++
 net/sched/sch_generic.c                                           |   14 +-
 net/sched/sch_gred.c                                              |   18 +-
 net/sched/sch_hfsc.c                                              |    8 +-
 net/sched/sch_htb.c                                               |   12 +-
 net/sched/sch_mqprio.c                                            |    3 +-
 net/sched/sch_multiq.c                                            |    3 +-
 net/sched/sch_netem.c                                             |   39 +-
 net/sched/sch_prio.c                                              |    3 +-
 net/sched/sch_qfq.c                                               |    5 +-
 net/sched/sch_red.c                                               |    5 +-
 net/sched/sch_sfb.c                                               |    3 +-
 net/sched/sch_sfq.c                                               |    3 +-
 net/sched/sch_tbf.c                                               |    3 +-
 net/sched/sch_teql.c                                              |    4 +-
 net/sctp/associola.c                                              |    4 +-
 net/sctp/input.c                                                  |    4 +-
 net/sctp/output.c                                                 |    4 +-
 net/sctp/outqueue.c                                               |    2 +-
 net/sctp/sm_sideeffect.c                                          |    9 +-
 net/sctp/sm_statefuns.c                                           |   22 +-
 net/sctp/socket.c                                                 |    6 +-
 net/sctp/sysctl.c                                                 |   10 +-
 net/socket.c                                                      |   64 +-
 net/sunrpc/auth_gss/gss_krb5_mech.c                               |    2 +-
 net/sunrpc/cache.c                                                |    2 +-
 net/sunrpc/svc.c                                                  |   18 +-
 net/sunrpc/svc_xprt.c                                             |   13 +-
 net/sunrpc/svcsock.c                                              |   30 +-
 net/sunrpc/timer.c                                                |    6 +-
 net/sunrpc/xdr.c                                                  |    2 +-
 net/sunrpc/xprt.c                                                 |    2 +-
 net/sysctl_net.c                                                  |   49 +-
 net/tipc/Makefile                                                 |    2 -
 net/tipc/addr.c                                                   |    3 -
 net/tipc/addr.h                                                   |   19 +-
 net/tipc/bcast.c                                                  |   22 -
 net/tipc/bcast.h                                                  |    3 -
 net/tipc/bearer.c                                                 |   24 +-
 net/tipc/bearer.h                                                 |    4 -
 net/tipc/config.c                                                 |   30 +-
 net/tipc/config.h                                                 |    1 +
 net/tipc/core.c                                                   |   11 +-
 net/tipc/core.h                                                   |   14 -
 net/tipc/discover.c                                               |   14 -
 net/tipc/eth_media.c                                              |   19 -
 net/tipc/handler.c                                                |    1 -
 net/tipc/link.c                                                   |  122 +-
 net/tipc/link.h                                                   |    6 -
 net/tipc/log.c                                                    |   14 -
 net/tipc/log.h                                                    |    1 -
 net/tipc/msg.c                                                    |    3 -
 net/tipc/msg.h                                                    |   21 -
 net/tipc/name_distr.c                                             |  130 +-
 net/tipc/name_table.c                                             |   98 +-
 net/tipc/name_table.h                                             |    3 -
 net/tipc/net.c                                                    |    9 +-
 net/tipc/node.c                                                   |   17 +-
 net/tipc/node.h                                                   |    2 -
 net/tipc/node_subscr.c                                            |    5 +-
 net/tipc/node_subscr.h                                            |    1 -
 net/tipc/port.c                                                   |  130 +-
 net/tipc/port.h                                                   |   14 +-
 net/tipc/ref.c                                                    |   13 -
 net/tipc/socket.c                                                 |  103 +-
 net/tipc/subscr.c                                                 |   45 -
 net/tipc/subscr.h                                                 |    2 -
 net/unix/af_unix.c                                                |   36 +-
 net/unix/diag.c                                                   |    2 +-
 net/unix/sysctl_net_unix.c                                        |   10 +-
 net/wimax/stack.c                                                 |    5 +-
 net/wireless/core.c                                               |    9 +-
 net/wireless/ethtool.c                                            |   29 +
 net/wireless/ibss.c                                               |    2 +-
 net/wireless/lib80211_crypt_ccmp.c                                |   33 +-
 net/wireless/lib80211_crypt_tkip.c                                |   50 +-
 net/wireless/mesh.c                                               |    4 +
 net/wireless/mlme.c                                               |   58 +-
 net/wireless/nl80211.c                                            | 1284 ++++----
 net/wireless/nl80211.h                                            |    4 +
 net/wireless/reg.c                                                |   10 +
 net/wireless/scan.c                                               |   10 +-
 net/wireless/util.c                                               |   21 +-
 net/wireless/wext-compat.c                                        |    3 +-
 net/wireless/wext-core.c                                          |    9 +-
 net/wireless/wext-sme.c                                           |    2 +-
 net/wireless/wext-spy.c                                           |    2 +-
 net/x25/sysctl_net_x25.c                                          |   10 +-
 net/x25/x25_dev.c                                                 |    2 +-
 net/x25/x25_facilities.c                                          |    4 +-
 net/xfrm/Kconfig                                                  |   13 +-
 net/xfrm/Makefile                                                 |    3 +-
 net/xfrm/xfrm_algo.c                                              |    5 +-
 net/xfrm/xfrm_hash.h                                              |    8 +-
 net/xfrm/xfrm_policy.c                                            |   27 +-
 net/xfrm/xfrm_sysctl.c                                            |    2 +-
 net/xfrm/xfrm_user.c                                              |  105 +-
 security/selinux/nlmsgtab.c                                       |   13 -
 tools/virtio/linux/virtio.h                                       |    1 +
 tools/virtio/virtio_test.c                                        |   26 +-
 1503 files changed, 63644 insertions(+), 69679 deletions(-)
 create mode 100644 Documentation/ABI/removed/ip_queue
 create mode 100644 Documentation/devicetree/bindings/net/mdio-mux-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/net/mdio-mux.txt
 delete mode 100644 Documentation/networking/3c359.txt
 delete mode 100644 Documentation/networking/olympic.txt
 delete mode 100644 Documentation/networking/smctr.txt
 delete mode 100644 Documentation/networking/tms380tr.txt
 create mode 100644 Documentation/nfc/nfc-hci.txt
 create mode 100644 arch/sparc/net/Makefile
 create mode 100644 arch/sparc/net/bpf_jit.h
 create mode 100644 arch/sparc/net/bpf_jit_asm.S
 create mode 100644 arch/sparc/net/bpf_jit_comp.c
 create mode 100644 drivers/ieee802154/fakelb.c
 delete mode 100644 drivers/net/ethernet/8390/ne2.c
 delete mode 100644 drivers/net/ethernet/8390/smc-mca.c
 delete mode 100644 drivers/net/ethernet/i825xx/3c523.c
 delete mode 100644 drivers/net/ethernet/i825xx/3c523.h
 delete mode 100644 drivers/net/ethernet/i825xx/3c527.c
 delete mode 100644 drivers/net/ethernet/i825xx/3c527.h
 create mode 100644 drivers/net/ethernet/intel/igb/e1000_i210.c
 create mode 100644 drivers/net/ethernet/intel/igb/e1000_i210.h
 create mode 100644 drivers/net/ethernet/intel/igb/igb_ptp.c
 create mode 100644 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
 create mode 100644 drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx4/en_dcb_nl.c
 create mode 100644 drivers/net/ethernet/wiznet/Kconfig
 create mode 100644 drivers/net/ethernet/wiznet/Makefile
 create mode 100644 drivers/net/ethernet/wiznet/w5100.c
 create mode 100644 drivers/net/ethernet/wiznet/w5300.c
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/Kconfig
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/Makefile
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/caleb.c
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/caleb.h
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/enp2611.c
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/ixp2400-msf.c
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/ixp2400-msf.h
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/ixp2400_rx.uc
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/ixp2400_rx.ucode
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/ixp2400_tx.uc
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/ixp2400_tx.ucode
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/ixpdev.c
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/ixpdev.h
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/ixpdev_priv.h
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/pm3386.c
 delete mode 100644 drivers/net/ethernet/xscale/ixp2000/pm3386.h
 create mode 100644 drivers/net/phy/mdio-mux-gpio.c
 create mode 100644 drivers/net/phy/mdio-mux.c
 create mode 100644 drivers/net/team/team_mode_loadbalance.c
 delete mode 100644 drivers/net/tokenring/3c359.c
 delete mode 100644 drivers/net/tokenring/3c359.h
 delete mode 100644 drivers/net/tokenring/Kconfig
 delete mode 100644 drivers/net/tokenring/Makefile
 delete mode 100644 drivers/net/tokenring/abyss.c
 delete mode 100644 drivers/net/tokenring/abyss.h
 delete mode 100644 drivers/net/tokenring/ibmtr.c
 delete mode 100644 drivers/net/tokenring/ibmtr_cs.c
 delete mode 100644 drivers/net/tokenring/lanstreamer.c
 delete mode 100644 drivers/net/tokenring/lanstreamer.h
 delete mode 100644 drivers/net/tokenring/madgemc.c
 delete mode 100644 drivers/net/tokenring/madgemc.h
 delete mode 100644 drivers/net/tokenring/olympic.c
 delete mode 100644 drivers/net/tokenring/olympic.h
 delete mode 100644 drivers/net/tokenring/proteon.c
 delete mode 100644 drivers/net/tokenring/skisa.c
 delete mode 100644 drivers/net/tokenring/smctr.c
 delete mode 100644 drivers/net/tokenring/smctr.h
 delete mode 100644 drivers/net/tokenring/tms380tr.c
 delete mode 100644 drivers/net/tokenring/tms380tr.h
 delete mode 100644 drivers/net/tokenring/tmspci.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc-ops.h
 rename drivers/net/wireless/ath/ath6kl/{htc.c => htc_mbox.c} (96%)
 create mode 100644 drivers/net/wireless/ath/ath6kl/htc_pipe.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pattern_detector.h
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_pri_detector.h
 create mode 100644 drivers/net/wireless/ipw2x00/ipw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-devices.c
 rename drivers/net/wireless/iwlwifi/{iwl-shared.h => iwl-config.h} (51%)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-core.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-core.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-modparams.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-phy-db.h
 create mode 100644 drivers/net/wireless/libertas/firmware.c
 create mode 100644 drivers/net/wireless/mwifiex/usb.c
 create mode 100644 drivers/net/wireless/mwifiex/usb.h
 create mode 100644 drivers/net/wireless/ti/Kconfig
 create mode 100644 drivers/net/wireless/ti/Makefile
 rename drivers/net/wireless/{ => ti}/wl1251/Kconfig (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/Makefile (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/acx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/acx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/boot.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/boot.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/cmd.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/cmd.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/debugfs.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/debugfs.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/event.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/event.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/init.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/init.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/io.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/io.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/main.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/ps.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/ps.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/reg.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/rx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/rx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/sdio.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/spi.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/spi.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/tx.c (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/tx.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/wl1251.h (100%)
 rename drivers/net/wireless/{ => ti}/wl1251/wl12xx_80211.h (100%)
 create mode 100644 drivers/net/wireless/ti/wl12xx/Kconfig
 create mode 100644 drivers/net/wireless/ti/wl12xx/Makefile
 create mode 100644 drivers/net/wireless/ti/wl12xx/acx.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/acx.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/cmd.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/cmd.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/conf.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/main.c
 rename drivers/net/wireless/{ => ti}/wl12xx/reg.h (71%)
 create mode 100644 drivers/net/wireless/ti/wl12xx/wl12xx.h
 create mode 100644 drivers/net/wireless/ti/wlcore/Kconfig
 create mode 100644 drivers/net/wireless/ti/wlcore/Makefile
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/acx.c (97%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/acx.h (99%)
 create mode 100644 drivers/net/wireless/ti/wlcore/boot.c
 create mode 100644 drivers/net/wireless/ti/wlcore/boot.h
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/cmd.c (84%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/cmd.h (87%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/conf.h (94%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/debug.h (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/debugfs.c (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/debugfs.h (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/event.c (91%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/event.h (98%)
 create mode 100644 drivers/net/wireless/ti/wlcore/hw_ops.h
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/ini.h (100%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/init.c (93%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/init.h (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/io.c (55%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/io.h (71%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/main.c (85%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/ps.c (97%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/ps.h (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/rx.c (69%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/rx.h (92%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/scan.c (95%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/scan.h (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/sdio.c (98%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/spi.c (99%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/testmode.c (96%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/testmode.h (100%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/tx.c (90%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/tx.h (97%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/wl12xx.h (68%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/wl12xx_80211.h (100%)
 rename drivers/net/wireless/{wl12xx => ti/wlcore}/wl12xx_platform_data.c (100%)
 create mode 100644 drivers/net/wireless/ti/wlcore/wlcore.h
 delete mode 100644 drivers/net/wireless/wl12xx/Kconfig
 delete mode 100644 drivers/net/wireless/wl12xx/Makefile
 delete mode 100644 drivers/net/wireless/wl12xx/boot.c
 delete mode 100644 drivers/net/wireless/wl12xx/boot.h
 delete mode 100644 firmware/3com/3C359.bin.ihex
 delete mode 100644 firmware/tr_smctr.bin.ihex
 delete mode 100644 include/linux/ibmtr.h
 delete mode 100644 include/linux/if_ec.h
 delete mode 100644 include/linux/if_tr.h
 create mode 100644 include/linux/mdio-mux.h
 create mode 100644 include/linux/netfilter/xt_HMARK.h
 delete mode 100644 include/linux/netfilter_ipv4/ip_queue.h
 create mode 100644 include/linux/platform_data/wiznet.h
 create mode 100644 include/linux/rndis.h
 delete mode 100644 include/linux/trdevice.h
 create mode 100644 include/net/codel.h
 create mode 100644 include/net/mac802154.h
 create mode 100644 include/net/nfc/hci.h
 create mode 100644 include/net/nfc/shdlc.h
 delete mode 100644 net/802/tr.c
 create mode 100644 net/batman-adv/bridge_loop_avoidance.c
 create mode 100644 net/batman-adv/bridge_loop_avoidance.h
 delete mode 100644 net/core/kmap_skb.h
 delete mode 100644 net/econet/Kconfig
 delete mode 100644 net/econet/Makefile
 delete mode 100644 net/econet/af_econet.c
 delete mode 100644 net/ipv4/netfilter/ip_queue.c
 delete mode 100644 net/ipv6/netfilter/ip6_queue.c
 create mode 100644 net/l2tp/l2tp_ip6.c
 create mode 100644 net/mac80211/mesh_sync.c
 create mode 100644 net/mac802154/Kconfig
 create mode 100644 net/mac802154/Makefile
 create mode 100644 net/mac802154/ieee802154_dev.c
 create mode 100644 net/mac802154/mac802154.h
 create mode 100644 net/mac802154/mac_cmd.c
 create mode 100644 net/mac802154/mib.c
 create mode 100644 net/mac802154/monitor.c
 create mode 100644 net/mac802154/rx.c
 create mode 100644 net/mac802154/tx.c
 create mode 100644 net/netfilter/xt_HMARK.c
 create mode 100644 net/nfc/hci/Kconfig
 create mode 100644 net/nfc/hci/Makefile
 create mode 100644 net/nfc/hci/command.c
 create mode 100644 net/nfc/hci/core.c
 create mode 100644 net/nfc/hci/hci.h
 create mode 100644 net/nfc/hci/hcp.c
 create mode 100644 net/nfc/hci/shdlc.c
 create mode 100644 net/sched/sch_codel.c
 create mode 100644 net/sched/sch_fq_codel.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
