Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab0HDDiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 23:38:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54852
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932517Ab0HDDh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 23:37:58 -0400
Date: Tue, 03 Aug 2010 20:38:14 -0700 (PDT)
Message-Id: <20100803.203814.59697285.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o743cXXc031176


Another release, another merge window, another set of networking
changes to merge :-)

Besides the usual assortment of cleanups and bug fixes, we have:

1) Some BKL-->mutex conversions from Arnd Bergmann

2) Support for higher granularity for inter-transmission gaps in pktgen
   from Daniel Turull.

3) Several optimizations from Eric Dumazet including:

   a) Use __this_cpu_inc() where possible
   b) Use less atomic bitops in packet scheduler
   c) Convert IP input route resolution paths to RCU
   d) some RCU'ification of the ARP code as well
   e) Less atomic ops in RAW socket transmit
   f) Similarly in IGMP and ICMP redirect processing
   g) Start supporting 64-bit network device statistics ubiquitously
   h) convert inetpeer cache to RCU
   i) allow TSO to be enabled on devices underneath VLANs

   Also, he added support for dumping routing table entries
   by MARK value.

4) Support SCM socket facilities across namespaces, from Eric
   W. Biederman

5) Support for ECN in TCP syncookies, along with other syncookie
   validation improvements, from Florian Westphal

6) Some BPF filter optimizations from Hagen Paul Pfeifer

7) Fix netpoll facilities so that bridging can be supported properly,
   from Herbert Xu

8) Add a network device notifier event in order to facilitate things
   like fast guest migration.  From Ian Campbell.

9) Support VLAN "0" properly, from Pedro Garcia.

10) Allow AF_PACKET to provide hw packet timestamps even when in 'mmap'
    mode.  From Scott McMillan

11) Scalability improvements in /proc/net/tcp reading, from Tom Herbert.

Please pull, thanks a lot!

