Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab0JWSfp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 14:35:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34571
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757563Ab0JWSfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 14:35:37 -0400
Date: Sat, 23 Oct 2010 11:35:58 -0700 (PDT)
Message-Id: <20101023.113558.71132081.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9NIaLlM027009


Linus, there are three conflicts which I am aware of that you'll need
to take care of when you pull this:

1) net/core/dev.c

   Keep the new trace_netif_receive_skb() call, delete the
   VLAN test and return statement.

2) drivers/net/wireless/ath/ath9k/debug.c

   Just delete everything in the conflict markers, the code
   dealing with fops_rcstat

3) drivers/net/pcmcia/smc91c92.c

   Keep only the "pr_info()" line in the conflict markers.

Changes worth mentioning:

1) TPROXY ipv6 support, from Balazs Scheidler.

2) Many routing, neighbour, and device handling optimizations on SMP from
   Eric Dumazet.  Routing tests now run faster with the routing cache
   disabled (for those who jump quickly to conclusions, NO this does
   not mean we can just remove the routing cache, we still need it for
   the sake of routing metrics etc.)

   Anyways, amazing stuff from Eric, the networking ninja.

3) Cleanup and add sanity to the queue allocation semantics for network
   devices, from Ben Hutchings.

4) Add MAC-level filtering and steering API support, also from Ben
   Hutchings.

5) Move VLAN handling into the core and out of the individual drivers.
   With a few more driver conversions even more code can get removed
   from the VLAN bits.  From Jesse Gross.

6) TCP_USER_TIMEOUT socket option support, from Jerry Chu.

7) Multiqueue support for macvtap driver, from Krishna Kumar.

8) Any-IP support in ipv6, from Maciej ≈ªenczykowski.

9) Make netpoll actually work on bonding, from Neil Horman.

Please pull, thanks a lot!

The following changes since commit 02f36038c568111ad4fc433f6fa760ff5e38fab4:

  Merge branches 'softirq-for-linus', 'x86-debug-for-linus', 'x86-numa-for-linus', 'x86-quirks-for-linus', 'x86-setup-for-linus', 'x86-uv-for-linus' and 'x86-vm86-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-10-23 08:25:36 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Ajit Khaparde (2):
      be2net: fix to dynamically generate MAC Address for VFs
      be2net: stats for packets received due to internal switching in ASIC.

Akinobu Mita (5):
      econet: kill unnecessary spin_lock_init()
      mlx4: use bitmap library
      phonet: use for_each_set_bit
      starfire: use PCI_VDEVICE
      starfire: use BUILD_BUG_ON for netdrv_addr_t

Alban Crequy (1):
      AF_UNIX: Implement SO_TIMESTAMP and SO_TIMETAMPNS on Unix sockets

Alexander Duyck (21):
      ixgbe: remove redundant DMA alignment code
      ixgbe: move setting of GSO size for 82598 into ixgbe_configure_dcb
      ixgbe: combine two modifications of TXDCTL into one
      ixgbe: move configuration of the MTQC register into it's own function
      ixgbe: move Tx ring configuration into a separate function
      ixgbe: consolidate all setting of MRQC into one function
      ixgbe: pull ring configuration into it's own function
      ixgbe: pull PSRTYPE configuration into a separate function
      ixgbe: combine accesses to FCTRL register into ixgbe_set_rx_mode
      ixgbe: bump PS header size to 512 bytes
      ixgbe: remove redundant configuration of vmolr, rename generic variable
      ixgbe: Move max frame size and Rx buffer length configuration into a function
      ixgbe: move all Rx DMA control register writes to one central location
      ixgbe: Move virtualization config into a separate function
      ixgbe: move all GPIE register config into a single function
      ixgbe: pull all Tx init into ixgbe_configure_tx
      ixgbe: combine Rx into into ixgbe_configure_rx
      ixgbe: update all DESC_ADV macros to accept a ring pointer
      ixgbe: rewrite ethtool test to use standard config functions
      ixgbe: fix TX ring enable issues seen when VMDQ is enabled
      igb: clear VF_PROMISC bits instead of setting all other bits

Allan Stephens (16):
      tipc: Provide correct error code for unsupported connect() operation
      tipc: correct problems with misleading flags returned using poll()
      tipc: Check for disabled bearer when processing incoming messages
      tipc: Prevent crash when broadcast link cannot send to all nodes
      tipc: Fix premature broadcast advertisement by sending node
      tipc: Fix bug in broadcast link transmit statistics computation
      tipc: Remove per-connection sequence number logic
      tipc: Optimize tipc_node_has_active_links()
      tipc: Minor enhancements to name table display format
      tipc: Allow connect() to wait indefinitely
      tipc: Prevent missing name table entries when link flip-flops rapidly
      tipc: Minor optimizations to name table translation code
      tipc: Ensure outgoing messages on Ethernet have sufficient headroom
      tipc: Fix misleading error code when enabling Ethernet bearers
      tipc: Simplify bearer shutdown logic
      tipc: delete needless memset from bearer enabling.

Amerigo Wang (2):
      mlx4: remove num_lro parameter
      s2io: remove lro parameter

Amit Kumar Salecha (26):
      qlcnic: fix aer for virtual func
      qlcnic: device state management fixes for virtual func
      qlcnic: add eswitch statistics support
      qlcnic: fix inconsistent lock state
      qlcnic: fix npar state
      qlcnic: mark device state as failed
      qlcnic: fix endiness in eswitch statistics
      qlcnic: update version 5.0.8
      qlcnic: support port vlan id
      qlcnic: fix fw recovery for PF
      qlcnic: change reg name
      qlcnic: support mac learning
      qlcnic: mac vlan learning support
      qlcnic: add cksum flag
      qlcnic: support vlan rx accleration
      qlcnic: vlan gro support
      qlcnic: vlan lro support
      qlcnic: remove fw version check
      qlcnic: update version 5.0.10
      qlcnic: fix internal loopback test
      qlcnic: fix eswitch stats
      qlcnic: fix diag register
      qlcnic: driver private workqueue
      qlcnic: support quiescent mode
      qlcnic: remove private LRO flag
      qlcnic: update driver version 5.0.11

Anders Kaseorg (1):
      tipc: Fix log buffer memory leak if initialization fails

Andrea Gelmini (1):
      net: mac80211: Fix a typo.

Andreas Schwab (2):
      net/de4x5: remove undefined operations
      net/cxgb3: remove undefined operations

Andrei Emeltchenko (4):
      Bluetooth: remove extra newline from debug output
      Bluetooth: check L2CAP length in first ACL fragment
      Bluetooth: check for l2cap header in start fragment
      Bluetooth: clean up rfcomm code

Andrew Gallatin (1):
      myri10ge: DCA update (resubmit)

Andrew Hendry (1):
      X.25 remove bkl in accept

Andrew Morton (2):
      drivers/net/wireless/libertas/cfg.c: needs sched.h
      drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl-checkpatch-fixes

Andy Grover (66):
      RDS: Fix BUG_ONs to not fire when in a tasklet
      RDS: Rewrite rds_send_drop_to() for clarity
      RDS: Fix locking in send on m_rs_lock
      RDS: move rds_shutdown_worker impl. to rds_conn_shutdown
      RDS: cleanup: remove "== NULL"s and "!= NULL"s in ptr comparisons
      RDS: break out rdma and data ops into nested structs in rds_message
      RDS: cleanup/fix rds_rdma_unuse
      RDS: Explicitly allocate rm in sendmsg()
      RDS: fold rdma.h into rds.h
      RDS: make m_rdma_op a member of rds_message
      RDS: make sure all sgs alloced are initialized
      RDS: Clear up some confusing code in send_remove_from_sock
      RDS: Implement atomic operations
      RDS: Base init_depth and responder_resources on hw values
      RDS: Do not mask address when pinning pages
      RDS: Whitespace
      RDS: inc_purge() transport function unused - remove it
      RDS/IB: eliminate duplicate code
      RDS/IB: Disallow connections less than RDS 3.1
      RDS/IB: Remove dead code
      RDS/IB: Remove ib_[header/data]_sge() functions
      RDS: rewrite rds_ib_xmit
      RDS: Remove unsignaled_bytes sysctl
      RDS/IB: Make all flow control code conditional on i_flowctl
      RDS: Move loop-only function to loop.c
      RDS: Implement silent atomics
      RDS: Inline rdma_prepare into cmsg_rdma_args
      RDS: purge atomic resources too in rds_message_purge()
      RDS: Remove struct rds_rdma_op
      RDS: Rename data op members prefix from m_ to op_
      RDS: Rewrite rds_send_xmit
      RDS: Do not set op_active in r_m_copy_from_user().
      RDS: Add a warning if trying to allocate 0 sgs
      RDS: queue failure notifications for dropped atomic ops
      RDS: Move some variables around for consistency
      RDS: Add flag for silent ops. Do atomic op before RDMA
      RDS: Make sure cmsgs aren't used in improper ways
      RDS: Perform unmapping ops in stages
      RDS/IB: Do not wait for send ring to be empty on conn shutdown
      RDS: Stop supporting old cong map sending method
      RDS: Refill recv ring directly from tasklet
      RDS: Change send lock from a mutex to a spinlock
      RDS: rds_send_xmit() locking/irq fixes
      RDS: Call rds_send_xmit() directly from sendmsg()
      RDS: Bypass workqueue when queueing cong updates
      RDS: Use NOWAIT in message_map_pages()
      RDS: Fix locking in send on m_rs_lock
      RDS: rds_message_unmapped() doesn't need to check if queue active
      RDS: Move atomic stats from general to ib-specific area
      RDS: Remove send_quota from send_xmit()
      RDS: Do wait_event_interruptible instead of wait_event
      RDS: Get pong working again
      RDS: Update comments in rds_send_xmit()
      RDS/IB: Remove unused variable in ib_remove_addr()
      RDS/IB: add _to_node() macros for numa and use {k,v}malloc_node()
      RDS: Use page_remainder_alloc() for recv bufs
      RDS: Assume recv->r_frag is always NULL in refill_one()
      RDS/IB: Remove ib_recv_unmap_page()
      RDS: whitespace
      RDS: Remove unused XLIST_PTR_TAIL and xlist_protect()
      RDS/IB: Make ib_recv_refill return void
      RDS/IB: Use SLAB_HWCACHE_ALIGN flag for kmem_cache_create()
      RDS: Implement masked atomic operations
      RDS: Add rds.h to exported headers list
      RDS: rds.h: Replace u_int[size]_t with uint[size]_t
      RDS: Remove dead struct from rds.h

Andy Shevchenko (4):
      drivers: isdn: capi: use simple_strtol to convert numbers
      uwb: use '%pM' format to print MAC address
      drivers: atm: use native kernel's hex_to_bin() func
      net: core: use kernel's converter from hex to bin

Andy Walls (1):
      IPv4: route.c: Change checks against 0xffffffff to ipv4_is_lbcast()

Anirban Chakraborty (1):
      qlcnic: Fix driver load issue in FW hang

Anton Blanchard (1):
      ibmveth: Use lighter weight read memory barrier in ibmveth_poll

Arnaud Patard (2):
      rt2x00: fix "buffer size not provably correct" build warning
      phy/marvell: fix 88e1121 support

Arnd Bergmann (3):
      irda/irnet: use noop_llseek
      i4l: kill big kernel lock
      misdn: kill big kernel lock

Balazs Scheidler (12):
      tproxy: kick out TIME_WAIT sockets in case a new connection comes in with the same tuple
      tproxy: add lookup type checks for UDP in nf_tproxy_get_sock_v4()
      tproxy: fix hash locking issue when using port redirection in __inet_inherit_port()
      tproxy: split off ipv6 defragmentation to a separate module
      tproxy: added const specifiers to udp lookup functions
      tproxy: added udp6_lib_lookup function
      tproxy: added tproxy sockopt interface in the IPV6 layer
      tproxy: allow non-local binds of IPv6 sockets if IP_TRANSPARENT is enabled
      tproxy: added IPv6 socket lookup function to nf_tproxy_core
      tproxy: added IPv6 support to the TPROXY target
      tproxy: added IPv6 support to the socket match
      tproxy: use the interface primary IP address as a default value for --on-ip

Bandan Das (3):
      bridge : Sanitize skb before it enters the IP stack
      bonding: cleanup : add space around operators
      bonding: cleanup: remove braces from single block statements

Ben Greear (20):
      ath9k: calcrxfilter should take multiple VIFs into account.
      ath9k: Print rxfilter in debugfs.
      ath5k: Add bssid mask and rxfilter to debugfs.
      mac80211: Support multiple VIFS per AP in debugfs.
      mac80211/ath9k: Support AMPDU with multiple VIFs.
      mac80211: Support receiving data frames on multiple vifs.
      wireless: Use first phyX name available when registering phy devices.
      ath5k: Allow ath5k to support virtual STA and AP interfaces.
      ath5k: Print rx/tx bytes in debugfs
      ath9k: Report total tx/rx bytes and packets in debugfs.
      mac80211: Improve mlme probe response log messages.
      wireless: Set some stats used by /proc/net/wireless (wext)
      ath5k: Print out opmode in debugfs.
      ath5k: Adjust opmode when interfaces are removed.
      wireless: Print wiphy name in sysfs.
      ath5k: Move debugfs under ieee80211/[wiphy-name]
      ath9k: Fix potential use-after-free.
      ath9k: Remove bf_dmacontext.
      ath9k: Null out references to stale pointers.
      net/core: Allow tagged VLAN packets to flow through VETH devices.

Ben Hutchings (46):
      mac80211: Don't squash error codes in key setup functions
      ethtool: Provide a default implementation of ethtool_ops::get_drvinfo
      sfc: Use MCDI RX_BAD_FCS_PKTS count as MAC rx_bad count
      sfc: Accumulate RX_NODESC_DROP count in rx_dropped, not rx_over_errors
      sfc: Remove declarations of functions that no longer exist
      sfc: Fix failure paths in efx_probe_port()
      sfc: Allocate DMA and event rings using GFP_KERNEL
      sfc: Abstract channel and index lookup for RX queues
      sfc: Refactor channel and queue lookup and iteration
      sfc: Allocate each channel separately, along with its RX and TX queues
      sfc: Allow changing the DMA ring sizes dynamically via ethtool
      sfc: Fix order of channel_name array dimensions
      ethtool: Complete kernel-doc comments for RX flow filter and hash control
      ethtool: Remove unimplemented flow specification types
      ethtool, ixgbe: Move RX n-tuple mask fixup to ethtool
      ethtool: Add comments for valid use of flow types
      ethtool: Define RX n-tuple action to clear a rule
      ethtool: Add Ethernet MAC-level filtering/steering
      ethtool: Allocate register dump buffer with vmalloc()
      sfc: Add filter table management
      sfc: Implement the ethtool RX n-tuple control functions
      sfc: Include RX IP filter table in register dump
      sfc: Clean up and correct comments on efx_monitor()
      sfc: Remove support for SFN4111T, SFT9001 and Falcon GMAC
      sfc: Add support for SFE4003 board and TXC43128 PHY
      net: Allow changing number of RX queues after device allocation
      net: Add netif_copy_real_num_queues() for use by virtual net drivers
      bnx2: Use netif_set_real_num_{rx,tx}_queues()
      bnx2x: Use netif_set_real_num_{rx,tx}_queues()
      cxgb3: Use netif_set_real_num_{rx,tx}_queues()
      cxgb4: Use netif_set_real_num_{rx,tx}_queues()
      cxgb4vf: Use netif_set_real_num_{rx, tx}_queues()
      gianfar: Use netif_set_real_num_rx_queues()
      igb: Use netif_set_real_num_{rx,tx}_queues()
      ixgbe: Use netif_set_real_num_{rx,tx}_queues()
      mlx4_en: Use netif_set_real_num_{rx, tx}_queues()
      mv643xx_eth: Use netif_set_real_num_{rx, tx}_queues()
      myri10ge: Use netif_set_real_num_{rx, tx}_queues()
      niu: Use netif_set_real_num_{rx,tx}_queues()
      sfc: Use netif_set_real_num_{rx,tx}_queues()
      8021q: Use netif_copy_real_num_queues() to set queue counts
      tg3: Use netif_set_real_num_{rx,tx}_queues()
      ar9170: Remove MODULE_FIRMWARE references to two-stage firmware
      net: Update kernel-doc for netif_set_real_num_rx_queues()
      sfc: Don't try to set filters with search depths we know won't work
      r6040: Fix multicast filter some more

Benjamin Poirier (1):
      bridge: Forward reserved group addresses if !STP

Bernard Blackham (1):
      smsc95xx: generate random MAC address once, not every ifup

Bill Jordan (4):
      nl80211: Uninitialized variable
      ath9k: add WDS interfaces to ath9k
      cfg80211: patches to allow setting the WDS peer
      mac80211: fix for WDS interfaces

Bj√∂rn Smedman (3):
      mac80211: minstrel_ht A-MPDU fix
      ath9k: A-MPDU rate control info fix
      ath9k: built-in rate control A-MPDU fix

Bob Copeland (9):
      ath5k: clean up some comments
      ath5k: remove monitor check in receive_frame_ok filter
      ath5k: remove all mention of monitor iftype
      ath5k: don't enable probe request rx for STAs
      mac80211: trivial spelling fixes
      ath5k: trivial spelling fixes
      ath5k: log descriptor chains at a new debug level
      ath5k: fix off-by-one in pilot magnitude mask
      ath5k: reorder base.c to remove fwd decls

Brandon Philips (1):
      net: enable GRO by default for vlan devices

Breno Leitao (4):
      qlge: Fix a deadlock when the interface is going down
      ehea: Remove a silly return
      ehea: using wait queues instead of msleep on ehea_flush_sq
      ehea: converting msleeps to waitqueue on check_sqs() function

Bruce Allan (1):
      e1000e: 82579 performance improvements

Bruno Randolf (25):
      ath: Copy cryptographic capability flags into ath
      ath: Copy key cache management functions from ath9k to ath
      ath5k: Use common ath key management functions
      ath5k: Remove old ath5k key handling functions
      ath/ath9k: Replace common->splitmic with a flag
      ath5k: Use common crypt capabilities flags
      ath9k: Use common ath key management functions
      ath/ath5k/ath9k: Fix crypto capabilities merge issue
      ath5k: Use four hardware queues
      ath5k: Fix queue debug file
      ath5k: Fix TX queues stopping
      ath5k: Move tx frame completion into separate function
      ath5k: Add watchdog for stuck TX queues
      ath5k: Count how many times a queue got stuck
      ath5k: Keep last descriptor in queue
      ath5k: Simplify cw_min/max and AIFS configuration
      ath5k: Add tx queue configuration function
      ath5k: Remove unused variable for atim window
      ath5k: Check and fix ATIM window
      ath5k: Increase "fudge" for beacon timers
      ath5k: Disable interrupts in ath5k_hw_get_tsf64
      ath5k: Fix bitmasks and typos for PCU Diagnostic register
      mac80211: Add WME information element for IBSS
      ath5k: Don't wake internal queues
      nl80211/mac80211: Add retry and failed transmission count to station info

Carolyn Wyborny (2):
      igb: add check for fiber/serdes devices to igb_set_spd_dplx;
      e1000e: Fix for offline diag test failure at first call

Casey Leedom (4):
      cxgb3: Add register bit definition for Fatal Parity Error.
      cxgb3: Set FATALPERREN.
      cxgb3: Leave interrupts for fatal errors asserted in common code.
      cxgb3: Avoid flush_workqueue() deadlock.

Changli Gao (27):
      net: rps: reset network header before calling skb_get_rxhash()
      net: rps: skip fragment when computing rxhash
      net: introduce proto_ports_offset()
      net: rps: use proto_ports_offset() to handle the AH message correctly
      net_sched: cls_flow: use proto_ports_offset() to support AH message
      netfilter: ipt_CLUSTERIP: use proto_ports_offset() to support AH message
      netfilter: xt_hashlimit: use proto_ports_offset() to support AH message
      net_sched: sch_sfq: use proto_ports_offset() to support AH message
      net: rps: fix the wrong network header pointer
      net_sched: cls_flow: add key rxhash
      net: use __be16 instead of u16 for the userspace code
      net: 802.1q: make vlan_hwaccel_do_receive() return void
      net: rds: remove duplication type definitions
      net_sched: act_csum: coding style cleanup
      net: use scnprintf() to avoid potential buffer overflow
      net: arp: code cleanup
      net: rps: add the shortcut for one rps_cpus
      netfilter: nf_nat: add nf_nat_csum()
      netfilter: use NFPROTO_IPV4 instead of AF_INET
      netfilter: nf_nat_core: don't check if the tuple is used if there is no other choice
      netfilter: nf_nat: no IP_NAT_RANGE_MAP_IPS flags when alloc_null_binding()
      netfilter: nf_conntrack: fix the hash random initializing race
      netfilter: save the hash of the tuple in the original direction for latter use
      netfilter: unregister nf hooks, matches and targets in the reverse order
      net_sched: use __TCA_HTB_MAX and TCA_HTB_MAX
      phonet: remove the unused variable pn
      net_sched: remove the unused parameter of qdisc_create_dflt()

Chris Mason (17):
      RDS: Use a generation counter to avoid rds_send_xmit loop
      rds: switch to rwlock on bind_lock
      rds: per-rm flush_wait waitq
      rds: rcu-ize rds_ib_get_device()
      rds: Use RCU for the bind lookup searches
      rds: don't let RDS shutdown a connection while senders are present
      rds: Fix RDMA message reference counting
      RDS: use locking on the connection hash list
      rds: use RCU to protect the connection hash
      rds: Fix reference counting on the for xmit_atomic and xmit_rdma
      RDS/IB: Add caching of frags and incs
      RDS: use friendly gfp masks for prefill
      rds: recycle FMRs through lockless lists
      rds: more FMRs are faster
      RDS: use delayed work for the FMR flushes
      RDS: properly use sg_init_table
      RDS: flush fmrs before allocating new ones

Christian Dietrich (1):
      drivers/net: Removing undead ifdef CHELSIO_T1_1G

Christian Lamparter (40):
      mac80211: put rx handlers into separate functions
      mac80211: remove unused rate function parameter
      mac80211: AMPDU rx reorder timeout timer
      p54spi: fix eeprom checksum
      p54: improve eeprom parser
      p54spi: Kconfig option for config blob
      p54usb: fix off-by-one on !CONFIG_PM
      mac80211: cancel restart_work in ieee80211_unregister_hw
      mac80211: fix rcu-unsafe pointer dereference
      p54: better rssi->dbm conversion for longbow phys
      carl9170: mac80211 glue and command interface
      carl9170: Register maps, tx/rx descriptor formats and eeprom layout
      carl9170: PHY/RF and MAC routines
      carl9170: 802.11 rx/tx processing and usb backend
      carl9170: firmware parser and debugfs code
      carl9170: Makefile, Kconfig files and MAINTAINERS
      carl9170: update AR9170 phy initvals
      carl9170: use rx chainmask from eeprom
      carl9170: fix noise dBm conversion
      carl9170: don't load bogus nf of chain 1
      carl9170: abort tasklet during usb reset
      carl9170: fix state downgrade during reset
      carl9170: reinit phy after HT settings have changed
      carl9170: fix hang in AP mode when HT STA does PSM
      mac80211: clear txflags for ps-filtered frames
      carl9170: remove non-standard ba session teardown
      carl9170: angle brackets for wiki link
      carl9170: remove lost-frame workaround
      carl9170: fix tx_ampdu_upload counter
      carl9170: fix WARN_ON triggered by Broadcom HT STAs
      carl9170: revamp carl9170_tx_prepare
      carl9170: interrupt urbs must not set URB_ZERO_PACKET
      mac80211: fix rx monitor filter refcounters
      carl9170: support firmware-based rx filter
      p54usb: add five more USBIDs
      mac80211: fix possible null-pointer de-reference
      mac80211: temporarily disable reorder release timer
      carl9170: common error path for bad frames
      carl9170: remove stale rx error path
      carl9170: A-MPDU frame type filter

