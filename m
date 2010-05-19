Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0ESGh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:37:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55618
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab0ESGhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:37:46 -0400
Date: Tue, 18 May 2010 23:37:52 -0700 (PDT)
Message-Id: <20100518.233752.256882583.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4J6c9aS006439


The biggest two things in here are RPS (Receive Packet Steering) and
RFS (Receive Flow Steering) support from Tom Herbert et al. at Google.

RPS allows one to specify a cpu mask per device RX queue, and we will
steer RX packet work, in software, to those cpus.  RPS essentially
provides in software what many modern cards can do in hardware with
the added flexibility of being able to constrain CPU targets
arbitrarily.  RPS is also, therefore, not in conflict with cards that
can flow distribute to cpus completely in hardware.

RFS tries to be even more sophisticated than RPS.  It watches on which
cpu a socket makes I/O calls, and will steer future RX packets to that
cpu.  In this way RX packet work is done near to where the application
will actually process the data.

In both the case of RPS and RFS, if the device provides a flow hash
(just about every modern card does), we make use of it instead of
computing it in software.

RPS/RFS has been found to even help for things like tbench over
loopback.

Eric Dumazet has been busy, as usual, avoiding unnecessary atomic
operations and false sharing in the hot paths.  Particularly in UDP.
A lot of these issues showed up now that we have RPS/RFS, which
tended to clean out the profiles.

Some other things that stand out:

1) Allow the administrator to reserve port ranges, such that the
   kernel bind allocation scheme won't use them.  From Amerigo Wang.

2) ipv6 address et al. handling converted to use generic kernel lists.
   From Stephem Hemminger.

3) PHY module autoloading support from David Howells

4) Device address (multicast, unicast) list traversal is formalized.
   From Jiri Pirko.

5) Support for multiple multicast routing tables, from Patrick McHardy.

6) New protocol stack, CAIF (a MUX protocol developed by ST-Ericsson
   for modems).  Via Sjur Braendeland.

7) Cache bundles instead of policies in the IPSEC flow cache, by
   Timo Ter√§s.

8) IPV6 bridge multicast snooping support from YOSHIFUJI Hideaki.

The majority of the rest is driver stuff, as it usually is.

Please pull, thanks a lot!

The following changes since commit 537b60d17894b7c19a6060feae40299d7109d6e7:
  Linus Torvalds (1):
        Merge branch 'x86-uv-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Abhijeet Kolekar (7):
      iwl3945: check ucode load error code
      iwlwifi: add debugfs ops to iwlwifi
      iwlwifi: reset pci retry timeout
      iwl3945: add ucode statistics
      iwl3945: fix scan races
      iwl3945: add plcp error checking
      mac80211: fix paged defragmentation

Adam Nielsen (1):
      netfilter: xt_LED: add refcounts to LED target

Alan Cox (2):
      caif: check write operations
      caif: tty's are kref objects so take a reference

Alban Browaeys (2):
      rt2x00: txdone implementation supporting hw encryption.
      rt2x00: Fix TX status reporting for rt2800pci.

Alexander Duyck (9):
      igb: Do not overwrite mdicnfg register when accessing 82580 phy
      igb: cleanup usage of virtualization registers
      igb: add support for Intel I350 Gigabit Network Connection
      igb: update hw_debug macro to make use of netdev_dbg call
      igb: modify register test for i350 to reflect read only bits in RDLEN/TDLEN
      skbuff: remove unused dev_consume_skb macro definition
      igb: add support for reporting 5GT/s during probe on PCIe Gen2
      igb: convert igb from using PCI DMA functions to using DMA API functions
      e1000e: increase rx fifo size to 36K on 82574 and 82583

Alexander Kurz (1):
      net/pcmcia/3c589_cs: using netdev_info and friends where appropriate

Alexey Dobriyan (4):
      netfilter: nf_conntrack: restrict runtime expect hashsize modifications
      netfilter: xtables: compat out of scope fix
      netfilter: xtables: make XT_ALIGN() usable in exported headers by exporting __ALIGN_KERNEL()
      Restore __ALIGN_MASK()

Allan Stephens (16):
      tipc: Eliminate obsolete port's "congested_link" field
      tipc: Eliminate unused argument in print statement
      tipc: Prune unused data structures from configuration service
      tipc: Eliminate unnecessary initialization in native API send routines
      tipc: Rename "multicast-link" to "broadcast-link"
      tipc: Add support for "-s" configuration option
      tipc: Update commenting in TIPC API
      tipc: remove abstraction for link_max_pkt
      tipc: Relocate trivial link status functions to header file
      tipc: add tipc_ prefix to fcns targeted for un-inlining
      tipc: Reduce footprint by un-inlining address routines
      tipc: Reduce footprint by un-inlining nmap routines
      tipc: Reduce footprint by un-inlining port list routines
      tipc: Reduce footprint by un-inlining bearer congestion routine
      tipc: Reduce footprint by un-inlining buf_acquire routine
      tipc: Reduce footprint by un-inlining tipc_msg_* routines

Amerigo Wang (3):
      netconsole: do not depend on experimental
      sysctl: refactor integer handling proc code
      net: reserve ports for applications using fixed port numbers

Amit Kumar Salecha (27):
      netxen: fix corner cases of firmware recovery
      netxen: fix fw load from file
      netxen: fix interrupt for NX2031
      qlcnic: fix fw load from file
      qlcnic: add driver debug support
      qlcnic: fix interface attach sequence
      qlcnic: fix endianness in fw validation
      qlcnic: update version to 5.0.1
      qlcnic: additional driver statistics
      qlcnic: fix defines as per IDC document
      qlcnic: fix fw initialization responsibility
      qlcnic: define macro for driver state
      qlcnic: fix pci semaphore checks
      qlcnic: fix rcv buffer leak
      qlcnic: protect resource access
      qlcnic: update version 5.0.2
      netxen: fix register usage
      netxen: handle queue manager access
      qlcnic: fix context cleanup
      qlcnic: remove obsolete register
      qlcnic: fix caching window register
      qlcnic: cleanup dma mask setting
      qlcnic: cleanup unused code
      qlcnic: module param for firmware load option
      qlcnic: remove unused register
      qlcnic: mark device state fail
      qlcnic: adding co maintainer

Amitkumar Karwar (1):
      libertas: add auto auth mode feature

Andrea Gelmini (1):
      netfilter: include/linux/netfilter/nf_conntrack_tuple_common.h: Checkpatch cleanup

Andreas Bombe (1):
      ARCNET: Limit com20020 PCI ID matches for SOHARD cards

Andres Salomon (1):
      mac80211: give warning if building w/out rate ctrl algorithm

Andrew Blaich (1):
      ath5k: fixing retries in ath5k_hw_setup_4word_tx_desc

Andrew Hendry (1):
      X25: Add if_x25.h and x25 to device identifiers

Andy Grover (9):
      RDS: Do not BUG() on error returned from ib_post_send
      RDS: sendmsg() should check sndtimeo, not rcvtimeo
      RDS: update copy_to_user state in tcp transport
      RDS/TCP: Wait to wake thread when write space available
      RDS: Fix congestion issues for loopback
      RDS: Workaround for in-use MRs on close causing crash
      RDS: Turn down alarming reconnect messages
      RDS: only put sockets that have seen congestion on the poll_waitq
      RDS: Do not call set_page_dirty() with irqs off

Anirban Chakraborty (1):
      qlcnic: fix memory leaks

Anjali Singhai (1):
      ixgbe: Properly display 1 gig downshift warning for backplane

Anton Vorontsov (2):
      gianfar: Remove legacy PM callbacks
      fsl_pq_mdio: Fix mdiobus allocation handling

Barry Song (1):
      netdev: bfin_mac: add support for IEEE 1588 PTP

Bart De Schuymer (6):
      netfilter: bridge-netfilter: cleanup br_netfilter.c
      netfilter: bridge-netfilter: update a comment in br_forward.c about ip_fragment()
      netfilter: bridge-netfilter: simplify IP DNAT
      netfilter: bridge-netfilter: Fix MAC header handling with IP DNAT
      netfilter: bridge-netfilter: fix refragmenting IP traffic encapsulated in PPPoE traffic
      netfilter: bridge-netfilter: fix crash in br_nf_forward_finish()

Baruch Siach (1):
      dm9000: fix "BUG: spinlock recursion"

Ben Hutchings (11):
      3c503: Fix IRQ probing
      sfc: Consistently report short MCDI responses as EIO
      sfc: Log specific message for failure of NVRAM self-test
      sfc: Enable IPv6 RSS using random key for Toeplitz hash
      sfc: Update MCDI protocol definitions
      sfc: Break NAPI processing after one ring-full of TX completions
      sfc: Add necessary parentheses to macro definitions in net_driver.h
      sfc: Clean up efx_nic::irq_zero_count
      sfc: Test only the first pair of TX queues
      sfc: Create multiple TX queues
      rndis_host: Poll status channel before control channel

Ben M Cahill (1):
      iwlagn: Add Flow-handler (FH) register dump for 4965.

Benoit Papillault (3):
      ath5k: Fix TX/RX padding for all frames
      ath5k/ath9k: Fix 64 bits TSF reads
      ath9k: Added get_survey callback in order to get channel noise

Bing Zhao (3):
      Bluetooth: Decode btmrvl MODULE_BRINGUP_REG response correctly
      Bluetooth: Separate btmrvl_register_hdev() from btmrvl_add_card()
      Bluetooth: Set hdev->dev_type based on Marvell device type

Bj√∏rn Mork (1):
      ipv6: udp: make short packet logging consistent with ipv4

Bob Copeland (4):
      ath5k: correct channel setting for 2.5 mhz spacing
      ath5k: clean up queue manipulation
      ath5k: fix race condition in tx desc processing
      ath5k: add bounds check to pdadc table

Brian Haley (4):
      SCTP: Change to use ipv6_addr_copy()
      IPv6: data structure changes for new socket options
      IPv6: Add dontfrag argument to relevant functions
      IPv6: Complete IPV6_DONTFRAG support

Brian King (1):
      ibmveth: Add suspend/resume support

Bruce Allan (15):
      e1000e: Use pr_<level> and netdev_<level>
      e1000e: reset MAC-PHY interconnect on 82577/82578 during Sx->S0
      e1000e: Reset 82577/82578 PHY before first PHY register read
      e1000e: use static params to save stack space (part 2)
      e1000e: bad state after running ethtool diagnostics with AMT enabled
      e1000e: initialize manageability (IPMI) pass-through in 82574/82583
      e1000e: s/w initiated LSC MSI-X interrupts not generated; no transmit
      e1000e: cleanup multiple common exit points
      e1000e: Remove EN_MAC_ADDR_FILTER check from enable_mng_pass_thru check
      e1000e: Cleanup e1000_sw_lcd_config_ich8lan()
      e1000e: Incorrect function pointer set for force_speed_duplex on 82577
      e1000e: fix checks for manageability enabled and management pass-through
      e1000e: move settting of flow control refresh timer to link setup code
      e1000e: Fix/cleanup PHY reset code for ICHx/PCHx
      e1000e: add PCI device id to enable support for 82567V-4

Bruno Randolf (23):
      mac80211: fix rates setup on IBSS merge
      ath5k: add antenna statistics and debugfs file for antenna settings
      ath5k: preserve antenna settings
      ath5k: remove double opmode definition
      ath5k: remove ah_magic
      ath5k: remove ah_mac_revision
      ath5k: remove ah_gpio_npins
      ath5k: add debugfs file frameerrors
      ath5k: IQ calibration for AR5211 is slightly different
      ath5k: Minor EEPROM documentation updates
      mac80211: (really) fix rates setup on IBSS merge
      ath5k: remove static calibration interval variable
      ath5k: remove the use of SWI interrupt
      ath5k: optimize ath5k_hw_calibration_poll
      ath5k: move ath5k_hw_calibration_poll to base.c
      ath5k: keep beacon RSSI average
      ath5k: initialize default noise floor
      ath5k: simplify MIB counters
      ath5k: update phy errors codes
      ath5k: add capability flag for phyerror counters
      ath5k: Adaptive Noise Immunity (ANI) Implementation
      ath5k: Use high bitrates for ACK/CTS
      ath5k: treat RXORN as non-fatal

Bryan Wu (1):
      netdev/fec.c: add phylib supporting to enable carrier detection (v2)

Changli Gao (7):
      rps: keep the old behavior on SMP without rps
      net: CONFIG_SMP should be CONFIG_RPS
      rps: optimize rps_get_cpu()
      net: reimplement softnet_data.output_queue as a FIFO queue
      net: batch skb dequeueing from softnet input_pkt_queue
      xfrm: potential uninitialized variable num_xfrms
      net: fix softnet_stat

Christian Lamparter (5):
      p54: Enable HW_REPORTS_TX_ACK_STATUS
      ar9170usb: fix panic triggered by undersized rxstream buffer
      ar9170usb: add a couple more USB IDs
      p54pci: fix serious sparse warning
      ar9170usb: remove deprecated aggregation code

Christoph Hellwig (1):
      vhost: fix sparse warnings

Cindy H Kao (6):
      wimax/i2400m: fix the race condition for accessing TX queue
      wimax/i2400m: correct the error path handlers in dev_start()
      wimax/i2400m: fix for missed reset events if triggered by dev_reset_handle()
      wimax/i2400m: add the error recovery mechanism on TX path
      wimax/i2400m: Correct the error path handlers order in i2400m_post_reset()
      wimax/i2400m: Reset the TX FIFO indices when allocating the TX FIFO in tx_setup()

Dan Carpenter (21):
      bridge: cleanup: remove unused assignment
      stmmac: use resource_size()
      ewrk3: range checking problem
      korina: use resource_size()
      mac80211: remove unneed variable from ieee80211_tx_pending()
      llc: cleanup: remove dead code from llc_init()
      wimax: remove unneeded variable
      rds: cleanup: remove unneeded variable
      iwl: cleanup: remove unneeded error handling
      ipv6: cleanup: remove unneeded null check
      sctp: cleanup: remove duplicate assignment
      Bluetooth: Fix storing negative values as unsigned char
      iwlwifi: remove stray mutex_unlock()
      ath9k/htc_drv_main: null dereference typo
      ath9k/htc_drv_main: off by one error
      ath5k: several off by one range checks
      wl1271: add missing spin_lock()
      wl1271: fix notifier interface supported test
      wl1271: remove some unneeded code
      wimax: checking ERR_PTR vs null
      wimax: wimax_msg_alloc() returns ERR_PTR not null

Dan Williams (3):
      libertas: consolidate SDIO firmware wait code
      libertas: Davinci platforms need more time loading helper firmware
      libertas: fix 8686 firmware loading regression

Daniel Halperin (2):
      mac80211: fix typo in comments
      iwlwifi: set AMPDU status variables correctly

Daniel Mack (1):
      libertas/sdio: 8686: set ECSI bit for 1-bit transfers

Daniel Ngu (1):
      drivers/net/wireless/b43/main.c:4351: Fixed coding style

Daniel Yingqiang Ma (1):
      ath9k: Group Key fix for VAPs

David Daney (6):
      netdev: octeon_mgmt: Use proper MAC addresses.
      netdev: octeon_mgmt: Fix race condition freeing TX buffers.
      netdev: octeon_mgmt: Fix race manipulating irq bits.
      netdev: octeon_mgmt: Free TX skbufs in a timely manner.
      netdev: octeon_mgmt: Try not to drop TX packets when stopping the queue.
      netdev: octeon_mgmt: Remove some gratuitous blank lines.

David Kilroy (10):
      orinoco: implement set_wiphy_params
      orinoco: use cfg80211_find_ie
      orinoco: have sparse check endian issues
      orinoco: add hermes_ops
      orinoco: allow driver to specify netdev_ops
      orinoco: encapsulate driver locking
      orinoco: add orinoco_usb driver
      orinoco_usb: avoid in_atomic
      orinoco_usb: implement fw download
      orinoco: refactor xmit path

David S. Miller (55):
      e1000e: Fix build with CONFIG_PM disabled.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ipv6: Fix bug in ipv6_chk_same_addr().
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      ipv6: Preserve pervious behavior in ipv6_link_dev_addr().
      ipv6: Fix result generation in ipv6_get_ifaddr().
      decnet: Remove unused FIB metric macros.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      l2tp: Add missing semicolon to MODULE_ALIAS() in l2tp_netlink.c
      l2tp: Fix L2TP_DEBUGFS ifdef tests.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Revert "Add non-Virtex5 support for LL TEMAC driver"
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      tcp: Set CHECKSUM_UNNECESSARY in tcp_init_nondata_skb
      chelsio: Fix build warning.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      virtio_net: Fix mis-merge.
      Merge branch 'vhost' of git://git.kernel.org/.../mst/vhost
      Merge branch 'master' of git://git.kernel.org/.../kaber/ipmr-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      niu: Enable GRO by default.
      tg3: Enable GRO by default.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      tcp: Fix ipv6 checksumming on response packets for real.
      tcp: Mark v6 response packets as CHECKSUM_PARTIAL
      net: Orphan and de-dst skbs earlier in xmit path.
      niu: Add skb->rxhash support.
      Merge branch 'net-next-2.6_20100423a/br/br_multicast_v3' of git://git.linux-ipv6.org/gitroot/yoshfuji/linux-2.6-next
      bridge: Fix build of ipv6 multicast code.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/ipmr-2.6
      net: Make RFS socket operations not be inet specific.
      bridge: Use hlist_for_each_entry_rcu() in br_multicast_add_router()
      Revert "bridge: Use hlist_for_each_entry_rcu() in br_multicast_add_router()"
      net: Inline skb_pull() in eth_type_trans().
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Use explicit "unsigned int" instead of plain "unsigned" in netdevice.h
      Revert "ixgbe: disable MSI-X by default on certain Cisco adapters"
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      phy/micrel: Add module device ID table for autoloading.
      Merge branch 'net-next' of git://git.kernel.org/.../vxy/lksctp-dev
      forcedeth: Kill NAPI config options.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'vhost' of git://git.kernel.org/.../mst/vhost
      netpoll: Use 'bool' for netpoll_rx() return type.
      microblaze: Kill NET_SKB_PAD and NET_IP_ALIGN overrides.
      Revert "microblaze: Kill NET_SKB_PAD and NET_IP_ALIGN overrides."
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/ipmr-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../inaky/wimax
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/

David Woodhouse (2):
      phylib: Support phy module autoloading
      phylib: Add module table to all existing phy drivers

Dhananjay Phadke (3):
      qlcnic: handle queue manager access
      qlcnic: update oncard memory size check
      qlcnic: fix onchip memory access

Dimitris Michailidis (9):
      cxgb4: parse the VPD instead of relying on a static VPD layout
      cxgb4: increase serial number length
      cxgb4: set skb->rxhash
      cxgb4: configure HW VLAN extraction through FW
      cxgb4: report the PCIe link speed
      cxgb4: report GRO stats with ethtool -S
      cxgb4: fix initial addition of MAC address
      cxgb4: keep interrupts available when the ports are brought down
      cxgb4: notify upper drivers if the device is already up when they load

Dmitry Kravkov (1):
      bnx2x: Added GRO support

Don Skidmore (2):
      ixgbe: cleanup ethtool autoneg input
      ixgbe: add support for active DA cables

Eddie Wai (1):
      bnx2: Fix register printouts during NETEV_WATCHDOG.

Elina Pasheva (1):
      NET: usb: Adding URB_ZERO_PACKET flag to usbnet.c

Emil Tantilov (3):
      e1000: Use netdev_<level>, pr_<level> and dev_<level>
      igb: Clean up left over prototype of igb_get_hw_dev_name()
      ixgbe: fix setting of promisc mode when using mac-vlans

Eric Dumazet (63):
      netfilter: nf_conntrack: per netns nf_conntrack_cachep
      net: remove rcu locking from fib_rules_event()
      tcp: Add SNMP counter for DEFER_ACCEPT
      net: speedup netdev_set_master()
      atm: Use kasprintf
      net: snmp mib cleanup
      net: dev_getfirstbyhwtype() optimization
      rps: add CONFIG_RPS
      net: __netif_receive_skb should be static
      net: remove redundant code
      netfilter: CLUSTERIP: clusterip_seq_stop() fix
      netfilter: xt_hashlimit: RCU conversion
      gen_estimator: deadlock fix
      r8169: Fix rtl8169_rx_interrupt()
      net: illegal_highdma() fix
      icmp: Account for ICMP out errors
      l2tp: unmanaged L2TPv3 tunnels fixes
      net: Add a missing local_irq_enable()
      net: include linux/proc_fs.h in dev_addr_lists.c
      net: Dont use netdev_warn()
      net: sk_dst_cache RCUification
      net: uninline skb_bond_should_drop()
      drivers: net: last_rx elimination
      drivers: net: use skb_headlen()
      net: netif_rx() must disable preemption
      rps: rps_sock_flow_table is mostly read
      net: remove time limit in process_backlog()
      net: Introduce skb_orphan_try()
      rps: shortcut net_rps_action()
      rps: static functions
      rps: cleanups
      rps: consistent rxhash
      net: sk_sleep() helper
      net: Fix various endianness glitches
      fasync: RCU and fine grained locking
      net: Introduce skb_orphan_try()
      rps: immediate send IPI in process_backlog()
      dst: rcu check refinement
      net: use sk_sleep()
      rps: inet_rps_save_rxhash() argument is not const
      net: fix a lockdep rcu warning in __sk_dst_set()
      net: sk_add_backlog() take rmem_alloc into account
      bnx2x: Remove two prefetch()
      net: speedup udp receive path
      net: ip_queue_rcv_skb() helper
      net: speedup sock_recv_ts_and_drops()
      net: sock_def_readable() and friends RCU conversion
      net: rcu fixes
      net: skb_free_datagram_locked() fix
      net: __alloc_skb() speedup
      net: Increase NET_SKB_PAD to 64 bytes
      rps: Various optimizations
      net: trans_start cleanups
      net: Consistent skb timestamping
      net: Introduce sk_route_nocaps
      net: congestion notifications are not dropped packets
      rps: avoid one atomic in enqueue_to_backlog
      net: add a noref bit on skb dst
      net: implements ip_route_input_noref()
      net: Use ip_route_input_noref() in input path
      net: No dst refcounting in ip_queue_xmit()
      tcp: tcp_synack_options() fix
      net: Introduce skb_tunnel_rx() helper

FUJITA Tomonori (15):
      acenic: fix the misusage of zero dma address
      acenic: use the dma state API instead of the pci equivalents
      net: change illegal_highdma to use dma_mask
      benet: use the dma state API instead of the pci equivalents
      benet: fix the misusage of zero dma address
      bnx2: use the dma state API instead of the pci equivalents
      bnx2x: use the DMA API instead of the pci equivalents
      tg3: use the DMA state API instead of the pci equivalents
      qla3xxx: use the DMA state API instead of the pci equivalents
      chelsio: use the DMA state API instead of the pci equivalents
      cxgb3: use the DMA state API instead of the pci equivalents
      qlge: use the DMA state API instead of the pci equivalents
      myri10ge: use the DMA state API instead of the pci equivalents
      sky2: use the DMA state API instead of the pci equivalents
      skge: use the DMA state API instead of the pci equivalents