The following changes since commit 3a09b1be53d23df780a0cd0e4087a05e2ca4a00c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw (2010-08-03 14:40:10 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Ajit Khaparde (13):
      be2net: enable ipv6 tso support
      be2net: changes to properly provide phy details
      be2net: change to call pmac_del only if necessary
      be2net: add support to get vf config
      be2net: add vlan support for sriov virtual functions
      be2net: code to support tx rate configuration on virtual functions
      be2net: supress printing error when mac query fails for VF
      be2net: variable name changes
      be2net: bump the driver version number
      be2net: fix to correctly know if driver needs to run for a VF or a PF
      be2net: add code to dump registers for debug
      be2net: change to show correct physical link status
      be2net: fix to avoid sending get_stats request if one is already being processed.

Alex Lorca (1):
      net-caif: Added missing lock validator constants

Alexander Duyck (10):
      skbuff: add check for non-linear to warn_if_lro and needs_linearize
      ixgbe: update set_rx_mode to fix issues w/ macvlan
      x86: Align skb w/ start of cacheline on newer core 2/Xeon Arch
      x86: Drop CONFIG_MCORE2 check around setting of NET_IP_ALIGN
      igb: correct link test not being run when link is down
      igb: drop support for UDP hashing w/ RSS
      e1000: allow option to limit number of descriptors down to 48 per ring
      ixgbe: drop support for UDP in RSS hash generation
      ixgbevf: fix null pointer dereference due to filter being set for VLAN 0
      igb: Program MDICNFG register prior to PHY init

Amerigo Wang (1):
      mlx4: add dynamic LRO disable support

Ameya Palande (1):
      wl12xx: Use MODULE_ALIAS macro at correct postion for SPI bus

Amit Kumar Salecha (13):
      qlcnic: fix register access
      qlcnic: cleanup skb allocation
      qlcnic: handshake with card after fw load
      qlcnic: fix mac address mgmt
      qlcnic: release device resources during interface down
      qlcnic: dont free host resources during fw recovery
      qlcnic: offload tx timeout recovery
      qlcnic: mark context state freed after destroy
      qlcnic: update version to 5.0.6
      qlcnic: disable tx timeout recovery
      qlcnic: fix netdev notifier in error path
      qlcnic: fix pci resource leak
      qlcnic: fix loopback test

Amitkumar Karwar (3):
      libertas: Added callback functions to support SDIO suspend/resume.
      libertas: Added support for host sleep feature
      Bluetooth: Process interrupt in main thread of btmrvl driver as well

Andrew Morton (2):
      net: fix "netpoll: Allow netpoll_setup/cleanup recursion"
      drivers/net/82596.c: fix warning

Andrew O. Shadoura (1):
      3c59x: Add ethtool WOL support

Andy Gospodarek (3):
      bonding: add all_slaves_active parameter
      bonding: allow user-controlled output slave selection
      bonding: prevent sysfs from allowing arp monitoring with alb/tlb

Andy Shevchenko (9):
      drivers: isdn: use kernel macros to convert hex digit
      drivers: isdn: remove custom strtoul()
      drivers: isdn: get rid of custom strtoul()
      drivers/net/cxgb3/t3_hw.c: use new hex_to_bin() method
      drivers: atm: don't use private copy of hex_to_bin()
      drivers: net: use newly introduced hex_to_bin()
      usb: usbnet: use newly introduced hex_to_bin()
      wireless: use newly introduced hex_to_bin()
      net: core: don't use own hex_to_bin() method

Anirban Chakraborty (9):
      qlcnic: NIC Partitioning - Add basic infrastructure support
      qlcnic: NIC Partitioning - Add non privileged mode support
      qlcnic: Fix Compilation Issue when CONFIG_INET was not set
      qlcnic: Fix a bug in setting up NIC partitioning mode
      qlcnic: Bumped up version number
      qlcnic: Remove obsolete code
      qlcnic: Check FW capability for TSO
      qlcnic: Disable admin tools interface for VF driver mode
      qlcnic: restore NPAR config data after recovery

Anton Vorontsov (3):
      gianfar: Implement workaround for eTSEC74 erratum
      gianfar: Implement workaround for eTSEC76 erratum
      gianfar: Implement workaround for eTSEC-A002 erratum

Arnaud Ebalard (1):
      ipv6: Refactor update of IPv6 flowi destination address for srcrt (RH) option

Arnd Bergmann (2):
      isdn: autoconvert trivial BKL users to private mutex
      net: autoconvert trivial BKL users to private mutex

Arnd Hannemann (1):
      netfilter: fix simple typo in KConfig for netfiltert xt_TEE

Baruch Siach (1):
      fec: use interrupt for MDIO completion indication

Ben Hutchings (33):
      sfc: Rename struct efx_mcdi_phy_cfg to efx_mcdi_phy_data
      sfc: Only count bad packets in rx_errors
      sfc: Get port number from CS_PORT_NUM, not PCI function number
      net: Enable 64-bit net device statistics on 32-bit architectures
      sfc: Implement 64-bit net device statistics on all architectures
      usbnet: Print device statistics as unsigned
      irttp: Print device parameters and statistics as unsigned
      ethtool: Revert incorrect indentation changes
      net: Fix error in comment on net_device_ops::ndo_get_stats
      sfc: Implement ethtool register dump operation
      sfc: Log MTD errors using partition name, not just net device name
      sfc: Implement message level control
      sfc: Replace EFX_DRIVER_NAME with KBUILD_MODNAME
      sfc: Disable setting feature flags that are not implemented
      sfc: Record hardware RX hash on each skb where possible
      sfc: Fix reading of inserted hash
      sfc: Move siena_nic_data::ipv6_rss_key to efx_nic::rx_hash_key
      sfc: Use Toeplitz IPv4 hash for RSS and hash insertion
      sfc: Log clearer error messages for hardware monitor
      3c59x: Specify window explicitly for access to windowed registers
      3c59x: Use fine-grained locks for MII and windowed register access
      ipv6: Clamp reported valid_lft to a minimum of 0
      ipv6: Use interface max_desync_factor instead of static default
      ethtool: Change ethtool_op_set_flags to validate flags
      netdev: Make ethtool_ops::set_flags() return -EINVAL for unsupported flags
      vmxnet3: Remove incorrect implementation of ethtool_ops::get_flags()
      ethtool: Add support for control of RX flow hash indirection
      sfc: Add support for RX flow hash control
      IB/{nes, ipoib}: Pass supported flags to ethtool_op_set_flags()
      sfc: Remove unused field left from mis-merge
      net: Get rid of rtnl_link_stats64 / net_device_stats union
      net: Document that dev_get_stats() returns the given pointer
      3c59x: Fix call to mdio_sync() with the wrong argument

Bhavesh Davda (1):
      net-next: Fix an overflow bug in vmxnet3 Tx descriptor

Bob Copeland (2):
      ath5k: move reset to mac80211 workqueue
      ath5k: disable tasklets during reset

Brian King (1):
      ehea: Allocate stats buffer with GFP_KERNEL

Bruce Allan (17):
      e1000e: cleanup ethtool loopback setup code
      e1000e: cleanup e1000_sw_lcd_config_ich8lan()
      e1000e: separate out PHY statistics register updates
      e1000e: fix check for manageability on ICHx/PCH
      e1000e: initial support for 82579 LOMs
      e1000e: enable support for EEE on 82579
      e1000e: update copyright information
      e1000e: update driver version number
      e1000e: avoid polling h/w registers during link negotiation
      e1000e: do not touch PHY page 800 registers when link speed is 1000Mbps
      e1000e: packet split should not be used with early receive
      e1000e: disable gig speed when in S0->Sx transition
      e1000e: suppress compile warnings on certain archs
      e1000e: remove EEE module parameter
      e1000e: disable EEE support by default
      e1000e: 82577/82578 PHY register access issues
      e1000e: correct MAC-PHY interconnect register offset for 82579

Bruno Randolf (33):
      ath5k: initialize calibration timers
      ath5k: move noise floor calibration into tasklet
      ath5k: Stop queues only for NF calibration
      ath5k: run NF calibration only every 60 seconds
      ath5k: remove ATH_TRACE macro
      ath5k: clarify logic when to enable spur mitigation filter
      ath5k: use ath5k_softc as driver data
      ath5k: add sysfs files for ANI parameters
      ath5k: always calculate ANI listen time
      ath5k: print error message if ANI levels are out of range
      ath5k: update AR5K_PHY_RESTART_DIV_GC values to match masks
      ath5k: new function for setting the antenna switch table
      ath5k: no need to save/restore the default antenna
      ath5k: add debugfs file for queue debugging
      ath5k: more debug prints for resets
      ath5k: rename ath5k_txbuf_free() to ath5k_txbuf_free_skb()
      ath5k: fix some comment typos
      ath5k: fix rx descriptor debugging
      ath5k: print more errors when decriptor setup fails
      ath5k: reset more pointers after we free skbs
      ath5k: unify rx descriptor error handling
      ath5k: split descriptor handling and frame receive
      ath5k: move checks and stats into new function
      ath5k: use direct function calls for descriptors when possible
      ath5k: cosmetic changes in ath5k_hw_proc_5212_rx_status()
      ath5k: remove pointless rx error overlay struct
      ath5k: review and add comments for descriptors
      ath5k: update 5210/5211 frame types
      ath5k: take descriptor differences between 5210 and 5211 into account
      ath5k: review RX descriptor functions
      ath5k: report PHY error frames only for chips which need it
      ath5k: fix antenna div gc for <= AR5K_SREV_PHY_2413
      ath5k: clean up rxlink handling

Carsten Otte (8):
      qeth: Rework qeth_dbf_longtext
      qeth: Add new s390 debug feature for each qeth card
      qeth: Fold qeth_trace debug area
      qeth: Fold qeth_sense debug area
      qeth: Fold qeth_misc debug area
      qeth: Fold qeth_qerr debug area
      qeth: fix use after free for qeths debug area
      qeth: Clear mac_bits field when switching between Layer 2 and Layer 3

Casey Leedom (17):
      cxgb4vf: small changes to message processing structures/macros
      cxgb4vf: update to latest T4 firmware API file
      cxgb4vf: Add new macros and definitions for hardware constants
      cxgb4vf: Add code to provision T4 PCI-E SR-IOV Virtual Functions with hardware resources
      cxgb4vf: Add core T4 PCI-E SR-IOV Virtual Function hardware definitions and device communication code
      cxgb4vf: Add T4 Virtual Function Scatter-Gather Engine DMA code
      cxgb4vf: Add main T4 PCI-E SR-IOV Virtual Function driver for cxgb4vf
      cxgb4vf: Add new Makefile for T4 PCI-E SR-IOV Virtual Function driver cxgb4vf
      cxgb4vf: Stitch new T4 PCI-E SR-IOV Virtual Function driver into the build
      cxgb4vf: Remove obsolete comment about the lack of a TX Timer Callback
      cxgb4vf: Use correct shift factor for extracting the SGE DMA Ingress Padding Boundary
      cxgb4vf: Implement "Unhandled Interrupts" statistic
      cxgb4vf: fix TX Queue restart
      cxgb4vf: fix SGE resource resource deallocation bug
      cxgb4vf: Fix off-by-one error checking for the end of the mailbox delay array
      cxgb4vf: Fix bug where we were only allocating one queue in MSI mode
      cxgb4vf: add maintainer entry for cxgb4vf

Catalin Marinas (1):
      smsc911x: Add spinlocks around registers access

Changli Gao (30):
      htb: remove two unnecessary assignments
      net-next: remove useless union keyword
      tcp: unify tcp flag macros
      act_mirred: don't clone skb when skb isn't shared
      act_mirred: combine duplicate code
      act_nat: use stack variable
      fragment: add fast path for in-order fragments
      netfilter: nf_conntrack_reasm: add fast path for in-order fragments
      netfilter: ipt_REJECT: postpone the checksum calculation.
      netfilter: xt_TPROXY: the length of lines should be within 80
      net: cleanups
      inet, inet6: make tcp_sendmsg() and tcp_sendpage() through inet_sendmsg() and inet_sendpage()
      netfilter: nf_nat_core: merge the same lines
      netfilter: arptables: use arp_hdr_len()
      netfilter: xt_quota: use per-rule spin lock
      xt_quota: report initial quota value instead of current value to userspace
      netfilter: ip6tables: use skb->len for accounting
      netfilter: iptables: use skb->len for accounting
      genetlink: cleanup code according to CodingStyle
      drop_monitor: use genl_register_family_with_ops()
      genetlink: use genl_register_family_with_ops()
      act_nat: fix wild pointer
      act_nat: the checksum of ICMP doesn't have pseudo header
      netfilter: nf_conntrack_extend: introduce __nf_ct_ext_exist()
      netfilter: nf_nat: use local variable hdrlen
      netfilter: nf_nat: make unique_tuple return void
      netfilter: nf_nat: don't check if the tuple is unique when there isn't any other choice
      netfilter: nf_conntrack_acct: use skb->len for accounting
      ip_fragment: fix subtracting PPPOE_SES_HLEN from mtu twice
      net: cleanup inclusion

Chihau Chau (1):
      Net: ethernet: pe2.c: fix EXPORT_SYMBOL macro code style issue

Choi, David (1):
      micrel phy driver - updated(1)

Christian Lamparter (3):
      p54: update MAINTAINERS
      mac80211: skip HT parsing if HW does not support HT
      cfg80211: fix dev <-> wiphy typo

Christoph Egger (7):
      net: Removing dead {AR,WAVE}LAN
      cassini: Removing dead CASSINI_QGE_DEBUG
      cassini: Removing dead CASSINI_MULTICAST_REG_WRITE
      cassini: Removing dead CASSINI_NAPI
      cs89x0: Removing dead SH_HICOSH4
      eth_v10: Removing dead ETRAX_NETWORK_RED_ON_NO_CONNECTION
      net: Removing dead ARCH_PNX010X

Cyril Chemparathy (2):
      phy/marvell: add 88e1121 interface mode support
      phy/marvell: add 88ec048 support

Cyril Lacoux (1):
      Bluetooth: Added support for controller shipped with iMac i5

Dan Carpenter (29):
      caif: remove unneeded null check in caif_connect()
      caif: cleanup: remove duplicate checks
      caif: remove unneeded variable from caif_net_open()
      caif: add newlines after declarations in caif_serial.c
      ath9k/debug: improve the snprintf() handling
      ath9k/debug: fixup the return codes
      ath9k: cleanup: remove unneeded null check
      enic: cleanup vic_provinfo_alloc()
      cpmac: use resource_size()
      prism54: call BUG_ON() earlier
      hostap: fixup strlen() math
      9p: strlen() doesn't count the terminator
      isdn: fix strlen() usage
      net/sched: potential data corruption
      orinoco_usb: potential null dereference
      arcnet: fix signed bug in probe function
      caif: precedence bug
      stmmac: handle allocation errors in setup functions
      mv643xx_eth: potential null dereference
      ath9k: snprintf() returns largish values
      ath5k: snprintf() returns largish values
      mac80211: freeing the wrong variable
      wireless: remove unneeded variable from regulatory_hint_11d()
      libertas: precedence bug
      caif: handle snprintf() return
      Bluetooth: Fix kfree() => kfree_skb() in hci_ath.c
      ixgbe: potential null dereference
      dnet: fixup error handling in initialization
      hp100: unmap memory on error path

Dan Williams (16):
      libertas: clean up MONITOR_MODE command
      libertas: clean up RSSI command
      libertas: convert 11D_DOMAIN_INFO to a direct command
      libertas: remove unused indirect TPC_CFG command leftovers
      libertas: remove unused Automatic Frequency Control command
      libertas: remove Beacon Control
      libertas: convert LED_GPIO_CTRL to a direct command
      libertas: convert register access to direct commands
      libertas: convert Mesh Blinding Table access to a direct command
      libertas: convert CMD_FWT_ACCESS to a direct command
      libertas: remove unused indirect command response handler
      libertas: convert PS_MODE to a direct command
      libertas: convert DEEP_SLEEP timer to a direct command
      libertas: kill unused lbs_prepare_and_send_command()
      libertas: rename lbs_get_cmd_ctrl_node() to lbs_get_free_cmd_node()
      libertas: remove unused cmd_pending waitq

Daniel Halperin (3):
      iwlwifi: parse block ack responses correctly
      iwlwifi: fix wrapping when handling aggregated batches
      iwlwifi: update LQ for bcast station on channel change

Daniel Mack (1):
      drivers/net/arcnet/capmode.c: clean up code

Daniel Turull (1):
      pktgen: increasing transmission granularity

David Daney (2):
      netdev: octeon_mgmt: Fix section mismatch errors.
      netdev: mdio-octeon: Fix section mismatch errors.

David Gnedt (1):
      mac80211: set carrier on for monitor interfaces on ieee80211_open

David J. Choi (1):
      drivers/net: Add Micrel KS8841/42 support to ks8842 driver

David S. Miller (34):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Fix NETDEV_NOTIFY_PEERS to not conflict with NETDEV_BONDING_DESLAVE.
      Merge branch 'vhost-net-next' of git://git.kernel.org/.../mst/vhost
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      gadget/rndis: dev_get_stats() now returns rtnl_link_stats64.
      net: Export cred_to_ucred to modules.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      niu: BUG on inability to find page in rx page hashes.
      ethoc: Fix warning in ethoc_init_ring().
      macvtap: Use dev_t for macvtap_major.
      Revert "tc35815: fix iomap leak"
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      sch_atm: Convert to use standard list_head facilities.
      ks8842: Fix ks8842_tx_frame() for 16bit case.
      ipv6: Make IP6CB(skb)->nhoff 16-bit.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      vhost net: Fix warning.
      r6040: Fix args to phy_mii_ioctl().
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      wireless: Make COMPAT_NETLINK_MESSAGES depend upon WEXT_CORE
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ks8842: Fix warnings on 64-bit.
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'vhost-net-next' of git://git.kernel.org/.../mst/vhost
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Revert "net: remove zap_completion_queue"

David Stevens (1):
      vhost-net: mergeable buffers support

Dean Nelson (1):
      e1000e: don't inadvertently re-set INTX_DISABLE

Denis Kirjanov (7):
      fec: convert TX hook to netdev_tx_t
      fec: Cleanup PHY probing
      fec: convert legacy PM hooks to dem_pm_ops
      ll_temac: add error checking to DMA init path
      cxgb4: Use kfree_skb for skb pointers
      ll_temac: fix DMA resources leak
      ll_temac: Fix missing validate_addr hook

Dimitris Michailidis (24):
      cxgb4: dynamically determine flash size and FW image location
      cxgb4: rearrange initialization code in preparation for EEH
      cxgb4: implement EEH
      cxgb4: set dev_id to the port number
      cxgb4: switch to 64 bit inteface statistics
      cxgb4: propagate link initialization errors to .ndo_open's callers
      cxgb4: add a missing error interrupt
      cxgb4: update FW definitions
      cxgb4: minor cleanup
      cxgb4: fix for new ndo_get_stats64 signature
      cxgb4: move the choice of interrupt type before net_device registration
      cxgb4: avoid duplicating some resource freeing code
      cxgb4: add user manipulation of the RSS table
      cxgb4: implement the ETHTOOL_GRXFH command
      cxgb4: exclude registers with read side effects from register dumps
      cxgb4: disable an interrupt that is neither used nor serviced
      cxgb4: don't offload Rx checksums for IPv6 fragments
      cxgb4: fix TSO descriptors
      cxgb4: get on-chip queue info from FW and create a memory window for them
      cxgb4: advertise NETIF_F_TSO_ECN
      cxgb4: support running the driver on PCI functions besides 0
      cxgb4: fix wrong shift direction
      cxgb4: add new PCI IDs
      cxgb4: update driver version

Divy Le Ray (2):
      cxgb3: update FW to 7.10
      cxgb3: request 7.10 firmware

Dmitry Eremin-Solenikov (2):
      broadcom: move all PHY_ID's to header
      broadcom: Add 5241 support

Dmitry Kravkov (8):
      bnx2x: Create separate folder for bnx2x driver
      bnx2x: store module parameters in driver main structure
      bnx2x: move global variable load_count to bnx2x.h
      bnx2x: Create bnx2x_cmn.* files
      bnx2x: Create separate file for ethtool routines
      bnx2x: Move statistics handling code to bnx2x_stats.*
      bnx2x: update driver version to 1.52.53-3
      bnx2x: Update MAINTAINERS according to new location

Dmitry Popov (1):
      tcp: cookie transactions setsockopt memory leak

Don Skidmore (2):
      ixgbe: add 1g PHY support for 82599
      ixgbe: fix version string for ixgbe

Dor Shaish (1):
      iwlwifi: Fix null pointer referencing in iwl_dbgfs_rx_queue_read.

Eli Cohen (1):
      mlx4_en: use net_device dev_id to indicate port number

Emil Tantilov (5):
      ixgbe: Use netdev_<level>, dev_<level>, pr_<level>
      igb: Fix Tx hangs seen when loading igb with max_vfs > 7.
      ixgbe: use netif_<level> instead of netdev_<level>
      e1000: use netif_<level> instead of netdev_<level>
      igb: Use irq_synchronize per vector when using MSI-X

Emmanuel Grumbach (3):
      iwlwifi: rename rxq->dma_addr
      iwlwifi: rename iwl4965_rx_mpdu_res_start
      iwlagn: fix the bit mask of a FH register in stop Tx DMA flow

Eran Liberty (1):
      gianfar: code cleanup

Eric Benard (1):
      net/fec: clean suspend/resume

Eric Dumazet (82):
      net: Use __this_cpu_inc() in fast path
      net: remove zap_completion_queue
      tcp: tcp_md5_hash_skb_data() frag_list handling
      ipv6: get rid of ipip6_prl_lock
      netfilter: br_netfilter: use skb_set_noref()
      netfilter: xt_statistic: remove nth_lock spinlock
      net: Define accessors to manipulate QDISC_STATE_RUNNING
      net: QDISC_STATE_RUNNING dont need atomic bit ops
      net: add additional lock to qdisc to increase throughput
      net: CONFIG_NET_NS reduction
      ipv4: add LINUX_MIB_IPRPFILTER snmp counter
      ipv4: RCU conversion of ip_route_input_slow/ip_route_input_mc
      drivers/net: use __packed annotation
      net: use __packed annotation
      ipv4: RCU changes in __mkroute_input()
      arp: RCU changes
      From abbffa2aa9bd6f8df16d0d0a102af677510d8b9a Mon Sep 17 00:00:00 2001     From: Eric Dumazet <eric.dumazet@gmail.com>     Date: Thu, 3 Jun 2010 04:29:41 +0000     Subject: [PATCH 2/3] net: net/socket.c and net/compat.c cleanups
      netfilter: vmalloc_node cleanup
      raw: avoid two atomics in xmit
      ip: Router Alert RCU conversion
      igmp: avoid two atomic ops in igmp_rcv()
      ipv4: avoid two atomic ops in ip_rt_redirect()
      net: avoid two atomic ops in ip_rcv_options()
      anycast: Some RCU conversions
      netfilter: xt_rateest: Better struct xt_rateest layout
      netfilter: nf_conntrack: IPS_UNTRACKED bit
      netfilter: nf_conntrack: per_cpu untracking
      netfilter: ip_queue: rwlock to spinlock conversion
      netfilter: ip6_queue: rwlock to spinlock conversion
      netfilter: nfnetlink_queue: some optimizations
      netfilter: nfnetlink_log: RCU conversion
      icmp: RCU conversion in icmp_address_reply()
      ipv6: mcast: RCU conversions
      ip: ip_ra_control() rcu fix
      pkt_sched: gen_kill_estimator() rcu fixes
      econet: fix locking
      netfilter: nfnetlink_log: RCU conversion, part 2
      ipv6: avoid two atomics in ipv6_rthdr_rcv()
      ipv6: RCU changes in ipv6_get_mtu() and ip6_dst_hoplimit()
      loopback: Implement 64bit stats on 32bit arches
      inetpeer: various changes
      netfilter: CLUSTERIP: RCU conversion
      inetpeer: RCU conversion
      ip_frag: Remove some atomic ops
      ipfrag : frag_kfree_skb() cleanup
      net: NET_SKB_PAD should depend on L1_CACHE_BYTES
      inetpeer: do not use zero refcnt for freed entries
      inetpeer: restore small inet_peer structures
      net: Introduce u64_stats_sync infrastructure
      bridge: 64bit rx/tx counters
      arp: RCU change in arp_solicit()
      loopback: use u64_stats_sync infrastructure
      snmp: add align parameter to snmp_mib_init()
      ipv6: remove ipv6_statistics
      net: u64_stats_sync improvements
      net: use this_cpu_ptr()
      net: u64_stats_fetch_begin_bh() and u64_stats_fetch_retry_bh()
      macvlan: 64 bit rx counters
      vlan: 64 bit rx counters
      tcp: tso_fragment() might avoid GFP_ATOMIC
      snmp: 64bit ipstats_mib for all arches
      netfilter: ipt_REJECT: avoid touching dst ref
      ipv4: use skb_dst_copy() in ip_copy_metadata()
      net: fix 64 bit counters on 32 bit arches
      vlan: allow TSO setting on vlan interfaces
      bnx2: 64 bit stats on all arches
      tg3: 64 bit stats on all arches
      tg3: allow TSO on vlan devices
      net/ipv4: EXPORT_SYMBOL cleanups
      net/core: EXPORT_SYMBOL cleanups
      net: sock_free() optimizations
      tcp: sizeof struct tcp_skb_cb is 44
      bonding: fix bond_inet6addr_event()
      net: 64bit stats for netdev_queue
      bonding: avoid a warning
      net: this_cpu_xxx conversions
      net: RTA_MARK addition
      netfilter: add xt_cpu match
      ixgbe: fix ethtool stats
      net: pskb_expand_head() optimization
      netlink: netlink_recvmsg() fix
      netfilter: {ip,ip6,arp}_tables: dont block bottom half more than necessary

Eric W. Biederman (8):
      scm: Reorder scm_cookie.
      user_ns: Introduce user_nsmap_uid and user_ns_map_gid.
      sock: Introduce cred_to_ucred
      af_unix: Allow SO_PEERCRED to work across namespaces.
      af_netlink: Add needed scm_destroy after scm_send.
      scm: Capture the full credentials of the scm sender.
      af_unix: Allow credentials to work across user and pid namespaces.
      af_unix: Allow connecting to sockets in other network namespaces.

FUJITA Tomonori (10):
      mwl8k: use the dma state API instead of the pci equivalents
      iwlwifi: use the DMA state API instead of the pci equivalents
      ssb: add dma_dev to ssb_device structure
      b43legacy: replace the ssb_dma API with the generic DMA API
      b43: replace the ssb_dma API with the generic DMA API
      b44: replace the ssb_dma API with the generic DMA API
      ssb: remove the ssb DMA API
      b44: remove unused dma_desc_align_mask
      cxgb4vf: remove obsolete DECLARE_PCI_UNMAP_ADDR usage
      cxgb3: simplify need_skb_unmap

Felix Fietkau (53):
      mac80211: add the minstrel_ht rate control algorithm
      ath9k_hw: add multicast key search support
      ath9k_common: use allocated key cache entries for multi BSS crypto support
      ath9k: use the key handling code from ath9k_common instead of duplicating it
      ath9k: fix queue stop/start based on the number of pending frames
      mac80211: reduce debugfs code size
      ath9k: fix mac80211 queue lookup for waking up queues
      ath9k_htc: use common WMM AC definitions instead of ath9k ones
      ath9k: remove duplicate WMM AC definitions
      ath9k: remove declarations of some nonexistant functions
      ath9k: make ath_get_hal_qnum static
      ath9k: fix extending the rx timestamp with the hardware TSF
      ath9k: fix queue stopping threshold
      ath9k: add a debugfs entry for ignoring CCA on the extension channel in HT40
      ath9k_hw: remove a useless function for setting the mac address
      ath9k_hw: add register definitions related to PA predistortion
      ath9k_hw: add support for parsing PA predistortion related EEPROM fields
      ath9k_hw: add functions for controlling PA predistortion calibration
      ath9k: implement PA predistortion support
      ath9k_hw: remove ATH9K_CAP_CIPHER
      ath9k_hw: remove ATH9K_CAP_TXPOW
      ath9k_hw: remove ATH9K_CAP_TKIP_MIC
      ath9k_hw: remove ATH9K_CAP_TKIP_SPLIT
      ath9k_hw: remove ATH9K_CAP_MCAST_KEYSRCH
      ath9k/ath9k_htc: remove redundand checks for dual-stream tx support
      ath9k_hw: remove ATH9K_CAP_DS
      ath9k: fix retry count for A-MPDU rate control status reports
      mac80211: fix the for_each_sta_info macro
      ath9k: fix TSF after reset on AR913x
      ath9k_hw: fix a few inconsistencies in initval array names
      ath9k_hw: reformat the ar5008, ar9001 and ar9002 initvals to match ar9003
      ath9k_hw: sync initvals for ar9001 and ar9002 with Atheros
      ath9k_hw: sanitize noise floor values properly on all chips
      ath9k_hw: clean up the noise floor calibration code to reduce code duplication
      ath9k: fix false positives in the baseband hang check
      ath9k: fix crash with WEP in ad-hoc mode
      ath9k: fix a potential buffer leak in the STA teardown path
      ath9k: fix a buffer leak in A-MPDU completion
      ath9k_hw: fix antenna diversity on AR9285
      ath9k_hw: fix a sign error in the IQ calibration code
      ath9k_hw: fix an off-by-one error in the PDADC boundaries calculation
      ath9k_hw: prevent a fast channel change after a rx DMA stuck issue
      ath9k_hw: report the TID in the tx status on AR5008-AR9002
      ath9k: validate the TID in the tx status information
      ath9k: merge noisefloor load implementations
      ath9k: another fix for the A-MPDU buffer leak
      ath9k_hw: remove initvals for hardware which was never sold
      mac80211: fix aggregation action frame handling with AP VLANs
      ath9k: fix yet another buffer leak in the tx aggregation code
      ath9k_hw: fix invalid extension channel noisefloor readings in HT20
      ath9k_hw: fix a small typo in the noisefloor calibration debug code
      ath9k_hw: simplify noisefloor calibration chainmask calculation
      mac80211: inform drivers about the off-channel status on channel changes

Filip Aben (2):
      hso: remove driver version
      hso: Add new product ID

Finn Thain (2):
      mac8390: propagate error code from request_irq
      mac8390: raise error logging priority

Florian Fainelli (2):
      r6040: implement phylib
      r6040: bump version to 0.26 and date to 30 May 2010

Florian Mickler (1):
      e1000e: register pm_qos request on hardware activation

Florian Westphal (7):
      syncookies: make v4/v6 synflood warning behaviour the same
      syncookies: avoid unneeded tcp header flag double check
      syncookies: update mss tables
      ipv6: syncookies: do not skip ->iif initialization
      syncookies: check decoded options against sysctl settings
      syncookies: do not store rcv_wscale in tcp timestamp
      syncookies: add support for ECN

Frank Blaschka (1):
      qeth: fix page breaks in hw headers

Geert Uytterhoeven (1):
      net: mac8390 - Sort out memory/MMIO accesses and casts

George Kadianakis (1):
      net/ipv4/ip_output.c: Removal of unused variable in ip_fragment()

Gerrit Renker (2):
      dccp: remove unused function argument
      dccp: make implementation of Syn-RTT symmetric

Gertjan van Wingerde (24):
      rt2x00: Move rt2x00debug_dump_frame declaration to rt2x00.h.
      rt2x00: Push beacon TX descriptor writing to drivers.
      rt2x00: Reverse calling order of bus write_tx_desc and driver write_tx_desc.
      rt2x00: Properly reserve room for descriptors in skbs.
      rt2x00: Fix rt2800usb TX descriptor writing.
      rt2x00: Clean up USB vendor request buffer functions.
      rt2x00: Centralize rt2800 beacon writing.
      rt2x00: Remove RT2870 chipset identification.
      rt2x00: Move all register definitions for rt2800 to rt2800.h.
      rt2x00: Introduce separate interface type for PCI-express.
      rt2x00: Simplify check for external LNA in rt2800_init_rfcsr.
      rt2x00: Move PCI/USB specific register initializations to rt2800{pci,usb}.
      rt2x00: Sync rt2800 MCU boot signal with Ralink driver.
      rt2x00: Fix HT40 operation in rt2800.
      mac80211: Fix compile warning in scan.c.
      rt2x00: Fix frame dumping for USB devices.
      rt2x00: Move filling of TX URB to rt2x00usb_kick_tx_entry function.
      rt2x00: Merge PCI and USB versions of write_tx_data into single function.
      rt2x00: Move common txdone handling to rt2x00lib_txdone.
      rt2x00: Rename driver write_tx_datadesc callback function.
      rt2x00: Split of TXWI writing to write_tx_data callback in rt2800usb.
      eeprom_93cx6: Add support for 93c86 EEPROMs.
      rt2x00: Correctly detect 93C86 EEPROMs in rt2800pci.
      rt2x00: Align rt2800 EEPROM validation to Ralink vendor driver.

Giuseppe CAVALLARO (2):
      stmmac: fix timer setup when use dual mac Kconfig
      stmmac: fix automatic PAD/FCS stripping

Giuseppe Cavallaro (1):
      phy: add suspend/resume in the ic+

Grazvydas Ignotas (1):
      wl1251: fix ELP_CTRL register reads

Greg Rose (2):
      igb: Use only a single Tx queue in SR-IOV mode
      igb: Add comment

Gustavo F. Padovan (46):
      Bluetooth: Remove max_tx and tx_window module paramenters from L2CAP
      Bluetooth: Remove L2CAP Extended Features from Kconfig
      Bluetooth: Fix drop of packets with invalid req_seq/tx_seq
      Bluetooth: Fix bug with ERTM vars increment
      Bluetooth: Only check SAR bits if frame is an I-frame
      Bluetooth: Fix bug in l2cap_ertm_send() behavior
      Bluetooth: Proper shutdown ERTM when closing the channel
      Bluetooth: Fix L2CAP control bit field corruption
      Bluetooth: Stop ack_timer if ERTM enters in Local Busy or SREJ_SENT
      Bluetooth: Update buffer_seq before retransmit frames
      Bluetooth: Fix handle of received P-bit
      Bluetooth: Check the tx_window size on setsockopt
      Bluetooth: Check packet FCS earlier
      Bluetooth: Fix missing retransmission action with RR(P=1)
      Bluetooth: Fix ERTM error reporting to the userspace
      Bluetooth: Add debug output to ERTM code
      Bluetooth: Tweaks to l2cap_send_i_or_rr_or_rnr() flow
      Bluetooth: Change the way we set ERTM mode as mandatory
      Bluetooth: Disconnect the channel if we don't want the proposed mode
      Bluetooth: Prefer Basic Mode on receipt of ConfigReq
      Bluetooth: Actively send request for Basic Mode
      Bluetooth: Refuse ConfigRsp with different mode
      Bluetooth: Remove check for supported mode
      Bluetooth: Disconnect early if mode is not supported
      Bluetooth: Don't accept ConfigReq if we aren't in the BT_CONFIG state
      Bluetooth: Remove the send_lock spinlock from ERTM
      Bluetooth: Add backlog queue to ERTM code
      Bluetooth: Improve ERTM local busy handling
      Bluetooth: Send ConfigReq after send a ConnectionRsp
      Bluetooth: Fix bug in kzalloc allocation size
      Bluetooth: Keep code under column 80
      Bluetooth: Add Copyright notice to L2CAP
      Bluetooth: Update L2CAP version information
      Bluetooth: Add Google's copyright to L2CAP
      Bluetooth: Move bit-field variable in USB driver to data->flags
      Bluetooth: Fix typo in hci_event.c
      Bluetooth: Enable L2CAP Extended features by default
      Bluetooth: Use __packed annotation
      Bluetooth: Use __packed annotation for drivers
      irda: Use __packed annotation instead IRDA_PACKED macro
      net: remove last uses of __attribute__((packed))
      Bluetooth: Fix permission of hci_ath.c
      Bluetooth: Test 'count' value before enter the loop
      Bluetooth: Use hci_recv_stream_fragment() in UART driver
      Bluetooth: Add __init and __exit marks to UART drivers
      Bluetooth: Add __init and __exit marks to RFCOMM

Hagen Paul Pfeifer (1):
      net: optimize Berkeley Packet Filter (BPF) processing

Hannes Eder (3):
      netfilter: xt_ipvs (netfilter matcher for IPVS)
      IPVS: make friends with nf_conntrack
      IPVS: make FTP work with full NAT support

Helmut Schaa (29):
      cfg80211: don't refuse HT20 channels on devices that don't support HT40
      rt2x00: rt2800: disable TX STBC for 1 stream devices
      rt2x00: Update TX_SW_CFG initvals for 305x SoC
      rt2x00: fix use of mcs rates
      rt2x00: Remove suspicious register write
      rt2x00: clarify meaning of txdone flags
      rt2x00: don't use TXDONE_FALLBACK as success indicator
      rt2x00: only set TXDONE_FALLBACK in rt2800pci if the frame was retried
      rt2x00: Fix IEEE80211_TX_CTL_MORE_FRAMES handling
      rt2x00: Add comment about BBP1_TX_POWER
      rt2x00: Fix TX_STA_FIFO handling
      rt2x00: Fix typo in rt2800_config_txpower
      rt2x00: provide mac80211 a suitable max_rates value
      rt2x00: Fix tx status reporting when falling back to the lowest rate
      rt2x00: Implement tx mpdu aggregation
      rt2x00: Fix beacon updates in rt2800pci
      rt2x00: Fix beacon updates in rt61pci
      rt2x00: Disable link tuning in AP mode
      rt2x00: fix beacon reset on rt2800
      mac82011: Allow selection of minstrel_ht as default rc algorithm
      rt2x00: Limit txpower by eeprom values
      rt2x00: Convert rt2x00 to use threaded interrupts
      rt2x00: Allow beacon update without scheduling a work
      rt2x00: Implement broad- and multicast buffering
      rt2x00: Use pretbtt irq for fetching beacons on rt2800pci
      rt2x00: Use separate mac80211_ops for rt2800pci and rt2800usb
      rt2x00: Remove set_tim callback from PCI drivers
      rt2x00: Don't initialize beacon interval to 0 on rt2800 devices
      rt2x00: Add missing TSF sync mode for AP operation

Henrique Camargo (1):
      net: Fix a typo from "dev" to "ndev"

Herbert Xu (13):
      netpoll: Set npinfo to NULL even with ndo_netpoll_cleanup
      bridge: Remove redundant npinfo NULL setting
      netpoll: Fix RCU usage
      netpoll: Add locking for netpoll_setup/cleanup
      netpoll: Add ndo_netpoll_setup
      netpoll: Allow netpoll_setup/cleanup recursion
      netpoll: Add netpoll_tx_running
      bridge: Fix netpoll support
      bridge: Add const to dummy br_netpoll_send_skb
      netpoll: Use correct primitives for RCU dereferencing
      udp: Add UFO to NETIF_F_SOFTWARE_GSO
      bridge: Fix skb leak when multicast parsing fails on TX
      bridge: Allow multicast snooping to be disabled before ifup

Ian Campbell (3):
      arp_notify: document that a gratuitous ARP request is sent when this option is enabled
      arp_notify: allow drivers to explicitly request a notification event.
      xen: netfront: explicitly generate arp_notify event after migration.

Ivo van Doorn (22):
      rt2x00: Use IEEE80211_TX_CTL_STBC flag
      rt2x00: Enable fallback rates for rt61pci and rt73usb
      rt2x00: Update author rt2800lib
      rt2x00: Limit TX done looping to number of TX ring entries
      rt2x00: Enable HW crypto by default
      rt2x00: Synchronize WCID initialization with legacy driver
      rt2x00: Write the BSSID to register when interface is added
      rt2x00: Remove unneeded variable
      rt2x00: Enable multiBSS in rt2800
      rt2x00: Fix IEEE80211_HT_CAP_RX_STBC assignment
      rt2x00: Fix antenna initialization
      rt2x00: Always set BBP_CSR_CFG_BBP_RW_MODE to 1
      rt2x00: Fix compile warning when debug disabled
      rt2x00: Convert AGC value from descriptor to RSSI (dBm)
      rt2x00: Rename CONFIG_DISABLE_LINK_TUNING
      rt2x00: Disable link tuning while scanning
      rt2x00: Fix vgc_level_reg handling
      rt2x00: Implement watchdog monitoring
      rt2x00: Make rt2800_write_beacon only export to GPL
      rt2x00: Move common firmware loading into rt2800lib
      rt2x00: Move driver callback functions into the ops structure
      rt2x00: Fix regression for rt2500pci

James Chapman (1):
      l2tp: fix export of header file for userspace

Jay Sternberg (2):
      iwlwifi: display ucode SW Error in hex
      iwlwifi: correct descriptions of advanced ucode errors

Jay Vosburgh (2):
      bonding: change test for presence of VLANs
      bonding: don't lock when copying/clearing VLAN list on slave

Jean Delvare (1):
      e1000e: Drop a useless statement

Jeff Dike (1):
      vhost-net: minor cleanup

Jeff Kirsher (1):
      e1000e: Fix irq_synchronize in MSI-X case

Jie Yang (1):
      atl1c: Add AR8151 v2 support and change L0s/L1 routine

Jiri Olsa (1):
      net - IP_NODEFRAG option for IPv4 socket

Jiri Pirko (13):
      bonding: remove unused variable "found"
      bonding: move slave MTU handling from sysfs V2
      bonding: remove redundant checks from bonding_store_slaves V2
      bonding: make bonding_store_slaves simpler
      bonding: move dev_addr cpy to bond_enslave
      bonding: remove unused original_flags struct slave member
      bonding: optimize tlb_get_least_loaded_slave
      net: replace hooks in __netif_receive_skb V5
      macvlan: use call_rcu for port free
      phonet: use call_rcu for phonet device free
      net: add rx_handler data pointer
      macvlan: use rx_handler_data pointer to store macvlan_port pointer V2
      bridge: use rx_handler_data pointer to store net_bridge_port pointer

Jiri Slaby (1):
      NET: nl80211, fix lock imbalance and netdev referencing

Joe Perches (26):
      drivers/net/gianfar.c: Remove unnecessary kmalloc casts
      drivers/net/tulip/eeprom.c: Remove unnecessary kmalloc casts
      net/ipv4/igmp.c: Remove unnecessary kmalloc casts
      net/ipv6/mcast.c: Remove unnecessary kmalloc casts
      drivers/net/wireless/ipw2x00/ipw2100.c: Remove unnecessary kmalloc casts
      net/core/pktgen.c: Use pr_<level>
      vsprintf: Recursive vsnprintf: Add "%pV", struct va_format
      device.h drivers/base/core.c Convert dev_<level> logging macros to functions
      netdevice.h net/core/dev.c: Convert netdev_<level> logging macros to functions
      netdevice.h: Change netif_<level> macros to call netdev_<level> functions
      drivers/isdn: Remove unnecessary casts of private_data
      drivers/net/caif: Remove unnecessary casts of private_data
      net/core: Remove unnecessary casts of private_data
      net/irda: Remove unnecessary casts of private_data
      drivers/net/wireless: Remove unnecessary casts of private_data
      drivers/net/mlx4: Use %pV, pr_<level>, printk_once
      Bluetooth: Remove unnecessary casts of private_data in drivers
      drivers/net/qlge: Use pr_<level>, shrink text a bit
      drivers/net/qla3xxx.c: Update logging message style
      drivers/net/qla3xxx.c: Checkpatch cleanups
      include/net/cfg80211.h: Add wiphy_<level> printk equivalents
      drivers/net/wireless: Use wiphy_<level>
      drivers/net/wireless/at76c50x-usb.c: Neaten macros
      wireless: Convert wiphy_debug macro to function
      drivers/net/vxge/vxge-main.c: Use pr_<level> and netdev_<level>
      drivers/net/wan/farsync.c: Use standard pr_<level>

Johan Hedberg (4):
      Bluetooth: Add blacklist support for incoming connections
      Bluetooth: Add debugfs support for showing the blacklist
      Bluetooth: Add missing HCIUARTGETDEVICE ioctl to compat_ioctl.c
      Bluetooth: Add HCIUARTSETFLAGS and HCIUARTGETFLAGS ioctls

Johannes Berg (79):
      iwlwifi: introduce iwl_sta_id_or_broadcast
      iwlwifi: don't crash on firmware file missing info
      iwl3945: remove sequence number assignment
      iwlwifi: move iwl_free_tfds_in_queue to iwlagn
      iwlwifi: improve station debugfs
      iwlwifi: remove IWL_MULTICAST_ID
      iwlagn: use firmware event/error log information
      iwlwifi: split debug and debugfs options
      iwlwifi: use proper short slot/preamble settings
      cfg80211: make action channel type optional
      mac80211: remove bogus mod_timer() call
      mac80211: remove tx status ampdu_ack_map
      mac80211: clean up ieee80211_stop_tx_ba_session
      mac80211: move WEP weak IV check
      mac80211: remove useless work starting
      mac80211: drop control frames after processing
      mac80211: move plink state
      mac80211: simplify key locking
      iwlwifi: remove useless node_addr assignments
      iwlwifi: remove unused wlap_bssid_addr assignment
      iwlwifi: remove mac_addr assignment
      iwlwifi: set MAC address in RXON from interface
      iwlwifi: use virtual interface address for scan
      iwlwifi: remove debug frame dumping
      iwlwifi: remove priv->mac_addr
      iwl3945: fix bugs in txq freeing
      iwlagn: fix bug in txq freeing
      iwlwifi: kzalloc txb array
      iwlwifi: reduce memory allocation
      iwlwifi: generic scan TX antenna forcing
      iwlwifi: queue user-initiated scan when doing internal scan
      wireless: fix kernel-doc
      iwlwifi: trace full RX
      iwlwifi: print warning about disconnected antennas
      cfg80211/mac80211: allow action frame TX/RX in IBSS
      mac80211: simplify station/aggregation code
      mac80211: use common skb queue
      mac80211: use common work struct
      mac80211: use common work function
      mac80211: common work skb freeing
      mac80211: pull mgmt frame rx into rx handler
      mac80211: always process blockack action from workqueue
      mac80211: move blockack stop due to fragmentation
      mac80211: move aggregation callback processing
      mac80211: use RCU for RX aggregation
      mac80211: use RCU for TX aggregation
      mac80211: remove non-irqsafe aggregation callbacks
      mac80211: refcount aggregation queue stop
      mac80211: make TX aggregation start/stop request async
      mac80211: move BA session work
      mac80211: defer RX agg session teardown to work
      mac80211: fix RX aggregation timer
      mac80211: change RX aggregation locking
      mac80211: defer TX agg session teardown to work
      mac80211: change TX aggregation locking
      mac80211: allow drivers to sleep in ampdu_action
      mac80211: update aggregation documentation
      mac80211: fix mgmt frame accounting
      mac80211: bracket driver tracing
      mac80211_hwsim: fix fake_hw_scan
      mac80211: fix sw scan bracketing
      iwlagn: use mutex for aggregation
      iwlwifi: use sync commands for keys
      iwlwifi: return ucode errors from station management
      iwlwifi: read rfkill during resume
      cfg80211: ignore spurious deauth
      cfg80211: don't get expired BSSes
      mac80211: move QoS-enable to BSS info
      mac80211: refuse shared key auth when WEP is unavailable
      mac80211: fix IBSS lockdep complaint
      mac80211: proper IBSS locking
      iwlagn: fix firmware loading TLV error path
      iwlwifi: make iwl_mac_beacon_update static
      iwlwifi: reduce beacon fill conditions
      iwlwifi: remove spurious semicolons
      mac80211: remove bogus rcu_read_lock()
      cfg80211: fix IBSS default management key
      mac80211: fix sta assignment
      mac80211: allow drivers to request DTIM period

John Fastabend (3):
      net: consolidate netif_needs_gso() checks
      ixgbe: dcb, set DPF bit when PFC is enabled
      ixgbe: priority tagging FCoE frames without FCoE offload

John W. Linville (68):
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      ath9k_htc: fix build error when ATH9K_HTC_DEBUGFS not enabled
      Revert "iwlwifi: move _agn statistics related structure"
      mac80211: make ARP filtering depend on CONFIG_INET
      iwlwifi: fix-up botched revert
      mac80211: fix lock leak w/ ARP filtering and w/o CONFIG_INET
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      zd1211rw: change ZD_REGDOMAIN_JAPAN_* naming
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      libertas: mark lbs_ret_802_11d_domain_info static
      ath9k: declare MODULE_FIRMWARE for ath9k_htc
      rtl8180: mark rtl8180_beacon_work static
      mac80211: don't shadow mgmt variable in ieee80211_rx_h_action
      minstrel_ht: make *idx unsigned in minstrel_downgrade_rate
      wireless: mark reg_mutex as static
      minstrel_ht: move minstrel_mcs_groups declaration to header file
      mac80211: avoid scheduling while atomic in mesh_rx_plink_frame
      mac80211: use netif_receive_skb in ieee80211_rx callpath
      mac80211: use netif_receive_skb in ieee80211_tx_status callpath
      mac80211: remove unnecessary check in ieee80211_dump_survey
      mac80211: add basic tracing to drv_get_survey
      ath9k: remove unused function ath9k_hw_keyisvalid
      ath9k: make ath9k_hw_keysetmac static
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      mac80211: remove wep dependency
      MAINTAINERS: mark adm8211 as an orphan
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      libertas: convert new uses of __attribute__ ((packed)) to __packed
      iwlwifi: convert new uses of __attribute__ ((packed)) to __packed
      mac80211: improve error checking if WEP fails to init
      wireless: only use alpha2 regulatory information from country IE
      wireless: correct sparse warning in lib80211_crypt_tkip.c
      wireless: correct sparse warning in wext-compat.c
      wireless: correct sparse warning in generated regdb.c
      wireless: mark cfg80211_is_all_idle as static
      ath9k: correct sparse identified endian bug in ath_paprd_calibrate
      ipw2100: mark ipw2100_pm_qos_req static
      libipw: correct sparse warnings and mark some variables static
      rt2x00: correct sparse warning in rt2x00debug.c
      wireless: remove unnecessary reg_same_country_ie_hint
      mwl8k: correct/silence sparse warnings
      rtl8180: improve signal reporting for rtl8185 hardware
      b43: silence most sparse warnings
      iwlagn: use __packed on new structure definitions
      wl1251: fix sparse-generated warnings
      rtl8180: improve signal reporting for actual rtl8180 hardware
      rtl8180: silence "dubious: x | !y" sparse warning
      MAINTAINERS: mark prism54 obsolete
      MAINTAINERS: orphan the raylink wireless driver
      MAINTAINERS: orphan the zd1201 wireless driver
      MAINTAINERS: remove entry for wavelan
      iwlwifi: assume vif is NULL for internal scans and non-NULL otherwise
      minstrel_ht: remove unnecessary NULL check in minstrel_ht_update_caps
      minstrel: don't complain about feedback for unrequested rates
      lib80211: remove unused host_build_iv option
      Merge branch 'master' of git://git.kernel.org/.../holtmann/bluetooth-next-2.6
      p54: Added get_survey callback in order to get channel noise
      Merge branch 'master' of git://git.kernel.org/.../holtmann/bluetooth-next-2.6
      ath9k: enable serialize_regmode for non-PCIE AR9160
      mwl8k: add get_survey callback in order to get channel noise
      ar9170: add get_survey callback in order to get channel noise
      wl1251: add get_survey callback in order to get channel noise
      libertas_tf: add get_survey callback in order to get channel noise
      wl1271: add get_survey callback in order to get channel noise
      wl1251: update hw/fw version info in wiphy struct
      wl1271: update hw/fw version info in wiphy struct
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Jon Mason (7):
      s2io: add dynamic LRO disable support
      vxge: Remove queue_state references
      vxge: Fix multicast issues
      vxge: NETIF_F_LLTX removal
      vxge: Update copyright information
      vxge: Update maintainers information
      vxge: Version update

Jonas Bonn (8):
      ethoc: calculate number of buffers in ethoc_probe
      ethoc: Write bus addresses to registers
      ethoc: write number of TX buffers in init_ring
      ethoc: Clean up PHY probing
      Remove unused variable
      ethoc: Clear command buffer after write
      ethoc: use devres resource management
      ethoc: add devinit/devexit section initializers

Josh Hunt (1):
      net: Add getsockopt support for TCP thin-streams

Jouni Malinen (3):
      mac80211: Protect Deauthentication frame when using MFP
      mac80211: Use a separate CCMP PN receive counter for management frames
      mac80211: Fix key freeing to handle unlinked keys

Jo√£o Paulo Rechi Vita (8):
      Bluetooth: Fix SREJ_QUEUE corruption in L2CAP
      Bluetooth: Fix l2cap_sock_connect error return.
      Bluetooth: Make l2cap_streaming_send() void.
      Bluetooth: Fix error return value on sendmsg.
      Bluetooth: Fix error return value on sendmsg.
      Bluetooth: Fix error return for l2cap_connect_rsp().
      Bluetooth: Fix error value for wrong FCS.
      Bluetooth: Fix error return on L2CAP-HCI interface.

Julia Lawall (25):
      net/can: Use memdup_user
      drivers/net: Use memdup_user
      drivers/net/cxgb3: Use memdup_user
      drivers/net/wan: Use memdup_user
      net/dccp: Use memdup_user
      drivers/net/wan: Use memdup_user
      drivers/isdn: Use memdup_user
      drivers/net/wireless/orinoco: Use kzalloc
      drivers/net/wireless/libertas: Use kmemdup
      drivers/net/wireless/wl12xx: Use kmemdup
      drivers/net/wireless/libertas_tf: Use kmemdup
      drivers/net/wireless/iwmc3200wifi: Use kmemdup
      drivers/net/wireless/ath/ath9k: Use kmemdup
      drivers/net/wireless/b43: Use kmemdup
      drivers/net/wireless/ipw2x00: Use kmemdup
      drivers/net/wireless/p54: Use kmemdup
      drivers/net/wireless/orinoco: Use kmemdup
      drivers/net/wireless/prism54: Use memdup_user
      forcedeth: correct valid flag
      Bluetooth: Use kmemdup for drivers
      Bluetooth: Use kzalloc for drivers
      arch/um/drivers: remove duplicate structure field initialization
      qeth: Use memdup_user when user data is immediately copied into the allocated region.
      drivers/net/wireless/wl12xx: Use kmemdup
      net/rose: Use GFP_ATOMIC

Junchang Wang (2):
      8139too: remove unnecessary cast of ioread32()'s return value
      r8169: remove unnecessary cast of readl()'s return value

Jussi Kivilinna (1):
      rndis_wlan: increase assocbuf size and validate association info offsets from driver

Justin P. Mattock (4):
      wireless:hostap_main.c warning: variable 'iface' set but not used
      wireless:hostap_ap.c Fix warning: variable 'fc' set but not used
      net: Fix a typo in netlink.h
      Bluetooth: Fix warning: variable 'tty' set but not used

Juuso Oikarinen (23):
      wl1271: Update handling of the NVS file / INI parameters
      wl1271: Add support for NVS files with 5GHz band parameters
      wl1271: Prevent dropping of TX frames in joins
      wl1271: Idle handling into own function
      wl1271: Flush TX buffers to air before going to idle
      wl1271: Use proper rates for PSM entry/exit null-funcs for 5GHz
      wl1271: Fix scan parameter handling for 5GHz
      mac80211: Add support for hardware ARP query filtering
      mac80211: Add netif state checking to ieee80211_ifa_changed
      mac80211: Fix circular locking dependency in ARP filter handling
      mac80211: Fix ps-qos network latency handling
      mac80211: Add interface for driver to temporarily disable dynamic ps
      cfg80211/mac80211: Update set_tx_power to use mBm instead of dBm units
      nl80211: Add option to adjust transmit power
      wl1271: Remove calibration from join command
      wl1271: Add TSF handling
      wl1271: Use the ARP configuration function from mac80211
      wl1271: Use all basic rates for ps-poll, instead of just the slowest
      wl1271: Work around AP's with broken ps-poll functionality
      wl1271: Update hardware ARP filtering configuration handling
      wl1271: Disable dynamic PS based on BT co-ext sense events
      wl1271: Fix warning when disconnecting and ad-hoc network
      wl1271: Update interface to temporarily disable dynamic PS

Karl Hiramoto (9):
      atm: propagate signal changes via notifier
      atm/br2684: register notifier event for carrier signal changes.
      atm/adummy: add syfs DEVICE_ATTR to change signal
      atm/idt77105.c: call atm_dev_signal_change() when signal changes.
      atm/solos-pci: call atm_dev_signal_change() when signal changes.
      atm/suni.c: call atm_dev_signal_change() when signal changes.
      usb/atm/cxacru.c: call atm_dev_signal_change() when signal changes.
      usb/atm/speedtch.c: call atm_dev_signal_change() when signal changes.
      usb/atm/ueagle-atm.c: call atm_dev_signal_change() when signal changes.

Kiran Divekar (3):
      Libertas: cfg80211 support
      Libertas: fix WARN_ON issues in cfg80211 support
      Libertas: Added 11d support using cfg80211

Klaus-Dieter Wacker (1):
      qeth: IP address takeover flag setting

Konstantin Khorenko (1):
      tcp: do not send reset to already closed sockets

Kouhei Sutou (1):
      zd1211rw: add 0x49 -> JP regulatory domain map

Krzysztof Ha≈Çasa (1):
      Tulip: don't initialize SBE xT3E3 WAN ports.

Kulikov Vasiliy (44):
      net/neighbour.h: fix typo
      sun3_82586: Use the instance of net_device_stats from net_device.
      davinci_emac: Use the instance of net_device_stats from net_device.
      fealnx: Use the instance of net_device_stats from net_device.
      ethoc: Use the instance of net_device_stats from net_device.
      epic100: Use the instance of net_device_stats from net_device.
      cs89x0: Use the instance of net_device_stats from net_device.
      hamachi: Use the instance of net_device_stats from net_device.
      starfire: Use the instance of net_device_stats from net_device.
      hp100: Use the instance of net_device_stats from net_device.
      lance: Use the instance of net_device_stats from net_device.
      ksz884x: Use the instance of net_device_stats from net_device.
      natsemi: Use the instance of net_device_stats from net_device.
      mac89x0: Use the instance of net_device_stats from net_device.
      ns83820: Use the instance of net_device_stats from net_device.
      ni52: Use the instance of net_device_stats from net_device.
      ax88796: free irq on error
      ll_temac: fix memory leak
      fec_mpc52xx: fix error path
      82596: do not panic on out of memory
      82596: free resources on error
      at1700: fix double free_irq
      ac3200: fix error path
      adm8211: fix memory leak
      depca: fix leaks in depca_module_init()
      tc35815: fix iomap leak
      jazzsonic: free irq if sonic_open() fails
      macsonic: free irqs if sonic_open() fails
      xtsonic: free irq if sonic_open() fails
      wireless: airo: delete netdev from list after it is freed
      tulip: formatting of pointers in printk()
      wd: fix memory leak
      eth16i: fix memory leak
      drivers: irda: fix sign bug
      drivers: irda: fix sign bug
      drivers: ixgbevf: fix unsigned underflow
      net: bridge: fix sign bug
      net: dccp: fix sign bug
      Bluetooth: Silence warning in btmrvl SDIO driver
      drivers/net/irda: use for_each_pci_dev()
      3c59x: handle pci_iomap() errors
      net: 3c59x: fix leak of iomaps
      net: s2io: fix buffer overflow
      usbnet: use jiffies in schedule_timeout(), not msecs

Larry Finger (3):
      ssb: Handle alternate SSPROM location
      b43: Clarify logged message after fatal DMA error and switch to PIO mode
      b43: silence phy_n sparse warnings

Leann Ogasawara (1):
      p54usb: Comment out duplicate Medion MD40900 device id

Lennert Buytenhek (1):
      mwl8k: change maintenance status

Luciano Coelho (7):
      wl1271: the core wl1271 module shouldn't depend on SPI_MASTER
      netfilter: xtables: idletimer target implementation
      wl1271: read fem manufacturer value from nvs
      wl1271: moved scan operations to a separate file
      wl1271: rewritten scanning code
      wl1271: use per-channel max tx power passed by mac80211 when scanning
      wl1271: use __packed annotation

Luis R. Rodriguez (26):
      ath9k_hw: add support for the AR9003 2.2
      ath9k_hw: rename the ar9003_initvals.h to ar9003_2p0_initvals.h
      ath9k_hw: add support for the AR9003 baseband watchdog
      ath9k: enable the baseband watchdog events for AR9003
      ath9k_hw: Enable TX IQ calibration on AR9003
      ath9k_hw: move clock definitions from hw.c to hw.h
      ath9k_hw: fix clock rate calculations for ANI
      ath9k_hw: clear MIB interrupt causes when skipping ANI adjustments
      ath9k_hw: allow for spliting up ANI operations by family
      ath9k_hw: add register definitions for the new ANI
      ath9k_hw: inform ANI calibration when scanning
      ath9k: add new ANI implementation for AR9003
      ath9k_hw: enable ANI for AR9003
      ath9k_hw: reduce delay on programming INI on AR9003
      ath9k_hw: update 5 GHz tx gain tables for femless and high power PA
      ath9k: enable AR9003 PCI IDs
      ath9k_hw: avoid setting cwmin/cwmax to 0 for IBSS for AR9003
      ath9k_hw: fix ASPM setting for AR9003
      ath9k_hw: move LowPower array writes to ar9003_hw_configpcipowersave()
      ath9k_hw: add pcieSerDesWrite to disable SERDES ASPM tweaks
      ath9k_hw: dynamically choose the SERDES array for low power
      ath9k_hw: add an extra delay when reseting AR_RTC_RESET
      ath9k_htc: make ath9k_htc_tx_aggr_oper() static
      ath9k_hw: Fix AR9003 MPDU delimeter CRC check for middle subframes
      ath9k: remove the two wiphys scanning at the same time message
      Revert "mac80211: fix sw scan bracketing"

Luke-Jr (1):
      p54spi: replace internal "cx3110x" name with "p54spi"

Magnus Damm (1):
      b43: Add SDIO_DEVICE() for EW-CG1102GC

Marc Kleine-Budde (1):
      CAN: Add Flexcan CAN controller driver

Marcel Holtmann (1):
      Bluetooth: Defer SCO setup if mode change is pending

Matt Carlson (32):
      tg3: Relocate APE mutex regs for 5717+
      tg3: Avoid tx lockups on 5755+ devices
      tg3: Fix a memory leak on 5717+ devices
      tg3: Off-by-one error in RSS setup
      tg3: Allow single MSI-X vector allocations
      tg3: 5717: Allow serdes link via parallel detect
      tg3: Use devfn to determine function number
      tg3: Add 5719 ASIC rev
      tg3: Add 5719 PCI device and phy IDs
      tg3: Update version to 3.111
      tg3: Revert RSS indir tbl setup change
      tg3: Fix single MSI-X vector coalescing
      tg3: Fix IPv6 TSO code in tg3_start_xmit_dma_bug()
      tg3: Relax 5717 serdes restriction
      tg3: Report driver version to firmware
      tg3: Revert PCIe tx glitch fix
      tg3: Fix some checkpatch errors
      tg3: Update version to 3.112
      tg3: Add 5784 ASIC rev to earlier PCIe MPS fix
      tg3: Disable TSS also during tg3_close()
      tg3: Create TG3_FLG3_5717_PLUS flag
      tg3: Don't access phy test ctrl reg for 5717+
      tg3: Manage gphy power for CPMU-less devs only
      tg3: Restrict ASPM workaround devlist
      tg3: Detect APE firmware types
      tg3: Remove 5720, 5750, and 5750M
      tg3: Improve small packet performance
      tg3: Add error reporting to tg3_phydsp_write()
      tg3: Add phy-related preprocessor constants
      tg3: Create phy_flags and migrate phy_is_low_power
      tg3: Migrate tg3_flags to phy_flags
      tg3: Update version to 3.113

Matthias Fuchs (1):
      can: Add driver for esd CAN-USB/2 device

Maxime Bizon (1):
      cfg80211: fix race between sysfs and cfg80211

Michael Chan (19):
      bnx2: Fix compiler warning in bnx2_disable_forced_2g5().
      cnic: Return error code in cnic_cm_close() if unsuccessful.
      cnic: Refactor code in cnic_cm_process_kcqe().
      cnic: Refactor and fix cnic_ready_to_close().
      cnic: Fix cnic_cm_abort() error handling.
      cnic: Fine-tune CID memory space calculation.
      cnic: Unify IRQ code for all hardware types.
      cnic: Unify kcq allocation for all devices.
      cnic: Restructure kcq processing.
      cnic: Further unify kcq handling code.
      cnic: Update version to 2.1.3.
      bnx2: Always enable MSI-X on 5709.
      bnx2: Add support for skb->rxhash.
      bnx2: Dump some config space registers during TX timeout.
      bnx2: Update version to 2.0.16.
      bnx2: Use proper counter for net_device_stats->multicast.
      bnx2: Call pci_enable_msix() with actual number of vectors.
      bnx2: Remove some unnecessary smp_mb() in tx fast path.
      bnx2: Update version to 2.0.17.

Michael S. Tsirkin (4):
      vhost: whitespace fix
      netfilter: add CHECKSUM target
      netfilter: correct CHECKSUM header and export it
      vhost: apply cgroup to vhost workers

Michal Marek (1):
      ipvs: Kconfig cleanup

Mike Ditto (1):
      forcedeth: Fix different hardware statistics versions.

Mike McCormack (1):
      sky2: Code style fixes

Ming Lei (4):
      ath9k: fix dma direction for map/unmap in ath_rx_tasklet
      ath9k: fix dma sync in rx path
      minstrel_ht: fix updating rate with best probability
      minstrel_ht: fix check for downgrading of top2 rate

Nathan Holstein (1):
      Bluetooth: Fix bug with ERTM minimum packet length

Neil Horman (2):
      drop_monitor: Add error code to detect duplicate state changes
      drop_monitor: convert some kfree_skb call sites to consume_skb

Nick Chalk (1):
      IPVS: one-packet scheduling

Nick Nunley (3):
      igb: fix PHY config access on 82580
      igb: add support for SGMII-based MDIO PHYs
      igb: restore EEPROM values of MDICNFG on reset with 82580

Nicolas Dichtel (1):
      __dst_free(): put EXPORT_SYMBOLS after the fct

Nicolas Kaiser (3):
      net/Makefile: conditionally descend to wireless and ieee802154
      drivers/net/Makefile: conditionally descend to wireless
      usb: pegasus: fixed coding style issues

Nicolas de Peslo√ºan (1):
      bonding: fix a buffer overflow in bonding_show_queue_id.

Nolan Leake (1):
      tun: keep link (carrier) state up to date

Ohad Ben-Cohen (1):
      wl1271: remove sdio ARM dependency

Oliver Hartkopp (1):
      can-raw: Fix skb_orphan_try handling

Oliver Neukum (1):
      usbnet: remove direct access to urb->status

Ondrej Zary (1):
      rt2500usb: fallback to SW encryption for TKIP+AES

Pablo Neira Ayuso (2):
      nfnetlink_log: do not expose NFULNL_COPY_DISABLED to user-space
      netfilter: nf_ct_tcp: fix flow recovery with TCP window	tracking enabled

Patrick McHardy (5):
      Merge branch 'master' of /repos/git/net-next-2.6
      netfilter: nf_nat: support user-specified SNAT rules in LOCAL_IN
      netfilter: ipt_LOG/ip6t_LOG: remove comparison within loop
      netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC header
      bridge: add per bridge device controls for invoking iptables

Pavel Roskin (1):
      ath9k: remove unneeded calculation of minimal calibration power

Pedro Garcia (1):
      vlan_dev: VLAN 0 should be treated as "no vlan tag" (802.1p packet)

Peter Huewe (12):
      atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      atm: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      isdn/hardware/mISDN: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      mISDN: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      isdn/hardware/eicon: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      mISDN: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
      isdn/hisax: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)