Dan Carpenter (18):
      net/sched: remove unneeded NULL check
      qlge: pull NULL check ahead of dereference
      tokenring: remove unneeded NULL checks
      plip: remove superflous return
      ath5k: re-order one of the frees on unwind
      isdn: potential buffer overflows
      isdn: cleanup: make buffer smaller
      bna: off by one
      rds: signedness bug
      rds: double unlock in rds_ib_cm_handle_connect()
      rds: spin_lock_irq() is not nestable
      airo: remove "basic_rate" module option
      ipw2200: check for allocation failures
      eicon: make buffer larger
      vhost: fix return code for log_access_ok()
      pch_gbe: fix if condition in set_settings()
      ns83820: spin_lock_irq() => spin_lock()
      gianfar: fix double lock typo

Dan Rosenberg (1):
      drivers/net/tulip/de4x5.c: fix union member name in DE4X5_GET_REG ioctl

Dan Williams (7):
      libertas: better scan response debugging
      libertas: better association request debugging
      libertas: [usb] use new firmware locations
      libertas: add two-stage firmware request helper
      libertas: [cs] use common firmware request helper and new firmware locations
      libertas: [sdio] use common firmware request helper and new firmware locations
      libertas: [spi] use common firmware request helper and new firmware locations

David Kilroy (2):
      orinoco: Fix walking past the end of the buffer
      orinoco: update status in MAINTAINERS

David Lamparter (1):
      netns: keep vlan slaves on master netns move

David S. Miller (42):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Rename skb_has_frags to skb_has_frag_list
      bna: Delete get_flags and set_flags ethtool methods.
      pkt_sched: Make act_csum depend upon INET.
      mlx4_en: Fix build warning in mlx4_en_create_rx_ring.
      stmmac: Make time functionality depend upon RTC_HCTOSYS_DEVICE
      stmmac: Fix build warnings.
      stmmac: Fix another build warning.
      starfire: Temporary kludge to fix powerpc build.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'for-davem' of git://oss.oracle.com/git/agrover/linux-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      bna: Check for NULL before deref in bnad_cb_tx_cleanup
      Merge branch 'dccp' of git://eden-feed.erg.abdn.ac.uk/net-next-2.6
      phonet: Fix build warning.
      Merge branch 'dccp' of git://eden-feed.erg.abdn.ac.uk/net-next-2.6
      sfc: Fix build due to lack of vmalloc.h include.
      ethtool: Fix build due to lack of ethtool.h include.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      sctp: Fix break indentation in sctp_ioctl().
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ipvs: Use frag walker helper in SCTP proto support.
      net: relax rtnl_dereference()
      ppp: Use a real SKB control block in fragmentation engine.
      Merge branch 'vhost-net-next' of git://git.kernel.org/.../mst/vhost
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'dccp' of git://eden-feed.erg.abdn.ac.uk/net-next-2.6
      s390: ctcm_mpc: Fix build after netdev refcount changes.
      tipc: Kill tipc_get_mode() completely.
      Merge branch 'can/mcp251x-for-net-next' of git://git.pengutronix.de/git/mkl/linux-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-2.6
      Merge branch 'vhost-net' of git://git.kernel.org/.../mst/vhost
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6

David Vrabel (2):
      Bluetooth: HCI devices are either BR/EDR or AMP radios
      Bluetooth: Support SDIO devices that are AMP controllers

Denis 'GNUtoo' Carikli (1):
      wl1251: Fix queue stopping/waking for TX path

Denis Kirjanov (13):
      r6040: Free irq line on error path
      ns83820: Use helper to disable chip interrupts
      ns83820: Remove unused have_optical variable.
      ns83820: Add copper device settings
      ns83820: Use predefined autoneg constants
      sundance: Add power management hooks
      sundance: Convert to DMA API
      sundance: Handle DMA mapping errors
      sundance: Use dev_kfree_skb_any() helper
      sundance: Drop legacy _COMPAT_WITH_OLD_KERNEL includes
      sundance: Add initial ethtool stats support
      ibmveth: Cleanup error handling inside ibmveth_open
      ibmveth: Free irq on error path

Diego Elio 'Flameeyes' Petten√≤ (1):
      sctp: implement SIOCINQ ioctl() (take 3)

Dimitris Michailidis (6):
      cxgb4: handle Rx/Tx queue ranges not starting at 0
      cxgb4: support eeprom read/write on functions other than 0
      cxgb4: fix setting of the function number in transmit descriptors
      cxgb4: update PCI ids
      cxgb4: remove a bogus PCI function number check
      ipv4: Remove leftover rcu_read_unlock calls from __mkroute_output()

Dmitry Kozlov (1):
      PPTP: PPP over IPv4 (Point-to-Point Tunneling Protocol)

Dmitry Kravkov (27):
      bnx2x: Load firmware in open() instead of probe()
      bnx2x: Spread rx buffers between allocated queues
      bnx2x: Moved enabling of MSI to the bnx2x_set_num_queues()
      bnx2x: create folder for bnx2x firmware files
      bnx2x: add 6.0.34 fw files
      bnx2x, cnic, bnx2i: use new FW/HSI
      bnx2x: remove old FW files
      bnx2x: rename MF related fields
      bnx2x: change type of spq_left to atomic
      bnx2x: Add 57712 support
      bnx2x: remove unused parameter in reuse_rx_skb()
      bnx2x: remove unused fields in main driver structure
      bnx2x: use proper constants for dma_unmap* calls
      bnx2x: use L1_CACHE_BYTES instead of magic number
      bnx2x: move msix table initialization to probe()
      bnx2x, cnic: Fix SPQ return credit
      bnx2x: code beautify
      bnx2x: properly initialize FW stats
      bnx2x: update version to 1.60.00-1
      bnx2x: Fixing a typo: added a missing RSS enablement
      bnx2x: remove redundant commands during error handling
      bnx2x: do not deal with power if no capability
      bnx2x: Use correct FW constant for header padding
      bnx2x: remove unnecessary FUNC_FLG_RSS flag and related
      bnx2x: update version to 1.60.00-2
      bnx2x: fix possible deadlock in HC hw block
      bnx2x: update version to 1.60.00-3

Don Skidmore (1):
      ixgbe: cleanup ixgbe_get_drvinfo to be extra careful with buffer boundaries

Eduardo Blanco (1):
      Fixed race condition at ip_vs.ko module init.

Eliad Peller (2):
      wl1271: avoid redundant memcpy of rx_status
      wl1271: bugfix: use bitwise-AND instead of logical-AND

Emil Tantilov (5):
      ixgbe: fix link issues and panic with shared interrupts for 82598
      ixgbevf: declare functions as static
      ixgbe: remove unused functions
      ixgbe: declare functions as static
      ixgbe: update copyright info

Eric Dumazet (121):
      atm: remove a net_device_stats clear
      vxge: Implement 64bit stats
      slip: fix get_stats() method
      net: build_ehash_secret() and rt_bind_peer() cleanups
      atl1c: use net_device_stats from struct net_device
      amd8111e: use net_device_stats from struct net_device
      irda: use net_device_stats from struct net_device
      net: copy_rtnl_link_stats64() simplification
      be2net: get rid of be_get_stats()
      ethoc: get rid of ethoc_stats()
      bcm63xx_enet: use netdev stats
      net: ip_append_data() optim
      bnx2x: small fix in stats handling
      typhoon: fix a race in typhoon_do_get_stats
      gro: __napi_gro_receive() optimizations
      bnx2x: fix wrong return from bnx2x_trylock_hw_lock
      net: struct xfrm_tunnel in read_mostly section
      ipv6: struct xfrm6_tunnel in read_mostly section
      pktgen: remove non used variable
      net: add a comment on netdev->last_rx
      gro: unexport tcp4_gro_receive and tcp4_gro_complete
      net: tunnels should use rcu_dereference
      skge: add GRO support
      net: skbuff.c cleanup
      net: another last_rx round
      net: dev_add_pack() & __dev_remove_pack() changes
      bna: fix stats handling
      drivers/net: avoid some skb->ip_summed initializations
      tulip: use integrated netdev stats
      net: remove two kmemcheck annotations
      r8169: fix rx checksum offload
      net: pskb_expand_head() optimization
      net: poll() optimizations
      r8169: add gro support
      net: introduce rcu_dereference_rtnl
      net: inet_add_protocol() can use cmpxchg()
      tunnels: missing rcu_assign_pointer()
      ixgbevf: remove private net_device_stats
      fib: cleanups
      flow: better memory management
      net: add rtnl_dereference()
      ipip: get rid of ipip_lock
      gre: get rid of ipgre_lock
      sit: get rid of ipip6_lock
      ipv4: ip_ptr cleanups
      ip6tnl: get rid of ip6_tnl_lock
      net: shrinks struct net_device
      ethtool: change ethtool_set_gro() to use ethtool_op_get_rx_csum
      bonding: enable gro by default
      net: reorder struct netdev_hw_addr
      net: rx_dropped accounting
      qlcnic: dont set skb->truesize
      net: constify some ppp/pptp structs
      ipv6: addrconf.h cleanups
      net: return operator cleanup
      ip: take care of last fragment in ip_append_data
      net: propagate NETIF_F_HIGHDMA to vlans
      net: skb_frag_t can be smaller on small arches
      drivers/net: return operator cleanup
      net: update SOCK_MIN_RCVBUF
      rps: allocate rx queues in register_netdevice only
      net: fix rcu use in ip_route_output_slow
      net: loopback driver cleanup
      vlan: use this_cpu_ptr() in vlan_skb_recv()
      tunnels: prepare percpu accounting
      ip_gre: percpu stats accounting
      ipip: percpu stats accounting
      sit: percpu stats accounting
      fib: use atomic_inc_not_zero() in fib_rules_lookup
      net: sk_{detach|attach}_filter() rcu fixes
      net: add a recursion limit in xmit path
      dummy: percpu stats and lockless xmit
      ipip: fix percpu stats accounting
      sit: fix percpu stats accounting
      sit: enable lockless xmits
      ip_gre: lockless xmit
      ipip: enable lockless xmits
      ip6tnl: percpu stats accounting
      net: rename netdev rx_queue to ingress_queue
      ip_gre: comments change
      ipv4: __mkroute_output() speedup
      ipv4: introduce __ip_dev_find()
      ipv4: rcu conversion in ip_route_output_slow
      neigh: reorder fields in struct neighbour
      ipmr: __pim_rcv() is called under rcu_read_lock
      ipmr: RCU conversion of mroute_sk
      ipmr: RCU protection for mfc_cache_array
      ipmr: cleanups
      net: introduce DST_NOCACHE flag
      netfilter: ipt_LOG: add bufferisation to call printk() once
      net: dynamic ingress_queue allocation
      fib: cleanups
      net: add a core netdev->rx_dropped counter
      net neigh: neigh_delete() and neigh_add() changes
      net neigh: RCU conversion of neigh hash table
      fib: RCU conversion of fib_lookup()
      neigh: RCU conversion of struct neighbour
      sundance: get_stats proper locking
      neigh: speedup neigh_hh_init()
      neigh: Protect neigh->ha[] with a seqlock
      net dst: use a percpu_counter to track entries
      neigh: reorder struct neighbour fields
      net: percpu net_device refcount
      r8169: use 50% less ram for RX ring
      net: allocate skbs on local node
      fib6: use FIB_LOOKUP_NOREF in fib6_rule_lookup()
      fib: remove a useless synchronize_rcu() call
      fib_trie: use fls() instead of open coded loop
      fib: avoid false sharing on fib_table_hash
      netns: reorder fields in struct net
      fib_hash: embed initial hash table in fn_zone
      fib_hash: RCU conversion phase 1
      fib_hash: RCU conversion phase 2
      igb: fix stats handling
      net: avoid a dev refcount in ip_mc_find_dev()
      inet: RCU changes in inetdev_by_index()
      net: avoid RCU for NOCACHE dst
      net/sched: fix missing spinlock init
      fib: introduce fib_alias_accessed() helper
      ixgbe: fix stats handling
      l2tp: small cleanup

Fabio Rossi (1):
      ath5k: avoid unneeded calibration error messages

Felix Fietkau (48):
      mac80211: fix driver offchannel notification when the channel does not change
      ath9k: add a separate debug level for stuck beacons
      ath9k_hw: apply the noise floor validation to the median instead of single
      ath9k: use AP beacon miss as a trigger for fast recalibration
      ath9k: shorten the calibration interval during strong interference
      ath9k: fix spurious MIC failure reports
      ath9k: fix BSSID mask calculation
      mac80211: add a note about iterating interfaces during add_interface()
      ath9k_hw: handle rx key miss
      ath9k_hw: remove useless hw capability flags
      ath9k: clean up block ack window handling
      ath9k: fix an aggregation start related race condition
      ath9k: clean up / fix aggregation session flush
      ath9k: move ath_tx_aggr_check() to the rate control module
      ath9k: make the driver specific rate control module optional
      ath9k_hw: simplify revision checks for AR9280
      ath9k_hw: simplify revision checks for AR9285
      ath9k_hw: simplify revision checks for AR9287
      ath9k_htc: remove use of common->ani.noise_floor
      ath9k_hw: keep calibrated noise floor values per channel
      ath9k: do not return default noise floor values via survey
      ath9k: remove the noise floor value in the ani struct
      nl80211: allow drivers to indicate whether the survey data channel is in use
      ath9k: return survey data for all channels instead of just the current one
      ath9k: fix channel flag / regd issues with multiple cards
      ath9k_hw: remove some useless calibration data
      ath9k_hw: clean up calibration flags
      ath9k_hw: merge codepaths that access the cycle counter registers
      ath9k_hw: clean up register write buffering
      ath9k_hw: add a helper function to check for the new ANI implementation
      ath9k_hw: clean up ANI state handling
      ath9k_hw: remove code duplication in phy error counter handling
      ath9k_hw: remove function pointer abstraction for internal ANI ops
      ath9k_hw: merge ath9k_hw_ani_monitor_old and ath9k_hw_ani_monitor_new
      ath9k_hw: store the clock rate in common data on channel changes
      ath5k: store the clock rate in common data on channel changes
      ath9k_hw: move the cycle counter tracking to ath
      ath5k: use the common cycle counter / listen time implementation
      cfg80211: add channel utilization stats to the survey command
      ath9k: add compile time checking for the size of the channel list
      ath9k: implement channel utilization stats for survey
      ath9k: do not track cycle counter updates in powersave mode
      ath9k_hw: fix division by zero in the ANI monitor code
      ath9k_hw: fix PHY counter overflow handling in ANI v1
      ath9k: add missing locking around ath9k_hw_proc_mib_event
      ath9k: make rate control debugfs stats per station
      ath9k: remove sc->cur_rate_table and sc->cur_rate_mode
      ath9k_hw: remove enum wireless_mode and its users

Flavio Leitner (3):
      bonding: rejoin multicast groups on VLANs
      bonding: fix to rejoin multicast groups immediately
      bonding: add retransmit membership reports tunable

Florian Fainelli (9):
      r6040: fix all checkpatch errors and warnings
      cpmac: fix all checkpatch errors and warnings
      au1000-eth: typedefs removal
      au1000-eth: stylistic fixes
      au1000-eth: fix all but one "line over 80 characters warnings"
      au1000-eth: fix bad printk usages
      au1000-eth: fix asm -> linux headers inclusion
      au1000-eth: remove volatiles, switch to I/O accessors
      au1000-eth: change multi-line comments style

Florian Westphal (1):
      tipc: add SO_RCVLOWAT support to stream socket receive path

Frank Blaschka (1):
      qeth: NAPI support for l2 and l3 discipline

Gabor Juhos (1):
      ath9k: get correct tx gain type in ath9k_hw_4k_get_eeprom

Geert Uytterhoeven (1):
      net/m68k: Hydra Ethernet - print whole resource instead of start address

Gerrit Renker (26):
      ccid: ccid-2/3 code cosmetics
      dccp ccid-3: No more CCID control blocks in LISTEN state
      dccp ccid-2: Remove redundant sanity tests
      dccp ccid-2: Simplify dec_pipe and rearming of RTO timer
      dccp ccid-2: Replace broken RTT estimator with better algorithm
      dccp ccid-2: Use u32 timestamps uniformly
      dccp ccid-2: Remove wrappers around sk_{reset,stop}_timer()
      tcp/dccp: Consolidate common code for RFC 3390 conversion
      dccp ccid-2: Share TCP's minimum RTO code
      dccp ccid-3: use per-route RTO or TCP RTO as fallback
      TCP: update initial windows according to RFC 5681
      tcp: update also tcp_output with regard to RFC 5681
      dccp ccid-3: A lower bound for the inter-packet scheduling algorithm
      dccp ccid-3: remove buggy RTT-sampling history lookup
      dccp ccid-3: Simplify and consolidate tx_parse_options
      dccp: Add packet type information to CCID-specific option parsing
      dccp: Replace magic CCID-specific numbers by symbolic constants
      dccp ccid-3: remove dead states
      dccp tfrc/ccid-3: computing the loss rate from the Loss Event Rate
      dccp ccid-3: Remove redundant 'options_received' struct
      dccp: fix the adjustments to AWL and SWL
      dccp: merge now-reduced connect_init() function
      dccp: remove unused argument in CCID tx function
      dccp: schedule an Ack when receiving timestamps
      dccp: cosmetics - warning format
      wext: fix alignment problem in serializing 'struct iw_point'

Giuseppe CAVALLARO (6):
      stmmac: remove dead option in the driver's Kconfig
      stmmac: make ioaddr 'void __iomem *' rather than unsigned long
      stmmac: add CSR Clock range selection
      stmmac: consolidate and tidy-up the COE support
      stmmac: prevent dma init stuck in case of failures.
      stmmac: use one memset() to reset TDES01

Giuseppe Cavallaro (2):
      stmmac: review the wake-up support
      stmmac: remove ifdef NETIF_F_TSO from stmmac_ethtool.c

Grazvydas Ignotas (4):
      wl1251: add missing __packed modifier for some structs
      wl1251: fix event handling mechanism
      wl1251: fix beacon filter table structure
      wl1251: wait for join command complete event

Greg Rose (3):
      ixgbevf: Removed unneeded HW struct members
      ixgbevf: Refactor ring parameter re-size
      igbvf: Remove unneeded pm_qos* calls

Gr√©goire Baron (1):
      net/sched: add ACT_CSUM action to update packets checksums

Guo-Fu Tseng (5):
      jme: Fix PHY power-off error
      jme: Add comment in jme_set_settings
      jme: Prevent possible read re-order error
      jme: Adding mii-tool support
      jme: Advance version number

Gustavo F. Padovan (4):
      Bluetooth: remove unused variable from cmtp
      Bluetooth: make batostr() print in the right order
      Bluetooth: Use the proper error value from bt_skb_send_alloc()
      Bluetooth: update MAINTAINERS for Bluetooth subsys

G√°bor Stefanik (4):
      b43: N-PHY: Implement Host Flags write during device init
      b43: N-PHY: Fix typo in function name (gain_crtl -> gain_ctrl)
      b43: N-PHY: Implement MAC PHY clock set
      b43: N-PHY: Implement RX core state setting for rev.2 and earlier PHYs

Hagen Paul Pfeifer (1):
      tcp: allow effective reduction of TCP's rcv-buffer via setsockopt

Haijun Liu (1):
      Bluetooth: Update conf_state before send config_req out

Hans Schillstrom (1):
      ipvs: IPv6 tunnel mode

Hao Zheng (1):
      bnx2x: Update bnx2x to use new vlan accleration.

Harvey Harrison (3):
      cxgb4vf: make single bit signed bitfields unsigned
      dnet: mark methods static and annotate for correct endianness
      niu: introduce temp variables to avoid sparse warnings when swapping in-situ

Helmut Schaa (32):
      rt2x00: Update comments regarding TXWI and TX_STA_FIFO
      rt2x00: Rename txentry_desc.queue -> txentry_desc.qid
      rt2x00: Update rt2800 comments regarding AMPDU and PACKET_ID in TXWI
      rt2x00: Initialize AMPDU_BA_WINSIZE register
      rt2x00: Check for specific changed flags when updating the erp config
      rt2x00: Mask out unused interrupts in rt2800pci
      rt2x00: Enable missing interrupts in rt61pci
      rt2x00: fix oops in rt2x00lib_txdone with rt61pci
      rt2x00: Don't overwrite beacon buffers in pairwise key setup
      rt2x00: Split out parts of the rt2800_txdone function for easier reuse
      rt2x00: rework tx status handling in rt2800pci
      rt2x00: Fix SM PS check
      rt2x00: Implement HT protection for rt2800
      rt2x00: Don't initialize MM40 HT protection to RTS/CTS on PCI devices
      rt2x00: Fix race between dma mapping and clearing rx entries in rt2800pci
      rt2x00: Allow tx duplication for legacy rates in HT40 mode
      rt2x00: Add register definition for busy time on secondary channel
      rt2x00: add field definitions for the TBTT_SYNC_CFG register
      rt2x00: Don't enable broad- and multicast buffering on USB devices
      mac80211: distinct between max rates and the number of rates the hw can report
      rt2x00: correctly set max_report_rates in rt61pci and rt2800
      rt2x00: Enable rx aggregation in rt2800
      rt2x00: Update comment about the AMPDU flag in the TXWI
      rt2x00: Fix oops caused by error path in rt2x00lib_start
      rt2x00: Improve cooperation between rt2800pci and minstrel
      rt2x00: Work around hw aggregation oddity in rt2800
      rt2x00: Shortcut link state updates when not operating as STA
      rt2x00: Optimize unmapping of skbs
      rt2x00: Use proper type for rxwi_w2 in rt2800_agc_to_rssi
      rt2x00: Use unlikely for error case in rt2x00queue_write_tx_frame
      rt2x00: Remove superfluous initialization of qidx
      rt2x00: Fix tx status handling in rt2800pci

Huang Weiyi (1):
      pxa168_eth: remove duplicated #include

Ian Campbell (1):
      xen: use less generic names in netfront driver.

Ido Yariv (4):
      wl1271: Fix overflow in wl1271_boot_upload_nvs
      wl1271: Handle large SPI transfers
      wl1271: Support firmware RX packet aggregation
      wl1271: Support firmware TX packet aggregation

Ilpo J√§rvinen (2):
      tcp: sack lost marking fixes
      tcp: use correct counters in CA_CWR state too

Ivo Calado (1):
      dccp: generalise data-loss condition

