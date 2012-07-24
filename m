Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2GXHl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 03:41:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53590 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2GXHlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 03:41:49 -0400
Date: Tue, 24 Jul 2012 00:41:45 -0700 (PDT)
Message-Id: <20120724.004145.1298680734117318486.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6O7gTNk008306


A lot of stuff here (1870 commits), the most notable parts being:

1) Remove the ipv4 routing cache.  Now lookups go directly into the
   FIB trie and use prebuilt routes cached there.

   No more garbage collection, no more rDOS attacks on the routing
   cache.  Instead we now get predictable and consistent performance,
   no matter what the pattern of traffic we service.

   This has been almost 2 years in the making.  Special thanks to
   Julian Anastasov, Eric Dumazet, Steffen Klassert, and others
   who have helped along the way.

   I'm sure that with a change of this magnitude there will be some
   kind of fallout, but such things ought the be simple to fix at
   this point.  Luckily I'm not European so I'll be around all of
   August to fix things :-)

   The major stages of this work here are each fronted by a forced
   merge commit whose commit message contains a top-level description
   of the motivations and implementation issues.

2) Pre-demux of established ipv4 TCP sockets, saves a route demux
   on input.

3) TCP SYN/ACK performance tweaks from Eric Dumazet.

4) Add namespace support for netfilter L4 conntrack helpers, from Gao
   Feng.

5) Add config mechanism for Energy Efficient Ethernet to ethtool, from
   Yuval Mintz.

6) Remove quadratic behavior from /proc/net/unix, from Eric Dumazet.

7) Support for connection tracker helpers in userspace, from Pablo
   Neira Ayuso.

8) Allow userspace driven TX load balancing functions in TEAM driver,
   from Jiri Pirko.

9) Kill off NLMSG_PUT and RTA_PUT macros, more gross stuff with
   embedded gotos.

10) TCP Small Queues, essentially minimize the amount of TCP data
    queued up in the packet scheduler layer.  Whereas the existing BQL
    (Byte Queue Limits) limits the pkt_sched --> netdevice queuing
    levels, this controls the TCP --> pkt_sched queueing levels.

    From Eric Dumazet.

11) Reduce the number of get_page/put_page ops done on SKB fragments,
    from Alexander Duyck.

12) Implement protection against blind resets in TCP (RFC 5961), from
    Eric Dumazet.

13) Support the client side of TCP Fast Open, basically the ability to
    send data in the SYN exchange, from Yuchung Cheng.

    Basically, the sender queues up data with a sendmsg() call using
    MSG_FASTOPEN, then they do the connect() which emits the queued
    up fastopen data.

14) Avoid all the problems we get into in TCP when timers or PMTU events
    hit a locked socket.  The TCP Small Queues changes added a tcp_release_cb()
    that allows us to queue work up to the release_sock() caller, and that's
    what we use here too.  From Eric Dumazet.

15) Zero copy on TX support for TUN driver, from Michael S. Tsirkin.

Please pull, thanks a lot!

The following changes since commit 3e4b9459fb0e149c6b74c9e89399a8fc39a92b44:

  Merge tag 'md-3.5-fixes' of git://neil.brown.name/md (2012-07-19 08:27:13 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to 320f5ea0cedc08ef65d67e056bcb9d181386ef2c:

  genetlink: define lockdep_genl_is_held() when CONFIG_LOCKDEP (2012-07-24 00:01:30 -0700)

----------------------------------------------------------------
Akeem G. Abodunrin (1):
      igb: reset PHY in the link_up process to recover PHY setting after power down.

Al Viro (5):
      batman-adv: get rid of pointless cast in memcpy()
      batman-adv: trivial endianness annotations
      batman-adv: keep batman_ogm_packet ->seqno net-endian all along
      batman-adv: don't bother flipping ->tt_data
      batman-adv: don't bother flipping ->tt_crc

Alan Cox (1):
      mac80211: fix use after free

Alban Crequy (5):
      netfilter: decnet: switch hook PFs to nfproto
      netfilter: bridge: switch hook PFs to nfproto
      netfilter: ipv4, defrag: switch hook PFs to nfproto
      netfilter: ipvs: switch hook PFs to nfproto
      netfilter: selinux: switch hook PFs to nfproto

Albert Pool (1):
      rt2800usb: 2001:3c17 is an RT3370 device

Alex Hung (1):
      rfkill: Add the capability to switch all devices of all type in __rfkill_switch_all().

Alexander Duyck (52):
      ipv4: Add sysctl knob to control early socket demux
      ixgbe: count q_vectors instead of MSI-X vectors
      ixgbe: Add upper limit to ring features
      ixgbe: Add feature offset value to ring features
      ixgbe: Clean up a useless switch statement and dead code in configure_srrctl
      ixgbe: Merge RSS and flow director ring register caching and configuration
      tcp: Fix out of bounds access to tcpm_vals
      net: Update alloc frag to reduce get/put page usage and recycle pages
      ixgbe: Simplify logic for getting traffic class from user priority
      ixgbe: Cleanup unpacking code for DCB
      ixgbe: Populate the prio_tc_map in ixgbe_setup_tc
      ixgbe: Add function for obtaining FCoE TC based on FCoE user priority
      ixgbe: Merge FCoE set_num and cache_ring calls into RSS/DCB config
      ixgbevf: Drop all dead or unnecessary code
      ixgbevf: Drop netdev_registered value since that is already stored in netdev
      ixgbevf: Make use of NETIF_F_RXCSUM instead of keeping our own flag
      ixgbevf: Drop use of eitr_low and eitr_high for hard coded values
      ixgbevf: Cleanup accounting for space needed at start of xmit_frame
      ixgbevf: Update q_vector to contain ring pointers instead of bitmaps
      ixgbevf: Move Tx clean-up into NAPI context
      ixgbevf: Use igb style interrupt masks instead of ixgbe style
      ixgbe: Ping the VFs on link status change to trigger link change
      ixgbe: Handle failures in the ixgbe_setup_rx/tx_resources calls
      ixgbe: Move configuration of set_real_num_rx/tx_queues into open
      ixgbe: Update the logic for ixgbe_cache_ring_dcb and DCB RSS configuration
      ixgbe: Cleanup logic for MRQC and MTQC configuration
      ixgbevf: Update descriptor macros to accept pointers and drop _ADV suffix
      ixgbevf: Do not rewind the Rx ring before bumping tail
      ixgbevf: Add netdev to ring structure
      ixgbevf: Consolidate Tx context descriptor creation code
      ixgbevf: Fix multiple issues in ixgbevf_get/set_ringparam
      ixgbe: Update configure virtualization to allow for multiple PF pools
      ixgbe: Add support for SR-IOV w/ DCB or RSS
      ixgbe: Retire RSS enabled and capable flags
      ixgbe: Cleanup holes in flags after removing several of them
      ixgbe: Use VMDq offset to indicate the default pool
      ixgbe: Fix memory leak when SR-IOV VFs are direct assigned
      ixgbe: Drop references to deprecated pci_ DMA api and instead use dma_ API
      ixgbe: Cleanup configuration of FCoE registers
      ixgbe: Merge all FCoE percpu values into a single structure
      ixgbe: Make FCoE allocation and configuration closer to how rings work
      ixgbe: Correctly set SAN MAC RAR pool to default pool of PF
      ixgbe: Only enable anti-spoof on VF pools
      ixgbe: Enable FCoE FSO and CRC offloads based on CAPABLE instead of ENABLED flag
      ixgbe: Drop probe_vf and merge functionality into ixgbe_enable_sriov
      ixgbe: Change how we check for pre-existing and assigned VFs
      ixgbevf: Add lock around mailbox ops to prevent simultaneous access
      ixgbevf: Add support for PCI error handling
      ixgbe: Fix handling of FDIR_HASH flag
      ixgbe: Reduce Rx header size to what is actually used
      ixgbe: Use num_tcs.pg_tcs as upper limit for TC when checking based on UP
      ixgbe: Use 1TC DCB instead of disabling DCB for MSI and legacy interrupts

Amir Vadai (4):
      net/mlx4: Move MAC_MASK to a common place
      net/rps: Protect cpu_rmap.h from double inclusion
      {NET,IB}/mlx4: Add rmap support to mlx4_assign_eq
      net/mlx4_en: Add accelerated RFS support

Amitkumar Karwar (14):
      mwifiex: fix simultaneous scan and Tx traffic problem
      mwifiex: scan less channels per scan command to improve Tx traffic
      mwifiex: wake up main thread to handle Tx traffic if scan is delayed/aborted
      mwifiex: enhance power save for USB and PCIe chipsets
      mwifiex: wakeup main thread to handle command queued
      mwifiex: use correct firmware command to get power limits
      mwifiex: do not advertise custom regulatory domain capability
      mwifiex: retrieve correct max_power information in reg_notifier handler
      mwifiex: add set_antenna handler support
      mwifiex: correction in mcs index check
      mwifiex: remove redundant code in set channel path
      mwifiex: remove unnecessary code in data rate configuration
      mwifiex: add support to use basic rates in ibss join request
      mwifiex: improvement in cfg80211 set_bitrate_mask handler

Andre Guedes (8):
      Bluetooth: Change default MTU for L2CAP ATT channel
      Bluetooth: Check MTU value in l2cap_sock_setsockopt_old
      Bluetooth: Rename L2CAP_LE_DEFAULT_MTU
      Bluetooth: Filter duplicated reports in LE scan
      Bluetooth: Remove magic value in disconnect mgmt handler
      Bluetooth: Use GFP_KERNEL in mgmt_handlers
      Bluetooth: Use GFP_KERNEL in mgmt_pending_add
      Bluetooth: Use GFP_KERNEL in mgmt events functions

Andrei Emeltchenko (55):
      Bluetooth: Silent sparse warnings
      Bluetooth: Use defined link key size
      Bluetooth: Preserve L2CAP flags values
      Bluetooth: trivial: Remove empty line
      Bluetooth: Define L2CAP conf continuation flag
      Bluetooth: Define and use PSM identifiers
      Bluetooth: Use __constant when dealing with constants
      Bluetooth: Use __constant modifier in HCI code
      Bluetooth: Define HCI AMP cmd struct
      Bluetooth: Move clean up code and set of SOCK_ZAPPED to l2cap_sock.c
      Bluetooth: Add l2cap_chan->ops->ready()
      Bluetooth: trivial: Use defined PSMLEN instead of magic
      Bluetooth: A2MP: Create A2MP channel
      Bluetooth: A2MP: AMP Manager basic functions
      Bluetooth: A2MP: Build and Send msg helpers
      Bluetooth: A2MP: Add chan callbacks
      Bluetooth: A2MP: Definitions for A2MP commands
      Bluetooth: A2MP: Define A2MP status codes
      Bluetooth: A2MP: Process A2MP messages
      Bluetooth: A2MP: Process A2MP Command Reject
      Bluetooth: A2MP: Process A2MP Discover Request
      Bluetooth: A2MP: Process A2MP Change Notify
      Bluetooth: A2MP: Process A2MP Get Info Request
      Bluetooth: A2MP: Process A2MP Get AMP Assoc Request
      Bluetooth: A2MP: Process A2MP Create Physlink Request
      Bluetooth: A2MP: Process A2MP Disc Physlink Request
      Bluetooth: A2MP: Process A2MP Command Responses
      Bluetooth: A2MP: Handling fixed channels
      Bluetooth: A2MP: Manage incoming connections
      Bluetooth: Do not check func ready existence
      Bluetooth: A2MP: Do not reference hci_conn
      Bluetooth: Make l2cap_data_channel return void
      Bluetooth: Make l2cap_conless_channel return void
      Bluetooth: Make l2cap_att_channel return void
      Bluetooth: Remove magic disconnect reason
      Bluetooth: Use standard HCI cmd timeout for RESET
      Bluetooth: Update HCI timeouts constants to use msecs_to_jiffies
      Bluetooth: Add opcode to error message
      Bluetooth: Correct debug print specifier for u16 objects
      Bluetooth: Fix not setting HCI_RESET flag for AMP
      Bluetooth: Fix compile warnings in mgmt
      Bluetooth: Use AUTO_OFF constant in jiffies
      Bluetooth: Improve debugging messages for hci_conn
      Bluetooth: Fix warning: using int as NULL pointer
      Bluetooth: Route traffic only through BR/EDR controller
      Bluetooth: bluecard_cs: Shorten scope for iobase
      Bluetooth: Do not auto off AMP controller
      Bluetooth: btmrvl: trivial style fixes
      Bluetooth: debug: Add printing num of cmds queued
      Bluetooth: debug: Correct types specifiers for L2CAP
      Bluetooth: debug: Print CID and PSM in hex format
      Bluetooth: debug: Add debug to l2cap_security_cfm
      Bluetooth: debug: Use standard hex object specifiers in hci_event
      Bluetooth: debug: Print l2cap_chan refcount
      Bluetooth: debug: Print amp_mgr refcnt

Andrey Vagin (1):
      net: make sock diag per-namespace

Andrzej Kaczmarek (3):
      Bluetooth: Allow only one LE connection attempt
      Bluetooth: Return proper mgmt state when LE pairing connection failed
      Bluetooth: Fix not removing hci_conn for failed LE connection

Andy Shevchenko (1):
      wireless: brcm80211: use %pM to print BSSID

AnilKumar Ch (2):
      can: c_can: Move overlay structure to array with offset as index
      can: c_can: Add support for Bosch D_CAN controller

Annie Li (1):
      xen/netback: only non-freed SKB is queued into tx_queue

Ansis Atteka (1):
      openvswitch: Do not send notification if ovs_vport_set_options() failed

Antonio Quartulli (7):
      batman-adv: fix skb->data assignment
      batman-adv: convert bat_priv->tt_crc from atomic_t to uint16_t
      batman-adv: use DBG_ALL in log_level sysfs definition
      batman-adv: fix condition in AP isolation
      batman-adv: fix global TT entry deletion
      batman-adv: clear ADD+DEL (and viceversa) events in the same orig-interval
      batman-adv: beautify tt_global_add() argument list

Arend van Spriel (11):
      brcmsmac: remove brcms_set_hint() function
      brcmsmac: fix smatch warning found in ampdu.c
      brcmfmac: add debugfs helper functions
      brcmfmac: expose sdio internal counters in debugfs
      brcmfmac: introduce checkdied debugfs functionality
      brcm80211: add mailing list address for brcm80211 drivers
      brcmfmac: make inclusion of vmalloc.h explicit fixing linux-next build
      brcmsmac: fix NULL pointer crash in brcms_c_regd_init()
      brcmfmac: reduce allocations needed during nvram data download
      brcmfmac: fix sparse warning introduced with checkdied patch
      brcmsmac: fix brcms_c_regd_init() which crashed after 11ad patch

Arik Nemtsov (74):
      wl18xx: create per-chip-family private storage
      wl18xx: set the number of Tx descriptors
      wl18xx: set normal/GEM Tx spare block counts
      wl18xx: implement hw op for calculating hw block count per packet
      wl18xx: implement hw op for setting blocks in hw_tx_desc
      wl18xx: implement hw op for setting frame length in tx_hw_desc
      wl18xx: define HW-rate translation elements/tables
      wl18xx: add fw_status private data
      wl18xx: set Rx block-size alignment quirk
      wl18xx: implement hw op for getting rx buffer data alignment
      wl18xx: implement hw op for getting rx packet data length
      wl18xx: implement immediate Tx completion
      wlcore/wl18xx: add hw op for setting Tx HW checksum
      wlcore/wl18xx: add hw op for Rx HW checksum
      wlcore: track current channel type per vif
      wl18xx: send channel type to FW on role start
      wl18xx: ipmlement ap_rate_mask hw op
      wlcore: support peer MIMO rates
      wlcore/wl18xx: enable MIMO/wide-chan rates in AP-mode rate config
      wl18xx: set HT capabilities
      wl18xx: add module param for overriding HT caps
      wl18xx: read FW pc on recovery
      wl18xx: disable FW log functionality
      wl18xx: implement hw op to read PG version
      wl18xx: init Tx-released index to 0 on HW init
      wl18xx: don't upload NVS to FW
      wl18xx: change board type enum according to new FW
      wlcore/wl12xx/18xx: split fw_status struct into two
      wlcore: fix sparse warnings related to static functions
      wlcore: fix dynamic_ps_timeout time regression
      wlcore: fixes for connection_loss_work
      wl18xx: add dependency on mac80211
      wlcore: remove duplicate BUG_ON during recovery
      mac80211: allow low-level drivers to set netdev feature bits
      wlcore/wl12xx/wl18xx: introduce quirk to remove TKIP header space
      wlcore/wl12xx/wl18xx: handle spare blocks spacial cases per arch
      wlcore: add stop reason bitmap for waking/starting queues
      wlcore: stop queues on Tx flush
      wlcore/wl12xx/wl18xx: implement op_set_key per HW arch
      mac80211: add stations after AP start on reconfig
      wl18xx: allow FW-log by default for PG2.0
      wl18xx: align wl18xx_conf_phy with FW variant and remove it
      wl18xx: clean up phy module parameters
      wlcore/wl12xx/wl18xx: make NVS file optional for wl18xx
      mac80211: stop Rx during HW reconfig
      mac80211: set only VO as a U-APSD enabled AC
      wlcore: suppress error message on Rx BA session removal
      wlcore: allow setting sleep_auth before interface init
      wlcore: reconfigure sleep_auth when removing interfaces
      wl18xx: increase Rx descriptors for PG2
      wl18xx: set Tx align quirk for PG2
      wl18xx: explicitly remove the 5Ghz MIMO HT cap
      wl18xx: sane defaults for HT capabilities
      wl18xx: split siso40 HT cap between 2Ghz and 5Ghz
      wlcore: cancel suspend when recovery is pending
      wlcore: don't allow SDIO read/writes after failure
      wlcore: force recovery on resume if suspended without recovering
      wlcore: check Rx-filter functions in the suspend path
      wlcore: refactor threaded IRQ routine
      wlcore: prevent recovery in the middle of resume
      wlcore/wl12xx/wl18xx: check min FW version
      wlcore: don't stop tx queue via watermark if already stopped
      wlcore: remove recover cmd from testmode
      wlcore: avoid debug prints during intended FW recovery
      wlcore: always clear recovery flag during recovery_work
      wlcore: don't set SDIO_FAILED flag when driver state is off
      wlcore: define number of supported bands internally
      wl12xx/wl18xx: use a dynamic PS timeout of 1.5sec
      wlcore: determine AP extra rates correctly
      mac80211: fix invalid band deref building preq IEs
      wl18xx: alloc conf.phy memory to ensure alignemnt
      wl18xx: fix bogus compile warning on cc config option
      wlcore: don't issue SLEEP_AUTH command during recovery
      wl18xx: enable MIMO rates when connected as a MIMO STA

Arkady Miasnikov (1):
      wlcore: access the firmware memory via debugfs

Assaf Azulay (2):
      wl18xx: change default tcp_checksum to false
      wlcore: increase number of BA sessions to 3

Avinash Patil (15):
      mwifiex: invalidate bss config before setting channel for uAP
      mwifiex: support NL80211_HIDDEN_SSID_ZERO_LEN for uAP
      ieee80211: definitions for Microsoft Vendor OUI and WPA OUI type
      mwifiex: set channel via start_ap handler for AP interface
      mwifiex: set HT capability based on cfg80211_ap_settings
      mwifiex: separate uAP WPA/WPA2 parsing from other BSS parameters
      mwifiex: support for WEP in AP mode
      ieee80211: more OUI type definitions for WLAN_OUI_MICROSOFT
      mwifiex: parse WPA IE and support WPA/WPA2 mixed mode for uAP
      mwifiex: pass cfg80211_beacon_data to mwifiex_set_mgmt_ie()
      mwifiex: separate IE parsing for Head/Tail IEs and beacon_ies etc
      mwifiex: overwrite earlier IE buffers for new set IE request
      mwifiex: add change_beacon cfg80211 handler
      mwifiex: advertise WPS probe response offload support to cfg80211
      mwifiex: parse WPS IEs from beacon_data

Bala Shanmugam (2):
      ath6kl: Add support for setting tx rateset.
      ath9k: fix incorrect profile type manupulation

Barak Witkowski (3):
      bnx2x: Split the FP structure
      bnx2x: Support DCBX for all functions
      bnx2x, bnx2fc, bnx2i, cnic: Add statistics support and FCoE capabilities advertisement

Ben Greear (1):
      ath9k: Support ethtool getstats api.

Ben Hutchings (17):
      net: Update kernel-doc for __alloc_skb()
      ethtool: Make more commands available to unprivileged processes
      net: Properly define functions with no parameters
      net: Fix (nearly-)kernel-doc comments for various functions
      net: Fix non-kernel-doc comments with kernel-doc start marker
      drivers/net/ethernet: Fix (nearly-)kernel-doc comments for various functions
      drivers/net/ethernet: Fix non-kernel-doc comments with kernel-doc start markers
      sfc: Work around bogus 'uninitialised variable' warning
      sfc: Use generic DMA API, not PCI-DMA API
      sfc: Remove dead write to tso_state::packet_space
      sfc: Stop changing header offsets on TX
      sfc: Use strlcpy() to copy ethtool stats names
      sfc: Use dev_kfree_skb() in efx_end_loopback()
      sfc: Explain why efx_mcdi_exit_assertion() ignores result of efx_mcdi_rpc()
      sfc: Disable VF queues during register self-test
      sfc: Fix interface statistics running backward
      sfc: Correct some comments on enum reset_type

Ben Pfaff (1):
      openvswitch: Check gso_type for correct sk_buff in queue_gso_packets().

Bing Zhao (2):
      Bluetooth: btmrvl: add SD8787 Bluetooth AMP device ID
      mwifiex: shorten per channel scan time

BjÃ¸rn Mork (8):
      net: qmi_wwan: define a structure for driver specific state
      net: qmi_wwan: rearranging to prepare for code sharing
      net: qmi_wwan: bind to both control and data interface
      net: qmi_wwan: shorten driver description
      net: qmi_wwan: use module_usb_driver macro
      net: qmi_wwan: make dynamic device IDs work
      net: qmi_wwan: add ZTE MF821D
      net: e100: ucode is optional in some cases

Brandon Misemer (1):
      iwlwifi: Fix Makefile build order for built-in driver

Bruce Allan (1):
      e1000e: use more informative logging macros when netdev not yet registered

Carolyn Wyborny (4):
      igb: Add switch case for supported hardware to igb_ptp_remove.
      igb: Support the get_ts_info ethtool method.
      igb: Update firmware info output
      igb: Version bump

Chris Metcalf (3):
      net: tilegx driver bugfix (be explicit about percpu queue number)
      tilegx net driver: handle payload data not in frags
      tilegx net: use eth_hw_addr_random(), not eth_random_addr()

Chris Yungmann (1):
      brcm80211: brcmsmac: fixed checkpatch and sparse warnings

Christian Hohnstaedt (1):
      phylib: Support registering a bunch of drivers

Christian Lamparter (4):
      mac80211: request TX status for BlockAck Requests
      mac80211: fix read outside array bounds
      carl9170: import 1.9.6 firmware headers
      carl9170: fix HT peer BA session corruption

Christian Riesch (7):
      asix: Rename asix.c to asix_devices.c
      asix: Factor out common code
      asix: Add a new driver for the AX88172A
      asix: Fix return value in AX88172A driver bind function
      asix: Rework reading from EEPROM
      asix: Add support for programming the EEPROM
      asix: AX88172A driver depends on phylib

Chun-Yeow Yeoh (11):
      mac80211: Add missing mesh parameter dot11MeshForwarding for debugfs
      cfg80211: add missing kernel-doc for mesh configuration structure
      {nl,cfg,mac}80211: fix the coding style related to mesh parameters
      {nl,cfg,mac}80211: implement dot11MeshHWMProotInterval and dot11MeshHWMPactivePathToRootTimeout
      mac80211: implement the proactive PREQ generation
      mac80211: implement the proactive PREP generation
      mac80211: invoke the timer only with correct dot11MeshHWMPRootMode value
      {nl,cfg,mac}80211: implement dot11MeshHWMPconfirmationInterval
      mac80211: fix the assignment of mesh element TTL
      mac80211: fix and improve mesh RANN processing
      mac80211: Fix the Problem of Unreachable Mesh STA from DS

Cloud Ren (1):
      atl1c: fix issue of io access mode for AR8152 v2.1

Cong Wang (2):
      netfilter: remove include/linux/netfilter_ipv4/ipt_addrtype.h
      netfilter: xt_connlimit: remove revision 0

Dan Carpenter (16):
      brcm80211: remove an unneeded NULL check
      brcm80211: brcmu_pkt_buf_free_skb() should handle NULL
      net/ethernet: ks8851_mll unregister_netdev() before freeing
      iwlwifi: turn on a lockdep assertion
      iwlwifi: unlock on error path
      net: qmi_wwan: simplify a check in qmi_wwan_bind()
      6lowpan: double unlock on an error path
      netfilter: use kfree_skb() not kfree()
      bnx2i: use strlcpy() instead of memcpy() for strings
      small cleanup in ax25_addr_parse()
      wlcore: fix a couple small memory leaks
      smsc95xx: signedness bug in get_regs()
      net/mlx4: off by one in parse_trans_rule()
      net/mlx4_en: dereferencing freed memory
      qlge: fix an "&&" vs "||" bug
      openvswitch: potential NULL deref in sample()

Daniel Drake (3):
      libertas: Update 11d info only when interface is active
      libertas: handle command failure immediately
      libertas USB: don't set surpriseremoved flag

Dave Jones (1):
      NFC: NCI module license 'unspecified' taints kernel

David Daney (4):
      netdev/phy: Handle IEEE802.3 clause 45 Ethernet PHYs
      netdev/phy/of: Handle IEEE802.3 clause 45 Ethernet PHYs in of_mdiobus_register()
      netdev/phy/of: Add more methods for binding PHY devices to drivers.
      netdev/phy: Add driver for Broadcom BCM87XX 10G Ethernet PHYs

David McCullough (1):
      net/ipv6/route.c: packets originating on device match lo

David Miller (4):
      ipv4: Kill ip_route_input_noref().
      ipv4: Remove rt_key_{src,dst,tos} from struct rtable.
      ipv4: Kill 'rt_src' from 'struct rtable'
      ipv4: Remove 'rt_mark' from 'struct rtable'