Felix Fietkau (49):
      minstrel: simplify and fix debugfs code
      minstrel: make the rate control ops reusable from another rc implementation
      ath9k: fix rate control tx status handling for A-MPDU
      mac80211: optimize tx status processing
      ath9k: split out access to tx status information
      ath9k: split out access to rx status information
      ath9k: allocate tx and rx status information on stack
      ath9k: fix compile error without debug enabled
      ath9k_hw: add silicon revision macros for AR9300
      ath9k_hw: add a macro for abstracting generic timer access
      ath9k_hw: fix a missing hex prefix for a register mask
      ath9k_hw: add simple register abstraction for some AR9300 registers
      ath9k_hw: add support for GPIO differences on AR9003
      ath9k_hw: Add AR9003 PHY register definitions
      ath9k_hw: Set the channel on AR9003
      ath9k_hw: Implement PLL control on AR9003
      ath9k_hw: Implement spur mitigation on AR9003
      ath9k_hw: Split off ANI control to the PHY ops
      ath9k: Add Rx EDMA support
      ath9k_hw: Split out the function for reading the noise floor
      ath9k_hw: move AR9280 PCI EEPROM fix to eeprom_def.c
      ath9k_hw: Update ath9k_hw_set_dma for AR9300
      ath9k: check for specific rx stuck conditions and recover from them
      ath9k: clean up tx buffer handling
      ath9k: update the MCS mask for MCS16 and above
      ath9k: update the ath_max_4ms_framelen table
      ath9k: reduce the bits_per_symbol table size, support more streams
      ath9k: initialize the number of tx/rx streams correctly
      mac80211: add flags for STBC (Space-Time Block Coding)
      ath9k: add support for Tx and Rx STBC
      ath9k: set the STBC flag in rate control if the peer supports it
      mac80211: fix handling of 4-address-mode in ieee80211_change_iface
      ath9k_hw: update initvals for AR9003
      ath9k_hw: fix pll clock setting for 5ghz on AR9003
      ath9k_hw: fix typo in the AR9003 EEPROM data structure definition
      ath9k_hw: update EEPROM data structure for AR9280
      ath9k_hw: fix fast clock handling for 5GHz channels
      ath9k: wake queue after processing edma rx frames
      ath9k_hw: use the configured power limit for AR9003
      ath9k_hw: Fix typos in tx rate power level parsing for AR9003
      ath9k_hw: Fix endian bug in an AR9003 EEPROM field
      ath9k_hw: fix noisefloor timeout handling on AR9003
      cfg80211: add ap isolation support
      mac80211: implement ap isolation support
      ath9k: fix another source of corrupt frames
      ath9k: use debugfs_remove_recursive() instead of keeping pointers to all entries
      ath9k: add debugfs files for reading/writing the rx and tx chainmask
      ath9k: add debugfs files for reading/writing registers
      ath9k_hw: clean up EEPROM endian handling on AR9003

Flavio Leitner (1):
      TCP: avoid to send keepalive probes if receiving data

Florian Fainelli (11):
      au1000-eth: allow driver to be compiled as a module
      au1000-eth: set MODULE_VERSION
      au1000-eth: prefix all functions with au1000_
      au1000-eth: fix checkpatch errors.
      au1000-eth: implement set/get_msglevel
      au1000-eth: Use (dev|netdev|netif)_<level> macro helpers
      au1000-eth: bump to 1.7
      r6040: use (dev|netdev)_<level> macros helpers
      PHY: fix typo in bcm63xx PHY driver table
      bcm63xx_enet: do not overwrite ENET_CTL_REG value
      r6040: fix link checking with switches

Florian Westphal (1):
      ipv6 addrlabel: permit deletion of labels assigned to removed dev

Francois Romieu (1):
      via-velocity: remove private #define

Frank Blaschka (3):
      qeth: l3 fix build error in ipv6 addr list handling
      qeth: exploit HW TX checksumming
      qeth: synchronize configuration interface

Frans Pop (16):
      net: remove trailing space in messages
      tipc: remove trailing space in messages
      net/irda: remove trailing space in messages
      net/ps3_gelic: remove trailing space in messages
      net/smc91xx: remove trailing space in messages
      net/tokenring: remove trailing space in messages
      net/tulip: remove trailing space in messages
      net/intel: remove trailing space in messages
      net/various: remove trailing space in messages
      wireless: remove trailing space in messages
      wireless/prism54: remove trailing space in messages
      wireless/raylink: remove trailing space in messages
      wireless/libertas: remove trailing space in debugfs header
      wireless/ipw2x00: remove trailing space in messages
      iwlwifi: remove trailing space in messages
      wireless/ath: remove trailing space in messages

Gertjan van Wingerde (32):
      rt2x00: Disable auto wakeup before waking up device.
      rt2x00: Add wakeup interrupt handler to rt61pci.
      rt2x00: Add wakeup interrupt handler to rt2800pci.
      rt2x00: Enable powersaving by default again on rt2500usb.
      rt2x00: Let RF chipset decide the RF channel switch method to use in rt2800.
      rt2x00: Update rt2800 register definitions towards latest definitions.
      rt2x00: Align RT chipset definitions with vendor driver.
      rt2x00: Refactor rt2800 version constants.
      rt2x00: Align rt2800 register initialization with vendor driver.
      rt2x00: Finish rt3070 support in rt2800 register initialization.
      rt2x00: Add rt3071 support in rt2800 register initialization.
      rt2x00: Add rt3090 support in rt2800 register initialization.
      rt2x00: Add rt3390 support in rt2800 register initialization.
      rt2x00: Remove rt2x00pci.h include from rt2800lib.
      rt2x00: Enable RT30xx by default.
      rt2x00: Fix HT40+/HT40- setting in rt2800.
      rt2x00: Register frame length in TX entry descriptor instead of L2PAD.
      rt2x00: Fix setting of txdesc->length field.
      rt2x00: Clean up rt2800usb.h.
      rt2x00: Don't check whether hardware crypto is enabled when reading RXD.
      rt2x00: Factor out TXWI writing to common rt2800 code.
      rt2x00: Factor out RXWI processing to common rt2800 code.
      rt2x00: Clean up all driver's kick_tx_queue callback functions.
      rt2x00: provide beacon's txdesc to write_beacon callback function.
      rt2x00: Fix beaconing on rt2800.
      rt2x00: Clean up generic procedures on descriptor writing.
      rt2x00: Consistently name skb frame descriptor skbdesc.
      rt2x00: Fix beacon descriptor writing for rt61pci.
      rt2x00: Re-order tx descriptor writing code in drivers.
      rt2x00: Simplify TXD handling of beacons.
      rt2x00: Dump beacons under a different identifier than TX frames.
      rt2x00: In debugfs frame dumping allow the TX descriptor to be part of the skb.

Giuseppe CAVALLARO (7):
      stmmac: split core and dma for the mac10/100
      stmmac: rework normal and enhanced descriptors
      stmmac: fix Transmit FIFO flush operation
      stmmac: new descriptor field for the driver's platform
      stmmac: get the descriptor structure from platform
      stmmac: fix vlan support setup
      stmmac: updated the drv module version

Grazvydas Ignotas (7):
      wl1251: make local symbols static
      wl1251: fix ELP_CTRL register accesses when using SDIO
      wl1251: reduce eeprom read wait time
      wl1251: don't require NVS data when EEPROM is used
      wl1251: read default MAC address from EEPROM when available
      wl1251: register platform_device to pass board data
      wl1251: add support for dedicated IRQ line

Greg Rose (6):
      ixgbevf: Fix link speed display
      ixgbe: Add boolean parameter to ixgbe_set_vmolr
      ixgbe: Add support for VF MAC and VLAN configuration
      ixgbe: Remove unneeded register writes in VF VLAN setup
      ixgbe: Streamline MC filter setup for VFs
      ixgbevf: Cache PF ack bit in interrupt

Gustavo F. Padovan (54):
      Bluetooth: Fix return value when bt_skb_alloc fails
      Bluetooth: Use the proper function cast to get hdr data
      Bluetooth: Fix wrong packet type count increment
      Bluetooth: Make hci_send_sco() void
      Bluetooth: Trivial clean ups to SCO
      Bluetooth: Move specific Basic Mode code to the right place
      Bluetooth: Fix memory leak of S-frames into L2CAP
      Bluetooth: Fix expected_tx_seq calculation on L2CAP
      Bluetooth: Fix ACL MTU issue
      Bluetooth: Use a l2cap_pinfo struct instead l2cap_pi() macro
      Bluetooth: Implement 'Send IorRRorRNR' event
      Bluetooth: Support case with F bit set under WAIT_F state.
      Bluetooth: Check the minimum {I,S}-frame size into L2CAP
      Bluetooth: Check if SDU size is greater than MTU on L2CAP
      Bluetooth: Implement SendAck() Action on ERTM.
      Bluetooth: Move set of P-bit to l2cap_send_sframe()
      Bluetooth: Add Recv RR (P=0)(F=0) for SREJ_SENT state on ERTM
      Bluetooth: Split l2cap_data_channel_sframe()
      Bluetooth: Handle all cases of receipt of RNR-frames into L2CAP
      Bluetooth: Group the ack of I-frames into l2cap_data_channel_rrframe()
      Bluetooth: Remove duplicate use of __get_reqseq() macro on L2CAP
      Bluetooth: Finish implementation for Rec RR (P=1) on ERTM
      Bluetooth: Add timer to Acknowledge I-frames
      Bluetooth: Ignore Tx Window value with Streaming mode
      Bluetooth: Read RFC conf option on a successful Conf RSP
      Bluetooth: Fix configuration of the MPS value
      Bluetooth: Add le16 macro to Retransmission and Monitor Timeouts values
      Bluetooth: Check the SDU size against the MTU value
      Bluetooth: Send Ack after clear the SREJ list
      Bluetooth: Add sockopt configuration for txWindow on L2CAP
      Bluetooth: Change acknowledgement to use the value of txWindow
      Bluetooth: Add module parameter for txWindow size on L2CAP
      Bluetooth: Enable option to configure Max Transmission value via sockopt
      Bluetooth: Fix bug when retransmitting I-frames
      Bluetooth: Fix crash when monitor timeout expires
      Bluetooth: Fix drop of acked packets on ERTM
      Bluetooth: Optimize SREJ_QUEUE append
      Bluetooth: Add Kconfig option for L2CAP Extended Features
      Bluetooth: Add SOCK_STREAM support to L2CAP
      Bluetooth: Fix SDU reassembly under SREJ
      Bluetooth: Don't set control bits to zero first
      Bluetooth: Fix errors reported by checkpatch.pl
      Bluetooth: Remove set of SrejSaveReqSeq under receipt of REJ frame
      Bluetooth: Remove unneeded control vars
      Bluetooth: Check if we really are in WAIT_F when F bit comes
      Bluetooth: Fix lockdep annotation on ERTM
      Bluetooth: Make hci_send_acl() void
      Bluetooth: Refactor l2cap_retransmit_frame()
      Bluetooth: Implement missing parts of the Invalid Frame Detection
      Bluetooth: Implement Local Busy Condition handling
      Bluetooth: Add wait_queue to wait ack of all sent packets
      Bluetooth: Fix race condition on l2cap_ertm_send()
      Bluetooth: Prevents buffer overflow on l2cap_ertm_reassembly_sdu()
      Bluetooth: Fix spec error in the RemoteBusy Logic

Hagen Paul Pfeifer (4):
      tipc: define needless global scoped variable static
      sctp: eliminate useless code
      ipv4: remove redundant verification code
      socket: remove duplicate declaration of struct timespec

Hans J. Koch (1):
      Fix some #includes in CAN drivers (rebased for net-next-2.6)

Hans de Goede (1):
      p54pci: fix regression from prevent stuck rx-ring on slow system

Hauke Mehrtens (1):
      wireless: Fix merge.

Helmut Schaa (14):
      mac80211: Improve software scan timing
      rt2x00: fix warning when building rt2800pci with just soc support
      rt2x00: use rt2800_config_channel_rt3x for rt2872
      rt2x00: add txdesc parameter to write_tx_data
      rt2x00: rt2800pci: fix tx path by not accessing the skb after it was DMA mapped
      rt2x00: rt2800lib: disable HT40 for now as it causes reception problems
      rt2x00: rt2800: use tx_power2 in rt2800_config_channel_rf3xxx
      rt2x00: fix typo in rt2800.h
      rt2x00: rt2800lib: Fix rx path on SoC devices
      rt2x00: rt2800lib: Remove redundant check for RT2872
      rt2x00: rt2800lib: update rfcsr & bbp init code for SoC devices
      rt2x00: rt2800: update initial SIFS values
      rt2x00: rt2800: don't overwrite SIFS values on erp changes
      rt2x00: rt2800: use correct txop value in tx descriptor

Herbert Xu (11):
      xfrm: Remove xfrm_state_genid
      netfilter: only do skb_checksum_help on CHECKSUM_PARTIAL in ip_queue
      netfilter: only do skb_checksum_help on CHECKSUM_PARTIAL in ip6_queue
      netfilter: only do skb_checksum_help on CHECKSUM_PARTIAL in nfnetlink_queue
      tcp: Handle CHECKSUM_PARTIAL for SYNACK packets for IPv4
      tcp: Handle CHECKSUM_PARTIAL for SYNACK packets for IPv6
      inet: Remove unused send_check length argument
      ipv6: Replace inet6_ifaddr->dead with state
      ipv6: Use state_lock to protect ifa state
      ipv6: Use POSTDAD state
      ipv6: Never schedule DAD timer on dead address

Holger Schurig (2):
      mac80211: sample survey implementation for mac80211 & hwsim
      ath5k: basic support for survey

Huang Weiyi (1):
      net: remove unused #include <linux/version.h>

Ilpo J√§rvinen (1):
      unix/garbage: kill copy of the skb queue walker

Inaky Perez-Gonzalez (2):
      wimax/i2400m: driver defaults to firmware v1.5 for i5x50 devices
      wimax/i2400m: driver defaults to firmware v1.5 for i6x60 devices

Ivo van Doorn (1):
      rt2x00: Fix RF3052 channel initialization

James Chapman (14):
      l2tp: Relocate pppol2tp driver to new net/l2tp directory
      l2tp: Split pppol2tp patch into separate l2tp and ppp parts
      ppp: Add ppp_dev_name() exported function
      l2tp: Add ppp device name to L2TP ppp session data
      l2tp: Add L2TPv3 protocol support
      l2tp: Update PPP-over-L2TP driver to work over L2TPv3
      l2tp: Add L2TPv3 IP encapsulation (no UDP) support
      netlink: Export genl_lock() API for use by modules
      l2tp: Add netlink control API for L2TP
      l2tp: Convert rwlock to RCU
      l2tp: Add L2TP ethernet pseudowire support
      l2tp: Add debugfs files for dumping l2tp debug info
      l2tp: Add support for static unmanaged L2TPv3 tunnels
      l2tp: Update documentation

Jan Engelhardt (64):
      net: tcp: make hybla selectable as default congestion module
      net: tcp: make veno selectable as default congestion module
      net: core: add IFLA_STATS64 support
      netfilter: xt_CT: par->family is an nfproto
      netfilter: xt_NFQUEUE: consolidate v4/v6 targets into one
      netfilter: xtables: add comment markers to Xtables Kconfig
      netfilter: xtables: merge xt_MARK into xt_mark
      netfilter: xtables: merge xt_CONNMARK into xt_connmark
      netfilter: xtables: schedule xt_NOTRACK for removal
      netfilter: update my email address
      netfilter: ebt_ip6: add principal maintainer in a MODULE_AUTHOR tag
      netfilter: xt_recent: update description
      netfilter: xt_recent: remove old proc directory
      netfilter: xtables: do without explicit XT_ALIGN
      netfilter: xtables: clean up xt_mac match routine
      netfilter: xtables: limit xt_mac to ethernet devices
      netfilter: xtables: resort osf kconfig text
      netfilter: xtables: make use of caller family rather than match family
      netfilter: update documentation fields of x_tables.h
      netfilter: xtables: remove almost-unused xt_match_param.data member
      netfilter: xtables: reduce holes in struct xt_target
      netfilter: xtables: do not print any messages on ENOMEM
      netfilter: xtables: replace custom duprintf with pr_debug
      netfilter: xt extensions: use pr_<level>
      netfilter: xtables: make use of caller family rather than target family
      netfilter: xt extensions: use pr_<level> (2)
      netfilter: xtables: make use of xt_request_find_target
      netfilter: xtables: consolidate code into xt_request_find_match
      netfilter: xt_recent: allow changing ip_list_[ug]id at runtime
      netfilter: bridge: use NFPROTO values for NF_HOOK invocation
      netfilter: ipv4: use NFPROTO values for NF_HOOK invocation
      netfilter: ipv6: use NFPROTO values for NF_HOOK invocation
      netfilter: decnet: use NFPROTO values for NF_HOOK invocation
      netfilter: ipvs: use NFPROTO values for NF_HOOK invocation
      netfilter: xtables: untangle spaghetti if clauses in checkentry
      netfilter: xtables: change xt_match.checkentry return type
      netfilter: xtables: change xt_target.checkentry return type
      netfilter: xtables: change matches to return error code
      netfilter: xtables: change targets to return error code
      netfilter: xtables: slightly better error reporting
      netfilter: xtables: shorten up return clause
      netfilter: xtables: remove xt_hashlimit revision 0
      netfilter: xtables: remove xt_multiport revision 0
      netfilter: xtables: remove xt_string revision 0
      netfilter: xtables: merge registration structure to NFPROTO_UNSPEC
      net: fix unaligned access in IFLA_STATS64
      net: increase preallocated size of nlmsg to accomodate for IFLA_STATS64
      netfilter: ipv6: move POSTROUTING invocation before fragmentation
      netfilter: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation
      netfilter: xtables: inclusion of xt_TEE
      netfilter: xtables: make ip_tables reentrant
      netfilter: xt_TEE: have cloned packet travel through Xtables too
      netfilter: xtables: remove old comments about reentrancy
      netfilter: x_tables: move sleeping allocation outside BH-disabled region
      netfilter: x_tables: rectify XT_FUNCTION_MAXNAMELEN usage
      netfilter: ip_tables: fix compilation when debug is enabled
      netfilter: xtables: fix incorrect return code
      netfilter: xtables: dissolve do_match function
      netfilter: xtables: combine struct xt_match_param and xt_target_param
      netfilter: xtables: substitute temporary defines by final name
      netfilter: xtables: deconstify struct xt_action_param for matches
      netfilter: xtables: change hotdrop pointer to direct modification
      netfilter: xtables: combine built-in extension structs
      netfilter: xtables: add missing depends for xt_TEE

Jason Gunthorpe (1):
      NET: Support clause 45 MDIO commands at the MDIO bus level

Javier Cardona (1):
      mac80211: Moved mesh action codes to a more visible location

Jay Sternberg (1):
      iwlwifi: enable '6000 Series 2x2 AGN Gen2' adaptors

Jesper Dangaard Brouer (1):
      netfilter: nf_conntrack: extend with extra stat counter

Jesse Brandeburg (7):
      e1000e: use static params to save stack space
      ixgbe: fix bug with vlan strip in promsic mode
      ixgbe: enable extremely low latency
      ixgbe: fix bug when EITR=0 causing no writebacks
      e1000/e1000e: implement a simple interrupt moderation
      e1000: fix WARN_ON with mac-vlan
      e1000: cleanup unused parameters

Jiri Pirko (20):
      net: convert multiple drivers to use netdev_for_each_mc_addr, part7
      net: rename notifier defines for netdev type change
      bonding: check return value of nofitier when changing type
      net: forbid underlaying devices to change its type
      bonding: flush unicast and multicast lists when changing type
      ipoib: remove addrlen check for mc addresses
      ixgbe: convert to use netdev_for_each_mc_addr
      ixgbevf: convert to use netdev_for_each_mc_addr
      netfilter: ctnetlink: compute message size properly
      net: move address list functions to a separate file
      net: convert multicast list to list_head
      net: emphasize rtnl lock required in call_netdevice_notifiers
      l2tp: fix memory allocation
      l2tp_eth: fix memory allocation
      netns: rename unregister_pernet_subsys parameter
      phonet: use phonet_pernet instead of directly net_generic
      pppoe: use pppoe_pernet instead of directly net_generic
      net: disallow to use net_assign_generic externally
      pppoe: remove unnecessary checks in pppoe_flush_dev
      net: adjust handle_macvlan to pass port struct to hook

Joe Perches (24):
      netfilter: net/netfilter/ipvs/ip_vs_ftp.c: Remove use of NIPQUAD
      drivers/net/ks*: Use netdev_<level>, netif_<level> and pr_<level>
      drivers/net/e100.c: Use pr_<level> and netif_<level>
      ixgbevf: Message formatting fixup
      include/linux/wireless.h: Add IW_HANDLER macro to initialize array entry
      wireless.h: Use SIOCIWFIRST not SIOCSIWCOMMIT for range check
      net/wireless/wext_core.c: Use IW_IOCTL_IDX macro
      net/wireless/wext-core.c: Use IW_EVENT_IDX macro
      drivers/net/wireless: Use IW_HANDLER macro
      drivers/net: Remove local #define IW_IOCTL, use IW_HANDLER
      orinoco/wext.c: Remove local #define STD_IW_HANDLER
      drivers/net/wireless/ray_cs.c: Use iw_handler function prototypes
      e1000e: typo corrections
      drivers/net/ipg: Remove invalid IPG_DDEBUG_MSG uses, neaten
      MAINTAINERS: ipg: Jesse Huang's email address bounces
      include/net/iw_handler.h: Use SIOCIWFIRST not SIOCSIWCOMMIT in comment
      net/l2tp/l2tp_debugfs.c: Convert NIPQUAD to %pI4
      ixgb: Use pr_<level> and netdev_<level>
      netfilter: remove unnecessary returns from void function()s
      drivers/net: Remove unnecessary returns from void function()s
      ixgb and e1000: Use new function for copybreak tests
      net: Remove unnecessary semicolons after switch statements
      drivers/net: remove useless semicolons
      net: Remove unnecessary returns from void function()s

Johannes Berg (95):
      mac80211: deprecate RX status noise
      mac80211: use different MAC addresses for virtual interfaces
      iwlagn: move ICT code into separate file
      iwlwifi: move 3945 specific data into union
      iwlwifi: move ICT data to agn part of union
      iwlagn: remove write-only variables
      iwlwifi: remove superfluous channel check
      iwlwifi: remove dead code from iwl_mac_reset_tsf
      iwlwifi: remove frame dropping
      iwlwifi: remove never-changing priv->rates_mask variable
      iwlwifi: remove priv->active_rate_basic
      iwlwifi: remove IBSS channel sanity check
      iwlwifi: remove sanity check
      iwlwifi: clear up AC/FIFO debug output
      iwlwifi: move 3945 clip groups to 3945 data
      iwlwifi: remove alive start adhoc restart
      iwlwifi: remove STATUS_MODE_PENDING
      iwlagn: move sysfs flags and filter_flags files to debugfs
      iwlwifi: change WEP key protection to use mutex
      iwlwifi: clean up queue/fifo handling
      iwlwifi: sta_id cannot be invalid in rs_initialize_lq
      iwlwifi: remove noise reporting
      mac80211: fix station destruction problem
      mac80211: remove irq disabling for sta lock
      mac80211: remove ieee80211_sta_stop_rx_ba_session
      mac80211: rename WLAN_STA_SUSPEND to WLAN_STA_BLOCK_BA
      mac80211: clean up/fix aggregation code
      mac80211: fix some RX aggregation locking
      mac80211: fix paged RX crypto
      mac80211: enhance tracing
      iwlwifi: make WEP key restoring explicit
      iwlwifi: remove wrong key use check
      iwlagn: simplify WEP key check
      iwlwifi: remove pointless sta_id invalid check
      iwlwifi: clean up last_phy_res
      iwlwifi: remove scan_bands logic
      iwlwifi: correct atomic bitops usage
      iwlwifi: remove next_scan_jiffies
      iwlwifi: remove scan_pass_start
      iwlwifi: rename priv->scan to priv->scan_cmd
      iwlwifi: trigger scan synchronously
      iwlwifi: make BT coex config a virtual method
      iwlwifi: rename TX_CMD_FLG_BT_DIS_MSK
      iwlwifi: don't check monitor for scanning
      iwlwifi: remove monitor check
      iwlwifi: make scan antenna forcing more generic
      mac80211: fix stopping RX BA session from timer
      mac80211: add missing newline
      radiotap parser: fix endian annotation
      ethernet: print protocol in host byte order
      mac80211: give virtual interface to hw_scan
      mac80211: notify driver about IBSS status
      mac80211: tell driver about IBSS merge
      mac80211: fix ieee80211_find_sta[_by_hw]
      mac80211: allow controlling aggregation manually
      mac80211: improve IBSS scanning
      mac80211_hwsim: fix double-scan detection
      mac80211: use fixed channel in ibss join when appropriate
      mac80211: fix BSS info reconfiguration
      cfg80211/mac80211: better channel handling
      mac80211: improve HT channel handling
      iwlagn: wait for asynchronous firmware loading
      iwlwifi: use vif iwl_bss_info_changed
      iwl3945: use iwl3945_add_bcast_station
      iwlwifi: pass address to iwl_remove_station
      iwlwifi: manage IBSS station properly
      iwlagn: show and store firmware build number
      iwl3945: remove ucode access indirection
      iwlwifi: remove ucode virtual functions
      iwlwifi: move eeprom version printout to eeprom init
      iwlagn: prepare for new firmware file format
      iwlagn: implement loading a new firmware file type
      iwlwifi: remove rts_threshold
      iwlagn: move iwl_get_ra_sta_id to 4965
      iwlagn: use vif->type to check station
      iwlwifi: apply filter flags directly
      iwlwifi: push virtual interface through
      iwlagn: use virtual interface in TX aggregation handling
      iwlwifi: remove useless priv->vif check
      iwlwifi: use vif in iwl_ht_conf
      iwlwifi: note that priv->bssid is used only by 3945
      iwlwifi: fix iwl_sta_init_lq station ID
      iwlwifi: split allocation/sending local station LQ
      iwlwifi: rework broadcast station management
      iwlwifi: track station IDs
      iwlwifi: add iwl_sta_id()
      iwlwifi: use iwl_find_station less
      iwlagn: use iwl_sta_id() for aggregation
      iwlwifi: use iwl_sta_id() for TKIP key update
      iwlwifi: move iwl_find_station() to 4965
      iwlwifi: rename iwl_add_local_station
      iwlwifi: remove pointless HT check
      iwlwifi: clear driver stations when going down
      mac80211: don't process work item with wrong frame
      mac80211: add offload channel switch support