Ivo van Doorn (31):
      rt2x00: Move USB tx/rx done handling to workqueue
      rt2x00: Set MIMO PS flag in tx descriptor for STAs in dynamic SMPS mode
      rt2x00: Add helper function for reporting tx status
      rt2x00: Request TXWI pointer from driver
      rt2x00: Implement TX status reporting for rt2800usb
      rt2x00: Remove ieee80211_rx_status from rt2x00_dev
      rt2x00: Simplify arguments to rt2x00 driver callback functions
      rt2x00: Reduce indenting
      rt2x00: Move direct access to queue->entries to rt2x00queue.c
      rt2x00: Remove Q_INDEX_CRYPTO and ENTRY_OWNER_DEVICE_CRYPTO
      rt2x00: Fix rt2800 retry calculation
      rt2x00: Merge rt2800{pci/usb} radio enabling/disabling code to rt2800lib
      rt2x00: Fix channel configuration for RF3052
      rt2x00: Fix max TX power settings
      rt2x00: Add rt2800_wait_csr_ready
      rt2x00: Validate TX status results with current data entry
      rt2x00: Wakeup hardware before loading firmware
      rt2x00: Don't set unicast/BSSID masks when clearning MAC or BSSID
      rt2x00: Set PWR_PIN_CFG during initialization
      rt2x00: Correctly kill beacon queue
      rt2x00: Split watchdog check into a DMA and STATUS timeout
      rt2x00: Cleanup rt2x00usb_watchdog_reset_tx
      rt2x00: Add rt73usb device ID
      rt2x00: Improve TX status entry validation
      rt2x00: Simplify Queue function arguments
      rt2x00: Move watchdog work to kernel work_queue
      rt2x00: Validate MCS on RX path
      rt2x00: Fix dead queue when skb allocation failed
      rt2x00: Make queue_entry flags access atomic
      rt2x00: Don't perform watchdog checks on empty queue
      rt2x00: Fix URB error handling

James Hogan (1):
      b44: fix resume, request_irq after hw reset

Jan Engelhardt (5):
      netfilter: xtables: resolve indirect macros 1/3
      netfilter: xtables: resolve indirect macros 2/3
      netfilter: xtables: resolve indirect macros 3/3
      netfilter: xtables: unify {ip,ip6,arp}t_error_target
      netfilter: xtables: remove unused defines

Jan Glauber (1):
      qdio: extend API to allow polling

Jan Kiszka (1):
      CAPI: Silence lockdep warning on get_capi_appl_by_nr usage

Jason Wang (1):
      vhost: max s/g to match qemu

Jay Sternberg (4):
      iwlwifi: enable experimental ucode support
      iwlwifi: move debug options into submenu
      iwlwifi: corrections to debug output of ucode statistics
      iwlwifi: define 100 devices

Jean Delvare (1):
      e1000e: Simplify MSI interrupt testing

Jerry Chu (1):
      tcp: Add TCP_USER_TIMEOUT socket option.

Jesse Brandeburg (5):
      e1000: fix Tx hangs by disabling 64-bit DMA
      e1000: use work queues
      e1000: fix occasional panic on unload
      e1000: use GRO for receive
      e1000e: use hardware writeback batching

Jesse Gross (12):
      ebtables: Allow filtering of hardware accelerated vlan frames.
      vlan: Rename VLAN_GROUP_ARRAY_LEN to VLAN_N_VID.
      vlan: Don't check for vlan group before vlan_tx_tag_present.
      vlan: Enable software emulation for vlan accleration.
      vlan: Avoid hash table lookup to find group.
      vlan: Centralize handling of hardware acceleration.
      ethtool: Add support for vlan accleration.
      bridge: Add support for TX vlan offload.
      bnx2: Update bnx2 to use new vlan accleration.
      ixgbe: Update ixgbe to use new vlan accleration.
      vlan: Calling vlan_hwaccel_do_receive() is always valid.
      bnx2/bnx2x: Unsupported Ethtool operations should return -EINVAL.

Jiri Pirko (1):
      vlan: Use vlan_dev_real_dev in vlan_hwaccel_do_receive

Jiri Slaby (3):
      NET: bna, fix lock imbalance
      NET: pch, fix use after free
      WIRELESS: at76c50x, remove unneeded NULL check

Joe Perches (27):
      pcnet_cs: Use pr_fmt and pr_<level>
      drivers/net: Convert unbounded kzalloc calls to kcalloc
      drivers/net/pcmcia: Use pr_<level> and netdev_<level>
      drivers/net/sungem: Use netdev_<level>, netif_<level> and pr_<level>
      drivers/net/sunvnet.c: Use pr_<level> and netdev_<level>
      include/linux/if_ether.h: Remove unused #define MAC_FMT
      net/mac80211: Use wiphy_<level>
      MAINTAINERS: add info for include/linux/spi/wl12xx.h
      drivers/net: Remove address use from assignments of function pointers
      net/sctp: Use pr_fmt and pr_<level>
      drivers/net/jme: Use pr_<level>
      net/caif: Use pr_fmt
      net/caifcaif_dev.c: Use netdev_<level>
      include/net/raw.h: Convert raw_seq_private macro to inline
      qeth: Use %pI6
      drivers/net/ixgbe/ixgbe_main.c: Checkpatch cleanups
      drivers/net/ixgbe/ixgbe_main.c: Use pr_<level>
      drivers/net/ixgbe/ixgbe_main.c: Add ixgbe_psum
      drivers/net/skfp: Remove pr_<level> uses of KERN_<level>
      drivers/isdn: Use static const char * const where possible
      drivers/net: Use static const char * const where possible
      drivers/net/pcmcia: Use static const char * const where possible
      drivers/net/wireless: Use static const char * const where possible
      net/irda: Use static const char * const where possible
      include/net/cfg80211.h: wiphy_<level> messages use dev_printk
      ath5k: fix build break from "ath5k: Print out opmode in debugfs"
      drivers/net/pch_gbe: Use DEFINE_PCI_DEVICE_TABLE

Johan Hedberg (1):
      Bluetooth: Don't clear the blacklist when closing the HCI device

Johannes Berg (146):
      mac80211: don't check rates on PLCP error frames
      mac80211: unify scan and work mutexes
      iwlwifi: track IBSS manager status
      cfg80211: deauth doesn't always imply disconnect
      mac80211: per interface idle notification
      mac80211: allow drivers to request SM PS mode change
      cfg80211: support sysfs namespaces
      mac80211: use cipher suite selectors
      mac80211: move key tfm setup
      mac80211: remove unused status flag checks
      mac80211: dont advertise WEP if unavailable
      cfg80211: check if WEP is available for shared key auth
      cfg80211: mark ieee80211_hdrlen const
      mac80211: remove unused don't-encrypt flag
      cfg80211/mac80211: extensible frame processing
      wireless: move documentation books
      mac80211-hwsim: allow configuring IBSS
      iwlwifi: refactor iwl_setup_rxon_timing
      mac80211: fix docbook
      nl80211: some documentation fixes
      iwlagn: do not check for AP mode for WEP keys
      iwlwifi: do not spuriously call ieee80211_scan_completed
      cfg80211: add some documentation
      iwlwifi: add 6000g2b BT coexist API
      iwlagn: implement advance BT config command
      iwlagn: set BT IGNORE for some frames
      iwlwifi: add BT notification support for bt coex
      iwlagn: let bluetooth traffic load impact rate scale
      iwlwifi: reset BT when going down
      iwlagn: disable gen2b BT coexistence in IBSS
      iwlagn: keep BT settings across restart
      iwlwifi: use antenna A only under high BT load
      iwlwifi: disable aggregation queue if stopped early
      nl80211: fix missing nesting
      mac80211: fix mesh advertisement
      iwlwifi: initial contextification
      iwlwifi: prepare for PAN queue/fifo assignment
      iwlwifi: define PAN queues/FIFOs
      iwlwifi: contextify broadcast station
      iwlwifi: contextify-stations-completely
      iwlwifi: contextify command sending
      iwlwifi: move QoS into context
      iwlwifi: add context into tx descriptor
      iwlwifi: move virtual interface pointer into context
      iwlwifi: clamp scanning dwell time to all contexts
      iwlwifi: move AP sta ID to context
      iwlwifi: make hw crypto context aware
      iwlwifi: store default station flags in context
      iwlwifi: add context pointer to station
      iwlwifi: move HT configuration data into context
      iwlwifi: introduce beacon context
      iwlwifi: add PAN API
      iwlagn: detect PAN capability
      iwlagn: remove iw_mode check for beacon
      iwlagn: queue frames according to context
      iwlagn: send RXON timing before associating
      iwlagn: send beacon before committing associated RXON
      iwlwifi: send PAN parameters
      iwlwifi: pass context to iwl_send_rxon_timing
      iwlagn: always send RXON timing
      iwlwifi: follow main beacon interval
      iwlwifi: allow using multiple contexts
      mac80211: remove unused scan expire define
      mac80211: allow scan to complete from any context
      wl12xx: remove unneeded locking
      cfg80211 docbook: remove erronous !A
      cfg80211: allow vendor specific cipher suites
      mac80211: allow vendor specific cipher suites
      cfg80211: allow changing port control protocol
      mac80211: allow changing port control protocol
      mac80211: use subqueue helpers
      mac80211: clean up ifdown/cleanup paths
      mac80211: switch to ieee80211_sdata_running
      mac80211: simplify zero address checks
      mac80211: split out concurrent vif checks
      mac80211: support runtime interface type changes
      mac80211_hwsim: support runtime iftype changes
      mac80211: fix offchannel queue stop
      iwlwifi: fix PAN parameters while scanning
      iwlwifi: implement beacon interval change
      iwlwifi: avoid sending too many commands
      iwlwifi: improve timing handling with dual-mode
      iwlwifi: fix and describe iwl_adjust_beacon_interval
      iwlwifi: remove unused conf variables
      iwlwifi: unify scan start checks
      iwlwifi: move scan completed flags handling
      mac80211: match only assigned bss in sta_info_get_bss
      mac80211: use correct station flags lock
      cfg80211/mac80211: use lockdep_assert_held
      mac80211: set running state earlier
      cfg80211/nl80211: introduce p2p device types
      mac80211: add p2p device type support
      mac80211: remove prepare_for_handlers sdata argument
      mac80211: consolidate packet processing
      mac80211: clean up rx handling wrt. found_sta
      mac80211: fix release_reorder_timeout in scan
      mac80211: move packet flags into packet
      cfg80211: always set IBSS basic rates
      cfg80211/mac80211: allow management frame TX in AP mode
      cfg80211: remove spurious __KERNEL__ ifdef
      cfg80211: fix locking
      genetlink: introduce pre_doit/post_doit hooks
      nl80211: use the new genetlink pre/post_doit hooks
      nl80211: use generic check for netif_running
      nl80211: reduce dumping boilerplate
      mac80211: fix deadlock with multiple interfaces
      nl80211: fix remain-on-channel documentation
      mac80211: avoid transmitting delBA to old AP
      cfg80211/mac80211: allow per-station GTKs
      nl80211: fix error in generic netif_running check
      cfg80211: fix BSS double-unlinking
      mac80211: fix sw scan locking
      nl80211: use new genl helpers for WDS
      cfg80211: constify WDS address
      iwlagn: rename iwl_commit_rxon
      iwlwifi: introduce post_scan hook
      iwl3945: use iwl3945_commit_rxon
      iwlwifi: move chain settings to agn
      iwlwifi: rename iwl_mac_beacon_update
      iwlwifi: remove verify_signature eeprom operation
      iwlwifi: move agn specific station code there
      iwlwifi: move tx fail code to agn
      iwlwifi: remove spurious exports
      iwlwifi: remove agn rates info there
      iwlwifi: move iwl_toggle_rx_ant to agn
      iwlwifi: move iwl_dump_csr to agn
      iwlwifi: move iwl_dump_fh to agn
      iwlwifi: remove set_ct_kill operation
      iwlwifi: remove set_pwr_src operation
      iwlwifi: remove apm_ops.stop
      iwlwifi: clean up declarations
      iwlwifi: remove iwl_check_bits
      iwlwifi: fix dual-mode scanning
      Revert "wireless: Use first phyX name available when registering phy devices."
      mac80211: don't kmalloc 16 bytes
      iwl3945: fix queue allocation
      cfg80211: notify drivers about frame registrations
      mac80211: add probe request filter flag
      mac80211: fix SMPS request
      iwlwifi: allow probe-after-rx on 2.4 GHz
      iwlwifi: rename ibss_beacon variable
      iwlwifi: clean up some beacon handling
      iwlwifi: rewrite RXON checks
      iwlwifi: blink LED in IBSS mode
      iwlagn: check beacon frame size
      radiotap: fix vendor namespace parsing

John Fastabend (2):
      net: netif_set_real_num_rx_queues may cap num_rx_queues at init time
      ixgbe: DCB: remove DCB check config

John Feeney (1):
      bnx2: Add PCI Advanced Error Reporting support.

John Heffner (1):
      TCP: Fix setting of snd_ssthresh in tcp_mtu_probe_success

John W. Linville (44):
      b43: update hw/fw version info in wiphy struct
      b43legacy: update hw/fw version info in wiphy struct
      p54: update fw version info in wiphy struct
      rt2x00: update fw version info in wiphy struct
      zd1211rw: update fw version info in wiphy struct
      mac80211: support use of NAPI for bottom-half processing
      rtl8180: use NAPI for bottom-half processing
      rtl8180: use RTL818X_MSR_ADHOC for IBSS connection
      rtl8187: consolidate MSR writes in rtl8187_bss_info_changed
      wireless: upcase alpha2 values in queue_regulatory_request
      iwlwifi: disable aspm by default
      ipw2100: avoid warning from pointer cast in call to IPW_DEBUG_TX
      iwm3200wifi: remove comparison to WIFI_IF_NTFY_MAX in iwm_ntf_wifi_if_wrapper
      b43: move hwrng registration driver to wireless core initialization
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      rt2x00: do not shortcut rt2x00lib_config_antenna
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      mac80211: cancel scan in ieee80211_restart_hw if software scan pending
      mac80211: only cancel software-based scans on suspend
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      wl1271: remove warnings in wl1271_sdio_set_power
      iwlwifi: fix sparse warning about wrong enum for band parameter
      ath9k: make ath_ant_div_conf_fast_divbias static
      libertas: correct sparse warnings
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Revert "mac80211: fix use-after-free"
      wl12xx: fix separate-object-folder builds
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'wireless-next' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      mac80211: avoid uninitialized var warning in ieee80211_scan_cancel
      Revert "rtl8180: use NAPI for bottom-half processing"
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'wireless-next' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next-2.6 into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Jon Mason (2):
      s2io: remove unused code
      s2io: Update driver version

Joseph Gasparakis (1):
      igb: Add support for DH89xxCC

Jouni Malinen (5):
      mac80211: Fix signal strength average initialization for CQM events
      mac80211: Do not generate CQM events based on first Beacon frames
      mac80211: Filter ProbeReq SuppRates based on TX rate mask
      mac80211: Add DS Parameter Set into Probe Request on 2.4 GHz
      ath9k: Set RX filter for Probe Request based on filter flag

Julia Lawall (31):
      drivers/net/wireless/libertas: Adjust confusing if indentation
      drivers/net/wireless/prism54: Adjust confusing if indentation
      drivers/net/wireless/ath/ath9k: Adjust confusing if indentation
      drivers/net/wan: Adjust confusing if indentation
      net/atm: Adjust confusing if indentation
      drivers/net/irda: Adjust confusing if indentation
      drivers/net: Adjust confusing if indentation
      drivers/atm: Adjust confusing if indentation
      drivers/net: Adjust confusing if indentation
      drivers/net/bnx2x: Adjust confusing if indentation
      drivers/net/hamradio: Adjust confusing if indentation
      drivers/net: Adjust confusing if indentation
      drivers/isdn: Adjust confusing if indentation
      net/decnet: Adjust confusing if indentation
      net/ax25: Use available error codes
      net/ax25: Use available error codes
      drivers/net/qlcnic: Use available error codes
      drivers/net/wireless/wl12xx: Use available error codes
      drivers/net/wireless/wl12xx: Use available error codes
      drivers/net/irda: Eliminate memory leak
      net/netfilter/ipvs: Eliminate memory leak
      drivers/net/atl1c: Remove double test
      net/wireless: Remove double test
      drivers/net/can/mscan/mpc5xxx_can.c: Add of_node_put to avoid memory leak
      drivers/net/fs_enet/fs_enet-main.c: Add of_node_put to avoid memory leak
      net/9p/trans_fd.c: Fix unsigned return type
      drivers/atm/firestream.c: Fix unsigned return type
      drivers/net/wireless/iwlwifi/iwl-agn.c: Fix return value from an unsigned function
      drivers/atm/idt77252.c: Remove unnecessary error check
      drivers/net/wireless/p54/eeprom.c: Return -ENOMEM on memory allocation failure
      drivers/net/ax88796.c: Return error code in failure

Julian Anastasov (18):
      ipvs: use pkts for SCTP too
      ipvs: extend connection flags to 32 bits
      ipvs: netfilter connection tracking changes
      ipvs: make rerouting optional with snat_reroute
      ipvs: changes related to service usecnt
      ipvs: fix CHECKSUM_PARTIAL for TCP, UDP
      ipvs: optimize checksums for apps
      ipvs: switch to notrack mode
      ipvs: do not schedule conns from real servers
      ipvs: stop ICMP from FORWARD to local
      ipvs: fix CHECKSUM_PARTIAL for TUN method
      ipvs: create ip_vs_defrag_user
      ipvs: move ip_route_me_harder for ICMP
      ipvs: changes for local real server
      ipvs: changes for local client
      ipvs: inherit forwarding method in backup
      ipvs: provide address family for debugging
      nf_nat: restrict ICMP translation for embedded header

Julian Calaby (1):
      Hostap: Fix "'ret' set but not used" warning message from GCC in hostap

Juuso Oikarinen (28):
      wl1271: Implement CMD_SET_STA_STATE to indicate connection completion to FW
      wl1271: Add trigger to net_device oper_state to change BT coex priority
      wl1271: Fix scan race condition
      wl1271: Change supported channel order for a more optimal scan
      wl1271: Remove outdated FIXME's
      wl1271: Move setting of wake-up conditions to ps.c from cmd.c
      wl1271: Remove acx_fw_version function
      wl1271: Release interrupt *after* releasing the driver context
      wl1271: Remove function cmd_read_memory
      wl1271: Enable/disable 11a support based on INI configuration
      wl1271: Reduce rate used for last PSM entry attempt
      wl1271: Enable 11a support always, prevent scanning for unsupporting chips
      wl1271: Fix tid-configuration of TX frames
      wl1271: Fix AC/TID default configuration
      wl1271: Move scan complete invocation into work function
      wl1271: Fix work cancelling when shutting down the driver
      wl1271: Separate interface removal to another function
      wl1271: Add hardware recovery mechanism
      wl1271: Add handling for failing hardware scan command
      wl1271: Optimize scan duration
      wl1271: Increase connection reliability
      wl1271: Add support for hardware GEM cipher
      mac80211: Fix WMM driver queue configuration
      wl1271: Move work-init calls to hw allocation
      wl1271: Indicate disconnection on hardware failure
      wl1271: Add extended radio parameter initialization
      mac80211: Add validity check for beacon_crc value
      wl1271: Support FEM autodetection

Kalle Valo (7):
      wl1251: update my email address
      wl12xx: change contact person for the include file
      wl1251: remove copyright contact person
      wl1251: move include guard after the license
      wl1251: create a copy of wl12xx_80211.h for wl1251
      wl1251: move to it's own directory
      wl1251: update the new location to the maintainers file

Karl Beldan (1):
      Bluetooth: hci_uart: Fix typo in stats for sco tx

Krishna Kumar (2):
      core: Factor out flow calculation from get_rps_cpu
      macvtap: Implement multiqueue for macvtap driver

Krzysztof Oledzki (1):
      bonding: add Speed/Duplex information to /proc/net/bonding/bond

Krzysztof Piotr Oledzki (2):
      bonding: print information about speed and duplex seen by the driver
      bonding: reread information about speed and duplex when interface goes up

Kumar Sanghvi (4):
      Phonet: Implement Pipe Controller to support Nokia Slim Modems
      Documentation: Update Phonet doc for Pipe Controller implementation
      Phonet: 'connect' socket implementation for Pipe controller
      Documentation: Update Phonet doc for Pipe controller changes

Lars Ericsson (1):
      rt2x00: Antenna diversity does not work in 2.6.35

Luciano Coelho (5):
      wl1271: remove deprecated ACX definition
      wl1271: remove useless 11a check when scanning
      wl1271: fix forced passive scan
      MAINTAINERS: Update git url for the wl1271 driver
      wl1271: remove deprecated __attribute__ ((packed))

Luis R. Rodriguez (15):
      ath9k: add fastcc to debug print for channel change
      ath9k: remove duplicate get_hw_crypto_keytype()
      ath9k: fix power save race conditions
      ath9k: fix regression on beacon loss after bgscan
      ath9k: fix enabling ANI / tx monitor after bg scan
      mac80211: add helper for reseting the connection monitor
      mac80211: reset probe send counter upon connection timer reset
      mac80211: reset connection idle when going offchannel
      mac80211: make the beacon monitor available externally
      mac80211: disable beacon monitor while going offchannel
      mac80211: send last 3/5 probe requests as unicast
      ath9k: fix regression which disabled ps on ath9k
      mac80211: fix offchannel assumption upon association
      mac80211: fix channel assumption for association done work
      ath9k_hw: remove AR9003 2.0 support

Maciej ≈ªenczykowski (1):
      ipv6: Implement Any-IP support for IPv6.

Marc Kleine-Budde (7):
      can: mcp251x: fix NOHZ local_softirq_pending 08 warning
      can: mcp251x: write intf only when needed
      can: mcp251x: Don't use pdata->model for chip selection anymore
      can: mcp251x: define helper functions mcp251x_is_2510, mcp251x_is_2515
      can: mcp251x: optimize 2515, rx int gets cleared automatically
      can: mcp251x: fix endless loop in interrupt handler if CANINTF_MERRF is set
      can: mcp251x: fix generation of error frames

Martin Schwidefsky (1):
      drivers/net/stmmac/: add HAS_IOMEM dependency

Masayuki Ohtake (1):
      net: Add Gigabit Ethernet driver of Topcliff PCH

Mat Martineau (4):
      Bluetooth: Validate PSM values in calls to connect() and bind()
      Bluetooth: Add common code for stream-oriented recvmsg()
      Bluetooth: Use common SOCK_STREAM receive code in RFCOMM
      Bluetooth: Use a stream-oriented recvmsg with SOCK_STREAM L2CAP sockets.

Matt Carlson (26):
      tg3: Fix read DMA FIFO overruns on recent devices
      tg3: Disable TSS
      tg3: Don't send APE events for NCSI firmware
      tg3: Unlock 5717 B0+ support
      tg3: Clarify semantics of TG3_IRQ_MAX_VECS
      tg3: Move producer ring struct to tg3_napi
      tg3: Use skb_is_gso_v6()
      tg3: Dynamically allocate VPD data memory
      tg3: phy tmp variable roundup
      tg3: Fix potential netpoll crash
      tg3: 5719: Prevent tx data corruption
      tg3: Remove 5724 device ID
      tg3: Cleanup missing VPD partno section
      tg3: Futureproof the loopback test
      tg3: Prepare for larger rx ring sizes
      tg3: Add extend rx ring sizes for 5717 and 5719
      tg3: Update version to 3.114
      tg3: Set real_num_rx_queues for non-multiq devs
      tg3: Add support for selfboot format 1 v6
      tg3: Disable unused transmit rings
      tg3: Add clause 45 register accessor methods
      tg3: Add EEE support
      tg3: Cleanup tg3_alloc_rx_skb()
      tg3: Don't allocate jumbo ring for 5780 class devs
      tg3: Report invalid link from tg3_get_settings()
      tg3: Update version to 3.115