David S. Miller (192):
      sparc bpf_jit: support BPF_S_ANC_ALU_XOR_X instruction
      Merge branch 'master' of git://gitorious.org/linux-can/linux-can-next
      Merge git://git.kernel.org/.../davem/net
      inet: Create and use rt{,6}_get_peer_create().
      tcp: Get rid of inetpeer special cases.
      tcp: Cache inetpeer in timewait socket, and only when necessary.
      inet: Initialize per-netns inetpeer roots in net/ipv{4,6}/route.c
      inet: Consolidate inetpeer_invalidate_tree() interfaces.
      ipv6: Do not mark ipv6_inetpeer_ops as __net_initdata.
      inet: Pass inetpeer root into inet_getpeer*() interfaces.
      inet: Hide route peer accesses behind helpers.
      ipv4: Kill ip_rt_frag_needed().
      inet: Add family scope inetpeer flushes.
      inet: Add inetpeer tree roots to the FIB tables.
      inet: Use FIB table peer roots in routes.
      inet: Avoid potential NULL peer dereference.
      Merge branch 'master' of git://1984.lsi.us.es/net-next
      inet: Fix BUG triggered by __rt{,6}_get_peer().
      Merge git://git.kernel.org/.../davem/net
      ipv4: Handle PMTU in all ICMP error handlers.
      ipv6: Handle PMTU in ICMP error handlers.
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../davem/net
      ipv6: Fix types of ip6_update_pmtu().
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      ipv4: Cap ADVMSS metric in the FIB rather than the routing cache.
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'master' of git://gitorious.org/linux-can/linux-can-next
      inet: Sanitize inet{,6} protocol demux.
      ipv4: Early TCP socket demux.
      team: Revert previous two changes.
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      tcp: Validate route interface in early demux.
      ipv4: Don't add deprecated new binary sysctl value.
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      Merge git://git.kernel.org/.../davem/net
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      ipv4: Remove unnecessary code from rt_check_expire().
      ipv4: Cache ip_error() routes even when not forwarding.
      connector: Move cn_test.c away from NLMSG_PUT().
      gdm72xx: Move away from NLMSG_PUT().
      netfilter: ebt_ulog: Move away from NLMSG_PUT().
      decnet: dn_rtmsg: Move away from NLMSG_PUT().
      inet_diag: Move away from NLMSG_PUT().
      netfilter: ipt_ULOG: Move away from NLMSG_PUT().
      netfilter: nfnetlink_log: Move away from NLMSG_PUT().
      netfilter: nfnetlink_queue_core: Move away from NLMSG_PUT().
      pkt_sched: act_api: Move away from NLMSG_PUT().
      unix_diag: Move away from NLMSG_PUT().
      selinux: netlink: Move away from NLMSG_PUT().
      infiniband: netlink: Move away from NLMSG_NEW().
      audit: netlink: Move away from NLMSG_NEW().
      decnet: dn_route: Move away from NLMSG_NEW().
      decnet: dn_table: Move away from NLMSG_NEW().
      pkt_sched: cls_api: Move away from NLMSG_NEW().
      pkt_sched: sch_api: Move away from NLMSG_NEW().
      netlink: Delete NLMSG_PUT and NLMSG_NEW.
      Revert "ipv4: tcp: dont cache unconfirmed intput dst"
      phy: Fix warning in get_phy_device().
      xfrm_user: Propagate netlink error codes properly.
      ipv4: Kill early demux method return value.
      ipv4: Show that ip_send_reply() is purely unicast routine.
      ipv4: Create and use fib_compute_spec_dst() helper.
      ipv4: Kill rt->rt_spec_dst, no longer used.
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge git://git.kernel.org/.../davem/net
      ipv4: Fix bugs in fib_compute_spec_dst().
      ipv4: Adjust in_dev handling in fib_validate_source()
      ipv4: Remove extraneous assignment of dst->tclassid.
      ipv4: Elide fib_validate_source() completely when possible.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      ipv4: Clarify in docs that accept_local requires rp_filter.
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      ipv4: Fix crashes in ip_options_compile().
      ipv4: Make neigh lookups directly in output packet path.
      ipv4: Don't report neigh uptodate state in rtcache procfs.
      sunrpc: Don't do a dst_confirm() on an input routes.
      net: Do delayed neigh confirmation.
      net: Add optional SKB arg to dst_ops->neigh_lookup().
      sch_teql: Convert over to dev_neigh_lookup_skb().
      ipoib: Convert over to dev_lookup_neigh_skb().
      qeth: Convert over to dst_neigh_lookup_skb().
      cxgbi: Convert over to dst_neigh_lookup().
      cxgb4i: Convert over to dst_neigh_lookup().
      br_netfilter: Convert to dst_neigh_lookup_skb().
      neigh: Convert over to dst_neigh_lookup_skb().
      decnet: Use neighbours privately in dn_route struct.
      net: Pass neighbours and dest address into NETEVENT_REDIRECT events.
      cxgb3: Convert t3_l2t_get() over to dst_neigh_lookup().
      ipv6: Store route neighbour in rt6_info struct.
      ipv4: No need to set generic neighbour pointer.
      xfrm: No need to copy generic neighbour pointer.
      net: Kill dst->_neighbour, accessors, and final uses.
      Merge git://git.kernel.org/.../davem/net
      ipoib: Need to do dst_neigh_lookup_skb() outside of priv->lock.
      ipv4: Avoid overhead when no custom FIB rules are installed.
      Merge branch 'master' of git://1984.lsi.us.es/nf-next
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'davem-next.r8169' of git://violet.fr.zoreil.com/romieu/linux
      ipv4: Fix crashes in fib_rules_tclass().
      tcp: Move dynamnic metrics handling into seperate file.
      tcp: Abstract back handling peer aliveness test into helper function.
      tcp: Maintain dynamic metrics in local cache.
      net: Don't report route RTT metric value in cache dumps.
      net: Kill set_dst_metric_rtt().
      tcp: Move timestamps from inetpeer to metrics cache.
      tcp: Remove tw->tw_peer
      inet: Remove ->get_peer() method.
      inet: Minimize use of cached route inetpeer.
      inet: Kill FLOWI_FLAG_PRECOW_METRICS.
      rtnetlink: Remove ts/tsage args to rtnl_put_cacheinfo().
      ipv4: Maintain redirect and PMTU info in struct rtable again.
      ipv4: Enforce max MTU metric at route insertion time.
      ipv4: Kill dst_copy_metrics() call from ipv4_blackhole_route().
      ipv4: Calling ->cow_metrics() now is a bug.
      ipv4: Remove inetpeer from routes.
      Merge branch 'metrics_restructure'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'davem-next.r8169' of git://violet.fr.zoreil.com/romieu/linux
      ipv6: Move ipv6 twsk accessors outside of CONFIG_IPV6 ifdefs.
      ipv4: Pull icmp socket delivery out into a helper function.
      ipv4: Deliver ICMP redirects to sockets too.
      ipv4: Pull redirect instantiation out into a helper function.
      ipv4: Rearrange arguments to ip_rt_redirect()
      ipv4: Generalize ip_do_redirect() and hook into new dst_ops->redirect.
      ipv4: Add ipv4_redirect() and ipv4_sk_redirect() helper functions.
      ipv4: Add redirect support to all protocol icmp error handlers.
      ipv4: Kill ip_rt_redirect().
      ipv6: Export ndisc option parsing from ndisc.c
      ipv6: Move bulk of redirect handling into rt6_redirect().
      ipv6: Pull main logic of rt6_redirect() into rt6_do_redirect().
      ipv6: Add ip6_redirect() and ip6_sk_redirect() helper functions.
      ipv6: Add redirect support to all protocol icmp error handlers.
      ipv6: Use icmpv6_notify() to propagate redirect, instead of rt6_redirect().
      net: Add dummy dst_ops->redirect method where needed.
      net: Remove checks for dst_ops->redirect being NULL.
      Merge branch 'redirect_via_sock'
      ipv4: Fix warnings in ip_do_redirect() for some configurations.
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      ipv4: Put proper checks into icmp_socket_deliver().
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      ipv4: Remove tb_peers from fib_table.
      ipv4: Don't store a rule pointer in fib_result.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      ipv4: Add helper inet_csk_update_pmtu().
      ipv6: Add helper inet6_csk_update_pmtu().
      sctp: Adjust PMTU updates to accomodate route invalidation.
      Merge branch 'tipc_net-next' of git://git.kernel.org/.../paulg/linux
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      net: Pass optional SKB and SK arguments to dst_ops->{update_pmtu,redirect}()
      ipv4: Add FIB nexthop exceptions.
      Merge branch 'nexthop_exceptions'
      ipv4: Fix nexthop exception hash computation.
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'davem-next.r8169' of git://violet.fr.zoreil.com/romieu/linux
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      ipv4: Fix time difference calculation in rt_bind_exception().
      net: Fix warnings in dst_ops.h
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'net' of git://git.kernel.org/.../cmetcalf/linux-tile
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'team_multiq'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      ipv4: Delete routing cache.
      ipv4: Remove 'rt_dst' from 'struct rtable'
      ipv4: Adjust semantics of rt->rt_gateway.
      net: Document dst->obsolete better.
      ipv4: Kill routes during PMTU/redirect updates.
      ipv4: Cache output routes in fib_info nexthops.
      ipv4: Cache input routes in fib_info nexthops.
      ipv4: Kill FLOWI_FLAG_RT_NOCACHE and associated code.
      ipv4: Dirty less cache lines in route caching paths.
      ipv4: Kill rt->rt_oif
      ipv4: Turn rt->rt_route_iif into rt->rt_is_input.
      ipv4: Kill rt->fi
      ipv4: Fix neigh lookup keying over loopback/point-to-point devices.
      Merge branch 'master' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'vhost-net-next' of git://git.kernel.org/.../mst/vhost
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      ixgbe: Fix build with PCI_IOV enabled.
      Merge branch 'kill_rtcache'
      decnet: Don't set RTCF_DIRECTSRC.
      ipv4: Really ignore ICMP address requests/replies.
      ipv4: Remove all RTCF_DIRECTSRC handliing.
      ipv4: Prepare for change of rt->rt_iif encoding.
      net: Make skb->skb_iif always track skb->dev
      ipv4: Change rt->rt_iif encoding.

Denis Efremov (1):
      forcedeth: spin_unlock_irq in interrupt handler fix

Denis Ovsienko (1):
      ipv6: fix RTPROT_RA markup of RA routes w/nexthops

Denys Fedoryshchenko (1):
      netfilter: xt_recent: add address masking option

Devendra Naga (3):
      Bluetooth: cleanup dtl1_config
      r6040: remove duplicate call to the pci_set_drvdata
      r6040: use module_pci_driver macro

Dinh Nguyen (1):
      net: stmmac: Add ip version to dts bindings

Dmitry Kravkov (1):
      bnx2x: organize BDs calculation for stop/resume

Don Fry (1):
      iwlwifi: implement dynamic opmode loading

Don Skidmore (1):
      ixgbe: add support for new 82599 device

Duan Jiong (2):
      lpc_eth: remove duplicated include
      libertas: firmware.c: remove duplicated include

Eddie Wai (2):
      cnic: Read bnx2x function number from internal register
      cnic: Handle RAMROD_CMD_ID_CLOSE error.

Eldad Zack (1):
      include/net/dst.h: neaten asterisk placement

Eliad Peller (24):
      wlcore: use the original elp time in forced_ps mode
      wlcore: use correct link for bcast/multicast frames
      wlcore: flush before stopping AP
      wlcore: set wl->ht_cap per-band
      wlcore: flush tx on CHANGE_CHANNEL
      wlcore: increase WL1271_EVENT_TIMEOUT
      mac80211: use offchannel queue only when supported
      mac80211: fail authentication when AP denied authentication
      nl80211: add new rssi event to indicate beacon loss
      mac80211: remove ieee80211_get_operstate()
      wl12xx: send beacon loss events to userspace
      wl12xx/wl18xx: add erp protection IE to the beacon filter
      wlcore: compare ssid_len before comparing ssids
      wlcore: update basic rates on channel switch
      wlcore: declare interface combinations
      mac80211: flush queues before deauth/disassoc
      mac80211: don't require associated->beacon_ies for ps
      mac80211: allow calling ieee80211_ap_probereq_get() during auth/assoc
      mac80211: always set in_reconfig=false on wakeup
      wlcore: implement .flush callback
      wlcore: check ssid length against the correct element
      mac80211: go out of PS before sending disassoc
      wlcore: use basic rates for non-data packets
      mac80211: flush stations before stop beaconing

Emeric Vigier (1):
      smsc95xx: support ethtool get_regs

Emil Tantilov (1):
      ixgbe: do not compile ixgbe_sysfs.c when CONFIG_IXGBE_HWMON is not set

Emmanuel Grumbach (33):
      iwlwifi: fix prints in iwl_rx_handle
      iwlwifi: s/iwlagn_txq_free_tfd/iwl_txq_free_tfd
      iwlwifi: s/iwlagn_unmap_tfd/iwl_unmap_tfd
      iwlwifi: SCD_INT_MSK is obsolete - don't update it
      iwlwifi: first config the SCD queues, then activate them
      iwlwifi: use iwl_trans_set_wr_ptrs to init the queues
      iwlwifi: s/txq_agg_disable/txq_disable
      iwlwifi: s/txq_setup/txq_enable
      iwlwifi: update mask value for SCD queue config
      iwlwifi: allocate Tx cmd pool per device
      iwlwifi: fix rf configuration
      iwlwifi: configure the SKU in the HW
      iwlwifi: s/iwl_read_targ_mem_words/iwl_read_targ_mem_bytes
      iwlwifi: iwl_{read,write}_targ_mem_words takes dwords
      iwlwifi: print more info when a queue is stuck
      iwlwifi: don't configure a txq that is being disabled
      iwlwifi: remove lock around txq_enable
      iwlwifi: comment that setting driver_data overrides info->control
      iwlwifi: print even more info when a queue is stuck
      iwlwifi: don't modify the timer if we don't Tx
      iwlwifi: warn if TFD index and WiFi Seq don't match
      iwlwifi: WARN only once when we have trouble in reclaim
      iwlwifi: check that we have enough bits to track the TX queues
      iwlwifi: print the scratch of all the buffers stuck in a queue
      iwlwifi: comment context requirements of the op_mode
      iwlwifi: disable BH before the call to iwl_op_mode_nic_error
      iwlwifi: don't disable interrupt in iwl_abort_notification_waits
      iwlwifi: don't disable interrupt while starting tx
      iwlwifi: protect use_ict with irq_lock
      iwlwifi: disable early power Off reset for all NICs
      iwlwifi: configure the queues from the op_mode
      iwlwifi: disable the watchdog for queues by default
      iwlwifi: REPLY_RX doesn't exist any more

Eric BÃ©nard (1):
      can: flexcan: add PM support

Eric Dumazet (42):
      tcp: tcp_make_synack() can use alloc_skb()
      tcp: tcp_make_synack() consumes dst parameter
      net: use consume_skb() in place of kfree_skb()
      sock_diag: add SK_MEMINFO_BACKLOG
      x86 bpf_jit: support BPF_S_ANC_ALU_XOR_X instruction
      af_unix: speedup /proc/net/unix
      af_unix: remove unix_iter_state
      net: keep name_hlist close to name
      bonding: remove packet cloning in recv_probe()
      bonding: drop_monitor aware
      net: lpc_eth: free skbs in start_xmit
      inetpeer: inetpeer_invalidate_tree() cleanup
      ipv4: tcp: dont cache output dst for syncookies
      net: struct sock cleanups
      ipv4: tcp: dont cache unconfirmed intput dst
      net: skb_free_datagram_locked() doesnt drop all packets
      net: l2tp_eth: provide tx_dropped counter
      ipv4: defer fib_compute_spec_dst() call
      ipv6: remove redundant declarations
      ipv6: fix a bad cast in ip6_dst_lookup_tail()
      asix: avoid copies in tx path
      bnx2x: populate skb->l4_rxhash
      ipv6: optimize ipv6 addresses compares
      tcp: TCP Small Queues
      tcp: add LAST_ACK as a valid state for TSQ
      tcp: add OFO snmp counters
      be2net: dont pull too much data in skb linear part
      netem: refine early skb orphaning
      tcp: implement RFC 5961 3.2
      tcp: implement RFC 5961 4.2
      ipv4: fix rcu splat
      ipv6: fix inet6_csk_xmit()
      bonding: refine IFF_XMIT_DST_RELEASE capability
      tcp: refine SYN handling in tcp_validate_incoming
      net: ftgmac100/ftmac100: dont pull too much data
      ipv6: add ipv6_addr_hash() helper
      ipv4: tcp: remove per net tcp_sock
      tcp: use hash_32() in tcp_metrics
      tcp: fix ABC in tcp_slow_start()
      tcp: improve latencies of timer triggered events
      ipv4: tcp: set unicast_sock uc_ttl to -1
      tcp: dont drop MTU reduction indications

Eric Lapuyade (16):
      NFC: Prepare asynchronous error management for driver and shdlc
      NFC: Removed addressed shdlc TODOs
      NFC: Handle SHDLC RSET frames from an SHDLC connected chip
      NFC: Remove an impossible HCI error case
      NFC: Implement HCP reaggregation allocation error case
      NFC: Changed HCI cmd execution completion result to std linux errno
      NFC: Driver failure API
      NFC: Factorize HCI cmd completion
      NFC: Implement HCI driver or internal error management
      NFC: Core must test the device polling state inside the device lock
      NFC: nfc_targets_found() should accept zero target found
      NFC: nfc_driver_failure() implementation
      NFC: Error management documentation
      NFC: update PN544 HCI driver state when opened/closed
      NFC: Allow HCI driver to pre-open pipes to some gates
      NFC: Set target nfcid1 for all HCI reader A targets

Erik Hugne (5):
      tipc: use standard printk shortcut macros (pr_err etc.)
      tipc: remove TIPC packet debugging functions and macros
      tipc: simplify print buffer handling in tipc_printf
      tipc: phase out most of the struct print_buf usage
      tipc: remove print_buf and deprecated log buffer code

Etay Luz (1):
      ath6kl: support changing dtim period on AP mode

Eyal Shapira (9):
      wlcore: add support macros to easily add conf debugfs entries
      wlcore: add debugfs control over rx interrupt pacing
      wlcore: avoid using NET_IP_ALIGN for RX alignment
      wlcore: send EAPOLs with basic rate policy
      mac80211: fix cleanup if driver suspend callback fails
      wlcore: fix broken TX due to wrong queuing of recovery
      wlcore: queue recovery in case of bus errors during cmd_remove_peer
      wlcore: print stack trace in every recovery
      wlcore: don't re-configure wakeup conditions if not needed

Federico Vaga (1):
      c_can_pci: generic module for C_CAN/D_CAN on PCI

Felix Fietkau (28):
      cfg80211: fix regression in multi-vif AP start
      ath9k_hw: remove aniState->noiseFloor
      ath9k_hw: fix OFDM weak signal detection handling
      ath9k_hw: remove confusing logic inversion in an ANI variable
      ath9k_hw: clean up / fix ANI mode checks related to beacon RSSI
      ath9k_hw: remove the old ANI implementation
      ath9k_hw: clean up defines and variables from the ANI implementation split
      ath9k: remove MIB interrupt support
      ath9k_hw: fix setting lower noise immunity values
      ath9k_hw: clean up ANI OFDM trigger handling
      ath9k: fix ANI operation in AP mode
      ath9k: update AR934x initvals to latest version
      ath9k: de-duplicate initvals
      cfg80211: ignore channel state for stopped AP/mesh interfaces
      ath9k_hw: fix 5 GHz frequency selection on AR934x/AR955x with 25 MHz refclock
      ath9k_hw: fall back to OTP ROM when platform data has no valid eeprom data
      ath9k: validate rx antenna settings
      ath9k_hw: enable ANI on AR934x
      ath9k_hw: fix tx gain tables for AR934x
      ath9k_hw: remove redundant arguments to INIT_INI_ARRAY
      ath9k/ath9k_htc: fix txop limit handling
      ath9k: make per-WMM-AC queue sizes configurable via debugfs
      ath9k: fix aggregate size limit based on queue TXOP limit
      ath9k_hw: apply XPA timing control values from EEPROM
      ath9k_hw: clean up AR9003 EEPROM code
      ath9k_hw: apply XLNA bias settings from EEPROM
      ath9k_hw: fix SREV checks for applying tuning caps from EEPROM
      ath5k: fix txop limit handling

Flavio Leitner (1):
      netxen: fix link notification order

Florian Westphal (2):
      netfilter: NFQUEUE: don't xor src/dst ip address for load distribution
      net: sched: add ipset ematch

Forest Bond (1):
      rtlwifi: rtl8192de: Fix phy-based version calculation

Francois Romieu (6):
      r8169: mdio_ops signature change.
      r8169: csi_ops signature change.
      r8169: ephy, eri and efuse functions signature changes.
      r8169: abstract out loop conditions.
      r8169: verbose error message.
      r8169: revert "add byte queue limit support".

Franky Lin (5):
      brcmfmac: add support for bus specific data command
      brcmfmac: restrict dongle txglom disable to old SDIO core
      brcmfmac: move glom alignment setting to SDIO bus layer
      brcmfmac: use firmware data buffer directly for nvram
      brcmfmac: add BCM4334 support

Gabor Juhos (20):
      ath9k: define DEVID for QCA955x
      ath9k: define MAC version for AR9550
      ath9k: set MAC version for AR9550
      ath9k: add platform_device_id for AR9550
      ath9k: add BB name string for AR9550
      ath9k: clear pciexpress flag for AR9550
      ath9k: enable TX/RX data byte swap for AR9550
      ath9k: add initvals for AR9550
      ath9k: add mode register initialization code for AR9550
      ath9k: read spur frequency information from eeprom for AR9550
      ath9k: fix XPABIASLEVEL settings for AR9550
      ath9k: fix antenna control configuration for AR9550
      ath9k: fix PAPRD settings for AR9550
      ath9k: fix RF channel frequency configuration for AR9550
      ath9k: disable SYNC_HOST1_FATAL interrupts for AR9550
      ath9k: skip internal regulator configuration for AR9550
      ath9k: fix PLL initialization for AR9550
      ath9k: enable PLL workaround for AR9550
      ath9k: set 4ADDRESS bit in RX filter for AR9550
      ath9k: enable support for AR9550

Gao feng (29):
      netfilter: nf_conntrack: prepare namespace support for l4 protocol trackers
      netfilter: nf_conntrack: prepare namespace support for l3 protocol trackers
      netfilter: nf_ct_generic: add namespace support
      netfilter: nf_ct_tcp: add namespace support
      netfilter: nf_ct_udp: add namespace support
      netfilter: nf_ct_icmp: add namespace support
      netfilter: nf_ct_icmp: add namespace support
      netfilter: nf_ct_ipv4: add namespace support
      netfilter: nf_ct_ipv6: add namespace support
      netfilter: nf_ct_sctp: add namespace support
      netfilter: nf_ct_udplite: add namespace support
      netfilter: nf_ct_dccp: use new namespace support
      netfilter: nf_ct_gre: use new namespace support
      netfilter: nf_conntrack: add namespace support for cttimeout
      inetpeer: add namespace support for inetpeer
      inetpeer: add parameter net for inet_getpeer_v4,v6
      netfilter: nf_conntrack: fix nf_conntrack_l3proto_register
      netfilter: nf_conntrack: prepare l4proto->init_net cleanup
      netfilter: nf_conntrack: add nf_ct_kfree_compat_sysctl_table
      netfilter: nf_conntrack: use l4proto->users as refcount for per-net data
      netfilter: nf_conntrack: fix memory leak if sysctl registration fails
      netfilter: nf_ct_tcp: merge tcpv[4,6]_net_init into tcp_net_init
      netfilter: nf_ct_udp: merge udpv[4,6]_net_init into udp_net_init
      netfilter: nf_ct_udplite: add udplite_kmemdup_sysctl_table function
      netfilter: nf_ct_sctp: merge sctpv[4,6]_net_init into sctp_net_init
      netfilter: nf_ct_generic: add generic_kmemdup_sysctl_table function
      netfilter: nf_ct_dccp: add dccp_kmemdup_sysctl_table function
      netfilter: nf_ct_icmp: add icmp_kmemdup[_compat]_sysctl_table function
      netfilter: nf_ct_icmpv6: add icmpv6_kmemdup_sysctl_table function

Giuseppe CAVALLARO (5):
      stmmac: remove two useless initialisations
      stmmac: do not use strict_strtoul but kstrtoint
      stmmac: update the driver Documentation and add EEE
      stmmac: add the Energy Efficient Ethernet support
      phy: add the EEE support and the way to access to the MMD registers.

Grant Erickson (1):
      wl12xx: Add support for an external 26 MHz crystal source

Grazvydas Ignotas (3):
      wl1251: remove unused filter_work
      wl1251: fix filtering support
      wl1251: send filters to firmware as they are set

Greg KH (1):
      tg3: add device id of Apple Thunderbolt Ethernet device

Greg Rose (1):
      ixgbevf: Fix namespace issue with ixgbe_write_eitr

Greg Ungerer (2):
      m68knommu: move the badly named mcfne.h to a better mcf8390.h
      net: add support for NS8390 based eth controllers on some ColdFire CPU boards

Gregory Greenman (1):
      iwlwifi: Move IWL_MASK macro to transport.

Gustavo Padovan (31):
      Bluetooth: Fix coding style in mgmt.c
      Bluetooth: Fix coding style in sco.c
      Bluetooth: Fix coding style in hci_sock.c
      Bluetooth: Fix coding style in hci_sysfs.c
      Bluetooth: Fix coding style in hci_event.c
      Bluetooth: Fix coding style in hci_conn.c
      Bluetooth: Fix coding style in hci_core.c
      Bluetooth: Do not purge queue in Basic Mode
      Bluetooth: Remove double check for BT_CONNECTED
      Bluetooth: Remove dead int returns
      Bluetooth: Fix trailing whitespaces in license text
      Bluetooth: Remove most of the inline usage
      Bluetooth: Remove 'register' usage from the subsystem
      Bluetooth: Fix coding style in include/net/bluetooth
      Bluetooth: Fix coding style in the subsystem
      Bluetooth: Remove unnecessary headers include
      Bluetooth: Remove unneeded EXPORT_SYMBOL
      Bluetooth: Use lmp_ssp_capable() macro
      Bluetooth: Get a more accurate L2CAP PDU len
      Bluetooth: Remove extra l2cap_state_change(BT_CONNECTED)
      Bluetooth: Use l2cap_chan_ready() in LE path
      Bluetooth: Use chan as parameters for l2cap chan ops
      Bluetooth: Use chan->state instead of sk->sk_state
      Bluetooth: Move check for backlog size to l2cap_sock.c
      Bluetooth: check for already existent channel before create new one
      Bluetooth: Create function to return the ERTM header size
      Bluetooth: Remove unused err var from l2cap_segment_sdu()
      Bluetooth: Create empty l2cap ops function
      Bluetooth: Fix style in hidp code
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth

Hadar Hen Zion (9):
      net/mlx4_core: Change resource tracking mechanism to use red-black tree
      net/mlx4_core: Change resource tracking ID to be 64 bit
      net/mlx4: Set steering mode according to device capabilities
      net/mlx4_core: Add firmware commands to support device managed flow steering
      {NET, IB}/mlx4: Add device managed flow steering firmware API
      net/mlx4_core: Add resource tracking for device managed flow steering rules
      net/mlx4: Implement promiscuous mode with device managed flow-steering
      net/mlx4_en: Manage flow steering rules with ethtool
      net/mlx4_en: Add support for drop action through ethtool

Haiyang Zhang (1):
      hyperv: Add support for setting MAC from within guests

Hauke Mehrtens (29):
      ssb: recognize ARM Cortex M3
      bcma: extend workaround for bcm4331
      bcma: add constants for chip ids
      bcma: remove fix for 4329b0 bad LPOM is detection
      bcma: add PCI ID for BCM43224
      bcma: complete workaround for BCMA43224 and BCM4313
      bcma: remove bcma_pmu_{pll,swreg}_init()
      bcma: remove chip ids doing nothing from PMU initialization.
      bcma: add bcma_pmu_spuravoid_pllupdate()
      bcma: add mdelay bcma_pmu_resources_init()
      brcmsmac: remove PCIE() macro
      brcmsmac: remove PCI_FORCEHT() macro
      brcmsmac: remove ai_get_buscore{type,rev}()
      brcmsmac: use container_of instead of cast
      brcmsmac: remove ai_findcore()
      brcmsmac: remove si_pmu_init() and si_pmu_res_init()
      brcmsmac: remove si_pmu_spuravoid_pllupdate()
      brcmsmac: remove some redundant chip common workarounds
      brcmsmac: use core id constants from bcma
      brcmsmac: use chip and package id constants from bcma
      brcmsmac: remove some unnessessacry casts and void pointer
      brcmsmac: add a conditions for core rev 17 again
      brcmsmac: add some workarounds for other chips again
      brcmsmac: extend xmtfifo_sz array
      brcmsmac: fix DMA on SoCs
      brcmsmac: extend brcms_c_chipmatch() to also handle non PCIe devices
      brcmsmac: fix read in write_phy_reg
      brcmsmac: handle non PCI devices in the phy code
      bcma: add PMU clock support for BCM4706

Hayes Wang (4):
      r8169: add RTL8106E support.
      r8169: support RTL8168G
      r8169: fix argument in rtl_hw_init_8168g.
      r8169: remove rtl_ocpdr_cond.

Heiko Schocher (1):
      net: ethernet: davinci_emac: add OF support

Holger Schurig (1):
      mac80211: send beacon loss events to userspace

Hong zhi guo (1):
      macvtap: use prepare_to_wait/finish_wait to ensure mb

Hui Wang (2):
      can: flexcan: use of_property_read_u32 to get DT entry value
      can: flexcan: add hardware controller version support

Ido Reis (6):
      wl18xx: fix PHY_INIT addresses mem size
      wl18xx: support PG2 version of the chip
      wl18xx: FW/PHY arguments added for PG2
      wl18xx: PG2.0 HW Watch dog interrupt support
      wl18xx: pad only last frame in aggregration buffer for PG2
      wl18xx: update fw statistics

Ido Yariv (12):
      wlcore: Fix sdio out-of-sync power state
      wlcore: Disable interrupts while recovering
      wlcore: Change read/write ops to return errors
      wlcore: Change raw io functions to return errors
      wlcore: Propagate errors from wlcore_raw_*_data functions
      wlcore: Propagate errors from wl1271_read
      wlcore: Propagate errors from wl1271_write
      wlcore: Propagate errors from wl1271_raw_read32
      wlcore: Propagate errors from wl1271_raw_write32
      wlcore: Propagate errors from wl1271_read_hwaddr
      wlcore: Force checking of io functions' return values
      wlcore: Prevent processing of work items during op_stop

Igal Chernobelsky (3):
      wlcore: modify bss loss parameters
      wlcore: read FW logs from FW memory on watchdog recovery
      wlcore: send EAPOLs using minimum basic rate for all roles

Ilan Peer (5):
      iwlwifi: Check BSS ctx active before call mac80211
      iwlwifi: handle race condition in ROC flow
      iwlwifi: clear STATUS_SCAN_HW when PAN_PARAMS fails
      iwlwifi: refactor testmode
      iwlwifi: decouple testmode and iwl-test

Ioan Orghici (1):
      sctp: fix sparse warning for sctp_init_cause_fixed

Ira W. Snyder (6):
      can: janz-ican3: remove dead code
      can: janz-ican3: drop invalid skbs
      can: janz-ican3: fix error and byte counters
      can: janz-ican3: fix support for CAN_RAW_RECV_OWN_MSGS
      can: janz-ican3: avoid firmware lockup caused by infinite bus error quota
      can: janz-ican3: add support for one shot mode

Jacob Keller (5):
      ixgbe: ptp code cleanup
      ixgbe: PTP Fix hwtstamp mode settings
      ixgbe: Check PTP Rx timestamps via BPF filter
      ixgbe: add support for 1G SX modules
      ixgbe: clean up ixgbe_get_settings ethtool function

Jaganath Kanakkassery (1):
      Bluetooth: Refactor PIN code rejection to use user_pairing_resp()

Jan Ceuleers (5):
      gianfar: whitespace cleanup - pointers and multiplications
      gianfar: comment cleanup
      gianfar: various coding style and whitespace cleanups
      gianfar: Remove superfluous initialisations
      gianfar_ethtool: coding style and whitespace cleanups

Javier Cardona (2):
      mac80211: Remove unused variable
      mac80211: Rename stainfo variable for the more common sta

Javier Martinez Canillas (1):
      connector: use nlmsg_put() instead of NLMSG_PUT() macro.

Jefferson Delfes (1):
      Bluetooth: Fix flags of mgmt_device_found event

Jeongdo Son (1):
      rt2x00: Add support for BUFFALO WLI-UC-GNM2 to rt2800usb.

Jesper Juhl (1):
      net: Fix references to out-of-scope variables in put_cmsg_compat()

Jesse Gross (2):
      openvswitch: Enable retrieval of TCP flags from IPv6 traffic.
      openvswitch: Reset upper layer protocol info on internal devices.

Jiri Pirko (42):
      team: make team_mode struct const
      team: for nomode use dummy struct team_mode
      team: add mode priv to port
      team: lb: push hash counting into separate function
      team: allow read/write-only options
      team: introduce array options
      team: comments: s/net\/drivers\/team/drivers\/net\/team/
      team: push array_index and port into separate structure
      team: allow async option changes
      team: fix error path in team_nl_fill_options_get()
      team: fix error path in team_nl_fill_port_list_get()
      team: allow to specify one option instance to be send to userspace
      team: pass NULL to __team_option_inst_add() instead of 0
      team: add port_[enabled/disabled] mode callbacks
      team: lb: introduce infrastructure for userspace driven tx loadbalancing
      team: implement multipart netlink messages for options transfers
      team: ensure correct order of netlink messages delivery
      team: allow to send multiple set events in one message
      team: use rcu_dereference_bh() in tx path
      team: use rcu_access_pointer to access RCU pointer by writer
      team: use RCU_INIT_POINTER for NULL assignment of RCU pointer
      team: do RCU update path fixups
      team: fix team_adjust_ops with regard to enabled ports
      team: do not allow to map disabled ports
      team: remove unused rcu_head field from team_port struct
      virtio_net: allow to change mac when iface is running
      net: introduce new priv_flag indicating iface capable of change mac when running
      virtio_net: use IFF_LIVE_ADDR_CHANGE priv_flag
      team: use IFF_LIVE_ADDR_CHANGE priv_flag
      dummy: use IFF_LIVE_ADDR_CHANGE priv_flag
      team: use function team_port_txable() for determing enabled and up port
      team: add broadcast mode
      team: make team_port_enabled() and team_port_txable() static inline
      netpoll: move np->dev and np->dev_name init into __netpoll_setup()
      team: add netpoll support
      team: refine IFF_XMIT_DST_RELEASE capability
      net: honour netif_set_real_num_tx_queues() retval
      rtnl: allow to specify different num for rx and tx queue count
      rtnl: allow to specify number of rx and tx queues on device creation
      net: rename bond_queue_mapping to slave_dev_queue_mapping
      bond_sysfs: use real_num_tx_queues rather than params.tx_queue
      team: add multiqueue support

Jitendra Kalsaria (10):
      qlcnic: fix unsupported CDRP command error message.
      qlge: Fix TX queue stoppage due to full condition.
      qlge: Cleanup atomic queue threshold check.
      qlge: Fix ethtool WOL calls to operate only on devices that support WOL.
      qlge: Clean up ethtool set WOL routine.
      qlge: Added missing case statement to ethtool get_strings.
      qlge: Fixed double pci free upon tx_ring->q allocation failure.
      qlge: Moving low level frame error to ethtool statistics.
      qlge: Refactoring of ethtool stats.
      qlge: Bumped driver version to 1.00.00.31