John Fastabend (3):
      ixgbe: ixgbe_down needs to stop dev_watchdog
      ixgbe: fix ixgbe_tx_is_paused logic
      ixgbe: dcb, do not tag tc_prio_control frames

John Linn (3):
      Add non-Virtex5 support for LL TEMAC driver
      net: ll_temac: remove virt_to_bus call
      Add non-Virtex5 support for LL TEMAC driver

John W. Linville (46):
      ath5k: remove some dead functions
      ath5k: remove dead source in ath5k_combine_linear_pcdac_curves
      ath5k: remove unused beacon timer code
      Revert "mac80211: fix rates setup on IBSS merge"
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      iwlwifi: fix build error for CONFIG_IWLAGN=n
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6 into merge
      ath5k: fixup some merge damage for AR5211 IQ calibration
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' into for-davem
      ssb: do not read SPROM if it does not exist
      MAINTAINERS: add entry for include/linux/iw_handler.h
      mwl8k: remove usage of deprecated noise value
      ar9170: remove usage of deprecated noise value
      ath5k: remove usage of deprecated noise value
      ath9k: remove usage of deprecated noise value
      b43: remove usage of deprecated noise value
      b43legacy: remove usage of deprecated noise value
      libertas_tf: remove usage of deprecated noise value
      p54: remove usage of deprecated noise value
      rt2x00: remove usage of deprecated noise value
      wl1251: remove usage of deprecated noise value
      rtl8180: use cached queue mapping for skb in rtl8180_tx
      rtl8180: fix tx status reporting
      libertas_tf: avoid warning about pr_fmt redefinition
      mac80211: remove deprecated noise field from ieee80211_rx_status
      iwmc3200wifi: cleanup unneeded debugfs error handling
      rt2x00: remove now unused noise field from struct rxdone_entry_desc
      b43: Added get_survey callback in order to get channel noise
      b43legacy: Added get_survey callback in order to get channel noise
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      iwmc3200wifi: fix busted iwm_debugfs_init definition
      rtl8180: use SET_IEEE80211_PERM_ADDR
      rtl8187: use SET_IEEE80211_PERM_ADDR
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      mac80211: set IEEE80211_TX_CTL_FIRST_FRAGMENT for beacons
      rtl8180: assign sequence numbers in the driver
      rtl8180: add software-based support for IBSS mode
      rtl8180: change PCI DMA mask to DMA_BIT_MASK(32)
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Jon Paul Maloy (1):
      TIPC: Updated topology subscription protocol according to latest spec

Jonas Sj√∂quist (1):
      cdc_ether: Identify MBM devices by GUID in MDLM descriptor

Jouni Malinen (8):
      mac80211: Track Beacon signal strength and implement cqm events
      mac80211: Send deauth/disassoc prior to dropping STA entry
      mac80211: Fix BIP to be used only with group-addressed frames
      mac80211: Fix dropping of unprotected robust multicast frames
      ath9k: Do not indicate RX_FLAG_DECRYPTED for unprotected frames
      mac80211: Fix drop_unencrypted for MFP with hwaccel
      mac80211: Fix robust management frame handling (MFP)
      cfg80211: Add local-state-change-only auth/deauth/disassoc

Jo√£o Paulo Rechi Vita (3):
      Bluetooth: Check if mode is supported on getsockopt
      Bluetooth: Close L2CAP channel on invalid ReqSeq
      Bluetooth: Completes the I-frame tx_seq check logic on RECV

Julia Lawall (9):
      drivers/net/wireless/hostap: Drop memory allocation cast
      drivers/net/usb: Use kmemdup
      drivers/net/usb: Use kmemdup
      drivers/net/usb: Use kmemdup
      drivers/s390/net: Drop memory allocation cast
      drivers/net: Use kzalloc
      net/caif: Use kzalloc
      drivers/net/vmxnet3: Use kzalloc
      drivers/net: Use kcalloc or kzalloc

Jussi Kivilinna (4):
      rndis_wlan: copy only useful data from rndis_command respond
      rndis_wlan: remove unused variables from priv structure
      rndis_wlan: get max_num_pmkids from device
      rndis_wlan: Implement cfg80211 PMKSA API

Juuso Oikarinen (63):
      wl1271: Improvements to the TX path
      wl1271: Fix ad-hoc mode neighborhood detection
      wl1271: Fix queue stopping/waking for TX path
      wl1271: Remove annoying PSM entry/exit kernel traces
      wl1271: Aggregate RX acknowledgements to FW
      wl1271: Don't mask interrupts while handling interrupt
      wl1271: Implement looped IRQ handling
      wl1271: Update TX packet life time handling with higher resolution time
      wl1271: Clean up firmware block allocation calculation
      wl1271: Clean up TX security sequence number handling
      wl1271: Disable host TX rate control
      wl1271: Remove tx-power level workaround
      wl1271: Fix configuration of the TX opportunity value
      wl1271: Fix SG configuration message structures
      wl1271: Add proper WLAN-BT co-ex configuration, and enable co-ex.
      wl1271: Move platform device registration from _spi to _main
      wl1271: Add sysfs file to control BT co-ex state
      wl1271: Fix MAC address handling
      wl1271: Remove deprecated interface config function
      wl1271: Update filters properly
      wl1271: Don't generate null func template for ad-hoc
      wl1271: Remove circular interlocking related to the inetaddr notifier chain
      mac80211: Add support for connection monitor in hardware
      cfg80211: Add connection quality monitoring support to nl80211
      mac80211: Add support for connection quality monitoring
      cfg80211: Improve connection quality maintenance docs in nl80211.h
      wl1271: Clean up RX rate reporting
      wl1271: Add TX rate reporting
      wl1271: Fix memory leaks in SPI initialization
      wl1271: Fix memory leak in scan command handling
      wl1271: Configure clock-request drive mode to open-drain
      wl1271: Fix memory leak in cmd_data_path
      wl1271: Update busyword checking mechanism
      wl1271: Remove device MAC-address randomization
      wl1271: Disable connection monitoring while not associated
      wl1271: Fix ad-hoc mode handling
      wl1271: Update beacon interval properly for ad-hoc
      wl1271: Fix memory leak in firmware crash scenario
      wl1271: Configure probe-request template when associated
      wl1271: Disconnect if PSM entry fails
      wl1271: Configure HW connection monitor
      wl1271: Add keep-alive frame template support
      wl1271: Enable hardware keep alive messages
      wl1271: Fix keep-alive related command error
      wl1271: Use minimum rate for each band for control messages
      wl1271: Configure rates for templates
      wl1271: Configure a higher listen interval to AP upon association
      wl1271: Fix debug prints for beacon-loss and psm-entry-fail scenarios
      wl1271: Fix tx queue flushing
      wl1271: Fix memory leaks on driver initialization
      wl1271: Go to ELP in idle
      wl1271: Add support for connection quality monitoring
      mac80211: Prevent running sta_cleanup timer unnecessarily
      mac80211: Fix ieee80211_sta_conn_mon_timer with hw connection monitoring
      mac80211: Fix sta->last_tx_rate setting with no-op rate control devices
      mac80211: Determine dynamic PS timeout based on ps-qos network latency
      cfg80211: Remove default dynamic PS timeout value
      wl1271: Improve command polling
      wl1271: Rewrite hardware keep-alive handling
      wl1271: Add sysfs file to retrieve HW PG-version and ROM-version
      wl1271: Fix 32 bit register read related endiannes bug
      wl1271: Fix to join and channel number handling
      wl1271: Reduce PSM entry hang over period from 128 => 1 ms

Kalle Valo (8):
      wl1271: don't get received frames from hardware in PLT mode
      wl1271: enable WMM
      wl1271: get pspoll and nullfunc templates from mac80211
      wl1271: get probe request template from mac80211
      wl1271: create qos nullfunc template
      wl1271: fix ps scheme in wl1271_op_conf_tx()
      wl1271: enable U-APSD
      wl1251: use DRIVER_NAME macro in wl1251_spi_driver

Koki Sanagi (2):
      igb: double increment nr_frags
      igbvf: double increment nr_frags

Kuninori Morimoto (3):
      net/irda: sh_sir: fixup err return value on sh_sir_open
      net/irda: sh_sir: Modify iounmap wrong execution
      net/irda: Add SuperH IrDA driver support

Larry Finger (3):
      ssb: Export ssb_chipco_gpio_control - needed by N PHY code
      rtl818x: Move configuration details to the rtl818x directory
      ssb: Make bus registration failure not be silent

Luciano Coelho (7):
      wl1271: fix wl1271_spi driver name
      wl1271: wait for join command complete event
      wl1271: wait for disconnect command complete event
      wl1271: remove deprecated usage of RX status noise
      wl1271: fix sdio driver name in wl1271_sdio_driver
      wl1271: added missing command header in wl1271_cmd_disconnect
      wl1271: fix a bunch of sparse warnings

Luis Correia (1):
      rt2x00: remove MCU requests for SoC platforms

Luis R. Rodriguez (64):
      mac80211_hwsim: add sw_scan sw_scan_complete
      mac80211: fix typo for LDPC capability
      ath9k_hw: start building an abstraction layer for hardware routines
      ath9k_hw: AR9003 does not have AR_RC_AHB skip its setting
      ath9k_hw: remove wrapper ath9k_hw_write_regs()
      ath9k_hw: Move some RF ops to the private callbacks
      ath9k_hw: skip PLL initialization on AR9003 on Power-On-Reset
      ath9k_hw: add some comments for ath9k_set_power_network_sleep()
      ath9k_hw: add a private callback for PLL control computation
      ath9k_hw: Add AR9003 PHY support
      ath9k_hw: move init config and default after chip is up
      ath9k_hw: add the AR9003 ar9003_hw_macversion_supported()
      ath9k_hw: disable ANI for AR9003
      ath9k: disable the MIB interrupt if ANI is disabled
      ath9k_hw: add common channel select helpers for ar900[23]
      ath9k_hw: split initvals.h by hardware family
      ath9k_hw: add initvals for the AR9003 hardware family
      ath9k_hw: add helpers for processing the AR9003 INI
      ath9k_hw: add all the AR9003 PHY callbacks
      ath9k_hw: add a helper for Power Amplifier calibration for AR9002
      ath9k_hw: add a helper for the OLC tem compensation for AR9002
      ath9k_hw: rename PA calib for AR9287
      ath9k_hw: shift code for AR9280 OLC temp comp
      ath9k_hw: move the AR9280 OLC temp comp to its own helper
      ath9k_hw: simplify OLC temp compensation for AR9002
      ath9k_hw: rename the PA calib routines to match their families
      ath9k_hw: rename getNoiseFloorThresh() to ath9k_hw_loadnf()
      ath9k_hw: move the cal AR9100 calibration settings
      ath9k_hw: split calib code by hardware families
      ath9k_hw: add the AR9003 ar9003_hw_init_cal callback
      ath9k_hw: add the config_pci_powersave AR9003 callback
      ath9k_hw: split the generic hardware code by hardware family
      ath9k_hw: move the cck channel 14 INI to the AR9002 hw code
      ath9k_hw: move TX/RX gain INI stuff to its own hardware family code
      ath9k_hw: abstract the AR_PHY_AGC_CONTROL register access
      ath9k_hw: abstract loading noisefloor
      ath9k_hw: fill in the callbacks for calibration for AR9003
      ath9k_hw: complete AR9003 calibration
      ath9k_hw: rename eep_AR9287_ops to eep_ar9287_ops
      ath9k_hw: restore mac address reading logic
      ath9k_hw: add OFDM spur mitigation for AR9003
      ath9k_hw: move the RF claim stuff to AR9002 hardware family
      ath9k_hw: add the AR9300 SREV hw name print
      ath9k_hw: add TX/RX gain register initialization for AR9003
      ath9k_hw: skip asynch fifo enablement to AR9003
      ath9k_hw: skip WEP aggregation enable code for AR9003
      ath9k_hw: move AR9002 mac ops to its own file
      ath9k: add RXLP and RXHP to debugfs counters
      ath9k_hw: enable CRC check of descriptors for AR9003
      ath9k_hw: set cwmin and cwmax to 0 for for AR9003 upon txq reset
      mac80211: add LDPC control flag
      ath9k_hw: add LDPC support for AR9003
      ath9k: add LDPC support
      ath9k_hw: add the PCI ID for the first AR9300 device
      ath9k_hw: make two initvals consto for the AR9001 family
      ath9k_hw: make all AR9002 initvals use u32
      ath9k_hw: disable TX IQ calibration for AR9003
      ath9k_hw: Fix TX interrupt mitigation settings
      ath9k_common: move the rate status setting into ath9k_process_rate()
      ath9k_common: drop incomming frames with an invalid hardware rate
      ath9k_hw: Update initvals for AR9003 for xb113
      ath9k_hw: enable PCIe low power mode for AR9003
      ath5k: drop warning on jumbo frames
      ath9k_hw: new initialization values for AR9003

Luis de Bethencourt (3):
      Net: wireless: ath: fix macros coding style issue in hw.c
      ath: fix code readability in regd.c
      ath: fix coding style/readability in ath/ar9170

Mallikarjuna R Chilakala (2):
      ixgbe: Use bool flag to see if the packet unmapping is delayed in HWRSC
      ixgbe: Refactor common code between 82598 & 82599 to accommodate new hardware

Manfred Rudigier (2):
      gianfar: Add hardware RX timestamping support
      gianfar: Add hardware TX timestamping support

Marc Zyngier (1):
      Add hotplug support to mcp251x driver

Marcel Holtmann (2):
      Bluetooth: Create per controller workqueue
      Bluetooth: Fix issues where sk_sleep() helper is needed now

Marco Porsch (1):
      nl80211: reenable station del for mesh

Matt Carlson (20):
      tg3: Fix MII_TG3_DSP_EXP8 offset
      tg3: Restore likely() check in tg3_poll_msix()
      tg3: Replace pr_err with sensible alternatives
      tg3: netdev_err() => dev_err()
      tg3: Fix message 80 char violations
      tg3: Prepare FW version code for VPD versioning
      tg3: Use VPD fw version when present
      tg3: Whitespace, constant, and comment updates
      tg3: The case of switches
      tg3: Cleanup if codestyle
      tg3: Remove tg3_dump_state()
      tg3: Update version to 3.109
      tg3: Disable CLKREQ in L2
      tg3: Set card 57765 card reader MRRS to 1024B
      tg3: Reduce 57765 core clock when link at 10Mbps
      tg3: Optimize rx double copy test
      tg3: Re-inline VLAN tags when appropriate
      tg3: Unify max pkt size preprocessor constants
      tg3: Remove function errors flagged by checkpatch
      tg3: Update version to 3.110

Matthias Fuchs (1):
      can: Add esd board support to plx_pci CAN driver

Matthieu CASTET (2):
      airo : fix printing status info
      airo : Print of firmware version

Michael Chan (6):
      bnx2: Add GRO support.
      bnx2: Add prefetches to rx path.
      bnx2: Update 5709 MIPS firmware and version to 2.0.15.
      bnx2: Use netif_carrier_off() to prevent timeout.
      cnic: Convert cnic_local_flags to atomic ops.
      cnic: Return SPQ credit to bnx2x after ring setup and shutdown.

Michael Hennerich (1):
      netdev: bfin_mac: add support for wake-on-lan magic packets

Michael S. Tsirkin (3):
      virtio-net: move sg off stack
      tun: add ioctl to modify vnet header size
      macvtap: add ioctl to modify vnet header size

Mike Frysinger (1):
      netdev: bfin_mac: handle timeouts with the MDIO registers gracefully

Mike McCormack (5):
      sky2: Restore multicast after restart
      sky2: Avoid race in sky2_change_mtu
      sky2: Shut off interrupts before NAPI
      sky2: Refactor down/up code out of sky2_restart()
      sky2: Avoid allocating memory in sky2_resume

Ming Lei (5):
      ath9k: decrease size of ath9k.ko
      ath9k-htc:respect usb buffer cacheline alignment in ath9k_hif_usb_alloc_rx_urbs
      ath9k-htc:respect usb buffer cacheline alignment in reg in path
      ath9k-htc:respect usb buffer cacheline alignment in reg out path
      ath9k-htc: fix lockdep warning and kernel warning after unplugging ar9271 usb device

Nathan Williams (1):
      atm: select FW_LOADER in Kconfig for solos-pci

Neil Horman (3):
      tipc: Increase frequency of load distribution over broadcast link
      tipc: Allow retransmission of cloned buffers
      ipv4: remove ip_rt_secret timer (v4)

Neil Jones (1):
      drivers/net/usb/asix.c: Fix unaligned accesses

Nicholas Nunley (1):
      ixgbe: disable MSI-X by default on certain Cisco adapters

Nick Nunley (8):
      igb: add per-packet timestamping
      e1000: use DMA API instead of PCI DMA functions
      e1000e: use DMA API instead of PCI DMA functions
      igbvf: use DMA API instead of PCI DMA functions
      ixgb: use DMA API instead of PCI DMA functions
      ixgbe: use DMA API instead of PCI DMA functions
      ixgbevf: use DMA API instead of PCI DMA functions
      igb: reduce cache misses on tx cleanup

Nikanth Karthikesan (1):
      net: small cleanup of lib8390

Nishant Sarmukadam (1):
      cfg80211: Avoid sending IWEVASSOCREQIE and IWEVASSOCRESPIE events with NULL event body

Octavian Purdila (1):
      sysctl: add proc_do_large_bitmap

Oliver Hartkopp (1):
      can: Fix SJA1000 command register writes on SMP systems

Patrick McHardy (38):
      netfilter: nf_conntrack: fix memory corruption with multiple namespaces
      netfilter: nf_conntrack: fix hash resizing with namespaces
      Merge branch 'master' of /repos/git/linux-2.6
      Merge branch 'master' of ../nf-2.6
      net: rtnetlink: ignore NETDEV_PRE_TYPE_CHANGE in rtnetlink_event()
      IPVS: fix potential stack overflow with overly long protocol names
      netfilter: remove invalid rcu_dereference() calls
      net: fib_rules: consolidate IPv4 and DECnet ->default_pref() functions.
      net: fib_rules: set family in fib_rule_hdr centrally
      net: fib_rules: decouple address families from real address families
      ipv4: raw: move struct raw_sock and raw_sk() to include/net/raw.h
      ipv4: ipmr: move unres_queue and timer to per-namespace data
      ipv4: ipmr: remove net pointer from struct mfc_cache
      ipv4: ipmr: convert struct mfc_cache to struct list_head
      ipv4: ipmr: move mroute data into seperate structure
      ipv4: ipmr: support multiple tables
      ipv4: ipmr: fix IP_MROUTE_MULTIPLE_TABLES Kconfig dependencies
      ipv4: ipmr: fix invalid cache resolving when adding a non-matching entry
      ipv4: ipmr: fix NULL pointer deref during unres queue destruction
      netfilter: ipt_LOG/ip6t_LOG: use more appropriate log level as default
      netfilter: xt_TEE: resolve oif using netdevice notifiers
      Merge branch 'master' of /repos/git/net-next-2.6
      netfilter: ip_tables: convert pr_devel() to pr_debug()
      net: fib_rules: mark arguments to fib_rules_register const and __net_initdata
      net: rtnetlink: decouple rtnetlink address families from real address families
      net: ipmr: add support for dumping routing tables over netlink
      netfilter: nf_ct_h323: switch "incomplete TPKT" message to pr_debug()
      netfilter: nf_conntrack_proto: fix warning with CONFIG_PROVE_RCU
      Merge branch 'master' of /repos/git/net-next-2.6
      netfilter: use rcu_dereference_protected()
      ipv6: ip6mr: move unres_queue and timer to per-namespace data
      ipv6: ip6mr: remove net pointer from struct mfc6_cache
      ipv6: ip6mr: convert struct mfc_cache to struct list_head
      ipv6: ip6mr: move mroute data into seperate structure
      ipv6: ip6mr: support multiple tables
      ipv6: ip6mr: add support for dumping routing tables over netlink
      Merge branch 'master' of git://dev.medozas.de/linux
      net_sched: sch_hfsc: fix classification loops

Paul E. McKenney (1):
      net: suppress RCU lockdep false positive in twsk_net()

Paul LeoNerd Evans (1):
      net: Socket filter ancilliary data access for skb->dev->type

Pavel Roskin (11):
      ath5k: remove stale function declarations, make some functions static
      ath5k: remove useless "extern" from function declarations
      ath5k: move ath5k_hw_register_timeout() into reset.c
      ath9k: never read from the AR_IMR_S2 register
      orinoco: disable support for prism chipset by default
      ipw2x00: replace "ieee80211" with "libipw" where appropriate
      ath9k: rename symbols in enum ath9k_internal_frame_type to avoid confusion
      ath9k: move imask from sc to ah
      ath9k: remove ah->mask_reg, it's never used properly
      net: fix definition of netdev_for_each_mc_addr()
      ath9k: simplify AR9220 fixup code for AR_AN_TOP2 register

Peter Korsgaard (1):
      macb: allow reception of large (>1518 bytes) frames

Peter Meerwald (1):
      netdev: bfin_mac: handler RX status errors

Prasanna S Panchamukhi (1):
      wimax/i2400m: Move module params to other file so they can be static

Prasanna S. Panchamukhi (13):
      wimax/i2400m: move I2400M_MAX_MTU enum from netdev.c to i2400m.h
      wimax/i2400m: fix insufficient size of Tx buffer for 12 payload of 1400 MTU.
      wimax/i2400m: increase the maximum number of payloads per message to 60 [v1]
      wimax/i2400m: limit the message size upto 16KiB [v1]
      wimax/i2400m: fix BUILD_BUG_ON() to use the maximum message size constant [v1]
      wimax/i2400m: modify i2400m_tx_fifo_push() to check for head room space in the TX FIFO [v1]
      wimax/i2400m: fix system freeze caused by an infinite loop [v1]
      wimax/i2400m: increase tx queue length from 5 to 20 [v1]
      wimax i2400m: fix race condition while accessing rx_roq by using kref count
      wimax/i2400m: fix incorrect handling of type 2 and 3 RX messages
      wimax/i2400m: reserve additional space in the TX queue's buffer while allocating space for a new message header
      wimax/i2400m: SDIO specific TX queue's minimum buffer room for new message
      wimax/i2400m: USB specific TX queue's minimum buffer room required for new message

Prasanna S.Panchamukhi (1):
      wimax/i2400m: fix incorrect return -ESHUTDOWN when there is no Tx buffer available