Prarit Bhargava (2):
      vxge: Fix checkstack warning in vxge_probe()
      ath: Fix uninitialized variable warnings

Rafa≈Ç Mi≈Çecki (2):
      ssb: update PMU init to match specs
      ssb: fast powerup delay calculation for PMU capable devices

Rajesh Borundia (3):
      qlcnic: fix pause params setting
      netxen: fix for kdump
      qlcnic: fix bandwidth check

Rajesh K Borundia (2):
      qlcnic: fix race in tx stop queue
      qlcnic: Add support for configuring eswitch and npars

Rajkumar Manoharan (1):
      ath9k: fix panic while cleaning up virtaul wifis

Ralf Baechle (1):
      ioc3-eth: Use the instance of net_device_stats from net_device.

Rami Rosen (3):
      cleanup: remove MIN_FRAG_SIZE definition.
      fix return value of __pppoe_xmit() method.
      cleanup: remove pppoe_xmit() declaration.

Randy Dunlap (2):
      netfilter: xt_IDLETIMER needs kdev_t.h
      net: ks8842 depends on DMA_ENGINE

Reinette Chatre (3):
      iwlwifi: fix and add missing sta_lock usage
      Merge branch 'wireless-2.6' into wireless-next-2.6
      iwlagn: reduce severity of disconnected antennas warning