Joe Perches (18):
      net: Remove casts to same type
      net/9p: Add __force to cast of __user pointer
      net: mac80211: Convert printk(KERN_DEBUG to pr_debug
      net: mac80211: Add and use ht_vdbg debugging macro
      net: mac80211: Add and use ibss_vdbg debugging macro
      ethernet: Remove casts to same type
      wireless: Remove casts to same type
      drivers: net: Remove casts to same type
      ath6kl: Add missing newline terminations
      phy: Use pr_<level>
      etherdevice: Rename random_ether_addr to eth_random_addr
      ethernet: Use eth_random_addr
      net: usb: Use eth_random_addr
      wireless: Use eth_random_addr
      drivers/net: Use eth_random_addr
      s390: Use eth_random_addr
      usb: Use eth_random_addr
      arch: Use eth_random_addr

Johan Hedberg (19):
      Bluetooth: Change page scan interval in fast connectable mode
      Bluetooth: Initial skeleton for Three-wire UART (H5) support
      Bluetooth: Add basic state tracking to Three-wire UART driver
      Bluetooth: Add initial reliable packet support for Three-wire UART
      Bluetooth: Add basic packet parsing to Three-wire UART driver
      Bluetooth: Add initial packet sending support to Three-wire UART
      Bluetooth: Add Three-wire header value convenience macros
      Bluetooth: Fix/implement Three-wire reliable packet sending
      Bluetooth: Add support for Three-wire Link Control packets
      Bluetooth: Simplify hci_uart_tty_close logic
      Bluetooth: Add delayed init sequence support for UART controllers
      Bluetooth: Use delayed init for Three-wire UART
      Bluetooth: Improve rx debug logs for Three-wire UART
      Bluetooth: Add initial sleep support to Three-wire UART
      Bluetooth: Add initialization tracking to HCI Three-wire driver
      Bluetooth: Implement proper low-power support for Three-wire UART
      Bluetooth: Remove unnecessary h5_build_pkt function
      Bluetooth: Improve Three-wire UART configuration handling
      Bluetooth: Introduce a flags variable to Three-wire UART state

Johannes Berg (111):
      iwlwifi: add __printf argument checking
      iwlwifi: properly handle device_set_wakeup_enable
      iwlwifi: move IWL_CMD_FAILED_MSK
      iwlwifi: move notification wait into core
      iwlwifi: clean up coding style in PCIe transport
      wireless: remove wext sysfs
      cfg80211: deprecate CFG80211_WEXT
      mac80211: simplify association HT parameters
      mac80211: clean up ieee80211_set_channel
      mac80211: move ieee80211_set_channel function
      cfg80211: simplify cfg80211_can_beacon_sec_chan API
      cfg80211: provide channel to start_ap function
      cfg80211: disallow setting channel on WDS interfaces
      cfg80211: provide channel to join_mesh function
      iwlwifi: make a lot of functions static
      iwlwifi: use mac80211 channel in connection init
      iwlwifi: trust mac80211 channel setting
      iwlwifi: use mac80211 channels for reset scan
      iwlwifi: use mac80211 channel for radar check
      iwlwifi: give HT format to mac80211/radiotap
      iwlwifi: move PCIe into subdirectory
      iwlwifi: trust mac80211 HT40 setting
      iwlwifi: move DVM code into subdirectory
      iwlwifi: unify tx_chains_num setting
      iwlwifi: move ht40 bitmap into config
      iwlwifi: add iwl_set_bits_mask
      iwlwifi: refactor EEPROM reading/parsing
      iwlwifi: configure PHY version for 1000 series
      iwlwifi: move RF config into NIC config
      iwlwifi: remove extern opmode ops declarations
      cfg80211: clarify set_channel APIs
      mac80211: print info when disabling HT
      cfg80211: validate remain-on-channel time better
      wireless: update wireless URLs
      mac80211: do remain-on-channel while idle
      mac80211: unify SW/offload remain-on-channel
      mac80211: remove unneeded ieee80211_run_deferred_scan()
      iwlwifi: fix dynamic loading
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: fix 6035 device parameters
      iwlwifi: use request_module instead of _nowait
      mac80211: allow cancelling dependent ROCs
      nl80211: fix sched scan match attribute name
      cfg80211/nl80211: fix kernel-doc
      iwlwifi: delay ROC if doing internal reset scan
      iwlwifi: fix 11n_disable EEPROM refactoring regression
      iwlwifi: use minimal time for radio reset scan
      iwlwifi: remove sku field from hw_params
      cfg80211: make some functions static
      nl80211: refactor __cfg80211_rdev_from_info
      nl80211: fix netns separation
      nl80211: change __cfg80211_rdev_from_info
      nl80211: use __cfg80211_rdev_from_attrs for testmode
      mac80211: fix double-start of remain-on-channel
      iwlwifi: fix radio reset scan dwell vs. quiet time
      iwlwifi: increase scan timeout
      iwlwifi: limit mac_change_interface to BSS context
      mac80211: remove TKIP debug
      mac80211: two small verbose debug cleanups
      mac80211: pass sdata to some RX functions
      mac80211: clean up debugging
      mac80211: rename driver-trace file
      mac80211: trace debug messages
      iwlwifi: bump trace message limit
      iwlwifi: use __get_str in tracing
      iwlwifi: limit dwell time more strictly
      mac80211_hwsim: fix smatch/sparse complaints
      mac80211: remove unused function
      mac80211: make ieee80211_check_concurrent_iface netdev-independent
      mac80211: make __ieee80211_recalc_idle static
      cfg80211: don't allow WoWLAN support without CONFIG_PM
      mac80211: don't expose ieee80211_add_srates_ie()
      Merge remote-tracking branch 'wireless-next/master' into mac80211-next
      iwlwifi: add trailing newline to some messages
      iwlwifi: fix debug message level
      mac80211: remove tx_frags driver callback
      mac80211_hwsim: fix NUM_BANDS usage
      mac80211: add TX prepare API
      iwlwifi: remove unneeded NULL check
      cfg80211: fix locking regression in monitor channel tracking
      mac80211: fix debugfs default key links
      mac80211: fix crash with single-queue drivers
      mac80211_hwsim: add testmode code to stop/wake queues
      mac80211: update BSS info on AC parameters change
      mac80211: remove unused assignment
      mac80211: remove ieee80211_key_removed
      nl80211: prepare for non-netdev wireless devs
      nl80211: add NL80211_FLAG_NEED_WDEV
      nl80211: retrieve interface data by wdev
      nl80211: don't assume wdev->netdev exists
      cfg80211: use wdev in mgmt-tx/ROC APIs
      etherdevice: introduce eth_broadcast_addr
      cfg80211: use wireless_dev for interface management
      nl80211: send interface after creation
      nl80211: move scan API to wdev
      mac80211: make scan_sdata pointer usable with RCU
      mac80211: track scheduled scan virtual interface
      mac80211: redesign scan RX
      mac80211: optimize ieee80211_rx_status struct layout
      mac80211: add time synchronisation with BSS for assoc
      mac80211: restructure key selection
      cfg80211: fix locking and lockdep complaints
      mac80211: iterate the virtual monitor interface
      iwlwifi: don't use stack memory for kmem cache name
      nl80211: allow enabling WoWLAN without triggers
      Revert "mac80211: refactor virtual monitor code"
      cfg80211/mac80211: re-add get_channel operation
      cfg80211: reduce monitor interface tracking
      nl80211: add wdev ID as u64 as it should
      b43: use temporary rate_index for error checking
      b43: fix crash with OpenFWWF

John Fastabend (5):
      ixgbe: align flow control DV macros with datasheet
      net: dcb: fix small regression in __dcbnl_pg_setcfg()
      ixgbe: fix RAR entry counting for generic and fdb_add()
      ixgbe: remove extra unused queues in DCB + FCoE case
      net: netprio_cgroup: rework update socket logic

John W. Linville (31):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      wl18xx: avoid some -Wformat warnings
      Merge tag 'nfc-next-3.6-1' of git://git.kernel.org/.../sameo/nfc-3.0
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://github.com/kvalo/ath6kl
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.sipsolutions.net/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'for-john' of git://git.sipsolutions.net/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-john' of git://git.sipsolutions.net/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      iwmc3200wifi: remove driver for unavailable hardware
      i2400m: remove SDIO device support
      iwmc3200top: remove driver for unavailable hardware
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jon Mason (15):
      vxge/s2io: remove dead URLs
      lance: remove unnecessary setting of skb->dev
      enic: remove unnecessary setting of skb->dev
      netxen: remove unnecessary setting of skb->dev
      lantiq_etop: remove unnecessary setting of skb->dev
      ksz884x: remove unnecessary setting of skb->dev
      qlcnic: remove unnecessary setting of skb->dev
      qlge: remove unnecessary setting of skb->dev
      sunbmac: remove unnecessary setting of skb->dev
      sungem: remove unnecessary setting of skb->dev
      sunhme: remove unnecessary setting of skb->dev
      ll_temac: remove unnecessary setting of skb->dev
      myri10ge: update MAINTAINERS
      ixgb: use PCI_VENDOR_ID_INTEL
      ixgbe: use PCI_VENDOR_ID_INTEL

Jonas Gorski (1):
      ssb: add missing PCI ID for b/g/n single band BCM4322

Jouni Malinen (1):
      ath6kl: Use correct max-scan-SSIDs limit

Julia Lawall (1):
      can: softing: softing_main: ensure a consistent return value in error case

Julian Anastasov (6):
      ipv4: optimize fib_compute_spec_dst call in ip_options_echo
      ipv4: fix address selection in fib_compute_spec_dst
      ipv4: use seqlock for nh_exceptions
      ipv4: Fix again the time difference calculation
      ipv4: show pmtu in route list
      tcp: avoid oops in tcp_metrics and reset tcpm_stamp

Kalle Valo (2):
      Merge remote branch 'wireless-next/master' into ath6kl-next
      cfg80211: fix set_regdom() to cancel requests with same alpha2

Karsten Keil (2):
      ISDN: Add check for return value of pnp_activate_dev()
      ISDN: Add check for usb_alloc_urb() result

Kevin Groeneveld (2):
      b44: add 64 bit stats
      net: fix race condition in several drivers when reading stats

Kim Lilliestierna XX (5):
      caif: Remove unused pointer and code
      caif: added check for potential null return
      caif: Fixed potential memory leak
      caif-hsi: Removed dead code
      caif-hsi: changed test on aggregation_timeout

Kiran Reddy (1):
      ath6kl: separate ht cap for each band

Krishna Kumar (3):
      netfilter: Add fail-open support
      netfilter: nfnetlink_queue: do not allow to set unsupported flag bits
      skbuff: Use correct allocation in skb_copy_ubufs

Larry Finger (6):
      rtlwifi: rtl8192se: Fix gcc 4.7.x warning
      rtlwifi: Change debug level for deletion of an entry in CAM
      rtlwifi: Fix IRQ disabled warning
      rtlwifi: rtl8192se: Fix double inclusion of header pci.h
      rtlwifi: Remove extra argument from queue setup routine
      rtlwifi: rtl8192cu: Change buffer allocation for synchronous reads

Leo Alterman (1):
      openvswitch: Fix typo in documentation.

Li RongQing (4):
      be2net: Fix Endian
      ksz884x: fix Endian
      qlge: fix endian issue
      bridge: fix endian

Li Wei (1):
      ipv6: fix unappropriate errno returned for non-multicast address

Lin Ming (1):
      ipv4: Remove redundant assignment

Lior Levy (1):
      igb: A fix to VF TX rate limit

Luciano Coelho (69):
      wl18xx: add new module
      wlcore_sdio/wl18xx: use SDIO revision number to identify wl18xx chips
      wl18xx: add empty operations struct
      wl18xx: add partition table
      wl18xx: add register table
      wl18xx: add identify chip operation
      wl18xx: add some boot operations and hw-specific configurations
      wl18xx: add trigger command and ack event operations
      wl18xx: add hw_init operation
      wl18xx: add runtime configuration parameters
      wl18xx: add board type module argument
      wl18xx: translate and write the board type to SCR_PAD2
      wl18xx: read clock frequency and do top init accordingly
      wlcore: rename wl12xx.h to wlcore_i.h
      wlcore/wl12xx: move ref_clock and tcxo_clock elements to wl12xx
      wlcore/wl12xx: move rx_mem_pool_addr element to wl12xx
      wlcore/wl12xx: add plt_init op and move the code to wl12xx
      wl18xx: add plt_init operation
      wl18xx: change the low_band_component_type for HDK boards
      wl18xx: add number of antennas and dc2dc type as module params
      wl18xx: add module parameter to disable TCP checksum
      wl18xx: derive the MAC address from the BD_ADDR in fuse ROM
      wl18xx: add a module parameter to control 11a support
      wlcore: add module parameter to dump SDIO reads and writes
      wl18xx: copy the default configuration before checking the board_type
      wl18xx: changed default board_type to HDK
      wlcore: add space for private area when allocating fw_status
      wl18xx: change low_band_component_type value for COM8
      wlcore: reorder identify_chip and get_hw_info
      wl18xx: disable MCS_13 for wl18xx PG 1.0
      wlcore: update beacon and probe_resp templates when rates change
      wlcore: use all AP basic rates as default
      wlcore: abstract debugfs fw_stats to be handled by the lower drivers
      wlcore: add debugfs macro to help print fw statistics arrays
      wl12xx: implement fw status debugfs entries
      wl18xx: implement fw status debugfs entries
      wlcore: create private static_data area and add operation to parse it
      wl18xx: print the PHY firmware version from the private static data
      wlcore: print the interrupt status when recovery is triggered
      wl18xx: don't use MIMO when ht_mode is set to wide
      wlcore: use proper values for supported local rates
      wl18xx: add module parameter to force SISO 20MHz
      wl18xx: add power limit reference value to mac_and_phy settings
      wl18xx: export low/high band component values as module params
      wl18xx: export pwr_limit_reference_11_abg value as a module parameter
      wlcore/wl12xx/wl18xx: move lower driver debugfs to a subdir
      wlcore: increase aggregation buffer size by one page
      wl18xx: increase tx_ba_win_size to 64
      wl18xx: use new fw stats structures
      wlcore/wl12xx/wl18xx: don't use TX align quirk for wl127x
      wl18xx: add support to clear FW statistics
      wlcore: export raw binary with the FW statistics in debugfs
      wlcore/wl18xx/wl12xx: use u8 instead of bool for host_fast_wakeup_support
      wlcore: use u8 instead of enum for bcn_filt_mode
      wlcore/wl18xx: the conf structs must be packed so they can be exported
      wlcore/wl18xx: export conf struct in a debugfs file
      wl18xx: read configuration structure from a binary file
      Merge branch 'wl12xx-next' into for-linville
      mac80211: initialize sta pointer to avoid false-positive warning
      mac80211: use the correct capability info in ieee80211_set_associated()
      wlcore: add a debugfs entry to allow changing the sleep mode by hand
      wl18xx: use %zu for size_t arguments in printk calls
      Merge branch 'wl12xx-next' into for-linville
      wl18xx: deprecate PG1 support
      wlcore: fix some failure cases in wlcore_probe()
      Merge branch 'wl12xx-next' into for-linville
      wl12xx/wlcore: increase FW filename version
      wlcore: wait for command completion event when sending CMD_ROLE_STOP
      wlcore: increase command completion timeout

Luis R. Rodriguez (7):
      ath5k: replace modparam_all_channels with CONFIG_ATH5K_TEST_CHANNELS
      cfg80211: add CONFIG_CFG80211_CERTIFICATION_ONUS
      cfg80211: add cellular base station regulatory hint support
      cfg80211: rename reg_device_remove() to wiphy_regulatory_deregister()
      cfg80211: make regulatory_update() static
      cfg80211: remove regulatory_update()
      ath9k: make CONFIG_ATH9K_DFS_CERTIFIED depend on CFG80211_CERTIFICATION_ONUS

Mahesh Palivela (3):
      wireless: add VHT (802.11ac) definitions
      cfg80211: allow advertising VHT capabilities
      mac80211: include VHT capability IE in probe requests

Manish chopra (1):
      netxen_nic: restrict force firmware dump when dump is disabled.

Marc Kleine-Budde (7):
      can: c_can_pci: fix compilation on non HAVE_CLK archs
      can: cc770: fix sparse warning for cc770_interrupt
      can: dev: fix sparse warning for can_restart
      can: flexcan: make flexcan_priv.devtype_data member point to const data
      can: mpc5xxx_can: make data in mpc5xxx_can_probe const
      can: mark bittiming_const pointer in struct can_priv as const
      can: janz-ican3: cleanup of ican3_to_can_frame and can_frame_to_ican3

Marek Lindner (6):
      batman-adv: avoid characters requiring shell escapes in protocol names
      batman-adv: ignore trailing CR when comparing protocol names
      batman-adv: return added entries instead of number of possibly added entries
      batman-adv: turn tt commit code into routing protocol agnostic API
      batman-adv: only store changed gw_bandwidth values
      batman-adv: fix counter summary length

Mark A. Greer (3):
      rtnl: Add #ifdef CONFIG_RPS around num_rx_queues reference
      net: ethernet: davinci_emac: Remove unnecessary #include
      net: ethernet: davinci_emac: add pm_runtime support

Martin HundebÃ¸ll (1):
      batman-adv: Add get_ethtool_stats() support

Masanari Iida (1):
      irda: Fix typo in irda

Mat Martineau (29):
      Bluetooth: Free allocated ERTM SREJ list if init fails
      Bluetooth: Fix early return from l2cap_chan_del
      Bluetooth: Change default state of ERTM disable flag
      Bluetooth: Add a new L2CAP ERTM transmit state machine.
      Bluetooth: Refactor l2cap_streaming_send
      Bluetooth: Refactor l2cap_ertm_send
      Bluetooth: Refactor l2cap_send_sframe
      Bluetooth: Consolidate common receive code for ERTM and streaming mode
      Bluetooth: Add streaming mode receive and incoming packet classifier
      Bluetooth: Remove receive code that has been superceded
      Bluetooth: Refactor l2cap_send_ack
      Bluetooth: Use the transmit state machine for busy state changes
      Bluetooth: Update l2cap_send_i_or_rr_or_rnr to fit the spec better
      Bluetooth: Add the ERTM receive state machine
      Bluetooth: Add implementation for retransmitting all unacked frames
      Bluetooth: Send SREJ frames when packets go missing
      Bluetooth: Reassemble all available data when retransmissions succeed.
      Bluetooth: Handle SREJ requests to resend unacked frames
      Bluetooth: Handle incoming REJ frames
      Bluetooth: Use new header structures in l2cap_send_rr_or_rnr
      Bluetooth: Check rules when setting retransmit or monitor timers
      Bluetooth: Use the ERTM transmit state machine from timeout handlers
      Bluetooth: Simplify the ERTM ack timeout
      Bluetooth: Remove unneccesary inline
      Bluetooth: Set txwin values for streaming mode
      Bluetooth: Remove unused ERTM control field macros
      Bluetooth: Enable ERTM by default
      Bluetooth: Send a configuration request after security confirmation
      Bluetooth: Use tx window from config response for ack timing

Mathias Jeppsson (2):
      NFC: Fix empty HCI message list check
      NFC: Fix order of arguments to list_add_tail() when queueing HCP frames

Matt Carlson (2):
      tg3: Add common function tg3_ape_event_lock()
      tg3: Add APE scratchpad read function

Matthew Vick (2):
      igb: Streamline RSS queue and queue pairing assignment logic.
      e1000e: Program the correct register for ITR when using MSI-X.

Matthias Brugger (1):
      smsc911x.c: encapsulate enable irq calls

Matthias Schiffer (2):
      batman-adv: fix visualization output without neighbors on the primary interface
      batman-adv: fix locking in hash_add()

Meenakshi Venkataraman (2):
      iwlwifi: fix debug print in iwl_sta_calc_ht_flags
      iwlwifi: add debugging to shadow registers and fix typo

Merav Sicron (10):
      bnx2x: Add support for external LB
      bnx2x: Return only online tests for MF
      bnx2x: Add support for 4-tupple UDP RSS
      bnx2x: Allow more than 64 L2 CIDs
      bnx2x: Make the transmission queues adjacent
      bnx2x: Move the CNIC L2 CIDs to be right after the RSS CIDs
      bnx2x: Allow up to 63 RSS queues
      bnx2x: Add support for ethtool -L
      bnx2x: Change date and version to 1.72.51-0
      bnx2x: Change bnx2x_tests_str_arr to static char

Michael Chan (12):
      bnx2: Dump all FTQ_CTL registers during tx_timeout
      bnx2: Dump additional BC_STATE during firmware sync timeout.
      bnx2: Read PCI function number from internal register
      bnx2: Update version 2.2.2
      cnic: Fix occasional NULL pointer dereference during reboot.
      cnic: Remove uio mem[0].
      bnx2: Add "fall through" comments
      bnx2: Add missing netif_tx_disable() in bnx2_close()
      cnic: Fix mmap regression.
      tg3: Fix the setting of the APE_HAS_NCSI flag
      tg3: Add hwmon support for temperature
      bnx2: Try to recover from PCI block reset

Michael S. Tsirkin (6):
      skbuff: add an api to orphan frags
      skbuff: convert to skb_orphan_frags
      tun: orphan frags on xmit
      net: orphan frags on receive
      skbuff: export skb_copy_ubufs
      tun: experimental zero copy tx support

Michal Kazior (13):
      cfg80211: introduce cfg80211_stop_ap
      cfg80211: .stop_ap when interface is going down
      cfg80211: add channel tracking for AP and mesh
      cfg80211: track ibss fixed channel
      cfg80211: introduce cfg80211_get_chan_state
      cfg80211: track monitor interfaces count
      mac80211: refactor virtual monitor code
      cfg80211: refuse to .set_monitor_channel when non-monitors are present
      cfg80211: track monitor channel
      cfg80211: set initial monitor channel
      cfg80211/mac80211: remove .get_channel
      cfg80211: add channel checking for iface combinations
      cfg80211: respect iface combinations when starting operation

Michal Schmidt (1):
      sfc: initialize dynamic sysfs attributes for lockdep

Michel Machado (1):
      net-next: add dev_loopback_xmit() to avoid duplicate code

Mikulas Patocka (1):
      tun: fix a crash bug and a memory leak

Mirko Lindner (2):
      sky2: Added support for Optima EEE
      sky2: Fix for interrupt handler

Mohammed Shafi Shajakhan (18):
      ath9k: Fix modal EEPROM dump
      ath9k: Fix softlockup in AR9485
      ath9k_hw: make use of the wrapper to check for MCI init
      ath9k: Fix signedness in a MCI debug message
      ath9k: Fix clearing of BTCOEX flags
      ath9k: Fix MCI cleanup
      ath9k: Stop the BTCOEX timers before disabling BTCOEX
      ath9k_hw: Add register definitions for WoW support
      ath9k: Add definitions and structures to support WoW
      ath9k_hw: Add WoW hardware capability flags
      ath9k_hw: advertise WoW support for capable chipsets
      ath9k: advertise supported WoW flags to upper layer
      ath9k_hw: INI changes for WoW for AR9002 chipsets
      ath9k_hw: Add hardware code for WoW
      ath: Add Wake-on-Wireless debug mask
      ath9k: Add WoW related mac80211 callbacks
      ath9k: do not disable hardware while wow is enabled
      cfg80211: Fix mutex locking in reg_last_request_cell_base

Mugunthan V N (2):
      driver: net: ethernet: davinci_mdio: runtime PM support
      driver: net: ethernet: cpsw: runtime PM support

Naveen Gangadharan (1):
      ath6kl: Add wow multicast firmware capability support

Naveen Singh (2):
      ath6kl: Include match ssid list in scheduled scan
      ath6kl: use firmware version from FW IE

Neal Cardwell (4):
      tcp: fix inet6_csk_route_req() for link-local addresses
      tcp: pass fl6 to inet6_csk_route_req()
      tcp: use inet6_csk_route_req() in tcp_v6_send_synack()
      tcp: plug dst leak in tcp_v6_conn_request()

Neil Horman (2):
      sctp: refactor sctp_packet_append_chunk and clenup some memory leaks
      sctp: Implement quick failover draft from tsvwg

Nicolas Cavallari (2):
      mac80211: tx: do not drop non-robust mgmt to non-MFP stas.
      mac80211: fix tx-mgmt cookie value being left uninitialized

Nicolas Ferre (1):
      net/macb: manage carrier state with call to netif_carrier_{on|off}()

Nobuhiro Iwamatsu (2):
      net/sh-eth: Add support selecting MII function for SH7734 and R8A7740
      net/sh-eth: Check return value of sh_eth_reset when chip reset fail

Oliver Hartkopp (8):
      can: update documentation wording error frames -> error messages
      canfd: add new data structures and constants
      canfd: add support for CAN FD in PF_CAN core
      canfd: add support for CAN FD in CAN_RAW sockets
      candev: add/update helpers for CAN FD
      vcan: add CAN FD support
      canfd: update documentation according to CAN FD extensions
      can: fix sparse warning in af_can.c

Oskar Schirmer (1):
      net/wireless: remove macro defined twice with same value

Pablo Neira Ayuso (23):
      netfilter: nf_conntrack: remove now unused sysctl for nf_conntrack_l[3|4]proto
      netfilter: nf_ct_tcp, udp: fix compilation with sysctl disabled
      netfilter: nf_ct_helper: allocate 16 bytes for the helper and policy names
      netfilter: nf_ct_ext: support variable length extensions
      netfilter: nf_ct_helper: implement variable length helper private data
      netfilter: add glue code to integrate nfnetlink_queue and ctnetlink
      netfilter: nfnetlink_queue: add NAT TCP sequence adjustment if packet mangled
      netfilter: ctnetlink: add CTA_HELP_INFO attribute
      netfilter: add user-space connection tracking helper infrastructure
      netfilter: ctnetlink: fix NULL dereference while trying to change helper
      netfilter: nf_ct_helper: disable automatic helper re-assignment of different type
      netfilter: fix compilation of the nfnl_cthelper if NF_CONNTRACK is unset
      netfilter: nfnetlink_queue: fix compilation with NF_CONNTRACK disabled
      netfilter: fix missing symbols if CONFIG_NETFILTER_NETLINK_QUEUE_CT unset
      netfilter: nfq_ct_hook needs __rcu and __read_mostly
      netfilter: nfnetlink_queue: fix compilation with CONFIG_NF_NAT=m and CONFIG_NF_CT_NETLINK=y
      netfilter: nfnetlink_queue: fix sparse warning due to missing include
      netfilter: ctnetlink: fix compilation with NF_CONNTRACK_EVENTS=n
      netfilter: ctnetlink: add new messages to obtain statistics
      netlink: add netlink_kernel_cfg parameter to netlink_kernel_create
      netlink: add nlk->netlink_bind hook for module auto-loading
      netfilter: nf_conntrack: generalize nf_ct_l4proto_net
      netfilter: nf_ct_tcp: missing per-net support for cttimeout

Padmanabh Ratnakar (12):
      be2net: Fix driver load for VFs for Lancer
      be2net: Fix error while toggling autoneg of pause parameters
      be2net : Fix die temperature stat for Lancer
      be2net: Fix initialization sequence for Lancer
      be2net: Activate new FW after FW download for Lancer
      be2net: Fix cleanup path when EQ creation fails
      be2net: Fix port name in message during driver load
      be2net: Enable RSS UDP hashing for Lancer and Skyhawk
      be2net: Add description about various RSS hash types
      be2net: update driver version
      be2net: Fix VF driver load for Lancer
      be2net: Ignore physical link async event for Lancer

Pascal Bouchareine (1):
      ixgbevf: fix VF untagging when 802.1 prio is set

Paul Bolle (3):
      iwlwifi: fix typo 'IWL_WATCHHDOG_DISABLED'
      iwlegacy: print how long queue was actually stuck
      gigaset: silence GCC warning for unused 'format_ie'

Paul Gortmaker (3):
      tipc: factor stats struct out of the larger link struct
      tipc: limit error messages relating to memory leak to one line
      tipc: simplify link_print by divorcing it from using tipc_printf

Peter Korsgaard (2):
      bcm87xx: disable autonegotiation by default
      bcm87xx: fix reg-init comment typo

Peter Wu (1):
      jme: netpoll support

Pontus Fuchs (2):
      mac80211: Clear wowlan flag when drv_suspend returns failure
      mac80211: Disallow changing chan type on monitor when CHAN_MODE_FIXED

Pravin B Shelar (1):
      openvswitch: Check currect return value from skb_gso_segment()

RafaÅ‚ MiÅ‚ecki (10):
      bcma: define some additional cores IDs
      b43: N-PHY: fix RSSI calibration
      bcma: use custom printing functions
      bcma: fix CC driver compilation on MIPS
      bcma: support alternative (BCM4706) ChipCommon core id
      bcma: fix typo - reading number of slave wrappers
      bcma: add trivial GBIT MAC COMMON driver
      bcma: add new cores at the end of list
      bcma: cc: update defines
      bcma: add place for flash memory support

Raffaele Recalcati (1):
      net/ethernet: ks8851_mll mac address configuration support added

Raja Mani (2):
      ath6kl: Remove unneeded memset in roam related config func
      ath6kl: Fix typo in htc mbox debug print msg

Rajesh Borundia (2):
      qlcnic: Fix estimation of recv MSS in case of LRO
      qlcnic: Fix protcol type in case of inband vlan.

Rajkumar Manoharan (44):
      ath9k_hw: update ar9462 initval table to fix rx
      ath9k: cleanup MCI indentation
      ath9k_hw: fix IQ calibration chain index
      ath9k_hw: program BT to control SPDT
      ath9k_hw: configure ar9462 switching regulator
      ath9k_hw: fix BT RF performance
      ath9k: BT coex performance tuning for AR9462
      ath: do not update cycle counters with sleep mode
      ath9k_hw: fix power state for MCI
      ath9k: improve BT FTP/PAN performance
      ath9k: choose legacy rate as last rate of MRR series
      ath9k: restore power state on set channel failure
      ath9k_hw: Fix AR9462 power consumption on idle associated
      ath9k_hw: check GPM HW write pointer before chip reset
      ath9k_hw: fix incorrect LNA register settings
      ath9k_hw: program OBS register only when MCI is disabled
      ath9k_hw: process MCI interrupts only when btcoex is enabled
      ath9k: simplify btcoex profile management
      ath9k: keep btcoex period in milliseconds
      ath9k: defer btcoex scheme update
      ath9k: fix btcoex duty cycle
      ath9k_hw: cleanup MCI gpm offset state
      ath9k_hw: add utility function to set BT version
      ath9k_hw: remove MCI_STATE_SEND_WLAN_CHANNELS
      ath9k_hw: remove MCI_STATE_NEED_FLUSH_BT_INFO
      ath9k_hw: remove p_data argument from ar9003_mci_state
      ath9k_hw: remove MCI_STATE_BT
      ath9k_hw: remove MCI_STATE_CONT_* state
      ath9k_hw: remove MCI_STATE_SET_BT_SLEEP
      mac80211: cleanup offchannel_ps_enable argument
      ath9k_hw: fix BT mute at hw init
      ath9k: fix mci_is_enabled utility
      ath9k_hw: update ar9462 dac_async_fifo initval
      ath9k_hw: fix LNA control on WLAN sleep
      ath9k: do not sampling on ani timer when chip is in sleep
      ath9k_hw: rename mrcCCKOff to fix smatch warning
      ath9k_hw: fix smatch warning in ar9003_hw_spur_mitigate_mrc_cck
      ath9k_hw: start noisefloor calibration after MCI reset
      ath9k_hw: do not load noise floor readings when it is running
      ath9k: fix fullsleep power consumption when BTCOEX is enabled
      ath9k: fix power consumption on network sleep when BTCOEX is enabled
      ath9k_hw: fix AR9462 2g5g switch on full reset
      ath9k_hw: remove debugging masks from AR_MCI_INTERRUPT_RX_MSG_DEFAULT
      ath9k: Fix race in reset-work usage

Raju Subramanian (1):
      openvswitch: Replace Nicira Networks.

Randy Dunlap (1):
      wimax: fix printk format warnings

Richard A. Griffiths (1):
      iwlwifi: disallow log_event access if interface down

Richard Cochran (4):
      bnx2x: advertise transmit time stamping
      e1000: advertise transmit time stamping
      e1000e: advertise transmit time stamping
      forcedeth: advertise transmit time stamping

Rick Jones (1):
      net-next: minor cleanups for bonding documentation

Rob Herring (4):
      net: calxedaxgmac: fix net timeout recovery
      net: calxedaxgmac: fix hang on rx refill
      net: calxedaxgmac: set outstanding AXI bus transactions to 8
      net: calxedaxgmac: enable rx cut-thru mode

RongQing.Li (2):
      ipv6: remove unnecessary codes in tcp_ipv6.c
      dccp: remove unnecessary codes in ipv6.c

Rostislav Lisovy (1):
      net: em_canid: Ematch rule to match CAN frames according to their identifiers

Samuel Ortiz (47):
      NFC: Take a reference on the LLCP local pointer when creating a socket
      NFC: Socket linked list
      NFC: Move LLCP receiver window value to socket structure
      NFC: Move LLCP MIU extension value to socket structure
      NFC: LLCP's MIUX is 10 bytes long, not 7
      NFC: Export LLCP general bytes getter
      NFC: Add target mode protocols to the polling loop startup routine
      NFC: Implement pn533 target mode polling loop
      NFC: Add target mode activation netlink event
      NFC: Set the NFC device RF mode appropriately
      NFC: Introduce target mode tx ops
      NFC: Introduce target mode rx data callback
      NFC: Implement the pn533 target mode data fetching routine
      NFC: Implement the pn533 target mode Tx op
      NFC: Don't hold a NULL connecting LLCP socket lock
      NFC: Call the DEP link down ops even when in target mode
      NFC: Reset poll mod list when stopping pn533 poll
      NFC: Unregister device if pn533 initial configuration fails
      NFC: Configure pn533 RF timings
      NFC: Add passive initiator data for pn533
      NFC: Add type A and type F parameters for pn533 target mode
      NFC: Implement pn533 polling loop
      NFC: Requeue lost LLCP frames
      NFC: Send a receiver ready frame only to reply to an I frame
      NFC: Switch to Initiator mode when getting NFC_ATTR_PROTOCOLS
      NFC: Destroy LLCP timout workqueue when releasing the link
      NFC: Set the proper baud rate when trying to activate pn533 targets
      NFC: Convert pn533 from semaphore to mutex
      NFC: Monitor pn533 target mode
      NFC: Add modules alias for NFC sockets
      NFC: Add netlink module alias for NFC
      NFC: Update LLCP socket target index when getting a connection
      NFC: Fix LLCP getname socket op
      NFC: Build LLCP general bytes upon request
      NFC: Close listening LLCP sockets when the device is gone
      NFC: Release LLCP SAP when the owner is released
      NFC: Forbid LLCP service name reusing
      NFC: Forbid SSAP binding to a not well known LLCP service
      NFC: LLCP late binding
      NFC: Handle LLCP Disconnected Mode frames
      NFC: Remove warning from nfc_llcp_local_put
      NFC: Do not return EBUSY when stopping a poll that's already stopped
      NFC: Dereference LLCP bind socket address after checking for it to be NULL
      NFC: Add initial Sony RC-S360 support to pn533
      NFC: Use communicate thru only for PaSoRi when trying to read Felica tags
      NFC: Add ISO 14443 type B protocol
      NFC: Check for llcp_sock and its device from llcp_sock_getname

Santosh Nayak (2):
      netxen: Error return off by one in 'netxen_nic_set_pauseparam()'.
      netxen: Error return off by one for XG port.

Sasha Levin (1):
      Bluetooth: Really fix registering hci with duplicate name

Sathya Perla (7):
      be2net: don't call vid_config() when there's no vlan config
      be2net: cleanup be_vid_config()
      be2net: do not modify PCI MaxReadReq size
      be2net: fix reporting number of actual rx queues
      be2net: remove unnecessary usage of unlikely()
      be2net: do not use SCRATCHPAD register
      be2net: update driver version

Saurabh (3):
      net/ipv4: VTI support rx-path hook in xfrm4_mode_tunnel.
      net/ipv4: VTI support new module for ip_vti.
      net/ipv4/ip_vti.c: Fix __rcu warnings detected by sparse.

Seth Forshee (9):
      brcm80211: smac: don't set up tx power limits during initialization
      brcm80211: smac: always set channel specified by mac80211
      brcm80211: smac: remove unused code for 40MHz channels
      brcm80211: smac: clean up channel.c
      brcm80211: smac: inform mac80211 of the X2 regulatory domain
      brcm80211: smac: enable/disable radio on regulatory updates
      brcm80211: smac: use mac80211 channel data for tx power limits
      brcm80211: smac: don't validate channels against internal regulatory data
      brcm80211: smac: use current regulatory domain when checking whether OFDM is allowed

Shawn Guo (6):
      net: fec: reset phy after pinctrl setup
      net: fec: enable regulator for fec phy
      net: fec: use managed function devm_gpio_request_one
      net: fec: phy-reset-gpios is optional
      net: fec: add phy-reset-duration for device tree probe
      net: flexcan: clock-frequency is optional for device tree probe

Shuah Khan (2):
      niu: Fix to check for dma mapping errors.
      niu: Change niu_rbr_fill() to use unlikely() to check niu_rbr_add_page() return value

Sjur BrÃ¦ndeland (7):
      caif-hsi: Use netdev_X instead of dev_X for printing
      caif-hsi: Remove uncecessary assignments
      Documentation/networking/caif: Update documentation
      caif-hsi: Add rtnl support
      caif-hsi: Replace platform device with ops structure.
      caif-hsi: Remove use of module parameters
      caif-hsi: Fix merge issues.

Somnath Kotur (3):
      be2net: Explicitly clear the reserved field in the Tx Descriptor
      be2net: Regression bug wherein VFs creation broken for multiple cards.
      be2net: Fix to trim skb for padded vlan packets to workaround an ASIC Bug

Stanislav Yakovlev (1):
      net/wireless: ipw2200: introduce ipw_read_eeprom function

Stanislaw Gruszka (6):
      rt2x00: claim RSN IBSS support
      iwl4965: claim RSN IBSS support
      mac80211: configure 11b/g channel access rules for legacy APs
      rt2x00pci: small 3290 changes cleanup
      rt2800lib: merge same defines
      rt2x00: remove unused argument

Stefan Hajnoczi (2):
      vhost: Separate vhost-net features from vhost features
      vhost: make vhost work queue visible

Steffen Klassert (3):
      ipv6: Initialize the neighbour pointer of rt6_info on allocation
      ipv6: Initialize the struct rt6_info behind the dst_enty field
      xfrm: Initialize the struct xfrm_dst behind the dst_enty field

Steffen Trumtrar (1):
      can: flexcan: add 2nd clock to support imx53 and newer

Stephen Hemminger (1):
      ixgbe: simplify padding and length checks

Sujith Manoharan (35):
      ath9k: Prune ath9k_init_device
      ath9k: Handle ASPM properly
      ath9k: Setup MCI interrupts properly
      ath9k_hw: Fix AR_RTC_KEEP_AWAKE usage
      ath9k_hw: Fix MCI usage
      ath9k_hw: Cleanup power mode API
      ath9k: Add MCI interrupt to debugfs statistics
      ath9k_hw: Fix variable usage
      ath9k: Remove SC_OP_OFFCHANNEL
      ath9k: Use separate operational flags for BTCOEX
      ath9k: Group link monitoring logic
      ath9k: Fix work handling
      ath9k: Move LNA code to antenna.c
      ath9k: Use atomic operations
      ath9k: Handle fatal interrupts properly
      ath9k: Fix powersave locking
      ath9k: Resync beacons properly
      ath9k_hw: Initvals update for AR9462
      ath9k_hw: Update initvals for AR9462
      ath9k: Fix lockdep splat
      ath9k_htc: Change default listen interval to 1
      ath9k_htc: Use atomic operations for op_flags
      ath9k_htc: Fix IDLE power save
      ath9k: Fix compilation breakage
      ath9k: Fix beacon setup
      ath9k_hw: Cleanup ath9k_hw_set_tsfadjust
      ath9k: Cleanup interface handling
      ath9k: Simplify ASSOC handling
      ath9k: Cleanup beacon logic
      ath9k: Remove is_bslot_active
      ath9k: Cleanup beacon queue configuration
      ath9k: Set the TSF adjust value properly
      ath9k: Cleanup the beacon tasklet
      ath9k: Fix ANI management
      ath9k: Reconfigure VIF state properly

Sven Eckelmann (75):
      batman-adv: update internal version number
      batman-adv: Initialize lockdep class keys for hashes
      batman-adv: Return error codes instead of -1 on failures
      batman-adv: Prefix bat_algo non-static functions with batadv_
      batman-adv: Prefix bat_debugfs non-static functions with batadv_
      batman-adv: Prefix bat_sysfs non-static functions with batadv_
      batman-adv: Prefix bitarray non-static functions with batadv_
      batman-adv: Prefix bridge_loop_avoidance non-static functions with batadv_
      batman-adv: Prefix gateway-client non-static functions with batadv_
      batman-adv: Prefix gateway-common non-static functions with batadv_
      batman-adv: Prefix hard-interface non-static functions with batadv_
      batman-adv: Prefix hash non-static functions with batadv_
      batman-adv: Prefix icmp-socket non-static functions with batadv_
      batman-adv: Prefix originator non-static functions with batadv_
      batman-adv: Prefix ring_buffer non-static functions with batadv_
      batman-adv: Prefix routing non-static functions with batadv_
      batman-adv: Prefix send non-static functions with batadv_
      batman-adv: Prefix soft-interface non-static functions with batadv_
      batman-adv: Prefix translation-table non-static functions with batadv_
      batman-adv: Prefix unicast non-static functions with batadv_
      batman-adv: Prefix vis non-static functions with batadv_
      batman-adv: Prefix main non-static functions with batadv_
      batman-adv: Reformat multiline comments to consistent style
      batman-adv: Prefix bat_debugfs local static functions with batadv_
      batman-adv: Prefix bitarray static inline functions with batadv_
      batman-adv: Prefix hard-interface static inline functions with batadv_
      batman-adv: Prefix hash static inline functions with batadv_
      batman-adv: Prefix originator static inline functions with batadv_
      batman-adv: Prefix unicast static inline functions with batadv_
      batman-adv: Prefix main static inline functions with batadv_
      batman-adv: Prefix bat_iv_ogm local static functions with batadv_
      batman-adv: Prefix bat_sysfs local static functions with batadv_
      batman-adv: Prefix bridge_loop_avoidance local static functions with batadv_
      batman-adv: Prefix gateway_client local static functions with batadv_
      batman-adv: Prefix gateway_common local static functions with batadv_
      batman-adv: Prefix hard-interface local static functions with batadv_
      batman-adv: Prefix hash local static functions with batadv_
      batman-adv: Prefix icmp_socket local static functions with batadv_
      batman-adv: Prefix originator local static functions with batadv_
      batman-adv: Prefix routing local static functions with batadv_
      batman-adv: Prefix send local static functions with batadv_
      batman-adv: Prefix soft-interface local static functions with batadv_
      batman-adv: Prefix translation-table local static functions with batadv_
      ath9k: raise aggregation limit to 64k for HT IBSS
      batman-adv: Prefix unicast local static functions with batadv_
      batman-adv: Prefix vis local static functions with batadv_
      batman-adv: Prefix main local static functions with batadv_
      batman-adv: Prefix remaining function like macros with batadv_
      batman-adv: Directly print to seq_file in vis
      batman-adv: Prefix local defines with BATADV_
      batman-adv: Prefix debugfs defines with BATADV_
      batman-adv: Prefix sysfs defines with BATADV_
      batman-adv: Prefix bridge_loop_avoidance defines with BATADV_
      batman-adv: Prefix gateway defines with BATADV_
      batman-adv: Prefix icmp_socket defines with BATADV_
      batman-adv: Prefix packet defines with BATADV_
      batman-adv: Prefix types defines with BATADV_
      batman-adv: Prefix unicast defines with BATADV_
      batman-adv: Prefix vis defines with BATADV_
      batman-adv: Prefix main defines with BATADV_
      batman-adv: Prefix gateway enum with BATADV_
      batman-adv: Prefix hard-interface enum with BATADV_
      batman-adv: Prefix types enum with BATADV_
      batman-adv: Prefix packet enum with BATADV_
      batman-adv: Prefix main enum with BATADV_
      batman-adv: Prefix local debugfs structs with batadv_
      batman-adv: Prefix hash struct and typedef with batadv_
      batman-adv: Prefix local sysfs struct with batadv_
      batman-adv: Prefix packet structs with batadv_
      batman-adv: Prefix types structs with batadv_
      batman-adv: Transform BATADV_LOG_BUFF(idx) into function
      batman-adv: Remove bat_ prefix from bat_{debugfs, sysfs}.{c, h}
      batman-adv: Remove space before semicolon
      batman-adv: Fix alignment after opened parentheses
      batman-adv: Don't leak information through uninitialized packet fields

Sylvain Roger Rieunier (1):
      minstrel_ht: enable frame aggregation for fixed rate

Szymon Janc (2):
      Bluetooth: Rename HCI_QUIRK_NO_RESET to HCI_QUIRK_RESET_ON_CLOSE
      Bluetooth: Remove unused HCI timeouts definitions

Thadeu Lima de Souza Cascardo (1):
      mlx4_en: map entire pages to increase throughput

Thomas Graf (24):
      ipv4: Add interface option to enable routing of 127.0.0.0/8
      dcbnl: Prepare framework to shorten handling functions
      dcbnl: Shorten all command handling functions
      dcbnl: Remove now unused dcbnl_reply()
      dcbnl: Use dcbnl_newmsg() where possible
      dcbnl: Return consistent error codes
      dcbnl: Move dcb app lookup code into dcb_app_lookup()
      dcbnl: Move dcb app allocation into dcb_app_add()
      dcbnl: Use type safe nlmsg_data()
      dcbnl: Silence harmless gcc warning about uninitialized reply_nlh
      dcbnl: Use BUG_ON() instead of BUG()
      unix_diag: Do not use RTA_PUT() macros
      sock_diag: Do not use RTA_PUT() macros
      inet_diag: Do not use RTA_PUT() macros
      ipmr: Do not use RTA_PUT() macros
      ip6mr: Do not use RTA_PUT() macros
      decnet: Do not use RTA_PUT() macros
      netlink: Get rid of obsolete rtnetlink macros
      net: Use NLMSG_DEFAULT_SIZE in combination with nlmsg_new()
      can: gw: Don't bump nlmsg_len manually
      can: gw: Use nla_policy to validate netlink attributes
      can: gw: Properly fill the netlink header when responding to RTM_GETROUTE
      can: gw: Remove pointless casts
      bridge: Fix enforcement of multicast hash_max limit

Thomas Huehn (5):
      mac80211: reduce IEEE80211_TX_MAX_RATES
      ath9k: fixing register bit shift values of control packets to support TPC
      mwl8k: fix possible race condition in info->control.sta use
      brcmsmac: restructure info->control.sta handling as it is goning to be removed soon.
      mac80211_hwsim: fix race condition with sta/vif pointers

Thomas Pedersen (6):
      ath6kl: enable enhanced bmiss detection
      ath6kl: issue wmi disconnect after notifying cfg80211
      mac80211: allow channel change while mesh is down
      ath6kl: fix fw capability parsing
      nl80211: specify RSSI threshold in scheduled scan
      cfg80211: support TX error rate CQM

Timur Tabi (1):
      net/fsl_pq_mdio: use spin_event_timeout() to poll the indicator register

Tomasz Bursztyka (1):
      netfilter: nfnetlink: check callbacks before using those in nfnetlink_rcv_msg

Tony Cheneau (3):
      6lowpan: Fix null pointer dereference in UDP uncompression function
      6lowpan: Change byte order when storing/accessing u16 tag
      6lowpan: Change byte order when storing/accessing to len field

Tushar Dave (2):
      e1000: Combining Bitwise OR in one expression.
      e1000e: Cleanup code logic in e1000_check_for_serdes_link_82571()

Valentin Ilie (1):
      drivers: connector: fixed coding style issues

Vasanthakumar Thiagarajan (3):
      ath6kl: Fix missing gpio pin 9 configuration
      ath6kl: Fix race in aggregation reorder logic
      ath6kl: Fix unstable downlink throughput

Victor Goldenshtein (7):
      wl12xx: fix fm_coex parameters configuration
      wl18xx: fix fm_coex parameters configuration
      wlcore: don't enable BET for high basic rates
      wlcore: wait for roc complete only for the first roc command
      wlcore: set channels 12-14 as pactive for sched scan
      mac80211: add command to get current rssi
      wlcore: enable sched scan while connected

Vijay Subramanian (3):
      tcp: Fix bug in tcp socket early demux
      net: Remove 'unlikely' qualifier in skb_steal_sock()
      tcp: Return bool instead of int where appropriate

Ville Nuorvala (1):
      ipv6_tunnel: Allow receiving packets on the fallback tunnel if they pass sanity checks

Vinicius Costa Gomes (1):
      Bluetooth: Fix checking the wrong flag when accepting a socket

Vivek Natarajan (1):
      ath9k: Ensure a fair beacon distribution in IBSS mode

Vladimir Kondratiev (6):
      cfg80211: add 802.11ad (60gHz band) support
      wireless: regulatory for 60g
      wireless: 60g protocol constants
      {nl,cfg}80211: support high bitrates
      cfg80211: bitrate calculation for 60g
      cfg80211: fix oops due to unassigned set_monitor_enabled callback

WANG Cong (1):
      genetlink: define lockdep_genl_is_held() when CONFIG_LOCKDEP

Weiping Pan (1):
      rds: set correct msg_namelen

Wey-Yi Guy (1):
      iwlwifi: set correct 32 bit boost register value

Will Hawkins (3):
      mac80211: Track auth frame registrations on IBSS ifaces
      mac80211: send auth in IBSS only if userspace isn't handling it
      mac80211: Allow userspace to register for auth frames in IBSS

Woody Hung (1):
      rt2x00 : RT3290 chip support v4

Xose Vazquez Perez (1):
      wireless: rtl818x: rtl8180 add devices ids

Yair Shapira (7):
      wlcore/wl12xx: add support for HP and SKW FEM radio manufacturers
      wlcore: add print logs of radio_status in case of BIP calibration
      wl18xx: add support for ht_mode in conf.h
      wlcore: add plt_mode including new PLT_FEM_DETECT
      wl18xx: disable calibrator based fem detect
      wlcore/wl12xx: calibrator fem detect implementation
      wlcore: make usage of nla_put clearer

Yevgeny Petrilin (1):
      net/mlx4_en: Re-design multicast attachments flow

Yoni Divinsky (9):
      wlcore: use psd_type indexing according to spec
      wl12xx: set the irq polarity before loading the fw
      wlcore: fix the CONF_TX_AC_ANY_TID to be 0xff
      wlcore: do not send stop fwlog cmd if fw is hanged
      wlcore: add role_id to all the sched_scan commands
      mac80211: save wmm_acm per sdata
      wlcore: do not report noise level in get survey op
      wlcore: add probe request templates for sched and one-shot scans
      wlcore: change the wait for event mechanism

Yoshihiro Shimoda (4):
      net: sh_eth: remove unnecessary function
      net: sh_eth: remove unnecessary members/definitions
      net: sh_eth: fix up the buffer pointers
      net: sh_eth: add support for set_ringparam/get_ringparam

Yuchung Cheng (7):
      net-tcp: Fast Open base
      net-tcp: Fast Open client - cookie cache
      net-tcp: Fast Open client - sending SYN-data
      net-tcp: Fast Open client - receiving SYN-ACK
      net-tcp: Fast Open client - sendmsg(MSG_FASTOPEN)
      net-tcp: Fast Open client - detecting SYN-data drops
      net-tcp: Fast Open client - cookie-less mode

Yuval Mintz (22):
      Added kernel support in EEE Ethtool commands
      bnx2x: Added EEE support
      bnx2x: Added EEE Ethtool support.
      bnx2x: correct LPI pass-through configuration
      bnx2x: sfp+ Tx fault detection added
      bnx2x: link cleanup
      bnx2x: treat 0 speed as link down (copper)
      bnx2x: revised link register access
      bnx2x: 1G sfp+ module handling
      bnx2x: link module eeprom
      net-next: Add netif_get_num_default_rss_queues
      mlx4: set maximal number of default RSS queues
      vxge: set maximal number of default RSS queues
      qlge: set maximal number of default RSS queues
      cxgb3: set maximal number of default RSS queues
      cxgb4: set maximal number of default RSS queues
      myri10ge: set maximal number of default RSS queues
      tg3: set maximal number of default RSS queues
      bnx2: set maximal number of default RSS queues
      bnx2x: set maximal number of default RSS queues
      be2net: set maximal number of default RSS queues
      bnx2x: Add new 57840 device IDs

Zefir Kurtisi (1):
      ath9k: fix/add bits for spectral scanning

Zero.Lin (1):
      rt2x00:Add RT5392 chipset support

alex.bluesman.smirnov@gmail.com (19):
      6lowpan: read data from skb safely
      6lowpan: fix hop limit compression
      6lowpan: remove excessive argument in pr_debug
      mac802154: add wpan device-class support
      mac802154: set and get PAN id
      mac802154: short address setter
      mac802154: page and channel setter
      mac802154: mlme start request
      drivers/ieee802154: add support for the at86rf230/231 transceivers
      mac802154: add monitor listener to TX datapath
      6lowpan: revert 'reuse eth_mac_addr()'
      drivers/ieee802154/at231rf230: remove unused return status
      6lowpan: revert: add missing spin_lock_init()
      drivers/ieee802154/at86rf230: rework irq handler
      mac802154: add get short address method
      6lowpan: get extra headroom in allocated frame
      mac802154: sparse warnings: make symbols static
      6lowpan: fix tag variable size
      6lowpan: rework fragment-deleting routine

brenohl@br.ibm.com (1):
      cxgb3: Set vlan_feature on net_device

danborkmann@iogearbox.net (1):
      af_packet: use sizeof instead of constant in spkt_device

parav.pandit@emulex.com (1):
      net: added support for 40GbE link.

stephen hemminger (2):
      ipx: move peII functions
      bridge: update documentation references

stigge@antcom.de (1):
      net: lpc_eth: Driver cleanup

tom.leiming@gmail.com (6):
      usbnet: remove usb_get/put_dev in .probe and .disconnect
      usbnet:pegasus: remove usb_get/put_dev in .probe and .disconnect
      usbnet:cdc-phonet: remove usb_get/put_dev in .probe and .disconnect
      usbnet: remove flag of EVENT_DEV_WAKING
      usbnet: remove declaration for intr_complete
      usbnet: don't initialize transfer buffer before submit status URB

villacis@palosanto.com (1):
      rt2x00: Add support for RT5360 based PCI devices.

 Documentation/DocBook/80211.tmpl                                       |    1 -
 Documentation/connector/cn_test.c                                      |   13 +-
 Documentation/devicetree/bindings/net/broadcom-bcm87xx.txt             |   29 +
 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt              |    3 +
 Documentation/devicetree/bindings/net/davinci_emac.txt                 |   41 +
 Documentation/devicetree/bindings/net/fsl-fec.txt                      |    6 +-
 Documentation/devicetree/bindings/net/phy.txt                          |   12 +-
 Documentation/devicetree/bindings/net/stmmac.txt                       |    3 +-
 Documentation/feature-removal-schedule.txt                             |   44 +-
 Documentation/networking/batman-adv.txt                                |    5 +
 Documentation/networking/bonding.txt                                   |    6 +-
 Documentation/networking/bridge.txt                                    |   13 +-
 Documentation/networking/caif/Linux-CAIF.txt                           |   91 +-
 Documentation/networking/can.txt                                       |  186 ++-
 Documentation/networking/ip-sysctl.txt                                 |   62 +-
 Documentation/networking/openvswitch.txt                               |    2 +-
 Documentation/networking/s2io.txt                                      |   14 +-
 Documentation/networking/stmmac.txt                                    |   36 +-
 Documentation/networking/vxge.txt                                      |    7 -
 Documentation/nfc/nfc-hci.txt                                          |   33 +
 MAINTAINERS                                                            |   30 +-
 arch/blackfin/mach-bf537/boards/stamp.c                                |    2 +-
 arch/c6x/kernel/soc.c                                                  |    2 +-
 arch/m68k/include/asm/{mcfne.h => mcf8390.h}                           |  137 +-
 arch/mips/ar7/platform.c                                               |    4 +-
 arch/mips/powertv/powertv_setup.c                                      |    6 +-
 arch/sparc/net/bpf_jit_comp.c                                          |    4 +
 arch/um/drivers/net_kern.c                                             |    2 +-
 arch/x86/net/bpf_jit_comp.c                                            |    4 +
 crypto/crypto_user.c                                                   |    7 +-
 drivers/bcma/Kconfig                                                   |   19 +
 drivers/bcma/Makefile                                                  |    3 +
 drivers/bcma/bcma_private.h                                            |   31 +
 drivers/bcma/core.c                                                    |   10 +-
 drivers/bcma/driver_chipcommon.c                                       |    5 +-
 drivers/bcma/driver_chipcommon_nflash.c                                |   19 +
 drivers/bcma/driver_chipcommon_pmu.c                                   |  369 ++++--
 drivers/bcma/driver_chipcommon_sflash.c                                |   19 +
 drivers/bcma/driver_gmac_cmn.c                                         |   14 +
 drivers/bcma/driver_mips.c                                             |   33 +-
 drivers/bcma/driver_pci_host.c                                         |   18 +-
 drivers/bcma/host_pci.c                                                |    5 +-
 drivers/bcma/main.c                                                    |   44 +-
 drivers/bcma/scan.c                                                    |   48 +-
 drivers/bcma/scan.h                                                    |    2 +-
 drivers/bcma/sprom.c                                                   |   26 +-
 drivers/bluetooth/Kconfig                                              |   12 +
 drivers/bluetooth/Makefile                                             |    1 +
 drivers/bluetooth/bluecard_cs.c                                        |   16 +-
 drivers/bluetooth/bpa10x.c                                             |    2 +-
 drivers/bluetooth/bt3c_cs.c                                            |    6 +-
 drivers/bluetooth/btmrvl_main.c                                        |    8 +-
 drivers/bluetooth/btmrvl_sdio.c                                        |    6 +-
 drivers/bluetooth/btuart_cs.c                                          |    6 +-
 drivers/bluetooth/btusb.c                                              |   14 +-
 drivers/bluetooth/dtl1_cs.c                                            |   22 +-
 drivers/bluetooth/hci_bcsp.c                                           |    2 +-
 drivers/bluetooth/hci_h4.c                                             |    2 +-
 drivers/bluetooth/hci_h5.c                                             |  747 +++++++++++
 drivers/bluetooth/hci_ldisc.c                                          |   68 +-
 drivers/bluetooth/hci_ll.c                                             |    6 +-
 drivers/bluetooth/hci_uart.h                                           |   10 +
 drivers/connector/cn_proc.c                                            |   36 +-
 drivers/connector/cn_queue.c                                           |   12 +-
 drivers/connector/connector.c                                          |   30 +-
 drivers/ieee802154/Kconfig                                             |    6 +
 drivers/ieee802154/Makefile                                            |    1 +
 drivers/ieee802154/at86rf230.c                                         |  968 ++++++++++++++
 drivers/infiniband/core/netlink.c                                      |   17 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c                                  |    5 +-
 drivers/infiniband/hw/mlx4/main.c                                      |   65 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h                                   |    1 +
 drivers/infiniband/hw/mlx4/qp.c                                        |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c                                |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c                              |    4 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c                         |   35 +-
 drivers/isdn/gigaset/capi.c                                            |    2 +
 drivers/isdn/hardware/mISDN/hfcsusb.c                                  |   18 +-
 drivers/isdn/hisax/hfc_usb.c                                           |   18 +-
 drivers/isdn/hisax/isurf.c                                             |    5 +
 drivers/misc/Kconfig                                                   |    1 -
 drivers/misc/Makefile                                                  |    1 -
 drivers/misc/iwmc3200top/Kconfig                                       |   20 -
 drivers/misc/iwmc3200top/Makefile                                      |   29 -
 drivers/misc/iwmc3200top/debugfs.c                                     |  137 --
 drivers/misc/iwmc3200top/debugfs.h                                     |   58 -
 drivers/misc/iwmc3200top/fw-download.c                                 |  358 ------
 drivers/misc/iwmc3200top/fw-msg.h                                      |  113 --
 drivers/misc/iwmc3200top/iwmc3200top.h                                 |  205 ---
 drivers/misc/iwmc3200top/log.c                                         |  348 -----
 drivers/misc/iwmc3200top/log.h                                         |  171 ---
 drivers/misc/iwmc3200top/main.c                                        |  662 ----------
 drivers/net/appletalk/cops.c                                           |    2 +-
 drivers/net/bonding/bond_3ad.c                                         |   13 +-
 drivers/net/bonding/bond_3ad.h                                         |    4 +-
 drivers/net/bonding/bond_alb.c                                         |   26 +-
 drivers/net/bonding/bond_main.c                                        |   84 +-
 drivers/net/bonding/bond_sysfs.c                                       |    2 +-
 drivers/net/bonding/bonding.h                                          |    4 +-
 drivers/net/caif/caif_hsi.c                                            |  548 ++++----
 drivers/net/can/at91_can.c                                             |    2 +-
 drivers/net/can/bfin_can.c                                             |    4 +-
 drivers/net/can/c_can/Kconfig                                          |   20 +-
 drivers/net/can/c_can/Makefile                                         |    1 +
 drivers/net/can/c_can/c_can.c                                          |  122 +-
 drivers/net/can/c_can/c_can.h                                          |  163 ++-
 drivers/net/can/c_can/c_can_pci.c                                      |  221 ++++
 drivers/net/can/c_can/c_can_platform.c                                 |   76 +-
 drivers/net/can/cc770/cc770.c                                          |    4 +-
 drivers/net/can/dev.c                                                  |   37 +-
 drivers/net/can/flexcan.c                                              |  154 ++-
 drivers/net/can/janz-ican3.c                                           |  241 +++-
 drivers/net/can/mcp251x.c                                              |    5 +-
 drivers/net/can/mscan/mpc5xxx_can.c                                    |    2 +-
 drivers/net/can/mscan/mscan.c                                          |    2 +-
 drivers/net/can/pch_can.c                                              |    2 +-
 drivers/net/can/sja1000/sja1000.c                                      |    2 +-
 drivers/net/can/softing/softing_main.c                                 |    2 +-
 drivers/net/can/ti_hecc.c                                              |    2 +-
 drivers/net/can/usb/ems_usb.c                                          |    2 +-
 drivers/net/can/usb/esd_usb2.c                                         |    2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h                           |    2 +-
 drivers/net/can/vcan.c                                                 |   27 +-
 drivers/net/cris/eth_v10.c                                             |    2 +-
 drivers/net/dummy.c                                                    |   19 +-
 drivers/net/ethernet/3com/3c501.c                                      |    2 +-
 drivers/net/ethernet/8390/Kconfig                                      |   14 +
 drivers/net/ethernet/8390/Makefile                                     |    1 +
 drivers/net/ethernet/8390/apne.c                                       |    2 +-
 drivers/net/ethernet/8390/mcf8390.c                                    |  480 +++++++
 drivers/net/ethernet/aeroflex/greth.c                                  |    8 +-
 drivers/net/ethernet/amd/declance.c                                    |    4 +-
 drivers/net/ethernet/amd/lance.c                                       |    5 +-
 drivers/net/ethernet/apple/macmace.c                                   |    2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c                          |    8 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h                          |    5 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c                        |   93 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c                     |    2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c                        |  105 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_param.c                       |    2 +-
 drivers/net/ethernet/atheros/atlx/atl1.c                               |   45 +-
 drivers/net/ethernet/atheros/atlx/atl2.c                               |   58 +-
 drivers/net/ethernet/atheros/atlx/atlx.c                               |   10 +-
 drivers/net/ethernet/broadcom/b44.c                                    |   96 +-
 drivers/net/ethernet/broadcom/b44.h                                    |    3 +-
 drivers/net/ethernet/broadcom/bnx2.c                                   |  100 +-
 drivers/net/ethernet/broadcom/bnx2.h                                   |   45 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                            |  197 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                        |  252 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                        |   63 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c                        |   30 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c                    |  585 ++++++++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h                    |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h                        |  184 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c                       | 1232 +++++++++++-------
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h                       |   53 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c                       |  310 +++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_mfw_req.h                    |  168 +++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h                        |  128 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c                         |    8 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h                         |   42 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c                      |   68 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h                      |    2 +
 drivers/net/ethernet/broadcom/cnic.c                                   |   53 +-
 drivers/net/ethernet/broadcom/cnic_if.h                                |   13 +-
 drivers/net/ethernet/broadcom/tg3.c                                    |  284 ++++-
 drivers/net/ethernet/broadcom/tg3.h                                    |   47 +-
 drivers/net/ethernet/brocade/bna/bfa_cee.c                             |   97 +-
 drivers/net/ethernet/brocade/bna/bfa_cs.h                              |   34 +-
 drivers/net/ethernet/brocade/bna/bfa_defs.h                            |   63 +-
 drivers/net/ethernet/brocade/bna/bfa_defs_cna.h                        |   15 +-
 drivers/net/ethernet/brocade/bna/bfa_defs_mfg_comm.h                   |   35 +-
 drivers/net/ethernet/brocade/bna/bfa_defs_status.h                     |    3 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c                             |  393 ++----
 drivers/net/ethernet/brocade/bna/bfa_ioc.h                             |   43 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc_ct.c                          |   48 +-
 drivers/net/ethernet/brocade/bna/bfa_msgq.c                            |    4 +-
 drivers/net/ethernet/brocade/bna/bfi.h                                 |   81 +-
 drivers/net/ethernet/brocade/bna/bfi_cna.h                             |   42 +-
 drivers/net/ethernet/brocade/bna/bfi_enet.h                            |  107 +-
 drivers/net/ethernet/brocade/bna/bfi_reg.h                             |    4 +-
 drivers/net/ethernet/brocade/bna/bna.h                                 |   51 +-
 drivers/net/ethernet/brocade/bna/bna_enet.c                            |   15 +-
 drivers/net/ethernet/brocade/bna/bna_hw_defs.h                         |   33 +-
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c                           |   17 +-
 drivers/net/ethernet/brocade/bna/bna_types.h                           |   66 +-
 drivers/net/ethernet/brocade/bna/bnad.c                                |   12 +-
 drivers/net/ethernet/brocade/bna/bnad.h                                |    4 +-
 drivers/net/ethernet/brocade/bna/cna_fwimg.c                           |    4 +-
 drivers/net/ethernet/cadence/macb.c                                    |   13 +-
 drivers/net/ethernet/calxeda/xgmac.c                                   |   35 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c                        |    6 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c                     |   30 +-
 drivers/net/ethernet/chelsio/cxgb3/l2t.c                               |    6 +-
 drivers/net/ethernet/chelsio/cxgb3/l2t.h                               |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c                               |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c                             |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                        |    4 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                               |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                             |    2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c                    |    2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c                             |    5 +-
 drivers/net/ethernet/cisco/enic/enic_main.c                            |    2 -
 drivers/net/ethernet/dec/tulip/de4x5.c                                 |    2 +-
 drivers/net/ethernet/emulex/benet/be.h                                 |   31 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                            |  171 ++-
 drivers/net/ethernet/emulex/benet/be_cmds.h                            |   57 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c                         |    2 +-
 drivers/net/ethernet/emulex/benet/be_hw.h                              |    9 +-
 drivers/net/ethernet/emulex/benet/be_main.c                            |  518 ++++----
 drivers/net/ethernet/ethoc.c                                           |    6 +-
 drivers/net/ethernet/faraday/ftgmac100.c                               |    9 +-
 drivers/net/ethernet/faraday/ftmac100.c                                |   11 +-
 drivers/net/ethernet/freescale/fec.c                                   |   32 +-
 drivers/net/ethernet/freescale/fsl_pq_mdio.c                           |   29 +-
 drivers/net/ethernet/freescale/gianfar.c                               |  491 +++----
 drivers/net/ethernet/freescale/gianfar_ethtool.c                       |  420 +++---
 drivers/net/ethernet/freescale/ucc_geth.c                              |    2 +-
 drivers/net/ethernet/hp/hp100.c                                        |    6 +-
 drivers/net/ethernet/i825xx/lp486e.c                                   |    8 +-
 drivers/net/ethernet/i825xx/sun3_82586.c                               |    4 +-
 drivers/net/ethernet/ibm/ehea/ehea_qmr.c                               |    4 +-
 drivers/net/ethernet/intel/e100.c                                      |   40 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c                       |    1 +
 drivers/net/ethernet/intel/e1000/e1000_hw.c                            |    8 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c                          |   21 +-
 drivers/net/ethernet/intel/e1000e/82571.c                              |   14 +-
 drivers/net/ethernet/intel/e1000e/e1000.h                              |    1 +
 drivers/net/ethernet/intel/e1000e/ethtool.c                            |    6 +-
 drivers/net/ethernet/intel/e1000e/netdev.c                             |   45 +-
 drivers/net/ethernet/intel/e1000e/param.c                              |   43 +-
 drivers/net/ethernet/intel/igb/e1000_regs.h                            |    1 +
 drivers/net/ethernet/intel/igb/igb.h                                   |   25 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c                           |   52 +-
 drivers/net/ethernet/intel/igb/igb_main.c                              |  164 ++-
 drivers/net/ethernet/intel/igb/igb_ptp.c                               |   12 +-
 drivers/net/ethernet/intel/igbvf/netdev.c                              |    1 +
 drivers/net/ethernet/intel/igbvf/vf.c                                  |    5 +-
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c                              |    5 +-
 drivers/net/ethernet/intel/ixgb/ixgb_ids.h                             |    5 -
 drivers/net/ethernet/intel/ixgb/ixgb_main.c                            |   16 +-
 drivers/net/ethernet/intel/ixgbe/Makefile                              |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                               |  100 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c                         |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c                        |   48 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h                        |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb.c                           |   78 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb.h                           |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c                        |   26 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c                       |  159 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c                          |  395 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h                          |   15 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c                           |  838 +++++++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                          |  769 +++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                           |   23 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c                           |  187 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                         |  223 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h                         |    1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_sysfs.c                         |   10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h                          |   46 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c                          |    4 +
 drivers/net/ethernet/intel/ixgbevf/defines.h                           |   28 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c                           |  172 +--
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h                           |  114 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c                      | 1371 ++++++++------------
 drivers/net/ethernet/jme.c                                             |   14 +
 drivers/net/ethernet/lantiq_etop.c                                     |    3 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c                             |    4 +-
 drivers/net/ethernet/marvell/pxa168_eth.c                              |    4 +-
 drivers/net/ethernet/marvell/sky2.c                                    |   18 +-
 drivers/net/ethernet/marvell/sky2.h                                    |    5 +
 drivers/net/ethernet/mellanox/mlx4/cmd.c                               |   19 +
 drivers/net/ethernet/mellanox/mlx4/en_cq.c                             |    9 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                        |  382 ++++++
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                         |  630 +++++++--
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                             |  270 ++--
 drivers/net/ethernet/mellanox/mlx4/eq.c                                |   12 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c                                |   91 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h                                |    3 +
 drivers/net/ethernet/mellanox/mlx4/main.c                              |   59 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c                               |  523 +++++++-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                              |   29 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                           |   47 +-
 drivers/net/ethernet/mellanox/mlx4/port.c                              |  108 +-
 drivers/net/ethernet/mellanox/mlx4/profile.c                           |   12 +-
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c                  |  285 ++++-
 drivers/net/ethernet/micrel/ks8851.c                                   |    2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c                               |   35 +-
 drivers/net/ethernet/micrel/ksz884x.c                                  |   10 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c                       |    2 +-
 drivers/net/ethernet/neterion/s2io.c                                   |   24 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c                       |    8 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.h                       |    2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c                         |   23 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h                         |    3 +-
 drivers/net/ethernet/neterion/vxge/vxge-traffic.c                      |    5 +-
 drivers/net/ethernet/nvidia/forcedeth.c                                |   10 +-
 drivers/net/ethernet/nxp/lpc_eth.c                                     |   18 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_api.c                    |   12 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c                |   10 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c                   |   42 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c                  |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h                        |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c                |   21 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c                     |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c                   |    6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h                            |   15 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c                        |   37 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hdr.h                        |    1 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c                       |    5 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c                       |   10 +
 drivers/net/ethernet/qlogic/qlge/qlge.h                                |   13 +-
 drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c                        |  315 +++--
 drivers/net/ethernet/qlogic/qlge/qlge_main.c                           |  100 +-
 drivers/net/ethernet/rdc/r6040.c                                       |   16 +-
 drivers/net/ethernet/realtek/r8169.c                                   | 1002 ++++++++++-----
 drivers/net/ethernet/renesas/sh_eth.c                                  |  371 ++++--
 drivers/net/ethernet/renesas/sh_eth.h                                  |   77 +-
 drivers/net/ethernet/sfc/efx.c                                         |   10 +-
 drivers/net/ethernet/sfc/enum.h                                        |    8 +-
 drivers/net/ethernet/sfc/ethtool.c                                     |    2 +-
 drivers/net/ethernet/sfc/falcon.c                                      |   35 +-
 drivers/net/ethernet/sfc/falcon_xmac.c                                 |   12 +-
 drivers/net/ethernet/sfc/filter.c                                      |    2 +-
 drivers/net/ethernet/sfc/mcdi.c                                        |   11 +-
 drivers/net/ethernet/sfc/mcdi_mon.c                                    |    1 +
 drivers/net/ethernet/sfc/mcdi_pcol.h                                   |    3 +-
 drivers/net/ethernet/sfc/net_driver.h                                  |   11 +-
 drivers/net/ethernet/sfc/nic.c                                         |   11 +-
 drivers/net/ethernet/sfc/nic.h                                         |   18 +
 drivers/net/ethernet/sfc/rx.c                                          |   23 +-
 drivers/net/ethernet/sfc/selftest.c                                    |   64 +-
 drivers/net/ethernet/sfc/siena.c                                       |   37 +-
 drivers/net/ethernet/sfc/tx.c                                          |   93 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                                    |    4 +-
 drivers/net/ethernet/smsc/smc911x.c                                    |    6 +-
 drivers/net/ethernet/smsc/smc91x.c                                     |    6 +-
 drivers/net/ethernet/smsc/smsc911x.c                                   |   19 +-
 drivers/net/ethernet/smsc/smsc9420.c                                   |    3 +-
 drivers/net/ethernet/stmicro/stmmac/common.h                           |   31 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h                        |   20 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c                   |  101 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c                    |    4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h                        |    1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                           |    8 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c                   |   57 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                      |  196 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c                       |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c                  |   12 +-
 drivers/net/ethernet/sun/niu.c                                         |    6 +-
 drivers/net/ethernet/sun/sunbmac.c                                     |    2 -
 drivers/net/ethernet/sun/sungem.c                                      |    1 -
 drivers/net/ethernet/sun/sunhme.c                                      |    3 -
 drivers/net/ethernet/sun/sunqe.c                                       |    2 +-
 drivers/net/ethernet/tehuti/tehuti.c                                   |  177 +--
 drivers/net/ethernet/ti/cpsw.c                                         |   25 +-
 drivers/net/ethernet/ti/davinci_emac.c                                 |  208 ++-
 drivers/net/ethernet/ti/davinci_mdio.c                                 |   25 +-
 drivers/net/ethernet/tile/tilegx.c                                     |   61 +-
 drivers/net/ethernet/toshiba/spider_net.c                              |    6 +-
 drivers/net/ethernet/via/via-velocity.c                                |    2 +-
 drivers/net/ethernet/wiznet/w5100.c                                    |    2 +-
 drivers/net/ethernet/wiznet/w5300.c                                    |    2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c                            |    3 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c                      |    2 +-
 drivers/net/fddi/defxx.c                                               |    4 +-
 drivers/net/fddi/skfp/pmf.c                                            |    8 +-
 drivers/net/hamradio/mkiss.c                                           |    8 +-
 drivers/net/hyperv/hyperv_net.h                                        |    1 +
 drivers/net/hyperv/netvsc.c                                            |    2 +-
 drivers/net/hyperv/netvsc_drv.c                                        |   30 +-
 drivers/net/hyperv/rndis_filter.c                                      |   79 ++
 drivers/net/irda/ali-ircc.c                                            |    6 +-
 drivers/net/irda/au1k_ir.c                                             |    2 +-
 drivers/net/loopback.c                                                 |    4 +-
 drivers/net/macvtap.c                                                  |    8 +-
 drivers/net/phy/Kconfig                                                |    5 +
 drivers/net/phy/Makefile                                               |    1 +
 drivers/net/phy/amd.c                                                  |    8 +-
 drivers/net/phy/bcm63xx.c                                              |   31 +-
 drivers/net/phy/bcm87xx.c                                              |  231 ++++
 drivers/net/phy/broadcom.c                                             |  119 +-
 drivers/net/phy/cicada.c                                               |   35 +-
 drivers/net/phy/davicom.c                                              |   41 +-
 drivers/net/phy/dp83640.c                                              |   23 +-
 drivers/net/phy/fixed.c                                                |    4 +-
 drivers/net/phy/icplus.c                                               |   31 +-
 drivers/net/phy/lxt.c                                                  |   47 +-
 drivers/net/phy/marvell.c                                              |   22 +-
 drivers/net/phy/mdio_bus.c                                             |   14 +-
 drivers/net/phy/micrel.c                                               |   62 +-
 drivers/net/phy/national.c                                             |    8 +-
 drivers/net/phy/phy.c                                                  |  316 ++++-
 drivers/net/phy/phy_device.c                                           |  139 +-
 drivers/net/phy/realtek.c                                              |    6 +-
 drivers/net/phy/smsc.c                                                 |   64 +-
 drivers/net/phy/spi_ks8995.c                                           |    4 +-
 drivers/net/phy/ste10Xp.c                                              |   21 +-
 drivers/net/phy/vitesse.c                                              |   52 +-
 drivers/net/slip/slip.c                                                |    4 +-
 drivers/net/team/Kconfig                                               |   13 +-
 drivers/net/team/Makefile                                              |    1 +
 drivers/net/team/team.c                                                |  777 ++++++++----
 drivers/net/team/team_mode_activebackup.c                              |   17 +-
 drivers/net/team/team_mode_broadcast.c                                 |   87 ++
 drivers/net/team/team_mode_loadbalance.c                               |  546 +++++++-
 drivers/net/team/team_mode_roundrobin.c                                |   13 +-
 drivers/net/tun.c                                                      |  153 ++-
 drivers/net/usb/Kconfig                                                |    1 +
 drivers/net/usb/Makefile                                               |    1 +
 drivers/net/usb/asix.h                                                 |  218 ++++
 drivers/net/usb/asix_common.c                                          |  631 +++++++++
 drivers/net/usb/{asix.c => asix_devices.c}                             |  666 +---------
 drivers/net/usb/ax88172a.c                                             |  414 ++++++
 drivers/net/usb/cdc-phonet.c                                           |    4 +-
 drivers/net/usb/pegasus.c                                              |    4 -
 drivers/net/usb/qmi_wwan.c                                             |  352 +++---
 drivers/net/usb/smsc75xx.c                                             |    2 +-
 drivers/net/usb/smsc95xx.c                                             |   34 +-
 drivers/net/usb/usbnet.c                                               |   77 +-
 drivers/net/virtio_net.c                                               |   10 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                                      |    2 +-
 drivers/net/wan/x25_asy.c                                              |    2 +-
 drivers/net/wimax/i2400m/Kconfig                                       |   22 -
 drivers/net/wimax/i2400m/Makefile                                      |    8 -
 drivers/net/wimax/i2400m/control.c                                     |    4 +-
 drivers/net/wimax/i2400m/driver.c                                      |    5 +-
 drivers/net/wimax/i2400m/fw.c                                          |    5 +-
 drivers/net/wimax/i2400m/i2400m-sdio.h                                 |  157 ---
 drivers/net/wimax/i2400m/i2400m.h                                      |   13 +-
 drivers/net/wimax/i2400m/sdio-debug-levels.h                           |   22 -
 drivers/net/wimax/i2400m/sdio-fw.c                                     |  210 ---
 drivers/net/wimax/i2400m/sdio-rx.c                                     |  301 -----
 drivers/net/wimax/i2400m/sdio-tx.c                                     |  177 ---
 drivers/net/wimax/i2400m/sdio.c                                        |  602 ---------
 drivers/net/wimax/i2400m/usb-fw.c                                      |    2 +-
 drivers/net/wireless/Kconfig                                           |    1 -
 drivers/net/wireless/Makefile                                          |    2 -
 drivers/net/wireless/adm8211.c                                         |    5 +-
 drivers/net/wireless/airo.c                                            |    4 +-
 drivers/net/wireless/ath/ath.h                                         |    2 +
 drivers/net/wireless/ath/ath5k/Kconfig                                 |    8 +
 drivers/net/wireless/ath/ath5k/base.c                                  |   17 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c                          |    2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c                             |  288 +++--
 drivers/net/wireless/ath/ath6kl/cfg80211.h                             |    8 +-
 drivers/net/wireless/ath/ath6kl/core.c                                 |    8 +-
 drivers/net/wireless/ath/ath6kl/core.h                                 |   46 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c                             |    2 +-
 drivers/net/wireless/ath/ath6kl/init.c                                 |   28 +-
 drivers/net/wireless/ath/ath6kl/main.c                                 |   28 +-
 drivers/net/wireless/ath/ath6kl/target.h                               |    1 +
 drivers/net/wireless/ath/ath6kl/txrx.c                                 |   48 +-
 drivers/net/wireless/ath/ath6kl/wmi.c                                  |  158 ++-
 drivers/net/wireless/ath/ath6kl/wmi.h                                  |   58 +-
 drivers/net/wireless/ath/ath9k/Kconfig                                 |    2 +-
 drivers/net/wireless/ath/ath9k/Makefile                                |    5 +-
 drivers/net/wireless/ath/ath9k/ahb.c                                   |    6 +-
 drivers/net/wireless/ath/ath9k/ani.c                                   |  489 +------
 drivers/net/wireless/ath/ath9k/ani.h                                   |   32 +-
 drivers/net/wireless/ath/ath9k/antenna.c                               |  776 ++++++++++++
 drivers/net/wireless/ath/ath9k/ar5008_phy.c                            |  176 +--
 drivers/net/wireless/ath/ath9k/ar9002_hw.c                             |  164 +--
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h                       |   14 +
 drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h                   |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_calib.c                          |   33 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                         |  214 ++--
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h                         |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c                             |  535 +++-----
 drivers/net/wireless/ath/ath9k/ar9003_mac.c                            |    7 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c                            |  734 +++++------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h                            |   40 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c                          |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                            |  124 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h                            |   43 +-
 drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h                   |   53 +-
 drivers/net/wireless/ath/ath9k/ar9330_1p2_initvals.h                   |  882 +------------
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h                       |  755 +++++------
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h                   |   12 +-
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h                       | 1528 +++++++++-------------
 drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h                   | 1284 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h                   |  772 +----------
 drivers/net/wireless/ath/ath9k/ath9k.h                                 |   93 +-
 drivers/net/wireless/ath/ath9k/beacon.c                                |  528 +++-----
 drivers/net/wireless/ath/ath9k/btcoex.c                                |   10 +-
 drivers/net/wireless/ath/ath9k/btcoex.h                                |    4 +
 drivers/net/wireless/ath/ath9k/calib.h                                 |    6 +-
 drivers/net/wireless/ath/ath9k/debug.c                                 |   22 +-
 drivers/net/wireless/ath/ath9k/debug.h                                 |   25 +-
 drivers/net/wireless/ath/ath9k/eeprom.h                                |    4 -
 drivers/net/wireless/ath/ath9k/eeprom_4k.c                             |    5 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c                           |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c                            |    7 +-
 drivers/net/wireless/ath/ath9k/gpio.c                                  |   69 +-
 drivers/net/wireless/ath/ath9k/htc.h                                   |    4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c                        |   10 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c                          |  122 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                          |    4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c                          |   82 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                          |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                                    |  285 +++--
 drivers/net/wireless/ath/ath9k/hw.h                                    |  107 +-
 drivers/net/wireless/ath/ath9k/init.c                                  |   39 +-
 drivers/net/wireless/ath/ath9k/link.c                                  |  555 ++++++++
 drivers/net/wireless/ath/ath9k/mac.c                                   |    2 +-
 drivers/net/wireless/ath/ath9k/mac.h                                   |    1 +
 drivers/net/wireless/ath/ath9k/main.c                                  | 1406 +++++++++++----------
 drivers/net/wireless/ath/ath9k/mci.c                                   |  246 ++--
 drivers/net/wireless/ath/ath9k/mci.h                                   |   11 +-
 drivers/net/wireless/ath/ath9k/pci.c                                   |   10 +-
 drivers/net/wireless/ath/ath9k/rc.c                                    |   17 +-
 drivers/net/wireless/ath/ath9k/recv.c                                  |  773 +-----------
 drivers/net/wireless/ath/ath9k/reg.h                                   |  171 ++-
 drivers/net/wireless/ath/ath9k/wow.c                                   |  532 ++++++++
 drivers/net/wireless/ath/ath9k/xmit.c                                  |  165 ++-
 drivers/net/wireless/ath/carl9170/carl9170.h                           |   11 +
 drivers/net/wireless/ath/carl9170/cmd.c                                |    2 +-
 drivers/net/wireless/ath/carl9170/fw.c                                 |    3 +
 drivers/net/wireless/ath/carl9170/fwdesc.h                             |    3 +
 drivers/net/wireless/ath/carl9170/main.c                               |    6 +
 drivers/net/wireless/ath/carl9170/rx.c                                 |   53 +-
 drivers/net/wireless/ath/carl9170/tx.c                                 |   69 +-
 drivers/net/wireless/ath/carl9170/version.h                            |    8 +-
 drivers/net/wireless/atmel.c                                           |    4 +-
 drivers/net/wireless/b43/b43.h                                         |    7 -
 drivers/net/wireless/b43/main.c                                        |   32 +-
 drivers/net/wireless/b43/phy_n.c                                       |   17 +-
 drivers/net/wireless/b43/xmit.c                                        |    9 +-
 drivers/net/wireless/b43legacy/dma.c                                   |    2 +-
 drivers/net/wireless/b43legacy/main.c                                  |    2 +-
 drivers/net/wireless/b43legacy/xmit.c                                  |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                       |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c                 |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h                          |    3 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h                      |    8 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c                   |   29 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c                      |  126 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h                      |   59 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c                    |    9 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c                     |  669 +++++++---
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c                    |   17 +
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c                  |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c                      |  131 +-
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h                      |   18 +-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c                        |   16 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c                      | 1223 ++++--------------
 drivers/net/wireless/brcm80211/brcmsmac/channel.h                      |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c                          |   17 +-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c                  |   21 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c                         |  127 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c                  |   22 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c                    |  142 ++-
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c                          |  172 +--
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h                          |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/pub.h                          |    2 +-
 drivers/net/wireless/brcm80211/brcmutil/utils.c                        |    2 +
 drivers/net/wireless/brcm80211/include/brcm_hw_ids.h                   |    1 +
 drivers/net/wireless/brcm80211/include/soc.h                           |   62 -
 drivers/net/wireless/hostap/hostap_proc.c                              |    3 +-
 drivers/net/wireless/ipw2x00/ipw2200.c                                 |   27 +-
 drivers/net/wireless/iwlegacy/3945-rs.c                                |    2 +-
 drivers/net/wireless/iwlegacy/4965-mac.c                               |   13 +-
 drivers/net/wireless/iwlegacy/common.c                                 |    9 +-
 drivers/net/wireless/iwlwifi/Kconfig                                   |    5 +
 drivers/net/wireless/iwlwifi/Makefile                                  |   32 +-
 drivers/net/wireless/iwlwifi/dvm/Makefile                              |   13 +
 drivers/net/wireless/iwlwifi/{iwl-agn.h => dvm/agn.h}                  |  113 +-
 drivers/net/wireless/iwlwifi/{iwl-agn-calib.c => dvm/calib.c}          |   24 +-
 drivers/net/wireless/iwlwifi/{iwl-agn-calib.h => dvm/calib.h}          |    4 +-
 drivers/net/wireless/iwlwifi/{iwl-commands.h => dvm/commands.h}        |   48 +-
 drivers/net/wireless/iwlwifi/{iwl-debugfs.c => dvm/debugfs.c}          |   37 +-
 drivers/net/wireless/iwlwifi/{iwl-dev.h => dvm/dev.h}                  |  192 +--
 drivers/net/wireless/iwlwifi/{iwl-agn-devices.c => dvm/devices.c}      |  191 +--
 drivers/net/wireless/iwlwifi/{iwl-led.c => dvm/led.c}                  |    5 +-
 drivers/net/wireless/iwlwifi/{iwl-led.h => dvm/led.h}                  |    0
 drivers/net/wireless/iwlwifi/{iwl-agn-lib.c => dvm/lib.c}              |   24 +-
 drivers/net/wireless/iwlwifi/{iwl-mac80211.c => dvm/mac80211.c}        |  201 +--
 drivers/net/wireless/iwlwifi/{iwl-agn.c => dvm/main.c}                 |  504 +++-----
 drivers/net/wireless/iwlwifi/{iwl-power.c => dvm/power.c}              |   11 +-
 drivers/net/wireless/iwlwifi/{iwl-power.h => dvm/power.h}              |    2 +-
 drivers/net/wireless/iwlwifi/{iwl-agn-rs.c => dvm/rs.c}                |   50 +-
 drivers/net/wireless/iwlwifi/{iwl-agn-rs.h => dvm/rs.h}                |    3 +-
 drivers/net/wireless/iwlwifi/{iwl-agn-rx.c => dvm/rx.c}                |   78 +-
 drivers/net/wireless/iwlwifi/{iwl-agn-rxon.c => dvm/rxon.c}            |   54 +-
 drivers/net/wireless/iwlwifi/{iwl-scan.c => dvm/scan.c}                |  195 +--
 drivers/net/wireless/iwlwifi/{iwl-agn-sta.c => dvm/sta.c}              |   60 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c                            |  471 +++++++
 drivers/net/wireless/iwlwifi/{iwl-agn-tt.c => dvm/tt.c}                |   13 +-
 drivers/net/wireless/iwlwifi/{iwl-agn-tt.h => dvm/tt.h}                |    2 +-
 drivers/net/wireless/iwlwifi/{iwl-agn-tx.c => dvm/tx.c}                |   62 +-
 drivers/net/wireless/iwlwifi/{iwl-ucode.c => dvm/ucode.c}              |   71 +-
 drivers/net/wireless/iwlwifi/iwl-config.h                              |   30 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h                                 |   28 +-
 drivers/net/wireless/iwlwifi/iwl-debug.c                               |   11 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h                               |   17 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c                            |    5 +
 drivers/net/wireless/iwlwifi/iwl-devtrace.h                            |    5 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c                                 |  152 ++-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c                        |  903 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h                        |  138 ++
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c                         |  463 +++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h                         |   70 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c                              | 1148 -----------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h                              |  269 ----
 drivers/net/wireless/iwlwifi/iwl-fh.h                                  |    2 +
 drivers/net/wireless/iwlwifi/iwl-io.c                                  |   53 +-
 drivers/net/wireless/iwlwifi/iwl-io.h                                  |   16 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c                          |   13 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                             |   24 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h                                |    2 +-
 drivers/net/wireless/iwlwifi/iwl-test.c                                |  856 +++++++++++++
 drivers/net/wireless/iwlwifi/iwl-test.h                                |  161 +++
 drivers/net/wireless/iwlwifi/iwl-testmode.c                            | 1114 ----------------
 drivers/net/wireless/iwlwifi/iwl-trans.h                               |   82 +-
 drivers/net/wireless/iwlwifi/{iwl-1000.c => pcie/1000.c}               |   19 +-
 drivers/net/wireless/iwlwifi/{iwl-2000.c => pcie/2000.c}               |   24 +-
 drivers/net/wireless/iwlwifi/{iwl-5000.c => pcie/5000.c}               |   20 +-
 drivers/net/wireless/iwlwifi/{iwl-6000.c => pcie/6000.c}               |   25 +-
 drivers/net/wireless/iwlwifi/{iwl-cfg.h => pcie/cfg.h}                 |    0
 drivers/net/wireless/iwlwifi/{iwl-pci.c => pcie/drv.c}                 |    5 +-
 drivers/net/wireless/iwlwifi/{iwl-trans-pcie-int.h => pcie/internal.h} |   25 +-
 drivers/net/wireless/iwlwifi/{iwl-trans-pcie-rx.c => pcie/rx.c}        |  106 +-
 drivers/net/wireless/iwlwifi/{iwl-trans-pcie.c => pcie/trans.c}        |  385 +++---
 drivers/net/wireless/iwlwifi/{iwl-trans-pcie-tx.c => pcie/tx.c}        |  200 ++-
 drivers/net/wireless/iwmc3200wifi/Kconfig                              |   39 -
 drivers/net/wireless/iwmc3200wifi/Makefile                             |   10 -
 drivers/net/wireless/iwmc3200wifi/bus.h                                |   57 -
 drivers/net/wireless/iwmc3200wifi/cfg80211.c                           |  882 -------------
 drivers/net/wireless/iwmc3200wifi/cfg80211.h                           |   31 -
 drivers/net/wireless/iwmc3200wifi/commands.c                           | 1002 ---------------
 drivers/net/wireless/iwmc3200wifi/commands.h                           |  509 --------
 drivers/net/wireless/iwmc3200wifi/debug.h                              |  123 --
 drivers/net/wireless/iwmc3200wifi/debugfs.c                            |  488 -------
 drivers/net/wireless/iwmc3200wifi/eeprom.c                             |  234 ----
 drivers/net/wireless/iwmc3200wifi/eeprom.h                             |  127 --
 drivers/net/wireless/iwmc3200wifi/fw.c                                 |  416 ------
 drivers/net/wireless/iwmc3200wifi/fw.h                                 |  100 --
 drivers/net/wireless/iwmc3200wifi/hal.c                                |  470 -------
 drivers/net/wireless/iwmc3200wifi/hal.h                                |  237 ----
 drivers/net/wireless/iwmc3200wifi/iwm.h                                |  367 ------
 drivers/net/wireless/iwmc3200wifi/lmac.h                               |  484 -------
 drivers/net/wireless/iwmc3200wifi/main.c                               |  847 -------------
 drivers/net/wireless/iwmc3200wifi/netdev.c                             |  191 ---
 drivers/net/wireless/iwmc3200wifi/rx.c                                 | 1701 -------------------------
 drivers/net/wireless/iwmc3200wifi/rx.h                                 |   60 -
 drivers/net/wireless/iwmc3200wifi/sdio.c                               |  509 --------
 drivers/net/wireless/iwmc3200wifi/sdio.h                               |   64 -
 drivers/net/wireless/iwmc3200wifi/trace.c                              |    3 -
 drivers/net/wireless/iwmc3200wifi/trace.h                              |  283 -----
 drivers/net/wireless/iwmc3200wifi/tx.c                                 |  529 --------
 drivers/net/wireless/iwmc3200wifi/umac.h                               |  789 ------------
 drivers/net/wireless/libertas/cfg.c                                    |   46 +-
 drivers/net/wireless/libertas/cmd.c                                    |   25 +-
 drivers/net/wireless/libertas/cmd.h                                    |    4 +-
 drivers/net/wireless/libertas/debugfs.c                                |    4 +-
 drivers/net/wireless/libertas/dev.h                                    |    2 +
 drivers/net/wireless/libertas/firmware.c                               |    2 -
 drivers/net/wireless/libertas/host.h                                   |    1 -
 drivers/net/wireless/libertas/if_usb.c                                 |    3 +-
 drivers/net/wireless/libertas/main.c                                   |    6 +
 drivers/net/wireless/libertas/mesh.c                                   |    7 +-
 drivers/net/wireless/libertas_tf/if_usb.c                              |    2 +-
 drivers/net/wireless/mac80211_hwsim.c                                  |   29 +-
 drivers/net/wireless/mwifiex/11n.c                                     |   14 +-
 drivers/net/wireless/mwifiex/11n.h                                     |    3 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c                           |   18 +-
 drivers/net/wireless/mwifiex/cfg80211.c                                |  406 ++++--
 drivers/net/wireless/mwifiex/cfp.c                                     |   31 -
 drivers/net/wireless/mwifiex/cmdevt.c                                  |    7 +-
 drivers/net/wireless/mwifiex/decl.h                                    |    9 -
 drivers/net/wireless/mwifiex/fw.h                                      |   54 +-
 drivers/net/wireless/mwifiex/ie.c                                      |  190 +--
 drivers/net/wireless/mwifiex/init.c                                    |   67 +-
 drivers/net/wireless/mwifiex/ioctl.h                                   |   21 +-
 drivers/net/wireless/mwifiex/join.c                                    |   20 +-
 drivers/net/wireless/mwifiex/main.c                                    |   11 +-
 drivers/net/wireless/mwifiex/main.h                                    |   41 +-
 drivers/net/wireless/mwifiex/scan.c                                    |  108 +-
 drivers/net/wireless/mwifiex/sta_cmd.c                                 |  114 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c                             |  151 ++-
 drivers/net/wireless/mwifiex/sta_event.c                               |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c                               |  290 +----
 drivers/net/wireless/mwifiex/uap_cmd.c                                 |  303 +++--
 drivers/net/wireless/mwl8k.c                                           |    5 +-
 drivers/net/wireless/orinoco/cfg.c                                     |   11 +-
 drivers/net/wireless/p54/eeprom.c                                      |    4 +-
 drivers/net/wireless/p54/fwio.c                                        |    2 +-
 drivers/net/wireless/p54/txrx.c                                        |    6 +-
 drivers/net/wireless/prism54/islpci_eth.c                              |    2 +-
 drivers/net/wireless/ray_cs.c                                          |    2 +-
 drivers/net/wireless/rndis_wlan.c                                      |    5 +-
 drivers/net/wireless/rt2x00/Kconfig                                    |    8 +
 drivers/net/wireless/rt2x00/rt2400pci.c                                |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c                                |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c                                |    2 +-
 drivers/net/wireless/rt2x00/rt2800.h                                   |  181 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c                                |  388 +++++-
 drivers/net/wireless/rt2x00/rt2800pci.c                                |   83 +-
 drivers/net/wireless/rt2x00/rt2800pci.h                                |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c                                |    4 +-
 drivers/net/wireless/rt2x00/rt2x00.h                                   |    1 +
 drivers/net/wireless/rt2x00/rt2x00config.c                             |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c                                |    2 +
 drivers/net/wireless/rt2x00/rt2x00mac.c                                |   14 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c                                |    9 +
 drivers/net/wireless/rt2x00/rt2x00queue.c                              |   10 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h                              |    5 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c                                |   20 +-
 drivers/net/wireless/rt2x00/rt61pci.c                                  |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c                                  |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c                             |    4 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c                             |    2 +-
 drivers/net/wireless/rtlwifi/base.c                                    |    4 +-
 drivers/net/wireless/rtlwifi/base.h                                    |    2 +-
 drivers/net/wireless/rtlwifi/cam.c                                     |    7 +-
 drivers/net/wireless/rtlwifi/core.c                                    |   14 +-
 drivers/net/wireless/rtlwifi/efuse.c                                   |    4 +-
 drivers/net/wireless/rtlwifi/pci.c                                     |   33 +-
 drivers/net/wireless/rtlwifi/ps.c                                      |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c                      |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c                      |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c                            |   43 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c                           |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c                            |   43 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c                           |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c                            |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c                            |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c                            |   34 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c                           |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c                           |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c                            |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c                            |   46 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c                           |    3 +
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c                            |    1 -
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c                           |    2 +-
 drivers/net/wireless/rtlwifi/usb.c                                     |   14 +-
 drivers/net/wireless/rtlwifi/wifi.h                                    |    1 +
 drivers/net/wireless/ti/Kconfig                                        |    1 +
 drivers/net/wireless/ti/Makefile                                       |    1 +
 drivers/net/wireless/ti/wl1251/cmd.c                                   |    9 -
 drivers/net/wireless/ti/wl1251/main.c                                  |   67 +-
 drivers/net/wireless/ti/wl1251/wl1251.h                                |    1 -
 drivers/net/wireless/ti/wl12xx/Makefile                                |    2 +-
 drivers/net/wireless/ti/wl12xx/acx.h                                   |  237 ++++
 drivers/net/wireless/ti/wl12xx/cmd.c                                   |   58 +-
 drivers/net/wireless/ti/wl12xx/debugfs.c                               |  243 ++++
 drivers/net/wireless/ti/wl12xx/debugfs.h                               |   28 +
 drivers/net/wireless/ti/wl12xx/main.c                                  |  621 +++++++--
 drivers/net/wireless/ti/wl12xx/wl12xx.h                                |   22 +
 drivers/net/wireless/ti/wl18xx/Kconfig                                 |    7 +
 drivers/net/wireless/ti/wl18xx/Makefile                                |    3 +
 drivers/net/wireless/ti/wl18xx/acx.c                                   |  111 ++
 drivers/net/wireless/ti/wl18xx/acx.h                                   |  287 +++++
 drivers/net/wireless/ti/wl18xx/conf.h                                  |  111 ++
 drivers/net/wireless/ti/wl18xx/debugfs.c                               |  403 ++++++
 drivers/net/wireless/ti/wl18xx/debugfs.h                               |   28 +
 drivers/net/wireless/ti/wl18xx/io.c                                    |   75 ++
 drivers/net/wireless/ti/wl18xx/io.h                                    |   28 +
 drivers/net/wireless/ti/wl18xx/main.c                                  | 1610 +++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/reg.h                                   |  191 +++
 drivers/net/wireless/ti/wl18xx/tx.c                                    |  127 ++
 drivers/net/wireless/ti/wl18xx/tx.h                                    |   46 +
 drivers/net/wireless/ti/wl18xx/wl18xx.h                                |   95 ++
 drivers/net/wireless/ti/wlcore/acx.c                                   |   16 +-
 drivers/net/wireless/ti/wlcore/acx.h                                   |  259 +---
 drivers/net/wireless/ti/wlcore/boot.c                                  |  184 ++-
 drivers/net/wireless/ti/wlcore/boot.h                                  |    1 +
 drivers/net/wireless/ti/wlcore/cmd.c                                   |  173 ++-
 drivers/net/wireless/ti/wlcore/cmd.h                                   |   40 +-
 drivers/net/wireless/ti/wlcore/conf.h                                  |   99 +-
 drivers/net/wireless/ti/wlcore/debugfs.c                               |  643 ++++++----
 drivers/net/wireless/ti/wlcore/debugfs.h                               |   87 ++
 drivers/net/wireless/ti/wlcore/event.c                                 |   39 +-
 drivers/net/wireless/ti/wlcore/hw_ops.h                                |   90 +-
 drivers/net/wireless/ti/wlcore/ini.h                                   |   22 +-
 drivers/net/wireless/ti/wlcore/init.c                                  |   62 +-
 drivers/net/wireless/ti/wlcore/io.c                                    |   61 +-
 drivers/net/wireless/ti/wlcore/io.h                                    |  145 ++-
 drivers/net/wireless/ti/wlcore/main.c                                  |  921 +++++++++-----
 drivers/net/wireless/ti/wlcore/ps.c                                    |   37 +-
 drivers/net/wireless/ti/wlcore/rx.c                                    |   50 +-
 drivers/net/wireless/ti/wlcore/rx.h                                    |   15 +-
 drivers/net/wireless/ti/wlcore/scan.c                                  |   61 +-
 drivers/net/wireless/ti/wlcore/scan.h                                  |   19 +-
 drivers/net/wireless/ti/wlcore/sdio.c                                  |   91 +-
 drivers/net/wireless/ti/wlcore/spi.c                                   |   20 +-
 drivers/net/wireless/ti/wlcore/testmode.c                              |  112 +-
 drivers/net/wireless/ti/wlcore/tx.c                                    |  282 ++++-
 drivers/net/wireless/ti/wlcore/tx.h                                    |   53 +-
 drivers/net/wireless/ti/wlcore/wlcore.h                                |  119 +-
 drivers/net/wireless/ti/wlcore/{wl12xx.h => wlcore_i.h}                |   75 +-
 drivers/net/wireless/zd1211rw/zd_chip.h                                |    2 +-
 drivers/net/wireless/zd1211rw/zd_usb.h                                 |    2 +-
 drivers/net/xen-netback/netback.c                                      |    4 +-
 drivers/nfc/nfcwilink.c                                                |    7 +-
 drivers/nfc/pn533.c                                                    |  846 +++++++++++--
 drivers/nfc/pn544_hci.c                                                |   47 +-
 drivers/of/of_mdio.c                                                   |   16 +-
 drivers/s390/net/qeth_l2_main.c                                        |    2 +-
 drivers/s390/net/qeth_l3_main.c                                        |    5 +-
 drivers/scsi/bnx2fc/bnx2fc.h                                           |    4 +
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                                      |   44 +
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h                                    |   16 +-
 drivers/scsi/bnx2i/bnx2i.h                                             |   58 +
 drivers/scsi/bnx2i/bnx2i_hwi.c                                         |   35 +-
 drivers/scsi/bnx2i/bnx2i_init.c                                        |   40 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c                                       |   11 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                                     |    3 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                                     |    5 +-
 drivers/scsi/cxgbi/libcxgbi.c                                          |   12 +-
 drivers/scsi/scsi_netlink.c                                            |    7 +-
 drivers/scsi/scsi_transport_iscsi.c                                    |    9 +-
 drivers/ssb/b43_pci_bridge.c                                           |    1 +
 drivers/ssb/scan.c                                                     |    2 +
 drivers/staging/gdm72xx/netlink_k.c                                    |   16 +-
 drivers/usb/atm/xusbatm.c                                              |    4 +-
 drivers/usb/gadget/u_ether.c                                           |    2 +-
 drivers/vhost/net.c                                                    |    4 +-
 drivers/vhost/test.c                                                   |    4 +-
 drivers/vhost/vhost.c                                                  |    5 +-
 drivers/vhost/vhost.h                                                  |    6 +-
 include/linux/bcma/bcma.h                                              |   39 +
 include/linux/bcma/bcma_driver_chipcommon.h                            |   88 +-
 include/linux/bcma/bcma_driver_gmac_cmn.h                              |  100 ++
 include/linux/can.h                                                    |   70 +-
 include/linux/can/core.h                                               |    4 +-
 include/linux/can/dev.h                                                |   35 +-
 include/linux/can/error.h                                              |    4 +-
 include/linux/can/raw.h                                                |    3 +-
 include/linux/cpu_rmap.h                                               |    4 +
 include/linux/etherdevice.h                                            |   25 +-
 include/linux/ethtool.h                                                |   43 +
 include/linux/genetlink.h                                              |    2 +-
 include/linux/ieee80211.h                                              |  212 +++-
 include/linux/if.h                                                     |    2 +
 include/linux/if_ether.h                                               |    3 +-
 include/linux/if_link.h                                                |    2 +
 include/linux/if_team.h                                                |   74 +-
 include/linux/if_tunnel.h                                              |   14 +
 include/linux/inetdevice.h                                             |    2 +
 include/linux/ipv6.h                                                   |   36 +-
 include/linux/ks8851_mll.h                                             |   33 +
 include/linux/mdio.h                                                   |   28 +-
 include/linux/mii.h                                                    |    9 +
 include/linux/mlx4/cmd.h                                               |    4 +
 include/linux/mlx4/device.h                                            |  139 +-
 include/linux/mlx4/driver.h                                            |    2 +
 include/linux/net.h                                                    |    2 +
 include/linux/netdevice.h                                              |   18 +-
 include/linux/netfilter.h                                              |   26 +
 include/linux/netfilter/Kbuild                                         |    1 +
 include/linux/netfilter/nf_conntrack_sip.h                             |    2 +
 include/linux/netfilter/nfnetlink.h                                    |    3 +-
 include/linux/netfilter/nfnetlink_conntrack.h                          |   39 +
 include/linux/netfilter/nfnetlink_cthelper.h                           |   55 +
 include/linux/netfilter/nfnetlink_queue.h                              |    9 +
 include/linux/netfilter/xt_connlimit.h                                 |    9 +-
 include/linux/netfilter/xt_recent.h                                    |   10 +
 include/linux/netfilter_ipv4.h                                         |    1 +
 include/linux/netfilter_ipv4/Kbuild                                    |    1 -
 include/linux/netfilter_ipv4/ipt_addrtype.h                            |   27 -
 include/linux/netfilter_ipv6.h                                         |    1 +
 include/linux/netlink.h                                                |   24 +-
 include/linux/netpoll.h                                                |    2 +-
 include/linux/nfc.h                                                    |   26 +-
 include/linux/nl80211.h                                                |  234 +++-
 include/linux/nl802154.h                                               |   14 +-
 include/linux/phy.h                                                    |   31 +-
 include/linux/pkt_cls.h                                                |    6 +-
 include/linux/rtnetlink.h                                              |  132 +-
 include/linux/skbuff.h                                                 |   16 +
 include/linux/snmp.h                                                   |    9 +-
 include/linux/sock_diag.h                                              |    2 +-
 include/linux/socket.h                                                 |    1 +
 include/linux/spi/at86rf230.h                                          |   31 +
 include/linux/ssb/ssb.h                                                |    1 +
 include/linux/tcp.h                                                    |   36 +-
 include/linux/tipc_config.h                                            |    4 +-
 include/linux/usb/usbnet.h                                             |    5 +-
 include/net/addrconf.h                                                 |    3 +-
 include/net/af_unix.h                                                  |    3 +-
 include/net/arp.h                                                      |   25 +-
 include/net/bluetooth/a2mp.h                                           |  126 ++
 include/net/bluetooth/bluetooth.h                                      |   39 +-
 include/net/bluetooth/hci.h                                            |  110 +-
 include/net/bluetooth/hci_core.h                                       |   37 +-
 include/net/bluetooth/l2cap.h                                          |  210 +--
 include/net/bluetooth/mgmt.h                                           |    2 +-
 include/net/caif/caif_hsi.h                                            |   71 +-
 include/net/cfg80211.h                                                 |  278 +++-
 include/net/dn_route.h                                                 |    2 +
 include/net/dst.h                                                      |   92 +-
 include/net/dst_ops.h                                                  |   10 +-
 include/net/fib_rules.h                                                |    1 +
 include/net/flow.h                                                     |    3 +-
 include/net/genetlink.h                                                |    2 +
 include/net/inet6_connection_sock.h                                    |    3 +
 include/net/inet_common.h                                              |    6 +-
 include/net/inet_connection_sock.h                                     |    3 +-
 include/net/inet_hashtables.h                                          |    4 +-
 include/net/inet_sock.h                                                |    3 +-
 include/net/inetpeer.h                                                 |   90 +-
 include/net/ip.h                                                       |    8 +-
 include/net/ip6_fib.h                                                  |   35 +-
 include/net/ip6_route.h                                                |   41 +-
 include/net/ip6_tunnel.h                                               |    2 +
 include/net/ip_fib.h                                                   |   83 +-
 include/net/ipv6.h                                                     |   39 +-
 include/net/mac80211.h                                                 |  109 +-
 include/net/mac802154.h                                                |    8 +
 include/net/ndisc.h                                                    |   50 +
 include/net/neighbour.h                                                |   26 +-
 include/net/net_namespace.h                                            |    1 +
 include/net/netevent.h                                                 |    4 +
 include/net/netfilter/nf_conntrack.h                                   |   35 +-
 include/net/netfilter/nf_conntrack_core.h                              |    4 +-
 include/net/netfilter/nf_conntrack_expect.h                            |    4 +-
 include/net/netfilter/nf_conntrack_extend.h                            |    9 +-
 include/net/netfilter/nf_conntrack_helper.h                            |   29 +-
 include/net/netfilter/nf_conntrack_l3proto.h                           |   11 +-
 include/net/netfilter/nf_conntrack_l4proto.h                           |   33 +-
 include/net/netfilter/nf_nat_helper.h                                  |    4 +
 include/net/netfilter/nfnetlink_queue.h                                |   43 +
 include/net/netns/conntrack.h                                          |   55 +
 include/net/netns/ipv4.h                                               |   14 +-
 include/net/netns/ipv6.h                                               |    1 +
 include/net/netprio_cgroup.h                                           |    4 +-
 include/net/nfc/hci.h                                                  |   22 +-
 include/net/nfc/nfc.h                                                  |   16 +-
 include/net/nfc/shdlc.h                                                |    3 +-
 include/net/protocol.h                                                 |    8 +-
 include/net/regulatory.h                                               |    5 +
 include/net/route.h                                                    |   76 +-
 include/net/rtnetlink.h                                                |   10 +-
 include/net/sch_generic.h                                              |    2 +-
 include/net/sctp/constants.h                                           |    1 +
 include/net/sctp/sctp.h                                                |    6 +-
 include/net/sctp/structs.h                                             |   24 +-
 include/net/sctp/user.h                                                |   11 +
 include/net/sock.h                                                     |    8 +-
 include/net/tcp.h                                                      |   48 +-
 include/net/timewait_sock.h                                            |    8 -
 include/net/xfrm.h                                                     |   12 +-
 kernel/audit.c                                                         |   30 +-
 lib/kobject_uevent.c                                                   |    5 +-
 net/8021q/vlan_dev.c                                                   |    5 +-
 net/9p/client.c                                                        |    2 +-
 net/9p/trans_virtio.c                                                  |    2 +-
 net/appletalk/ddp.c                                                    |    8 +-
 net/atm/lec.c                                                          |    8 +-
 net/atm/pppoatm.c                                                      |    2 +-
 net/ax25/ax25_addr.c                                                   |    6 +-
 net/ax25/ax25_out.c                                                    |    2 +-
 net/ax25/ax25_route.c                                                  |    2 +-
 net/batman-adv/Makefile                                                |    4 +-
 net/batman-adv/bat_algo.h                                              |    6 +-
 net/batman-adv/bat_debugfs.c                                           |  388 ------
 net/batman-adv/bat_iv_ogm.c                                            | 1050 +++++++--------
 net/batman-adv/bat_sysfs.c                                             |  735 -----------
 net/batman-adv/bitarray.c                                              |   65 +-
 net/batman-adv/bitarray.h                                              |   24 +-
 net/batman-adv/bridge_loop_avoidance.c                                 |  799 ++++++------
 net/batman-adv/bridge_loop_avoidance.h                                 |   76 +-
 net/batman-adv/debugfs.c                                               |  409 ++++++
 net/batman-adv/{bat_debugfs.h => debugfs.h}                            |   15 +-
 net/batman-adv/gateway_client.c                                        |  354 +++---
 net/batman-adv/gateway_client.h                                        |   32 +-
 net/batman-adv/gateway_common.c                                        |   61 +-
 net/batman-adv/gateway_common.h                                        |   23 +-
 net/batman-adv/hard-interface.c                                        |  342 ++---
 net/batman-adv/hard-interface.h                                        |   51 +-
 net/batman-adv/hash.c                                                  |   25 +-
 net/batman-adv/hash.h                                                  |   78 +-
 net/batman-adv/icmp_socket.c                                           |  180 +--
 net/batman-adv/icmp_socket.h                                           |   14 +-
 net/batman-adv/main.c                                                  |  276 ++--
 net/batman-adv/main.h                                                  |  257 ++--
 net/batman-adv/originator.c                                            |  337 ++---
 net/batman-adv/originator.h                                            |   57 +-
 net/batman-adv/packet.h                                                |  181 +--
 net/batman-adv/ring_buffer.c                                           |   13 +-
 net/batman-adv/ring_buffer.h                                           |    9 +-
 net/batman-adv/routing.c                                               |  689 +++++-----
 net/batman-adv/routing.h                                               |   64 +-
 net/batman-adv/send.c                                                  |  237 ++--
 net/batman-adv/send.h                                                  |   23 +-
 net/batman-adv/soft-interface.c                                        |  304 +++--
 net/batman-adv/soft-interface.h                                        |   17 +-
 net/batman-adv/sysfs.c                                                 |  787 ++++++++++++
 net/batman-adv/{bat_sysfs.h => sysfs.h}                                |   24 +-
 net/batman-adv/translation-table.c                                     | 1659 +++++++++++++-----------
 net/batman-adv/translation-table.h                                     |   75 +-
 net/batman-adv/types.h                                                 |  183 +--
 net/batman-adv/unicast.c                                               |  179 +--
 net/batman-adv/unicast.h                                               |   34 +-
 net/batman-adv/vis.c                                                   |  728 ++++++-----
 net/batman-adv/vis.h                                                   |   26 +-
 net/bluetooth/Makefile                                                 |    3 +-
 net/bluetooth/a2mp.c                                                   |  568 +++++++++
 net/bluetooth/af_bluetooth.c                                           |   14 +-
 net/bluetooth/bnep/core.c                                              |   21 +-
 net/bluetooth/bnep/netdev.c                                            |   16 +-
 net/bluetooth/bnep/sock.c                                              |   18 +-
 net/bluetooth/hci_conn.c                                               |  143 +--
 net/bluetooth/hci_core.c                                               |  265 ++--
 net/bluetooth/hci_event.c                                              |  479 +++----
 net/bluetooth/hci_sock.c                                               |   59 +-
 net/bluetooth/hci_sysfs.c                                              |   99 +-
 net/bluetooth/hidp/core.c                                              |   26 +-
 net/bluetooth/hidp/sock.c                                              |   16 +-
 net/bluetooth/l2cap_core.c                                             | 2248 ++++++++++++++++++++-------------
 net/bluetooth/l2cap_sock.c                                             |  130 +-
 net/bluetooth/lib.c                                                    |    7 +-
 net/bluetooth/mgmt.c                                                   |  131 +-
 net/bluetooth/rfcomm/core.c                                            |   32 +-
 net/bluetooth/rfcomm/sock.c                                            |   21 +-
 net/bluetooth/rfcomm/tty.c                                             |    9 +-
 net/bluetooth/sco.c                                                    |   43 +-
 net/bluetooth/smp.c                                                    |    7 +-
 net/bridge/br_device.c                                                 |    9 +-
 net/bridge/br_multicast.c                                              |   11 +-
 net/bridge/br_netfilter.c                                              |   77 +-
 net/bridge/netfilter/ebt_ulog.c                                        |   29 +-
 net/caif/caif_dev.c                                                    |    8 +-
 net/caif/cfctrl.c                                                      |   17 +-
 net/can/af_can.c                                                       |  126 +-
 net/can/af_can.h                                                       |    3 +
 net/can/gw.c                                                           |   90 +-
 net/can/proc.c                                                         |    3 -
 net/can/raw.c                                                          |   50 +-
 net/ceph/pagelist.c                                                    |   14 +-
 net/compat.c                                                           |    4 +-
 net/core/datagram.c                                                    |    1 -
 net/core/dev.c                                                         |   44 +-
 net/core/dst.c                                                         |   25 +-
 net/core/ethtool.c                                                     |   45 +
 net/core/fib_rules.c                                                   |    4 +
 net/core/flow_dissector.c                                              |    5 +-
 net/core/neighbour.c                                                   |   31 +-
 net/core/net-sysfs.c                                                   |   74 --
 net/core/netpoll.c                                                     |   10 +-
 net/core/netprio_cgroup.c                                              |   53 +
 net/core/rtnetlink.c                                                   |   57 +-
 net/core/skbuff.c                                                      |   71 +-
 net/core/sock.c                                                        |   15 +-
 net/core/sock_diag.c                                                   |   42 +-
 net/dcb/dcbnl.c                                                        | 1168 ++++++-----------
 net/dccp/ackvec.h                                                      |    7 +-
 net/dccp/ccid.c                                                        |    1 +
 net/dccp/ccids/ccid3.c                                                 |    8 +-
 net/dccp/ccids/lib/loss_interval.c                                     |    1 +
 net/dccp/ccids/lib/packet_history.c                                    |    3 +-
 net/dccp/ccids/lib/tfrc_equation.c                                     |    2 +
 net/dccp/dccp.h                                                        |    1 +
 net/dccp/feat.c                                                        |   10 +
 net/dccp/input.c                                                       |    1 +
 net/dccp/ipv4.c                                                        |   24 +-
 net/dccp/ipv6.c                                                        |   61 +-
 net/dccp/options.c                                                     |    1 +
 net/dccp/output.c                                                      |    1 +
 net/decnet/dn_fib.c                                                    |    8 +
 net/decnet/dn_neigh.c                                                  |    8 +-
 net/decnet/dn_nsp_out.c                                                |    2 +-
 net/decnet/dn_route.c                                                  |  144 ++-
 net/decnet/dn_table.c                                                  |   76 +-
 net/decnet/netfilter/dn_rtmsg.c                                        |   30 +-
 net/ethernet/Makefile                                                  |    2 -
 net/ethernet/eth.c                                                     |    5 +-
 net/ieee802154/6lowpan.c                                               |  251 ++--
 net/ieee802154/netlink.c                                               |    4 +-
 net/ieee802154/nl-mac.c                                                |    2 +-
 net/ieee802154/nl-phy.c                                                |    2 +-
 net/ipv4/Kconfig                                                       |   11 +
 net/ipv4/Makefile                                                      |    3 +-
 net/ipv4/af_inet.c                                                     |   75 +-
 net/ipv4/ah4.c                                                         |   17 +-
 net/ipv4/arp.c                                                         |    8 +-
 net/ipv4/devinet.c                                                     |    5 +-
 net/ipv4/esp4.c                                                        |   17 +-
 net/ipv4/fib_frontend.c                                                |  130 +-
 net/ipv4/fib_rules.c                                                   |   39 +-
 net/ipv4/fib_semantics.c                                               |   46 +-
 net/ipv4/fib_trie.c                                                    |   13 +-
 net/ipv4/icmp.c                                                        |  191 +--
 net/ipv4/inet_connection_sock.c                                        |   53 +-
 net/ipv4/inet_diag.c                                                   |  146 ++-
 net/ipv4/inet_fragment.c                                               |    2 +-
 net/ipv4/inetpeer.c                                                    |   99 +-
 net/ipv4/ip_fragment.c                                                 |   10 +-
 net/ipv4/ip_gre.c                                                      |   25 +-
 net/ipv4/ip_input.c                                                    |   32 +-
 net/ipv4/ip_options.c                                                  |   29 +-
 net/ipv4/ip_output.c                                                   |   93 +-
 net/ipv4/ip_sockglue.c                                                 |   12 +-
 net/ipv4/ip_vti.c                                                      |  956 ++++++++++++++
 net/ipv4/ipcomp.c                                                      |   17 +-
 net/ipv4/ipip.c                                                        |   28 +-
 net/ipv4/ipmr.c                                                        |   41 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                                    |    5 +-
 net/ipv4/netfilter/ipt_ULOG.c                                          |   23 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c                         |  172 ++-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c                           |   81 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                                    |    4 +-
 net/ipv4/netfilter/nf_nat_amanda.c                                     |    4 +-
 net/ipv4/netfilter/nf_nat_core.c                                       |    6 +
 net/ipv4/netfilter/nf_nat_h323.c                                       |    8 +-
 net/ipv4/netfilter/nf_nat_helper.c                                     |   13 +
 net/ipv4/netfilter/nf_nat_pptp.c                                       |    6 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c                                 |    4 +-
 net/ipv4/netfilter/nf_nat_tftp.c                                       |    4 +-
 net/ipv4/ping.c                                                        |    2 +
 net/ipv4/proc.c                                                        |    7 +-
 net/ipv4/protocol.c                                                    |    8 +-
 net/ipv4/raw.c                                                         |    5 +
 net/ipv4/route.c                                                       | 2150 +++++++++----------------------
 net/ipv4/syncookies.c                                                  |    2 +-
 net/ipv4/sysctl_net_ipv4.c                                             |   28 +
 net/ipv4/tcp.c                                                         |   72 +-
 net/ipv4/tcp_cong.c                                                    |    5 +-
 net/ipv4/tcp_fastopen.c                                                |   11 +
 net/ipv4/tcp_input.c                                                   |  375 +++---
 net/ipv4/tcp_ipv4.c                                                    |  186 +--
 net/ipv4/tcp_metrics.c                                                 |  745 +++++++++++
 net/ipv4/tcp_minisocks.c                                               |   61 +-
 net/ipv4/tcp_output.c                                                  |  343 ++++-
 net/ipv4/tcp_timer.c                                                   |   70 +-
 net/ipv4/udp.c                                                         |    9 +-
 net/ipv4/udp_diag.c                                                    |   10 +-
 net/ipv4/xfrm4_input.c                                                 |    4 +-
 net/ipv4/xfrm4_mode_tunnel.c                                           |   68 +
 net/ipv4/xfrm4_policy.c                                                |   33 +-
 net/ipv6/addrconf.c                                                    |   21 +-
 net/ipv6/ah6.c                                                         |   11 +-
 net/ipv6/esp6.c                                                        |   11 +-
 net/ipv6/exthdrs.c                                                     |    4 +-
 net/ipv6/icmp.c                                                        |   23 +-
 net/ipv6/inet6_connection_sock.c                                       |  103 +-
 net/ipv6/ip6_fib.c                                                     |    5 +
 net/ipv6/ip6_input.c                                                   |    9 +-
 net/ipv6/ip6_output.c                                                  |   40 +-
 net/ipv6/ip6_tunnel.c                                                  |   96 +-
 net/ipv6/ip6mr.c                                                       |    5 +-
 net/ipv6/ipcomp6.c                                                     |   11 +-
 net/ipv6/mcast.c                                                       |    3 +
 net/ipv6/ndisc.c                                                       |  129 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c                         |  131 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c                         |   51 +-
 net/ipv6/protocol.c                                                    |    8 +-
 net/ipv6/raw.c                                                         |   11 +-
 net/ipv6/route.c                                                       |  538 ++++----
 net/ipv6/sit.c                                                         |   25 +-
 net/ipv6/syncookies.c                                                  |    5 +-
 net/ipv6/tcp_ipv6.c                                                    |  204 +--
 net/ipv6/udp.c                                                         |   13 +-
 net/ipv6/xfrm6_policy.c                                                |   26 +-
 net/ipx/Makefile                                                       |    2 +-
 net/{ethernet => ipx}/pe2.c                                            |    2 -
 net/irda/af_irda.c                                                     |    2 +-
 net/irda/irlan/irlan_provider.c                                        |    2 +-
 net/irda/irqueue.c                                                     |    6 +-
 net/l2tp/l2tp_core.c                                                   |   11 +-
 net/l2tp/l2tp_eth.c                                                    |   15 +-
 net/l2tp/l2tp_netlink.c                                                |    6 +-
 net/l2tp/l2tp_ppp.c                                                    |    8 +-
 net/llc/af_llc.c                                                       |    2 +-
 net/llc/llc_station.c                                                  |   16 +-
 net/mac80211/Kconfig                                                   |   56 +-
 net/mac80211/Makefile                                                  |    7 +-
 net/mac80211/agg-rx.c                                                  |   38 +-
 net/mac80211/agg-tx.c                                                  |  118 +-
 net/mac80211/cfg.c                                                     |  734 ++++++-----
 net/mac80211/chan.c                                                    |    4 +
 net/mac80211/debug.h                                                   |  170 +++
 net/mac80211/debugfs.c                                                 |    2 -
 net/mac80211/debugfs_key.c                                             |   16 +-
 net/mac80211/debugfs_netdev.c                                          |   49 +-
 net/mac80211/driver-ops.h                                              |   39 +-
 net/mac80211/driver-trace.c                                            |    9 -
 net/mac80211/ht.c                                                      |   10 +-
 net/mac80211/ibss.c                                                    |  127 +-
 net/mac80211/ieee80211_i.h                                             |  139 +-
 net/mac80211/iface.c                                                   |  325 +++--
 net/mac80211/key.c                                                     |   24 +-
 net/mac80211/main.c                                                    |   48 +-
 net/mac80211/mesh.c                                                    |   19 +-
 net/mac80211/mesh.h                                                    |    4 +-
 net/mac80211/mesh_hwmp.c                                               |  173 ++-
 net/mac80211/mesh_pathtbl.c                                            |   34 +-
 net/mac80211/mesh_plink.c                                              |   70 +-
 net/mac80211/mesh_sync.c                                               |   47 +-
 net/mac80211/mlme.c                                                    |  382 +++---
 net/mac80211/offchannel.c                                              |  291 ++++-
 net/mac80211/pm.c                                                      |   11 +
 net/mac80211/rc80211_minstrel_ht.c                                     |    8 +-
 net/mac80211/rx.c                                                      |  130 +-
 net/mac80211/scan.c                                                    |  123 +-
 net/mac80211/sta_info.c                                                |   45 +-
 net/mac80211/status.c                                                  |   48 +-
 net/mac80211/tkip.c                                                    |   46 +-
 net/mac80211/trace.c                                                   |   75 ++
 net/mac80211/{driver-trace.h => trace.h}                               |   80 +-
 net/mac80211/tx.c                                                      |   95 +-
 net/mac80211/util.c                                                    |  178 ++-
 net/mac80211/wme.c                                                     |   11 +-
 net/mac80211/wme.h                                                     |    2 +-
 net/mac80211/work.c                                                    |  370 ------
 net/mac802154/Makefile                                                 |    2 +-
 net/mac802154/ieee802154_dev.c                                         |    4 +
 net/mac802154/mac802154.h                                              |    9 +
 net/mac802154/mac_cmd.c                                                |   33 +-
 net/mac802154/mib.c                                                    |  108 +-
 net/mac802154/rx.c                                                     |    1 +
 net/mac802154/tx.c                                                     |    2 +
 net/mac802154/wpan.c                                                   |  559 ++++++++
 net/netfilter/Kconfig                                                  |   21 +
 net/netfilter/Makefile                                                 |    3 +
 net/netfilter/core.c                                                   |    7 +
 net/netfilter/ipvs/ip_vs_core.c                                        |   24 +-
 net/netfilter/ipvs/ip_vs_xmit.c                                        |    8 +-
 net/netfilter/nf_conntrack_core.c                                      |   22 +-
 net/netfilter/nf_conntrack_extend.c                                    |   16 +-
 net/netfilter/nf_conntrack_ftp.c                                       |   11 +-
 net/netfilter/nf_conntrack_h323_main.c                                 |   16 +-
 net/netfilter/nf_conntrack_helper.c                                    |   38 +-
 net/netfilter/nf_conntrack_irc.c                                       |    8 +-
 net/netfilter/nf_conntrack_netlink.c                                   |  407 +++++-
 net/netfilter/nf_conntrack_pptp.c                                      |   17 +-
 net/netfilter/nf_conntrack_proto.c                                     |  300 +++--
 net/netfilter/nf_conntrack_proto_dccp.c                                |  143 ++-
 net/netfilter/nf_conntrack_proto_generic.c                             |   81 +-
 net/netfilter/nf_conntrack_proto_gre.c                                 |   79 +-
 net/netfilter/nf_conntrack_proto_sctp.c                                |  175 ++-
 net/netfilter/nf_conntrack_proto_tcp.c                                 |  163 ++-
 net/netfilter/nf_conntrack_proto_udp.c                                 |  111 +-
 net/netfilter/nf_conntrack_proto_udplite.c                             |  127 +-
 net/netfilter/nf_conntrack_sane.c                                      |   12 +-
 net/netfilter/nf_conntrack_sip.c                                       |   32 +-
 net/netfilter/nf_conntrack_tftp.c                                      |    8 +-
 net/netfilter/nfnetlink.c                                              |   40 +-
 net/netfilter/nfnetlink_cthelper.c                                     |  672 ++++++++++
 net/netfilter/nfnetlink_cttimeout.c                                    |   13 +-
 net/netfilter/nfnetlink_log.c                                          |   29 +-
 net/netfilter/{nfnetlink_queue.c => nfnetlink_queue_core.c}            |   95 +-
 net/netfilter/nfnetlink_queue_ct.c                                     |   98 ++
 net/netfilter/xt_CT.c                                                  |   44 +-
 net/netfilter/xt_NFQUEUE.c                                             |   28 +-
 net/netfilter/xt_TPROXY.c                                              |    4 +-
 net/netfilter/xt_connlimit.c                                           |   35 +-
 net/netfilter/xt_recent.c                                              |   62 +-
 net/netlink/af_netlink.c                                               |   35 +-
 net/netlink/genetlink.c                                                |   14 +-
 net/nfc/core.c                                                         |  157 ++-
 net/nfc/hci/command.c                                                  |   26 +-
 net/nfc/hci/core.c                                                     |  137 +-
 net/nfc/hci/hci.h                                                      |   12 +-
 net/nfc/hci/hcp.c                                                      |    2 +-
 net/nfc/hci/shdlc.c                                                    |   44 +-
 net/nfc/llcp/commands.c                                                |   54 +-
 net/nfc/llcp/llcp.c                                                    |  627 +++++----
 net/nfc/llcp/llcp.h                                                    |   31 +-
 net/nfc/llcp/sock.c                                                    |   74 +-
 net/nfc/nci/core.c                                                     |   23 +-
 net/nfc/nci/ntf.c                                                      |    5 +-
 net/nfc/netlink.c                                                      |  104 +-
 net/nfc/nfc.h                                                          |   12 +-
 net/openvswitch/actions.c                                              |    5 +-
 net/openvswitch/datapath.c                                             |   13 +-
 net/openvswitch/datapath.h                                             |    2 +-
 net/openvswitch/dp_notify.c                                            |    2 +-
 net/openvswitch/flow.c                                                 |    5 +-
 net/openvswitch/flow.h                                                 |    2 +-
 net/openvswitch/vport-internal_dev.c                                   |   10 +-
 net/openvswitch/vport-internal_dev.h                                   |    2 +-
 net/openvswitch/vport-netdev.c                                         |    2 +-
 net/openvswitch/vport-netdev.h                                         |    2 +-
 net/openvswitch/vport.c                                                |    2 +-
 net/openvswitch/vport.h                                                |    2 +-
 net/packet/af_packet.c                                                 |   29 +-
 net/rds/page.c                                                         |    9 +-
 net/rds/recv.c                                                         |    3 +
 net/rfkill/core.c                                                      |    2 +-
 net/rxrpc/ar-error.c                                                   |    4 -
 net/rxrpc/ar-output.c                                                  |    2 +-
 net/sched/Kconfig                                                      |   20 +
 net/sched/Makefile                                                     |    2 +
 net/sched/act_api.c                                                    |   59 +-
 net/sched/cls_api.c                                                    |   12 +-
 net/sched/cls_route.c                                                  |    2 +-
 net/sched/em_canid.c                                                   |  240 ++++
 net/sched/em_ipset.c                                                   |  135 ++
 net/sched/em_meta.c                                                    |    2 +-
 net/sched/sch_api.c                                                    |   24 +-
 net/sched/sch_netem.c                                                  |    9 +-
 net/sched/sch_teql.c                                                   |   47 +-
 net/sctp/associola.c                                                   |   41 +-
 net/sctp/input.c                                                       |   20 +-
 net/sctp/ipv6.c                                                        |    3 +
 net/sctp/output.c                                                      |   81 +-
 net/sctp/outqueue.c                                                    |    6 +-
 net/sctp/protocol.c                                                    |    2 +-
 net/sctp/sm_make_chunk.c                                               |    2 +-
 net/sctp/sm_sideeffect.c                                               |   33 +-
 net/sctp/socket.c                                                      |  107 +-
 net/sctp/sysctl.c                                                      |    9 +
 net/sctp/transport.c                                                   |   20 +-
 net/socket.c                                                           |    8 +-
 net/sunrpc/backchannel_rqst.c                                          |    9 +-
 net/sunrpc/clnt.c                                                      |    2 +-
 net/sunrpc/svcauth_unix.c                                              |   22 +-
 net/sunrpc/svcsock.c                                                   |   12 +-
 net/sunrpc/xdr.c                                                       |   12 +-
 net/sunrpc/xprt.c                                                      |    2 +-
 net/sunrpc/xprtsock.c                                                  |    3 -
 net/tipc/Kconfig                                                       |   25 -
 net/tipc/bcast.c                                                       |   75 +-
 net/tipc/bearer.c                                                      |   69 +-
 net/tipc/bearer.h                                                      |    4 +-
 net/tipc/config.c                                                      |   41 +-
 net/tipc/core.c                                                        |   18 +-
 net/tipc/core.h                                                        |   65 +-
 net/tipc/discover.c                                                    |   10 +-
 net/tipc/handler.c                                                     |    4 +-
 net/tipc/link.c                                                        |  326 +++--
 net/tipc/link.h                                                        |   63 +-
 net/tipc/log.c                                                         |  302 +----
 net/tipc/log.h                                                         |   66 -
 net/tipc/msg.c                                                         |  242 ----
 net/tipc/name_distr.c                                                  |   25 +-
 net/tipc/name_table.c                                                  |  142 ++-
 net/tipc/net.c                                                         |    8 +-
 net/tipc/netlink.c                                                     |    2 +-
 net/tipc/node.c                                                        |   22 +-
 net/tipc/node_subscr.c                                                 |    3 +-
 net/tipc/port.c                                                        |   77 +-
 net/tipc/port.h                                                        |    1 +
 net/tipc/ref.c                                                         |   10 +-
 net/tipc/socket.c                                                      |   17 +-
 net/tipc/subscr.c                                                      |   14 +-
 net/unix/af_unix.c                                                     |  110 +-
 net/unix/diag.c                                                        |  115 +-
 net/wireless/Kconfig                                                   |   35 +-
 net/wireless/Makefile                                                  |    2 +-
 net/wireless/ap.c                                                      |   46 +
 net/wireless/chan.c                                                    |  107 +-
 net/wireless/core.c                                                    |  134 +-
 net/wireless/core.h                                                    |  106 +-
 net/wireless/ibss.c                                                    |   11 +
 net/wireless/mesh.c                                                    |  121 +-
 net/wireless/mlme.c                                                    |   64 +-
 net/wireless/nl80211.c                                                 | 1009 +++++++++++----
 net/wireless/nl80211.h                                                 |   21 +-
 net/wireless/reg.c                                                     |  137 +-
 net/wireless/reg.h                                                     |    8 +-
 net/wireless/scan.c                                                    |   24 +-
 net/wireless/sme.c                                                     |   10 +-
 net/wireless/util.c                                                    |  171 ++-
 net/wireless/wext-compat.c                                             |   23 +-
 net/wireless/wext-sme.c                                                |   10 +-
 net/x25/x25_route.c                                                    |    2 +-
 net/xfrm/xfrm_policy.c                                                 |   37 +-
 net/xfrm/xfrm_user.c                                                   |  401 +++---
 security/selinux/hooks.c                                               |   10 +-
 security/selinux/netlink.c                                             |   17 +-
 1363 files changed, 70064 insertions(+), 57900 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/broadcom-bcm87xx.txt
 create mode 100644 Documentation/devicetree/bindings/net/davinci_emac.txt
 rename arch/m68k/include/asm/{mcfne.h => mcf8390.h} (54%)
 create mode 100644 drivers/bcma/driver_chipcommon_nflash.c
 create mode 100644 drivers/bcma/driver_chipcommon_sflash.c
 create mode 100644 drivers/bcma/driver_gmac_cmn.c
 create mode 100644 drivers/bluetooth/hci_h5.c
 create mode 100644 drivers/ieee802154/at86rf230.c
 delete mode 100644 drivers/misc/iwmc3200top/Kconfig
 delete mode 100644 drivers/misc/iwmc3200top/Makefile
 delete mode 100644 drivers/misc/iwmc3200top/debugfs.c
 delete mode 100644 drivers/misc/iwmc3200top/debugfs.h
 delete mode 100644 drivers/misc/iwmc3200top/fw-download.c
 delete mode 100644 drivers/misc/iwmc3200top/fw-msg.h
 delete mode 100644 drivers/misc/iwmc3200top/iwmc3200top.h
 delete mode 100644 drivers/misc/iwmc3200top/log.c
 delete mode 100644 drivers/misc/iwmc3200top/log.h
 delete mode 100644 drivers/misc/iwmc3200top/main.c
 create mode 100644 drivers/net/can/c_can/c_can_pci.c
 create mode 100644 drivers/net/ethernet/8390/mcf8390.c
 create mode 100644 drivers/net/ethernet/broadcom/bnx2x/bnx2x_mfw_req.h
 create mode 100644 drivers/net/phy/bcm87xx.c
 create mode 100644 drivers/net/team/team_mode_broadcast.c
 create mode 100644 drivers/net/usb/asix.h
 create mode 100644 drivers/net/usb/asix_common.c
 rename drivers/net/usb/{asix.c => asix_devices.c} (61%)
 create mode 100644 drivers/net/usb/ax88172a.c
 delete mode 100644 drivers/net/wimax/i2400m/i2400m-sdio.h
 delete mode 100644 drivers/net/wimax/i2400m/sdio-debug-levels.h
 delete mode 100644 drivers/net/wimax/i2400m/sdio-fw.c
 delete mode 100644 drivers/net/wimax/i2400m/sdio-rx.c
 delete mode 100644 drivers/net/wimax/i2400m/sdio-tx.c
 delete mode 100644 drivers/net/wimax/i2400m/sdio.c
 create mode 100644 drivers/net/wireless/ath/ath9k/antenna.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h
 create mode 100644 drivers/net/wireless/ath/ath9k/link.c
 create mode 100644 drivers/net/wireless/ath/ath9k/wow.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
 create mode 100644 drivers/net/wireless/iwlwifi/dvm/Makefile
 rename drivers/net/wireless/iwlwifi/{iwl-agn.h => dvm/agn.h} (80%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-calib.c => dvm/calib.c} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-calib.h => dvm/calib.h} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-commands.h => dvm/commands.h} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-debugfs.c => dvm/debugfs.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-dev.h => dvm/dev.h} (81%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-devices.c => dvm/devices.c} (75%)
 rename drivers/net/wireless/iwlwifi/{iwl-led.c => dvm/led.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-led.h => dvm/led.h} (100%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-lib.c => dvm/lib.c} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-mac80211.c => dvm/mac80211.c} (90%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn.c => dvm/main.c} (84%)
 rename drivers/net/wireless/iwlwifi/{iwl-power.c => dvm/power.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-power.h => dvm/power.h} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rs.c => dvm/rs.c} (98%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rs.h => dvm/rs.h} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rx.c => dvm/rx.c} (94%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-rxon.c => dvm/rxon.c} (97%)
 rename drivers/net/wireless/iwlwifi/{iwl-scan.c => dvm/scan.c} (89%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-sta.c => dvm/sta.c} (97%)
 create mode 100644 drivers/net/wireless/iwlwifi/dvm/testmode.c
 rename drivers/net/wireless/iwlwifi/{iwl-agn-tt.c => dvm/tt.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-tt.h => dvm/tt.h} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-tx.c => dvm/tx.c} (96%)
 rename drivers/net/wireless/iwlwifi/{iwl-ucode.c => dvm/ucode.c} (90%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-eeprom.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-test.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-test.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-testmode.c
 rename drivers/net/wireless/iwlwifi/{iwl-1000.c => pcie/1000.c} (89%)
 rename drivers/net/wireless/iwlwifi/{iwl-2000.c => pcie/2000.c} (91%)
 rename drivers/net/wireless/iwlwifi/{iwl-5000.c => pcie/5000.c} (90%)
 rename drivers/net/wireless/iwlwifi/{iwl-6000.c => pcie/6000.c} (93%)
 rename drivers/net/wireless/iwlwifi/{iwl-cfg.h => pcie/cfg.h} (100%)
 rename drivers/net/wireless/iwlwifi/{iwl-pci.c => pcie/drv.c} (99%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie-int.h => pcie/internal.h} (95%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie-rx.c => pcie/rx.c} (94%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie.c => pcie/trans.c} (88%)
 rename drivers/net/wireless/iwlwifi/{iwl-trans-pcie-tx.c => pcie/tx.c} (84%)
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/Kconfig
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/Makefile
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/bus.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/cfg80211.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/cfg80211.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/commands.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/commands.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/debug.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/debugfs.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/eeprom.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/eeprom.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/fw.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/fw.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/hal.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/hal.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/iwm.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/lmac.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/main.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/netdev.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/rx.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/rx.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/sdio.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/sdio.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/trace.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/trace.h
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/tx.c
 delete mode 100644 drivers/net/wireless/iwmc3200wifi/umac.h
 create mode 100644 drivers/net/wireless/ti/wl12xx/debugfs.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/debugfs.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/Kconfig
 create mode 100644 drivers/net/wireless/ti/wl18xx/Makefile
 create mode 100644 drivers/net/wireless/ti/wl18xx/acx.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/acx.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/conf.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/debugfs.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/debugfs.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/io.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/io.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/main.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/reg.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/tx.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/tx.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/wl18xx.h
 rename drivers/net/wireless/ti/wlcore/{wl12xx.h => wlcore_i.h} (91%)
 create mode 100644 include/linux/bcma/bcma_driver_gmac_cmn.h
 create mode 100644 include/linux/ks8851_mll.h
 create mode 100644 include/linux/netfilter/nfnetlink_cthelper.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_addrtype.h
 create mode 100644 include/linux/spi/at86rf230.h
 create mode 100644 include/net/bluetooth/a2mp.h
 create mode 100644 include/net/netfilter/nfnetlink_queue.h
 delete mode 100644 net/batman-adv/bat_debugfs.c
 delete mode 100644 net/batman-adv/bat_sysfs.c
 create mode 100644 net/batman-adv/debugfs.c
 rename net/batman-adv/{bat_debugfs.h => debugfs.h} (74%)
 create mode 100644 net/batman-adv/sysfs.c
 rename net/batman-adv/{bat_sysfs.h => sysfs.h} (63%)
 create mode 100644 net/bluetooth/a2mp.c
 create mode 100644 net/ipv4/ip_vti.c
 create mode 100644 net/ipv4/tcp_fastopen.c
 create mode 100644 net/ipv4/tcp_metrics.c
 rename net/{ethernet => ipx}/pe2.c (91%)
 create mode 100644 net/mac80211/debug.h
 delete mode 100644 net/mac80211/driver-trace.c
 create mode 100644 net/mac80211/trace.c
 rename net/mac80211/{driver-trace.h => trace.h} (95%)
 delete mode 100644 net/mac80211/work.c
 create mode 100644 net/mac802154/wpan.c
 create mode 100644 net/netfilter/nfnetlink_cthelper.c
 rename net/netfilter/{nfnetlink_queue.c => nfnetlink_queue_core.c} (92%)
 create mode 100644 net/netfilter/nfnetlink_queue_ct.c
 create mode 100644 net/sched/em_canid.c
 create mode 100644 net/sched/em_ipset.c
 delete mode 100644 net/tipc/log.h
 create mode 100644 net/wireless/ap.c
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