Quintin Pitts (1):
      p54pci: prevent stuck rx-ring on slow system

Rafael J. Wysocki (3):
      r8169 / PCI / PM: Add simplified runtime PM support (rev. 3)
      e1000e / PCI / PM: Add basic runtime PM support (rev. 4)
      Net / e1000e: Fix build issue introduced by runtime PM patch

Rafa≈Ç Mi≈Çecki (19):
      b43: N-PHY: add some registers and structs definitions
      b43: N-PHY: initialize super switch
      b43: N-PHY: turn radio on/off (rfkill)
      b43: N-PHY: update writing channel-specific radio registers
      b43: N-PHY: update post init of 2055 radio
      b43: N-PHY: switch to chanspec struct
      b43: N-PHY: adjust gain table
      b43: N-PHY: isloate 2055 radio setup
      b43: N-PHY: implement chanspec setup
      b43: N-PHY: switch to chanspec ops
      b43: N-PHY: some dummy PHY rev 3 calls
      b43: N-PHY: use b43_phy_n_sfo_cfg rather than duplicating same fields
      b43: N-PHY: find table entry earlier for setting chanspec
      b43: N-PHY: prepare for rev3+ channel tables
      b43: N-PHY: fix value written on 2055 radio setup
      b43: N-PHY: fix copy&paste typo
      ssb: Look for SPROM at different offset on higher rev CC
      ssb: Use relative offsets for SPROM
      ssb: Fix order of definitions and some text space indents

Rajesh K Borundia (1):
      netxen: validate unified romimage

Ralf Baechle (1):
      NET: sb1250: Fix compile warning in driver

Rami Rosen (2):
      net: Remove two unnecessary exports (skbuff).
      cleanup: remove pppoe_ioctl() declaration.

Randy Dunlap (3):
      wireless: depends on NET
      netfilter: xt_TEE depends on NF_CONNTRACK
      bridge: fix build for CONFIG_SYSFS disabled

Reinette Chatre (11):
      iwlwifi: remove needlessly exported symbols
      iwlwifi: only add broadcast station once
      iwlwifi: implement new mac80211 station add/remove calls
      Revert "iwlwifi: fix build error for CONFIG_IWLAGN=n"
      iwlwifi: fix compile warnings when compiling without debug
      Merge branch 'wireless-2.6' into wireless-next-2.6
      Merge branch 'wireless-2.6' into wireless-next-2.6
      iwlwifi: recalculate average tpt if not current
      Merge branch 'wireless-2.6' into wireless-next-2.6
      iwlwifi: make bcast LQ command available for later restore actions
      iwlagn: work around rate scaling reset delay

Richard Cochran (1):
      packet: support for TX time stamps on RAW sockets

Richard R√∂jfors (1):
      ks8842: Add platform data for setting mac address

Robert Olsson (1):
      pktgen node allocation

Roland Dreier (2):
      cxgb4: Use ntohs() on __be16 value instead of htons()
      cxgb4: Make unnecessarily global functions static

Samuel Ortiz (2):
      iwmc3200wifi: Fix sparse warnings
      iwmc3200wifi: check sparse endianness annotations

Saravanan Dhanabal (4):
      wl1271: Fix msleep() delay while waiting for completion
      wl1271: Fix mac80211 configuration requests during WL1271_STATE_OFF
      wl1271: Fix mac80211 RTS threshold requests during WL1271_STATE_OFF
      wl1271: Configure QOS nullfunc template for U-APSD

Sarveshwar Bandi (1):
      be2net: Adding PCI SRIOV support

Sathya Perla (3):
      be2net: handle dma mapping errors in Tx path
      be2net: fix unmap_single/page() called incorrectly in Tx compl processing
      be2net: clarify promiscuous cmd with a comment

Scott Feldman (3):
      remove DCB_PROTO_VERSION as we don't do netlink versioning
      net: Add netlink support for virtual port management (was iovnl)
      net: Add ndo_{set|get}_vf_port support for enic dynamic vnics

Sebastian Andrzej Siewior (2):
      net/sb1250: remove CONFIG_SIBYTE_STANDALONE
      net/sb1250: setup the pdevice within the soc code

Sebastien Jan (3):
      ks8851: Add caching of CCR register
      ks8851: Low level functions for read/write to companion eeprom
      ks8851: companion eeprom access through ethtool

Senthil Balasubramanian (5):
      ath9k_hw: Add the PCI IDs for AR9300 and fill up the pci_id_tables
      ath9k_hw: update the chip tests for AR9003
      ath9k_hw: prevent reset control register zeroing on AR9003 reset
      ath9k_hw: the eep_map is used only for AR9280 PCI card ini fixup
      ath9k_hw: Implement AR9003 eeprom callbacks

Shan Wei (4):
      ipv6: cancel to setting local_df in ip6_xmit()
      net: replace ipfragok with skb->local_df
      ipv6: fix the comment of ip6_xmit()
      sctp: use sctp_chunk_is_data macro to decide a chunk is data chunk

Shannon Nelson (1):
      ixgbe: fix header len when unsplit packet overflows to data buffer

Shanyu Zhao (7):
      iwlwifi: clean up driver names for 1000/5000/6000
      iwlwifi: bring up 6000 Series 2x2 AGN Gen2 adapters
      iwlwifi: remove redundant iwl_dump_lq_cmd()
      mac80211: fix rts threshold check
      iwlwifi: set correct AC to swq_id for aggregation
      iwlwifi: rename 6000 series Gen2 devices to Gen2a
      iwlwifi: dump firmware build info in error case

Sherman Pun (1):
      RDS: Properly unmap when getting a remote access error

Shirley Ma (1):
      virtio_net: missing sg_init_table

Simon Arlott (1):
      bridge: update sysfs link names if port device names have changed

Sjur Braendeland (19):
      net-caif: add CAIF protocol definitions
      net-caif: add CAIF socket and configuration headers
      net-caif: add CAIF core protocol stack header files
      net-caif: add CAIF Link layer device header files
      net-caif: add CAIF core protocol stack
      net-caif: add CAIF generic caif support functions
      net-caif: add CAIF device registration functionality
      net-caif: add CAIF socket implementation
      net-caif: add CAIF netdevice
      net-caif: add CAIF Kconfig and Makefiles
      net-caif: add CAIF documentation
      net-caif-driver: add CAIF serial driver (ldisc)
      caif: Ldisc add permission check and mem-alloc error check
      caif: Rename functions in cfcnfg and caif_dev
      caif: Add reference counting to service layer
      caif: Disconnect without waiting for response
      caif: Rewritten socket implementation
      caif: Bugfixes in CAIF netdevice for close and flow control
      Bugfix: Link selection was swapped in switch.

Sonic Zhang (5):
      netdev: bfin_mac: invalid data cache only once for each new rx skb buffer
      netdev: bfin_mac: deduce Ethernet FCS from hardware IP payload checksum
      netdev: bfin_mac: clear RXCKS if hardware generated checksum is not enabled
      netdev: bfin_mac: use promiscuous flag for promiscuous mode
      netdev: bfin_mac: check for mii_bus platform data

Sreenivasa Honnur (12):
      vxge: Fix a receive stall due to driver being out of synch with chip.
      vxge: Fix starvation of receive ring controller when blasted by short packets.
      vxge: Align the memory only if it is misaligned.
      vxge: Fixed "ethtool -d" prints.
      vxge: Fixed MSIX interrupt configuration.
      vxge: Set function-0 as the privilaged function for normal function.
      vxge: Version update.
      vxge: Updating Maintainer list of S2IO 10GbE drivers (xframe / vxge).
      vxge: Fix a possible memory leak in vxge_hw_device_initialize().
      vxge: Allow driver load for all enumerated pci functions.
      vxge: Pass correct number of VFs value to pci_sriov_enable().
      vxge: Version update.

Stanislaw Gruszka (9):
      mac80211: explicitly disable/enable QoS
      iwlwifi: manage QoS by mac stack
      mac80211: enable QoS explicitly in AP mode
      iwlwifi: check scan request ie_len
      iwlwifi: initialize iwl_wimax_coex_cmd.flags
      mac80211: document IEEE80211_CONF_CHANGE_QOS
      mac80211: do not wip out old supported rates
      mac80211: fix supported rates IE if AP doesn't give us it's rates
      bnx2x: avoid TX timeout when stopping device

Stephen Hemminger (7):
      IPv6: addrconf cleanups
      addrconf: checkpatch fixes
      IPv6: Generic TTL Security Mechanism (final version)
      sky2: add support for receive hashing
      netfilter: change NF_ASSERT to WARN_ON
      netfilter: cleanup printk messages
      ipv6: fix the bug of address check

Stephen Rothwell (3):
      rps: fix net-sysfs build for !CONFIG_RPS
      net-caif: using kmalloc/kfree requires the include of slab.h
      ar9170: fix for driver-core ABI change

Steve Hodgson (8):
      sfc: Ignore parity errors in the other port's SRAM
      sfc: Handle serious errors in exactly one interrupt handler
      sfc: Stop masking out XGMII faults over reconfigures
      sfc: Reconfigure the XAUI serdes after an EM reset
      sfc: Extend the legacy interrupt workarounds
      sfc: Read MEM_STAT for SRM_PERR as well as MEM_PERR errors
      sfc: Set PERIODIC_NOEVENT flag for MC_CMD_MAC_STATS
      sfc: Add Siena PHY BIST and cable diagnostic support

Steve Tanner (1):
      ar9170usb: add vendor and device ID for Qwest/Actiontec 802AIN Wireless N USB Network Adapter

Steve deRosier (1):
      libertastf: add configurable debug messages

Stewart Malik (1):
      DRIVER: Libertas: Fixed coding style in rx.c

Sucheta Chakraborty (11):
      netxen: fix tx csum status
      qlcnic: use IDC defined timeout value
      netxen: remove unnecessary size checks
      netxen: to fix onchip memory access.
      qlcnic: check IDC version
      qlcnic: check device class
      qlcnic: support quisce mode
      qlcnic: add idc debug registers
      qlcnic: change adapter name display
      qlcnic: fix rx bytes statistics
      qlcnic: fix internal loopback test

Sujith (54):
      ath9k_hw: update initialization values for AR9271
      ath9k_hw: add GPIO setup code for AR9271
      ath9k_hw: skip chip tests for AR9271
      ath9k_hw: fix TX descriptor setup for AR9271
      ath9k_hw: Fix full sleep setup for AR9271
      ath9k_hw: fix noisefloor history buffer usage on AR9271
      ath9k_hw: restrict valid nf readings for AR9271 to -114
      ath9k_hw: use the skip count for PA calibration on AR9271
      ath9k_hw: always set the core clock for AR9271
      ath9k_hw: add HTC init hardware call for special resets for AR9271
      ath9k_hw: fix hardware deinit
      ath9k_htc: Support for AR9271 chipset.
      ath9k_htc: Fix symbol collision with ath9k
      ath9k_common: Move RX filter code to ath9k_htc
      ath9k_htc: Fix bug in aggregation initiation
      ath9k_htc: Fix watchdog pattern parsing
      ath9k_htc: Simplify RX URB management
      ath9k_htc: Handle TX queue overflow
      ath9k_htc: Initialize HW opmode
      ath9k_htc: Fix TKIP encryption
      ath: Add a bus type field
      ath9k_hw: Don't check devid for ath9k_htc
      ath9k_htc: Add TL-WN422G v2 product ID
      ath9k_htc: Protect RX stream variables
      ath9k_htc: Fix RX URB reference count
      ath9k_htc: Fix module unloading issue
      ath9k_htc: Use anchors for REGOUT pipe
      ath9k_htc: Fix HTC layer memleak
      ath9k_htc: Cleanup beacon configuration
      ath: Add buffered register write operations
      ath9k_htc: Implement multiple register write support
      ath9k_hw: Add macros for multiple register writes
      ath9k_hw: Relocate Opmode initialization
      ath9k_hw: Use buffered register writes
      ath9k_htc: Remove GPIO set on unload
      ath9k_htc: Add dropped SKB count to debugfs
      ath9k_htc: Handle WMI timeouts properly
      ath9k_htc: Fix sparse endian warnings
      ath9k_htc: Simplify TX URB management
      ath9k_htc: Handle device unplug properly
      ath9k_htc: Use multiple register writes
      ath9k_htc: Cancel running timers before disabling HW
      ath9k_hw: Remove pointless ANI deinit
      ath9k_htc: Pass correct private pointer
      ath9k_htc: Use USB reboot
      ath9k_htc: Process command data properly
      ath9k_htc: Increase WMI timeout value
      ath9k_htc: Fix WMI command race
      ath9k_htc: Really fix device hotunplug
      ath9k_htc: Remove unnecessary powersave restore
      ath9k_htc: Validate TX Endpoint ID
      ath9k_htc: Simplify RX IRQ handler
      ath9k_htc: Fix beaconing in IBSS mode
      ath9k_htc: Handle IDLE LED properly

Sujith.Manoharan@atheros.com (5):
      ath9k_htc: Lock sta_notify() callback
      ath9k_htc: Allocate URBs properly
      ath9k_htc: Reorder HTC initialization
      ath9k_htc: Fix target ready race condition
      ath9k_htc: Fix array overflow

Tadashi Abe (1):
      pegasus: fix USB device ID for ETX-US2

Taku Izumi (3):
      e1000e: add registers etc. printout code just before resetting adapters
      igb: add registers etc. printout code just before resetting adapters
      ixgbe: add registers etc. printout code just before resetting adapters

Teemu Paasikivi (19):
      wl1271: Moved module basics to wl1271_spi.c
      wl1271: Added functions to enable/disable interrupt handling
      wl1271: Implemented abstraction of IO functions.
      wl1271: Inlined IO functions
      wl1271: Removed wl1271_spi.h and made some functions static
      wl1271: Divided driver to two separate modules
      wl1271: Initial SDIO implementation
      wl1271: Changed access to fw status register to use raw read
      wl1271: Fixed unloading of the wl1271_sdio module
      wl1271: Changed wl1271_sdio to be selectable only on ARM
      wl1271: Cleaned up wlan power on/off functions
      wl1271: Changed SDIO MMC host claiming
      wl1271: Added DEBUG_SDIO flag
      wl1271: Removed duplicate code from module remove function.
      wl1271: Changed platform_device to be dynamically allocated
      wl1271: Warnings caused by wrong format specifiers fixed
      wl1271: Removed checking of PSM from handling BSS_LOST_EVENT
      mac80211: check whether scan is in progress before queueing scan_work
      wl1271: Increase timeout for command event waiting

Thomas Klein (2):
      ehea: error handling improvement
      ehea: fix possible DLPAR/mem deadlock

Tim Gardner (2):
      netfilter: xt_recent: add an entry reaper
      netfilter: xt_recent: check for unsupported user space flags

Timo Teras (1):
      xfrm: fix policy unreferencing on larval drop

Timo Ter√§s (8):
      xfrm_user: verify policy direction at XFRM_MSG_POLEXPIRE handler
      xfrm: remove policy lock when accessing policy->walk.dead
      flow: structurize flow cache
      flow: virtualize flow cache entry methods
      xfrm: cache bundles instead of policies for outgoing flows
      xfrm: remove policy garbage collection
      flow: delayed deletion of flow cache entries
      xfrm: Fix crashes in xfrm_lookup()

Tina Yang (3):
      RDS: Fix send locking issue
      RDS: Fix locking in rds_send_drop_to()
      RDS: Enable per-cpu workqueue threads

Tobias Klauser (9):
      net: emaclite: Use resource_size
      3c507: Remove unnecessary memset of netdev private data
      3c523: Remove unnecessary memset of netdev private data
      KS8695: Remove unnecessary memset of netdev private data
      bcm63xx_enet: Remove unnecessary memset of netdev private data
      ethoc: Remove unnecessary memset of napi member in netdev private data
      smc9194: Remove unnecessary memset of netdev private data
      sunhme: Remove unnecessary memset of netdev private data
      tehuti: Remove unnecessary memset of netdev private data

Tom Goff (3):
      net_sched: make traffic control network namespace aware
      netlink: use the appropriate namespace pid
      net_sched: minor netns related cleanup

Tom Herbert (15):
      rps: Receive Packet Steering
      rps: Fixed build with CONFIG_SMP not enabled.
      rps: Fix build with CONFIG_SYSFS enabled
      net: Fix locking in flush_backlog
      rps: fixed missed rps_unlock
      rfs: Receive Flow Steering
      tcp: fix outsegs stat for TSO segments
      bnx2x: add support for receive hashing
      forcedeth: GRO support
      bnx2x: Fix check to get RX hash
      e1000e: save skb counts in TX to avoid cache misses
      e1000e: reduce writes of RX producer ptr
      e1000e: Remove unnessary log message
      e1000e: Save irq into netdev structure
      forcedeth: Account for consumed budget in napi poll

Tomas Winkler (1):
      Bluetooth: Use strict_strtoul instead of simple_strtoul

Ulrich Weber (1):
      netfilter: ipv6: move xfrm_lookup at end of ip6_route_me_harder

Ursula Braun (2):
      qeth: new message if OLM limit is reached
      qeth: support the new OSA CHPID types OSX and OSM

Vasanthakumar Thiagarajan (29):
      ath9k_hw: Add hw cap flag for EDMA for the AR9003 family
      ath9k_hw: Fill few hw cap for edma
      ath9k_hw: Add abstraction for rx enable
      ath9k_hw: Fill rx_enable() for the AR9003 hardware family
      ath9k_hw: Add few routines for rx edma support
      ath9k_hw: Define tx control struct for AR9003
      ath9k_hw: Move code which populates ds_data to ath9k_hw
      ath9k_hw: Add abstraction to set/get link pointer
      ath9k: Use abstraction to get link pointer
      ath9k: Use memcpy in ath_clone_txbuf()
      ath9k: Remove ATH9K_TX_SW_ABORTED and introduce a bool for this purpose
      ath9k: Make bf_desc of ath_buf opaque
      ath9k_hw: Abstract the routine which returns interrupt status
      ath9k_hw: Initialize interrupt mask for AR9003
      ath9k_hw: Fill get_isr() for AR9003
      ath9k_hw: Configure Tx interrupt mitigation timer
      ath9k: Load SW filtered NF values and start NF cal during full reset for AR9003
      ath9k_hw: Define abstraction for tx desc access
      ath9k_hw: Add function to configure tx status ring buffer
      ath9k_hw: Fill descriptor abstrations for AR9003
      ath9k: Setup appropriate tx desc for regular dma and edma
      ath9k: Initialize and configure tx status for EDMA
      ath9k_hw: Compute pointer checksum over the link descriptor
      ath9k: Add Tx EDMA support
      ath9k: Enable TXOK and TXERR interrupts for TX EDMA
      ath9k_hw: Abort rx if hw is not coming out of full sleep in reset
      ath9k_hw: Fix usec to hw clock conversion in 5Ghz for ar9003
      ath9k: Fix bug in handling rx frames with invalid descriptor content
      ath9k: Remove unused rx_edma in ath_rx_addbuffer_edma()

Vasanthy Kolluri (5):
      enic: Bug Fix: Fix hardware descriptor reads
      enic: Bug Fix: Fix timeout for hardware Tx and Rx queue disable operations
      enic: Do not advertise NETIF_F_HW_VLAN_RX
      enic: Clean up: Add wrapper functions
      enic: Clean up: Change driver description; Fix tab space; Update MAINTAINERS

Vivek Natarajan (5):
      ath9k: Add support for newer AR9285 chipsets.
      ath9k_htc: Add support for power save.
      ath9k_htc: Configure the beacon timers once the scan is completed.
      ath9k_htc: Handle CONF_IDLE during unassociated state to save power.
      ath9k: Avoid corrupt frames being forwarded to mac80211.

Vlad Yasevich (13):
      sctp: Use correct address family in sctp_getsockopt_peer_addrs()
      sctp: send SHUTDOWN-ACK chunk back to the source.
      sctp: Do no select unconfirmed transports for retransmissions
      sctp: Make sure we always return valid retransmit path
      sctp: remove 'resent' bit from the chunk
      sctp: Do not force T3 timer on fast retransmissions.
      sctp: Save some room in the sctp_transport by using bitfields
      sctp: update transport initializations
      sctp: fast recovery algorithm is per association.
      sctp: rwnd_press should be cumulative
      sctp: correctly mark missing chunks in fast recovery
      sctp: Optimize computation of highest new tsn in SACK.
      sctp: Tag messages that can be Nagle delayed at creation.

Vladislav Zolotarov (11):
      bnx2x: Parity errors handling for 57710 and 57711
      bnx2x: Use VPD-R V0 entry to display firmware revision
      bnx2x: Increase DMAE max write size for 57711
      bnx2x: Protect code with NOMCP
      bnx2x: White spaces
      bnx2x: Added new statistics
      bnx2x: Fixed MSI-X enabling flow
      bnx2x: use mask in test_registers() to avoid parity error
      bnx2x: Rework power state handling code
      bnx2x: Don't report link down if has been already down
      bnx2x: Date and version

WANG Cong (3):
      netpoll: add generic support for bridge and bonding devices
      bridge: make bridge support netpoll
      bonding: make bonding support netpoll

Wei Yongjun (6):
      sctp: assure at least one T3-rtx timer is running if a FORWARD TSN is sent
      sctp: discard ABORT chunk with zero verification tag in COOKIE-WAIT state
      sctp: missing set src and dest port while lookup output route
      sctp: fix to retranmit at least one DATA chunk
      sctp: implement sctp association probing module
      sctp: fix append error cause to ERROR chunk correctly

Wey-Yi Guy (58):
      iwlwifi: remove un-necessary parameters
      iwlwifi: remove duplicate function
      iwlwifi: remove unnecessary parameter in scan function
      iwlwifi: add internal short scan support for 3945
      iwlwifi: Recover TX flow stall due to stuck queue
      iwlwifi: move plcp check to separated function
      iwlwifi: Recover TX flow failure
      iwlwifi: code cleanup for connectivity recovery
      iwlwifi: iwl_good_ack_health() only apply to AGN device
      iwlwifi: move ucode loading related code to separated file
      iwlwifi: code cleanup for "load ucode" function
      iwlwifi: move hcmd related code to separate file
      iwlwifi: move tx queue related code to separate file
      iwlwifi: move hw related defines to separate file
      iwlwifi: move ucode alive related code to separate file
      iwlwifi: move agn common code to iwlagn library file
      iwlwifi: each device has its own eeprom tx power version
      iwlwifi: move agn module parameter structure to common place
      iwlwifi: move agn only tx functions from iwlcore to iwlagn
      iwlwifi: move agn only rx functions from iwlcore to iwlagn
      iwlwifi: more clean up to move agn only rx functions from iwlcore to iwlagn
      iwlwifi: remove non-exist extern functions and structures
      iwlwifi: add missing email address information
      iwlwifi: Generic approach to measure temperature
      iwlwifi: remove "\n" from module parameter description
      iwlwifi: change spin_lock to spin_lock_irqsave
      iwlwifi: avoid device type checking in generic code
      iwlwifi: merge module parameters into single place
      iwlwifi: remove irrelevant comments
      iwlwifi: deprecate "iwl4965" alias support
      iwlwifi: code cleanup for generic defines
      iwlwifi: default max event log size
      iwlwifi: add more debug info in error event dump
      iwlwifi: update tx command response status
      iwlwifi: small changes in comments
      iwlwifi: fix compiler warning
      iwlwifi: set correct single/dual stream mask
      iwlwifi: more generic eeprom defines
      iwlwifi: remove duplicated debug functions
      iwlwifi: add hw revision for 6000g2 NIC
      iwlwifi: PA type for 6000g2 series
      iwlwifi: sanity check for turn on aggregation tid
      iwlwifi: more code clean up for agn devices
      iwlwifi: remove get_stats callback function
      iwlwifi: remove outdated comments
      iwlwifi: set hw parameters based on device type
      iwlwifi: greenfield support only true for 11n devices
      iwlwifi: remove powersave debugfs if it is not supported
      iwlwifi: rename "tx_power" to "chain_tx_power"
      iwlwifi: remove device type checking for tx power in debugfs
      iwlwifi: use .cfg to enable/disable continuous ucode trace
      iwlwifi: use cfg to configure calibration operation
      iwlwifi: give correct return information for tx power debugfs
      iwlwifi: wimax co-exist code clean up
      iwlwifi: checking for all the possible failure cases
      iwlwifi: "tx power per chain" are part of ucode_tx_stats
      iwlwifi: provide more comments for cfg structure
      mac80211: check channel switch mode for future frames transmit