Richard Cochran (5):
      ixp4xx: Support the all multicast flag on the NPE devices.
      net: add driver hook for tx time stamping.
      net: preserve ifreq parameter when calling generic phy_mii_ioctl().
      net: added a BPF to help drivers detect PTP packets.
      net: support time stamping in phy devices.

Richard R√∂jfors (5):
      ks8842: Replace usage of dev_dbg with netdev_dbg
      ks8842: Do the TX timeout work in workqueue context.
      ks8842: Remove unnecessary bank select.
      ks8842: Support 100Mbps when accessed via timberdale
      ks8842: Support DMA when accessed via timberdale

Roland Dreier (1):
      chelsio: Remove remnants of CONFIG_CHELSIO_T1_COUGAR

Ron Mercer (6):
      qlge: Restore promiscuous setting after reset.
      qlge: Don't use firmware when forcing firmware dump.
      qlge: Reduce print level in data path statements.
      qlge: Fix possible endian issue for rx UDP csum.
      qlge: Make adapter drop frame errors and pass up csum errors.
      qlge: Change version to v1.00.00.25.00.00-01.

Ron Shaffer (2):
      Bluetooth: Remove extraneous white space
      Bluetooth: Reassigned copyright to Code Aurora Forum

Ronghua Zang (1):
      net-next: vmxnet3 fixes [2/5] Interrupt control bitmap

Sarveshwar Bandi (1):
      be2net: Patch to determine if function is VF while running in guest OS.

Sascha Silbe (1):
      libertas: Fix ethtool reporting no WOL options supported if WOL is not already active

Sathya Perla (3):
      be2net: cleanup in case of error in be_open()
      be2net: replace udelay() with schedule_timeout() in mbox polling
      be2net: memory barrier fixes on IBM p7 platform

Scott McMillan (1):
      packet_mmap: expose hw packet timestamps to network packet capture utilities

Sebastian Andrzej Siewior (1):
      net/core: use ntohs for skb->protocol

Sebastian Smolorz (2):
      at76c50x-usb: Move function at76_join() several lines up
      at76c50x-usb: Extract bssid from authentication frame

Senthil Balasubramanian (4):
      ath9k: Introduce bit masks for valid and valid_single_stream.
      ath9k: Add three stream rate control support for AR938X.
      ath9k: Fix incorrect user ratekbs of MCS15 ShortGI
      ath9k: remove unused base_index from rate table.

Sergey Matyukevich (2):
      ucc_geth driver: add ioctl
      ucc_geth: fix UCC device number in debug message

Shan Wei (4):
      netfilter: xt_sctp: use WORD_ROUND macro to calculate length of multiple of 4 bytes
      netfilter: kill redundant check code in which setting ip_summed value
      netfilter: defrag: remove one redundant atomic ops
      netfilter: defrag: kill unused work parameter of frag_kfree_skb()

Shanyu Zhao (4):
      iwlwifi: enable remaining 6000 Gen2 devices
      iwlwifi: add new PCI IDs for 6000g2 devices
      iwlwifi: do not clear data after chain noise calib
      iwlwifi: enable 6050 series Gen2 devices

Shirley Ma (1):
      ixgbevf: Enable GRO by default

Shreyas Bhatewara (4):
      net-next: fix LRO feature update in vmxnet3
      net-next: vmxnet3 fixes [3/5] Initialize link state at probe time
      net-next: vmxnet3 fixes [4/5] Do not reset when the device is not opened
      net-next: vmxnet3 fixes [5/5] Respect the interrupt type in VM configuration

Simon Horman (2):
      ipvs: remove EXPERIMENTAL tag
      ipvs: provide default ip_vs_conn_{in,out}_get_proto

Sjur Braendeland (6):
      caif: Bugfix not all services uses flow-ctrl.
      caif: Bugfix - RFM must support segmentation.
      caif: Use link layer MTU instead of fixed MTU
      caif: Add debug connection type for CAIF.
      caif: Kconfig and Makefile fixes
      caif-driver: Add CAIF-SPI Protocol driver.

Sonic Zhang (1):
      netdev:bfin_mac: reclaim and free tx skb as soon as possible after transfer

Sony Chacko (1):
      qlcnic: fix diag resource allocation

Sridhar Samudrala (2):
      macvlan: Fix rx counters update in macvlan_handle_frame()
      cgroups: Add an API to attach a task to current task's cgroup

Sriram (3):
      TI DaVinci EMAC : Implement interrupt pacing functionality.
      TI DaVinci EMAC: Fix asymmetric handling of packets in NAPI Poll function.
      TI DaVinci EMAC: Fix incorrect reference to EMAC_CTRL registers.

Sritej Velaga (1):
      qlcnic: change driver description

Stanislaw Gruszka (12):
      e1000e: fail when try to setup unsupported features
      vmxnet3: fail when try to setup unsupported features
      bnx2x: fail when try to setup unsupported features
      netxen: fail when try to setup unsupported features
      qlcnic: fail when try to setup unsupported features
      ixgbe: use NETIF_F_LRO
      bnx2: allocate with GFP_KERNEL flag on RX path init
      bnx2: use device model DMA API
      rt2500usb: write keys to proper registers
      rt2500usb: truly disable encryption when initialize
      rt2500usb: disallow to set WEP key with non zero index
      iwlwifi: fix scan abort

Stefan Assmann (2):
      sysfs: add attribute to indicate hw address assignment type
      igbvf, ixgbevf: use dev_hw_addr_random

Stephen Hemminger (2):
      gre: propagate ipv6 transport class
      net: ingress filter message limit

Stephen Rothwell (1):
      net: bnx2x_cmn.c needs net/ip6_checksum.h for csum_ipv6_magic

Steve Hodgson (9):
      sfc: Reschedule any resets scheduled inside efx_pm_freeze()
      sfc: Workaround flush failures on Falcon B0
      sfc: Synchronise link_advertising and wanted_fc on Siena
      sfc: Wait for the link to stay up before running loopback selftest
      sfc: Allow DRV_GEN events to be used outside of selftests
      sfc: Remove efx_rx_queue::add_lock
      sfc: Support only two rx buffers per page
      sfc: Recycle discarded rx buffers back onto the queue
      sfc: Allow shared pages to be recycled

Steven Walter (2):
      tulip: explicity set to D0 power state during init
      tulip: implement wake-on-lan support

Sucheta Chakraborty (2):
      qlcnic: fix device soft reset
      qlcnic: aer support

Sujith (38):
      ath9k_htc: Add queue statistics to xmit debugfs file
      ath9k_htc: Initialize beacon/CAB queues
      ath9k_htc: Remove HW queue translation
      ath9k_htc: Increase credit size
      ath9k_htc: Initvals update for AR9271
      ath9k_htc: Cleanup rate initialization
      ath9k_htc: Update HT configuration properly
      ath9k_htc: Enable SGI in HT20 for AR9271
      ath9k_htc: Enable RX STBC for AR9271
      ath9k: Move ath9k specific RX code to driver
      ath9k: Move driver specific structures
      ath9k_hw: Cleanup eeprom_9287.c
      ath9k_hw: Optimize ath9k_hw_ar9287_set_board_values
      ath9k_hw: Cleanup TX power calculation for AR9287
      ath9k_hw: Update the PCI WAR register
      ath9k_hw: Fix async fifo for AR9287
      ath9k_htc: Revamp CONF_IDLE handling
      ath9k_htc: Add PS wrappers
      ath9k_htc: Fix bug in handling CONF_IDLE
      ath9k_htc: Remove useless cancel_work_sync
      ath9k_htc: Fix locking for ps_idle
      ath9k_htc: Handle monitor interface removal
      ath9k_htc: Handle host RX disable
      ath9k_htc: Fix fair beacon distribution
      ath9k_htc: Use proper station add/remove callbacks
      mac80211: Remove deprecated sta_notify commands
      ath9k: Determine Firmware on probe
      ath9k_hw: Configure byte swap for non AR9271 chips
      ath9k_htc: Add support for AR7010
      ath9k_common: Move count_streams to common module
      ath9k_htc: Setup HT capabilites for 2-stream devices
      ath9k_htc: Configure dual stream rates
      ath9k_htc: Setup 5GHz channels
      ath9k_htc: Configure credit size for AR7010
      ath9k_htc: Fix ampdu_action callback
      ath9k_htc: Update supported product list
      ath9k_htc: Add LED support for AR7010
      mac80211: Don't set per-BSS QoS for monitor interfaces

Suraj Sumangala (5):
      Bluetooth: Add one more buffer for HCI stream reassembly
      Bluetooth: Implement hci_reassembly helper to reassemble RX packets
      Bluetooth: Modified hci_recv_fragment() to use hci_reassembly helper
      Bluetooth: Implemented HCI frame reassembly for RX from stream
      Bluetooth: Support for Atheros AR300x serial chip

Teemu Paasikivi (3):
      mac80211: Set basic rates while joining ibss network
      mac80211: Set changed basic rates flag
      mac80211: remove BSS from cfg80211 list when leaving IBSS

Tejun Heo (1):
      vhost: replace vhost_workqueue with per-vhost kthread