Meelis Roos (1):
      tmspci: fix tr%d in printk

Michael Buesch (1):
      p54spi: Add error message for eeprom failure

Michael Chan (14):
      cnic: Pass cp pointer to BNX2X_HW_CID.
      cnic: Use pfid for internal memory offsets.
      cnic: Fine-tune ring init code.
      bnx2: Update firmware to 6.0.x.
      bnx2: Enable AER on PCIE devices only
      cnic: Add common cnic_request_irq()
      cnic: Convert ctx_flags to bit fields
      cnic: Add cnic_bnx2x_destroy_ramrod()
      cnic: Defer iscsi connection cleanup
      cnic: Add cnic_free_uio()
      cnic: Add cnic_uio_dev struct
      cnic: Decouple uio close from cnic shutdown
      cnic: Add support for 57712 device
      bnx2: Increase max rx ring size from 1K to 2K

Michal Simek (1):
      xilinx_emaclite: netpoll support

Mike Frysinger (1):
      Kconfig: have CCWGROUP depend on CLAW

Mohammed Shafi Shajakhan (2):
      ath9k : Fix for displaying the channel number
      ath9k: Fix documentation in rate control

Namhyung Kim (3):
      net: remove address space warnings in net/socket.c
      net/core: remove address space warnings on verify_iovec()
      net/core: add lock context change annotations in net/core/sock.c

Nathan Holstein (1):
      Bluetooth: fix oops in l2cap_connect_req

Neil Horman (9):
      bonding: Fix bonding drivers improper modification of netpoll structure
      bonding: Fix deadlock in bonding driver resulting from internal locking when using netpoll
      bonding: Fix napi poll for bonding driver
      bonding: Fix netconsole to not deadlock on rmmod
      bonding: Re-enable netpoll over bonding
      netpoll: Remove netpoll blocking from uninit path
      netpoll: Revert napi_poll fix for bonding driver
      Revert c6537d6742985da1fbf12ae26cde6a096fd35b5c
      Revert d88dca79d3852a3623f606f781e013d61486828a

Nick Bowler (1):
      netfilter: install missing ebtables headers for userspace

Nick Kossifidis (2):
      ath5k: rename ath5k_hw_set_associd to _set_bssid
      ath5k: remove own (wrong) IEEE80211_MAX_LEN

Nicolas Kaiser (4):
      netfilter: remove duplicated include
      caif: remove duplicated include
      ehea: simplify conditional
      net/tg3: simplify conditional

Nikitas Angelinas (3):
      drivers/net/bnx2x: use ARRAY_SIZE macro in bnx2x_main.c
      drivers/net/wireless/ath/ath9k: use ARRAY_SIZE macro in ani.c
      net/wireless: use ARRAY_SIZE macro in radiotap.c

Nobuhiro Iwamatsu (2):
      Bluetooth: Add support Bluetooth controller of MacbookPro 6,2
      Bluetooth: Add support Bluetooth controller of MacbookPro 7,1

Ohad Ben-Cohen (11):
      wl1271: sdio: claim host only when doing IO
      wl12xx: make wl12xx.h common to both spi and sdio
      wl1271: propagate set_power's return value
      wl12xx: add platform data passing support
      wl1271: take irq info from private board data
      wl1271: make ref_clock configurable by board
      omap: zoom: add fixed regulator device for wlan
      omap: zoom: add mmc3/wl1271 device support
      wl12xx: fix non-wl12xx build scenarios
      wl1271: sdio: enable runtime PM
      wl1271: sdio: add suspend/resume support

Oliver Hartkopp (2):
      net: simplify flags for tx timestamping
      can-raw: add msg_flags to distinguish local traffic

Ondrej Zary (6):
      introduce cx82310_eth: Conexant CX82310-based ADSL router USB ethernet driver
      cxacru: ignore cx82310_eth devices
      cx82310_eth: check usb_string() return value for error
      cx82310_eth: allow empty URBs
      de2104x: disable media debug messages by default
      de2104x: remove experimental status

Otavio Salvador (1):
      net: r6040: store BIOS default MAC in perm_add

Pablo Neira Ayuso (5):
      netfilter: nf_nat: better error handling of nf_ct_expect_related() in helpers
      netfilter: ctnetlink: missing validation of CTA_EXPECT_ZONE attribute
      netfilter: ctnetlink: allow to specify the expectation flags
      netfilter: ctnetlink: add support for user-space expectation helpers
      netfilter: ctnetlink: add expectation deletion events

Patrick McHardy (2):
      netfilter: add missing xt_log.h file
      Merge branch 'for-patrick' of git://git.kernel.org/.../horms/lvs-test-2.6

Paul Fox (1):
      libertas: Communicate USB transfer errors

Paul Gortmaker (3):
      tipc: Optimize handling excess content on incoming messages
      tipc: clean out all instances of #if 0'd unused code
      3c52x: remove IRQF_SAMPLE_RANDOM from legacy MCA drivers.

Pawel Moll (1):
      stmmac: fix_mac_speed is called during 10/100<->1000 speed changes

Peter Meerwald (1):
      net: Improve comments in include/linux/phy.h

Peter Waskiewicz (1):
      ixgbe: Use affinity_hint when Flow Director is enabled

Philip Rakity (1):
      net: pxa168_etc.c recognize additional contributors

Rafa≈Ç Mi≈Çecki (12):
      b43: N-PHY: add missing phyrxchain setting and fix warning in RX core function
      b43: N-PHY: simplify channel switching
      b43: define B43_SHM_SH_CHAN_40MHZ
      b43: N-PHY: don't duplicate setting channel in shared memory
      b43: N-PHY: grab more info about new channel
      b43: N-PHY: store info about current channel's type
      b43: N-PHY: fix logic in band switching
      b43: N-PHY: prepare for rev3+ channel tables
      b43: N-PHY: replace N-specific radio_chanspec with common code
      b43: N-PHY: fix typo: read table when caching IQ LO calibration (do not write)
      b43: N-PHY: put radio-specific code in separated file
      b43: N-PHY: put 2056-radio's specific code in separated file

Rajesh Borundia (12):
      qlcnic: fix for setting function modes
      qlcnic: configure port on eswitch
      qlcnic: configure offload setting on eswitch
      qlcnic: eswitch config fixes
      qlcnic: add api version in reg dump
      qlcnic: fix mac addr read
      qlcnic: fix for setting default eswitch config
      qlcnic: fix mac anti spoof policy
      qlcnic: fix panic while using eth_hdr
      qlcnic: fix mac override capability
      qlcnic: fix promiscous mode for VF
      netxen: fix race in tx stop queue

Rajkumar Manoharan (12):
      ath9k_htc: Enable ANI in associated state only
      ath9k_htc: Enable fastcc for HTC devices.
      ath9k_hw: Restore ANI registers to default during partial reset for AR9271
      ath9k_hw: Support fastcc for AR7010
      ath9k_htc: Fix memory leak on WMI event handler
      ath9k_htc: Fix CPU usage issue during scan period
      ath9k_hw: remove warning in ath9k_hw_def_get_num_ant_config
      ath9k_htc: Fix register read through bulk pipe
      ath9k_htc: Fix beacon distribution in IBSS mode
      ath9k_htc: Fix TKIP disconnect failure with HTC drivers
      ath9k_hw: Fix hw reset failure with HTC driver
      ath9k_htc: set probe request rx filter

Randy Dunlap (4):
      pch_gbe: add header files
      infiniband: fix mlx4 kconfig dependency warning
      net: move MII outside of NET_ETHERNET, fix kconfig warning
      netfilter: fix kconfig unmet dependency warning

Rasesh Mody (4):
      bna: Brocade 10Gb Ethernet device driver
      bna: Fixed build break for allyesconfig
      bna: fix interrupt handling
      bna: scope and dead code cleanup

Roel Kluin (1):
      irda: Test index before read in stir421x_patch_device()

Roopa Prabhu (7):
      enic: Add set mac address
      enic: Add support for firmware management device
      enic: Add new firmware devcmds
      enic: Use offsetof macro in vic tlv length calculation
      enic: Clean up: remove enic_dev_stats_clear
      enic: Check if rq/wq buf not NULL before freeing them
      enic: Mark intr_timer in vnic_enet_config as deprecated

R√©mi Denis-Courmont (14):
      Phonet: restore flow control credits when sending fails
      Phonet: correct sendmsg() error code from sock_alloc_send_skb()
      Phonet: do not set POLLOUT in case of send buffer overflow
      Phonet: remove dangling pipe if an endpoint is closed early
      Phonet: resource routing backend
      Phonet: hook resource routing to userspace via ioctl()'s
      Phonet: look up the resource routing table when forwarding
      Phonet: list subscribed resources via proc_fs
      Phonet: resource routing documentation
      Phonet: restore flow control credits when sending fails
      Phonet: add to MAINTAINERS and add myself
      Phonet: advise against enabling the pipe controller
      Phonet: cleanup pipe enable socket option
      Phonet: mark the pipe controller as EXPERIMENTAL

Samuel Ortiz (4):
      irda: Remove BKL instances from af_irda.c
      irda: Remove BKL instances from irnet
      irda: Fix parameter extraction stack overflow
      irda: Fix heap memory corruption in iriap.c

Santiago Leon (20):
      ibmveth: Remove integer divide caused by modulus
      ibmveth: batch rx buffer replacement
      ibmveth: Remove LLTX
      ibmveth: Add tx_copybreak
      ibmveth: Add rx_copybreak
      ibmveth: Add scatter-gather support
      ibmveth: Add optional flush of rx buffer
      ibmveth: Remove duplicate checksum offload setup code
      ibmveth: Enable IPv6 checksum offload
      ibmveth: remove procfs code
      ibmveth: Convert to netdev_alloc_skb
      ibmveth: Remove redundant function prototypes
      ibmveth: Convert driver specific debug to netdev_dbg
      ibmveth: Convert driver specific error functions to netdev_err
      ibmveth: Some formatting fixes
      ibmveth: Coding style fixes
      ibmveth: Return -EINVAL on all ->probe errors
      ibmveth: Convert driver specific assert to BUG_ON
      ibmveth: Remove some unnecessary include files
      ibmveth: Update module information and version

Sascha Hauer (3):
      can: mcp251x: increase rx_errors on overflow, not only rx_over_errors
      can: mcp251x: allow to read two registers in one spi transfer
      can: mcp251x: read-modify-write eflag only when needed

Sathya Perla (1):
      be2net: add multiple RX queue support

Senthil Balasubramanian (3):
      ath9k: fix regression which prevents chip sleep after CAB data
      ath9k: remove unnecessary power save flags.
      ath9k: Introduce a wrapper for power save disable.

Shanyu Zhao (8):
      iwlwifi: do not call ieee80211_frequency_to_channel
      iwlwifi: avoid race condition in channel change
      iwlwifi: cleanup iwl_set_rxon_channel()
      iwlwifi: add iwl_nic_ops structure to iwl_ops
      iwlagn: set CSR register for 6050g2 devices
      iwlwifi: send DC calib config to runtime ucode
      iwlagn: fix default calibration table size
      iwlagn: add temperature offset calib for 6000g2

Simon Horman (20):
      bridge: is PACKET_LOOPBACK unlikely()?
      net: increase the size of priv_flags and add IFF_OVS_DATAPATH
      IPVS: ICMPv6 checksum calculation
      IPVS: convert __ip_vs_sched_lock to a spinlock
      IPVS: convert __ip_vs_securetcp_lock to a spinlock
      ipvs: switch to GFP_KERNEL allocations
      net: fix datapath typo
      netfilter: nf_conntrack_sip: Allow ct_sip_get_header() to be called with a null ct argument
      netfilter: nf_conntrack_sip: Add callid parser
      IPVS: compact ip_vs_sched_persist()
      IPVS: Add struct ip_vs_conn_param
      IPVS: Allow null argument to ip_vs_scheduler_put()
      IPVS: ip_vs_{un,}bind_scheduler NULL arguments
      IPVS: Add struct ip_vs_pe
      IPVS: Add persistence engine data to /proc/net/ip_vs_conn
      IPVS: management of persistence engine modules
      IPVS: Allow configuration of persistence engines
      IPVS: Fallback if persistence engine fails
      IPVS: sip persistence engine
      IPVS: ip_vs_dbg_callid() is only needed for debugging

Sjur Braendeland (4):
      caif: Remove buggy re-definition of pr_debug
      caif: Minor fixes in log prints.
      caif: Fix function NULL pointer check.
      caif: Use default send and receive buffer size in caif_socket.

Somnath Kotur (1):
      be2net: Changes to use only priority codes allowed by f/w

Sony Chacko (8):
      qlcnic: fix link status message
      qlcnic: fix link diag test
      qlcnic: remove unused code
      qlcnic: replace magic numbers with defines
      qlcnic: support anti mac spoofing
      qlcnic: firmware initialization update
      qlcnic: Fix missing error codes
      qlcnic: backout firmware initialization update

Sritej Velaga (5):
      qlcnic: PCI ID addition
      qlcnic: cleanup port mode setting
      qlcnic: set mtu lower limit
      qlcnic: fix board description
      qlcnic: change all P3 references to P3P

Stanislaw Gruszka (29):
      iwlwifi: make scan workqueue functions static
      iwlwifi: fix canceling monitor_recover timer
      iwlwifi: cancel scan when down the device
      iwlwifi: report scan completion when abort fail
      iwlwifi: rework iwl_scan_cancel_timeout
      iwlwifi: rewrite scan completion
      iwlwifi: force scan complete after timeout
      iwlwifi: assure we complete scan in scan_abort and scan_check works
      iwlwifi: do not force complete scan too early
      mac80211: wait for scan work complete before restarting hw
      iwlwifi: cleanup scan initiate check
      iwlwifi: use IWL_DEBUG_SCAN for debug scanning
      iwlwifi: apply settings when finishing scan
      iwlwifi: change WARN_ON to IWL_WARN in iwl_mac_add_interface
      mac80211: perform scan cancel in hw reset work
      mac80211: reduce number of __ieee80211_scan_completed calls
      mac80211: keep lock when calling __ieee80211_scan_completed()
      mac80211: assure we also cancel deferred scan request
      mac80211: do not requeue scan work when not needed
      mac80211: compete scan to cfg80211 if deferred scan fail to start
      Revert "iwlwifi: do not perferm force reset while doing scan"
      r8169: check dma mapping failures
      r8169: init rx ring cleanup
      r8169: replace PCI_DMA_{TO,FROM}DEVICE to DMA_{TO,FROM}_DEVICE
      r8169: use pointer to struct device as local variable
      r8169: do not account fragments as packets
      r8169: changing mtu clean up
      r8169: (re)init phy on resume
      r8169: print errors when dma mapping fail

Stephen Hemminger (6):
      tc: add meta match on receive hash
      bridge: fix locking comment
      ray_cs: make data const
      airo: make strings const
      atlx: make strings const
      netfilter: nf_nat: make find/put static

Stephen Rothwell (3):
      net/sched: need to include net/ip6_checksum.h
      IPVS: include net/ip6_checksum.h for csum_ipv6_magic
      net: include inetdevice.h for rcu_dereference_raw api change

Steve Hodgson (1):
      sfc: Make the dmaq size a run-time setting (rather than compile-time)

Steve deRosier (2):
      mac80211: Fix dangling pointer in ieee80211_xmit
      mac80211: Update mesh constants to approved IEEE ANA values

Sucheta Chakraborty (5):
      qlcnic: turn off lro when rxcsum is disabled.
      qlcnic: rom lock recovery
      qlcnic: fix endianess for lro
      qlcnic: fix vlan TSO on big endian machine
      qlcnic: sparse warning fixes

Teemu Paasikivi (1):
      nl80211: Fix exit from nl80211_set_power_save

Tejun Heo (1):
      net/neighbour: cancel_delayed_work() + flush_scheduled_work() -> cancel_delayed_work_sync()

Thomas Graf (3):
      ipv6: add special mode accept_ra=2 to accept RA while configured as router
      ipv6: add special mode forwarding=2 to send RS while configured as router
      ipv6: Update ip-sysctl.txt documentation for recent changes to accept_ra and forwarding

Thomas Klute (2):
      libertas_tf: if_usb.c: Whitespace cleanup
      libertas_tf: if_usb.c: Some more formatting fixes

Tilman Schmidt (9):
      isdn/gigaset: bas_gigaset locking fix
      isdn/gigaset: fix bas_gigaset AT read error handling
      isdn/gigaset: correct bas_gigaset rx buffer handling
      isdn/gigaset: drop obsolete debug option
      isdn/gigaset: bas_gigaset timer cleanup
      isdn/gigaset: try USB reset for bas_gigaset error recovery
      isdn/gigaset: unclog bas_gigaset AT response pipe
      isdn/gigaset: fix bas_gigaset interrupt read error handling
      isdn/gigaset: improve bas_gigaset USB error reporting

Tina Yang (1):
      RDS: Fix corrupted rds_mrs

Tobias Klauser (8):
      am79c961a: Use net_device_stats from struct net_device
      greth: Use return value of register_netdev
      sunhme: Use return value of register_netdev
      ether1: Use net_device_stats from struct net_device
      ether3: Use net_device_stats from struct net_device
      ep93xx_eth: Use net_device_stats from struct net_device
      tehuti: Use net_device_stats from struct net_device
      slip: Use net_device_stats from struct net_device

Tom Herbert (5):
      ipv4: Allow configuring subnets as local addresses
      net: Fix rxq ref counting
      net: fail alloc_netdev_mq if queue count < 1
      net: cleanups in RX queue allocation
      net: allocate tx queues in register_netdevice

Tomas Winkler (1):
      iwlwifi: fix default LQ table in 5.2 band

Tracey Dent (1):
      Drivers: atm: Makefile: replace the use of <module>-objs with <module>-y

Ursula Braun (1):
      qeth: tagging with VLAN-ID 0

Uwe Kleine-K√∂nig (2):
      net/phy: fix many "defined but unused" warnings
      don't let BCM63XX_PHY depend on non-existant symbol

Vasanthakumar Thiagarajan (4):
      ath9k_hw: Add capability flag for Antenna diversity and combining feature
      ath9k_hw: Add functions to get/set antenna diversity configuration
      ath9k: Implement an algorithm for Antenna diversity and combining
      ath9k: Fix tx struck state with paprd

Vasanthy Kolluri (8):
      enic: Remove dead code
      enic: Make local functions static
      enic: Update MAINTAINERS
      enic: Add support for multiple hardware receive queues
      enic: Make firmware cognizant of the user set mac address
      enic: Replace firmware devcmd CMD_ENABLE with CMD_ENABLE_WAIT
      enic: Change min MTU
      enic: Fix log message

Vivek Natarajan (3):
      ath9k_common: Move bt_stomp to common for sharing with ath9k_htc.
      ath9k_htc: Add support for bluetooth coexistence.
      ath9k: Change the default LED pattern.

Vladislav Zolotarov (2):
      bnx2x: Optimized the branching in the bnx2x_rx_int()
      bnx2x: prevent false parity error in MSI-X memory of HC block

Wey-Yi Guy (62):
      iwlwifi: make iwl_hw_detect static to _agn
      iwlagn: log pci revision id
      iwlwifi: make iwl_set_hw_params static to _agn
      iwlwifi: separate thermal throttling function
      iwlwifi: fix thermal throttling related power management operation
      iwlwifi: remove unused define
      iwlwifi: additional comments in iwl_cfg
      iwlwifi: max/min aggregation time limit
      iwlwifi: make aggregation time limit configurable
      iwlagn: adjust starting action for rate scale
      iwlagn: continue perform rate scale when error detected
      iwlwifi: additional parameter in REPLY_RX_PHY_CMD
      iwlwifi: more generic name for rssi calc in iwlagn
      iwlwifi: configurable ampdu factor and density
      iwlwifi: remove unused iwl_send_card_state function
      mac80211: fix warning for un-used parameter
      iwlwifi: update out-of-date comments
      iwlwifi: comments cleanup
      iwlwifi: Relax uCode timeout/error checking for 6000g2b
      iwlwifi: add bt full concurrency support
      iwlagn: wifi/bt coex configuration sequence
      iwlwifi: indicate bt_kill condition when receive tx reply
      iwlwifi: add debugfs to control stuck queue timer
      iwlwifi: add bt_init_traffic_load as configurable parameter
      iwlagn: add bt prio_boost to .cfg
      iwlagn: parsing uart message and take actions
      iwlagn: add additional bt related parameters
      iwlagn: add bt_ch_announce module parameter
      iwlagn: set traffic load based on multiple factors
      iwlagn: generic bt coex functions
      iwlagn: update bt status upon scan complete
      iwlwifi: add bt traffic load debugfs file
      iwlwifi: fix compile error without debugging support
      iwlagn: open/close envlope to force move BT state machine
      iwlwifi: remember the last uCode sysassert error code
      iwlwifi: allow configure protection mode
      iwlwifi: make sure runtime calibration is enabled after association
      iwlwifi: remove code repetition
      iwlagn: add bt_status_read for 5150
      iwlagn: keep track fail tx reason counter
      iwlagn: keep track of failure tx status
      iwlagn: log aggregation tx command status
      iwlagn: keep track of aggregated tx frames failure counter
      iwlagn: adding aggregated frame failure status to debugfs
      iwlagn: correct naming for failure reply tx status
      iwlagn: minor coex API changes
      iwlagn: initialize both tx/rx prio boost parameters
      iwlagn: API v5 for 6050 series device
      iwlwifi: schedule to deprecate software scan support
      iwlagn: reduce redundant parameter definitions
      iwlagn: rename iwl5000_tx_power_dbm_cmd
      iwlwifi: remove uncorrect comments
      iwlagn: rename iwl5000_tx_resp
      iwlagn: define 130 series of WiFi/BT combo devices
      iwlagn: fix module firmware name for 130 series device
      iwlagn: add define for MODULE_FIRMWARE
      iwlagn: no version check for experimental uCode
      iiwlagn: always download priority table
      iwlagn: prio_tbl need to download before calibration
      iwlgn: need longer tx queue stuck timer for coex devices
      iwlagn: 6050 ops should be used;
      iwlwifi: move agn only eeprom functions to separate file

Wolfram Sang (1):
      pcnet_cs: Use proper netdev_*-printouts

Yaniv Rosner (18):
      bnx2x: Fix potential link issue of BCM8073/BCM8727
      bnx2x: Fix potential link issue In BCM8727 based boards
      bnx2x: Reset link before any new link settings
      bnx2x: Change BCM848xx configuration according to IEEE
      bnx2x: Remove unneeded setting of XAUI low power to BCM8727
      bnx2x: Change BCM848xx LED configuration
      bnx2x: Add BCM84823 to the supported PHYs
      bnx2x: Update version to 1.52.53-5
      bnx2x: Unify PHY attributes
      bnx2x: Split PHY functions
      bnx2x: Adjust alignment of split PHY functions
      bnx2x: Adjust flow-control with the new scheme
      bnx2x: Move common function into aggregated function
      bnx2x: Apply logic changes for the new scheme
      bnx2x: Organize PHY functions
      bnx2x: Add dual-media changes
      bnx2x: Change LED scheme for dual-media
      bnx2x: Update bnx2x version to 1.52.53-6