Wolfgang Grandegger (1):
      can: sja1000 platform data fixes

Xose Vazquez Perez (9):
      wireless: rt2x00: rt2800usb: identify ids-chips
      wireless: rt2x00: rt2800usb: delete id
      wireless: rt2x00: rt2800pci: new id
      wireless: rt2x00: rt2800usb: new ids
      wireless: rt2x00: rt2800usb: identify Sitecom devices
      wireless: rt2x00: rt2800usb: identify Hawking devices
      wireless: rt2x00: rt2800usb: identify Allwin devices
      wireless: rt2x00: rt2800usb: be in sync with latest windows drivers.
      wireless: rt2x00: rt2800usb: replace X by x

YOSHIFUJI Hideaki (6):
      netfilter: ebt_ip6: Use ipv6_masked_addr_cmp()
      netfilter: remove stale declaration for ip6_masked_addrcmp()
      ipv6: Reduce timer events for addrconf_verify().
      ipv6 mcast: Introduce include/net/mld.h for MLD definitions.
      bridge br_multicast: Make functions less ipv4 dependent.
      bridge br_multicast: IPv6 MLD support.

YOSHIFUJI Hideaki / ÂêâËó§Ëã±Êòé (6):
      ipv6: Use __fls() instead of fls() in __ipv6_addr_diff().
      sctp: Use ipv6_addr_diff() in sctp_v6_addr_match_len().
      ipv6 fib: Use "Sweezle" to optimize addr_bit_test().
      ipv6 fib: Make rt6_info{} more cache-line aware.
      mac80211: Ensure initializing private mc_list in prepare_multicast().
      bridge br_multicast: Ensure to initialize BR_INPUT_SKB_CB(skb)->mrouters_only.

Yegor Yefremov (2):
      can: sja1000: allow shared interrupt definition
      can: sja1000: add read/write routines for 8, 16 and 32-bit register access

Yi Zou (3):
      ixgbe: fix wrong offset to fc_frame_header in ixgbe_fcoe_ddp
      ixgbe: remove some redundant code in setting FCoE FIP filter
      ixgbe: always enable vlan strip/insert when DCB is enabled

Zhitong Wang (4):
      netfilter: remove unused headers in net/netfilter/nfnetlink.c
      netfilter: remove unused headers in net/ipv6/netfilter/ip6t_LOG.c
      netfilter: remove unused headers in net/ipv4/netfilter/nf_nat_h323.c
      netfilter: fix some coding styles and remove moduleparam.h

Zhu Yi (13):
      iwmc3200wifi: refuse to associate on unallowed channels
      iwmc3200wifi: remove "_safe" for some list_for_each_entry usage
      iwmc3200wifi: add ftrace event tracing support
      iwmc3200wifi: protect rx_tickets and rx_packets[] lists
      iwmc3200wifi: increase concatenated buffer
      iwmc3200wifi: mark some pmksa functions static
      iwmc3200wifi: typo fix and code cleanup
      mac80211: support paged rx SKBs
      iwlwifi: remove skb_linearize for rx frames
      ipw2200: restart adapter only when abort_scan doesn't work
      iwlwifi: clear rxq->queue in queue reset
      mac80211: delay skb linearising in rx decryption
      iwlwifi: avoid Tx queue memory allocation in interface down

andrew hendry (10):
      X25: Use identifiers for isdn device to x25 interface
      X25: Use identifiers for x25 async device to x25 interface
      X25: Use identifiers for lapbether device to x25 interface
      X25: Use identifiers for cyclades device to x25 interface
      X25: Use identifiers for hdlc x25 device to x25 interface
      X25: Update X25 interface documentation
      X25: Move qbit flag to bitfield
      X25: Move interrupt flag to bitfield
      X25: Move accept approve flag to bitfield
      X25: Remove bkl in sockopts

chavey (1):
      net: fix ethtool coding style errors and warnings

florian@mickler.org (3):
      Document the rfkill sysfs ABI
      enhance sysfs rfkill interface
      rename new rfkill sysfs knobs

laurent chavey (1):
      fix net/core/dst.c coding style error and warnings