Tetsuo Handa (1):
      net: Remove MAX_SOCK_ADDR constant

Tilman Schmidt (13):
      Documentation/isdn: CAPI controller interface amendment
      isdn: avoid calling tty_ldisc_flush() in atomic context
      isdn/gigaset: adjust usb_gigaset tty write buffer limit
      isdn/gigaset: avoid copying AT commands twice
      isdn/gigaset: ignore irrelevant device responses
      isdn/gigaset: drop debug check on isochronous write
      isdn/gigaset: improve CAPI message debugging
      isdn/gigaset: handle Supplementary Service Listen
      isdn/gigaset: remove obsolete compile time options
      isdn/gigaset: reduce syslog spam
      isdn/gigaset: fix leaks in error path
      isdn/gigaset: document dial-out number format
      isdn/gigaset: remove EXPERIMENTAL tag from GIGASET_CAPI

Tim Gardner (2):
      netfilter: xt_connbytes: Force CT accounting to be enabled
      netfilter: complete the deprecation of CONFIG_NF_CT_ACCT

Tobias Klauser (4):
      vhost: Storage class should be before const qualifier
      drivers/net/wireless: Storage class should be before const qualifier
      greth: Remove unnecessary memset of napi member in netdev private data
      s2io: Remove unnecessary memset of netdev private data

Tom Herbert (1):
      tcp: Fix slowness in read /proc/net/tcp

Ursula Braun (8):
      smsgiucv: guarantee single iucv connect in thaw
      qeth: specify correct function level for OSN devices
      qeth: handle missing z/VM authorization of OSX
      qeth: serialize sysfs-triggered device configurations
      qeth: avoid loop if ipa command response is missing
      claw: A claw device is a group of just 2 ccw devices
      qeth: return zero from reply callback functions
      qeth: avoid useless removal of multicast addresses

Uwe Kleine-K√∂nig (2):
      cfg80211: move cfg80211_exit to .exit.text
      wireless: move regulatory_init to .init.text

Vasanthakumar Thiagarajan (12):
      ath9k: Enable Short GI in 20 Mhz for ar9287 and later chips
      ath9k: Make sure null func frame is acked before going into PS for ar9003
      ath9k: Fix power save with auto sleeping
      ath9k_hw: Enable auto sleep for ar9003
      ath9k: Clean up few function parameters in recv.c
      ath9k: Fix bug in accessing skb->data of rx frame for edma
      ath9k: Fix bug in validating received data length for edma
      ath9k: Fix bug in rate table
      ath9k: Fix bug in paprd
      ath9k: Remove unused paprd_txok
      ath9k: Wakeup the chip in an appropriate place in ath_paprd_calibrate()
      ath9k: Fix inconsistency between txq->stopped and the actual queue state

Vasanthy Kolluri (10):
      enic: Feature Add: Replace LRO with GRO
      enic: Bug Fix: Change hardware ingress vlan rewrite mode
      enic: Use a lighter reset operation for enic devices
      enic: Clean up: Add wrapper routines for firmware devcmd calls
      enic: Use (netdev|dev|pr)_<level> macro helpers for logging
      enic: Add new firmware devcmds
      enic: Use receive queue buffer blocks of 32/64 entries
      enic: Feature Add: Add loopback capability to enic devices
      enic: Bug Fix: Handle surprise hardware removals
      enic: Clean ups

Vivek Natarajan (2):
      ath9k: Add a module parameter to disable led blinking.
      ath9k: Fix the LED behaviour in idle unassociated state.

Vladislav Zolotarov (1):
      bnx2x: Set RXHASH for LRO packets

Walter Goldens (1):
      wireless: fix several minor description typos

Wan ZongShun (1):
      net/nuc900: enable Mac driver clock

Wey-Yi Guy (41):
      iwlwifi: move _agn statistics related structure
      iwlwifi: separate statistics flag function for agn & 3945
      iwlwifi: code cleanup for _agn devices
      iwlwifi: modify out-dated comments
      iwlwifi: move ucode related function to iwl-agn-ucode.c
      iwlwifi: remove unused parameter in iwl_priv
      iwlwifi: beacon format related helper function
      iwlwifi: support channel switch offload in driver
      iwlwifi: beacon internal time unit
      iwlwifi: remove inaccurate comment
      iwlwifi: do not use huge command buffer for channel switch
      iwlwifi: remove unused parameter
      iwlwifi: cancel run time calibration work when going down
      iwlwifi: move agn specific rx related code to iwl-agn-rx.c
      iwlwifi: move _agn statistics related structure
      iwlwifi: move calibration from iwlcore to iwlagn
      iwlwifi: code cleanup to remove un-necessary "goto"
      iwlwifi: remove non-exist reference
      iwlwifi: name change from signal protection flag
      iwlwifi: enable DC calibration based on config parameter
      iwlwifi: add a mechanism to disable plcp error checking
      iwlwifi: turn on RTS/CTS after aggregation become operational
      iwlwifi: add disable rf calibration support for 6000g2a and 6000g2b
      iwlwifi: fix fw_restart module parameter
      iwlwifi: add debug print for parsing firmware TLV
      iwlwifi: tx fifo queue flush command
      iwlwifi: add mac80211 flush callback support
      iwlwifi: add support for device tx flush request
      iwlwifi: debugfs file for txfifo command testing
      iwlwifi: generic parameter define for _agn device
      iwlwifi: adding enhance sensitivity table entries
      iwlagn: more generic description for iwlagn devices
      iwlwifi: additional statistic debug counter
      iwlwifi: more statistics counter for agn in debugfs
      iwlwifi: "recover_from_tx_stall" function for 4965
      iwlagn: add statistic notification structure for WiFi/BT devices
      iwlagn: add .cfg flag to idenfity the need for bt statistics
      iwlagn: Add support for bluetooth statistics notification
      iwlagn: add bluetooth stats to debugfs
      iwlwifi: add TLV to specify the size of phy calibration table
      iwlwifi: read multiple MAC addresses

Wolfram Sang (2):
      net/mpc52xx_phy: Various code cleanups
      net/fec: restore interrupt mask after software-reset in fec_stop()

Wu Fengguang (2):
      ipconfig: send host-name in DHCP requests
      ipconfig: document DHCP hostname and DNS record

Xiaoyu Du (1):
      ipvs: lvs sctp protocol handler is incorrectly invoked ip_vs_app_pkt_out

Yaniv Rosner (1):
      bnx2x: Fix link problem with some DACs

Yi Zou (2):
      ixgbe: properly toggling netdev feature flags when disabling FCoE
      ixgbe: use GFP_ATOMIC when allocating FCoE DDP context from the dma pool

Yoshihiro Shimoda (1):
      net: sh_eth: add support for SH7757's ETHER

Yuri Ershov (3):
      mac80211: Put some code under MESH macro
      nl80211: Fix memory leaks
      cfg80211: Update of regulatory request initiator handling

chas williams - CONTRACTOR (5):
      atm: [nicstar] reformatted with Lindent
      atm: [nicstar] remove virt_to_bus() and support 64-bit platforms
      atm: [he] remove small buffer allocation/handling code
      atm: [he] rewrite buffer handling in receive path
      atm: remove IRQF_DISABLED in combination with IRQF_SHARED

jamal (2):
      net sched: make pedit check for clones instead
      net: Remove unnecessary net action assertion

schacko (1):
      qlcnic: seperate interrupt for TX

stephen hemminger (3):
      ppp: eliminate shadowed variable name
      bridge: add rcu_read_lock on transmit
      u32: negative offset fix