Yevgeny Petrilin (16):
      mlx4_en: Fixed incorrect unmapping on RX flow.
      mlx4_en: Setting actual RX ring size
      mlx4_en: Setting dev->perm_addr field
      mlx4_en: performing CLOSE_PORT at the end of tear-down process
      mlx4_en: Fixed MAX_TX_RINGS definition
      mlx4_en: Reporting link state with KERN_INFO
      mlx4_en: Validate port up prior to transmitting
      mlx4_en: Added self diagnostics test implementation
      mlx4_en: Fixing report in Ethtool get_settings
      mlx4_en: get/set ringsize uses actual ring size
      mlx4_en: reconfiguring mac address.
      mlx4_en: UDP RSS support
      mlx4_en: Moving to work with GRO
      mlx4_en: updated driver version
      mlx4_en: Consider napi_get_frags() failure.
      mlx4_en: Fixed Ethtool statistics report

Yi Zou (2):
      e1000/e1000e/igb/ixgb/ixgbe: set NETIF_F_HIGHDMA for VLAN feature flags
      ixgbe: add a refcnt when turning on/off FCoE offload capability

Yuri Kululin (1):
      Bluetooth: Fix RFCOMM RPN negotiation

Zach Brown (23):
      RDS/IB: rds_ib_cm_handle_connect() forgot to unlock c_cm_lock
      RDS/IB: get the xmit max_sge from the RDS IB device on the connection
      RDS/IB: add refcount tracking to struct rds_ib_device
      RDS: introduce rds_conn_connect_if_down()
      RDS/IB: disconnect when IB devices are removed
      rds: remove unused rds_send_acked_before()
      rds: block ints when acquiring c_lock in rds_conn_message_info()
      rds: fix rds_send_xmit() serialization
      RDS/IB: wait for IB dev freeing work to finish during rmmod
      RDS/IB: destroy connections on rmmod
      RDS/IB: create a work queue for FMR flushing
      RDS: return to a single-threaded krdsd
      RDS/IB: always process recv completions
      RDS: remove __init and __exit annotation
      RDS/IB: track signaled sends
      RDS/IB: print IB event strings as well as their number
      RDS/IB: protect the list of IB devices
      RDS: lock rds_conn_count decrement in rds_conn_destroy()
      RDS: remove old rs_transport comment
      RDS: have sockets get transport module references
      RDS: don't call rds_conn_shutdown() from rds_conn_destroy()
      RDS: cancel connection work structs as we shut down
      RDS/IB: print string constants in more places

amit salecha (2):
      qlcnic: update ethtool stats
      netxen: mask correctable error

andrew hendry (5):
      X.25 remove bkl in listen
      X.25 remove bkl in bind
      X.25 remove bkl in connect
      X.25 remove bkl in getsockname
      X.25 remove bkl in poll

ext Anand Gadiyar (1):
      omap: zoom2/3: fix build caused by wl1271 support

fran√ßois romieu (1):
      via-velocity: forced 1000 Mbps mode support.