stephen hemminger (32):
      bridge: per-cpu packet statistics (v3)
      ipv6: convert temporary address list to list macros
      ipv6: convert addrconf list to hlist
      IPv6: convert addrconf hash list to RCU
      ipv6: user better hash for addrconf
      ipv6: convert idev_list to list macros
      IPv6: addrconf cleanup addrconf_verify
      sky2: support Yukon EC_U rev B1 and later
      sky2: add XL revisions
      sky2: avoid duplicate link up on Optima chip
      netdev: ethtool RXHASH flag
      IPv6: keep route for tentative address
      IPv6: keep tentative addresses in hash table
      ipv6: additional ref count for hash list unnecessary
      IPv6: only notify protocols if address is compeletely gone
      dst: don't inline dst_ifdown
      sky2: size status ring based on Tx/Rx ring
      bridge: use is_multicast_ether_addr
      bridge: multicast router list manipulation
      bridge: simplify multicast_add_router
      bridge: multicast flood
      bridge: multicast port group RCU fix
      bridge: multicast_flood cleanup
      forcedeth: Stay in NAPI as long as there's work
      sky2: version 1.28
      bridge: netpoll cleanup
      bridge: change console message interface
      tbf: stop wanton destruction of children (v2)
      net sched: printk message severity
      xfrm: add severity to printk
      pfkey: add severity to printk
      net sched: cleanup and rate limit warning

 Documentation/ABI/obsolete/sysfs-class-rfkill      |   29 +
 Documentation/ABI/stable/sysfs-class-rfkill        |   67 +
 Documentation/Changes                              |    2 +-
 Documentation/feature-removal-schedule.txt         |   57 +-
 Documentation/networking/caif/Linux-CAIF.txt       |  212 +
 Documentation/networking/caif/README               |  109 +
 Documentation/networking/ip-sysctl.txt             |   31 +
 Documentation/networking/l2tp.txt                  |  247 +-
 Documentation/networking/x25-iface.txt             |   16 +-
 Documentation/rfkill.txt                           |   44 +-
 Documentation/sysctl/net.txt                       |   10 +
 MAINTAINERS                                        |   11 +-
 arch/arm/mach-mx2/pcm970-baseboard.c               |    6 +-
 arch/arm/mach-mx3/mach-pcm037.c                    |    6 +-
 arch/arm/mach-pxa/icontrol.c                       |    9 +-
 arch/arm/mach-pxa/zeus.c                           |    4 +-
 arch/microblaze/include/asm/system.h               |   11 +
 arch/mips/sibyte/swarm/platform.c                  |   54 +
 drivers/atm/Kconfig                                |    1 +
 drivers/atm/atmtcp.c                               |    6 +-
 drivers/atm/eni.c                                  |    2 +-
 drivers/atm/he.c                                   |    4 +-
 drivers/bluetooth/btmrvl_drv.h                     |    8 +-
 drivers/bluetooth/btmrvl_main.c                    |   92 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    7 +-
 drivers/bluetooth/hci_h4.c                         |    2 +-
 drivers/bluetooth/hci_ll.c                         |    8 +-
 drivers/bluetooth/hci_vhci.c                       |    2 +-
 drivers/infiniband/hw/nes/nes_nic.c                |    7 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |   15 +-
 drivers/isdn/i4l/isdn_x25iface.c                   |   17 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |   14 +-
 drivers/net/3c501.c                                |    2 -
 drivers/net/3c503.c                                |   44 +-
 drivers/net/3c505.c                                |   14 +-
 drivers/net/3c507.c                                |    5 +-
 drivers/net/3c509.c                                |    4 +-
 drivers/net/3c515.c                                |    6 +-
 drivers/net/3c523.c                                |   11 +-
 drivers/net/3c527.c                                |    6 +-
 drivers/net/3c59x.c                                |   11 +-
 drivers/net/7990.c                                 |   12 +-
 drivers/net/8139cp.c                               |    9 +-
 drivers/net/8139too.c                              |    8 +-
 drivers/net/82596.c                                |    9 +-
 drivers/net/Kconfig                                |   46 +-
 drivers/net/Makefile                               |    3 +-
 drivers/net/a2065.c                                |   10 +-
 drivers/net/ac3200.c                               |    2 -
 drivers/net/acenic.c                               |   44 +-
 drivers/net/acenic.h                               |    6 +-
 drivers/net/amd8111e.c                             |    8 +-
 drivers/net/apne.c                                 |    1 -
 drivers/net/appletalk/cops.c                       |    9 +-
 drivers/net/appletalk/ltpc.c                       |    1 -
 drivers/net/arcnet/arcnet.c                        |    1 -
 drivers/net/arcnet/com20020-pci.c                  |    4 +-
 drivers/net/ariadne.c                              |    2 -
 drivers/net/arm/am79c961a.c                        |    7 +-
 drivers/net/arm/at91_ether.c                       |    7 +-
 drivers/net/arm/ep93xx_eth.c                       |    2 -
 drivers/net/arm/ether1.c                           |    1 -
 drivers/net/arm/ether3.c                           |    1 -
 drivers/net/arm/ixp4xx_eth.c                       |    9 +-
 drivers/net/arm/ks8695net.c                        |   13 +-
 drivers/net/arm/w90p910_ether.c                    |    7 +-
 drivers/net/at1700.c                               |   11 +-
 drivers/net/atarilance.c                           |    5 +-
 drivers/net/atl1c/atl1c_ethtool.c                  |    2 -
 drivers/net/atl1c/atl1c_main.c                     |    9 +-
 drivers/net/atl1e/atl1e_ethtool.c                  |    2 -
 drivers/net/atl1e/atl1e_main.c                     |   16 +-
 drivers/net/atlx/atl1.c                            |    7 +-
 drivers/net/atlx/atl2.c                            |    8 +-
 drivers/net/atlx/atlx.c                            |    6 +-
 drivers/net/atp.c                                  |   10 +-
 drivers/net/au1000_eth.c                           |  262 +-
 drivers/net/au1000_eth.h                           |    4 +-
 drivers/net/ax88796.c                              |    1 -
 drivers/net/b44.c                                  |    8 +-
 drivers/net/bcm63xx_enet.c                         |   14 +-
 drivers/net/benet/be.h                             |   11 +-
 drivers/net/benet/be_cmds.c                        |   14 +-
 drivers/net/benet/be_cmds.h                        |    2 +-
 drivers/net/benet/be_ethtool.c                     |    5 +-
 drivers/net/benet/be_hw.h                          |    3 +
 drivers/net/benet/be_main.c                        |  315 +-
 drivers/net/bfin_mac.c                             |  559 ++-
 drivers/net/bfin_mac.h                             |   18 +
 drivers/net/bmac.c                                 |   15 +-
 drivers/net/bnx2.c                                 |  102 +-
 drivers/net/bnx2.h                                 |    9 +-
 drivers/net/bnx2x.h                                |   66 +-
 drivers/net/bnx2x_link.c                           |   12 +-
 drivers/net/bnx2x_main.c                           | 1878 +++++--
 drivers/net/bnx2x_reg.h                            |   27 +-
 drivers/net/bonding/bond_ipv6.c                    |    9 +-
 drivers/net/bonding/bond_main.c                    |  275 +-
 drivers/net/bonding/bonding.h                      |    2 +-
 drivers/net/caif/Kconfig                           |   17 +
 drivers/net/caif/Makefile                          |   12 +
 drivers/net/caif/caif_serial.c                     |  449 ++
 drivers/net/can/at91_can.c                         |    4 -
 drivers/net/can/bfin_can.c                         |    3 -
 drivers/net/can/mcp251x.c                          |   16 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |    1 -
 drivers/net/can/mscan/mscan.c                      |    1 -
 drivers/net/can/sja1000/Kconfig                    |    4 +-
 drivers/net/can/sja1000/ems_pci.c                  |    1 -
 drivers/net/can/sja1000/kvaser_pci.c               |    1 -
 drivers/net/can/sja1000/plx_pci.c                  |  154 +-
 drivers/net/can/sja1000/sja1000.c                  |   23 +-
 drivers/net/can/sja1000/sja1000.h                  |    1 +
 drivers/net/can/sja1000/sja1000_isa.c              |    1 -
 drivers/net/can/sja1000/sja1000_of_platform.c      |    1 -
 drivers/net/can/sja1000/sja1000_platform.c         |   48 +-
 drivers/net/can/ti_hecc.c                          |    1 -
 drivers/net/can/usb/ems_usb.c                      |    4 -
 drivers/net/cassini.c                              |   15 +-
 drivers/net/chelsio/pm3393.c                       |    7 +-
 drivers/net/chelsio/sge.c                          |   58 +-
 drivers/net/cnic.c                                 |   80 +-
 drivers/net/cnic.h                                 |   10 +-
 drivers/net/cpmac.c                                |   17 +-
 drivers/net/cris/eth_v10.c                         |    8 +-
 drivers/net/cs89x0.c                               |    3 -
 drivers/net/cxgb3/l2t.c                            |    1 -
 drivers/net/cxgb3/sge.c                            |   20 +-
 drivers/net/cxgb3/xgmac.c                          |    8 +-
 drivers/net/cxgb4/cxgb4.h                          |    9 +-
 drivers/net/cxgb4/cxgb4_main.c                     |  102 +-
 drivers/net/cxgb4/sge.c                            |   11 +-
 drivers/net/cxgb4/t4_hw.c                          |  117 +-
 drivers/net/cxgb4/t4_msg.h                         |    1 +
 drivers/net/cxgb4/t4fw_api.h                       |    4 +-
 drivers/net/davinci_emac.c                         |    8 +-
 drivers/net/de600.c                                |    4 +-
 drivers/net/de620.c                                |    1 -
 drivers/net/declance.c                             |   10 +-
 drivers/net/defxx.c                                |    6 +-
 drivers/net/depca.c                                |   15 +-
 drivers/net/dl2k.c                                 |    8 +-
 drivers/net/dm9000.c                               |   50 +-
 drivers/net/dnet.c                                 |    4 +-
 drivers/net/e100.c                                 |  190 +-
 drivers/net/e1000/e1000.h                          |   37 +-
 drivers/net/e1000/e1000_ethtool.c                  |   89 +-
 drivers/net/e1000/e1000_hw.c                       |  356 +-
 drivers/net/e1000/e1000_hw.h                       |    1 +
 drivers/net/e1000/e1000_main.c                     |  429 +-
 drivers/net/e1000/e1000_osdep.h                    |   14 -
 drivers/net/e1000/e1000_param.c                    |  112 +-
 drivers/net/e1000e/82571.c                         |   29 +-
 drivers/net/e1000e/defines.h                       |    9 +
 drivers/net/e1000e/e1000.h                         |   26 +-
 drivers/net/e1000e/es2lan.c                        |   11 +-
 drivers/net/e1000e/ethtool.c                       |   48 +-
 drivers/net/e1000e/hw.h                            |    5 +
 drivers/net/e1000e/ich8lan.c                       |  391 +-
 drivers/net/e1000e/lib.c                           |   60 +-
 drivers/net/e1000e/netdev.c                        |  844 +++-
 drivers/net/e1000e/param.c                         |   25 +-
 drivers/net/e1000e/phy.c                           |   21 +-
 drivers/net/e2100.c                                |    1 -
 drivers/net/eepro.c                                |   13 +-
 drivers/net/eexpress.c                             |   11 +-
 drivers/net/ehea/ehea.h                            |    2 +-
 drivers/net/ehea/ehea_main.c                       |   78 +-
 drivers/net/ehea/ehea_qmr.c                        |   43 +-
 drivers/net/ehea/ehea_qmr.h                        |   14 +-
 drivers/net/enc28j60.c                             |    2 -
 drivers/net/enic/Makefile                          |    2 +-
 drivers/net/enic/cq_enet_desc.h                    |   12 +-
 drivers/net/enic/enic.h                            |   12 +-
 drivers/net/enic/enic_main.c                       |  341 ++-
 drivers/net/enic/enic_res.c                        |    5 -
 drivers/net/enic/enic_res.h                        |    1 -
 drivers/net/enic/vnic_dev.c                        |  110 +-
 drivers/net/enic/vnic_dev.h                        |   10 +-
 drivers/net/enic/vnic_rq.c                         |    4 +-
 drivers/net/enic/vnic_vic.c                        |   73 +
 drivers/net/enic/vnic_vic.h                        |   59 +
 drivers/net/enic/vnic_wq.c                         |    4 +-
 drivers/net/epic100.c                              |   13 +-
 drivers/net/eql.c                                  |    2 +-
 drivers/net/es3210.c                               |    2 -
 drivers/net/eth16i.c                               |    5 +-
 drivers/net/ethoc.c                                |    8 +-
 drivers/net/ewrk3.c                                |   14 +-
 drivers/net/fealnx.c                               |    9 +-
 drivers/net/fec.c                                  | 1140 +---
 drivers/net/fec_mpc52xx.c                          |    8 +-
 drivers/net/forcedeth.c                            |  251 +-
 drivers/net/fs_enet/fs_enet-main.c                 |    2 -
 drivers/net/fs_enet/mac-fcc.c                      |    6 +-
 drivers/net/fs_enet/mac-fec.c                      |    6 +-
 drivers/net/fs_enet/mac-scc.c                      |    6 +-
 drivers/net/fsl_pq_mdio.c                          |    6 +-
 drivers/net/gianfar.c                              |  213 +-
 drivers/net/gianfar.h                              |    8 +-
 drivers/net/greth.c                                |    7 +-
 drivers/net/hamachi.c                              |   11 +-
 drivers/net/hamradio/baycom_ser_fdx.c              |    2 +-
 drivers/net/hamradio/scc.c                         |    1 -
 drivers/net/hp-plus.c                              |    4 -
 drivers/net/hp.c                                   |    3 -
 drivers/net/hp100.c                                |   16 +-
 drivers/net/ibm_newemac/core.c                     |   12 +-
 drivers/net/ibmlana.c                              |    8 +-
 drivers/net/ibmveth.c                              |   24 +-
 drivers/net/ifb.c                                  |    1 -
 drivers/net/igb/e1000_82575.c                      |   35 +-
 drivers/net/igb/e1000_82575.h                      |    9 +-
 drivers/net/igb/e1000_defines.h                    |    5 +-
 drivers/net/igb/e1000_hw.h                         |   17 +-
 drivers/net/igb/e1000_mac.c                        |   27 +-
 drivers/net/igb/igb.h                              |    9 +-
 drivers/net/igb/igb_ethtool.c                      |   58 +-
 drivers/net/igb/igb_main.c                         |  613 ++-
 drivers/net/igbvf/ethtool.c                        |    2 -
 drivers/net/igbvf/netdev.c                         |   82 +-
 drivers/net/ioc3-eth.c                             |    7 +-
 drivers/net/ipg.c                                  |   11 +-
 drivers/net/ipg.h                                  |  109 +-
 drivers/net/irda/Kconfig                           |    6 +
 drivers/net/irda/Makefile                          |    1 +
 drivers/net/irda/ali-ircc.c                        |   32 +-
 drivers/net/irda/au1k_ir.c                         |    1 -
 drivers/net/irda/donauboe.c                        |    2 -
 drivers/net/irda/irda-usb.c                        |    2 +-
 drivers/net/irda/mcs7780.c                         |    4 -
 drivers/net/irda/pxaficp_ir.c                      |    1 -
 drivers/net/irda/sa1100_ir.c                       |    2 -
 drivers/net/irda/sh_irda.c                         |  865 +++
 drivers/net/irda/sh_sir.c                          |   12 +-
 drivers/net/irda/sir_dev.c                         |    1 -
 drivers/net/irda/smsc-ircc2.c                      |    3 +-
 drivers/net/irda/via-ircc.h                        |    2 +-
 drivers/net/irda/vlsi_ir.c                         |    5 +-
 drivers/net/irda/w83977af_ir.c                     |    2 -
 drivers/net/iseries_veth.c                         |    6 +-
 drivers/net/ixgb/ixgb.h                            |    8 +-
 drivers/net/ixgb/ixgb_ee.c                         |   24 +-
 drivers/net/ixgb/ixgb_hw.c                         |  164 +-
 drivers/net/ixgb/ixgb_hw.h                         |   12 -
 drivers/net/ixgb/ixgb_main.c                       |  159 +-
 drivers/net/ixgb/ixgb_osdep.h                      |   16 +-
 drivers/net/ixgb/ixgb_param.c                      |   31 +-
 drivers/net/ixgbe/ixgbe.h                          |    3 +
 drivers/net/ixgbe/ixgbe_82598.c                    |    8 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |  418 +--
 drivers/net/ixgbe/ixgbe_common.c                   |  539 ++-
 drivers/net/ixgbe/ixgbe_common.h                   |   22 +-
 drivers/net/ixgbe/ixgbe_dcb_nl.c                   |    1 -
 drivers/net/ixgbe/ixgbe_ethtool.c                  |  146 +-
 drivers/net/ixgbe/ixgbe_fcoe.c                     |   17 +-
 drivers/net/ixgbe/ixgbe_main.c                     |  656 ++-
 drivers/net/ixgbe/ixgbe_phy.c                      |   42 +-
 drivers/net/ixgbe/ixgbe_phy.h                      |    3 +
 drivers/net/ixgbe/ixgbe_sriov.c                    |  137 +-
 drivers/net/ixgbe/ixgbe_sriov.h                    |    8 +-
 drivers/net/ixgbe/ixgbe_type.h                     |   50 +-
 drivers/net/ixgbevf/defines.h                      |   12 +-
 drivers/net/ixgbevf/ixgbevf_main.c                 |  125 +-
 drivers/net/ixgbevf/vf.c                           |   27 +-
 drivers/net/ixgbevf/vf.h                           |    4 +-
 drivers/net/ixp2000/ixpdev.c                       |    2 -
 drivers/net/jme.c                                  |   12 +-
 drivers/net/korina.c                               |   12 +-
 drivers/net/ks8842.c                               |   61 +-
 drivers/net/ks8851.c                               |  448 ++-
 drivers/net/ks8851.h                               |   14 +-
 drivers/net/ks8851_mll.c                           |   63 +-
 drivers/net/ksz884x.c                              |   86 +-
 drivers/net/lance.c                                |    4 +-
 drivers/net/lib82596.c                             |   11 +-
 drivers/net/lib8390.c                              |   22 +-
 drivers/net/ll_temac.h                             |   14 +-
 drivers/net/ll_temac_main.c                        |  159 +-
 drivers/net/lne390.c                               |    2 -
 drivers/net/lp486e.c                               |    8 +-
 drivers/net/mac8390.c                              |    2 -
 drivers/net/mac89x0.c                              |    1 -
 drivers/net/macb.c                                 |    9 +-
 drivers/net/mace.c                                 |    6 +-
 drivers/net/macmace.c                              |    7 +-
 drivers/net/macvlan.c                              |   23 +-
 drivers/net/macvtap.c                              |   46 +-
 drivers/net/meth.c                                 |    4 +-
 drivers/net/mlx4/en_ethtool.c                      |    2 -
 drivers/net/mlx4/en_netdev.c                       |   53 +-
 drivers/net/mlx4/eq.c                              |    2 +-
 drivers/net/mlx4/mlx4_en.h                         |    3 +-
 drivers/net/mv643xx_eth.c                          |   10 +-
 drivers/net/myri10ge/myri10ge.c                    |   54 +-
 drivers/net/myri_sbus.c                            |    2 +-
 drivers/net/natsemi.c                              |   10 +-
 drivers/net/ne-h8300.c                             |    1 -
 drivers/net/ne.c                                   |    1 -
 drivers/net/ne2.c                                  |    1 -
 drivers/net/ne2k-pci.c                             |    1 -
 drivers/net/ne3210.c                               |    2 -
 drivers/net/netconsole.c                           |   15 +-
 drivers/net/netx-eth.c                             |    1 -
 drivers/net/netxen/netxen_nic.h                    |    6 +-
 drivers/net/netxen/netxen_nic_ethtool.c            |    9 +
 drivers/net/netxen/netxen_nic_hdr.h                |    8 -
 drivers/net/netxen/netxen_nic_hw.c                 |  131 +-
 drivers/net/netxen/netxen_nic_init.c               |  169 +-
 drivers/net/netxen/netxen_nic_main.c               |   74 +-
 drivers/net/ni5010.c                               |    5 +-
 drivers/net/ni52.c                                 |   13 +-
 drivers/net/ni65.c                                 |    5 +-
 drivers/net/niu.c                                  |   57 +-
 drivers/net/niu.h                                  |    7 +-
 drivers/net/octeon/octeon_mgmt.c                   |   66 +-
 drivers/net/pasemi_mac.c                           |    2 -
 drivers/net/pci-skeleton.c                         |    7 +-
 drivers/net/pcmcia/3c574_cs.c                      |    6 +-
 drivers/net/pcmcia/3c589_cs.c                      |  289 +-
 drivers/net/pcmcia/axnet_cs.c                      |   10 +-
 drivers/net/pcmcia/fmvj18x_cs.c                    |    9 +-
 drivers/net/pcmcia/ibmtr_cs.c                      |    2 -
 drivers/net/pcmcia/nmclan_cs.c                     |   12 +-
 drivers/net/pcmcia/smc91c92_cs.c                   |   14 +-
 drivers/net/pcmcia/xirc2ps_cs.c                    |    9 +-
 drivers/net/pcnet32.c                              |   15 +-
 drivers/net/phy/bcm63xx.c                          |    8 +
 drivers/net/phy/broadcom.c                         |   16 +
 drivers/net/phy/cicada.c                           |    8 +
 drivers/net/phy/davicom.c                          |    9 +
 drivers/net/phy/et1011c.c                          |    7 +
 drivers/net/phy/icplus.c                           |    7 +
 drivers/net/phy/lxt.c                              |    8 +
 drivers/net/phy/marvell.c                          |   13 +
 drivers/net/phy/mdio-bitbang.c                     |   60 +-
 drivers/net/phy/mdio_bus.c                         |    4 +-
 drivers/net/phy/micrel.c                           |    9 +
 drivers/net/phy/national.c                         |   10 +-
 drivers/net/phy/phy_device.c                       |   12 +
 drivers/net/phy/qsemi.c                            |    7 +
 drivers/net/phy/realtek.c                          |    7 +
 drivers/net/phy/smsc.c                             |   11 +
 drivers/net/phy/ste10Xp.c                          |    8 +
 drivers/net/phy/vitesse.c                          |    8 +
 drivers/net/plip.c                                 |    4 -
 drivers/net/ppp_generic.c                          |   19 +
 drivers/net/pppoe.c                                |   11 +-
 drivers/net/pppol2tp.c                             | 2680 ---------
 drivers/net/ps3_gelic_net.c                        |   13 +-
 drivers/net/ps3_gelic_wireless.c                   |   74 +-
 drivers/net/qla3xxx.c                              |   72 +-
 drivers/net/qla3xxx.h                              |    8 +-
 drivers/net/qlcnic/qlcnic.h                        |   40 +-
 drivers/net/qlcnic/qlcnic_ctx.c                    |    3 +-
 drivers/net/qlcnic/qlcnic_ethtool.c                |   34 +-
 drivers/net/qlcnic/qlcnic_hdr.h                    |   60 +-
 drivers/net/qlcnic/qlcnic_hw.c                     |  136 +-
 drivers/net/qlcnic/qlcnic_init.c                   |  101 +-
 drivers/net/qlcnic/qlcnic_main.c                   |  435 +-
 drivers/net/qlge/qlge.h                            |    8 +-
 drivers/net/qlge/qlge_dbg.c                        |    4 +-
 drivers/net/qlge/qlge_ethtool.c                    |    2 -
 drivers/net/qlge/qlge_main.c                       |   64 +-
 drivers/net/r6040.c                                |   46 +-
 drivers/net/r8169.c                                |  158 +-
 drivers/net/rrunner.c                              |    1 -
 drivers/net/s2io.c                                 |   15 +-
 drivers/net/s6gmac.c                               |    3 +-
 drivers/net/sb1000.c                               |    5 -
 drivers/net/sb1250-mac.c                           |  275 +-
 drivers/net/sc92031.c                              |    8 +-
 drivers/net/seeq8005.c                             |    4 +-
 drivers/net/sfc/efx.c                              |  137 +-
 drivers/net/sfc/efx.h                              |    4 +-
 drivers/net/sfc/ethtool.c                          |    6 +-
 drivers/net/sfc/falcon.c                           |   16 +-
 drivers/net/sfc/falcon_xmac.c                      |   22 +-
 drivers/net/sfc/mcdi.c                             |   32 +-
 drivers/net/sfc/mcdi_mac.c                         |   25 +-
 drivers/net/sfc/mcdi_pcol.h                        |   71 +-
 drivers/net/sfc/mcdi_phy.c                         |  152 +-
 drivers/net/sfc/net_driver.h                       |   76 +-
 drivers/net/sfc/nic.c                              |  114 +-
 drivers/net/sfc/nic.h                              |    3 +
 drivers/net/sfc/selftest.c                         |    8 +-
 drivers/net/sfc/selftest.h                         |    4 +-
 drivers/net/sfc/siena.c                            |   19 +
 drivers/net/sfc/tx.c                               |   61 +-
 drivers/net/sfc/workarounds.h                      |    2 +-
 drivers/net/sgiseeq.c                              |    6 +-
 drivers/net/sh_eth.c                               |    2 -
 drivers/net/sis190.c                               |    6 +-
 drivers/net/sis900.c                               |   25 +-
 drivers/net/skfp/fplustm.c                         |    2 +-
 drivers/net/skfp/pcmplc.c                          |    4 +-
 drivers/net/skfp/skfddi.c                          |   15 +-
 drivers/net/skfp/smt.c                             |    2 +-
 drivers/net/skfp/srf.c                             |    2 +-
 drivers/net/skge.c                                 |   46 +-
 drivers/net/skge.h                                 |    4 +-
 drivers/net/sky2.c                                 |  215 +-
 drivers/net/sky2.h                                 |   41 +-
 drivers/net/slhc.c                                 |    1 -
 drivers/net/slip.c                                 |    4 +-
 drivers/net/smc-mca.c                              |    1 -
 drivers/net/smc-ultra.c                            |    1 -
 drivers/net/smc-ultra32.c                          |    1 -
 drivers/net/smc911x.c                              |   21 +-
 drivers/net/smc9194.c                              |   61 +-
 drivers/net/smc91x.c                               |   12 +-
 drivers/net/smsc911x.c                             |    7 +-
 drivers/net/smsc9420.c                             |    8 +-
 drivers/net/sonic.c                                |   10 +-
 drivers/net/spider_net.c                           |    8 +-
 drivers/net/starfire.c                             |   16 +-
 drivers/net/stmmac/Makefile                        |    2 +-
 drivers/net/stmmac/common.h                        |   21 +-
 drivers/net/stmmac/dwmac100.c                      |  538 --
 drivers/net/stmmac/dwmac100.h                      |    5 +
 drivers/net/stmmac/dwmac1000.h                     |   12 -
 drivers/net/stmmac/dwmac1000_core.c                |   41 +-
 drivers/net/stmmac/dwmac1000_dma.c                 |  338 +--
 drivers/net/stmmac/dwmac100_core.c                 |  196 +
 drivers/net/stmmac/dwmac100_dma.c                  |  134 +
 drivers/net/stmmac/dwmac_dma.h                     |    1 +
 drivers/net/stmmac/dwmac_lib.c                     |   19 +-
 drivers/net/stmmac/enh_desc.c                      |  337 ++
 drivers/net/stmmac/norm_desc.c                     |  236 +
 drivers/net/stmmac/stmmac.h                        |   10 +-
 drivers/net/stmmac/stmmac_ethtool.c                |    7 -
 drivers/net/stmmac/stmmac_main.c                   |   32 +-
 drivers/net/stmmac/stmmac_timer.c                  |    6 -
 drivers/net/stnic.c                                |    1 -
 drivers/net/sun3_82586.c                           |   13 +-
 drivers/net/sun3lance.c                            |    8 +-
 drivers/net/sunbmac.c                              |   12 +-
 drivers/net/sundance.c                             |   14 +-
 drivers/net/sungem.c                               |    9 +-
 drivers/net/sunhme.c                               |   22 +-
 drivers/net/sunlance.c                             |   11 +-
 drivers/net/sunqe.c                                |    7 +-
 drivers/net/sunvnet.c                              |    9 +-
 drivers/net/tc35815.c                              |    8 +-
 drivers/net/tehuti.c                               |   10 +-
 drivers/net/tg3.c                                  |  839 ++--
 drivers/net/tg3.h                                  |   17 +-
 drivers/net/tlan.c                                 |   13 +-
 drivers/net/tokenring/3c359.c                      |  112 +-
 drivers/net/tokenring/ibmtr.c                      |   13 +-
 drivers/net/tokenring/lanstreamer.c                |   58 +-
 drivers/net/tokenring/madgemc.c                    |   12 -
 drivers/net/tokenring/olympic.c                    |   74 +-
 drivers/net/tokenring/smctr.c                      |    4 +-
 drivers/net/tokenring/tms380tr.c                   |   65 +-
 drivers/net/tsi108_eth.c                           |   16 +-
 drivers/net/tulip/de2104x.c                        |   13 +-
 drivers/net/tulip/de4x5.c                          |   87 +-
 drivers/net/tulip/dmfe.c                           |   17 +-
 drivers/net/tulip/media.c                          |    2 -
 drivers/net/tulip/pnic.c                           |    2 +-
 drivers/net/tulip/tulip_core.c                     |   31 +-
 drivers/net/tulip/uli526x.c                        |   10 +-
 drivers/net/tulip/winbond-840.c                    |   18 +-
 drivers/net/tulip/xircom_cb.c                      |    6 +-
 drivers/net/tun.c                                  |   55 +-
 drivers/net/typhoon.c                              |    8 +-
 drivers/net/ucc_geth.c                             |   12 +-
 drivers/net/usb/asix.c                             |   53 +-
 drivers/net/usb/catc.c                             |    6 +-
 drivers/net/usb/cdc_ether.c                        |  113 +-
 drivers/net/usb/dm9601.c                           |    9 +-
 drivers/net/usb/hso.c                              |    4 -
 drivers/net/usb/kaweth.c                           |    1 -
 drivers/net/usb/mcs7830.c                          |   10 +-
 drivers/net/usb/pegasus.c                          |    9 +-
 drivers/net/usb/pegasus.h                          |    2 +-
 drivers/net/usb/rndis_host.c                       |   18 +-
 drivers/net/usb/smsc75xx.c                         |    6 +-
 drivers/net/usb/smsc95xx.c                         |    6 +-
 drivers/net/usb/usbnet.c                           |   15 +-
 drivers/net/via-rhine.c                            |   10 +-
 drivers/net/via-velocity.c                         |  121 +-
 drivers/net/via-velocity.h                         |   77 +-
 drivers/net/virtio_net.c                           |   57 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   11 +-
 drivers/net/vxge/vxge-config.c                     |   41 +-
 drivers/net/vxge/vxge-config.h                     |   34 +-
 drivers/net/vxge/vxge-ethtool.c                    |    5 +-
 drivers/net/vxge/vxge-main.c                       |  245 +-
 drivers/net/vxge/vxge-main.h                       |    6 +
 drivers/net/vxge/vxge-traffic.c                    |   79 +-
 drivers/net/vxge/vxge-traffic.h                    |   50 +-
 drivers/net/vxge/vxge-version.h                    |    4 +-
 drivers/net/wan/cycx_x25.c                         |   13 +-
 drivers/net/wan/dscc4.c                            |    2 -
 drivers/net/wan/hd64570.c                          |    1 -
 drivers/net/wan/hd64572.c                          |    1 -
 drivers/net/wan/hdlc_x25.c                         |   12 +-
 drivers/net/wan/ixp4xx_hss.c                       |    1 -
 drivers/net/wan/lapbether.c                        |   12 +-
 drivers/net/wan/lmc/lmc_main.c                     |    6 +-
 drivers/net/wan/pc300_drv.c                        |    5 +-
 drivers/net/wan/pc300_tty.c                        |    2 +-
 drivers/net/wan/sdla.c                             |    2 +-
 drivers/net/wan/wanxl.c                            |    1 -
 drivers/net/wan/x25_asy.c                          |   12 +-
 drivers/net/wd.c                                   |    1 -
 drivers/net/wimax/i2400m/control.c                 |   27 +-
 drivers/net/wimax/i2400m/driver.c                  |  167 +-
 drivers/net/wimax/i2400m/i2400m-sdio.h             |    5 +-
 drivers/net/wimax/i2400m/i2400m.h                  |   82 +-
 drivers/net/wimax/i2400m/netdev.c                  |   14 +-
 drivers/net/wimax/i2400m/rx.c                      |  116 +-
 drivers/net/wimax/i2400m/sdio-rx.c                 |    2 -
 drivers/net/wimax/i2400m/sdio-tx.c                 |   35 +-
 drivers/net/wimax/i2400m/sdio.c                    |    7 +
 drivers/net/wimax/i2400m/tx.c                      |  155 +-
 drivers/net/wimax/i2400m/usb-notif.c               |    1 -
 drivers/net/wimax/i2400m/usb.c                     |   12 +-
 drivers/net/wireless/Kconfig                       |   92 +-
 drivers/net/wireless/adm8211.c                     |   12 +-
 drivers/net/wireless/airo.c                        |   37 +-
 drivers/net/wireless/at76c50x-usb.c                |    2 +-
 drivers/net/wireless/ath/Kconfig                   |    2 +-
 drivers/net/wireless/ath/ar9170/ar9170.h           |   52 +-
 drivers/net/wireless/ath/ar9170/cmd.h              |    2 +-
 drivers/net/wireless/ath/ar9170/eeprom.h           |    4 +-
 drivers/net/wireless/ath/ar9170/hw.h               |    1 +
 drivers/net/wireless/ath/ar9170/main.c             |  587 +--
 drivers/net/wireless/ath/ar9170/usb.c              |   17 +-
 drivers/net/wireless/ath/ath.h                     |   27 +-
 drivers/net/wireless/ath/ath5k/Makefile            |    1 +
 drivers/net/wireless/ath/ath5k/ani.c               |  744 +++
 drivers/net/wireless/ath/ath5k/ani.h               |  104 +
 drivers/net/wireless/ath/ath5k/ath5k.h             |  313 +-
 drivers/net/wireless/ath/ath5k/attach.c            |    7 +-
 drivers/net/wireless/ath/ath5k/base.c              |  329 +-
 drivers/net/wireless/ath/ath5k/base.h              |   39 +-
 drivers/net/wireless/ath/ath5k/caps.c              |    9 +-
 drivers/net/wireless/ath/ath5k/debug.c             |  382 ++
 drivers/net/wireless/ath/ath5k/debug.h             |    4 +
 drivers/net/wireless/ath/ath5k/desc.c              |   19 +-
 drivers/net/wireless/ath/ath5k/desc.h              |   35 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |    4 +-
 drivers/net/wireless/ath/ath5k/eeprom.h            |   88 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |  379 +--
 drivers/net/wireless/ath/ath5k/phy.c               |   77 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |   17 -
 drivers/net/wireless/ath/ath5k/reg.h               |   42 +-
 drivers/net/wireless/ath/ath5k/reset.c             |   41 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |   21 +
 drivers/net/wireless/ath/ath9k/Makefile            |   26 +-
 drivers/net/wireless/ath/ath9k/ahb.c               |    1 +
 drivers/net/wireless/ath/ath9k/ani.c               |  217 +-
 drivers/net/wireless/ath/ath9k/ani.h               |    1 -
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h   |  742 +++
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        | 1374 +++++
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h   | 1254 ++++
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      | 1000 ++++
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |  598 ++
 .../ath/ath9k/{initvals.h => ar9002_initvals.h}    | 2292 +-------
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |  480 ++
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |  535 ++
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |  572 ++
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |  802 +++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     | 1838 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |  323 ++
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  205 +
 drivers/net/wireless/ath/ath9k/ar9003_initvals.h   | 1784 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |  614 ++
 drivers/net/wireless/ath/ath9k/ar9003_mac.h        |  120 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        | 1134 ++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |  847 +++
 drivers/net/wireless/ath/ath9k/ath9k.h             |   28 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   40 +-
 drivers/net/wireless/ath/ath9k/calib.c             | 1024 +----
 drivers/net/wireless/ath/ath9k/calib.h             |   19 +-
 drivers/net/wireless/ath/ath9k/common.c            |  392 ++-
 drivers/net/wireless/ath/ath9k/common.h            |   17 +-
 drivers/net/wireless/ath/ath9k/debug.c             |  297 +-
 drivers/net/wireless/ath/ath9k/debug.h             |   21 +-
 drivers/net/wireless/ath/ath9k/eeprom.c            |   11 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |   25 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |   19 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |   11 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |   18 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |   17 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           | 1008 ++++
 drivers/net/wireless/ath/ath9k/hif_usb.h           |  104 +
 drivers/net/wireless/ath/ath9k/htc.h               |  464 ++
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |  255 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |  834 +++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      | 1775 ++++++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  707 +++
 drivers/net/wireless/ath/ath9k/htc_hst.c           |  480 ++
 drivers/net/wireless/ath/ath9k/htc_hst.h           |  245 +
 drivers/net/wireless/ath/ath9k/hw-ops.h            |  280 +
 drivers/net/wireless/ath/ath9k/hw.c                | 1913 ++-----
 drivers/net/wireless/ath/ath9k/hw.h                |  275 +-
 drivers/net/wireless/ath/ath9k/init.c              |   88 +-
 drivers/net/wireless/ath/ath9k/mac.c               |  571 +--
 drivers/net/wireless/ath/ath9k/mac.h               |   93 +-
 drivers/net/wireless/ath/ath9k/main.c              |  158 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    2 +
 drivers/net/wireless/ath/ath9k/phy.c               |  978 ----
 drivers/net/wireless/ath/ath9k/phy.h               |  596 +--
 drivers/net/wireless/ath/ath9k/rc.c                |   21 +-
 drivers/net/wireless/ath/ath9k/rc.h                |   11 +-
 drivers/net/wireless/ath/ath9k/recv.c              |  533 ++-
 drivers/net/wireless/ath/ath9k/reg.h               |  183 +-
 drivers/net/wireless/ath/ath9k/virtual.c           |    2 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |  336 ++
 drivers/net/wireless/ath/ath9k/wmi.h               |  139 +
 drivers/net/wireless/ath/ath9k/xmit.c              |  591 ++-
 drivers/net/wireless/ath/debug.h                   |    1 +
 drivers/net/wireless/ath/hw.c                      |    4 +-
 drivers/net/wireless/ath/regd.c                    |    4 +-
 drivers/net/wireless/atmel.c                       |    1 -
 drivers/net/wireless/b43/b43.h                     |    1 +
 drivers/net/wireless/b43/main.c                    |   26 +-
 drivers/net/wireless/b43/phy_n.c                   |  479 ++-
 drivers/net/wireless/b43/phy_n.h                   |   21 +-
 drivers/net/wireless/b43/tables_nphy.c             |   20 +-
 drivers/net/wireless/b43/tables_nphy.h             |   37 +-
 drivers/net/wireless/b43/xmit.c                    |    1 -
 drivers/net/wireless/b43legacy/main.c              |   21 +-
 drivers/net/wireless/b43legacy/xmit.c              |    1 -
 drivers/net/wireless/hostap/hostap_80211_rx.c      |    3 +-
 drivers/net/wireless/hostap/hostap_ap.c            |    2 +-
 drivers/net/wireless/hostap/hostap_download.c      |    2 +-
 drivers/net/wireless/hostap/hostap_ioctl.c         |    3 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |   49 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |  190 +-
 drivers/net/wireless/ipw2x00/libipw.h              |   14 +-
 drivers/net/wireless/ipw2x00/libipw_module.c       |   13 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c           |    1 -
 drivers/net/wireless/iwlwifi/Makefile              |    6 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |  102 +-
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c    |  500 ++
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h    |   60 +
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h         |    7 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c         |   93 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c            |  361 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h            |   26 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h         |   24 -
 drivers/net/wireless/iwlwifi/iwl-4965.c            |  198 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h         |   33 -
 drivers/net/wireless/iwlwifi/iwl-5000.c            | 1493 +-----
 drivers/net/wireless/iwlwifi/iwl-6000.c            |  331 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c     |  850 +++
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h     |   56 +
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c        |  276 +
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h          |  118 +
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c         |  307 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         | 1530 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |  208 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          | 1340 +++++
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c       |  425 ++
 drivers/net/wireless/iwlwifi/iwl-agn.c             | 1021 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h             |  181 +
 drivers/net/wireless/iwlwifi/iwl-calib.c           |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |  116 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            | 1021 +---
 drivers/net/wireless/iwlwifi/iwl-core.h            |  136 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |    1 +
 drivers/net/wireless/iwlwifi/iwl-debug.h           |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |  912 +---
 drivers/net/wireless/iwlwifi/iwl-dev.h             |  288 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c        |    1 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |    7 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |   49 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h         |    3 +
 drivers/net/wireless/iwlwifi/iwl-io.h              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c           |   15 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |   94 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c              |  826 +---
 drivers/net/wireless/iwlwifi/iwl-scan.c            |  536 +--
 drivers/net/wireless/iwlwifi/iwl-sta.c             |  901 ++--
 drivers/net/wireless/iwlwifi/iwl-sta.h             |   76 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c              | 1074 +----
 drivers/net/wireless/iwlwifi/iwl3945-base.c        |  406 +-
 drivers/net/wireless/iwmc3200wifi/Kconfig          |    9 +-
 drivers/net/wireless/iwmc3200wifi/Makefile         |    5 +
 drivers/net/wireless/iwmc3200wifi/bus.h            |    2 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |   17 +-
 drivers/net/wireless/iwmc3200wifi/commands.c       |   14 +-
 drivers/net/wireless/iwmc3200wifi/commands.h       |    1 +
 drivers/net/wireless/iwmc3200wifi/debug.h          |    7 +-
 drivers/net/wireless/iwmc3200wifi/debugfs.c        |  123 +-
 drivers/net/wireless/iwmc3200wifi/hal.c            |   15 +-
 drivers/net/wireless/iwmc3200wifi/hal.h            |    5 +-
 drivers/net/wireless/iwmc3200wifi/iwm.h            |    3 +
 drivers/net/wireless/iwmc3200wifi/main.c           |    9 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |   79 +-
 drivers/net/wireless/iwmc3200wifi/sdio.c           |   19 +-
 drivers/net/wireless/iwmc3200wifi/trace.c          |    3 +
 drivers/net/wireless/iwmc3200wifi/trace.h          |  283 +
 drivers/net/wireless/iwmc3200wifi/tx.c             |   12 +-
 drivers/net/wireless/iwmc3200wifi/umac.h           |    2 +-
 drivers/net/wireless/libertas/assoc.c              |   22 +-
 drivers/net/wireless/libertas/cfg.c                |    1 +
 drivers/net/wireless/libertas/debugfs.c            |    5 +-
 drivers/net/wireless/libertas/dev.h                |    1 +
 drivers/net/wireless/libertas/if_sdio.c            |  127 +-
 drivers/net/wireless/libertas/if_usb.c             |    4 -
 drivers/net/wireless/libertas/main.c               |   15 +-
 drivers/net/wireless/libertas/rx.c                 |   51 +-
 drivers/net/wireless/libertas/tx.c                 |    2 -
 drivers/net/wireless/libertas/wext.c               |    4 +
 drivers/net/wireless/libertas_tf/cmd.c             |  203 +-
 drivers/net/wireless/libertas_tf/deb_defs.h        |  104 +
 drivers/net/wireless/libertas_tf/if_usb.c          |  252 +-
 drivers/net/wireless/libertas_tf/libertas_tf.h     |    2 +
 drivers/net/wireless/libertas_tf/main.c            |  106 +-
 drivers/net/wireless/mac80211_hwsim.c              |   96 +-
 drivers/net/wireless/mwl8k.c                       |   30 +-
 drivers/net/wireless/orinoco/Kconfig               |   20 +-
 drivers/net/wireless/orinoco/Makefile              |    4 +
 drivers/net/wireless/orinoco/airport.c             |    8 +-
 drivers/net/wireless/orinoco/cfg.c                 |   91 +-
 drivers/net/wireless/orinoco/fw.c                  |   10 +-
 drivers/net/wireless/orinoco/hermes.c              |  286 +-
 drivers/net/wireless/orinoco/hermes.h              |   62 +-
 drivers/net/wireless/orinoco/hermes_dld.c          |  243 +-
 drivers/net/wireless/orinoco/hw.c                  |  102 +-
 drivers/net/wireless/orinoco/hw.h                  |    1 -
 drivers/net/wireless/orinoco/main.c                |  307 +-
 drivers/net/wireless/orinoco/main.h                |   12 -
 drivers/net/wireless/orinoco/orinoco.h             |   38 +-
 drivers/net/wireless/orinoco/orinoco_cs.c          |   85 +-
 drivers/net/wireless/orinoco/orinoco_nortel.c      |    2 +-
 drivers/net/wireless/orinoco/orinoco_pci.c         |    2 +-
 drivers/net/wireless/orinoco/orinoco_plx.c         |    2 +-
 drivers/net/wireless/orinoco/orinoco_tmd.c         |    2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c         | 1795 ++++++
 drivers/net/wireless/orinoco/scan.c                |    4 +-
 drivers/net/wireless/orinoco/spectrum_cs.c         |    7 +-
 drivers/net/wireless/orinoco/wext.c                |  273 +-
 drivers/net/wireless/p54/main.c                    |    2 +-
 drivers/net/wireless/p54/p54pci.c                  |   10 +-
 drivers/net/wireless/p54/p54usb.c                  |    1 -
 drivers/net/wireless/p54/txrx.c                    |    3 +-
 drivers/net/wireless/prism54/isl_ioctl.c           |    2 -
 drivers/net/wireless/prism54/islpci_dev.c          |   18 +-
 drivers/net/wireless/prism54/islpci_eth.c          |   10 +-
 drivers/net/wireless/prism54/islpci_mgt.c          |    8 +-
 drivers/net/wireless/prism54/oid_mgt.c             |    2 +-
 drivers/net/wireless/ray_cs.c                      |  242 +-
 drivers/net/wireless/rndis_wlan.c                  |  374 ++-
 drivers/net/wireless/rt2x00/Kconfig                |    4 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |   56 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |   54 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |  130 +-
 drivers/net/wireless/rt2x00/rt2800.h               |  119 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  676 ++-
 drivers/net/wireless/rt2x00/rt2800lib.h            |    3 +
 drivers/net/wireless/rt2x00/rt2800pci.c            |  318 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |  297 +-
 drivers/net/wireless/rt2x00/rt2800usb.h            |   40 -
 drivers/net/wireless/rt2x00/rt2x00.h               |   35 +-
 drivers/net/wireless/rt2x00/rt2x00crypto.c         |    1 +
 drivers/net/wireless/rt2x00/rt2x00debug.c          |   23 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    1 -
 drivers/net/wireless/rt2x00/rt2x00dump.h           |    3 +
 drivers/net/wireless/rt2x00/rt2x00firmware.c       |    2 +-
 drivers/net/wireless/rt2x00/rt2x00ht.c             |   17 +
 drivers/net/wireless/rt2x00/rt2x00pci.c            |   12 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h            |    3 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   47 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |   11 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h            |   10 +
 drivers/net/wireless/rt2x00/rt2x00usb.c            |   11 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h            |    3 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |   95 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |  128 +-
 drivers/net/wireless/rtl818x/Kconfig               |   88 +
 drivers/net/wireless/rtl818x/rtl8180.h             |   11 +
 drivers/net/wireless/rtl818x/rtl8180_dev.c         |  115 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c         |   14 +-
 drivers/net/wireless/wl12xx/Kconfig                |   24 +
 drivers/net/wireless/wl12xx/Makefile               |    6 +-
 drivers/net/wireless/wl12xx/wl1251.h               |    2 +
 drivers/net/wireless/wl12xx/wl1251_boot.c          |    3 +-
 drivers/net/wireless/wl12xx/wl1251_io.h            |   20 +
 drivers/net/wireless/wl12xx/wl1251_main.c          |   73 +-
 drivers/net/wireless/wl12xx/wl1251_ps.c            |    8 +-
 drivers/net/wireless/wl12xx/wl1251_reg.h           |    7 +
 drivers/net/wireless/wl12xx/wl1251_rx.c            |    8 -
 drivers/net/wireless/wl12xx/wl1251_sdio.c          |  144 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c           |    2 +-
 drivers/net/wireless/wl12xx/wl1271.h               |   63 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c           |  179 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h           |  157 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c          |   46 +-
 drivers/net/wireless/wl12xx/wl1271_boot.h          |   10 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c           |  337 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.h           |   27 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h          |  488 ++-
 drivers/net/wireless/wl12xx/wl1271_debugfs.c       |   12 +-
 drivers/net/wireless/wl12xx/wl1271_event.c         |   69 +-
 drivers/net/wireless/wl12xx/wl1271_event.h         |    8 +
 drivers/net/wireless/wl12xx/wl1271_init.c          |   57 +-
 drivers/net/wireless/wl12xx/wl1271_io.c            |   87 +-
 drivers/net/wireless/wl12xx/wl1271_io.h            |  139 +-
 drivers/net/wireless/wl12xx/wl1271_main.c          | 1272 +++--
 drivers/net/wireless/wl12xx/wl1271_ps.c            |    7 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c            |   94 +-
 drivers/net/wireless/wl12xx/wl1271_rx.h            |    2 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c          |  291 +
 drivers/net/wireless/wl12xx/wl1271_spi.c           |  315 +-
 drivers/net/wireless/wl12xx/wl1271_spi.h           |   96 -
 drivers/net/wireless/wl12xx/wl1271_testmode.c      |    1 -
 drivers/net/wireless/wl12xx/wl1271_tx.c            |  133 +-
 drivers/net/wireless/wl12xx/wl1271_tx.h            |    9 +-
 drivers/net/wireless/wl3501_cs.c                   |   57 +-
 drivers/net/wireless/zd1201.c                      |   12 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |   13 +-
 drivers/net/xilinx_emaclite.c                      |   10 +-
 drivers/net/yellowfin.c                            |   13 +-
 drivers/net/znet.c                                 |    2 -
 drivers/net/zorro8390.c                            |    1 -
 drivers/s390/net/ctcm_main.c                       |    6 +-
 drivers/s390/net/ctcm_mpc.c                        |    6 +-
 drivers/s390/net/lcs.c                             |    3 +-
 drivers/s390/net/qeth_core.h                       |   32 +-
 drivers/s390/net/qeth_core_main.c                  |  237 +-
 drivers/s390/net/qeth_core_mpc.h                   |   10 +-
 drivers/s390/net/qeth_core_sys.c                   |  151 +-
 drivers/s390/net/qeth_l2_main.c                    |   47 +-
 drivers/s390/net/qeth_l3_main.c                    |  108 +-
 drivers/s390/net/qeth_l3_sys.c                     |  244 +-
 drivers/scsi/fcoe/fcoe.c                           |   18 +-
 drivers/scsi/iscsi_tcp.c                           |    4 +-
 drivers/ssb/driver_chipcommon.c                    |    3 +
 drivers/ssb/main.c                                 |    3 +
 drivers/ssb/pci.c                                  |   14 +-
 drivers/ssb/sprom.c                                |   14 +
 drivers/staging/arlan/arlan-main.c                 |    9 +-
 drivers/staging/et131x/et131x_netdev.c             |    6 +-
 drivers/staging/slicoss/slicoss.c                  |    6 +-
 drivers/staging/vt6655/device_main.c               |    6 +-
 drivers/staging/vt6656/main_usb.c                  |    6 +-
 drivers/staging/wavelan/wavelan.c                  |   10 +-
 drivers/staging/wavelan/wavelan_cs.c               |   12 +-
 drivers/staging/winbond/wbusb.c                    |    6 +-
 drivers/staging/wlags49_h2/wl_netdev.c             |   12 +-
 drivers/vhost/net.c                                |    4 +-
 drivers/vhost/vhost.c                              |   11 +-
 firmware/Makefile                                  |    2 +-
 firmware/bnx2/bnx2-mips-09-5.0.0.j15.fw.ihex       | 6081 ++++++++++++++++++++
 firmware/bnx2/bnx2-mips-09-5.0.0.j9.fw.ihex        | 6058 -------------------
 fs/fcntl.c                                         |   66 +-
 fs/sysfs/symlink.c                                 |    1 +
 include/linux/Kbuild                               |    1 +
 include/linux/caif/caif_socket.h                   |  165 +
 include/linux/caif/if_caif.h                       |   34 +
 include/linux/can/dev.h                            |    1 +
 include/linux/can/platform/mcp251x.h               |    4 +-
 include/linux/can/platform/sja1000.h               |    2 +-
 include/linux/dcbnl.h                              |    2 -
 include/linux/ethtool.h                            |  116 +-
 include/linux/filter.h                             |    3 +-
 include/linux/fs.h                                 |   12 +-
 include/linux/genetlink.h                          |    8 +
 include/linux/ieee80211.h                          |    4 +-
 include/linux/if.h                                 |    2 +
 include/linux/if_arp.h                             |    1 +
 include/linux/if_ether.h                           |    1 +
 include/linux/if_link.h                            |  108 +
 include/linux/if_macvlan.h                         |    3 +-
 include/linux/if_packet.h                          |    1 +
 include/linux/if_pppol2tp.h                        |   16 +-
 include/linux/if_pppox.h                           |    9 +
 include/linux/if_tun.h                             |    2 +
 include/linux/if_x25.h                             |   26 +
 include/linux/in6.h                                |    5 +-
 include/linux/ipv6.h                               |   18 +-
 include/linux/kernel.h                             |    6 +-
 include/linux/ks8842.h                             |   34 +
 include/linux/l2tp.h                               |  163 +
 include/linux/mmc/sdio.h                           |    2 +
 include/linux/mod_devicetable.h                    |   26 +
 include/linux/mroute.h                             |   20 +-
 include/linux/mroute6.h                            |   35 +-
 include/linux/net.h                                |   14 +-
 include/linux/netdevice.h                          |  292 +-
 include/linux/netfilter/Kbuild                     |    1 +
 include/linux/netfilter/nf_conntrack_common.h      |    1 +
 .../linux/netfilter/nf_conntrack_tuple_common.h    |    3 +-
 include/linux/netfilter/x_tables.h                 |   95 +-
 include/linux/netfilter/xt_CONNMARK.h              |   22 +-
 include/linux/netfilter/xt_MARK.h                  |    6 +-
 include/linux/netfilter/xt_TEE.h                   |   12 +
 include/linux/netfilter/xt_connmark.h              |   11 +
 include/linux/netfilter/xt_mark.h                  |    4 +
 include/linux/netfilter/xt_recent.h                |    7 +
 include/linux/netfilter_bridge.h                   |   29 +-
 include/linux/netfilter_ipv6/ip6_tables.h          |    4 -
 include/linux/netpoll.h                            |   13 +-
 include/linux/nl80211.h                            |   76 +
 include/linux/notifier.h                           |   10 +-
 include/linux/pci_regs.h                           |    3 +
 include/linux/phy.h                                |   13 +-
 include/linux/ppp_channel.h                        |    3 +
 include/linux/rculist.h                            |   42 +
 include/linux/rtnetlink.h                          |    7 +
 include/linux/skbuff.h                             |   83 +-
 include/linux/snmp.h                               |    2 +
 include/linux/socket.h                             |    5 +-
 include/linux/spi/wl12xx.h                         |    2 +
 include/linux/ssb/ssb.h                            |    4 +
 include/linux/ssb/ssb_driver_chipcommon.h          |   15 +
 include/linux/ssb/ssb_regs.h                       |  239 +-
 include/linux/stmmac.h                             |    1 +
 include/linux/sysctl.h                             |    2 +
 include/linux/tipc.h                               |   36 +-
 include/linux/tipc_config.h                        |    1 +
 include/linux/tty.h                                |    4 +-
 include/linux/wireless.h                           |    4 +-
 include/net/af_unix.h                              |   20 +-
 include/net/bluetooth/hci_core.h                   |    6 +-
 include/net/bluetooth/l2cap.h                      |   41 +-
 include/net/caif/caif_dev.h                        |  103 +
 include/net/caif/caif_device.h                     |   55 +
 include/net/caif/caif_layer.h                      |  283 +
 include/net/caif/cfcnfg.h                          |  140 +
 include/net/caif/cfctrl.h                          |  139 +
 include/net/caif/cffrml.h                          |   16 +
 include/net/caif/cfmuxl.h                          |   22 +
 include/net/caif/cfpkt.h                           |  274 +
 include/net/caif/cfserl.h                          |   12 +
 include/net/caif/cfsrvl.h                          |   56 +
 include/net/cfg80211.h                             |   47 +-
 include/net/dn_fib.h                               |    4 -
 include/net/dst.h                                  |   83 +-
 include/net/fib_rules.h                            |    3 +-
 include/net/flow.h                                 |   23 +-
 include/net/icmp.h                                 |   11 -
 include/net/if_inet6.h                             |   25 +-
 include/net/inet6_connection_sock.h                |    2 +-
 include/net/inet_connection_sock.h                 |    5 +-
 include/net/inet_sock.h                            |    1 +
 include/net/inet_timewait_sock.h                   |    4 +-
 include/net/ip.h                                   |    9 +-
 include/net/ip6_fib.h                              |   29 +-
 include/net/ip6_route.h                            |    4 +-
 include/net/ipv6.h                                 |   10 +-
 include/net/iw_handler.h                           |    2 +-
 include/net/mac80211.h                             |  149 +-
 include/net/mld.h                                  |   75 +
 include/net/neighbour.h                            |   14 +
 include/net/netns/generic.h                        |    9 +-
 include/net/netns/ipv4.h                           |   15 +-
 include/net/netns/ipv6.h                           |   14 +-
 include/net/pkt_sched.h                            |    2 +-
 include/net/raw.h                                  |   13 +
 include/net/route.h                                |   17 +-
 include/net/sch_generic.h                          |    1 +
 include/net/sctp/sctp.h                            |    4 +-
 include/net/sctp/sm.h                              |    2 +-
 include/net/sctp/structs.h                         |   66 +-
 include/net/snmp.h                                 |   31 +-
 include/net/sock.h                                 |  192 +-
 include/net/tcp.h                                  |   13 +-
 include/net/tipc/tipc.h                            |   16 +-
 include/net/transp_v6.h                            |    3 +-
 include/net/x25.h                                  |   10 +-
 include/net/x25device.h                            |    1 +
 include/net/xfrm.h                                 |   19 +-
 kernel/sysctl.c                                    |  551 ++-
 kernel/sysctl_binary.c                             |    1 -
 net/802/garp.c                                     |    4 +-
 net/8021q/vlan.c                                   |    8 +-
 net/8021q/vlan_core.c                              |    2 +-
 net/8021q/vlan_dev.c                               |   18 +-
 net/9p/trans_rdma.c                                |    1 -
 net/Kconfig                                        |    8 +
 net/Makefile                                       |    2 +
 net/appletalk/ddp.c                                |    2 +-
 net/atm/br2684.c                                   |    1 -
 net/atm/common.c                                   |   30 +-
 net/atm/lec.c                                      |    6 -
 net/atm/mpc.c                                      |   32 -
 net/atm/mpoa_caches.c                              |   20 -
 net/atm/proc.c                                     |   10 +-
 net/atm/signaling.c                                |    2 +-
 net/atm/svc.c                                      |   62 +-
 net/ax25/af_ax25.c                                 |    8 +-
 net/bluetooth/Kconfig                              |   13 +
 net/bluetooth/af_bluetooth.c                       |    6 +-
 net/bluetooth/bnep/core.c                          |    8 +-
 net/bluetooth/bnep/netdev.c                        |   20 +-
 net/bluetooth/cmtp/cmtp.h                          |    2 +-
 net/bluetooth/cmtp/core.c                          |    4 +-
 net/bluetooth/hci_core.c                           |   27 +-
 net/bluetooth/hci_sysfs.c                          |   34 +-
 net/bluetooth/hidp/core.c                          |   10 +-
 net/bluetooth/hidp/hidp.h                          |    4 +-
 net/bluetooth/l2cap.c                              | 1115 +++-
 net/bluetooth/rfcomm/sock.c                        |    8 +-
 net/bluetooth/rfcomm/tty.c                         |    2 -
 net/bluetooth/sco.c                                |   31 +-
 net/bridge/Kconfig                                 |    6 +-
 net/bridge/br.c                                    |    2 +-
 net/bridge/br_device.c                             |  131 +-
 net/bridge/br_fdb.c                                |    9 +-
 net/bridge/br_forward.c                            |   51 +-
 net/bridge/br_if.c                                 |   14 +-
 net/bridge/br_input.c                              |   12 +-
 net/bridge/br_ioctl.c                              |    2 +-
 net/bridge/br_multicast.c                          |  690 ++-
 net/bridge/br_netfilter.c                          |  263 +-
 net/bridge/br_netlink.c                            |    8 +-
 net/bridge/br_notify.c                             |   11 +
 net/bridge/br_private.h                            |   57 +-
 net/bridge/br_stp.c                                |   11 +-
 net/bridge/br_stp_bpdu.c                           |    2 +-
 net/bridge/br_stp_if.c                             |   16 +-
 net/bridge/br_stp_timer.c                          |   24 +-
 net/bridge/br_sysfs_if.c                           |   32 +-
 net/bridge/netfilter/ebt_802_3.c                   |    8 +-
 net/bridge/netfilter/ebt_among.c                   |   27 +-
 net/bridge/netfilter/ebt_arp.c                     |   10 +-
 net/bridge/netfilter/ebt_arpreply.c                |   10 +-
 net/bridge/netfilter/ebt_dnat.c                    |   12 +-
 net/bridge/netfilter/ebt_ip.c                      |   18 +-
 net/bridge/netfilter/ebt_ip6.c                     |   39 +-
 net/bridge/netfilter/ebt_limit.c                   |   11 +-
 net/bridge/netfilter/ebt_log.c                     |   10 +-
 net/bridge/netfilter/ebt_mark.c                    |   12 +-
 net/bridge/netfilter/ebt_mark_m.c                  |   12 +-
 net/bridge/netfilter/ebt_nflog.c                   |    8 +-
 net/bridge/netfilter/ebt_pkttype.c                 |    8 +-
 net/bridge/netfilter/ebt_redirect.c                |   12 +-
 net/bridge/netfilter/ebt_snat.c                    |   12 +-
 net/bridge/netfilter/ebt_stp.c                     |   10 +-
 net/bridge/netfilter/ebt_ulog.c                    |   38 +-
 net/bridge/netfilter/ebt_vlan.c                    |   54 +-
 net/bridge/netfilter/ebtables.c                    |   56 +-
 net/caif/Kconfig                                   |   48 +
 net/caif/Makefile                                  |   26 +
 net/caif/caif_config_util.c                        |   87 +
 net/caif/caif_dev.c                                |  417 ++
 net/caif/caif_socket.c                             | 1252 ++++
 net/caif/cfcnfg.c                                  |  470 ++
 net/caif/cfctrl.c                                  |  692 +++
 net/caif/cfdbgl.c                                  |   40 +
 net/caif/cfdgml.c                                  |  108 +
 net/caif/cffrml.c                                  |  151 +
 net/caif/cfmuxl.c                                  |  251 +
 net/caif/cfpkt_skbuff.c                            |  571 ++
 net/caif/cfrfml.c                                  |  108 +
 net/caif/cfserl.c                                  |  192 +
 net/caif/cfsrvl.c                                  |  192 +
 net/caif/cfutill.c                                 |  115 +
 net/caif/cfveil.c                                  |  107 +
 net/caif/cfvidl.c                                  |   65 +
 net/caif/chnl_net.c                                |  467 ++
 net/can/bcm.c                                      |    2 -
 net/core/Makefile                                  |    2 +-
 net/core/datagram.c                                |   21 +-
 net/core/dev.c                                     | 1363 +++---
 net/core/dev_addr_lists.c                          |  741 +++
 net/core/dev_mcast.c                               |  232 -
 net/core/dst.c                                     |   45 +-
 net/core/ethtool.c                                 |  152 +-
 net/core/fib_rules.c                               |   31 +-
 net/core/filter.c                                  |    7 +
 net/core/flow.c                                    |  405 +-
 net/core/net-sysfs.c                               |  318 +-
 net/core/net_namespace.c                           |   95 +-
 net/core/netpoll.c                                 |   26 +-
 net/core/pktgen.c                                  |   58 +-
 net/core/rtnetlink.c                               |  238 +-
 net/core/skbuff.c                                  |   33 +-
 net/core/sock.c                                    |   78 +-
 net/core/stream.c                                  |   22 +-
 net/core/sysctl_net_core.c                         |   75 +
 net/dccp/ccids/ccid3.c                             |    2 +-
 net/dccp/dccp.h                                    |    4 +-
 net/dccp/input.c                                   |    2 +-
 net/dccp/ipv4.c                                    |    2 +-
 net/dccp/ipv6.c                                    |    7 +-
 net/dccp/output.c                                  |   18 +-
 net/dccp/proto.c                                   |    2 +-
 net/dccp/timer.c                                   |    4 +-
 net/decnet/af_decnet.c                             |   32 +-
 net/decnet/dn_dev.c                                |   15 +-
 net/decnet/dn_neigh.c                              |    9 +-
 net/decnet/dn_nsp_in.c                             |    3 +-
 net/decnet/dn_route.c                              |   29 +-
 net/decnet/dn_rules.c                              |   22 +-
 net/dsa/slave.c                                    |   14 +-
 net/ethernet/eth.c                                 |    4 +-
 net/ipv4/Kconfig                                   |   22 +
 net/ipv4/af_inet.c                                 |   57 +-
 net/ipv4/arp.c                                     |    2 +-
 net/ipv4/cipso_ipv4.c                              |    2 -
 net/ipv4/devinet.c                                 |    4 +-
 net/ipv4/fib_rules.c                               |   22 +-
 net/ipv4/fib_trie.c                                |    2 -
 net/ipv4/icmp.c                                    |   11 +-
 net/ipv4/igmp.c                                    |    4 +-
 net/ipv4/inet_connection_sock.c                    |   10 +-
 net/ipv4/inet_hashtables.c                         |    2 +
 net/ipv4/ip_forward.c                              |    4 +-
 net/ipv4/ip_gre.c                                  |   10 +-
 net/ipv4/ip_input.c                                |    8 +-
 net/ipv4/ip_options.c                              |   10 +-
 net/ipv4/ip_output.c                               |   35 +-
 net/ipv4/ip_sockglue.c                             |   20 +-
 net/ipv4/ipconfig.c                                |    2 +-
 net/ipv4/ipip.c                                    |    7 +-
 net/ipv4/ipmr.c                                    |  925 +++-
 net/ipv4/netfilter.c                               |    6 +-
 net/ipv4/netfilter/arp_tables.c                    |  102 +-
 net/ipv4/netfilter/arpt_mangle.c                   |    4 +-
 net/ipv4/netfilter/ip_queue.c                      |    4 +-
 net/ipv4/netfilter/ip_tables.c                     |  260 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   77 +-
 net/ipv4/netfilter/ipt_ECN.c                       |   23 +-
 net/ipv4/netfilter/ipt_LOG.c                       |   19 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                |   18 +-
 net/ipv4/netfilter/ipt_NETMAP.c                    |   16 +-
 net/ipv4/netfilter/ipt_REDIRECT.c                  |   16 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |   19 +-
 net/ipv4/netfilter/ipt_ULOG.c                      |   47 +-
 net/ipv4/netfilter/ipt_addrtype.c                  |   28 +-
 net/ipv4/netfilter/ipt_ah.c                        |   28 +-
 net/ipv4/netfilter/ipt_ecn.c                       |   19 +-
 net/ipv4/netfilter/iptable_filter.c                |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |   10 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |    7 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |   17 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   21 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |   16 +-
 net/ipv4/netfilter/nf_nat_standalone.c             |    7 +-
 net/ipv4/netfilter/nf_nat_tftp.c                   |    1 -
 net/ipv4/proc.c                                    |    1 +
 net/ipv4/raw.c                                     |    6 +-
 net/ipv4/route.c                                   |  154 +-
 net/ipv4/sysctl_net_ipv4.c                         |   17 +
 net/ipv4/tcp.c                                     |   21 +-
 net/ipv4/tcp_input.c                               |   12 +-
 net/ipv4/tcp_ipv4.c                                |   43 +-
 net/ipv4/tcp_minisocks.c                           |    1 +
 net/ipv4/tcp_output.c                              |   25 +-
 net/ipv4/tcp_timer.c                               |    8 +-
 net/ipv4/udp.c                                     |   34 +-
 net/ipv4/xfrm4_input.c                             |    6 +-
 net/ipv4/xfrm4_output.c                            |    2 +-
 net/ipv4/xfrm4_policy.c                            |   22 -
 net/ipv6/Kconfig                                   |   14 +
 net/ipv6/addrconf.c                                |  886 ++--
 net/ipv6/addrlabel.c                               |    8 +-
 net/ipv6/af_inet6.c                                |    3 +
 net/ipv6/datagram.c                                |  108 +-
 net/ipv6/fib6_rules.c                              |    3 +-
 net/ipv6/icmp.c                                    |    7 +-
 net/ipv6/inet6_connection_sock.c                   |    4 +-
 net/ipv6/ip6_fib.c                                 |   16 +-
 net/ipv6/ip6_flowlabel.c                           |    3 +-
 net/ipv6/ip6_input.c                               |    4 +-
 net/ipv6/ip6_output.c                              |  103 +-
 net/ipv6/ip6_tunnel.c                              |    8 +-
 net/ipv6/ip6mr.c                                   |  942 +++-
 net/ipv6/ipv6_sockglue.c                           |   86 +-
 net/ipv6/mcast.c                                   |  143 +-
 net/ipv6/ndisc.c                                   |    6 +-
 net/ipv6/netfilter.c                               |   25 +-
 net/ipv6/netfilter/ip6_queue.c                     |    4 +-
 net/ipv6/netfilter/ip6_tables.c                    |  236 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |   20 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |   32 +-
 net/ipv6/netfilter/ip6t_ah.c                       |   18 +-
 net/ipv6/netfilter/ip6t_eui64.c                    |    4 +-
 net/ipv6/netfilter/ip6t_frag.c                     |   18 +-
 net/ipv6/netfilter/ip6t_hbh.c                      |   33 +-
 net/ipv6/netfilter/ip6t_ipv6header.c               |    8 +-
 net/ipv6/netfilter/ip6t_mh.c                       |   21 +-
 net/ipv6/netfilter/ip6t_rt.c                       |   20 +-
 net/ipv6/netfilter/ip6table_filter.c               |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c               |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   14 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |    2 +-
 net/ipv6/proc.c                                    |    2 +-
 net/ipv6/raw.c                                     |   18 +-
 net/ipv6/route.c                                   |    2 -
 net/ipv6/sit.c                                     |    8 +-
 net/ipv6/tcp_ipv6.c                                |   68 +-
 net/ipv6/udp.c                                     |   41 +-
 net/ipv6/xfrm6_input.c                             |    2 +-
 net/ipv6/xfrm6_output.c                            |    4 +-
 net/ipv6/xfrm6_policy.c                            |   31 -
 net/irda/af_irda.c                                 |   14 +-
 net/irda/ircomm/ircomm_param.c                     |    2 +-
 net/irda/iriap.c                                   |    2 -
 net/irda/irnet/irnet_irda.c                        |    3 -
 net/iucv/af_iucv.c                                 |   22 +-
 net/key/af_key.c                                   |   10 +-
 net/l2tp/Kconfig                                   |  107 +
 net/l2tp/Makefile                                  |   12 +
 net/l2tp/l2tp_core.c                               | 1666 ++++++
 net/l2tp/l2tp_core.h                               |  304 +
 net/l2tp/l2tp_debugfs.c                            |  341 ++
 net/l2tp/l2tp_eth.c                                |  334 ++
 net/l2tp/l2tp_ip.c                                 |  679 +++
 net/l2tp/l2tp_netlink.c                            |  840 +++
 net/l2tp/l2tp_ppp.c                                | 1837 ++++++
 net/llc/af_llc.c                                   |   12 +-
 net/llc/llc_core.c                                 |    6 -
 net/mac80211/Kconfig                               |   17 +-
 net/mac80211/Makefile                              |    3 +-
 net/mac80211/agg-rx.c                              |   80 +-
 net/mac80211/agg-tx.c                              |   16 +-
 net/mac80211/cfg.c                                 |  122 +-
 net/mac80211/chan.c                                |  127 +
 net/mac80211/debugfs.h                             |    1 -
 net/mac80211/debugfs_netdev.c                      |   12 +
 net/mac80211/debugfs_sta.c                         |   79 +-
 net/mac80211/driver-ops.h                          |   33 +-
 net/mac80211/driver-trace.h                        |  333 ++-
 net/mac80211/ht.c                                  |    3 +-
 net/mac80211/ibss.c                                |   46 +-
 net/mac80211/ieee80211_i.h                         |   51 +-
 net/mac80211/iface.c                               |  124 +-
 net/mac80211/key.c                                 |    1 +
 net/mac80211/main.c                                |   28 +-
 net/mac80211/mesh.c                                |    6 +-
 net/mac80211/mesh.h                                |    2 -
 net/mac80211/mesh_hwmp.c                           |    5 +-
 net/mac80211/mesh_plink.c                          |    2 +-
 net/mac80211/mlme.c                                |  310 +-
 net/mac80211/pm.c                                  |    2 +-
 net/mac80211/rc80211_minstrel.c                    |    2 +-
 net/mac80211/rc80211_minstrel.h                    |   11 +
 net/mac80211/rc80211_minstrel_debugfs.c            |   41 +-
 net/mac80211/rx.c                                  |  108 +-
 net/mac80211/scan.c                                |  126 +-
 net/mac80211/sta_info.c                            |  105 +-
 net/mac80211/sta_info.h                            |   12 +-
 net/mac80211/status.c                              |   21 +-
 net/mac80211/tx.c                                  |   26 +-
 net/mac80211/util.c                                |   36 +-
 net/mac80211/work.c                                |   62 +-
 net/netfilter/Kconfig                              |  133 +-
 net/netfilter/Makefile                             |    9 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |   10 +-
 net/netfilter/ipvs/ip_vs_proto.c                   |   28 +-
 net/netfilter/ipvs/ip_vs_proto_ah_esp.c            |   14 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |    2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   16 +-
 net/netfilter/nf_conntrack_amanda.c                |    2 +-
 net/netfilter/nf_conntrack_core.c                  |    6 +-
 net/netfilter/nf_conntrack_ecache.c                |   12 +-
 net/netfilter/nf_conntrack_ftp.c                   |    4 +-
 net/netfilter/nf_conntrack_h323_main.c             |    9 +-
 net/netfilter/nf_conntrack_irc.c                   |    4 +-
 net/netfilter/nf_conntrack_netlink.c               |   30 +-
 net/netfilter/nf_conntrack_proto.c                 |    8 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |    4 +-
 net/netfilter/nf_conntrack_sip.c                   |    4 +-
 net/netfilter/nf_conntrack_standalone.c            |    9 +-
 net/netfilter/nf_conntrack_tftp.c                  |    4 +-
 net/netfilter/nf_internals.h                       |    2 +-
 net/netfilter/nf_log.c                             |    6 +-
 net/netfilter/nf_queue.c                           |    3 +-
 net/netfilter/nfnetlink.c                          |    7 +-
 net/netfilter/nfnetlink_log.c                      |    4 +-
 net/netfilter/nfnetlink_queue.c                    |    3 +-
 net/netfilter/x_tables.c                           |  128 +-
 net/netfilter/xt_CLASSIFY.c                        |    2 +-
 net/netfilter/xt_CONNMARK.c                        |  113 -
 net/netfilter/xt_CONNSECMARK.c                     |   29 +-
 net/netfilter/xt_CT.c                              |   25 +-
 net/netfilter/xt_DSCP.c                            |   18 +-
 net/netfilter/xt_HL.c                              |   30 +-
 net/netfilter/xt_LED.c                             |   93 +-
 net/netfilter/xt_MARK.c                            |   56 -
 net/netfilter/xt_NFLOG.c                           |   10 +-
 net/netfilter/xt_NFQUEUE.c                         |   50 +-
 net/netfilter/xt_NOTRACK.c                         |    2 +-
 net/netfilter/xt_RATEEST.c                         |   20 +-
 net/netfilter/xt_SECMARK.c                         |   48 +-
 net/netfilter/xt_TCPMSS.c                          |   41 +-
 net/netfilter/xt_TCPOPTSTRIP.c                     |    7 +-
 net/netfilter/xt_TEE.c                             |  309 +
 net/netfilter/xt_TPROXY.c                          |   12 +-
 net/netfilter/xt_TRACE.c                           |    2 +-
 net/netfilter/xt_cluster.c                         |   21 +-
 net/netfilter/xt_comment.c                         |    2 +-
 net/netfilter/xt_connbytes.c                       |   22 +-
 net/netfilter/xt_connlimit.c                       |   24 +-
 net/netfilter/xt_connmark.c                        |  104 +-
 net/netfilter/xt_conntrack.c                       |   23 +-
 net/netfilter/xt_dccp.c                            |   18 +-
 net/netfilter/xt_dscp.c                            |   18 +-
 net/netfilter/xt_esp.c                             |   28 +-
 net/netfilter/xt_hashlimit.c                       |  346 +-
 net/netfilter/xt_helper.c                          |   18 +-
 net/netfilter/xt_hl.c                              |   16 +-
 net/netfilter/xt_iprange.c                         |    5 +-
 net/netfilter/xt_length.c                          |    4 +-
 net/netfilter/xt_limit.c                           |   15 +-
 net/netfilter/xt_mac.c                             |   23 +-
 net/netfilter/xt_mark.c                            |   37 +-
 net/netfilter/xt_multiport.c                       |  103 +-
 net/netfilter/xt_osf.c                             |   12 +-
 net/netfilter/xt_owner.c                           |    2 +-
 net/netfilter/xt_physdev.c                         |   18 +-
 net/netfilter/xt_pkttype.c                         |    2 +-
 net/netfilter/xt_policy.c                          |   31 +-
 net/netfilter/xt_quota.c                           |   10 +-
 net/netfilter/xt_rateest.c                         |   10 +-
 net/netfilter/xt_realm.c                           |    2 +-
 net/netfilter/xt_recent.c                          |  189 +-
 net/netfilter/xt_sctp.c                            |   57 +-
 net/netfilter/xt_socket.c                          |   11 +-
 net/netfilter/xt_state.c                           |   50 +-
 net/netfilter/xt_statistic.c                       |   14 +-
 net/netfilter/xt_string.c                          |   68 +-
 net/netfilter/xt_tcpmss.c                          |    4 +-
 net/netfilter/xt_tcpudp.c                          |   38 +-
 net/netfilter/xt_time.c                            |   16 +-
 net/netfilter/xt_u32.c                             |    5 +-
 net/netlabel/netlabel_addrlist.h                   |    2 -
 net/netlabel/netlabel_unlabeled.c                  |    1 -
 net/netlink/af_netlink.c                           |    2 +-
 net/netlink/genetlink.c                            |    6 +-
 net/netrom/af_netrom.c                             |    8 +-
 net/packet/af_packet.c                             |   69 +-
 net/phonet/pep.c                                   |    8 +-
 net/phonet/pn_dev.c                                |   23 +-
 net/phonet/socket.c                                |    2 +-
 net/rds/af_rds.c                                   |   11 +-
 net/rds/cong.c                                     |    2 -
 net/rds/ib_cm.c                                    |    3 +-
 net/rds/ib_rdma.c                                  |    5 +-
 net/rds/ib_recv.c                                  |    4 +-
 net/rds/ib_send.c                                  |   20 +-
 net/rds/iw_cm.c                                    |    4 +-
 net/rds/iw_recv.c                                  |    4 +-
 net/rds/iw_send.c                                  |    3 +-
 net/rds/loop.c                                     |    7 -
 net/rds/rdma.c                                     |    4 +-
 net/rds/rdma_transport.c                           |    5 +-
 net/rds/rds.h                                      |    4 +-
 net/rds/recv.c                                     |    2 +-
 net/rds/send.c                                     |   40 +-
 net/rds/tcp_connect.c                              |    2 +-
 net/rds/tcp_recv.c                                 |    1 +
 net/rds/tcp_send.c                                 |    4 +-
 net/rds/threads.c                                  |    2 +-
 net/rfkill/core.c                                  |   53 +-
 net/rose/af_rose.c                                 |    8 +-
 net/rxrpc/af_rxrpc.c                               |   12 +-
 net/rxrpc/ar-recvmsg.c                             |    6 +-
 net/sched/act_api.c                                |   65 +-
 net/sched/act_gact.c                               |    4 +-
 net/sched/act_ipt.c                                |    9 +-
 net/sched/act_mirred.c                             |    6 +-
 net/sched/act_pedit.c                              |   11 +-
 net/sched/act_simple.c                             |    4 +-
 net/sched/cls_api.c                                |   30 +-
 net/sched/cls_flow.c                               |    1 -
 net/sched/cls_u32.c                                |   10 +-
 net/sched/ematch.c                                 |    3 +-
 net/sched/sch_api.c                                |  121 +-
 net/sched/sch_generic.c                            |   21 +-
 net/sched/sch_hfsc.c                               |    7 +-
 net/sched/sch_ingress.c                            |    1 -
 net/sched/sch_mq.c                                 |    1 -
 net/sched/sch_multiq.c                             |    1 -
 net/sched/sch_prio.c                               |    1 -
 net/sched/sch_red.c                                |    1 -
 net/sched/sch_sfq.c                                |   10 +-
 net/sched/sch_tbf.c                                |    6 +-
 net/sctp/Kconfig                                   |   12 +
 net/sctp/Makefile                                  |    3 +
 net/sctp/associola.c                               |   15 +-
 net/sctp/chunk.c                                   |    4 +-
 net/sctp/endpointola.c                             |    2 -
 net/sctp/ipv6.c                                    |   27 +-
 net/sctp/output.c                                  |   27 +-
 net/sctp/outqueue.c                                |   96 +-
 net/sctp/probe.c                                   |  214 +
 net/sctp/proc.c                                    |    3 -
 net/sctp/protocol.c                                |    9 +-
 net/sctp/sm_make_chunk.c                           |   28 +-
 net/sctp/sm_sideeffect.c                           |   12 +-
 net/sctp/socket.c                                  |   41 +-
 net/sctp/transport.c                               |   61 +-
 net/sctp/ulpqueue.c                                |    2 -
 net/socket.c                                       |  123 +-
 net/sunrpc/auth_gss/gss_spkm3_token.c              |    2 +-
 net/sunrpc/bc_svc.c                                |    2 +-
 net/sunrpc/clnt.c                                  |    1 -
 net/sunrpc/svcsock.c                               |   25 +-
 net/sunrpc/xprt.c                                  |    3 +-
 net/sunrpc/xprtsock.c                              |    4 -
 net/sysctl_net.c                                   |    1 -
 net/tipc/addr.c                                    |   32 +
 net/tipc/addr.h                                    |   37 +-
 net/tipc/bcast.c                                   |  149 +-
 net/tipc/bcast.h                                   |  117 +-
 net/tipc/bearer.c                                  |   16 +-
 net/tipc/bearer.h                                  |   16 +-
 net/tipc/cluster.c                                 |    2 +-
 net/tipc/config.c                                  |   68 +-
 net/tipc/core.c                                    |   26 +-
 net/tipc/core.h                                    |   27 +-
 net/tipc/discover.c                                |    8 +-
 net/tipc/link.c                                    |  102 +-
 net/tipc/link.h                                    |   35 +
 net/tipc/msg.c                                     |   94 +
 net/tipc/msg.h                                     |   99 +-
 net/tipc/name_distr.c                              |    2 +-
 net/tipc/name_table.c                              |    2 +-
 net/tipc/net.c                                     |    8 +-
 net/tipc/node.c                                    |   14 +-
 net/tipc/port.c                                    |   27 +-
 net/tipc/port.h                                    |    2 -
 net/tipc/socket.c                                  |   26 +-
 net/tipc/subscr.c                                  |   15 +-
 net/unix/af_unix.c                                 |   25 +-
 net/unix/garbage.c                                 |   13 +-
 net/wimax/op-reset.c                               |    2 -
 net/wimax/op-state-get.c                           |    2 -
 net/wimax/stack.c                                  |    4 +-
 net/wireless/chan.c                                |   56 +-
 net/wireless/core.c                                |    3 +-
 net/wireless/core.h                                |   27 +-
 net/wireless/ibss.c                                |    5 -
 net/wireless/mlme.c                                |   52 +-
 net/wireless/nl80211.c                             |  328 +-
 net/wireless/nl80211.h                             |    6 +
 net/wireless/reg.c                                 |    6 +-
 net/wireless/sme.c                                 |   36 +-
 net/wireless/util.c                                |   24 +-
 net/wireless/wext-compat.c                         |   15 +-
 net/wireless/wext-core.c                           |  134 +-
 net/wireless/wext-sme.c                            |    2 +-
 net/x25/af_x25.c                                   |   42 +-
 net/x25/x25_dev.c                                  |   36 +-
 net/x25/x25_in.c                                   |    2 +-
 net/x25/x25_out.c                                  |    5 +-
 net/xfrm/xfrm_hash.h                               |    9 +-
 net/xfrm/xfrm_policy.c                             |  848 ++--
 net/xfrm/xfrm_state.c                              |    5 +-
 net/xfrm/xfrm_user.c                               |   22 +-
 scripts/mod/file2alias.c                           |   26 +
 1455 files changed, 95794 insertions(+), 48164 deletions(-)
 create mode 100644 Documentation/ABI/obsolete/sysfs-class-rfkill
 create mode 100644 Documentation/ABI/stable/sysfs-class-rfkill
 create mode 100644 Documentation/networking/caif/Linux-CAIF.txt
 create mode 100644 Documentation/networking/caif/README
 create mode 100644 drivers/net/caif/Kconfig
 create mode 100644 drivers/net/caif/Makefile
 create mode 100644 drivers/net/caif/caif_serial.c
 create mode 100644 drivers/net/enic/vnic_vic.c
 create mode 100644 drivers/net/enic/vnic_vic.h
 create mode 100644 drivers/net/irda/sh_irda.c
 delete mode 100644 drivers/net/pppol2tp.c
 delete mode 100644 drivers/net/stmmac/dwmac100.c
 create mode 100644 drivers/net/stmmac/dwmac100_core.c
 create mode 100644 drivers/net/stmmac/dwmac100_dma.c
 create mode 100644 drivers/net/stmmac/enh_desc.c
 create mode 100644 drivers/net/stmmac/norm_desc.c
 create mode 100644 drivers/net/wireless/ath/ath5k/ani.c
 create mode 100644 drivers/net/wireless/ath/ath5k/ani.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar5008_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar5008_phy.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9001_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_calib.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_hw.c
 rename drivers/net/wireless/ath/ath9k/{initvals.h => ar9002_initvals.h} (77%)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_mac.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_phy.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9002_phy.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_calib.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_hw.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mac.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mac.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_phy.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_phy.h
 create mode 100644 drivers/net/wireless/ath/ath9k/hif_usb.c
 create mode 100644 drivers/net/wireless/ath/ath9k/hif_usb.h
 create mode 100644 drivers/net/wireless/ath/ath9k/htc.h
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_init.c
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_main.c
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_hst.c
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_hst.h
 create mode 100644 drivers/net/wireless/ath/ath9k/hw-ops.h
 delete mode 100644 drivers/net/wireless/ath/ath9k/phy.c
 create mode 100644 drivers/net/wireless/ath/ath9k/wmi.c
 create mode 100644 drivers/net/wireless/ath/ath9k/wmi.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-ict.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-lib.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-tx.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn.h
 create mode 100644 drivers/net/wireless/iwmc3200wifi/trace.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/trace.h
 create mode 100644 drivers/net/wireless/libertas_tf/deb_defs.h
 create mode 100644 drivers/net/wireless/orinoco/orinoco_usb.c
 create mode 100644 drivers/net/wireless/rtl818x/Kconfig
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_sdio.c
 delete mode 100644 drivers/net/wireless/wl12xx/wl1271_spi.h
 create mode 100644 firmware/bnx2/bnx2-mips-09-5.0.0.j15.fw.ihex
 delete mode 100644 firmware/bnx2/bnx2-mips-09-5.0.0.j9.fw.ihex
 create mode 100644 include/linux/caif/caif_socket.h
 create mode 100644 include/linux/caif/if_caif.h
 create mode 100644 include/linux/if_x25.h
 create mode 100644 include/linux/ks8842.h
 create mode 100644 include/linux/l2tp.h
 create mode 100644 include/linux/netfilter/xt_TEE.h
 create mode 100644 include/net/caif/caif_dev.h
 create mode 100644 include/net/caif/caif_device.h
 create mode 100644 include/net/caif/caif_layer.h
 create mode 100644 include/net/caif/cfcnfg.h
 create mode 100644 include/net/caif/cfctrl.h
 create mode 100644 include/net/caif/cffrml.h
 create mode 100644 include/net/caif/cfmuxl.h
 create mode 100644 include/net/caif/cfpkt.h
 create mode 100644 include/net/caif/cfserl.h
 create mode 100644 include/net/caif/cfsrvl.h
 create mode 100644 include/net/mld.h
 create mode 100644 net/caif/Kconfig
 create mode 100644 net/caif/Makefile
 create mode 100644 net/caif/caif_config_util.c
 create mode 100644 net/caif/caif_dev.c
 create mode 100644 net/caif/caif_socket.c
 create mode 100644 net/caif/cfcnfg.c
 create mode 100644 net/caif/cfctrl.c
 create mode 100644 net/caif/cfdbgl.c
 create mode 100644 net/caif/cfdgml.c
 create mode 100644 net/caif/cffrml.c
 create mode 100644 net/caif/cfmuxl.c
 create mode 100644 net/caif/cfpkt_skbuff.c
 create mode 100644 net/caif/cfrfml.c
 create mode 100644 net/caif/cfserl.c
 create mode 100644 net/caif/cfsrvl.c
 create mode 100644 net/caif/cfutill.c
 create mode 100644 net/caif/cfveil.c
 create mode 100644 net/caif/cfvidl.c
 create mode 100644 net/caif/chnl_net.c
 create mode 100644 net/core/dev_addr_lists.c
 delete mode 100644 net/core/dev_mcast.c
 create mode 100644 net/l2tp/Kconfig
 create mode 100644 net/l2tp/Makefile
 create mode 100644 net/l2tp/l2tp_core.c
 create mode 100644 net/l2tp/l2tp_core.h
 create mode 100644 net/l2tp/l2tp_debugfs.c
 create mode 100644 net/l2tp/l2tp_eth.c
 create mode 100644 net/l2tp/l2tp_ip.c
 create mode 100644 net/l2tp/l2tp_netlink.c
 create mode 100644 net/l2tp/l2tp_ppp.c
 create mode 100644 net/mac80211/chan.c
 delete mode 100644 net/netfilter/xt_CONNMARK.c
 delete mode 100644 net/netfilter/xt_MARK.c
 create mode 100644 net/netfilter/xt_TEE.c
 create mode 100644 net/sctp/probe.c

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