ubuntu@tjworld.net (1):
      ipw2200: Enable LED by default

 Documentation/feature-removal-schedule.txt         |    9 -
 Documentation/filesystems/nfs/nfsroot.txt          |    2 +
 Documentation/isdn/INTERFACE.CAPI                  |    8 +-
 Documentation/isdn/README.gigaset                  |  117 +-
 Documentation/kernel-parameters.txt                |    3 +-
 Documentation/networking/README.ipw2200            |    2 +-
 Documentation/networking/bonding.txt               |   84 +-
 Documentation/networking/caif/spi_porting.txt      |  208 +
 Documentation/networking/ip-sysctl.txt             |    2 +-
 Documentation/networking/packet_mmap.txt           |   26 +
 Documentation/networking/pktgen.txt                |    5 +
 MAINTAINERS                                        |   50 +-
 arch/microblaze/include/asm/system.h               |    3 -
 arch/powerpc/include/asm/system.h                  |    3 -
 arch/s390/appldata/appldata_net_sum.c              |    3 +-
 arch/um/drivers/net_kern.c                         |   10 +-
 arch/x86/include/asm/system.h                      |    7 +
 drivers/atm/Kconfig                                |    2 +-
 drivers/atm/adummy.c                               |   39 +
 drivers/atm/ambassador.c                           |    6 +-
 drivers/atm/eni.c                                  |    6 +-
 drivers/atm/firestream.c                           |    6 +-
 drivers/atm/he.c                                   |  310 +-
 drivers/atm/he.h                                   |   65 +-
 drivers/atm/idt77105.c                             |   11 +-
 drivers/atm/idt77252.c                             |    5 +-
 drivers/atm/nicstar.c                              | 5196 ++++----
 drivers/atm/nicstar.h                              |  602 +-
 drivers/atm/nicstarmac.c                           |  364 +-
 drivers/atm/solos-pci.c                            |    6 +-
 drivers/atm/suni.c                                 |    5 +-
 drivers/atm/zatm.c                                 |    6 +-
 drivers/base/core.c                                |   64 +
 drivers/bluetooth/Kconfig                          |   12 +
 drivers/bluetooth/Makefile                         |    1 +
 drivers/bluetooth/bcm203x.c                        |    3 +-
 drivers/bluetooth/bpa10x.c                         |    2 +-
 drivers/bluetooth/btmrvl_debugfs.c                 |    2 +-
 drivers/bluetooth/btmrvl_drv.h                     |    5 +-
 drivers/bluetooth/btmrvl_main.c                    |    5 +-
 drivers/bluetooth/btmrvl_sdio.c                    |  111 +-
 drivers/bluetooth/btusb.c                          |   13 +-
 drivers/bluetooth/dtl1_cs.c                        |    2 +-
 drivers/bluetooth/hci_ath.c                        |  235 +
 drivers/bluetooth/hci_bcsp.c                       |    4 +-
 drivers/bluetooth/hci_h4.c                         |  107 +-
 drivers/bluetooth/hci_ldisc.c                      |   20 +-
 drivers/bluetooth/hci_ll.c                         |    6 +-
 drivers/bluetooth/hci_uart.h                       |   15 +-
 drivers/infiniband/core/addr.c                     |    2 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |    4 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |    4 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |    2 +-
 drivers/infiniband/hw/nes/nes_nic.c                |    8 +-
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |    7 +-
 drivers/isdn/capi/capi.c                           |   12 +-
 drivers/isdn/capi/capidrv.c                        |    7 +-
 drivers/isdn/divert/divert_procfs.c                |    7 +-
 drivers/isdn/gigaset/Kconfig                       |    4 +-
 drivers/isdn/gigaset/bas-gigaset.c                 |   69 +-
 drivers/isdn/gigaset/capi.c                        |   66 +-
 drivers/isdn/gigaset/common.c                      |    2 -
 drivers/isdn/gigaset/ev-layer.c                    |  226 +-
 drivers/isdn/gigaset/gigaset.h                     |   16 +-
 drivers/isdn/gigaset/i4l.c                         |    4 +-
 drivers/isdn/gigaset/interface.c                   |   37 +-
 drivers/isdn/gigaset/ser-gigaset.c                 |   27 +-
 drivers/isdn/gigaset/usb-gigaset.c                 |   29 +-
 drivers/isdn/hardware/eicon/divamnt.c              |    7 +-
 drivers/isdn/hardware/eicon/divasi.c               |    2 -
 drivers/isdn/hardware/eicon/divasmain.c            |   71 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |    9 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |   92 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |   39 +-
 drivers/isdn/hisax/config.c                        |   84 +-
 drivers/isdn/hisax/q931.c                          |   13 +-
 drivers/isdn/hysdn/hysdn_procconf.c                |   21 +-
 drivers/isdn/hysdn/hysdn_proclog.c                 |   51 +-
 drivers/isdn/i4l/isdn_common.c                     |   27 +-
 drivers/isdn/i4l/isdn_net.c                        |    7 +-
 drivers/isdn/i4l/isdn_ppp.c                        |   13 +-
 drivers/isdn/i4l/isdn_tty.c                        |    6 -
 drivers/isdn/mISDN/timerdev.c                      |    7 +-
 drivers/isdn/pcbit/drv.c                           |   10 +-
 drivers/isdn/sc/ioctl.c                            |   23 +-
 drivers/net/3c527.h                                |    6 +-
 drivers/net/3c59x.c                                |  392 +-
 drivers/net/8139cp.c                               |    2 +-
 drivers/net/8139too.c                              |    8 +-
 drivers/net/82596.c                                |   64 +-
 drivers/net/Kconfig                                |   43 +-
 drivers/net/Makefile                               |    6 +-
 drivers/net/Space.c                                |    6 -
 drivers/net/ac3200.c                               |    2 +-
 drivers/net/arcnet/capmode.c                       |  177 +-
 drivers/net/arcnet/com20020-isa.c                  |    4 +-
 drivers/net/arcnet/com90io.c                       |    2 +-
 drivers/net/arm/ixp4xx_eth.c                       |   14 +-
 drivers/net/arm/w90p910_ether.c                    |    3 +
 drivers/net/at1700.c                               |    4 +-
 drivers/net/atl1c/atl1c.h                          |    9 +-
 drivers/net/atl1c/atl1c_hw.c                       |  107 +-
 drivers/net/atl1c/atl1c_hw.h                       |   49 +-
 drivers/net/atl1c/atl1c_main.c                     |  348 +-
 drivers/net/atlx/atl1.h                            |    4 +-
 drivers/net/au1000_eth.c                           |    2 +-
 drivers/net/ax88796.c                              |    4 +-
 drivers/net/b44.c                                  |  146 +-
 drivers/net/bcm63xx_enet.c                         |    2 +-
 drivers/net/benet/be.h                             |   31 +-
 drivers/net/benet/be_cmds.c                        |   91 +-
 drivers/net/benet/be_cmds.h                        |   48 +-
 drivers/net/benet/be_ethtool.c                     |   58 +-
 drivers/net/benet/be_hw.h                          |   12 +-
 drivers/net/benet/be_main.c                        |  376 +-
 drivers/net/bfin_mac.c                             |  123 +-
 drivers/net/bfin_mac.h                             |    5 +
 drivers/net/bnx2.c                                 |  264 +-
 drivers/net/bnx2.h                                 |   12 +-
 drivers/net/bnx2x/Makefile                         |    7 +
 drivers/net/{ => bnx2x}/bnx2x.h                    |  235 +-
 drivers/net/bnx2x/bnx2x_cmn.c                      | 2252 ++++
 drivers/net/bnx2x/bnx2x_cmn.h                      |  652 +
 drivers/net/{ => bnx2x}/bnx2x_dump.h               |    0
 drivers/net/bnx2x/bnx2x_ethtool.c                  | 1971 +++
 drivers/net/{ => bnx2x}/bnx2x_fw_defs.h            |    0
 drivers/net/{ => bnx2x}/bnx2x_fw_file_hdr.h        |    0
 drivers/net/{ => bnx2x}/bnx2x_hsi.h                |    0
 drivers/net/{ => bnx2x}/bnx2x_init.h               |    0
 drivers/net/{ => bnx2x}/bnx2x_init_ops.h           |    0
 drivers/net/{ => bnx2x}/bnx2x_link.c               |    8 +-
 drivers/net/{ => bnx2x}/bnx2x_link.h               |    0
 drivers/net/bnx2x/bnx2x_main.c                     | 8040 +++++++++++
 drivers/net/{ => bnx2x}/bnx2x_reg.h                |    0
 drivers/net/bnx2x/bnx2x_stats.c                    | 1411 ++
 drivers/net/bnx2x/bnx2x_stats.h                    |  239 +
 drivers/net/bnx2x_main.c                           |13928 --------------------
 drivers/net/bonding/bond_alb.c                     |   37 +-
 drivers/net/bonding/bond_ipv6.c                    |    2 +
 drivers/net/bonding/bond_main.c                    |  222 +-
 drivers/net/bonding/bond_sysfs.c                   |  316 +-
 drivers/net/bonding/bonding.h                      |   14 +-
 drivers/net/caif/Kconfig                           |   22 +-
 drivers/net/caif/Makefile                          |   14 +-
 drivers/net/caif/caif_serial.c                     |   12 +-
 drivers/net/caif/caif_spi.c                        |  850 ++
 drivers/net/caif/caif_spi_slave.c                  |  252 +
 drivers/net/can/Kconfig                            |    9 +
 drivers/net/can/Makefile                           |    1 +
 drivers/net/can/flexcan.c                          | 1030 ++
 drivers/net/can/mscan/mscan.h                      |    2 +-
 drivers/net/can/usb/Kconfig                        |    6 +
 drivers/net/can/usb/Makefile                       |    1 +
 drivers/net/can/usb/ems_usb.c                      |    2 +-
 drivers/net/can/usb/esd_usb2.c                     | 1132 ++
 drivers/net/cassini.c                              |   25 +-
 drivers/net/cassini.h                              |    4 -
 drivers/net/chelsio/common.h                       |    1 -
 drivers/net/chelsio/subr.c                         |   49 +-
 drivers/net/cnic.c                                 |  373 +-
 drivers/net/cnic.h                                 |   23 +-
 drivers/net/cnic_if.h                              |    4 +-
 drivers/net/cpmac.c                                |   13 +-
 drivers/net/cris/eth_v10.c                         |    4 -
 drivers/net/cs89x0.c                               |  162 +-
 drivers/net/cs89x0.h                               |    4 -
 drivers/net/cxgb3/cxgb3_main.c                     |   12 +-
 drivers/net/cxgb3/sge.c                            |   14 +-
 drivers/net/cxgb3/t3_hw.c                          |   16 +-
 drivers/net/cxgb3/version.h                        |    4 +-
 drivers/net/cxgb4/cxgb4.h                          |   11 +-
 drivers/net/cxgb4/cxgb4_main.c                     |  755 +-
 drivers/net/cxgb4/cxgb4_uld.h                      |    6 +
 drivers/net/cxgb4/l2t.c                            |    7 +
 drivers/net/cxgb4/sge.c                            |   67 +-
 drivers/net/cxgb4/t4_hw.c                          |  109 +-
 drivers/net/cxgb4/t4_hw.h                          |   45 +-
 drivers/net/cxgb4/t4_msg.h                         |   16 +-
 drivers/net/cxgb4/t4_regs.h                        |    7 +
 drivers/net/cxgb4/t4fw_api.h                       |   63 +-
 drivers/net/cxgb4vf/Makefile                       |    7 +
 drivers/net/cxgb4vf/adapter.h                      |  540 +
 drivers/net/cxgb4vf/cxgb4vf_main.c                 | 2888 ++++
 drivers/net/cxgb4vf/sge.c                          | 2454 ++++
 drivers/net/cxgb4vf/t4vf_common.h                  |  273 +
 drivers/net/cxgb4vf/t4vf_defs.h                    |  121 +
 drivers/net/cxgb4vf/t4vf_hw.c                      | 1333 ++
 drivers/net/davinci_emac.c                         |  200 +-
 drivers/net/depca.c                                |   29 +-
 drivers/net/dm9000.c                               |    2 +-
 drivers/net/dnet.c                                 |    9 +-
 drivers/net/e1000/e1000.h                          |   22 +-
 drivers/net/e1000/e1000_ethtool.c                  |   27 +-
 drivers/net/e1000/e1000_main.c                     |   86 +-
 drivers/net/e1000e/82571.c                         |    2 +-
 drivers/net/e1000e/defines.h                       |    4 +-
 drivers/net/e1000e/e1000.h                         |   10 +-
 drivers/net/e1000e/es2lan.c                        |    2 +-
 drivers/net/e1000e/ethtool.c                       |  144 +-
 drivers/net/e1000e/hw.h                            |   17 +-
 drivers/net/e1000e/ich8lan.c                       |  456 +-
 drivers/net/e1000e/lib.c                           |    2 +-
 drivers/net/e1000e/netdev.c                        |  357 +-
 drivers/net/e1000e/param.c                         |    2 +-
 drivers/net/e1000e/phy.c                           |    5 +-
 drivers/net/ehea/ehea_main.c                       |    2 +-
 drivers/net/ehea/ehea_qmr.h                        |    2 +-
 drivers/net/enic/cq_desc.h                         |    2 +-
 drivers/net/enic/cq_enet_desc.h                    |   20 +-
 drivers/net/enic/enic.h                            |   21 +-
 drivers/net/enic/enic_main.c                       |  517 +-
 drivers/net/enic/enic_res.c                        |   53 +-
 drivers/net/enic/enic_res.h                        |   33 +-
 drivers/net/enic/rq_enet_desc.h                    |    2 +-
 drivers/net/enic/vnic_cq.c                         |    4 +-
 drivers/net/enic/vnic_cq.h                         |    2 +-
 drivers/net/enic/vnic_dev.c                        |  272 +-
 drivers/net/enic/vnic_dev.h                        |   21 +-
 drivers/net/enic/vnic_devcmd.h                     |   35 +-
 drivers/net/enic/vnic_enet.h                       |    4 +-
 drivers/net/enic/vnic_intr.c                       |    5 +-
 drivers/net/enic/vnic_intr.h                       |    8 +-
 drivers/net/enic/vnic_nic.h                        |    2 +-
 drivers/net/enic/vnic_resource.h                   |    2 +-
 drivers/net/enic/vnic_rq.c                         |   40 +-
 drivers/net/enic/vnic_rq.h                         |   16 +-
 drivers/net/enic/vnic_rss.h                        |    2 +-
 drivers/net/enic/vnic_stats.h                      |    2 +-
 drivers/net/enic/vnic_vic.c                        |    8 +-
 drivers/net/enic/vnic_vic.h                        |    2 +-
 drivers/net/enic/vnic_wq.c                         |   25 +-
 drivers/net/enic/vnic_wq.h                         |   16 +-
 drivers/net/enic/wq_enet_desc.h                    |    2 +-
 drivers/net/epic100.c                              |   47 +-
 drivers/net/eth16i.c                               |    4 +-
 drivers/net/ethoc.c                                |  160 +-
 drivers/net/fealnx.c                               |   68 +-
 drivers/net/fec.c                                  |  110 +-
 drivers/net/fec_mpc52xx.c                          |   40 +-
 drivers/net/fec_mpc52xx_phy.c                      |   24 +-
 drivers/net/forcedeth.c                            |   62 +-
 drivers/net/fs_enet/fs_enet-main.c                 |    3 +-
 drivers/net/fsl_pq_mdio.h                          |    2 +-
 drivers/net/gianfar.c                              |  152 +-
 drivers/net/gianfar.h                              |   13 +
 drivers/net/greth.c                                |    1 -
 drivers/net/hamachi.c                              |   63 +-
 drivers/net/hp100.c                                |   53 +-
 drivers/net/igb/e1000_82575.c                      |  143 +-
 drivers/net/igb/e1000_defines.h                    |   16 +
 drivers/net/igb/igb_ethtool.c                      |    8 +-
 drivers/net/igb/igb_main.c                         |   43 +-
 drivers/net/igbvf/netdev.c                         |    2 +-
 drivers/net/ioc3-eth.c                             |   49 +-
 drivers/net/irda/donauboe.h                        |    2 +-
 drivers/net/irda/irda-usb.h                        |    2 +-
 drivers/net/irda/ks959-sir.c                       |    2 +-
 drivers/net/irda/ksdazzle-sir.c                    |    2 +-
 drivers/net/irda/sh_irda.c                         |    2 +-
 drivers/net/irda/sh_sir.c                          |    2 +-
 drivers/net/irda/smsc-ircc2.c                      |    5 +-
 drivers/net/irda/vlsi_ir.h                         |    6 +-
 drivers/net/ixgbe/ixgbe.h                          |    9 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |   18 +-
 drivers/net/ixgbe/ixgbe_common.h                   |   25 +-
 drivers/net/ixgbe/ixgbe_dcb_82599.c                |    2 +-
 drivers/net/ixgbe/ixgbe_dcb_nl.c                   |    2 +-
 drivers/net/ixgbe/ixgbe_ethtool.c                  |  107 +-
 drivers/net/ixgbe/ixgbe_fcoe.c                     |   56 +-
 drivers/net/ixgbe/ixgbe_main.c                     |  425 +-
 drivers/net/ixgbe/ixgbe_phy.c                      |   33 +-
 drivers/net/ixgbe/ixgbe_phy.h                      |    1 +
 drivers/net/ixgbe/ixgbe_sriov.c                    |   30 +-
 drivers/net/ixgbe/ixgbe_type.h                     |    2 +
 drivers/net/ixgbevf/ixgbevf_main.c                 |   18 +-
 drivers/net/jazzsonic.c                            |   17 +-
 drivers/net/ks8842.c                               |  706 +-
 drivers/net/ksz884x.c                              |   59 +-
 drivers/net/lance.c                                |   56 +-
 drivers/net/ll_temac_main.c                        |   63 +-
 drivers/net/loopback.c                             |   33 +-
 drivers/net/mac8390.c                              |   57 +-
 drivers/net/mac89x0.c                              |   52 +-
 drivers/net/macb.c                                 |    2 +-
 drivers/net/macsonic.c                             |   37 +-
 drivers/net/macvlan.c                              |   95 +-
 drivers/net/macvtap.c                              |    2 +-
 drivers/net/mlx4/catas.c                           |    4 +-
 drivers/net/mlx4/en_ethtool.c                      |   38 +-
 drivers/net/mlx4/en_main.c                         |   29 +-
 drivers/net/mlx4/en_netdev.c                       |    1 +
 drivers/net/mlx4/eq.c                              |   20 +-
 drivers/net/mlx4/main.c                            |   16 +-
 drivers/net/mlx4/mlx4.h                            |   15 +-
 drivers/net/mlx4/mlx4_en.h                         |   62 +-
 drivers/net/mlx4/mr.c                              |    2 +-
 drivers/net/mv643xx_eth.c                          |   12 +-
 drivers/net/myri10ge/myri10ge.c                    |   10 +-
 drivers/net/natsemi.c                              |   56 +-
 drivers/net/netxen/netxen_nic_ctx.c                |   16 +-
 drivers/net/netxen/netxen_nic_ethtool.c            |   13 +-
 drivers/net/ni52.c                                 |   37 +-
 drivers/net/niu.c                                  |   13 +-
 drivers/net/ns83820.c                              |   44 +-
 drivers/net/octeon/octeon_mgmt.c                   |    8 +-
 drivers/net/phy/broadcom.c                         |   46 +-
 drivers/net/phy/icplus.c                           |    2 +
 drivers/net/phy/marvell.c                          |   77 +-
 drivers/net/phy/mdio-octeon.c                      |    6 +-
 drivers/net/phy/micrel.c                           |  167 +-
 drivers/net/phy/phy.c                              |    8 +-
 drivers/net/phy/phy_device.c                       |    2 +
 drivers/net/ppp_generic.c                          |   37 +-
 drivers/net/pppoe.c                                |    3 +-
 drivers/net/ps3_gelic_wireless.h                   |   10 +-
 drivers/net/qla3xxx.c                              | 1435 +--
 drivers/net/qlcnic/qlcnic.h                        |  225 +-
 drivers/net/qlcnic/qlcnic_ctx.c                    |  526 +-
 drivers/net/qlcnic/qlcnic_ethtool.c                |   42 +-
 drivers/net/qlcnic/qlcnic_hdr.h                    |   78 +-
 drivers/net/qlcnic/qlcnic_hw.c                     |   62 +-
 drivers/net/qlcnic/qlcnic_init.c                   |  136 +-
 drivers/net/qlcnic/qlcnic_main.c                   | 1139 ++-
 drivers/net/qlge/qlge.h                            |   30 +-
 drivers/net/qlge/qlge_dbg.c                        |  814 +-
 drivers/net/qlge/qlge_main.c                       |   47 +-
 drivers/net/qlge/qlge_mpi.c                        |   17 -
 drivers/net/r6040.c                                |  302 +-
 drivers/net/r8169.c                                |    2 +-
 drivers/net/s2io-regs.h                            |    2 +-
 drivers/net/s2io.c                                 |   83 +-
 drivers/net/s2io.h                                 |    2 +-
 drivers/net/sb1250-mac.c                           |    2 +-
 drivers/net/sfc/efx.c                              |  304 +-
 drivers/net/sfc/efx.h                              |    9 +-
 drivers/net/sfc/ethtool.c                          |  167 +-
 drivers/net/sfc/falcon.c                           |  200 +-
 drivers/net/sfc/falcon_boards.c                    |   35 +-
 drivers/net/sfc/falcon_xmac.c                      |    5 +-
 drivers/net/sfc/io.h                               |   37 +-
 drivers/net/sfc/mcdi.c                             |   98 +-
 drivers/net/sfc/mcdi_mac.c                         |    8 +-
 drivers/net/sfc/mcdi_phy.c                         |   41 +-
 drivers/net/sfc/mdio_10g.c                         |   39 +-
 drivers/net/sfc/mdio_10g.h                         |    3 +-
 drivers/net/sfc/mtd.c                              |   23 +-
 drivers/net/sfc/net_driver.h                       |   88 +-
 drivers/net/sfc/nic.c                              |  553 +-
 drivers/net/sfc/nic.h                              |    9 +-
 drivers/net/sfc/qt202x_phy.c                       |   42 +-
 drivers/net/sfc/rx.c                               |  469 +-
 drivers/net/sfc/selftest.c                         |  154 +-
 drivers/net/sfc/siena.c                            |   68 +-
 drivers/net/sfc/tenxpress.c                        |   12 +-
 drivers/net/sfc/tx.c                               |   41 +-
 drivers/net/sfc/workarounds.h                      |    2 +-
 drivers/net/sh_eth.c                               |   55 +-
 drivers/net/sky2.c                                 |   40 +-
 drivers/net/sky2.h                                 |    6 +-
 drivers/net/smsc911x.c                             |   94 +-
 drivers/net/smsc9420.c                             |    2 +-
 drivers/net/starfire.c                             |   47 +-
 drivers/net/stmmac/common.h                        |    1 +
 drivers/net/stmmac/dwmac1000.h                     |    2 +-
 drivers/net/stmmac/dwmac1000_core.c                |    2 +
 drivers/net/stmmac/dwmac100_core.c                 |    2 +
 drivers/net/stmmac/enh_desc.c                      |    2 +-
 drivers/net/stmmac/stmmac_main.c                   |   37 +-
 drivers/net/sun3_82586.c                           |   35 +-
 drivers/net/tc35815.c                              |    2 +-
 drivers/net/tehuti.h                               |    2 +-
 drivers/net/tg3.c                                  |  799 +-
 drivers/net/tg3.h                                  |   98 +-
 drivers/net/tulip/de2104x.c                        |    4 +-
 drivers/net/tulip/eeprom.c                         |   10 +-
 drivers/net/tulip/tulip.h                          |   64 +-
 drivers/net/tulip/tulip_core.c                     |  132 +-
 drivers/net/tulip/winbond-840.c                    |    4 +-
 drivers/net/tun.c                                  |   10 +-
 drivers/net/typhoon.c                              |    2 +-
 drivers/net/typhoon.h                              |   26 +-
 drivers/net/ucc_geth.c                             |   16 +-
 drivers/net/ucc_geth.h                             |   46 +-
 drivers/net/usb/asix.c                             |    2 +-
 drivers/net/usb/cdc-phonet.c                       |    8 +-
 drivers/net/usb/hso.c                              |    8 +-
 drivers/net/usb/ipheth.c                           |   13 +-
 drivers/net/usb/kaweth.c                           |    2 +-
 drivers/net/usb/net1080.c                          |    4 +-
 drivers/net/usb/pegasus.c                          |  125 +-
 drivers/net/usb/pegasus.h                          |  296 +-
 drivers/net/usb/sierra_net.c                       |    2 +-
 drivers/net/usb/usbnet.c                           |   17 +-
 drivers/net/via-velocity.h                         |   12 +-
 drivers/net/vmxnet3/vmxnet3_defs.h                 |    6 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   46 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   18 +-
 drivers/net/vmxnet3/vmxnet3_int.h                  |    4 +-
 drivers/net/vxge/Makefile                          |    2 +-
 drivers/net/vxge/vxge-config.c                     |    4 +-
 drivers/net/vxge/vxge-config.h                     |    4 +-
 drivers/net/vxge/vxge-ethtool.c                    |    4 +-
 drivers/net/vxge/vxge-ethtool.h                    |    4 +-
 drivers/net/vxge/vxge-main.c                       |  599 +-
 drivers/net/vxge/vxge-main.h                       |   27 +-
 drivers/net/vxge/vxge-reg.h                        |    4 +-
 drivers/net/vxge/vxge-traffic.c                    |    8 +-
 drivers/net/vxge/vxge-traffic.h                    |    4 +-
 drivers/net/vxge/vxge-version.h                    |    9 +-
 drivers/net/wan/cosa.c                             |   10 +-
 drivers/net/wan/farsync.c                          |  125 +-
 drivers/net/wan/hd64570.h                          |    2 +-
 drivers/net/wan/hdlc_cisco.c                       |    4 +-
 drivers/net/wan/hdlc_fr.c                          |    2 +-
 drivers/net/wan/sdla.c                             |   13 +-
 drivers/net/wd.c                                   |    4 +-
 drivers/net/wimax/i2400m/control.c                 |    2 +-
 drivers/net/wimax/i2400m/fw.c                      |    8 +-
 drivers/net/wimax/i2400m/op-rfkill.c               |    2 +-
 drivers/net/wireless/adm8211.c                     |   58 +-
 drivers/net/wireless/adm8211.h                     |    6 +-
 drivers/net/wireless/airo.c                        |   56 +-
 drivers/net/wireless/at76c50x-usb.c                |  270 +-
 drivers/net/wireless/at76c50x-usb.h                |   41 +-
 drivers/net/wireless/ath/ar9170/cmd.c              |    7 +-
 drivers/net/wireless/ath/ar9170/led.c              |    4 +-
 drivers/net/wireless/ath/ar9170/main.c             |  191 +-
 drivers/net/wireless/ath/ar9170/phy.c              |    8 +-
 drivers/net/wireless/ath/ath5k/Makefile            |    1 +
 drivers/net/wireless/ath/ath5k/ani.c               |   20 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |   19 +-
 drivers/net/wireless/ath/ath5k/attach.c            |    2 -
 drivers/net/wireless/ath/ath5k/base.c              |  438 +-
 drivers/net/wireless/ath/ath5k/base.h              |    4 +-
 drivers/net/wireless/ath/ath5k/caps.c              |    7 -
 drivers/net/wireless/ath/ath5k/debug.c             |   99 +-
 drivers/net/wireless/ath/ath5k/debug.h             |    9 +-
 drivers/net/wireless/ath/ath5k/desc.c              |  152 +-
 drivers/net/wireless/ath/ath5k/desc.h              |  310 +-
 drivers/net/wireless/ath/ath5k/dma.c               |   13 -
 drivers/net/wireless/ath/ath5k/eeprom.c            |    3 +-
 drivers/net/wireless/ath/ath5k/gpio.c              |    7 -
 drivers/net/wireless/ath/ath5k/pcu.c               |   24 -
 drivers/net/wireless/ath/ath5k/phy.c               |   82 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |    9 -
 drivers/net/wireless/ath/ath5k/reset.c             |   64 +-
 drivers/net/wireless/ath/ath5k/sysfs.c             |  116 +
 drivers/net/wireless/ath/ath9k/Makefile            |    3 +-
 drivers/net/wireless/ath/ath9k/ahb.c               |    7 +-
 drivers/net/wireless/ath/ath9k/ani.c               |  743 +-
 drivers/net/wireless/ath/ath9k/ani.h               |   78 +-
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h   | 1319 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |  492 +-
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h   | 2479 ++--
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |  196 +-
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h   | 8251 +++++-------
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |    1 +
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |   71 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |   33 +
 .../{ar9003_initvals.h => ar9003_2p0_initvals.h}   |  254 +-
 .../{ar9003_initvals.h => ar9003_2p2_initvals.h}   |  433 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   15 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  185 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   44 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.h        |    8 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |  714 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  699 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |  298 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   92 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |    3 +-
 drivers/net/wireless/ath/ath9k/calib.c             |  138 +-
 drivers/net/wireless/ath/ath9k/calib.h             |    7 +-
 drivers/net/wireless/ath/ath9k/common.c            |  318 +-
 drivers/net/wireless/ath/ath9k/common.h            |   77 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   68 +-
 drivers/net/wireless/ath/ath9k/debug.h             |    2 +
 drivers/net/wireless/ath/ath9k/eeprom.c            |   29 +
 drivers/net/wireless/ath/ath9k/eeprom.h            |    7 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |   12 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |  616 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |   14 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |    9 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   71 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h           |    2 +
 drivers/net/wireless/ath/ath9k/htc.h               |   38 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   23 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |  163 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  512 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   86 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    3 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |   22 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  314 +-
 drivers/net/wireless/ath/ath9k/hw.h                |  123 +-
 drivers/net/wireless/ath/ath9k/init.c              |   61 +-
 drivers/net/wireless/ath/ath9k/mac.c               |   14 +-
 drivers/net/wireless/ath/ath9k/mac.h               |   16 +-
 drivers/net/wireless/ath/ath9k/main.c              |  475 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    8 +-
 drivers/net/wireless/ath/ath9k/rc.c                |  633 +-
 drivers/net/wireless/ath/ath9k/rc.h                |   89 +-
 drivers/net/wireless/ath/ath9k/recv.c              |  292 +-
 drivers/net/wireless/ath/ath9k/reg.h               |   90 +-
 drivers/net/wireless/ath/ath9k/virtual.c           |    8 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |    3 -
 drivers/net/wireless/ath/ath9k/xmit.c              |  251 +-
 drivers/net/wireless/b43/b43.h                     |    6 +-
 drivers/net/wireless/b43/dma.c                     |   69 +-
 drivers/net/wireless/b43/dma.h                     |    8 +-
 drivers/net/wireless/b43/main.c                    |    4 +-
 drivers/net/wireless/b43/phy_g.c                   |    2 +-
 drivers/net/wireless/b43/phy_lp.c                  |    8 +-
 drivers/net/wireless/b43/phy_n.c                   |   16 +-
 drivers/net/wireless/b43/sdio.c                    |    1 +
 drivers/net/wireless/b43/wa.c                      |    8 +-
 drivers/net/wireless/b43/xmit.h                    |   20 +-
 drivers/net/wireless/b43legacy/b43legacy.h         |    6 +-
 drivers/net/wireless/b43legacy/dma.c               |   49 +-
 drivers/net/wireless/b43legacy/dma.h               |    8 +-
 drivers/net/wireless/b43legacy/xmit.h              |   10 +-
 drivers/net/wireless/hostap/hostap_80211.h         |   18 +-
 drivers/net/wireless/hostap/hostap_ap.c            |    3 +-
 drivers/net/wireless/hostap/hostap_common.h        |   10 +-
 drivers/net/wireless/hostap/hostap_main.c          |    4 +-
 drivers/net/wireless/hostap/hostap_wlan.h          |   32 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |   24 +-
 drivers/net/wireless/ipw2x00/ipw2100.h             |   16 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |    7 +-
 drivers/net/wireless/ipw2x00/ipw2200.h             |  122 +-
 drivers/net/wireless/ipw2x00/libipw.h              |   63 +-
 drivers/net/wireless/ipw2x00/libipw_module.c       |    4 +-
 drivers/net/wireless/ipw2x00/libipw_tx.c           |   16 +-
 drivers/net/wireless/ipw2x00/libipw_wx.c           |    6 +-
 drivers/net/wireless/iwlwifi/Kconfig               |   15 +-
 drivers/net/wireless/iwlwifi/Makefile              |    4 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |   12 +-
 drivers/net/wireless/iwlwifi/iwl-3945-debugfs.c    |   28 +-
 drivers/net/wireless/iwlwifi/iwl-3945-fh.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h         |   10 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c            |  208 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c            |   98 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |   80 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |  538 +-
 .../iwlwifi/{iwl-calib.c => iwl-agn-calib.c}       |  223 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c     |  239 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h     |    7 +
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c        |   32 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         |  320 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |   20 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c          |  351 +
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |   89 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c       |  123 +
 drivers/net/wireless/iwlwifi/iwl-agn.c             |  594 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h             |   48 +
 drivers/net/wireless/iwlwifi/iwl-calib.h           |    6 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |  422 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  395 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |   44 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |  144 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |  123 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |    3 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |   17 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h              |   13 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c            |    1 +
 drivers/net/wireless/iwlwifi/iwl-helpers.h         |   27 +
 drivers/net/wireless/iwlwifi/iwl-rx.c              |  246 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |   67 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.h        |   10 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |  164 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h             |   32 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c              |   33 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        |  160 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |   12 +-
 drivers/net/wireless/iwmc3200wifi/commands.h       |   50 +-
 drivers/net/wireless/iwmc3200wifi/hal.c            |    2 +-
 drivers/net/wireless/iwmc3200wifi/iwm.h            |    2 +-
 drivers/net/wireless/iwmc3200wifi/lmac.h           |   32 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |    4 +-
 drivers/net/wireless/iwmc3200wifi/umac.h           |   60 +-
 drivers/net/wireless/libertas/Makefile             |    3 -
 drivers/net/wireless/libertas/README               |   12 +
 drivers/net/wireless/libertas/assoc.c              | 2264 ----
 drivers/net/wireless/libertas/assoc.h              |  155 -
 drivers/net/wireless/libertas/cfg.c                | 1865 +++-
 drivers/net/wireless/libertas/cfg.h                |   15 +-
 drivers/net/wireless/libertas/cmd.c                |  767 +-
 drivers/net/wireless/libertas/cmd.h                |   27 +-
 drivers/net/wireless/libertas/cmdresp.c            |  190 +-
 drivers/net/wireless/libertas/debugfs.c            |  191 +-
 drivers/net/wireless/libertas/decl.h               |    7 +-
 drivers/net/wireless/libertas/defs.h               |   18 -
 drivers/net/wireless/libertas/dev.h                |   68 +-
 drivers/net/wireless/libertas/ethtool.c            |   29 +-
 drivers/net/wireless/libertas/host.h               |  250 +-
 drivers/net/wireless/libertas/if_sdio.c            |   58 +
 drivers/net/wireless/libertas/if_usb.c             |   16 +-
 drivers/net/wireless/libertas/main.c               |  326 +-
 drivers/net/wireless/libertas/mesh.c               |  222 +-
 drivers/net/wireless/libertas/mesh.h               |   19 +-
 drivers/net/wireless/libertas/radiotap.h           |    4 +-
 drivers/net/wireless/libertas/rx.c                 |  129 +-
 drivers/net/wireless/libertas/scan.c               | 1354 --
 drivers/net/wireless/libertas/scan.h               |   63 -
 drivers/net/wireless/libertas/tx.c                 |   12 +-
 drivers/net/wireless/libertas/types.h              |   66 +-
 drivers/net/wireless/libertas/wext.c               | 2353 ----
 drivers/net/wireless/libertas/wext.h               |   17 -
 drivers/net/wireless/libertas_tf/if_usb.c          |    5 +-
 drivers/net/wireless/libertas_tf/libertas_tf.h     |    7 +-
 drivers/net/wireless/libertas_tf/main.c            |   18 +
 drivers/net/wireless/mac80211_hwsim.c              |  106 +-
 drivers/net/wireless/mwl8k.c                       |  254 +-
 drivers/net/wireless/orinoco/cfg.c                 |    5 +-
 drivers/net/wireless/orinoco/fw.c                  |    2 +-
 drivers/net/wireless/orinoco/hermes.h              |   18 +-
 drivers/net/wireless/orinoco/hermes_dld.c          |   10 +-
 drivers/net/wireless/orinoco/hw.c                  |    6 +-
 drivers/net/wireless/orinoco/main.c                |   10 +-
 drivers/net/wireless/orinoco/orinoco.h             |    2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c         |   18 +-
 drivers/net/wireless/orinoco/wext.c                |    6 +-
 drivers/net/wireless/p54/eeprom.c                  |   80 +-
 drivers/net/wireless/p54/fwio.c                    |   53 +-
 drivers/net/wireless/p54/led.c                     |    8 +-
 drivers/net/wireless/p54/main.c                    |   17 +
 drivers/net/wireless/p54/net2280.h                 |   16 +-
 drivers/net/wireless/p54/p54pci.c                  |    3 +-
 drivers/net/wireless/p54/p54pci.h                  |    6 +-
 drivers/net/wireless/p54/p54spi.c                  |    5 +-
 drivers/net/wireless/p54/p54spi.h                  |    2 +-
 drivers/net/wireless/p54/p54usb.c                  |    6 +-
 drivers/net/wireless/p54/p54usb.h                  |    6 +-
 drivers/net/wireless/p54/txrx.c                    |   36 +-
 drivers/net/wireless/prism54/isl_ioctl.c           |   15 +-
 drivers/net/wireless/prism54/isl_oid.h             |   18 +-
 drivers/net/wireless/prism54/islpci_eth.h          |    4 +-
 drivers/net/wireless/prism54/islpci_mgt.h          |    2 +-
 drivers/net/wireless/ray_cs.c                      |   23 +-
 drivers/net/wireless/rndis_wlan.c                  |   90 +-
 drivers/net/wireless/rt2x00/rt2400pci.c            |   85 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |   87 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |   63 +-
 drivers/net/wireless/rt2x00/rt2800.h               |   93 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  734 +-
 drivers/net/wireless/rt2x00/rt2800lib.h            |   54 +-
 drivers/net/wireless/rt2x00/rt2800pci.c            |  366 +-
 drivers/net/wireless/rt2x00/rt2800pci.h            |   19 -
 drivers/net/wireless/rt2x00/rt2800usb.c            |  293 +-
 drivers/net/wireless/rt2x00/rt2800usb.h            |   37 -
 drivers/net/wireless/rt2x00/rt2x00.h               |   69 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |   16 +-
 drivers/net/wireless/rt2x00/rt2x00debug.c          |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c            |  139 +-
 drivers/net/wireless/rt2x00/rt2x00dump.h           |    9 +-
 drivers/net/wireless/rt2x00/rt2x00ht.c             |   47 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   52 +-
 drivers/net/wireless/rt2x00/rt2x00link.c           |   73 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   75 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |   39 +-
 drivers/net/wireless/rt2x00/rt2x00pci.h            |   10 -
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   90 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |   20 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h            |    5 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |  118 +-
 drivers/net/wireless/rt2x00/rt2x00usb.h            |   39 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |  130 +-
 drivers/net/wireless/rt2x00/rt61pci.h              |    4 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |   59 +-
 drivers/net/wireless/rt2x00/rt73usb.h              |    4 +-
 drivers/net/wireless/rtl818x/rtl8180.h             |    4 +-
 drivers/net/wireless/rtl818x/rtl8180_dev.c         |   34 +-
 drivers/net/wireless/rtl818x/rtl8180_grf5101.c     |   12 +-
 drivers/net/wireless/rtl818x/rtl8180_max2820.c     |   19 +-
 drivers/net/wireless/rtl818x/rtl8180_rtl8225.c     |    5 +-
 drivers/net/wireless/rtl818x/rtl8180_sa2400.c      |   28 +-
 drivers/net/wireless/rtl818x/rtl8187.h             |    8 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c         |   11 +-
 drivers/net/wireless/rtl818x/rtl8187_rtl8225.c     |    8 +-
 drivers/net/wireless/rtl818x/rtl818x.h             |    3 +-
 drivers/net/wireless/wl12xx/Kconfig                |    4 +-
 drivers/net/wireless/wl12xx/Makefile               |    2 +-
 drivers/net/wireless/wl12xx/wl1251.h               |    3 +
 drivers/net/wireless/wl12xx/wl1251_acx.h           |  102 +-
 drivers/net/wireless/wl12xx/wl1251_boot.c          |    8 +-
 drivers/net/wireless/wl12xx/wl1251_cmd.h           |   34 +-
 drivers/net/wireless/wl12xx/wl1251_event.h         |    4 +-
 drivers/net/wireless/wl12xx/wl1251_main.c          |   27 +-
 drivers/net/wireless/wl12xx/wl1251_rx.c            |    6 +
 drivers/net/wireless/wl12xx/wl1251_rx.h            |    2 +-
 drivers/net/wireless/wl12xx/wl1251_sdio.c          |   40 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c           |    1 +
 drivers/net/wireless/wl12xx/wl1251_tx.c            |   10 +-
 drivers/net/wireless/wl12xx/wl1251_tx.h            |   14 +-
 drivers/net/wireless/wl12xx/wl1271.h               |   58 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c           |   41 +-
 drivers/net/wireless/wl12xx/wl1271_acx.h           |  117 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c          |    4 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c           |  275 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.h           |  124 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h          |   16 +-
 drivers/net/wireless/wl12xx/wl1271_event.c         |   99 +-
 drivers/net/wireless/wl12xx/wl1271_event.h         |    5 +-
 drivers/net/wireless/wl12xx/wl1271_ini.h           |  123 +
 drivers/net/wireless/wl12xx/wl1271_main.c          |  289 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c            |   11 +-
 drivers/net/wireless/wl12xx/wl1271_rx.h            |    2 +-
 drivers/net/wireless/wl12xx/wl1271_scan.c          |  257 +
 drivers/net/wireless/wl12xx/wl1271_scan.h          |  109 +
 drivers/net/wireless/wl12xx/wl1271_sdio.c          |    2 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c           |    1 +
 drivers/net/wireless/wl12xx/wl1271_testmode.c      |   11 +-
 drivers/net/wireless/wl12xx/wl1271_tx.c            |   36 +-
 drivers/net/wireless/wl12xx/wl1271_tx.h            |    7 +-
 drivers/net/wireless/wl12xx/wl12xx_80211.h         |   26 +-
 drivers/net/wireless/wl3501.h                      |   16 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    5 +-
 drivers/net/wireless/zd1211rw/zd_mac.h             |   15 +-
 drivers/net/wireless/zd1211rw/zd_usb.c             |    2 +-
 drivers/net/wireless/zd1211rw/zd_usb.h             |   14 +-
 drivers/net/xen-netfront.c                         |    1 +
 drivers/net/xtsonic.c                              |   12 +-
 drivers/parisc/led.c                               |    3 +-
 drivers/s390/net/claw.c                            |    2 +-
 drivers/s390/net/qeth_core.h                       |   27 +-
 drivers/s390/net/qeth_core_main.c                  |  423 +-
 drivers/s390/net/qeth_core_mpc.h                   |    5 +-
 drivers/s390/net/qeth_core_sys.c                   |    5 +-
 drivers/s390/net/qeth_l2_main.c                    |  108 +-
 drivers/s390/net/qeth_l3.h                         |    1 +
 drivers/s390/net/qeth_l3_main.c                    |  262 +-
 drivers/s390/net/qeth_l3_sys.c                     |   14 +
 drivers/s390/net/smsgiucv.c                        |   11 +-
 drivers/scsi/cxgb3i/cxgb3i_offload.c               |    4 +-
 drivers/scsi/fcoe/fcoe.c                           |    3 +-
 drivers/ssb/driver_chipcommon.c                    |   25 +
 drivers/ssb/driver_chipcommon_pmu.c                |   17 +-
 drivers/ssb/main.c                                 |   76 +-
 drivers/ssb/pci.c                                  |   15 +-
 drivers/staging/batman-adv/hard-interface.c        |    5 +-
 drivers/staging/octeon/ethernet-mdio.c             |    2 +-
 drivers/usb/atm/cxacru.c                           |   18 +-
 drivers/usb/atm/speedtch.c                         |   10 +-
 drivers/usb/atm/ueagle-atm.c                       |   13 +-
 drivers/usb/gadget/rndis.c                         |    5 +-
 drivers/vhost/net.c                                |  306 +-
 drivers/vhost/vhost.c                              |  232 +-
 drivers/vhost/vhost.h                              |   55 +-
 firmware/Makefile                                  |    2 +-
 firmware/cxgb3/t3fw-7.10.0.bin.ihex                | 1935 +++
 firmware/cxgb3/t3fw-7.4.0.bin.ihex                 | 1917 ---
 fs/compat_ioctl.c                                  |    9 +-
 include/linux/Kbuild                               |    1 +
 include/linux/atmdev.h                             |   17 +
 include/linux/brcmphy.h                            |    7 +
 include/linux/caif/caif_socket.h                   |   34 +
 include/linux/can/platform/flexcan.h               |   20 +
 include/linux/cgroup.h                             |    7 +
 include/linux/device.h                             |  112 +-
 include/linux/eeprom_93cx6.h                       |    1 +
 include/linux/etherdevice.h                        |   14 +
 include/linux/ethtool.h                            |   57 +-
 include/linux/filter.h                             |   48 +
 include/linux/if.h                                 |    2 +
 include/linux/if_bonding.h                         |    1 +
 include/linux/if_bridge.h                          |    2 -
 include/linux/if_ether.h                           |    2 +-
 include/linux/if_fddi.h                            |    8 +-
 include/linux/if_frad.h                            |    2 +-
 include/linux/if_hippi.h                           |    8 +-
 include/linux/if_link.h                            |    3 +-
 include/linux/if_macvlan.h                         |   23 +-
 include/linux/if_packet.h                          |    1 +
 include/linux/if_pppox.h                           |    8 +-
 include/linux/in.h                                 |    1 +
 include/linux/ip_vs.h                              |    2 +
 include/linux/ipv6.h                               |    6 +-
 include/linux/isdnif.h                             |    2 +-
 include/linux/kernel.h                             |    5 +
 include/linux/ks8842.h                             |    4 +
 include/linux/mISDNif.h                            |    2 +-
 include/linux/nbd.h                                |    2 +-
 include/linux/ncp.h                                |   10 +-
 include/linux/ncp_fs_sb.h                          |   14 +-
 include/linux/netdevice.h                          |  165 +-
 include/linux/netfilter/Kbuild                     |    6 +-
 include/linux/netfilter/nf_conntrack_common.h      |    4 +
 include/linux/netfilter/nfnetlink_log.h            |    1 +
 include/linux/netfilter/xt_CHECKSUM.h              |   20 +
 include/linux/netfilter/xt_IDLETIMER.h             |   45 +
 include/linux/netfilter/xt_cpu.h                   |   11 +
 include/linux/netfilter/xt_ipvs.h                  |   27 +
 include/linux/netfilter/xt_quota.h                 |    2 +-
 include/linux/netfilter_ipv4/ipt_LOG.h             |    3 +-
 include/linux/netfilter_ipv6/ip6t_LOG.h            |    3 +-
 include/linux/netpoll.h                            |   24 +-
 include/linux/nl80211.h                            |   24 +-
 include/linux/notifier.h                           |    1 +
 include/linux/pci_ids.h                            |    6 +-
 include/linux/phonet.h                             |    4 +-
 include/linux/phy.h                                |   24 +-
 include/linux/ptp_classify.h                       |  126 +
 include/linux/rds.h                                |   12 +-
 include/linux/rtnetlink.h                          |    1 +
 include/linux/sctp.h                               |   80 +-
 include/linux/skbuff.h                             |   70 +-
 include/linux/snmp.h                               |    1 +
 include/linux/socket.h                             |    5 +
 include/linux/ssb/ssb.h                            |  159 +-
 include/linux/u64_stats_sync.h                     |  140 +
 include/linux/user_namespace.h                     |   14 +
 include/linux/wlp.h                                |   22 +-
 include/net/act_api.h                              |    2 +
 include/net/af_unix.h                              |    4 +-
 include/net/bluetooth/bluetooth.h                  |    3 +-
 include/net/bluetooth/hci.h                        |  187 +-
 include/net/bluetooth/hci_core.h                   |   30 +-
 include/net/bluetooth/l2cap.h                      |   34 +-
 include/net/bluetooth/rfcomm.h                     |   14 +-
 include/net/caif/caif_dev.h                        |    8 +-
 include/net/caif/caif_layer.h                      |    6 -
 include/net/caif/caif_spi.h                        |  153 +
 include/net/caif/cfcnfg.h                          |   16 +-
 include/net/caif/cfsrvl.h                          |   15 +-
 include/net/cfg80211.h                             |  221 +-
 include/net/dn_dev.h                               |    8 +-
 include/net/dn_nsp.h                               |   16 +-
 include/net/dn_route.h                             |    4 +-
 include/net/genetlink.h                            |   15 +-
 include/net/inet_common.h                          |   59 +-
 include/net/inet_frag.h                            |    1 +
 include/net/inet_sock.h                            |    3 +-
 include/net/inetpeer.h                             |   30 +-
 include/net/ip.h                                   |   29 +-
 include/net/ip6_fib.h                              |   10 +-
 include/net/ip6_tunnel.h                           |    2 +-
 include/net/ip_vs.h                                |   14 +-
 include/net/ipip.h                                 |    2 +-
 include/net/ipv6.h                                 |   16 +-
 include/net/ipx.h                                  |    8 +-
 include/net/irda/irda.h                            |    4 -
 include/net/irda/irlap_frame.h                     |   18 +-
 include/net/lib80211.h                             |    3 -
 include/net/mac80211.h                             |  145 +-
 include/net/mip6.h                                 |    2 +-
 include/net/ndisc.h                                |    2 +-
 include/net/neighbour.h                            |    2 +-
 include/net/netfilter/nf_conntrack.h               |   17 +-
 include/net/netfilter/nf_conntrack_acct.h          |   12 +
 include/net/netfilter/nf_conntrack_core.h          |    2 +-
 include/net/netfilter/nf_conntrack_extend.h        |    9 +-
 include/net/netfilter/nf_nat_protocol.h            |    8 +-
 include/net/netfilter/nf_nat_rule.h                |    2 -
 include/net/netfilter/nfnetlink_log.h              |    2 +
 include/net/netfilter/xt_rateest.h                 |   11 +-
 include/net/netlink.h                              |    2 +-
 include/net/phonet/pn_dev.h                        |    1 +
 include/net/pkt_sched.h                            |    2 +-
 include/net/regulatory.h                           |    1 -
 include/net/route.h                                |    6 +-
 include/net/sch_generic.h                          |   38 +-
 include/net/scm.h                                  |   30 +-
 include/net/sctp/structs.h                         |    4 +-
 include/net/snmp.h                                 |   75 +-
 include/net/sock.h                                 |   14 +-
 include/net/tcp.h                                  |  260 +-
 include/net/udp.h                                  |   38 +-
 include/rxrpc/packet.h                             |    8 +-
 kernel/audit.c                                     |    2 +-
 kernel/cgroup.c                                    |   23 +
 kernel/user_namespace.c                            |   44 +
 lib/vsprintf.c                                     |    9 +
 net/8021q/vlan.c                                   |   13 +-
 net/8021q/vlan.h                                   |   13 +-
 net/8021q/vlan_core.c                              |   26 +-
 net/8021q/vlan_dev.c                               |  161 +-
 net/8021q/vlanproc.c                               |   16 +-
 net/9p/trans_fd.c                                  |    2 +-
 net/Kconfig                                        |   12 +-
 net/Makefile                                       |    4 +-
 net/atm/br2684.c                                   |   66 +-
 net/atm/clip.c                                     |    2 +-
 net/atm/common.c                                   |   30 +
 net/bluetooth/Kconfig                              |   13 -
 net/bluetooth/bnep/bnep.h                          |    8 +-
 net/bluetooth/hci_conn.c                           |   34 +-
 net/bluetooth/hci_core.c                           |  204 +-
 net/bluetooth/hci_event.c                          |   39 +-
 net/bluetooth/hci_sock.c                           |   90 +
 net/bluetooth/hci_sysfs.c                          |   38 +
 net/bluetooth/l2cap.c                              |  669 +-
 net/bluetooth/rfcomm/sock.c                        |    2 +-
 net/bluetooth/rfcomm/tty.c                         |    4 +-
 net/bridge/br.c                                    |    2 -
 net/bridge/br_device.c                             |  142 +-
 net/bridge/br_fdb.c                                |    6 +-
 net/bridge/br_forward.c                            |   11 +
 net/bridge/br_if.c                                 |   33 +-
 net/bridge/br_input.c                              |   24 +-
 net/bridge/br_multicast.c                          |   11 +-
 net/bridge/br_netfilter.c                          |   60 +-
 net/bridge/br_netlink.c                            |    9 +-
 net/bridge/br_notify.c                             |    5 +-
 net/bridge/br_private.h                            |   67 +-
 net/bridge/br_stp_bpdu.c                           |    7 +-
 net/bridge/br_sysfs_br.c                           |   72 +
 net/bridge/netfilter/ebt_redirect.c                |    3 +-
 net/bridge/netfilter/ebt_ulog.c                    |    8 +-
 net/bridge/netfilter/ebtables.c                    |   11 +-
 net/caif/Kconfig                                   |    7 +-
 net/caif/Makefile                                  |   14 +-
 net/caif/caif_config_util.c                        |    5 +
 net/caif/caif_dev.c                                |   12 +-
 net/caif/caif_socket.c                             |   61 +-
 net/caif/cfcnfg.c                                  |   54 +-
 net/caif/cfctrl.c                                  |    8 +-
 net/caif/cfdbgl.c                                  |    2 +-
 net/caif/cfdgml.c                                  |    7 +-
 net/caif/cfpkt_skbuff.c                            |    5 +-
 net/caif/cfrfml.c                                  |  318 +-
 net/caif/cfserl.c                                  |    7 +-
 net/caif/cfsrvl.c                                  |   26 +-
 net/caif/cfutill.c                                 |    8 +-
 net/caif/cfveil.c                                  |    7 +-
 net/caif/cfvidl.c                                  |    2 +-
 net/caif/chnl_net.c                                |   67 +-
 net/can/raw.c                                      |   15 +-
 net/compat.c                                       |   53 +-
 net/core/Makefile                                  |    2 +-
 net/core/datagram.c                                |    8 +-
 net/core/dev.c                                     |  387 +-
 net/core/drop_monitor.c                            |   33 +-
 net/core/dst.c                                     |    2 +-
 net/core/ethtool.c                                 |  108 +-
 net/core/filter.c                                  |  212 +-
 net/core/flow.c                                    |    9 +-
 net/core/gen_estimator.c                           |    1 +
 net/core/gen_stats.c                               |   14 +-
 net/core/iovec.c                                   |    9 +-
 net/core/link_watch.c                              |    1 -
 net/core/net-sysfs.c                               |   19 +-
 net/core/netevent.c                                |    5 +-
 net/core/netpoll.c                                 |  182 +-
 net/core/pktgen.c                                  |  212 +-
 net/core/rtnetlink.c                               |   11 +-
 net/core/scm.c                                     |   33 +-
 net/core/skbuff.c                                  |    3 +-
 net/core/sock.c                                    |   49 +-
 net/core/stream.c                                  |    6 -
 net/core/timestamping.c                            |  126 +
 net/core/utils.c                                   |    3 -
 net/dccp/ackvec.c                                  |    4 +-
 net/dccp/ccids/ccid3.c                             |    4 +-
 net/dccp/dccp.h                                    |   12 +-
 net/dccp/input.c                                   |   13 +-
 net/dccp/ipv4.c                                    |    4 +-
 net/dccp/ipv6.c                                    |   30 +-
 net/dccp/options.c                                 |   20 +-
 net/dccp/proto.c                                   |   14 +-
 net/decnet/dn_route.c                              |  158 +-
 net/dsa/slave.c                                    |    3 +-
 net/econet/af_econet.c                             |   27 +-
 net/ethernet/eth.c                                 |    5 +-
 net/ethernet/pe2.c                                 |    3 +-
 net/ipv4/af_inet.c                                 |   84 +-
 net/ipv4/arp.c                                     |   51 +-
 net/ipv4/datagram.c                                |    4 +-
 net/ipv4/devinet.c                                 |    1 +
 net/ipv4/fib_frontend.c                            |   13 +-
 net/ipv4/icmp.c                                    |   37 +-
 net/ipv4/igmp.c                                    |   32 +-
 net/ipv4/inet_connection_sock.c                    |   21 +-
 net/ipv4/inet_fragment.c                           |    1 -
 net/ipv4/inet_hashtables.c                         |    4 -
 net/ipv4/inetpeer.c                                |  244 +-
 net/ipv4/ip_forward.c                              |   10 +-
 net/ipv4/ip_fragment.c                             |   27 +-
 net/ipv4/ip_gre.c                                  |   16 +-
 net/ipv4/ip_input.c                                |   26 +-
 net/ipv4/ip_output.c                               |   78 +-
 net/ipv4/ip_sockglue.c                             |   45 +-
 net/ipv4/ipconfig.c                                |    7 +
 net/ipv4/ipip.c                                    |    8 +-
 net/ipv4/ipmr.c                                    |    8 +-
 net/ipv4/netfilter.c                               |   12 +-
 net/ipv4/netfilter/arp_tables.c                    |   22 +-
 net/ipv4/netfilter/ip_queue.c                      |   57 +-
 net/ipv4/netfilter/ip_tables.c                     |   16 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   50 +-
 net/ipv4/netfilter/ipt_LOG.c                       |   54 +-
 net/ipv4/netfilter/ipt_NETMAP.c                    |    6 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |   12 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |    5 +
 net/ipv4/netfilter/nf_nat_core.c                   |   29 +-
 net/ipv4/netfilter/nf_nat_proto_common.c           |   12 +-
 net/ipv4/netfilter/nf_nat_proto_dccp.c             |    6 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c              |   12 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c             |   10 +-
 net/ipv4/netfilter/nf_nat_proto_sctp.c             |    6 +-
 net/ipv4/netfilter/nf_nat_proto_tcp.c              |    5 +-
 net/ipv4/netfilter/nf_nat_proto_udp.c              |    5 +-
 net/ipv4/netfilter/nf_nat_proto_udplite.c          |    6 +-
 net/ipv4/netfilter/nf_nat_proto_unknown.c          |    4 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   10 +-
 net/ipv4/netfilter/nf_nat_standalone.c             |   10 +-
 net/ipv4/proc.c                                    |   16 +-
 net/ipv4/protocol.c                                |    3 +-
 net/ipv4/raw.c                                     |   22 +-
 net/ipv4/route.c                                   |  518 +-
 net/ipv4/syncookies.c                              |  105 +-
 net/ipv4/tcp.c                                     |   78 +-
 net/ipv4/tcp_input.c                               |   20 +-
 net/ipv4/tcp_ipv4.c                                |  175 +-
 net/ipv4/tcp_minisocks.c                           |    9 +-
 net/ipv4/tcp_output.c                              |   77 +-
 net/ipv4/tcp_timer.c                               |    1 -
 net/ipv4/tunnel4.c                                 |    2 -
 net/ipv4/udp.c                                     |    4 +-
 net/ipv4/udplite.c                                 |    3 +-
 net/ipv4/xfrm4_input.c                             |    1 -
 net/ipv4/xfrm4_policy.c                            |    2 +-
 net/ipv6/addrconf.c                                |   53 +-
 net/ipv6/addrlabel.c                               |    6 +-
 net/ipv6/af_inet6.c                                |   32 +-
 net/ipv6/anycast.c                                 |   96 +-
 net/ipv6/datagram.c                                |   18 +-
 net/ipv6/exthdrs.c                                 |   34 +-
 net/ipv6/fib6_rules.c                              |   10 +-
 net/ipv6/inet6_connection_sock.c                   |    9 +-
 net/ipv6/ip6_fib.c                                 |   30 +-
 net/ipv6/ip6_output.c                              |   38 +-
 net/ipv6/ip6_tunnel.c                              |    8 +-
 net/ipv6/ipv6_sockglue.c                           |    2 -
 net/ipv6/mcast.c                                   |  190 +-
 net/ipv6/ndisc.c                                   |    8 +-
 net/ipv6/netfilter.c                               |    4 +-
 net/ipv6/netfilter/ip6_queue.c                     |   57 +-
 net/ipv6/netfilter/ip6_tables.c                    |   21 +-
 net/ipv6/netfilter/ip6t_LOG.c                      |   81 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |    2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   18 +-
 net/ipv6/proc.c                                    |   17 +-
 net/ipv6/raw.c                                     |   32 +-
 net/ipv6/reassembly.c                              |   21 +-
 net/ipv6/route.c                                   |  319 +-
 net/ipv6/sit.c                                     |   16 +-
 net/ipv6/syncookies.c                              |   58 +-
 net/ipv6/tcp_ipv6.c                                |   47 +-
 net/ipv6/udp.c                                     |   11 +-
 net/irda/irnet/irnet_ppp.c                         |   10 +-
 net/irda/irttp.c                                   |   14 +-
 net/iucv/iucv.c                                    |   14 +-
 net/l2tp/l2tp_ip.c                                 |    6 +-
 net/mac80211/Kconfig                               |    8 +
 net/mac80211/Makefile                              |    4 +
 net/mac80211/agg-rx.c                              |  123 +-
 net/mac80211/agg-tx.c                              |  554 +-
 net/mac80211/cfg.c                                 |  124 +-
 net/mac80211/debugfs.c                             |  154 +-
 net/mac80211/debugfs_key.c                         |    2 +-
 net/mac80211/debugfs_sta.c                         |   65 +-
 net/mac80211/driver-ops.h                          |  102 +-
 net/mac80211/driver-trace.h                        |  210 +-
 net/mac80211/ht.c                                  |   52 +-
 net/mac80211/ibss.c                                |  171 +-
 net/mac80211/ieee80211_i.h                         |   81 +-
 net/mac80211/iface.c                               |  190 +-
 net/mac80211/key.c                                 |  295 +-
 net/mac80211/key.h                                 |   33 +-
 net/mac80211/main.c                                |  124 +-
 net/mac80211/mesh.c                                |   73 +-
 net/mac80211/mesh.h                                |    2 -
 net/mac80211/mesh_hwmp.c                           |    4 +-
 net/mac80211/mesh_pathtbl.c                        |    4 +-
 net/mac80211/mesh_plink.c                          |   42 +-
 net/mac80211/mlme.c                                |  284 +-
 net/mac80211/pm.c                                  |   18 +-
 net/mac80211/rate.h                                |   13 +
 net/mac80211/rc80211_minstrel.c                    |    1 -
 net/mac80211/rc80211_minstrel_ht.c                 |  827 ++
 net/mac80211/rc80211_minstrel_ht.h                 |  130 +
 net/mac80211/rc80211_minstrel_ht_debugfs.c         |  118 +
 net/mac80211/rx.c                                  |  195 +-
 net/mac80211/scan.c                                |    6 +-
 net/mac80211/sta_info.c                            |   24 +-
 net/mac80211/sta_info.h                            |  113 +-
 net/mac80211/status.c                              |    6 +-
 net/mac80211/tkip.c                                |    8 +-
 net/mac80211/tkip.h                                |    2 +-
 net/mac80211/tx.c                                  |  112 +-
 net/mac80211/util.c                                |   42 +-
 net/mac80211/wep.c                                 |   29 +-
 net/mac80211/wep.h                                 |    2 +-
 net/mac80211/work.c                                |   45 +-
 net/mac80211/wpa.c                                 |   13 +-
 net/netfilter/Kconfig                              |   71 +-
 net/netfilter/Makefile                             |    4 +
 net/netfilter/ipvs/Kconfig                         |   11 +-
 net/netfilter/ipvs/ip_vs_app.c                     |   43 -
 net/netfilter/ipvs/ip_vs_conn.c                    |   55 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   57 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   10 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |  176 +-
 net/netfilter/ipvs/ip_vs_proto.c                   |    1 +
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   55 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |   50 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |   56 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  115 +-
 net/netfilter/nf_conntrack_acct.c                  |   14 +-
 net/netfilter/nf_conntrack_core.c                  |   49 +-
 net/netfilter/nf_conntrack_extend.c                |   22 +-
 net/netfilter/nf_conntrack_h323_main.c             |   12 +-
 net/netfilter/nf_conntrack_netbios_ns.c            |    2 +-
 net/netfilter/nf_conntrack_netlink.c               |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   42 +-
 net/netfilter/nfnetlink_log.c                      |   73 +-
 net/netfilter/nfnetlink_queue.c                    |   39 +-
 net/netfilter/xt_CHECKSUM.c                        |   70 +
 net/netfilter/xt_CT.c                              |    4 +-
 net/netfilter/xt_IDLETIMER.c                       |  315 +
 net/netfilter/xt_NOTRACK.c                         |    2 +-
 net/netfilter/xt_RATEEST.c                         |   12 +-
 net/netfilter/xt_TCPMSS.c                          |    8 +-
 net/netfilter/xt_TEE.c                             |    8 +-
 net/netfilter/xt_TPROXY.c                          |    6 +-
 net/netfilter/xt_cluster.c                         |    2 +-
 net/netfilter/xt_connbytes.c                       |   10 +
 net/netfilter/xt_conntrack.c                       |   11 +-
 net/netfilter/xt_cpu.c                             |   63 +
 net/netfilter/xt_ipvs.c                            |  189 +
 net/netfilter/xt_quota.c                           |   12 +-
 net/netfilter/xt_sctp.c                            |    3 +-
 net/netfilter/xt_socket.c                          |    2 +-
 net/netfilter/xt_state.c                           |   14 +-
 net/netfilter/xt_statistic.c                       |   19 +-
 net/netlink/af_netlink.c                           |   42 +-
 net/netlink/genetlink.c                            |   15 +-
 net/packet/af_packet.c                             |   37 +-
 net/phonet/pn_dev.c                                |   15 +-
 net/rose/rose_route.c                              |    4 +-
 net/rxrpc/ar-peer.c                                |    4 +-
 net/sched/act_api.c                                |   11 +-
 net/sched/act_mirred.c                             |   12 +-
 net/sched/act_nat.c                                |   34 +-
 net/sched/act_pedit.c                              |    3 +-
 net/sched/act_police.c                             |   12 +-
 net/sched/act_simple.c                             |    4 +-
 net/sched/cls_u32.c                                |    6 +-
 net/sched/sch_atm.c                                |   98 +-
 net/sched/sch_generic.c                            |   25 +-
 net/sched/sch_htb.c                                |    2 -
 net/sctp/protocol.c                                |    7 +-
 net/sctp/sm_make_chunk.c                           |    2 +-
 net/socket.c                                       |  177 +-
 net/unix/af_unix.c                                 |   99 +-
 net/wanrouter/wanmain.c                            |    7 +-
 net/wanrouter/wanproc.c                            |    7 +-
 net/wireless/chan.c                                |    5 +-
 net/wireless/core.c                                |   65 +-
 net/wireless/core.h                                |    1 +
 net/wireless/genregdb.awk                          |    1 +
 net/wireless/ibss.c                                |    4 +-
 net/wireless/lib80211_crypt_ccmp.c                 |    1 -
 net/wireless/lib80211_crypt_tkip.c                 |    3 +-
 net/wireless/lib80211_crypt_wep.c                  |    1 -
 net/wireless/mlme.c                                |   16 +-
 net/wireless/nl80211.c                             |   93 +-
 net/wireless/reg.c                                 |  668 +-
 net/wireless/reg.h                                 |    2 +-
 net/wireless/scan.c                                |    5 +
 net/wireless/sme.c                                 |    2 +-
 net/wireless/util.c                                |    4 +-
 net/wireless/wext-compat.c                         |   11 +-
 net/xfrm/xfrm_policy.c                             |    3 +-
 1178 files changed, 79952 insertions(+), 58814 deletions(-)
 create mode 100644 Documentation/networking/caif/spi_porting.txt
 create mode 100644 drivers/bluetooth/hci_ath.c
 create mode 100644 drivers/net/bnx2x/Makefile
 rename drivers/net/{ => bnx2x}/bnx2x.h (84%)
 create mode 100644 drivers/net/bnx2x/bnx2x_cmn.c
 create mode 100644 drivers/net/bnx2x/bnx2x_cmn.h
 rename drivers/net/{ => bnx2x}/bnx2x_dump.h (100%)
 create mode 100644 drivers/net/bnx2x/bnx2x_ethtool.c
 rename drivers/net/{ => bnx2x}/bnx2x_fw_defs.h (100%)
 rename drivers/net/{ => bnx2x}/bnx2x_fw_file_hdr.h (100%)
 rename drivers/net/{ => bnx2x}/bnx2x_hsi.h (100%)
 rename drivers/net/{ => bnx2x}/bnx2x_init.h (100%)
 rename drivers/net/{ => bnx2x}/bnx2x_init_ops.h (100%)
 rename drivers/net/{ => bnx2x}/bnx2x_link.c (99%)
 rename drivers/net/{ => bnx2x}/bnx2x_link.h (100%)
 create mode 100644 drivers/net/bnx2x/bnx2x_main.c
 rename drivers/net/{ => bnx2x}/bnx2x_reg.h (100%)
 create mode 100644 drivers/net/bnx2x/bnx2x_stats.c
 create mode 100644 drivers/net/bnx2x/bnx2x_stats.h
 delete mode 100644 drivers/net/bnx2x_main.c
 create mode 100644 drivers/net/caif/caif_spi.c
 create mode 100644 drivers/net/caif/caif_spi_slave.c
 create mode 100644 drivers/net/can/flexcan.c
 create mode 100644 drivers/net/can/usb/esd_usb2.c
 create mode 100644 drivers/net/cxgb4vf/Makefile
 create mode 100644 drivers/net/cxgb4vf/adapter.h
 create mode 100644 drivers/net/cxgb4vf/cxgb4vf_main.c
 create mode 100644 drivers/net/cxgb4vf/sge.c
 create mode 100644 drivers/net/cxgb4vf/t4vf_common.h
 create mode 100644 drivers/net/cxgb4vf/t4vf_defs.h
 create mode 100644 drivers/net/cxgb4vf/t4vf_hw.c
 create mode 100644 drivers/net/wireless/ath/ath5k/sysfs.c
 copy drivers/net/wireless/ath/ath9k/{ar9003_initvals.h => ar9003_2p0_initvals.h} (87%)
 rename drivers/net/wireless/ath/ath9k/{ar9003_initvals.h => ar9003_2p2_initvals.h} (78%)
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_paprd.c
 rename drivers/net/wireless/iwlwifi/{iwl-calib.c => iwl-agn-calib.c} (83%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-rx.c
 delete mode 100644 drivers/net/wireless/libertas/assoc.c
 delete mode 100644 drivers/net/wireless/libertas/assoc.h
 delete mode 100644 drivers/net/wireless/libertas/scan.c
 delete mode 100644 drivers/net/wireless/libertas/scan.h
 delete mode 100644 drivers/net/wireless/libertas/wext.c
 delete mode 100644 drivers/net/wireless/libertas/wext.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_ini.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_scan.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_scan.h
 create mode 100644 firmware/cxgb3/t3fw-7.10.0.bin.ihex
 delete mode 100644 firmware/cxgb3/t3fw-7.4.0.bin.ihex
 create mode 100644 include/linux/can/platform/flexcan.h
 create mode 100644 include/linux/netfilter/xt_CHECKSUM.h
 create mode 100644 include/linux/netfilter/xt_IDLETIMER.h
 create mode 100644 include/linux/netfilter/xt_cpu.h
 create mode 100644 include/linux/netfilter/xt_ipvs.h
 create mode 100644 include/linux/ptp_classify.h
 create mode 100644 include/linux/u64_stats_sync.h
 create mode 100644 include/net/caif/caif_spi.h
 create mode 100644 net/core/timestamping.c
 create mode 100644 net/mac80211/rc80211_minstrel_ht.c
 create mode 100644 net/mac80211/rc80211_minstrel_ht.h
 create mode 100644 net/mac80211/rc80211_minstrel_ht_debugfs.c
 create mode 100644 net/netfilter/xt_CHECKSUM.c
 create mode 100644 net/netfilter/xt_IDLETIMER.c
 create mode 100644 net/netfilter/xt_cpu.c
 create mode 100644 net/netfilter/xt_ipvs.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