stephen hemminger (33):
      ethtool: allow non-netadmin to query settings
      bridge: avoid ethtool on non running interface
      net: make rx_queue sysfs_ops const
      wan: make read-only data const
      pkt_sched: remov unnecessary bh_disable
      sky2: enable GRO by default
      arp: remove unnecessary export of arp_broken_ops
      tcp: tcp_enter_quickack_mode can be static
      gre: protocol table can be static
      qlcnic: remove dead code
      wimax: make functions local
      fib: fib_rules_cleanup can be static
      ipv6: make __ipv6_isatap_ifid static
      dccp: Kill dead code and add static markers.
      tipc: cleanup function namespace
      stmmac: make ethtool functions local
      stmmac: make function tables const
      netxen: make local function static.
      socket: localize functions
      bridge: make br_parse_ip_options static
      sfc: make functions static
      bonding: make bond_resend_igmp_join_requests_delayed static
      vmxnet3: make bit twiddle routines inline
      pch_gbe: make local functions static
      xfrm6: make xfrm6_tunnel_free_spi local
      rtnetlink: remove rtnl_kill_links
      xfrm: make xfrm_bundle_ok local
      bonding: make release_and_destroy static
      cxgb4: function namespace cleanup (v3)
      napi: unexport napi_reuse_skb
      rds: make local functions/variables static
      9p: client code cleanup
      cxgb3: function namespace cleanup

 Documentation/DocBook/80211.tmpl                   |  495 +
 Documentation/DocBook/Makefile                     |    2 +-
 Documentation/DocBook/mac80211.tmpl                |  337 -
 Documentation/feature-removal-schedule.txt         |    9 +
 Documentation/networking/bonding.txt               |    8 +
 Documentation/networking/can.txt                   |   12 +
 Documentation/networking/dccp.txt                  |   29 +-
 Documentation/networking/ip-sysctl.txt             |   27 +-
 Documentation/networking/phonet.txt                |   56 +
 Documentation/networking/timestamping.txt          |   22 +-
 MAINTAINERS                                        |   62 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |   54 +
 arch/s390/include/asm/qdio.h                       |   13 +-
 drivers/atm/Makefile                               |    2 +-
 drivers/atm/firestream.c                           |    4 +-
 drivers/atm/horizon.c                              |    6 +-
 drivers/atm/idt77252.c                             |    6 +-
 drivers/atm/iphase.c                               |    2 +-
 drivers/bluetooth/btmrvl_main.c                    |    4 +-
 drivers/bluetooth/btsdio.c                         |    8 +
 drivers/bluetooth/btusb.c                          |    6 +
 drivers/bluetooth/hci_ldisc.c                      |    2 +-
 drivers/firewire/net.c                             |   13 -
 drivers/ieee1394/eth1394.c                         |   16 -
 drivers/infiniband/hw/mlx4/Kconfig                 |    1 +
 drivers/infiniband/hw/nes/nes_cm.c                 |    4 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |    4 +-
 drivers/isdn/capi/capidrv.c                        |   17 +-
 drivers/isdn/capi/kcapi.c                          |   19 +-
 drivers/isdn/divert/isdn_divert.c                  |    6 +-
 drivers/isdn/gigaset/bas-gigaset.c                 |  400 +-
 drivers/isdn/gigaset/common.c                      |   26 -
 drivers/isdn/gigaset/gigaset.h                     |    3 +-
 drivers/isdn/gigaset/i4l.c                         |    2 -
 drivers/isdn/gigaset/isocdata.c                    |    8 +-
 drivers/isdn/hardware/eicon/debug.c                |    2 +-
 drivers/isdn/hardware/eicon/debuglib.h             |    2 +-
 drivers/isdn/hisax/hfc_sx.c                        |   13 +-
 drivers/isdn/i4l/isdn_tty.c                        |   15 +-
 drivers/isdn/mISDN/dsp_cmx.c                       |    1 +
 drivers/isdn/mISDN/l1oip_core.c                    |    2 +-
 drivers/isdn/mISDN/stack.c                         |    7 -
 drivers/isdn/pcbit/edss1.c                         |    2 +-
 drivers/isdn/pcbit/edss1.h                         |    2 +-
 drivers/net/3c503.c                                |    8 +-
 drivers/net/3c515.c                                |    6 +-
 drivers/net/3c523.c                                |    4 +-
 drivers/net/3c527.c                                |    2 +-
 drivers/net/3c59x.c                                |    2 +-
 drivers/net/8139cp.c                               |    4 +-
 drivers/net/Kconfig                                |   51 +-
 drivers/net/Makefile                               |    3 +
 drivers/net/acenic.c                               |    2 +-
 drivers/net/amd8111e.c                             |   20 +-
 drivers/net/amd8111e.h                             |    1 -
 drivers/net/appletalk/ipddp.c                      |   10 +-
 drivers/net/appletalk/ltpc.c                       |    2 +-
 drivers/net/arm/am79c961a.c                        |   35 +-
 drivers/net/arm/am79c961a.h                        |    1 -
 drivers/net/arm/ep93xx_eth.c                       |   39 +-
 drivers/net/arm/ether1.c                           |   34 +-
 drivers/net/arm/ether1.h                           |    1 -
 drivers/net/arm/ether3.c                           |   33 +-
 drivers/net/arm/ether3.h                           |    1 -
 drivers/net/atarilance.c                           |   24 +-
 drivers/net/atl1c/atl1c.h                          |    1 -
 drivers/net/atl1c/atl1c_hw.c                       |    2 +-
 drivers/net/atl1c/atl1c_main.c                     |   10 +-
 drivers/net/atl1e/atl1e_main.c                     |    6 +-
 drivers/net/atlx/atl1.c                            |   10 +-
 drivers/net/atlx/atl2.c                            |   12 +-
 drivers/net/atp.c                                  |    2 +-
 drivers/net/au1000_eth.c                           |  313 +-
 drivers/net/au1000_eth.h                           |   42 +-
 drivers/net/ax88796.c                              |    1 +
 drivers/net/b44.c                                  |   21 +-
 drivers/net/bcm63xx_enet.c                         |   62 +-
 drivers/net/bcm63xx_enet.h                         |    1 -
 drivers/net/benet/be.h                             |  100 +-
 drivers/net/benet/be_cmds.c                        |  103 +-
 drivers/net/benet/be_cmds.h                        |   65 +-
 drivers/net/benet/be_ethtool.c                     |  177 +-
 drivers/net/benet/be_main.c                        |  644 +-
 drivers/net/bfin_mac.c                             |   10 +-
 drivers/net/bmac.c                                 |    9 +-
 drivers/net/bna/Makefile                           |   11 +
 drivers/net/bna/bfa_cee.c                          |  291 +
 drivers/net/bna/bfa_cee.h                          |   64 +
 drivers/net/bna/bfa_defs.h                         |  243 +
 drivers/net/bna/bfa_defs_cna.h                     |  223 +
 drivers/net/bna/bfa_defs_mfg_comm.h                |  244 +
 drivers/net/bna/bfa_defs_status.h                  |  216 +
 drivers/net/bna/bfa_ioc.c                          | 1732 +++
 drivers/net/bna/bfa_ioc.h                          |  300 +
 drivers/net/bna/bfa_ioc_ct.c                       |  392 +
 drivers/net/bna/bfa_sm.h                           |   88 +
 drivers/net/bna/bfa_wc.h                           |   69 +
 drivers/net/bna/bfi.h                              |  392 +
 drivers/net/bna/bfi_cna.h                          |  199 +
 drivers/net/bna/bfi_ctreg.h                        |  637 +
 drivers/net/bna/bfi_ll.h                           |  438 +
 drivers/net/bna/bna.h                              |  550 +
 drivers/net/bna/bna_ctrl.c                         | 3261 +++++
 drivers/net/bna/bna_hw.h                           | 1490 ++
 drivers/net/bna/bna_txrx.c                         | 4172 ++++++
 drivers/net/bna/bna_types.h                        | 1128 ++
 drivers/net/bna/bnad.c                             | 3264 +++++
 drivers/net/bna/bnad.h                             |  332 +
 drivers/net/bna/bnad_ethtool.c                     | 1277 ++
 drivers/net/bna/cna.h                              |   81 +
 drivers/net/bna/cna_fwimg.c                        |   64 +
 drivers/net/bnx2.c                                 |  253 +-
 drivers/net/bnx2.h                                 |   25 +-
 drivers/net/bnx2x/bnx2x.h                          |  710 +-
 drivers/net/bnx2x/bnx2x_cmn.c                      | 1017 +-
 drivers/net/bnx2x/bnx2x_cmn.h                      |  593 +-
 drivers/net/bnx2x/bnx2x_dump.h                     |   35 +-
 drivers/net/bnx2x/bnx2x_ethtool.c                  |  432 +-
 drivers/net/bnx2x/bnx2x_fw_defs.h                  |  819 +-
 drivers/net/bnx2x/bnx2x_fw_file_hdr.h              |    1 +
 drivers/net/bnx2x/bnx2x_hsi.h                      | 1778 ++-
 drivers/net/bnx2x/bnx2x_init.h                     |   44 +
 drivers/net/bnx2x/bnx2x_init_ops.h                 |  366 +-
 drivers/net/bnx2x/bnx2x_link.c                     | 9097 +++++++------
 drivers/net/bnx2x/bnx2x_link.h                     |  242 +-
 drivers/net/bnx2x/bnx2x_main.c                     | 6098 +++++---
 drivers/net/bnx2x/bnx2x_reg.h                      |  938 ++-
 drivers/net/bnx2x/bnx2x_stats.c                    |  305 +-
 drivers/net/bnx2x/bnx2x_stats.h                    |    8 +-
 drivers/net/bonding/bond_3ad.c                     |  276 +-
 drivers/net/bonding/bond_main.c                    |  181 +-
 drivers/net/bonding/bond_sysfs.c                   |   52 +
 drivers/net/bonding/bonding.h                      |   34 +-
 drivers/net/bsd_comp.c                             |    2 +-
 drivers/net/can/mcp251x.c                          |  103 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |    8 +-
 drivers/net/cassini.c                              |    6 +-
 drivers/net/chelsio/sge.c                          |    6 +-
 drivers/net/chelsio/subr.c                         |    2 -
 drivers/net/chelsio/vsc7326.c                      |    2 +-
 drivers/net/cnic.c                                 |  955 +-
 drivers/net/cnic.h                                 |  118 +-
 drivers/net/cnic_defs.h                            |  456 +-
 drivers/net/cnic_if.h                              |   23 +-
 drivers/net/cpmac.c                                |   39 +-
 drivers/net/cxgb3/adapter.h                        |    3 -
 drivers/net/cxgb3/common.h                         |   18 -
 drivers/net/cxgb3/cxgb3_defs.h                     |    3 -
 drivers/net/cxgb3/cxgb3_main.c                     |   29 +-
 drivers/net/cxgb3/cxgb3_offload.c                  |   11 +-
 drivers/net/cxgb3/mc5.c                            |   38 -
 drivers/net/cxgb3/regs.h                           |    4 +
 drivers/net/cxgb3/sge.c                            |   45 +-
 drivers/net/cxgb3/t3_hw.c                          |  204 +-
 drivers/net/cxgb4/cxgb4.h                          |   17 +-
 drivers/net/cxgb4/cxgb4_main.c                     |  167 +-
 drivers/net/cxgb4/cxgb4_uld.h                      |    6 -
 drivers/net/cxgb4/l2t.c                            |   34 -
 drivers/net/cxgb4/l2t.h                            |    3 -
 drivers/net/cxgb4/sge.c                            |   19 +-
 drivers/net/cxgb4/t4_hw.c                          |  332 -
 drivers/net/cxgb4/t4_hw.h                          |    1 +
 drivers/net/cxgb4/t4fw_api.h                       |    5 +
 drivers/net/cxgb4vf/cxgb4vf_main.c                 |    5 +-
 drivers/net/cxgb4vf/sge.c                          |    3 +-
 drivers/net/cxgb4vf/t4vf_common.h                  |   26 +-
 drivers/net/de620.c                                |    2 +-
 drivers/net/declance.c                             |    2 +-
 drivers/net/defxx.c                                |   66 +-
 drivers/net/dl2k.c                                 |    2 +-
 drivers/net/dm9000.c                               |    2 +-
 drivers/net/dnet.c                                 |   18 +-
 drivers/net/dummy.c                                |   58 +-
 drivers/net/e100.c                                 |    4 +-
 drivers/net/e1000/e1000.h                          |    3 +
 drivers/net/e1000/e1000_main.c                     |  245 +-
 drivers/net/e1000e/82571.c                         |    6 +-
 drivers/net/e1000e/defines.h                       |    2 +
 drivers/net/e1000e/e1000.h                         |   29 +
 drivers/net/e1000e/es2lan.c                        |    1 +
 drivers/net/e1000e/ethtool.c                       |   23 +-
 drivers/net/e1000e/ich8lan.c                       |    2 +-
 drivers/net/e1000e/netdev.c                        |  149 +-
 drivers/net/e1000e/param.c                         |    2 -
 drivers/net/eepro.c                                |    8 +-
 drivers/net/ehea/ehea.h                            |    2 +
 drivers/net/ehea/ehea_main.c                       |   53 +-
 drivers/net/enic/enic.h                            |   27 +-
 drivers/net/enic/enic_main.c                       |  415 +-
 drivers/net/enic/enic_res.c                        |   32 +-
 drivers/net/enic/enic_res.h                        |    2 +-
 drivers/net/enic/vnic_dev.c                        |  133 +-
 drivers/net/enic/vnic_dev.h                        |   19 -
 drivers/net/enic/vnic_devcmd.h                     |   12 +
 drivers/net/enic/vnic_enet.h                       |    2 +-
 drivers/net/enic/vnic_intr.c                       |    5 -
 drivers/net/enic/vnic_resource.h                   |   13 +
 drivers/net/enic/vnic_rq.c                         |    8 +-
 drivers/net/enic/vnic_rq.h                         |    6 +-
 drivers/net/enic/vnic_rss.h                        |    5 -
 drivers/net/enic/vnic_vic.c                        |    7 +-
 drivers/net/enic/vnic_wq.c                         |    8 +-
 drivers/net/enic/vnic_wq.h                         |    4 -
 drivers/net/epic100.c                              |    2 +-
 drivers/net/eth16i.c                               |   16 +-
 drivers/net/ethoc.c                                |    6 -
 drivers/net/fealnx.c                               |    4 +-
 drivers/net/fec_mpc52xx.c                          |    6 -
 drivers/net/forcedeth.c                            |   19 +-
 drivers/net/fs_enet/fs_enet-main.c                 |    3 +-
 drivers/net/fsl_pq_mdio.c                          |    4 +-
 drivers/net/gianfar.c                              |   26 +-
 drivers/net/gianfar_ethtool.c                      |    6 +-
 drivers/net/greth.c                                |    6 +-
 drivers/net/hamachi.c                              |    2 +-
 drivers/net/hamradio/bpqether.c                    |    2 +-
 drivers/net/hamradio/hdlcdrv.c                     |    2 +-
 drivers/net/hamradio/scc.c                         |    3 +-
 drivers/net/hp.c                                   |    8 +-
 drivers/net/hp100.c                                |    6 +-
 drivers/net/hydra.c                                |   13 +-
 drivers/net/ibm_newemac/core.c                     |    6 +-
 drivers/net/ibm_newemac/core.h                     |    6 +-
 drivers/net/ibmlana.c                              |    2 +-
 drivers/net/ibmveth.c                              |  999 +-
 drivers/net/ibmveth.h                              |   59 +-
 drivers/net/igb/e1000_82575.c                      |   18 +-
 drivers/net/igb/e1000_defines.h                    |   31 +
 drivers/net/igb/e1000_hw.h                         |    2 +
 drivers/net/igb/e1000_phy.c                        |  206 +-
 drivers/net/igb/e1000_phy.h                        |    2 +
 drivers/net/igb/igb.h                              |   11 +-
 drivers/net/igb/igb_ethtool.c                      |   52 +-
 drivers/net/igb/igb_main.c                         |  164 +-
 drivers/net/igbvf/ethtool.c                        |    2 +-
 drivers/net/igbvf/netdev.c                         |   11 +-
 drivers/net/ioc3-eth.c                             |    2 +-
 drivers/net/ipg.c                                  |    6 +-
 drivers/net/irda/donauboe.c                        |    4 +-
 drivers/net/irda/irda-usb.c                        |   10 +-
 drivers/net/irda/mcs7780.c                         |    2 +-
 drivers/net/irda/nsc-ircc.c                        |    2 +-
 drivers/net/irda/sir_dev.c                         |    2 +-
 drivers/net/irda/smsc-ircc2.c                      |    2 +-
 drivers/net/irda/stir4200.c                        |    2 +-
 drivers/net/irda/via-ircc.c                        |    3 +-
 drivers/net/irda/via-ircc.h                        |    2 +-
 drivers/net/irda/vlsi_ir.h                         |    2 +-
 drivers/net/iseries_veth.c                         |    2 +-
 drivers/net/ixgb/ixgb_ee.c                         |   32 +-
 drivers/net/ixgb/ixgb_ethtool.c                    |    2 +-
 drivers/net/ixgb/ixgb_hw.c                         |   14 +-
 drivers/net/ixgb/ixgb_main.c                       |   12 +-
 drivers/net/ixgbe/ixgbe.h                          |   39 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |  234 +-
 drivers/net/ixgbe/ixgbe_common.c                   |   50 +-
 drivers/net/ixgbe/ixgbe_common.h                   |    1 -
 drivers/net/ixgbe/ixgbe_dcb.c                      |  219 -
 drivers/net/ixgbe/ixgbe_dcb.h                      |   18 -
 drivers/net/ixgbe/ixgbe_dcb_82598.c                |   67 +-
 drivers/net/ixgbe/ixgbe_dcb_82598.h                |   15 -
 drivers/net/ixgbe/ixgbe_dcb_82599.c                |   69 +-
 drivers/net/ixgbe/ixgbe_dcb_82599.h                |   18 -
 drivers/net/ixgbe/ixgbe_ethtool.c                  |  428 +-
 drivers/net/ixgbe/ixgbe_fcoe.c                     |   13 +-
 drivers/net/ixgbe/ixgbe_fcoe.h                     |    1 +
 drivers/net/ixgbe/ixgbe_main.c                     | 1972 ++--
 drivers/net/ixgbe/ixgbe_mbx.c                      |   21 +-
 drivers/net/ixgbe/ixgbe_mbx.h                      |    5 +-
 drivers/net/ixgbe/ixgbe_sriov.c                    |   19 +-
 drivers/net/ixgbe/ixgbe_sriov.h                    |   10 +-
 drivers/net/ixgbe/ixgbe_type.h                     |    2 +
 drivers/net/ixgbevf/ethtool.c                      |  153 +-
 drivers/net/ixgbevf/ixgbevf.h                      |    1 -
 drivers/net/ixgbevf/ixgbevf_main.c                 |   36 +-
 drivers/net/ixgbevf/mbx.c                          |    2 +-
 drivers/net/ixgbevf/mbx.h                          |    2 -
 drivers/net/ixgbevf/vf.c                           |    2 +-
 drivers/net/ixgbevf/vf.h                           |    2 -
 drivers/net/jme.c                                  |  167 +-
 drivers/net/jme.h                                  |    6 +-
 drivers/net/ll_temac_main.c                        |    4 +-
 drivers/net/loopback.c                             |   28 +-
 drivers/net/lp486e.c                               |    2 +-
 drivers/net/mac8390.c                              |   48 +-
 drivers/net/macb.c                                 |    2 +-
 drivers/net/macvlan.c                              |    4 +
 drivers/net/macvtap.c                              |   99 +-
 drivers/net/meth.c                                 |    2 +-
 drivers/net/mlx4/Makefile                          |    2 +-
 drivers/net/mlx4/alloc.c                           |   17 +-
 drivers/net/mlx4/en_ethtool.c                      |  173 +-
 drivers/net/mlx4/en_main.c                         |   24 +-
 drivers/net/mlx4/en_netdev.c                       |   31 +-
 drivers/net/mlx4/en_port.c                         |   32 +
 drivers/net/mlx4/en_port.h                         |   14 +
 drivers/net/mlx4/en_rx.c                           |  104 +-
 drivers/net/mlx4/en_selftest.c                     |  179 +
 drivers/net/mlx4/en_tx.c                           |   24 +-
 drivers/net/mlx4/eq.c                              |   44 +
 drivers/net/mlx4/fw.c                              |   15 +
 drivers/net/mlx4/fw.h                              |    6 +
 drivers/net/mlx4/main.c                            |    6 +
 drivers/net/mlx4/mlx4_en.h                         |   39 +-
 drivers/net/mlx4/profile.c                         |    2 +-
 drivers/net/mv643xx_eth.c                          |    3 +-
 drivers/net/myri10ge/myri10ge.c                    |   49 +-
 drivers/net/myri_sbus.c                            |    2 +-
 drivers/net/natsemi.c                              |    2 +-
 drivers/net/netconsole.c                           |    9 +-
 drivers/net/netxen/netxen_nic.h                    |   23 +-
 drivers/net/netxen/netxen_nic_hw.c                 |   43 +-
 drivers/net/netxen/netxen_nic_init.c               |   14 +-
 drivers/net/netxen/netxen_nic_main.c               |   49 +-
 drivers/net/niu.c                                  |  133 +-
 drivers/net/ns83820.c                              |   55 +-
 drivers/net/pasemi_mac.c                           |    2 +-
 drivers/net/pasemi_mac_ethtool.c                   |   16 -
 drivers/net/pch_gbe/Makefile                       |    4 +
 drivers/net/pch_gbe/pch_gbe.h                      |  659 +
 drivers/net/pch_gbe/pch_gbe_api.c                  |  245 +
 drivers/net/pch_gbe/pch_gbe_api.h                  |   36 +
 drivers/net/pch_gbe/pch_gbe_ethtool.c              |  585 +
 drivers/net/pch_gbe/pch_gbe_main.c                 | 2477 ++++
 drivers/net/pch_gbe/pch_gbe_param.c                |  499 +
 drivers/net/pch_gbe/pch_gbe_phy.c                  |  274 +
 drivers/net/pch_gbe/pch_gbe_phy.h                  |   37 +
 drivers/net/pci-skeleton.c                         |    2 +-
 drivers/net/pcmcia/3c574_cs.c                      |   88 +-
 drivers/net/pcmcia/3c589_cs.c                      |   17 +-
 drivers/net/pcmcia/axnet_cs.c                      |  187 +-
 drivers/net/pcmcia/com20020_cs.c                   |   32 +-
 drivers/net/pcmcia/fmvj18x_cs.c                    |   60 +-
 drivers/net/pcmcia/ibmtr_cs.c                      |   26 +-
 drivers/net/pcmcia/nmclan_cs.c                     |   56 +-
 drivers/net/pcmcia/pcnet_cs.c                      |  106 +-
 drivers/net/pcmcia/smc91c92_cs.c                   |  105 +-
 drivers/net/pcmcia/xirc2ps_cs.c                    |  104 +-
 drivers/net/pcnet32.c                              |    4 +-
 drivers/net/phy/Kconfig                            |    1 -
 drivers/net/phy/bcm63xx.c                          |    2 +-
 drivers/net/phy/broadcom.c                         |    2 +-
 drivers/net/phy/cicada.c                           |    2 +-
 drivers/net/phy/davicom.c                          |    2 +-
 drivers/net/phy/et1011c.c                          |    2 +-
 drivers/net/phy/icplus.c                           |    2 +-
 drivers/net/phy/lxt.c                              |    2 +-
 drivers/net/phy/marvell.c                          |   33 +-
 drivers/net/phy/micrel.c                           |    2 +-
 drivers/net/phy/national.c                         |    2 +-
 drivers/net/phy/qsemi.c                            |    2 +-
 drivers/net/phy/realtek.c                          |    2 +-
 drivers/net/phy/smsc.c                             |    2 +-
 drivers/net/phy/ste10Xp.c                          |    2 +-
 drivers/net/phy/vitesse.c                          |    2 +-
 drivers/net/plip.c                                 |    9 +-
 drivers/net/ppp_generic.c                          |   46 +-
 drivers/net/pppoe.c                                |    2 +-
 drivers/net/pppox.c                                |    4 +-
 drivers/net/pptp.c                                 |  726 +
 drivers/net/ps3_gelic_net.c                        |    4 +-
 drivers/net/ps3_gelic_wireless.c                   |    6 +-
 drivers/net/pxa168_eth.c                           |    4 +-
 drivers/net/qla3xxx.c                              |    4 +-
 drivers/net/qlcnic/qlcnic.h                        |  179 +-
 drivers/net/qlcnic/qlcnic_ctx.c                    |  411 +-
 drivers/net/qlcnic/qlcnic_ethtool.c                |  226 +-
 drivers/net/qlcnic/qlcnic_hdr.h                    |   47 +-
 drivers/net/qlcnic/qlcnic_hw.c                     |  131 +-
 drivers/net/qlcnic/qlcnic_init.c                   |  332 +-
 drivers/net/qlcnic/qlcnic_main.c                   | 1310 ++-
 drivers/net/qlge/qlge_main.c                       |   36 +-
 drivers/net/r6040.c                                |   92 +-
 drivers/net/r8169.c                                |  400 +-
 drivers/net/rrunner.c                              |    2 +-
 drivers/net/s2io.c                                 |   39 +-
 drivers/net/s2io.h                                 |    9 -
 drivers/net/sb1250-mac.c                           |    2 +-
 drivers/net/sc92031.c                              |   11 -
 drivers/net/sfc/Makefile                           |    7 +-
 drivers/net/sfc/efx.c                              |  353 +-
 drivers/net/sfc/efx.h                              |   46 +-
 drivers/net/sfc/ethtool.c                          |  181 +-
 drivers/net/sfc/falcon.c                           |  136 +-
 drivers/net/sfc/falcon_boards.c                    |  203 +-
 drivers/net/sfc/falcon_gmac.c                      |  230 -
 drivers/net/sfc/falcon_xmac.c                      |    2 +-
 drivers/net/sfc/filter.c                           |  454 +
 drivers/net/sfc/filter.h                           |  189 +
 drivers/net/sfc/mac.h                              |    2 -
 drivers/net/sfc/mcdi.c                             |    4 +-
 drivers/net/sfc/mcdi.h                             |    2 -
 drivers/net/sfc/mcdi_phy.c                         |    3 +-
 drivers/net/sfc/mdio_10g.c                         |   30 +-
 drivers/net/sfc/net_driver.h                       |  117 +-
 drivers/net/sfc/nic.c                              |  199 +-
 drivers/net/sfc/phy.h                              |   18 +-
 drivers/net/sfc/regs.h                             |   14 +
 drivers/net/sfc/rx.c                               |   73 +-
 drivers/net/sfc/selftest.c                         |   17 +-
 drivers/net/sfc/siena.c                            |    6 +-
 drivers/net/sfc/tenxpress.c                        |  424 +-
 drivers/net/sfc/tx.c                               |   78 +-
 drivers/net/sfc/txc43128_phy.c                     |  560 +
 drivers/net/sfc/workarounds.h                      |    9 +-
 drivers/net/sh_eth.c                               |    4 +-
 drivers/net/sis900.c                               |    8 +-
 drivers/net/skfp/cfm.c                             |   10 +-
 drivers/net/skfp/drvfbi.c                          |   16 +-
 drivers/net/skfp/ess.c                             |   46 +-
 drivers/net/skfp/fplustm.c                         |   24 +-
 drivers/net/skfp/hwmtm.c                           |   30 +-
 drivers/net/skfp/hwt.c                             |    4 +-
 drivers/net/skfp/pcmplc.c                          |   22 +-
 drivers/net/skfp/pmf.c                             |   62 +-
 drivers/net/skfp/queue.c                           |    2 +-
 drivers/net/skfp/skfddi.c                          |  116 +-
 drivers/net/skfp/smt.c                             |   78 +-
 drivers/net/skfp/smtdef.c                          |    4 +-
 drivers/net/skfp/smtinit.c                         |    2 +-
 drivers/net/skfp/srf.c                             |    2 +-
 drivers/net/skge.c                                 |    5 +-
 drivers/net/sky2.c                                 |    5 +-
 drivers/net/slip.c                                 |   93 +-
 drivers/net/slip.h                                 |    9 -
 drivers/net/smsc911x.c                             |    2 +-
 drivers/net/spider_net.c                           |    4 +-
 drivers/net/starfire.c                             |   10 +-
 drivers/net/stmmac/Kconfig                         |    5 +-
 drivers/net/stmmac/common.h                        |   61 +-
 drivers/net/stmmac/dwmac100.h                      |    2 +-
 drivers/net/stmmac/dwmac1000.h                     |    4 +-
 drivers/net/stmmac/dwmac1000_core.c                |   36 +-
 drivers/net/stmmac/dwmac1000_dma.c                 |   20 +-
 drivers/net/stmmac/dwmac100_core.c                 |   31 +-
 drivers/net/stmmac/dwmac100_dma.c                  |   20 +-
 drivers/net/stmmac/dwmac_dma.h                     |   16 +-
 drivers/net/stmmac/dwmac_lib.c                     |   22 +-
 drivers/net/stmmac/enh_desc.c                      |    6 +-
 drivers/net/stmmac/norm_desc.c                     |   21 +-
 drivers/net/stmmac/stmmac.h                        |   13 +-
 drivers/net/stmmac/stmmac_ethtool.c                |   63 +-
 drivers/net/stmmac/stmmac_main.c                   |  216 +-
 drivers/net/stmmac/stmmac_mdio.c                   |   26 +-
 drivers/net/sun3lance.c                            |    4 +-
 drivers/net/sunbmac.c                              |    2 +-
 drivers/net/sundance.c                             |  275 +-
 drivers/net/sungem.c                               |  211 +-
 drivers/net/sungem_phy.c                           |    5 +-
 drivers/net/sunhme.c                               |   10 +-
 drivers/net/sunlance.c                             |    2 +-
 drivers/net/sunqe.c                                |    2 +-
 drivers/net/sunvnet.c                              |   50 +-
 drivers/net/tc35815.c                              |    2 +-
 drivers/net/tehuti.c                               |   34 +-
 drivers/net/tehuti.h                               |    1 -
 drivers/net/tg3.c                                  |  734 +-
 drivers/net/tg3.h                                  |   73 +-
 drivers/net/tlan.c                                 |   10 +-
 drivers/net/tlan.h                                 |    8 +-
 drivers/net/tokenring/proteon.c                    |    2 +-
 drivers/net/tokenring/smctr.c                      |  500 +-
 drivers/net/tokenring/tms380tr.c                   |   64 +-
 drivers/net/tokenring/tmspci.c                     |   10 +-
 drivers/net/tsi108_eth.c                           |    2 +-
 drivers/net/tulip/Kconfig                          |    4 +-
 drivers/net/tulip/de2104x.c                        |    3 +-
 drivers/net/tulip/de4x5.c                          |   57 +-
 drivers/net/tulip/dmfe.c                           |    2 +-
 drivers/net/tulip/interrupt.c                      |   77 +-
 drivers/net/tulip/tulip.h                          |    3 +-
 drivers/net/tulip/tulip_core.c                     |   10 +-
 drivers/net/tulip/uli526x.c                        |    4 +-
 drivers/net/tulip/winbond-840.c                    |    2 +-
 drivers/net/tulip/xircom_cb.c                      |   15 -
 drivers/net/typhoon.c                              |   50 +-
 drivers/net/usb/Kconfig                            |    8 +
 drivers/net/usb/Makefile                           |    1 +
 drivers/net/usb/cx82310_eth.c                      |  346 +
 drivers/net/usb/hso.c                              |    9 -
 drivers/net/usb/kaweth.c                           |    9 -
 drivers/net/usb/sierra_net.c                       |    4 +-
 drivers/net/usb/smsc95xx.c                         |    4 +-
 drivers/net/veth.c                                 |    2 +-
 drivers/net/via-velocity.c                         |   86 +-
 drivers/net/via-velocity.h                         |   16 +-
 drivers/net/virtio_net.c                           |   14 -
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   23 +-
 drivers/net/vmxnet3/vmxnet3_int.h                  |   17 +-
 drivers/net/vxge/vxge-main.c                       |   38 +-
 drivers/net/vxge/vxge-main.h                       |    1 -
 drivers/net/wan/c101.c                             |    2 +-
 drivers/net/wan/cycx_drv.c                         |   14 +-
 drivers/net/wan/cycx_main.c                        |    6 +-
 drivers/net/wan/dlci.c                             |   42 +-
 drivers/net/wan/hdlc_cisco.c                       |    4 +-
 drivers/net/wan/lapbether.c                        |    2 +-
 drivers/net/wan/lmc/lmc_main.c                     |    6 +-
 drivers/net/wan/n2.c                               |    6 +-
 drivers/net/wan/pc300_drv.c                        |   20 +-
 drivers/net/wan/pc300_tty.c                        |    2 +-
 drivers/net/wan/pci200syn.c                        |    2 +-
 drivers/net/wan/sdla.c                             |  108 +-
 drivers/net/wan/x25_asy.c                          |    2 +-
 drivers/net/wan/z85230.c                           |    4 +-
 drivers/net/wd.c                                   |    8 +-
 drivers/net/wimax/i2400m/control.c                 |   18 +-
 drivers/net/wimax/i2400m/driver.c                  |    2 +-
 drivers/net/wimax/i2400m/i2400m-sdio.h             |    1 -
 drivers/net/wimax/i2400m/i2400m.h                  |    9 -
 drivers/net/wimax/i2400m/rx.c                      |    2 +-
 drivers/net/wimax/i2400m/sdio-rx.c                 |    2 +-
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    2 +
 drivers/net/wireless/airo.c                        |   24 +-
 drivers/net/wireless/at76c50x-usb.c                |   10 +-
 drivers/net/wireless/ath/Kconfig                   |    1 +
 drivers/net/wireless/ath/Makefile                  |    4 +-
 drivers/net/wireless/ath/ar9170/main.c             |   31 +-
 drivers/net/wireless/ath/ar9170/usb.c              |    2 -
 drivers/net/wireless/ath/ath.h                     |   56 +-
 drivers/net/wireless/ath/ath5k/ani.c               |   47 +-
 drivers/net/wireless/ath/ath5k/ani.h               |    5 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |   31 +-
 drivers/net/wireless/ath/ath5k/attach.c            |   23 +-
 drivers/net/wireless/ath/ath5k/base.c              | 3621 +++---
 drivers/net/wireless/ath/ath5k/base.h              |   33 +-
 drivers/net/wireless/ath/ath5k/debug.c             |  121 +-
 drivers/net/wireless/ath/ath5k/debug.h             |   15 +-
 drivers/net/wireless/ath/ath5k/dma.c               |    8 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |    4 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |  297 +-
 drivers/net/wireless/ath/ath5k/phy.c               |   26 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |   99 +-
 drivers/net/wireless/ath/ath5k/reg.h               |   73 +-
 drivers/net/wireless/ath/ath5k/reset.c             |   34 +-
 drivers/net/wireless/ath/ath5k/rfbuffer.h          |    4 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |    8 +
 drivers/net/wireless/ath/ath9k/Makefile            |    5 +-
 drivers/net/wireless/ath/ath9k/ani.c               |  655 +-
 drivers/net/wireless/ath/ath9k/ani.h               |   13 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   50 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |   89 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |   55 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |   36 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |    2 +
 .../net/wireless/ath/ath9k/ar9003_2p0_initvals.h   | 1784 ---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |   37 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  164 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    5 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   20 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   86 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   28 +-
 drivers/net/wireless/ath/ath9k/btcoex.c            |    7 +
 drivers/net/wireless/ath/ath9k/calib.c             |  152 +-
 drivers/net/wireless/ath/ath9k/calib.h             |   11 +-
 drivers/net/wireless/ath/ath9k/common.c            |  290 +-
 drivers/net/wireless/ath/ath9k/common.h            |   16 +-
 drivers/net/wireless/ath/ath9k/debug.c             |  170 +-
 drivers/net/wireless/ath/ath9k/debug.h             |   33 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |    7 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |   28 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |    8 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |   22 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |   40 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   35 +-
 drivers/net/wireless/ath/ath9k/htc.h               |   42 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |    9 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c      |  134 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   74 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   51 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    6 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    4 +-
 drivers/net/wireless/ath/ath9k/htc_hst.h           |    2 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |   22 -
 drivers/net/wireless/ath/ath9k/hw.c                |  418 +-
 drivers/net/wireless/ath/ath9k/hw.h                |  116 +-
 drivers/net/wireless/ath/ath9k/init.c              |   76 +-
 drivers/net/wireless/ath/ath9k/mac.c               |   13 +-
 drivers/net/wireless/ath/ath9k/mac.h               |   21 -
 drivers/net/wireless/ath/ath9k/main.c              |  310 +-
 drivers/net/wireless/ath/ath9k/phy.h               |    3 -
 drivers/net/wireless/ath/ath9k/rc.c                |  200 +-
 drivers/net/wireless/ath/ath9k/rc.h                |   37 +-
 drivers/net/wireless/ath/ath9k/recv.c              |  602 +-
 drivers/net/wireless/ath/ath9k/reg.h               |   48 +-
 drivers/net/wireless/ath/ath9k/virtual.c           |   63 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |   74 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |    7 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  184 +-
 drivers/net/wireless/ath/carl9170/Kconfig          |   41 +
 drivers/net/wireless/ath/carl9170/Makefile         |    4 +
 drivers/net/wireless/ath/carl9170/carl9170.h       |  628 +
 drivers/net/wireless/ath/carl9170/cmd.c            |  188 +
 drivers/net/wireless/ath/carl9170/cmd.h            |  168 +
 drivers/net/wireless/ath/carl9170/debug.c          |  902 ++
 drivers/net/wireless/ath/carl9170/debug.h          |  134 +
 drivers/net/wireless/ath/carl9170/eeprom.h         |  216 +
 drivers/net/wireless/ath/carl9170/fw.c             |  402 +
 drivers/net/wireless/ath/carl9170/fwcmd.h          |  284 +
 drivers/net/wireless/ath/carl9170/fwdesc.h         |  241 +
 drivers/net/wireless/ath/carl9170/hw.h             |  739 +
 drivers/net/wireless/ath/carl9170/led.c            |  190 +
 drivers/net/wireless/ath/carl9170/mac.c            |  604 +
 drivers/net/wireless/ath/carl9170/main.c           | 1891 +++
 drivers/net/wireless/ath/carl9170/phy.c            | 1810 +++
 drivers/net/wireless/ath/carl9170/phy.h            |  564 +
 drivers/net/wireless/ath/carl9170/rx.c             |  938 ++
 drivers/net/wireless/ath/carl9170/tx.c             | 1335 ++
 drivers/net/wireless/ath/carl9170/usb.c            | 1136 ++
 drivers/net/wireless/ath/carl9170/version.h        |    7 +
 drivers/net/wireless/ath/carl9170/wlan.h           |  420 +
 drivers/net/wireless/ath/debug.c                   |   29 +
 drivers/net/wireless/ath/debug.h                   |   12 +
 drivers/net/wireless/ath/hw.c                      |   59 +
 drivers/net/wireless/ath/key.c                     |  568 +
 drivers/net/wireless/ath/reg.h                     |   34 +
 drivers/net/wireless/b43/Makefile                  |    2 +
 drivers/net/wireless/b43/b43.h                     |    3 +-
 drivers/net/wireless/b43/main.c                    |   30 +-
 drivers/net/wireless/b43/phy_common.c              |    6 +-
 drivers/net/wireless/b43/phy_common.h              |    5 +-
 drivers/net/wireless/b43/phy_n.c                   |  211 +-
 drivers/net/wireless/b43/phy_n.h                   |  218 +-
 drivers/net/wireless/b43/radio_2055.c              | 1332 ++
 drivers/net/wireless/b43/radio_2055.h              |  254 +
 drivers/net/wireless/b43/radio_2056.c              |   43 +
 drivers/net/wireless/b43/radio_2056.h              |   42 +
 drivers/net/wireless/b43/tables_nphy.c             | 1311 +--
 drivers/net/wireless/b43/tables_nphy.h             |   59 +-
 drivers/net/wireless/b43legacy/main.c              |    5 +
 drivers/net/wireless/hostap/hostap_ioctl.c         |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |   10 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |   20 +-
 drivers/net/wireless/iwlwifi/Kconfig               |   10 +
 drivers/net/wireless/iwlwifi/Makefile              |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c            |  119 +-
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h         |    3 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c         |    7 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c            |  191 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h            |   11 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c            |  134 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |  245 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |  754 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c       |   58 +-
 .../iwlwifi/{iwl-calib.h => iwl-agn-calib.h}       |    4 +
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c     |  515 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h     |    7 +
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c      |  454 +
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c        |  157 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         | 1121 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |  404 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |   21 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c          |   35 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c         |  716 +
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c          |  699 +
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h          |  129 +
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |  208 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c       |  118 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |  890 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h             |   96 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |  585 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            | 1451 +--
 drivers/net/wireless/iwlwifi/iwl-core.h            |  261 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |  209 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |  257 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |  393 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |    8 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c            |   13 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h         |    5 -
 drivers/net/wireless/iwlwifi/iwl-led.c             |    6 +-
 drivers/net/wireless/iwlwifi/iwl-power.c           |  642 +-
 drivers/net/wireless/iwlwifi/iwl-power.h           |   93 -
 drivers/net/wireless/iwlwifi/iwl-prph.h            |    9 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c              |   10 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |  441 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |  759 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h             |   69 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c              |   81 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        |  434 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |    7 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |    7 +-
 drivers/net/wireless/libertas/cfg.c                |   72 +-
 drivers/net/wireless/libertas/decl.h               |   13 +
 drivers/net/wireless/libertas/if_cs.c              |  130 +-
 drivers/net/wireless/libertas/if_sdio.c            |  161 +-
 drivers/net/wireless/libertas/if_sdio.h            |    4 -
 drivers/net/wireless/libertas/if_spi.c             |  150 +-
 drivers/net/wireless/libertas/if_spi.h             |    5 -
 drivers/net/wireless/libertas/if_usb.c             |   64 +-
 drivers/net/wireless/libertas/if_usb.h             |    1 +
 drivers/net/wireless/libertas/main.c               |  105 +
 drivers/net/wireless/libertas/mesh.c               |    2 +-
 drivers/net/wireless/libertas_tf/if_usb.c          |   57 +-
 drivers/net/wireless/mac80211_hwsim.c              |   31 +-
 drivers/net/wireless/orinoco/hw.c                  |    9 +-
 drivers/net/wireless/orinoco/wext.c                |   11 +-
 drivers/net/wireless/p54/Kconfig                   |   18 +
 drivers/net/wireless/p54/eeprom.c                  |   25 +-
 drivers/net/wireless/p54/fwio.c                    |    6 +-
 drivers/net/wireless/p54/main.c                    |    9 +-
 drivers/net/wireless/p54/p54spi.c                  |    9 +-
 drivers/net/wireless/p54/p54spi_eeprom.h           |    2 +-
 drivers/net/wireless/p54/p54usb.c                  |   15 +-
 drivers/net/wireless/p54/txrx.c                    |   25 +-
 drivers/net/wireless/prism54/isl_ioctl.c           |    2 +-
 drivers/net/wireless/ray_cs.c                      |   44 +-
 drivers/net/wireless/rndis_wlan.c                  |   12 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |  149 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |  156 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |   78 +-
 drivers/net/wireless/rt2x00/rt2800.h               |  109 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  625 +-
 drivers/net/wireless/rt2x00/rt2800lib.h            |   28 +-
 drivers/net/wireless/rt2x00/rt2800pci.c            |  400 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |  159 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |   70 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |   24 +-
 drivers/net/wireless/rt2x00/rt2x00crypto.c         |   17 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c          |   13 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |  194 +-
 drivers/net/wireless/rt2x00/rt2x00firmware.c       |    3 +
 drivers/net/wireless/rt2x00/rt2x00ht.c             |   25 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   14 +-
 drivers/net/wireless/rt2x00/rt2x00link.c           |   24 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |    6 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  138 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |   56 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |  320 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h            |   12 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |  123 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |   96 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c         |   15 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c         |    9 +-
 drivers/net/wireless/wl1251/Kconfig                |   33 +
 drivers/net/wireless/wl1251/Makefile               |    6 +
 .../wireless/{wl12xx/wl1251_acx.c => wl1251/acx.c} |   10 +-
 .../wireless/{wl12xx/wl1251_acx.h => wl1251/acx.h} |   12 +-
 .../{wl12xx/wl1251_boot.c => wl1251/boot.c}        |   16 +-
 .../{wl12xx/wl1251_boot.h => wl1251/boot.h}        |    2 -
 .../wireless/{wl12xx/wl1251_cmd.c => wl1251/cmd.c} |   12 +-
 .../wireless/{wl12xx/wl1251_cmd.h => wl1251/cmd.h} |    8 +-
 .../{wl12xx/wl1251_debugfs.c => wl1251/debugfs.c}  |    8 +-
 .../{wl12xx/wl1251_debugfs.h => wl1251/debugfs.h}  |    2 -
 .../{wl12xx/wl1251_event.c => wl1251/event.c}      |   41 +-
 .../{wl12xx/wl1251_event.h => wl1251/event.h}      |    3 +-
 .../{wl12xx/wl1251_init.c => wl1251/init.c}        |   10 +-
 .../{wl12xx/wl1251_init.h => wl1251/init.h}        |    2 -
 .../wireless/{wl12xx/wl1251_io.c => wl1251/io.c}   |    6 +-
 .../wireless/{wl12xx/wl1251_io.h => wl1251/io.h}   |    0
 .../{wl12xx/wl1251_main.c => wl1251/main.c}        |   75 +-
 .../wireless/{wl12xx/wl1251_ps.c => wl1251/ps.c}   |   10 +-
 .../wireless/{wl12xx/wl1251_ps.h => wl1251/ps.h}   |   10 +-
 .../wireless/{wl12xx/wl1251_reg.h => wl1251/reg.h} |    2 -
 .../wireless/{wl12xx/wl1251_rx.c => wl1251/rx.c}   |   12 +-
 .../wireless/{wl12xx/wl1251_rx.h => wl1251/rx.h}   |    2 -
 .../{wl12xx/wl1251_sdio.c => wl1251/sdio.c}        |    4 +-
 .../wireless/{wl12xx/wl1251_spi.c => wl1251/spi.c} |   10 +-
 .../wireless/{wl12xx/wl1251_spi.h => wl1251/spi.h} |    8 +-
 .../wireless/{wl12xx/wl1251_tx.c => wl1251/tx.c}   |   34 +-
 .../wireless/{wl12xx/wl1251_tx.h => wl1251/tx.h}   |    4 +-
 drivers/net/wireless/{wl12xx => wl1251}/wl1251.h   |    7 +-
 drivers/net/wireless/wl1251/wl12xx_80211.h         |  156 +
 drivers/net/wireless/wl12xx/Kconfig                |   39 +-
 drivers/net/wireless/wl12xx/Makefile               |   12 +-
 drivers/net/wireless/wl12xx/wl1271.h               |   32 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c           |   36 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h           |   31 -
 drivers/net/wireless/wl12xx/wl1271_boot.c          |   67 +-
 drivers/net/wireless/wl12xx/wl1271_boot.h          |    1 -
 drivers/net/wireless/wl12xx/wl1271_cmd.c           |  143 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.h           |   73 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h          |   78 +-
 drivers/net/wireless/wl12xx/wl1271_event.c         |   15 +-
 drivers/net/wireless/wl12xx/wl1271_init.c          |   39 +-
 drivers/net/wireless/wl12xx/wl1271_io.h            |    9 +-
 drivers/net/wireless/wl12xx/wl1271_main.c          |  416 +-
 drivers/net/wireless/wl12xx/wl1271_ps.c            |   20 +-
 drivers/net/wireless/wl12xx/wl1271_ps.h            |    2 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c            |   67 +-
 drivers/net/wireless/wl12xx/wl1271_scan.c          |   83 +-
 drivers/net/wireless/wl12xx/wl1271_scan.h          |    6 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c          |   98 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c           |  151 +-
 drivers/net/wireless/wl12xx/wl1271_testmode.c      |   14 +-
 drivers/net/wireless/wl12xx/wl1271_tx.c            |  109 +-
 drivers/net/wireless/wl12xx/wl1271_tx.h            |   17 -
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |   28 +
 drivers/net/wireless/wl3501_cs.c                   |   11 -
 drivers/net/wireless/zd1211rw/zd_chip.c            |    5 +
 drivers/net/xen-netfront.c                         |   14 +-
 drivers/net/xilinx_emaclite.c                      |   15 +-
 drivers/net/yellowfin.c                            |    2 +-
 drivers/s390/cio/qdio.h                            |   29 +
 drivers/s390/cio/qdio_debug.c                      |   33 +-
 drivers/s390/cio/qdio_main.c                       |  138 +-
 drivers/s390/cio/qdio_setup.c                      |    1 +
 drivers/s390/cio/qdio_thinint.c                    |   66 +-
 drivers/s390/net/Kconfig                           |    2 +-
 drivers/s390/net/ctcm_mpc.c                        |    2 +-
 drivers/s390/net/qeth_core.h                       |   17 +
 drivers/s390/net/qeth_core_main.c                  |   26 +-
 drivers/s390/net/qeth_l2_main.c                    |  175 +-
 drivers/s390/net/qeth_l3_main.c                    |  218 +-
 drivers/s390/scsi/zfcp_qdio.c                      |    6 +-
 drivers/scsi/bnx2i/57xx_iscsi_constants.h          |    2 +
 drivers/scsi/bnx2i/bnx2i.h                         |    2 +
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    3 +-
 drivers/usb/atm/cxacru.c                           |   18 +-
 drivers/uwb/address.c                              |    5 +-
 drivers/uwb/wlp/wss-lc.c                           |    7 +-
 drivers/vhost/net.c                                |    2 +-
 drivers/vhost/vhost.c                              |   51 +-
 drivers/vhost/vhost.h                              |   18 +-
 firmware/Makefile                                  |   14 +-
 firmware/WHENCE                                    |   15 +-
 firmware/bnx2/bnx2-mips-06-5.0.0.j6.fw.ihex        | 5908 --------
 firmware/bnx2/bnx2-mips-06-6.0.15.fw.ihex          | 5815 ++++++++
 firmware/bnx2/bnx2-mips-09-5.0.0.j15.fw.ihex       | 6081 --------
 firmware/bnx2/bnx2-mips-09-6.0.17.fw.ihex          | 6488 ++++++++
 firmware/bnx2/bnx2-rv2p-06-5.0.0.j3.fw.ihex        |  424 -
 firmware/bnx2/bnx2-rv2p-06-6.0.15.fw.ihex          |  366 +
 firmware/bnx2/bnx2-rv2p-09-5.0.0.j10.fw.ihex       |  462 -
 firmware/bnx2/bnx2-rv2p-09-6.0.17.fw.ihex          |  392 +
 firmware/bnx2/bnx2-rv2p-09ax-5.0.0.j10.fw.ihex     |  499 -
 firmware/bnx2/bnx2-rv2p-09ax-6.0.17.fw.ihex        |  425 +
 firmware/bnx2x-e1-5.2.13.0.fw.ihex                 |10191 -------------
 firmware/bnx2x-e1h-5.2.13.0.fw.ihex                |12849 ----------------
 firmware/bnx2x/bnx2x-e1-6.0.34.0.fw.ihex           | 9476 ++++++++++++
 firmware/bnx2x/bnx2x-e1h-6.0.34.0.fw.ihex          |13178 +++++++++++++++++
 firmware/bnx2x/bnx2x-e2-6.0.34.0.fw.ihex           |15442 ++++++++++++++++++++
 include/linux/Kbuild                               |    1 +
 include/linux/atmdev.h                             |    2 +-
 include/linux/can/platform/mcp251x.h               |    4 -
 include/linux/dccp.h                               |    6 +-
 include/linux/etherdevice.h                        |   22 +-
 include/linux/ethtool.h                            |  190 +-
 include/linux/ieee80211.h                          |   71 +-
 include/linux/if.h                                 |    2 +
 include/linux/if_bonding.h                         |    3 +
 include/linux/if_ether.h                           |    2 -
 include/linux/if_macvlan.h                         |    9 +-
 include/linux/if_pppox.h                           |   52 +-
 include/linux/if_vlan.h                            |   31 +-
 include/linux/in.h                                 |   19 +
 include/linux/in6.h                                |    4 +
 include/linux/inetdevice.h                         |   21 +-
 include/linux/ip_vs.h                              |   15 +
 include/linux/ipv6.h                               |    4 +-
 include/linux/mlx4/cmd.h                           |    1 +
 include/linux/mlx4/device.h                        |    7 +
 include/linux/mmc/sdio_ids.h                       |    1 +
 include/linux/mroute.h                             |    1 +
 include/linux/netdevice.h                          |  120 +-
 include/linux/netfilter/nf_conntrack_common.h      |    6 +
 include/linux/netfilter/nf_conntrack_sip.h         |    1 +
 include/linux/netfilter/nfnetlink_conntrack.h      |    1 +
 include/linux/netfilter/x_tables.h                 |    5 +
 include/linux/netfilter/xt_TPROXY.h                |   13 +-
 include/linux/netfilter_arp/arp_tables.h           |   68 +-
 include/linux/netfilter_bridge/Kbuild              |    2 +
 include/linux/netfilter_ipv4/ip_tables.h           |  107 +-
 include/linux/netfilter_ipv6/ip6_tables.h          |  110 +-
 include/linux/netpoll.h                            |    9 +-
 include/linux/nl80211.h                            |  210 +-
 include/linux/pci_ids.h                            |    3 +
 include/linux/phonet.h                             |    5 +
 include/linux/phy.h                                |    4 +-
 include/linux/pkt_cls.h                            |    1 +
 include/linux/rds.h                                |  115 +-
 include/linux/rtnetlink.h                          |   30 +
 include/linux/skbuff.h                             |  117 +-
 include/linux/socket.h                             |    1 -
 include/linux/ssb/ssb_regs.h                       |    1 +
 include/linux/stmmac.h                             |    6 +-
 include/linux/tc_act/Kbuild                        |    1 +
 include/linux/tc_act/tc_csum.h                     |   32 +
 include/linux/tc_ematch/tc_em_meta.h               |    1 +
 include/linux/tcp.h                                |    1 +
 include/linux/tipc.h                               |   30 +-
 include/linux/wireless.h                           |    2 +-
 include/linux/{spi => }/wl12xx.h                   |   23 +-
 include/net/9p/client.h                            |    3 -
 include/net/addrconf.h                             |   65 +-
 include/net/arp.h                                  |    2 -
 include/net/bluetooth/bluetooth.h                  |    2 +
 include/net/bluetooth/hci.h                        |    2 +-
 include/net/bluetooth/hci_core.h                   |    2 +-
 include/net/bluetooth/l2cap.h                      |    2 +-
 include/net/bluetooth/rfcomm.h                     |    5 -
 include/net/cfg80211.h                             |  296 +-
 include/net/dst.h                                  |   33 +-
 include/net/dst_ops.h                              |   37 +-
 include/net/fib_rules.h                            |    3 +-
 include/net/flow.h                                 |    1 +
 include/net/genetlink.h                            |   18 +
 include/net/gre.h                                  |   18 +
 include/net/inet_connection_sock.h                 |    1 +
 include/net/inet_ecn.h                             |    2 +-
 include/net/inet_hashtables.h                      |    2 +-
 include/net/ip.h                                   |    6 +-
 include/net/ip_fib.h                               |   17 +-
 include/net/ip_vs.h                                |  180 +-
 include/net/ipip.h                                 |   12 +-
 include/net/ipv6.h                                 |   35 +-
 include/net/irda/irlan_common.h                    |    1 -
 include/net/irda/irlan_event.h                     |    2 +-
 include/net/irda/irlap.h                           |    2 +-
 include/net/irda/irlmp.h                           |    2 +-
 include/net/irda/irttp.h                           |    2 +-
 include/net/mac80211.h                             |  195 +-
 include/net/neighbour.h                            |   47 +-
 include/net/net_namespace.h                        |   17 +-
 include/net/netfilter/ipv6/nf_defrag_ipv6.h        |    6 +
 include/net/netfilter/nf_conntrack_expect.h        |   12 +-
 include/net/netfilter/nf_nat_protocol.h            |    3 -
 include/net/netfilter/nf_tproxy_core.h             |  192 +-
 include/net/netfilter/xt_log.h                     |   54 +
 include/net/netns/xfrm.h                           |    9 +-
 include/net/phonet/pep.h                           |   26 +
 include/net/phonet/phonet.h                        |    5 +
 include/net/phonet/pn_dev.h                        |    1 +
 include/net/raw.h                                  |    5 +-
 include/net/rtnetlink.h                            |    1 -
 include/net/sch_generic.h                          |    5 +-
 include/net/sctp/sctp.h                            |   60 +-
 include/net/sctp/sm.h                              |   10 +-
 include/net/sctp/structs.h                         |    2 +-
 include/net/sctp/tsnmap.h                          |    2 +-
 include/net/sock.h                                 |   14 +-
 include/net/tc_act/tc_csum.h                       |   15 +
 include/net/tcp.h                                  |   11 +-
 include/net/tipc/tipc.h                            |   71 -
 include/net/tipc/tipc_msg.h                        |   10 +-
 include/net/tipc/tipc_port.h                       |    2 -
 include/net/udp.h                                  |    3 +
 include/net/xfrm.h                                 |    3 -
 net/802/fc.c                                       |    2 +-
 net/802/fddi.c                                     |   12 +-
 net/802/hippi.c                                    |    2 +-
 net/802/tr.c                                       |    2 +-
 net/8021q/vlan.c                                   |   93 +-
 net/8021q/vlan.h                                   |   17 -
 net/8021q/vlan_core.c                              |  121 +-
 net/8021q/vlan_dev.c                               |   10 +-
 net/9p/client.c                                    |   55 +-
 net/9p/trans_fd.c                                  |    2 +-
 net/atm/clip.c                                     |    4 +-
 net/atm/common.c                                   |    2 +-
 net/atm/lec.c                                      |    1 -
 net/ax25/af_ax25.c                                 |    2 +-
 net/ax25/ax25_route.c                              |    4 +-
 net/bluetooth/af_bluetooth.c                       |  114 +-
 net/bluetooth/cmtp/core.c                          |    6 +-
 net/bluetooth/hci_core.c                           |    1 -
 net/bluetooth/hci_sysfs.c                          |   21 +-
 net/bluetooth/hidp/core.c                          |    8 +-
 net/bluetooth/l2cap.c                              |   60 +-
 net/bluetooth/lib.c                                |    4 +-
 net/bluetooth/rfcomm/core.c                        |   43 +-
 net/bluetooth/rfcomm/sock.c                        |  104 +-
 net/bluetooth/rfcomm/tty.c                         |    4 +-
 net/bridge/br_device.c                             |    8 +-
 net/bridge/br_if.c                                 |   29 +-
 net/bridge/br_input.c                              |    4 +-
 net/bridge/br_netfilter.c                          |  134 +-
 net/bridge/netfilter/ebt_vlan.c                    |   25 +-
 net/bridge/netfilter/ebtables.c                    |   15 +-
 net/caif/caif_dev.c                                |   24 +-
 net/caif/caif_socket.c                             |   27 +-
 net/caif/cfcnfg.c                                  |   49 +-
 net/caif/cfctrl.c                                  |   59 +-
 net/caif/cfdbgl.c                                  |    4 +-
 net/caif/cfdgml.c                                  |   11 +-
 net/caif/cffrml.c                                  |   14 +-
 net/caif/cfmuxl.c                                  |   14 +-
 net/caif/cfpkt_skbuff.c                            |   48 +-
 net/caif/cfrfml.c                                  |   12 +-
 net/caif/cfserl.c                                  |    4 +-
 net/caif/cfsrvl.c                                  |   17 +-
 net/caif/cfutill.c                                 |   12 +-
 net/caif/cfveil.c                                  |   11 +-
 net/caif/cfvidl.c                                  |    6 +-
 net/caif/chnl_net.c                                |   47 +-
 net/can/raw.c                                      |   37 +-
 net/core/datagram.c                                |    5 +-
 net/core/dev.c                                     |  598 +-
 net/core/dst.c                                     |   39 +-
 net/core/ethtool.c                                 |   91 +-
 net/core/fib_rules.c                               |   16 +-
 net/core/filter.c                                  |   10 +-
 net/core/flow.c                                    |   82 +-
 net/core/gen_estimator.c                           |    4 +-
 net/core/iovec.c                                   |    6 +-
 net/core/neighbour.c                               |  486 +-
 net/core/net-sysfs.c                               |   39 +-
 net/core/net-sysfs.h                               |    4 +
 net/core/netpoll.c                                 |    6 +-
 net/core/pktgen.c                                  |   12 +-
 net/core/rtnetlink.c                               |   39 +-
 net/core/skbuff.c                                  |  105 +-
 net/core/sock.c                                    |    4 +
 net/core/utils.c                                   |   15 +-
 net/dccp/ccid.h                                    |   52 +-
 net/dccp/ccids/Kconfig                             |   31 -
 net/dccp/ccids/ccid2.c                             |  289 +-
 net/dccp/ccids/ccid2.h                             |   35 +-
 net/dccp/ccids/ccid3.c                             |  256 +-
 net/dccp/ccids/ccid3.h                             |   51 +-
 net/dccp/ccids/lib/loss_interval.c                 |    2 +-
 net/dccp/ccids/lib/packet_history.c                |   39 -
 net/dccp/ccids/lib/packet_history.h                |   22 +-
 net/dccp/ccids/lib/tfrc.h                          |    1 +
 net/dccp/ccids/lib/tfrc_equation.c                 |   14 +
 net/dccp/dccp.h                                    |   46 +-
 net/dccp/feat.c                                    |   10 -
 net/dccp/feat.h                                    |    1 -
 net/dccp/input.c                                   |   20 +-
 net/dccp/ipv4.c                                    |   10 +-
 net/dccp/ipv6.c                                    |   10 +-
 net/dccp/minisocks.c                               |   30 +-
 net/dccp/options.c                                 |   31 +-
 net/dccp/output.c                                  |   20 +-
 net/dccp/proto.c                                   |   50 +-
 net/decnet/dn_neigh.c                              |   13 +-
 net/decnet/dn_nsp_out.c                            |    8 +-
 net/decnet/dn_route.c                              |    3 +-
 net/econet/af_econet.c                             |    6 +-
 net/ethernet/eth.c                                 |    8 +-
 net/ipv4/Kconfig                                   |    8 +-
 net/ipv4/Makefile                                  |    1 +
 net/ipv4/af_inet.c                                 |    8 +-
 net/ipv4/arp.c                                     |  245 +-
 net/ipv4/datagram.c                                |    2 +-
 net/ipv4/devinet.c                                 |   11 +-
 net/ipv4/fib_frontend.c                            |  192 +-
 net/ipv4/fib_hash.c                                |  291 +-
 net/ipv4/fib_lookup.h                              |   11 +-
 net/ipv4/fib_rules.c                               |   13 +-
 net/ipv4/fib_semantics.c                           |  297 +-
 net/ipv4/fib_trie.c                                |   84 +-
 net/ipv4/gre.c                                     |  151 +
 net/ipv4/icmp.c                                    |    4 +-
 net/ipv4/igmp.c                                    |   22 +-
 net/ipv4/inet_diag.c                               |    2 +-
 net/ipv4/inet_hashtables.c                         |   28 +-
 net/ipv4/ip_fragment.c                             |    6 +-
 net/ipv4/ip_gre.c                                  |  237 +-
 net/ipv4/ip_options.c                              |    3 +-
 net/ipv4/ip_output.c                               |   24 +-
 net/ipv4/ipip.c                                    |  212 +-
 net/ipv4/ipmr.c                                    |  428 +-
 net/ipv4/netfilter/Kconfig                         |    4 +-
 net/ipv4/netfilter/arp_tables.c                    |   64 +-
 net/ipv4/netfilter/arpt_mangle.c                   |    2 +-
 net/ipv4/netfilter/ip_tables.c                     |   84 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   31 +-
 net/ipv4/netfilter/ipt_LOG.c                       |  145 +-
 net/ipv4/netfilter/nf_nat_amanda.c                 |    9 +-
 net/ipv4/netfilter/nf_nat_core.c                   |   51 +-
 net/ipv4/netfilter/nf_nat_ftp.c                    |    9 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |   53 +-
 net/ipv4/netfilter/nf_nat_helper.c                 |   76 +-
 net/ipv4/netfilter/nf_nat_irc.c                    |    9 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   17 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |   27 +-
 net/ipv4/protocol.c                                |   31 +-
 net/ipv4/raw.c                                     |    2 +-
 net/ipv4/route.c                                   |  190 +-
 net/ipv4/tcp.c                                     |   11 +-
 net/ipv4/tcp_input.c                               |   55 +-
 net/ipv4/tcp_ipv4.c                                |   12 +-
 net/ipv4/tcp_minisocks.c                           |    2 +-
 net/ipv4/tcp_output.c                              |   31 +-
 net/ipv4/tcp_timer.c                               |   50 +-
 net/ipv4/tcp_westwood.c                            |    2 +-
 net/ipv4/tunnel4.c                                 |   19 +-
 net/ipv4/udp.c                                     |    4 +-
 net/ipv4/xfrm4_policy.c                            |    4 +-
 net/ipv4/xfrm4_tunnel.c                            |    4 +-
 net/ipv6/addrconf.c                                |    8 +-
 net/ipv6/addrlabel.c                               |    5 +-
 net/ipv6/af_inet6.c                                |    9 +-
 net/ipv6/datagram.c                                |   19 +
 net/ipv6/exthdrs_core.c                            |    4 +-
 net/ipv6/fib6_rules.c                              |    3 +-
 net/ipv6/ip6_fib.c                                 |    9 +-
 net/ipv6/ip6_output.c                              |    6 +-
 net/ipv6/ip6_tunnel.c                              |  157 +-
 net/ipv6/ip6mr.c                                   |    1 +
 net/ipv6/ipv6_sockglue.c                           |   23 +
 net/ipv6/ndisc.c                                   |   36 +-
 net/ipv6/netfilter/Kconfig                         |    4 +-
 net/ipv6/netfilter/Makefile                        |    5 +-
 net/ipv6/netfilter/ip6_tables.c                    |   98 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |  157 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |   78 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   16 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |  131 +
 net/ipv6/protocol.c                                |   32 +-
 net/ipv6/raw.c                                     |   12 +-
 net/ipv6/reassembly.c                              |    2 +-
 net/ipv6/route.c                                   |   50 +-
 net/ipv6/sit.c                                     |  165 +-
 net/ipv6/tcp_ipv6.c                                |   14 +-
 net/ipv6/tunnel6.c                                 |   17 +-
 net/ipv6/udp.c                                     |   16 +-
 net/ipv6/xfrm6_policy.c                            |   10 +-
 net/ipv6/xfrm6_tunnel.c                            |    8 +-
 net/irda/af_irda.c                                 |  380 +-
 net/irda/discovery.c                               |    2 +-
 net/irda/ircomm/ircomm_tty.c                       |    4 +-
 net/irda/iriap.c                                   |    3 +-
 net/irda/irlan/irlan_eth.c                         |   32 +-
 net/irda/irlan/irlan_event.c                       |    2 +-
 net/irda/irlmp.c                                   |    2 +-
 net/irda/irlmp_frame.c                             |    2 +-
 net/irda/irnet/irnet.h                             |    2 +
 net/irda/irnet/irnet_irda.c                        |   22 +-
 net/irda/irnet/irnet_ppp.c                         |   69 +-
 net/irda/irnet/irnet_ppp.h                         |    3 +-
 net/irda/parameters.c                              |    4 +-
 net/key/af_key.c                                   |    4 +-
 net/l2tp/l2tp_eth.c                                |    1 -
 net/l2tp/l2tp_ip.c                                 |    4 +-
 net/l2tp/l2tp_ppp.c                                |    2 +-
 net/mac80211/aes_ccm.c                             |    6 +-
 net/mac80211/aes_cmac.c                            |    6 +-
 net/mac80211/agg-rx.c                              |   30 +-
 net/mac80211/agg-tx.c                              |   14 +-
 net/mac80211/cfg.c                                 |  244 +-
 net/mac80211/chan.c                                |    2 +-
 net/mac80211/debugfs.c                             |    7 +-
 net/mac80211/debugfs_key.c                         |   55 +-
 net/mac80211/debugfs_netdev.c                      |    3 +
 net/mac80211/debugfs_sta.c                         |    5 +-
 net/mac80211/driver-ops.h                          |   14 +
 net/mac80211/driver-trace.h                        |   42 +-
 net/mac80211/ht.c                                  |   47 +-
 net/mac80211/ibss.c                                |   77 +-
 net/mac80211/ieee80211_i.h                         |  133 +-
 net/mac80211/iface.c                               |  460 +-
 net/mac80211/key.c                                 |  168 +-
 net/mac80211/key.h                                 |   13 +-
 net/mac80211/main.c                                |  194 +-
 net/mac80211/mesh_plink.c                          |   17 +-
 net/mac80211/mlme.c                                |  173 +-
 net/mac80211/offchannel.c                          |   26 +-
 net/mac80211/pm.c                                  |    2 +-
 net/mac80211/rate.c                                |   11 +-
 net/mac80211/rc80211_minstrel_ht.c                 |    7 +-
 net/mac80211/rc80211_pid_debugfs.c                 |    2 +-
 net/mac80211/rx.c                                  |  819 +-
 net/mac80211/scan.c                                |  179 +-
 net/mac80211/sta_info.c                            |   52 +-
 net/mac80211/sta_info.h                            |   24 +-
 net/mac80211/status.c                              |   14 +-
 net/mac80211/tx.c                                  |   73 +-
 net/mac80211/util.c                                |  102 +-
 net/mac80211/wep.c                                 |   10 +-
 net/mac80211/work.c                                |   39 +-
 net/mac80211/wpa.c                                 |   34 +-
 net/netfilter/core.c                               |    6 +-
 net/netfilter/ipvs/Kconfig                         |   20 +-
 net/netfilter/ipvs/Makefile                        |   10 +-
 net/netfilter/ipvs/ip_vs_app.c                     |    6 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  286 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  819 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |  392 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |  194 +-
 net/netfilter/ipvs/ip_vs_nfct.c                    |  292 +
 net/netfilter/ipvs/ip_vs_pe.c                      |  147 +
 net/netfilter/ipvs/ip_vs_pe_sip.c                  |  169 +
 net/netfilter/ipvs/ip_vs_proto.c                   |    8 +-
 net/netfilter/ipvs/ip_vs_proto_ah_esp.c            |   99 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   27 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   52 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |   51 +-
 net/netfilter/ipvs/ip_vs_sched.c                   |   47 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |   46 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  696 +-
 net/netfilter/nf_conntrack_core.c                  |  131 +-
 net/netfilter/nf_conntrack_expect.c                |   68 +-
 net/netfilter/nf_conntrack_netlink.c               |   77 +-
 net/netfilter/nf_conntrack_sip.c                   |   42 +
 net/netfilter/nf_tproxy_core.c                     |   35 -
 net/netfilter/x_tables.c                           |   12 +-
 net/netfilter/xt_TPROXY.c                          |  366 +-
 net/netfilter/xt_hashlimit.c                       |   15 +-
 net/netfilter/xt_ipvs.c                            |    1 -
 net/netfilter/xt_socket.c                          |  167 +-
 net/netlink/genetlink.c                            |   14 +-
 net/packet/af_packet.c                             |    4 +-
 net/phonet/Kconfig                                 |   12 +
 net/phonet/af_phonet.c                             |   17 +
 net/phonet/datagram.c                              |   13 +
 net/phonet/pep.c                                   |  388 +-
 net/phonet/pn_dev.c                                |    5 +-
 net/phonet/socket.c                                |  289 +-
 net/rds/af_rds.c                                   |   26 +-
 net/rds/bind.c                                     |   82 +-
 net/rds/cong.c                                     |    8 +-
 net/rds/connection.c                               |  159 +-
 net/rds/ib.c                                       |  200 +-
 net/rds/ib.h                                       |  104 +-
 net/rds/ib_cm.c                                    |  184 +-
 net/rds/ib_rdma.c                                  |  318 +-
 net/rds/ib_recv.c                                  |  549 +-
 net/rds/ib_send.c                                  |  682 +-
 net/rds/ib_stats.c                                 |    2 +
 net/rds/ib_sysctl.c                                |   19 +-
 net/rds/info.c                                     |   12 +-
 net/rds/iw.c                                       |    8 +-
 net/rds/iw.h                                       |   15 +-
 net/rds/iw_cm.c                                    |   14 +-
 net/rds/iw_rdma.c                                  |    8 +-
 net/rds/iw_recv.c                                  |   24 +-
 net/rds/iw_send.c                                  |   93 +-
 net/rds/iw_sysctl.c                                |    6 +-
 net/rds/loop.c                                     |   31 +-
 net/rds/message.c                                  |  142 +-
 net/rds/page.c                                     |    8 +-
 net/rds/rdma.c                                     |  339 +-
 net/rds/rdma.h                                     |   85 -
 net/rds/rdma_transport.c                           |   44 +-
 net/rds/rdma_transport.h                           |    4 -
 net/rds/rds.h                                      |  192 +-
 net/rds/recv.c                                     |   12 +-
 net/rds/send.c                                     |  548 +-
 net/rds/stats.c                                    |    6 +-
 net/rds/sysctl.c                                   |    4 +-
 net/rds/tcp.c                                      |   12 +-
 net/rds/tcp.h                                      |    9 +-
 net/rds/tcp_connect.c                              |    2 +-
 net/rds/tcp_listen.c                               |    6 +-
 net/rds/tcp_recv.c                                 |   17 +-
 net/rds/tcp_send.c                                 |   68 +-
 net/rds/threads.c                                  |   69 +-
 net/rds/transport.c                                |   19 +-
 net/rds/xlist.h                                    |   80 +
 net/rfkill/input.c                                 |    2 +-
 net/rose/rose_link.c                               |    4 +-
 net/sched/Kconfig                                  |   10 +
 net/sched/Makefile                                 |    1 +
 net/sched/act_csum.c                               |  595 +
 net/sched/act_ipt.c                                |   14 +-
 net/sched/cls_flow.c                               |   74 +-
 net/sched/em_meta.c                                |    6 +
 net/sched/sch_api.c                                |   44 +-
 net/sched/sch_atm.c                                |    5 +-
 net/sched/sch_cbq.c                                |   12 +-
 net/sched/sch_drr.c                                |    4 +-
 net/sched/sch_dsmark.c                             |    6 +-
 net/sched/sch_fifo.c                               |    3 +-
 net/sched/sch_generic.c                            |   24 +-
 net/sched/sch_hfsc.c                               |    8 +-
 net/sched/sch_htb.c                                |   12 +-
 net/sched/sch_mq.c                                 |    2 +-
 net/sched/sch_multiq.c                             |    3 +-
 net/sched/sch_netem.c                              |    3 +-
 net/sched/sch_prio.c                               |    2 +-
 net/sched/sch_sfq.c                                |   33 +-
 net/sched/sch_teql.c                               |    8 +-
 net/sctp/associola.c                               |    2 +
 net/sctp/chunk.c                                   |    2 +
 net/sctp/inqueue.c                                 |    2 +
 net/sctp/ipv6.c                                    |    4 +-
 net/sctp/objcnt.c                                  |    5 +-
 net/sctp/output.c                                  |    2 +
 net/sctp/outqueue.c                                |   34 +-
 net/sctp/probe.c                                   |    4 +-
 net/sctp/protocol.c                                |   19 +-
 net/sctp/sm_make_chunk.c                           |    2 +
 net/sctp/sm_sideeffect.c                           |   21 +-
 net/sctp/sm_statefuns.c                            |   20 +-
 net/sctp/sm_statetable.c                           |   42 +-
 net/sctp/socket.c                                  |   85 +-
 net/sctp/transport.c                               |    9 +-
 net/socket.c                                       |   37 +-
 net/sunrpc/auth_gss/auth_gss.c                     |    2 +-
 net/sunrpc/auth_gss/gss_generic_token.c            |   44 +-
 net/sunrpc/auth_gss/gss_krb5_seqnum.c              |    2 +-
 net/sunrpc/auth_gss/gss_mech_switch.c              |    2 +-
 net/sunrpc/sched.c                                 |    2 +-
 net/tipc/addr.c                                    |    7 +-
 net/tipc/bcast.c                                   |   51 +-
 net/tipc/bcast.h                                   |    3 -
 net/tipc/bearer.c                                  |   42 +-
 net/tipc/cluster.c                                 |   21 +-
 net/tipc/cluster.h                                 |    2 +-
 net/tipc/config.c                                  |  148 +-
 net/tipc/config.h                                  |    6 -
 net/tipc/core.c                                    |   38 +-
 net/tipc/core.h                                    |    9 +-
 net/tipc/dbg.c                                     |   17 +-
 net/tipc/dbg.h                                     |    3 -
 net/tipc/discover.c                                |   44 +-
 net/tipc/discover.h                                |    5 -
 net/tipc/eth_media.c                               |   48 +-
 net/tipc/link.c                                    |  188 +-
 net/tipc/link.h                                    |   24 +-
 net/tipc/msg.c                                     |    2 +-
 net/tipc/msg.h                                     |    6 +-
 net/tipc/name_distr.c                              |    2 +-
 net/tipc/name_table.c                              |   67 +-
 net/tipc/net.c                                     |   10 +-
 net/tipc/node.c                                    |   73 +-
 net/tipc/node.h                                    |    3 +-
 net/tipc/port.c                                    |  295 +-
 net/tipc/port.h                                    |    4 +-
 net/tipc/ref.c                                     |   17 -
 net/tipc/ref.h                                     |    1 -
 net/tipc/socket.c                                  |   83 +-
 net/tipc/subscr.c                                  |   77 +-
 net/tipc/subscr.h                                  |    2 +
 net/tipc/zone.c                                    |   11 -
 net/tipc/zone.h                                    |    1 -
 net/unix/af_unix.c                                 |   10 +-
 net/wireless/core.c                                |   66 +-
 net/wireless/core.h                                |   34 +-
 net/wireless/ibss.c                                |   21 +-
 net/wireless/mlme.c                                |  225 +-
 net/wireless/nl80211.c                             | 2189 ++--
 net/wireless/nl80211.h                             |   14 +-
 net/wireless/radiotap.c                            |   61 +-
 net/wireless/reg.c                                 |   22 +-
 net/wireless/scan.c                                |   12 +-
 net/wireless/sme.c                                 |   11 +-
 net/wireless/sysfs.c                               |   18 +
 net/wireless/util.c                                |   40 +-
 net/wireless/wext-compat.c                         |   42 +-
 net/wireless/wext-core.c                           |    2 +-
 net/wireless/wext-sme.c                            |    2 +
 net/x25/af_x25.c                                   |   34 +-
 net/xfrm/xfrm_policy.c                             |    7 +-
 1343 files changed, 157285 insertions(+), 84043 deletions(-)
 create mode 100644 Documentation/DocBook/80211.tmpl
 delete mode 100644 Documentation/DocBook/mac80211.tmpl
 create mode 100644 drivers/net/bna/Makefile
 create mode 100644 drivers/net/bna/bfa_cee.c
 create mode 100644 drivers/net/bna/bfa_cee.h
 create mode 100644 drivers/net/bna/bfa_defs.h
 create mode 100644 drivers/net/bna/bfa_defs_cna.h
 create mode 100644 drivers/net/bna/bfa_defs_mfg_comm.h
 create mode 100644 drivers/net/bna/bfa_defs_status.h
 create mode 100644 drivers/net/bna/bfa_ioc.c
 create mode 100644 drivers/net/bna/bfa_ioc.h
 create mode 100644 drivers/net/bna/bfa_ioc_ct.c
 create mode 100644 drivers/net/bna/bfa_sm.h
 create mode 100644 drivers/net/bna/bfa_wc.h
 create mode 100644 drivers/net/bna/bfi.h
 create mode 100644 drivers/net/bna/bfi_cna.h
 create mode 100644 drivers/net/bna/bfi_ctreg.h
 create mode 100644 drivers/net/bna/bfi_ll.h
 create mode 100644 drivers/net/bna/bna.h
 create mode 100644 drivers/net/bna/bna_ctrl.c
 create mode 100644 drivers/net/bna/bna_hw.h
 create mode 100644 drivers/net/bna/bna_txrx.c
 create mode 100644 drivers/net/bna/bna_types.h
 create mode 100644 drivers/net/bna/bnad.c
 create mode 100644 drivers/net/bna/bnad.h
 create mode 100644 drivers/net/bna/bnad_ethtool.c
 create mode 100644 drivers/net/bna/cna.h
 create mode 100644 drivers/net/bna/cna_fwimg.c
 create mode 100644 drivers/net/mlx4/en_selftest.c
 create mode 100644 drivers/net/pch_gbe/Makefile
 create mode 100644 drivers/net/pch_gbe/pch_gbe.h
 create mode 100644 drivers/net/pch_gbe/pch_gbe_api.c
 create mode 100644 drivers/net/pch_gbe/pch_gbe_api.h
 create mode 100644 drivers/net/pch_gbe/pch_gbe_ethtool.c
 create mode 100644 drivers/net/pch_gbe/pch_gbe_main.c
 create mode 100644 drivers/net/pch_gbe/pch_gbe_param.c
 create mode 100644 drivers/net/pch_gbe/pch_gbe_phy.c
 create mode 100644 drivers/net/pch_gbe/pch_gbe_phy.h
 create mode 100644 drivers/net/pptp.c
 delete mode 100644 drivers/net/sfc/falcon_gmac.c
 create mode 100644 drivers/net/sfc/filter.c
 create mode 100644 drivers/net/sfc/filter.h
 create mode 100644 drivers/net/sfc/txc43128_phy.c
 create mode 100644 drivers/net/usb/cx82310_eth.c
 delete mode 100644 drivers/net/wireless/ath/ath9k/ar9003_2p0_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
 create mode 100644 drivers/net/wireless/ath/carl9170/Kconfig
 create mode 100644 drivers/net/wireless/ath/carl9170/Makefile
 create mode 100644 drivers/net/wireless/ath/carl9170/carl9170.h
 create mode 100644 drivers/net/wireless/ath/carl9170/cmd.c
 create mode 100644 drivers/net/wireless/ath/carl9170/cmd.h
 create mode 100644 drivers/net/wireless/ath/carl9170/debug.c
 create mode 100644 drivers/net/wireless/ath/carl9170/debug.h
 create mode 100644 drivers/net/wireless/ath/carl9170/eeprom.h
 create mode 100644 drivers/net/wireless/ath/carl9170/fw.c
 create mode 100644 drivers/net/wireless/ath/carl9170/fwcmd.h
 create mode 100644 drivers/net/wireless/ath/carl9170/fwdesc.h
 create mode 100644 drivers/net/wireless/ath/carl9170/hw.h
 create mode 100644 drivers/net/wireless/ath/carl9170/led.c
 create mode 100644 drivers/net/wireless/ath/carl9170/mac.c
 create mode 100644 drivers/net/wireless/ath/carl9170/main.c
 create mode 100644 drivers/net/wireless/ath/carl9170/phy.c
 create mode 100644 drivers/net/wireless/ath/carl9170/phy.h
 create mode 100644 drivers/net/wireless/ath/carl9170/rx.c
 create mode 100644 drivers/net/wireless/ath/carl9170/tx.c
 create mode 100644 drivers/net/wireless/ath/carl9170/usb.c
 create mode 100644 drivers/net/wireless/ath/carl9170/version.h
 create mode 100644 drivers/net/wireless/ath/carl9170/wlan.h
 create mode 100644 drivers/net/wireless/ath/key.c
 create mode 100644 drivers/net/wireless/b43/radio_2055.c
 create mode 100644 drivers/net/wireless/b43/radio_2055.h
 create mode 100644 drivers/net/wireless/b43/radio_2056.c
 create mode 100644 drivers/net/wireless/b43/radio_2056.h
 rename drivers/net/wireless/iwlwifi/{iwl-calib.h => iwl-agn-calib.h} (95%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-sta.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-tt.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-tt.h
 create mode 100644 drivers/net/wireless/wl1251/Kconfig
 create mode 100644 drivers/net/wireless/wl1251/Makefile
 rename drivers/net/wireless/{wl12xx/wl1251_acx.c => wl1251/acx.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_acx.h => wl1251/acx.h} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_boot.c => wl1251/boot.c} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_boot.h => wl1251/boot.h} (96%)
 rename drivers/net/wireless/{wl12xx/wl1251_cmd.c => wl1251/cmd.c} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_cmd.h => wl1251/cmd.h} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_debugfs.c => wl1251/debugfs.c} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_debugfs.h => wl1251/debugfs.h} (95%)
 rename drivers/net/wireless/{wl12xx/wl1251_event.c => wl1251/event.c} (81%)
 rename drivers/net/wireless/{wl12xx/wl1251_event.h => wl1251/event.h} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_init.c => wl1251/init.c} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_init.h => wl1251/init.h} (97%)
 rename drivers/net/wireless/{wl12xx/wl1251_io.c => wl1251/io.c} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_io.h => wl1251/io.h} (100%)
 rename drivers/net/wireless/{wl12xx/wl1251_main.c => wl1251/main.c} (96%)
 rename drivers/net/wireless/{wl12xx/wl1251_ps.c => wl1251/ps.c} (96%)
 rename drivers/net/wireless/{wl12xx/wl1251_ps.h => wl1251/ps.h} (93%)
 rename drivers/net/wireless/{wl12xx/wl1251_reg.h => wl1251/reg.h} (99%)
 rename drivers/net/wireless/{wl12xx/wl1251_rx.c => wl1251/rx.c} (96%)
 rename drivers/net/wireless/{wl12xx/wl1251_rx.h => wl1251/rx.h} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_sdio.c => wl1251/sdio.c} (98%)
 rename drivers/net/wireless/{wl12xx/wl1251_spi.c => wl1251/spi.c} (97%)
 rename drivers/net/wireless/{wl12xx/wl1251_spi.h => wl1251/spi.h} (94%)
 rename drivers/net/wireless/{wl12xx/wl1251_tx.c => wl1251/tx.c} (95%)
 rename drivers/net/wireless/{wl12xx/wl1251_tx.h => wl1251/tx.h} (98%)
 rename drivers/net/wireless/{wl12xx => wl1251}/wl1251.h (98%)
 create mode 100644 drivers/net/wireless/wl1251/wl12xx_80211.h
 create mode 100644 drivers/net/wireless/wl12xx/wl12xx_platform_data.c
 delete mode 100644 firmware/bnx2/bnx2-mips-06-5.0.0.j6.fw.ihex
 create mode 100644 firmware/bnx2/bnx2-mips-06-6.0.15.fw.ihex
 delete mode 100644 firmware/bnx2/bnx2-mips-09-5.0.0.j15.fw.ihex
 create mode 100644 firmware/bnx2/bnx2-mips-09-6.0.17.fw.ihex
 delete mode 100644 firmware/bnx2/bnx2-rv2p-06-5.0.0.j3.fw.ihex
 create mode 100644 firmware/bnx2/bnx2-rv2p-06-6.0.15.fw.ihex
 delete mode 100644 firmware/bnx2/bnx2-rv2p-09-5.0.0.j10.fw.ihex
 create mode 100644 firmware/bnx2/bnx2-rv2p-09-6.0.17.fw.ihex
 delete mode 100644 firmware/bnx2/bnx2-rv2p-09ax-5.0.0.j10.fw.ihex
 create mode 100644 firmware/bnx2/bnx2-rv2p-09ax-6.0.17.fw.ihex
 delete mode 100644 firmware/bnx2x-e1-5.2.13.0.fw.ihex
 delete mode 100644 firmware/bnx2x-e1h-5.2.13.0.fw.ihex
 create mode 100644 firmware/bnx2x/bnx2x-e1-6.0.34.0.fw.ihex
 create mode 100644 firmware/bnx2x/bnx2x-e1h-6.0.34.0.fw.ihex
 create mode 100644 firmware/bnx2x/bnx2x-e2-6.0.34.0.fw.ihex
 create mode 100644 include/linux/tc_act/tc_csum.h
 rename include/linux/{spi => }/wl12xx.h (68%)
 create mode 100644 include/net/gre.h
 create mode 100644 include/net/netfilter/ipv6/nf_defrag_ipv6.h
 create mode 100644 include/net/netfilter/xt_log.h
 create mode 100644 include/net/tc_act/tc_csum.h
 create mode 100644 net/ipv4/gre.c
 create mode 100644 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
 create mode 100644 net/netfilter/ipvs/ip_vs_nfct.c
 create mode 100644 net/netfilter/ipvs/ip_vs_pe.c
 create mode 100644 net/netfilter/ipvs/ip_vs_pe_sip.c
 delete mode 100644 net/rds/rdma.h
 create mode 100644 net/rds/xlist.h
 create mode 100644 net/sched/act_csum.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
