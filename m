Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030212Ab2AFA27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 19:28:59 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:35901 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab2AFA2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 19:28:50 -0500
Date: Thu, 05 Jan 2012 19:28:33 -0500 (EST)
Message-Id: <20120105.192833.760673635385506638.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 05 Jan 2012 16:28:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q060TC4c022995


The most prominent thing here are the TX byte queue limit changes
from Tom Herbert and others at Google.

The idea is that you can limit the amount of packet data, in bytes,
that can get queued up to a TX queue of a networking device.  And as
a result one can tune things such that high priority packets get
serviced with a reasonable amount of latency whilst not subjecting
the hardware queue to emptying when data is available to send.

Driver's need to make some minor changes to support this feature, and
drivers for most of the most commonly used ethernet devices have been
transformed.  In particular niu, bnx2, igb, e1000e, forcedeth, tg3,
bnx2x, sfc, and sky2 have support.

Eric Dumazet added a new interface for drivers called build_skb() which
allows the driver to DMA RX packets into kmalloc()'d buffers, and
then allocate the packet metadata on the local cpu right when we push
the packet up into the stack for better cache locality.  Currently
tg3, bnx2, and bnx2x have been converted to use this new interface.

Eric also extended our RED packet scheduler to support Adaptive RED
wherein the random-drop/tail-drop thresholds are adjusted dynamically
in response to traffic.

Jiri Pirko has introduced a new "teaming" network device which is
intended to be a more cleanly designed, scalable, and simpler
replacement for the bonding driver.  Currently round-robin and
active-backup modes are implemented.

Netlink socket dumping is now supported for UDP and AF_UNIX sockets
thanks to Pavel Emelyanov.  For AF_UNIX sockets we report the peers as
well as the pending connection IDs.  The reporting of socket memory
usage is also now more complete.

Socket memory pressure can now be enforced on a per-cgroup level,
from Glauber Costa.

As is usually the case the majority of this pull is a boatload of
driver updates.

Please pull, thanks a lot!

The following changes since commit 07d106d0a33d6063d2061305903deb02489eba20:

  vfs: fix up ENOIOCTLCMD error handling (2012-01-05 15:40:12 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next master

Aarthi Thiruvengadam (4):
      ath6kl: add support for WPS
      ath6kl: fix missing copy of action frame contents
      ath6kl: Fix target minimum length requirement for WMI_SEND_PROBE_RESPONSE_CMDID
      ath6kl: support for P2P mgmt operations on station interface

Ajit Khaparde (6):
      be2net: update some counters to display via ethtool
      be2net: workaround to fix a bug in BE
      be2net: Add support for Skyhawk cards
      be2net: fix be_vlan_add/rem_vid
      be2net: fix range check for set_qos for a VF
      be2net: query link status in be_open()

Alan Cox (1):
      rt2800: Add support for the Fujitsu Stylistic Q550

Alexander Duyck (1):
      ixgbevf: Fix register defines to correctly handle complex expressions

Alexander Guller (1):
      mlx4_en: nullify cached multicast address list after cleanup

Alexander Simon (3):
      mac80211: Add HT helper functions
      nl80211: Parse channel type attribute in an ibss join request
      mac80211: Add HT operation modes for IBSS

Alexey Dobriyan (2):
      xfrm: optimize ipv4 selector matching
      net: remove ipv6_addr_copy()

Allan Stephens (23):
      tipc: Enable use by containers having their own network namespace
      tipc: Register new media using pre-compiled structure
      tipc: Optimize detection of duplicate media registration
      tipc: Eliminate duplication of media structures
      tipc: Streamline media registration error checking
      tipc: Improve handling of media address printing errors
      tipc: Add new address conversion routines for Ethernet media
      tipc: Hide media-specific addressing details from generic bearer code
      tipc: Ignore neighbor discovery messages containing invalid address
      tipc: Allow run-time alteration of default link settings
      tipc: Revise comment justifying release of configuration spinlock
      tipc: Minor optimization to deactivation of Ethernet media suppot
      tipc: Do timely cleanup of disabled Ethernet bearer resources
      tipc: Eliminate useless memset operations in Ethernet media support
      tipc: Minor correction to TIPC module unloading
      tipc: Eliminate useless check when network address is assigned
      tipc: Eliminate dynamic allocation of broadcast link data structures
      tipc: Ensure broadcast link spinlock is held when updating node map
      tipc: Handle broadcast attempt when no neighboring nodes exist
      tipc: Minor optimization of broadcast link transmit queue statistic
      tipc: Flush unsent broadcast messages when contact with last node is lost
      tipc: Ignore broadcast acknowledgements that are out-of-range
      tipc: Allow use of buf_seqno() helper routine by unicast links

Alwin Beukers (6):
      brcm80211: cleanup defines in main.c
      brcm80211: removed duplicate defines
      brcm80211: smac: don't modify sta parameters when adding sta
      brcm80211: smac: combine promiscuous mode functionality
      brcm80211: smac: fix channel frequency
      brcm80211: smac: added support for mac80211 filter flags

Amir Vadai (2):
      net/mlx4_en: adding loopback support
      net/mlx4_en: bug fix for the case of vlan id 0 and UP 0

Amitkumar Karwar (10):
      mwifiex: enable SDIO multiport aggregation
      mwifiex: remove unnecessary free_priv handler
      mwifiex: release bss structure returned by cfg80211_inform_bss()
      mwifiex: failure case handling for PCIe events
      mwifiex: do not advertise custom regulatory domain capability
      mwifiex: remove cfg_workqueue
      mwifiex: cleanup work in scan.c
      mwifiex: remove redundant band config code
      mwifiex: use IEEE80211_HT_PARAM_CHA_SEC_* macros
      mwifiex: fix issues in band configuration code

Andre Guedes (7):
      Bluetooth: Create hci_do_inquiry()
      Bluetooth: Create hci_cancel_inquiry()
      Bluetooth: Periodic Inquiry and Discovery
      Bluetooth: Rename mgmt_inquiry_failed()
      Bluetooth: mgmt_stop_discovery_failed()
      Bluetooth: Add dev_flags to struct hci_dev
      Bluetooth: LE Set Scan Parameter Command

Andrei Emeltchenko (49):
      Bluetooth: EFS: l2cap extended feature mask update
      Bluetooth: EFS: add enable_hs kernel param
      Bluetooth: convert flushable variable to flag in l2cap chan
      Bluetooth: convert force_reliable variable to flag in l2cap chan
      Bluetooth: convert force_active variable to flag in l2cap chan
      Bluetooth: convert role_switch variable to flag in l2cap chan
      Bluetooth: clean up spaces in L2CAP header
      Bluetooth: EWS: extended window size option support
      Bluetooth: EWS: adds ext control field bit mask
      Bluetooth: EWS: rewrite handling Supervisory (S) bits
      Bluetooth: EWS: rewrite handling SAR bits
      Bluetooth: EWS: rewrite reqseq calculation
      Bluetooth: EWS: rewrite L2CAP ERTM txseq calculation
      Bluetooth: EWS: rewrite check frame type function
      Bluetooth: EWS: rewrite handling FINAL (F) bit
      Bluetooth: EWS: rewrite handling POLL (P) bit
      Bluetooth: EWS: recalculate L2CAP header size
      Bluetooth: EWS: define L2CAP header sizes
      Bluetooth: EFS: definitions and headers
      Bluetooth: EFS: assign default values in chan add
      Bluetooth: EFS: add efs option in L2CAP conf req
      Bluetooth: AMP: read local amp info HCI command
      Bluetooth: EWS: handling different Control fields
      Bluetooth: EWS: support extended seq numbers
      Bluetooth: EWS: remove magic numbers in l2cap
      Bluetooth: EWS: fix max_pdu calculation
      Bluetooth: EFS: parse L2CAP config request
      Bluetooth: EFS: implement L2CAP config pending state
      Bluetooth: remove magic offset and size
      Bluetooth: correct debug output
      Bluetooth: Initialize tx_win_max for fixed channel
      Bluetooth: Define HCI reasons instead of magic number
      Bluetooth: EFS: parse L2CAP config response
      Bluetooth: Move scope of kernel parameter enable_hs
      Bluetooth: Do not set HCI_RAW when HS enabled
      Bluetooth: Allow to set AMP type for virtual HCI
      Bluetooth: making enable_hs independent from L2CAP
      Bluetooth: Use queue in the device list
      Bluetooth: Add HCI Read Flow Control Mode function
      Bluetooth: remove old code
      Bluetooth: Remove magic bluetooth version numbers
      Bluetooth: trivial: correct check for LMP version
      Bluetooth: Add HCI Read Data Block Size function
      Bluetooth: Simplify num_comp_pkts_evt function
      Bluetooth: Split ctrl init to BREDR and AMP parts
      Bluetooth: Initialize default flow control mode
      Bluetooth: Check for flow control mode
      Bluetooth: Clean up magic pointers
      Bluetooth: Remove magic numbers from le scan cmd

Andres Salomon (1):
      libertas: clean up scan thread handling

Andy Fleming (1):
      fsl_pq_mdio: Clean up tbi address configuration

Antonio Quartulli (8):
      batman-adv: tt_global_del_orig() has to print the correct message
      batman-adv: use orig_hash_find() instead of get_orig_node() in TT code
      batman-adv: fixed hash functions type to uint32_t instead of int
      batman-adv: linearise the tt_response skb only if needed
      batman-adv: check for tt_reponse packet real length
      batman-adv: create a common substructure for tt_global/local_entry
      batman-adv: generalise tt_local_reset_flags()
      batman-adv: format multi-line if in the correct way

Arend van Spriel (60):
      brcm80211: smac: drop "40MHz intolerant" flag from HT capability info
      brcm80211: smac: remove obsolete srom variables from n-phy
      brcm80211: smac: avoid sprom endianess conversions for crc8 check
      brcm80211: smac: some local function made static in main.c
      brcm80211: smac: remove phy api bypass in rate.h
      brcm80211: util: move brcmu_pktfrombuf() function to brcmfmac
      brcm80211: util: remove function brcmu_format_hex() from brcmutil
      brcm80211: fmac: use sk_buff list for handling frames in receive path
      brcm80211: smac: rename buffer endianess conversion functions
      brcm80211: smac: use sk_buff list for handling frames in receive path
      brcm80211: smac: change buffer endianess convert function interface
      brcm80211: smac: fix endianess issue for OTP memory access
      brcm80211: smac: remove code under unused macro definitions
      brcm80211: smac: replace own access category definitions with mac80211 enum
      brcm80211: smac: remove duplicate definition of D11_PHY_HDR_LEN
      brcm80211: smac: remove usage of brcmu_pkttotlen
      brcm80211: util: use sk_buff_head in precedence queue functions
      brcm80211: util: move brcmu_pkttotlen() function to brcmfmac
      brcm80211: util: remove pointer traversal from brcmu_pkt_buf_free_skb
      brcm80211: fmac: add function to free the glom skb queue
      brcm80211: fmac: cleanup receive path using proper skb_queue functions
      brcm80211: smac: remove skb next pointer usage from the driver
      brcm80211: fmac: separate receiving skb chain from other receive path
      brcm80211: fmac: remove width parameter from brcmf_sdioh_request_buffer
      brcm80211: fmac: simplify the brcmf_sdioh_request_buffer() function
      brcm80211: fmac: remove alignment check from brcmf_sdioh_request_buffer()
      brcm80211: fmac: rename wait queue name to match using function
      bcma: add set/mask macros for 16-bit register access
      bcma: use static keyword for inline function declaration in bcma.h
      brcm80211: smac: remove unused fields from struct si_pub definition
      brcm80211: smac: move fields from struct si_pub to struct si_info
      brcm80211: smac: use inline access functions for struct si_pub fields
      brcm80211: smac: change from pci device driver to bcma device driver
      brcm80211: smac: change attach interfaces in main.c for bcma support
      brcm80211: smac: rename struct si_info field pbus to pcibus
      brcm80211: smac: change ai_attach interface taking a bcma_bus object
      brcm80211: smac: remove enumeration rom parsing function
      brcm80211: smac: use bcma core register access functions for 802.11 core
      brcm80211: smac: use DMA-API calls for descriptor allocations
      brcm80211: smac: use bcma function for register access in dma.c
      brcm80211: smac: use bcma functions for register access in phy code
      brcm80211: smac: remove SI_FAST() macro usage
      brcm80211: smac: replace ai_corereg() function with ai_cc_reg()
      brcm80211: smac: remove unused functions and/or prototypes
      brcm80211: smac: use bcma core control functions
      brcm80211: smac: use bcma core access functions in nicpci.c
      brcm80211: smac: change ai_findcoreidx() to ai_findcore()
      brcm80211: smac: use bcma core access functions in otp.c
      brcm80211: smac: use bcma core access function in srom.c
      brcm80211: smac: use bcma core access functions in pmu.c
      brcm80211: smac: use bcma core access functions in aiutils.c
      brcm80211: smac: remove register access macro definitions
      brcm80211: smac: remove empty or unused functions from pmu.c
      brcm80211: smac: INTROFF/INTRESTORE macros removed
      brcm80211: smac: remove interrupt disable callback functionality
      brcm80211: smac: remove ai_switch_core() function
      brcm80211: smac: remove mapped core related function from aiutils.c
      brcm80211: smac: cleanup si_info structure definition
      brcm80211: smac: cleanup buscore handling in aiutils.c
      brcm80211: smac: register with bcma for specific 802.11 core revisions

Ariel Elior (3):
      bnx2x: add fan failure event handling
      bnx2x: Remove on-stack napi struct variable
      bnx2x: support classification config query

Arik Nemtsov (14):
      wl12xx: keep beacon-filtering enabled during STA operation
      mac80211: support adding IV-room in the skb for CCMP keys
      mac80211: init rate-control for TDLS sta when supp-rates are known
      mac80211: make sure hw_key exists before checking its flags
      nl80211: Add probe response offload attribute
      nl80211: Pass probe response data to drivers
      mac80211: Save probe response data for bss
      ath6kl: indicate probe-resp offload support
      mac80211: dereference RCU protected probe_resp pointer correctly
      mac80211: don't indicate probe resp change in IBSS mode
      wl12xx: configure probe-resp template according to notification
      wl12xx: indicate probe-resp offloading support
      wl12xx: avoid bail out when probe-resp is not set by mac80211
      wl12xx: leave IV calculation to HW for CCMP

Avinash Patil (2):
      mwifiex: proper cleanup when RX multiport aggregation fails
      mwifiex: wakeup and stop multiple tx queues in net_device

Axel Lin (8):
      net: mv643xx_eth: fix build error
      net/irda: convert drivers/net/irda/* to use module_platform_driver()
      net/can: convert drivers/net/can/* to use module_platform_driver()
      net/ethernet: convert drivers/net/ethernet/* to use module_platform_driver()
      net: rfkill: convert net/rfkill/* to use module_platform_driver()
      NFC: pn533: Staticise pn533_data_exchange()
      dsa: Include linux/if_ether.h to fix build error
      mlx4: Add missing include of linux/slab.h

Barak Witkowski (5):
      bnx2x: add PFC statistics
      bnx2x: add fcoe statistics
      bnx2x, cnic: support DRV_INFO upon FW request
      bnx2x: fix typo in fcoe stats collection
      bnx2x: handle vpd data longer than 128 bytes

Baruch Siach (1):
      net: fsl_pq_mdio: fix non tbi phy access

Ben Dooks (4):
      eeprom_93cx6: Add data direction control.
      eeprom_93cx6: Add write support
      KSZ8851-SNL: Add support for EEPROM MAC address
      KSZ8851-SNL: Add ethtool support for EEPROM via eeprom_93cx6

Ben Greear (5):
      ath9k: Improve debugfs printout for stations.
      wireless: Support ht-capabilities over-rides.
      mac80211: Support ht-cap over-rides.
      mac80211: Make __check_htcap_disable static.
      mac80211: Remove WARN_ON in apply-ht-override logic.

Ben Hutchings (25):
      dsa: Change dsa_uses_{dsa, trailer}_tags() into inline functions
      dsa: Export functions from core to modules
      dsa: Combine core and tagging code
      mv88e6xxx: Combine mv88e6131 and mv88e612_61_65 drivers
      dsa: Define module author, description, license and aliases for drivers
      dsa: Allow core and drivers to be built as modules
      net: Use IS_ENABLED() in netdevice.h as appropriate
      bonding: Remove obsolete source file 'bond_ipv6.c'
      dsa: Remove unnecessary exports
      dsa: Move all definitions needed by drivers into <net/dsa.h>
      dsa: Move switch drivers to new directory drivers/net/dsa
      MAINTAINERS: Update sfc maintainers
      sfc: Remove device ID macros only used once
      ethtool: Clarify use of size field for ETHTOOL_GRXFHINDIR
      ethtool: Centralise validation of ETHTOOL_{G, S}RXFHINDIR parameters
      ethtool: Define and apply a default policy for RX flow hash indirection
      sfc: Use skb_fill_page_desc() to simplify passing of page buffers to GRO
      gianfar: Reject out-of-range RX NFC locations
      ethtool: Allow drivers to select RX NFC rule locations
      sfc: Change filter ID generation to satisfy priority semantics of RX NFC
      sfc: Use consistent types for filter IDs, indices and search depths
      sfc: Add support for retrieving and removing filters by ID
      sfc: Implement ethtool RX NFC rules API instead of n-tuple API
      sfc: Remove now-unused filter function
      ethtool: Remove ethtool_ops::set_rx_ntuple operation

Benjamin LaHaise (1):
      vlan: add 802.1q netpoll support

Bing Zhao (2):
      mwifiex: add support for Marvell sd8797 device
      Bluetooth: btusb: fix bInterval for high/super speed isochronous endpoints

Bjorn Helgaas (2):
      sunhme/PCI: use list_for_each_entry() for bus->devices traversal
      de4x5/PCI: use list_for_each_entry() for bus->devices traversal

Brian Gix (11):
      Bluetooth: Add HCI defines for User Passkey entry
      Bluetooth: Add MGMT opcodes for Passkey Entry
      Bluetooth: Add MGMT event for Passkey Entry
      Bluetooth: User Pairing Response restructuring
      Bluetooth: Differentiate LE User Pairing Responses
      Bluetooth: Add User Passkey Response handling
      Bluetooth: Add HCI User Passkey Req Evt handling
      Bluetooth: Cleanup blkcipher on SMP termination
      Bluetooth: Centralize SMP pairing failure handling
      Bluetooth: Add MITM mechanism to LE-SMP
      Bluetooth: Add SMP to User Passkey and Confirm

Bruce Allan (1):
      e1000e: hitting BUG_ON() from napi_enable

Carolyn Wyborny (1):
      igb: Add flow control advertising to ethtool setting.

Chilam Ng (1):
      ath6kl: make sure WLAN power save is enabled during suspend

Christian Auby (1):
      caif-hsi: Remove wake line modification when flushing FIFO

Christian Lamparter (4):
      mac80211: handle HT PHY BSS membership selector value correctly
      p54: use ieee80211_free_txskb
      carl9170: use ieee80211_free_txskb
      carl9170: move checksum and txseq into subfunctions

Chun-Yeow Yeoh (2):
      {nl,cfg,mac}80211: Allow Setting Multicast Rate in Mesh
      ath9k: Support RSN Mesh

Cyrill Gorcunov (1):
      net: unix -- Add missing module.h inclusion

Dai Shuibing (3):
      ath6kl: Add support for configuring SMS4 keys
      ath6kl: Allow SMS4 to be configured in AP mode
      ath6kl: Indicate WAPI IE from (Re)Association Request frame

Dan Carpenter (24):
      ath9k_hw: min_t() casts u32 to int
      rndis_wlan: add range check in del_key()
      iwmc3200wifi: add some more range checks
      mwifiex: remove unneeded kfree(NULL);
      mwifiex: remove an unneeded NULL check
      mwifiex: prevent corruption instead of just warning
      6LoWPAN: double free in lowpan_fragment_xmit()
      mac80211: use kfree_skb() instead of kfree()
      mac80211: memory leak in mesh_queue_preq()
      ath6kl: unlock if ath6kl_cfg80211_connect() fails
      ath6kl: use a larger buffer for debug output
      brcm80211: fmac: small memory leak on error
      openvswitch: small potential memory leak in ovs_vport_alloc()
      batman-adv: remove extra negation in gw_out_of_range()
      sock_diag: off by one checks
      mac80211: unlock on error path in ieee80211_ibss_join()
      vlan: add rtnl_dereference() annotations
      tcp_memcontrol: fix reversed if condition
      brcm80211: smac: precendence bug in wlc_phy_attach()
      wimax/i2400m: remove an unused variable
      NFC: double unlock in nfc_llcp_recv_connect()
      NFC: use kfree_skb() for sk_buffs
      usb: pegasus: cleanup a couple conditions
      iwlegacy: off by one in iwl3945_hw_build_tx_cmd_rate()

Daniel Halperin (1):
      skge: fix warning when CONFIG_PM is defined but not CONFIG_PM_SLEEP

Daniel Kuehn (1):
      ath9k: set ATH9K_PCI to y by default

Dave T√§ht (1):
      wireless: Treat IPv6 diffserv the same as IPv4 for 802.11e

David Herrmann (13):
      Bluetooth: hidp: Stop I/O on shutdown
      Bluetooth: Fix hci core device initialization
      Bluetooth: Rename sysfs un/register to add/del
      Bluetooth: Forward errors from hci_register_dev
      Bluetooth: Return proper error codes on rfcomm tty init
      Bluetooth: Replace rfcomm tty tasklet by workqueue
      Bluetooth: Ignore hci_unregister_dev return value
      Bluetooth: Make hci_unregister_dev return void
      Bluetooth: ath3k: Use GFP_KERNEL instead of GFP_ATOMIC
      Bluetooth: bcm203x: Fix race condition on disconnect
      Bluetooth: bcm203x: Use GFP_KERNEL in workqueue
      Bluetooth: bfusb: Fix error path on firmware load
      Bluetooth: hidp: Fix module reference cleanup

David Kilroy (1):
      orinoco: release BSS structures returned by cfg80211_inform_bss()

David Miller (17):
      neigh: Create mechanism for generic neigh private areas.
      neigh: Get rid of neigh_table->kmem_cachep
      neigh: Add infrastructure for allocating device neigh privates.
      neigh: Do not set tbl->entry_size in ipv4/ipv6 neigh tables.
      atm: clip: Convert over to neighbour_priv()
      neigh: Add device constructor/destructor capability.
      atm: clip: Use device neigh support on top of "arp_tbl".
      net: Rename dst_get_neighbour{, _raw} to dst_get_neighbour_noref{, _raw}.
      infiniband: addr: Consolidate code to fetch neighbour hardware address from dst.
      cxgb3: Rework t3_l2t_get to take a dst_entry instead of a neighbour.
      cxgb3: Handle NULL dst neighbour in cxgb3_offload.c
      infiniband: nes: Use dst's neighbour entry.
      infiniband: cxgb4: Consolidate 3 copies of the same operation into 1 helper function.
      libcxgbi: Handle dst_get_neighbour_noref() returning NULL.
      cxgb4i: Handle dst_get_neighbour_noref() returning NULL.
      infiniband: ipoib: Sanitize neighbour handling in ipoib_main.c
      ipv6: Remove optimistic DAD flag test in ipv6_add_addr()

David S. Miller (50):
      infiniband: Update net drivers for netdev_features_t changes.
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      ipv6: Use pr_warn() in ip6_fib.c
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'for_david' of git://git.open-mesh.org/linux-merge
      Merge git://git.kernel.org/.../davem/net
      airo: Fix array bounds warning when moving packet payload.
      ray_cs: Fix array bounds warnings.
      ifenslave: Fix unused variable warnings.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      can: Revert outdated cc770 driver patches.
      dccp: Evaluate ip_hdr() only once in dccp_v4_route_skb().
      net: Make ndo_neigh_destroy return void.
      dccp: Fix compile warning in probe code.
      niu: Remove redundant PHY ID test.
      niu: Add support for byte queue limits.
      niu: Fix typo in comment.
      Merge git://git.kernel.org/.../davem/net
      atm: clip: Remove code commented out since eternity.
      ipv6: Various cleanups in ip6_route.c
      ipv6: Various cleanups in route.c
      ipv6: Kill ndisc_get_neigh() inline helper.
      Merge branch 'for-upstream' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      ipv6: Make third arg to anycast_dst_alloc() bool.
      ipv6: Move xfrm_lookup() call down into icmp6_dst_alloc().
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/linux-merge
      net: Remove unused neighbour layer ops.
      ipv6: If neigh lookup fails during icmp6 dst allocation, propagate error.
      Merge git://git.kernel.org/.../davem/net
      batman-adv: Fix merge error.
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Revert "net: Remove unused neighbour layer ops."
      Merge git://git.kernel.org/.../davem/net
      netlink: Undo const marker in netlink_is_kernel().
      Merge branch 'nf-next' of git://1984.lsi.us.es/net-next
      unix: If we happen to find peer NULL when diag dumping, write zero.
      ipv6: Kill useless route tracing bits in net/ipv6/route.c
      Merge branch 'nf-next' of git://1984.lsi.us.es/net-next
      ipv6: Use universal hash for NDISC.
      ipv6: Create fast inline ipv6 neigh lookup just like ipv4.
      ipv6: Kill rt6i_dev and rt6i_expires defines.
      ipv6: Report TCP timetstamp info in cacheinfo just like ipv4 does.
      ipv6: Fix neigh lookup using NULL device.
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'tipc-Dec29-2011' of git://git.kernel.org/.../paulg/linux
      Merge git://git.kernel.org/.../davem/net
      Merge git://git.kernel.org/.../davem/net

Dinesh Kumar Sharma (1):
      Phonet: set the pipe handle using setsockopt

Djalal Harouni (1):
      drivers/iwlwifi: use dma_zalloc_coherent() for DMA allocation

Dmitry Kravkov (15):
      bnx2x: allow FCoE and DCB for 578xx
      bnx2x: use rx_queue index for skb_record_rx_queue()
      bnx2x: remove unused variable
      bnx2x: separate FCoE and iSCSI license initialization.
      bnx2x: propagate DCBX negotiation
      bnx2x: DCBX: use #define instead of magic
      bnx2x: simplify definition of RX_SGE_MASK_LEN and use it.
      bnx2x: remove unused #define
      bnx2x: prevent race in statistics flow
      bnx2x: update driver version to 1.70.35-0
      bnx2x: add endline at end of message
      bnx2x: handle iSCSI SD mode
      bnx2x: fix crash while ethtool -t
      bnx2x: properly initialize L5 features
      bnx2x: properly update skb when mtu > 1500

Dmitry Shmidt (1):
      wireless: Protect regdomain change by mutex

Dmitry TARNYAGIN (1):
      mac80211: Do not request FIF_BCN_PRBRESP_PROMISC for HW scan.

Dmitry Tarnyagin (1):
      cfg80211: merge in beacon ies of hidden bss.

Don Fry (23):
      iwlagn: remove unnecessary type for tracing operations
      iwlagn: simplify iwl_alloc_all
      iwlagn: move ucode_write_complete from priv to trans structure
      iwlagn: remove knowledge of ucode image location from upper layers
      iwlagn: push knowledge of ucode image lower down
      iwlagn: move ucode files out of the iwl_priv structure
      iwlagn: Remove dependence of iwl_priv from eeprom routines.
      iwlagn: move nvm_device_type from iwl_priv to iwl_trans
      iwlwifi: rename iwl-agn-ucode as iwl-ucode
      iwlwifi: replace iwl_priv reference with iwl_trans for ucode.
      iwlwifi: move ucode_type from iwl_priv to iwl_shared
      iwlwifi: move ucode notification from iwl_priv to iwl_shared
      iwlwifi: rename iwl-agn-ucode as iwl-ucode
      iwlwifi: replace iwl_priv reference with iwl_trans for ucode.
      iwlwifi: move ucode_type from iwl_priv to iwl_shared
      iwlwifi: move ucode notification from iwl_priv to iwl_shared
      iwlwifi: move eeprom pointer from iwl_priv to iwl_shared
      iwlwifi: move device_pointers from iwl_priv to iwl_shared
      iwlwifi: move calib_results list from iwl_priv to iwl_trans
      iwlwifi: move iwl_cfg from iwl_priv to iwl_shared
      iwlwifi: Add official names for new devices
      iwlwifi: create iwl_mac80211 unregister routine
      iwlwifi: remove most of the iwl_priv references from iwl-ucode.c

Don Skidmore (1):
      ixgbe: add support for new 82599 device.

Einar Lueck (1):
      qeth: recovery through asynchronous delivery

Eli Cohen (1):
      mlx4_core: resource tracking for HCA resources used by guests

Eliad Peller (84):
      wl12xx: replace wl->mac_addr with vif->addr
      wl12xx: start reworking the init sequence
      wl12xx: define wl12xx_vif
      wl12xx: move rate_set into wlvif
      wl12xx: move basic_rate into wlvif
      wl12xx: replace wl->bssid with vif->bss_conf.bssid
      wl12xx: move bss_type into wlvif
      wl12xx: remove set_bss_type field
      wl12xx: move p2p into wlvif
      wl12xx: move ssid and ssid_len into wlvif
      wl12xx: move probereq into wlvif
      wl12xx: move aid into wlvif
      wl12xx: move role_id into wlvif
      wl12xx: move dev_role_id into wlvif
      wl12xx: move sta_hlid into wlvif
      wl12xx: move ap_global_hlid and ap_bcast_hlid into wlvif
      wl12xx: move session_counter into wlvif
      wl12xx: move some logic into wl12xx_init_vif_data
      wl12xx: move dev_hlid into wlvif
      wl12xx: move beacon_int into wlvif
      wl12xx: move default_key into wlvif
      wl12xx: move pspoll_work into wlvif
      wl12xx: move ps_compl into wlvif
      wl12xx: move ps_poll_failures and psm_entry_retry into wlvif
      wl12xx: move rssi_thold and last_rssi_event into wlvif
      wl12xx: move ba fields into wlvif
      wl12xx: move ap_hlid_map into wlvif.ap
      wl12xx: move recorded_ap_keys into wlvif
      wl12xx: refactor fw init into a new function
      wl12xx: move last_tx_hlid into wlvif
      wl12xx: unify STA and AP tx_queue mechanism
      wl12xx: move some functions from remove_interface() to stop()
      wl12xx: move bitrate_masks into wlvif
      wl12xx: add vifs list
      wl12xx: support multiple vifs in the tx path
      wl12xx: configure sleep_policy according to active roles
      wl12xx: make event handling support multirole
      wl12xx: move tx_security_seq into wlvif
      wl12xx: rearm rx streaming per vif
      wl12xx: make WL1271_FLAG_STA_ASSOCIATED flag per-vif
      wl12xx: make WL1271_FLAG_IBSS_JOINED flag per-vif
      wl12xx: make WL1271_FLAG_AP_STARTED flag per-vif
      wl12xx: make WL1271_FLAG_PSM flag per-vif
      wl12xx: make WL1271_FLAG_STA_STATE_SENT flag per-vif
      wl12xx: make WL1271_FLAG_RX_STREAMING_STARTED flag per-vif
      wl12xx: make WL1271_FLAG_IF_INITIALIZED per-vif
      wl12xx: make WL1271_FLAG_PSPOLL_FAILURE flag per-vif
      wl12xx: make WL1271_FLAG_CS_PROGRESS flag per-vif
      wl12xx: add band field to wlvif
      wl12xx: add channel field to wlvif
      wl12xx: add power_level field to wlvif
      wl12xx: make op_config configure all vifs
      wl12xx: replace all remaining wl->vif references
      wl12xx: call stop() on recovery
      wl12xx: use dynamic rate policies
      wl12xx: add elp wakeup/sleep calls to add_interface
      wl12xx: use round-robin policy for tx
      wl12xx: handle injected packets
      wl12xx: couple role_start_dev with roc
      wl12xx: reconfigure rate policies on set_bitrate_mask
      wl12xx: add vifs_state debugfs key
      wl12xx: clear wl->vif on remove_interface
      wl12xx: use p2p rate index when the skb has the NO_CCK flag
      wl12xx: handle idle changes per-interface
      mac80211: call set_wmm_default only for valid vifs
      mac80211: set BSS_CHANGED_IDLE on vif reconfig
      mac80211: set carrier_on for ibss vifs only while joined
      mac80211: call skb_put() before copying the data (trivial)
      wl12xx: init CMD_TEMPL_KLV to sizeof(ieee80211_qos_hdr)
      wl12xx: don't explicitly check for unjoined ibss
      wl12xx: fix testmode test/interrogate commands
      wl12xx: remove redundant commands from plt init
      wl12xx: send testmode reply in wl1271_tm_cmd_interrogate
      mac80211: configure BSS_CHANGED_ARP_FILTER on reconfiguration
      mac80211: don't check sdata_running in vif notifier
      wl12xx: use ieee80211_free_txskb()
      wl12xx: implement change_interface
      wl12xx: remove redundant code from wl1271_op_conf_tx
      wl12xx: make WL1271_FLAG_IDLE flag per-vif
      wl12xx: flush packets before stopping dev role
      wl12xx: fix checking of started dev role
      wl12xx: stop device role on remove_interface
      wl12xx: check the actual vif operstate in wl1271_dev_notify
      mac80211: always clear SDATA_STATE_OFFCHANNEL flag

Emil Tantilov (4):
      ixgbe: fix LED blink logic to check for link
      ixgbe: fix incorrect PHY register reads
      ixgbe: add write flush in ixgbe_clock_out_i2c_byte()
      ixgbe: add support for new 82599 device id

Emmanuel Grumbach (30):
      iwlwifi: fix unused label in iwl_send_cmd_sync
      iwlwifi: remove the use of the QOS debug flag
      iwlwifi: add debug information on queue stop / wake
      iwlwifi: check the HW when a queue is stuck
      iwlwifi: improve the prints in the reclaim path
      iwlwifi: fix endianity issues in debug prints
      iwlwifi: tid_data is taken twice in iwl_trans_pcie_tx_agg_alloc
      iwlwifi: check the HW when a queue is stuck
      iwlwifi: improve the prints in the reclaim path
      iwlwifi: fix endianity issues in debug prints
      iwlwifi: tid_data is taken twice in iwl_trans_pcie_tx_agg_alloc
      iwlwifi: help to debug AGG SM inconsistencies
      iwlwifi: help to debug AGG SM inconsistencies
      iwlwifi: fix endianity issue in debug prints
      iwlwifi: don't count the tfds in HW queue any more
      iwlwifi: we can wake SW queues even when draining HW queues
      iwlwifi: don't rely on the wr / rd pointers in DELBA flow
      iwlwifi: tid_data logic move to upper layer - tx AGG stop
      iwlwifi: tid_data logic move to upper layer - tx AGG alloc
      iwlwifi: tid_data logic move to upper layer - tx AGG setup
      iwlwifi: tid_data logic move to upper layer - check_empty
      iwlwifi: tid_data logic move to upper layer - txqid
      iwlwifi: tid_data logic move to upper layer - seq_number
      iwlwifi: transport layer shouldn't access the AGG SM
      iwlwifi: tid_data moves to iwl_priv
      iwlwifi: reset the tid_data when a station is removed
      iwlwifi: add debug in Tx path in AGG flow
      iwlwifi: kill iwl_{start,stop}_tx_ba_trans_ready
      iwlwifi: don't accept Tx packets when draining HW queues
      iwlwifi: add missing documentation for iwl_shared

Eric Dumazet (65):
      net: better pcpu data alignment
      sch_choke: use skb_header_pointer()
      net: rename sk_clone to sk_clone_lock
      ipv4: reduce percpu needs for icmpmsg mibs
      ipv4: PKTINFO doesnt need dst reference
      ipv6: reduce percpu needs for icmpv6msg mibs
      neigh: new unresolved queue limits
      net: introduce build_skb()
      bnx2x: uses build_skb() in receive path
      net: use jump_label for netstamp_needed
      net: use jump_label to shortcut RPS if not setup
      bnx2: switch to build_skb() infrastructure
      tg3: switch to build_skb() infrastructure
      netfilter: use jump_label for nf_hooks
      atm: use SKB_TRUESIZE() in atm_guess_pdu2truesize()
      net: remove netdev_alloc_page and use __GFP_COLD
      net: treewide use of RCU_INIT_POINTER
      tcp: tcp_sendmsg() wrong access to sk_route_caps
      net: introduce skb_flow_dissect()
      net: use skb_flow_dissect() in __skb_get_rxhash()
      cls_flow: use skb_flow_dissect()
      sch_sfb: use skb_flow_dissect()
      net: dont call jump_label_dec from irq context
      net: optimize socket timestamping
      flow_dissector: use a 64bit load/store
      tcp: avoid frag allocation for small frames
      sch_sfq: use skb_flow_dissect()
      sch_choke: use skb_flow_dissect()
      tcp: inherit listener congestion control for passive cnx
      bnx2: Support for byte queue limits
      sfc: fix race in efx_enqueue_skb_tso()
      netem: fix build error on 32bit arches
      net: net_device flags is an unsigned int
      ipv4: use a 64bit load/store in output path
      tcp: drop SYN+FIN messages
      tcp: take care of misalignments
      tcp: tcp_sendmsg() page recycling
      tcp: fix tcp_trim_head()
      bql: fix CONFIG_XPS=n build
      tcp: remove TCP_OFF and TCP_PAGE macros
      sch_red: Adaptative RED AQM
      sch_red: generalize accurate MAX_P support to RED/GRED/CHOKE
      net: use IS_ENABLED(CONFIG_IPV6)
      net: fix build error if CONFIG_CGROUPS=n
      rtnetlink: rtnl_link_register() sanity test
      vlan: static functions
      cls_flow: remove one dynamic array
      net: ping: remove some sparse errors
      inet: remove rcu protection on tw_net
      sch_gred: prefer GFP_KERNEL allocations
      netfilter: nf_conntrack: use atomic64 for accounting counters
      net: two vzalloc() cleanups
      sch_sfq: rehash queues in perturb timer
      sch_hfsc: report backlog information
      rfs: better sizing of dev_flow_table
      sch_tbf: report backlog information
      netem: fix classful handling
      sch_sfq: dont put new flow at the end of flows
      sch_qfq: accurate wsum handling
      net_sched: qdisc_alloc_handle() can be too slow
      net_sched: sfq: fix mem alloc error recovery
      net_sched: sfq: always randomize hash perturbation
      igb: Add support for byte queue limits.
      net_sched: sfq: extend limits
      net_sched: red: split red_parms into parms and vars

Erwan Bracq (1):
      caif-spi: Bugfix for dump upon device removal

Eugenia Emantayev (3):
      mlx4: Traffic steering management support for SRIOV
      mlx4: Ethernet port management modifications
      mlx4_en: Allow communication between functions on same host

Eyal Shapira (5):
      wl12xx: fix SDIO suspend/resume
      mac80211: add recalc PS in ieee80211_reconfig()
      wl12xx: minor fix in sched_scan_ssid_list
      wl12xx: fix sched scan of DFS channels
      wl12xx: mark no sched scan only after FW event

Felipe Balbi (8):
      wl12xx: add an sdio glue struct to keep wl and device side-by-side
      wl12xx: add an spi glue struct to keep wl and device side-by-side
      wl12xx: add a platform device to the sdio module
      wl12xx: add a platform device to the spi module
      wl12xx: add platform driver to the core module
      wl12xx: move common init code from bus modules to main
      wl12xx: mark some symbols static
      wl12xx: drop unneeded plat_dev

Felix Fietkau (15):
      mac80211: call ieee80211_recalc_idle() after sending packets
      mac80211: do not pass AP VLAN vif pointers to drivers
      ath9k: always issue a full hw reset after waking up from full-sleep mode
      ath9k: rework power state handling
      ath9k: only drop packets in drv_flush when asked to
      ath9k: cancel all workqueue activity when going idle
      ath9k: make two mci related functions static
      ath9k: change maximum software retransmission handling
      ath9k: reduce the number of unnecessary BAR tx packets
      ath9k: reduce indentation level in a few places
      ath9k: remove bogus sequence number increment
      ath9k: simplify tx locking
      ath9k: avoid retransmitting aggregation frames that a BAR was sent for
      ath9k_hw: make bluetooth coexistence support optional at compile time
      ath9k: fix tx locking issues

Florian Fainelli (9):
      r6040: use an unique MDIO bus name
      r6040: remove unused variables and definitions
      r6040: define more MCR0 register bits
      r6040: use MAC_RST bit definition with MCR1 read/writes
      r6040: use definitions for MAC_SM register read/writes
      r6040: use __aligned(size)
      r6040: place comments before code
      e1000: unmap ce4100_gbe_mdio_base_virt in e1000_remove
      e1000: cleanup CE4100 MDIO registers access

Florian Westphal (4):
      net: ipv4: export fib_lookup and fib_table_lookup
      netfilter: add ipv4 reverse path filter match
      ipv6: add ip6_route_lookup
      netfilter: add ipv6 reverse path filter match

Frank Blaschka (1):
      qeth: improve recovery during resource shortage

Franky Lin (77):
      brcm80211: fmac: allow wd timer to be disabled when bus down
      brcm80211: fmac: use brcmf_del_if for all net devices
      brcm80211: fmac: use brcmf_add_if for all net devices
      brcm80211: fmac: store brcmf_if in net device private data
      brcm80211: fmac: remove state from brcmf_if in fullmac
      brcm80211: fmac: remove unnecessary 4329 chip specific code
      brcm80211: fmac: move chip recognition function to sdio_chip.c
      brcm80211: fmac: move bus core prep code to sdio_chip.c
      brcm80211: fmac: abstract chip buscore setup function
      brcm80211: fmac: move core disable function to sdio_chip.c
      brcm80211: fmac: disable dongle arm core in bus core setup function
      brcm80211: fmac: move dongle gpio reset code to chip attach function
      brcm80211: fmac: remove duplicate regiter set in chip attach path
      brcm80211: fmac: chip attach code flow clean up
      brcm80211: fmac: abstract chip iscoreup function
      brcm80211: fmac: abstract chip core revision function
      brcm80211: fmac: move chip reset core function to sdio_chip.c
      brcm80211: fmac: move chip detach function to sdio_chip.c
      brcm80211: fmac: move chip drive strength related code to sdio_chip.c
      brcm80211: fmac: replace private SB macros with ssb_regs version
      brcm80211: fmac: optimize chip core info management
      brcm80211: fmac: add iscoreup function for bcm4330 chip
      brcm80211: fmac: add corerev function for bcm4330 chip
      brcm80211: fmac: add coredisable function for bcm4330 chip
      brcm80211: fmac: add resetcore function for bcm4330 chip
      brcm80211: fmac: remove id retrieve code
      brcm80211: fmac: remove PCMCIA core related code
      brcm80211: fmac: release bss struct returned from cfg80211_inform_bss
      brcm80211: fmac: change firmware/nvram name to be more generic
      brcm80211: fmac: discard packet received when net device not registered
      brcm80211: fmac: move module init/exit to sdio layer
      brcm80211: fmac: remove function brcmf_c_init
      brcm80211: fmac: remove unused parameter of brcmf_sdbrcm_probe
      brcm80211: fmac: rename structure brcmf_bus to brcmf_sdio
      brcm80211: fmac: introduce common bus interface struct brcmf_bus
      brcm80211: fmac: move busstate to struct brcmf_bus
      brcm80211: fmac: stop using brcmf_pub in brcmf_sdbrcm_bus_watchdog
      brcm80211: fmac: change function bus_rxctl parameter
      brcm80211: fmac: change function bus_txctl parameter
      brcm80211: fmac: change function bus_txdata parameter
      brcm80211: fmac: change function bus_init parameter
      brcm80211: fmac: remove function brcmf_bus_get_device
      brcm80211: fmac: change function bus_stop parameter
      brcm80211: fmac: save bus interface structure in function 2 device
      brcm80211: fmac: fix firmware shared structures version
      brcm80211: fmac: add bcm4330 support
      brcm80211: fmac: remove drive strength code for unsupported chips
      brcm80211: fmac: unify common layer driver data structure
      brcm80211: fmac: remove oneline proto block functions
      brcm80211: fmac: register a dummy irq handler for SDIO function 2
      brcm80211: fmac: change function add_if parameter
      brcm80211: fmac: change function bus_start parameter
      brcm80211: fmac: change function brcmf_detach parameter
      brcm80211: fmac: change function txflowcontrol parameter
      brcm80211: fmac: change function txcomplete parameter
      brcm80211: fmac: change function brcmf_c_prec_enq parameter
      brcm80211: fmac: change function rx_frame parameter
      brcm80211: fmac: change function proto_hdrpull parameter
      brcm80211: fmac: move sdio used statistics to struct brcmf_sdio
      brcm80211: fmac: move maxctl to struct brcmf_bus
      brcm80211: fmac: move driver up status to struct brcmf_bus
      brcm80211: fmac: remove duplicate statistics from driver data structure
      brcm80211: fmac: move dongle statistics to struct brcmf_bus
      brcm80211: fmac: move packet realloc stats to struct brcmf_bus
      brcm80211: fmac: move tx flow ctrl flag to bus layer
      brcm80211: fmac: stop referencing brcmf_pub in bus layer
      brcm80211: fmac: stop referencing brcmf_sdio in common layer
      brcm80211: fmac: move sdio related macros to sdio_host.h
      brcm80211: fmac: abstract bus_stop interface function pointer
      brcm80211: fmac: move common layer bus interface context to dhd_bus.h
      brcm80211: fmac: abstract bus_init interface function pointer
      brcm80211: fmac: abstract bus_txdata interface function pointer
      brcm80211: fmac: abstract ctrl frames interface function pointers
      brcm80211: fmac: move debug level macros to dhd_dbg.h
      brcm80211: fmac: move idle macros to dhd_sdio.c
      brcm80211: fmac: exclude unnecessary header files
      brcm80211: fmac: add Kconfig option for SDIO bus support

Frederic LAMBERT (1):
      phy: Micrel KS8995MA 5-ports 10/100 managed Ethernet switch support added

George (1):
      rtlwifi: rtl8192cu: Allow retries for USB I/O

Gertjan van Wingerde (5):
      rt2x00: Identify rt2800usb chipsets.
      rt2x00: Whitespace cleanup.
      rt2x00: Convert big if-statements to switch-statements.
      rt2x00: RT3593 is also applicable to USB.
      rt2x00: Change RF3853 to RF3053.

Giuseppe CAVALLARO (2):
      stmmac: add the experimental PCI support
      stmmac: update the driver's documentation (Dec-2011)

Giuseppe Cavallaro (1):
      stmmac: fix missing module license in the main.

Glauber Costa (13):
      Basic kernel memory functionality for the Memory Controller
      foundations of per-cgroup memory pressure controlling.
      socket: initial cgroup code.
      tcp memory pressure controls
      per-netns ipv4 sysctl_tcp_mem
      tcp buffer limitation: per-cgroup limit
      Display current tcp memory allocation in kmem cgroup
      Display current tcp failcnt in kmem cgroup
      Display maximum tcp memory allocation in kmem cgroup
      Move limit definitions outside CONFIG_INET
      net: fix sleeping while atomic problem in sock mem_cgroup.
      net: fix compilation with !CONFIG_NET
      Partial revert "Basic kernel memory functionality for the Memory Controller"

Greg Dietsche (9):
      iwlegacy: change IL_WARN to D_HT in il4965_tx_agg_start
      iwlegacy: change IL_ERR to D_HT in iwl4965_rs_tl_turn_on_agg_for_tid
      iwlegacy: 4965: remove vif null check in request_scan
      iwlegacy: 4965-rs: remove null check on sta in il4965_rs_tx_status
      iwlegacy: 4965-rs: remove unnecessary null check for sta and lq_sta
      iwlegacy: 4965-rs: il4965_rs_alloc_sta: remove lq_sta local var
      iwlegacy: 4965-rs: don't return rate from il4965_rs_update_rate_tbl
      iwlegacy: 4965-rs: cleanup il4965_rs_sta_dbgfs_rate_scale_data_read
      iwlegacy: debugfs_ops should depend on CONFIG_IWLEGACY_DEBUGFS

Greg Rose (1):
      ixgbe: Remove function prototype for non-existent function

Gustavo F. Padovan (60):
      Bluetooth: use list_for_each_entry() in hidp
      Bluetooth: prioritize the interrupt channel in hidp
      Bluetooth: Trasmit interrupt channel messages first
      Bluetooth: Fix input device registration
      Bluetooth: Remove wrong error check
      Bluetooth: Uses test_and_clear_bit() when possible
      Bluetooth: Delay session allocation in hidp
      Bluetooth: Rename hidp_find_connection()
      Bluetooth: Fix permission of enable_le param
      Bluetooth: return proper error if sock_queue_rcv_skb() fails
      Bluetooth: Add missing cmd_status() in mgmt
      Bluetooth: Use list_for_each_entry() in mgmt
      Bluetooth: Fix mgmt interaction with userspace
      Bluetooth: Fix missing cmd_status in mgmt
      Bluetooth: small styles clean ups to l2cap_core.c
      Bluetooth: Fix hidp_get_connection()
      Bluetooth: Rename l2cap_check_security()
      Bluetooth: Allow L2CAP to increase the security level
      Bluetooth: Only set ack_timer if we didn't send and ack
      Bluetooth: Add user readable debug for state changes
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth
      Bluetooth: remove struct hci_chan_hash
      Bluetooth: remove lock from struct conn_hash
      Bluetooth: Initialize LE connection count
      Bluetooth: Use chan instead of l2cap_pi macro
      Bluetooth: Use list_for_each_entry in hci_conn_hash_flush()
      Bluetooth: make hci_conn_enter_sniff_mode static
      Bluetooth: Replace spin_lock by mutex in hci_dev
      Bluetooth: Use delayed_work for connection timeout
      Bluetooth: Use delayed work for advertisiment cache timeout
      Bluetooth: hci_conn_auto_accept() doesn't need locking
      Bluetooth: Move L2CAP timers to workqueue
      Bluetooth: Don't use spin_lock socket lock anymore
      Bluetooth: Remove sk_backlog usage from L2CAP
      Bluetooth: move hci_task_lock to mutex
      Bluetooth: convert chan_lock to mutex
      Bluetooth: Use RCU to manipulate chan_list
      Bluetooth: convert conn hash to RCU
      Bluetooth: Don't disable tasklets to call hdev->notify()
      Bluetooth: Move command task to workqueue
      Bluetooth: convert tx_task to workqueue
      Bluetooth: convert info timer to delayed_work
      Bluetooth: invert locking order in connect path
      Bluetooth: Change l2cap chan_list to use RCU
      Bluetooth: move power_off to system workqueue
      Bluetooth: Use new alloc_workqueue()
      Bluetooth: Remove work_add and work_del from hci_sysfs
      Bluetooth: Use system workqueue to schedule power_on
      Bluetooth: Add ProFUSION's copyright
      Merge git://git.kernel.org/.../padovan/bluetooth
      Bluetooth: Move l2cap_{set,clear}_timer to l2cap.h
      Bluetooth: convert security timer to delayed_work
      Bluetooth: Rename info_work to info_timer
      Bluetooth: fix bt_accept_dequeue() to work in process context
      Bluetooth: Remove l2cap priority from inside RFCOMM.
      Bluetooth: add debug output to l2cap_ack_timeout()
      Bluetooth: Remove lock from inquiry_cache
      Bluetooth: remove *_bh usage from hci_dev_list and hci_cb_list
      Bluetooth: Don't disable interrupt when locking the queue
      Bluetooth: Fix a compile warning in RFCOMM

Guy Eilam (1):
      wl12xx: set scan probe requests rate according to the no_cck flag

Hagen Paul Pfeifer (3):
      netem: rate extension
      netem: add cell concept to simulate special MAC behavior
      net_sched: Bug in netem reordering

Heiko Carstens (1):
      net: calxeda xgmac ethernet driver add missing HAS_IOMEM dependency

Helmut Schaa (11):
      mac80211: Also report the STA's TDLS flag via nl80211
      mac80211: Check rate->idx before rate->count
      mac80211: Get rid of search loop for rate group index
      rt2x00: Pass BlockAck and BlackAckReq frames to mac80211 in monitor mode
      ieee80211: Introduce ieee80211_is_first_frag
      mac80211: Make use of ieee80211_is_* functions in tx status path
      rt2x00: Make use of ieee80211_free_txskb in tx path
      mac80211: Use appropriate TID for sending BAR, ADDBA and DELBA frames
      mac80211: Keep skb->piority for relayed frames in AP mode
      mac80211: Remove superfluous ieee80211_rx_h_remove_qos_control
      rt2x00: Mark active channel's survey data as "in use"

Hemant Gupta (1):
      Bluetooth: Incorrect address while storing LTK.

Herbert Xu (6):
      ipv4: Remove all uses of LL_ALLOCATED_SPACE
      ipv6: Remove all uses of LL_ALLOCATED_SPACE
      net: Remove all uses of LL_ALLOCATED_SPACE
      net: Remove LL_ALLOCATED_SPACE
      packet: Add needed_tailroom to packet_sendmsg_spkt
      ip_gre: Set needed_headroom dynamically again

Hiroaki SHIMODA (1):
      tg3: Fix advertisement handling

Hsu, Kenny (12):
      iwlwifi: add tm commands for indirect register access
      iwlwifi: add tm commands for indirect register access
      iwlwifi: add tm commands for sram reading by dumpit
      iwlwifi: add generic chunk size of tm dumpit packet
      iwlwifi: add WOWLAN uCode loading support by testmode
      iwlwifi: add tm commands for sram reading by dumpit
      iwlwifi: add generic chunk size of tm dumpit packet
      iwlwifi: add WOWLAN uCode loading support by testmode
      iwlwifi: add uCode version information support by testmode
      iwlwifi: hide kernel option IWLWIFI_DEVICE_SVTOOL
      iwlwifi: add device ID information support by testmode
      iwlwifi: add IO function for continuous write of target memory

Ian Campbell (2):
      net: only use a single page of slop in MAX_SKB_FRAGS
      net: pack skb_shared_info more efficiently

Igor Maravic (3):
      net: Fix skb_update_prio RCU usage.
      forcedeath: Fix bql support for forcedeath
      ipv4: arp: Cleanup in arp.c

Igor Maraviƒá (4):
      net:core: use IS_ENABLED
      net:x25: use IS_ENABLED
      net:netfilter: use IS_ENABLED
      net:bridge: use IS_ENABLED

Ilan Elias (7):
      NFC: Update names and structs to NCI spec 1.0 d18
      NFC: Removal of unused operations for NCI spec 1.0 d18
      NFC: Check if NCI data flow control is used
      NFC: Fix indentation in nci.h file
      NFC: Update names and structs to NCI spec 1.0 d22
      NFC: Handle error during NCI data exchange
      NFC: Export a new attribute nfcid1 in target info

Ivan Vecera (1):
      be2net: netpoll support

Jack Morgenstein (12):
      mlx4_core: initial header-file changes for SRIOV support
      mlx4: Extanding port_mask functionality
      mlx4_core: Add "native" argument to mlx4_cmd and its callers (where needed)
      mlx4_core: Reduce number of PD bits to 17
      mlx4_core: srq modifications for SRIOV
      mlx4_core: qp modifications for SRIOV
      mlx4_core: cq modifications for SRIOV
      mlx4_core: mtt modifications for SRIOV
      mlx4_core: Add wrapper functions and comm channel and slave event support to EQs
      mlx4_ib: disable SRIOV mode for IB ports (not yet supported)
      mlx4_core: adjust catas operation for SRIOV mode
      mlx4_core: Modify driver initialization flow to accommodate SRIOV for Ethernet

Jakub Kici≈Ñski (2):
      rt2800usb: Let rt2x00usb handle USB padding
      rt2x00usb: Zero USB padding before sending URB

Jan Engelhardt (4):
      netfilter: xtables: move ipt_ecn to xt_ecn
      netfilter: xtables: give xt_ecn its own name
      netfilter: xtables: collapse conditions in xt_ecn
      netfilter: provide config option to disable ancient procfs parts

Jason Wang (2):
      8139cp/8139too: do not read into reserved registers
      8139cp: properly config rx mode after resuming

Javier Cardona (2):
      mac80211: Avoid filling up mesh preq queue with redundant requests
      mac80211: simplify mesh frame queue mapping and QoS

Javier Martinez Canillas (2):
      net: phy: smsc: Move SMSC PHY constants to <linux/smscphy.h>
      net/smsc911x: Check if PHY is in operational mode before software reset

Jeff Kirsher (5):
      e1000e: Convert printks to pr_<level>
      igbvf: Convert printks to pr_<level>
      ixgbevf: Convert printks to pr_<level>
      igb: Convert printks to pr_<level>
      e1000e: Avoid wrong check on TX hang

Jesse Brandeburg (2):
      e1000e: convert to real ndo_set_rx_mode
      e1000: fix lockdep splat in shutdown handler

Jesse Gross (3):
      genetlink: Add rcu_dereference_genl and genl_dereference.
      ipv6: Add fragment reporting to ipv6_skip_exthdr().
      net: Add Open vSwitch kernel components.

Jesse Sung (1):
      Bluetooth: Add support for BCM20702A0 [0a5c:21e3]

Jiri Pirko (13):
      net: introduce ethernet teaming device
      team: Do not hold rcu_read_lock when running netlink cmds
      team: convert overall spinlock to mutex
      team: replicate options on register
      team: add fix_features
      team: avoid using variable-length array
      team: replace kmalloc+memcpy by kmemdup
      vlan: rename vlan_dev_info to vlan_dev_priv
      net: make vlan ndo_vlan_rx_[add/kill]_vid return error value
      net: introduce vlan_vid_[add/del] and use them instead of direct [add/kill]_vid ndo calls
      vlan: introduce vid list with reference counting
      vlan: introduce functions to do mass addition/deletion of vids by another device
      team: use vlan_vids_[addr/del]_by_dev

Jitendra Kalsaria (1):
      qla3xxx: Adding Maintainer.

Joe Perches (14):
      igb: Convert bare printk to pr_notice
      intel: Convert <FOO>_LENGTH_OF_ADDRESS to ETH_ALEN
      ethernet: Convert MAC_ADDR_LEN uses to ETH_ALEN
      ethernet: Convert ETHER_ADDR_LEN uses to ETH_ALEN
      bna: Convert MAC_ADDRLEN uses to ETH_ALEN
      amd8111e: Convert ETH_ADDR_LEN uses to ETH_ALEN
      ucc_geth: Convert ENET_NUM_OCTETS_PER_ADDRESS uses to ETH_ALEN
      brcmsmac: Use current logging styles
      iwl-debug: Shrink object by using dev_err and deduplicating formats
      nfc: Use standard logging styles
      nfc: Convert nfc_dbg to pr_debug
      nfc: Remove unused nfc_printk and nfc_<level> macros
      nfc: Remove function tracer like entry messages
      ath: Convert ath_dbg(bar, ATH_DBG_<FOO>, to ath_dbg(bar, FOO

Joerg Roedel (1):
      mlx4: Fix compile error when driver is comiled-in

Johan Hedberg (37):
      Bluetooth: Fix command complete/status for discovery commands
      Bluetooth: Set HCI_MGMT flag only in read_controller_info
      Bluetooth: Fix mgmt response when adapter goes down or is removed
      Bluetooth: Clean up logic in hci_cc_write_scan_enable
      Bluetooth: Add timeout field to mgmt_set_discoverable
      Bluetooth: Fix mgmt response when HCI_Write_Scan_Enable fails
      Bluetooth: Convert power off mechanism to use delayed_work
      Bluetooth: Remove redundant code from mgmt_block & mgmt_unblock
      Bluetooth: Fix response for mgmt_start_discovery when powered off
      Bluetooth: Update link key mgmt APIs to match latest spec.
      Bluetooth: Add address type fields to mgmt messages that need them
      Bluetooth: Pass full hci_dev struct to mgmt callbacks
      Bluetooth: Move pending management command list into struct hci_dev
      Bluetooth: Add missing hci_dev locking when calling mgmt functions
      Bluetooth: Fix cancel_delayed_work_sync usage with locks
      Bluetooth: Fix consistency with u16 integer type in mgmt pending_cmd
      Bluetooth: Remove redundant hci_dev comparisons in mgmt lookups
      Bluetooth: Add public/random LE address information to mgmt messages
      Bluetooth: Fix deadlock with mgmt_pair_device
      Bluetooth: Add proper response to mgmt_remove_keys command
      Bluetooth: Add status parameter to mgmt_disconnect response
      Bluetooth: Add address type to mgmt_pair_device
      Bluetooth: Fix mgmt_pair_device imediate error responses
      Bluetooth: Return success instead of EALREADY for mgmt commands
      Bluetooth: Create a unique mgmt error code hierarchy
      Bluetooth: Add missing cmd_complete for mgmt_load_link_keys
      Bluetooth: Pass all message parameters to mgmt_start_discovery
      Bluetooth: Update mgmt_read_info and related mgmt messages
      Bluetooth: Move mgmt_set_fast_connectable to the right location
      Bluetooth: Remove mgmt_set_service_cache
      Bluetooth: Move EIR and CoD update functions to a better position
      Bluetooth: Add timer for automatically disabling the service cache
      Bluetooth: Update ordering and opcodes of mgmt messages
      Bluetooth: Use correct struct for user_confirm_neg_reply
      Bluetooth: Add missing confirm_name field to mgmt_ev_device_found
      Bluetooth: Fix mgmt_(block,unblock)_device opcodes
      Bluetooth: Add missing mgmt_confirm_name command definition

Johannes Berg (87):
      iwlagn: update wowlan API
      iwlagn: use 6 Mbps rate for no-CCK scans
      mac80211: fix confusing parentheses
      mac80211: exit cooked monitor RX early if there are none
      nl80211: clean up genlmsg_end uses
      cfg80211: annotate cfg80211_inform_bss
      mac80211: preserve EOSP in QoS header
      net: add wireless TX status socket option
      mac80211: verify virtual interfaces in driver API
      mac80211: add helper to free TX skb
      mac80211: add support for control port protocol in AP mode
      nl80211: allow subscribing to unexpected class3 frames
      mac80211: support spurious class3 event
      nl80211: advertise device AP SME
      nl80211: add API to probe a client
      mac80211: support client probe
      cfg80211: allow registering to beacons
      mac80211: report OBSS beacons
      cfg80211: add event for unexpected 4addr frames
      mac80211: send unexpected 4addr event
      cfg80211/mac80211: allow management TX to not wait for ACK
      nl80211: advertise socket TX status capability
      mac80211: implement wifi TX status
      mac80211: simplify scan state machine
      mac80211/cfg80211: report monitor channel in wireless extensions
      wireless: move ieee80211chan2mhz macro
      nl80211: fix compiler warning
      iwlagn: add P2P NoA to probe responses
      iwlagn: fix NULL ptr deref when reprogramming sta w/o LQ
      iwlagn: use per-vif AC parameters
      iwlagn: explicitly program P2P QoS parameters
      iwlagn: convert remain-on-channel duration to TU
      iwlagn: don't always split remain-on-channel
      mac80211: fix warning in ieee80211_probe_client
      mac80211: remove crypto special case for auth frames
      mac80211: use skb list for fragments
      mac80211: move fragment flag adjustment
      mac80211: make TX LED handling independent of fragmentation
      mac80211: transmit fragment list to drivers
      mac80211: remove unused ASSOC_AP flag
      mac80211: minor cleanup to mesh state locking
      cfg80211: add flags for off-channel capabilities
      nl80211: make get_vlan logic more common
      cfg80211/mac80211: Revert "move information element parsing logic to cfg80211"
      cfg80211: work around a sparse issue
      mac80211: fix RCU warnings in mesh
      iwlagn: remove calibration knowledge
      iwlagn: dynamically allocate & reflect calibration data
      iwlagn: allow up to uCode API 6 for 6000 devices
      mac80211: fix TX warning
      mac80211: remove tracing config symbol
      iwlagn: remove calibration knowledge
      iwlagn: dynamically allocate & reflect calibration data
      iwlagn: allow up to uCode API 6 for 6000 devices
      mac80211: revert on-channel work optimisations
      iwlagn: fix HW crypto for TX-only keys
      iwlagn: remove TX_REPLY_LIMIT debug
      iwlagn: remove HC_DUMP debug
      iwlagn: remove MACDUMP debug
      iwlagn: make debug levels more readable
      iwlagn: remove TX_REPLY_LIMIT debug
      iwlagn: remove HC_DUMP debug
      iwlagn: remove MACDUMP debug
      iwlagn: make debug levels more readable
      mac80211: fix retransmit
      mac80211: accept public action frames with mismatched BSSID
      wireless: disable wext sysfs by default
      iwlagn: fix TID use bug
      iwlagn: use IWL_MAX_TID_COUNT for WoWLAN
      iwlagn: use IWL_MAX_TID_COUNT instead of TID_MAX_LOAD_COUNT
      nl80211: accept testmode dump with netdev
      nl80211: add TDLS peer flag to policy
      cfg80211: validate nl80211 station handling better
      mac80211: remove duplicate TDLS peer verification
      mac80211: use station mutex in configuration
      mac80211: refactor station state transitions
      mac80211: count authorized stations per BSS
      mac80211: make address arguments to sta_info_alloc const
      mac80211: delay IBSS station insertion
      mac80211: reduce station management complexity
      mac80211_hwsim: fix wmediumd_pid
      iwlwifi: remove unused AMPDU factor/density configuration
      iwlagn: remove iwlagn_build_addsta_hcmd
      mac80211: handle SMPS action frames
      iwlagn: add IRQ tracing
      iwlagn: finer-grained HT disable
      iwlagn: fix (remove) use of PAGE_SIZE

John Fastabend (4):
      ixgbe: DCBnl set_all, order of operations fix
      ixgbe: DCB: IEEE transitions may fail to reprogram hardware.
      net: netprio_cgroup: make net_prio_subsys static
      Revert "net: netprio_cgroup: make net_prio_subsys static"

John W. Linville (29):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next
      wireless: cleanup brcm80211 bits in drivers/net/wireless/Makefile
      brcmsmac: fix warning in _initvars_srom_pci
      libertas: release bss references and avoid warning from cfg80211_inform_bss
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://github.com/kvalo/ath6kl
      Merge branch 'for-linville' of git://github.com/sgruszka/iwlegacy
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux
      rtlwifi: squash warning in _usb_read_sync
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next
      wl12xx: silence tx_attr uninitialized warning in wl1271_tx_fill_hdr
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'wireless-next' of git://git.kernel.org/.../iwlwifi/iwlwifi
      b43: avoid calling bcma_* if CONFIG_B43_BCMA is not set
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      b43: mark some vars __maybe_unused in b43_nphy_pmu_spur_avoid
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'wireless-next' of git://git.kernel.org/.../iwlwifi/iwlwifi
      Merge branch 'for-linville' of git://github.com/kvalo/ath6kl
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      ath6kl: revert USB support
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jorge Boncompte [DTI2] (5):
      atm: br2684: Do not move counters backwards
      atm: clip: Don't move counters backwards
      atm: clip: move clip_devs check to clip_push
      atm: Introduce vcc_process_recv_queue
      atm: Allow MSG_PEEK for atm sockets

Josh Hunt (1):
      IPv6: Avoid taking write lock for /proc/net/ipv6_route

Joshua Kinard (1):
      net: meth: Add set_rx_mode hook to fix ICMPv6 neighbor discovery

Jouni Malinen (15):
      mac80211_hwsim: Claim support for TDLS
      ath9k: Advertise support for TDLS
      ieee80211: Define cipher suite selector for WPI-SMS4
      nl80211: Increase maximum NL80211_ATTR_KEY_SEQ length to 16
      ath6kl: Add endpoint_stats debugfs file
      ath6kl: Add debugfs file for target roam table
      ath6kl: Add debugfs files for roaming control
      ath6kl: Add debugfs control for keepalive and disconnection timeout
      ath6kl: Allow CCKM AKM and KRK to be configured
      ath6kl: Fix endpoint_stats debugfs buffer length calculation
      ath6kl: Report unique remain-on-channel cookie values
      ath6kl: Remove unused WMI crypto defines
      ath6kl: Fix key configuration to copy at most seq_len from seq
      ath6kl: Do not hide ath6kl_wmi_addkey_cmd() error values
      ath6kl: Use delayed key configuration for WAPI in AP mode

Julia Lawall (3):
      net/mac80211/debugfs.c: use kstrtoul, etc
      net/rfkill/core.c: use kstrtoul, etc
      net/rfkill/rfkill-gpio.c: introduce missing kfree

Jun Zhao (2):
      ipv4 : igmp : Delete useless parameter in ip_mc_add1_src()
      ipv6 : mcast : Delete useless parameter in ip6_mc_add1_src()

Jussi Kivilinna (6):
      rndis_wlan: release BSS structures returned by cfg80211_inform_bss()
      rndis_wlan: split getting current channel to separate function
      rndis_wlan: pass channel info to cfg80211_roamed()
      rndis_wlan: add missing __packed
      rndis_wlan: add reporting of PMKSA candidate events
      rndis_wlan: remove unused macro

Kalle Valo (76):
      ath6kl: remove unused parameters from struct wmi
      ath6kl: fix struct host_app_area endian handling
      ath6kl: return error block size is not power of 2
      ath6kl: move htc_hif to hif.c
      ath6kl: remove unused values from htc_hif.h
      ath6kl: move remaining content from htc_hif.h to hif.h
      ath6kl: fix null skb dereference in ath6kl_rx()
      ath6kl: fix firmware start address for ar6003 hw2.0
      ath6kl: merge htc debug levels
      ath6kl: cleanup htc debug messages
      ath6kl: don't dump full htc packets
      ath6kl: add debug level for hif
      ath6kl: remove unused A_CACHE_LINE_PAD
      ath6kl: use ath6kl prefix in credit functions
      ath6kl: rename struct htc_endpoint_credit_dist.htc_rsvd to htc_ep
      ath6kl: rename struct htc_credit_state_info to ath6kl_htc_credit_info
      ath6kl: move all credit distribution code to htc.c
      ath6kl: use ath6kl_credit prefix consistently
      ath6kl: remove unused debug levels
      ath6kl: add debug messages for credit handling
      ath6kl: add more boot debug messages
      ath6kl: don't use cfg80211_scan_request after cfg80211_scan_done()
      ath6kl: rename ath6kl_wmi_qos_state_init() to _wmi_reset()
      ath6kl: move power control from sdio to core
      ath6kl: add a fixme to ath6kl_htc_wait_target()
      ath6kl: merge ath6kl_init() to ath6kl_core_init()
      ath6kl: separate hardware boot code from module initialisation code
      ath6kl: remove useless cleanup call from ath6kl_bmi_done()
      ath6kl: add a timeout to ath6kl_hif_intr_bh_handler()
      ath6kl: create ath6kl_htc_reset()
      ath6kl: don't print an error for canceled packets
      ath6kl: change name of sdio driver to ath6kl
      ath6kl: create ath6kl_hif_stop()
      ath6kl: power down hardware when interface is down
      ath6kl: fix WLAN_ENABLE usage in ath6kl_close()
      ath6kl: print firmware crashes always
      ath6kl: print seqno in htc debug logs
      ath6kl: add aborted parameter to ath6kl_cfg80211_scan_complete_event()
      ath6kl: create ath6kl_cfg80211_stop()
      ath6kl: reset CONNECT_PEND and CONNECTED flags in ath6kl_cfg80211_stop()
      ath6kl: implement ath6kl_cfg80211_suspend()
      ath6kl: add state variable depicting hw/fw state
      ath6kl: refactor sdio configuration to a separate function
      ath6kl: cut power during suspend
      ath6kl: don't power down hardware when interface is down
      ath6kl: add suspend_cutpower module parameter
      ath6kl: move bmi calls to hif driver
      ath6kl: change bmi sizes being configurable by HIF
      ath6kl: move diag commands to hif driver
      ath6kl: update ar6004 definitions
      ath6kl: firmware boot fixes for ar6004
      ath6kl: add hif_type
      ath6kl: add USB support
      ath6kl: disable HTC for USB devices
      ath6kl: enable USB support
      ath6kl: remove hw version related parameter defines
      ath6kl: move hw version related to parameters to struct
      ath6kl: add board address to struct ath6kl_hw
      ath6kl: add firmware IE for board data address
      ath6kl: add name field to struct ath6kl_hw
      ath6kl: use hardware version names consistently
      ath6kl: add ar6004 firmwares to sdio module
      ath6kl: add firmware filename info to struct ath6kl_hw
      ath6kl: make maximum number of vifs runtime configurable
      ath6kl: add firmware IE for maximum number of vifs
      Merge remote branch 'wireless-next/master' into ath6kl-next
      nl80211: add testmode to the list of supported commands
      ath6kl: remove unused sc_params from struct ath6kl
      ath6kl: cleanup ath6kl_priv()
      ath6kl: remove a workaround from ath6kl_cfg80211_stop()
      ath6kl: call ath6kl_cfg80211_stop() from ath6kl_close()
      ath6kl: implement ath6kl_cfg80211_stop_all()
      ath6kl: fix value of WOW_FILTER_SSID
      ath6kl: fix reading of FW IE capabilities
      ath6kl: implement scheduled scan
      Merge remote branch 'wireless-next/master' into ath6kl-next

Kenny Hsu (2):
      iwlwifi: add range checking in tm sram read command
      iwlwifi: add range checking in tm sram read command

Kevin Fang (1):
      ath6kl: Add WSC IE on the associate message

Koki Sanagi (1):
      igb: reset PHY after recovering from PHY power down

Krishna Gudipati (2):
      bna: Added flash sub-module and ethtool eeprom entry points.
      bna: Add debugfs interface.

Krishna Kumar (1):
      macvtap: Fix macvtap_get_queue to use rxhash first

Larry Finger (10):
      rtl8192cu: Add new device IDs
      rtlwifi: rtl8192cu: Change firmware upload to use block writes
      rtlwifi: rtl8192cu: Fix endianian issues
      rtlwifi: Remove redundant code from PCI interrupt
      rtlwifi: Fix incorrect return of IRQ_HANDLED
      rtl8192c: Do not log firmware load message unless actually done
      brcmsmac: Replace kmalloc/memset with kzalloc
      rtlwifi: Fix locking problem introduces with commit 6539306b
      b43legacy: Avoid packet losses in the dma worker code
      rt2800usb: Move ID out of unknown

Lars-Peter Clausen (1):
      wireless: Remove redundant spi driver bus initialization

Laszlo Ersek (1):
      xen-netfront: delay gARP until backend switches to Connected

Lothar Wa√ümann (8):
      net/fec: misc cleanups
      net/fec: set con_id in clk_get() call to NULL
      net/fec: prevent dobule restart of interface on FDX/HDX change
      net/fec: don't request invalid IRQ
      net/fec: don't munge MAC address from platform data
      net/fec: preserve MII/RMII setting in fec_stop()
      net/fec: fix the .remove code
      net/fec: make FEC driver buildable as module

Luciano Coelho (16):
      wl12xx: remove sdio_test module
      wl12xx: move debugging definitions to a separate file
      wl12xx: sdio: use dev_dbg instead of wl1271_debug
      wl12xx: spi: use dev_err instead of wl1271_error
      wl12xx: use the same plat dev name for both SPI and SDIO
      wl12xx: change blocksize alignment quirk to negative
      wl12xx: use the same SDIO block size for all different chips
      wl12xx: increase firmware upload chunk size
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into wl12xx-next
      Merge branch 'wl12xx-next' into for-linville
      wl12xx: don't write out of bounds when hlid > WL12XX_MAX_LINKS
      wl12xx: call extended radio parameters for wl127x AP mode
      wl12xx: remove deprecated packet detection threshold config
      wl12xx: remove unused firmware version macros
      wl12xx: alloc buffer in driver_state_read to prevent compilation warning
      wl12xx: add missing copyright notice

Luis R. Rodriguez (23):
      cfg80211: process regulatory DFS region for countries
      cfg80211: pass DFS region to drivers through reg_notifier()
      ath6kl: fix ath6kl's set tx power
      cfg80211: clarify set tx power mBm documentation
      brcm80211: fix usage of set tx power
      brcm80211: avoid code duplication on set tx power
      mwifiex: fix usage of set tx power
      prism54: remove private driver ioctls
      ath: add a helper for processing reg data on init
      ath: optimize processing of CTLs for country IEs for world roaming cards
      ath: document ATH_DBG_MCI
      cfg80211: allow following country IE power for custom regdom cards
      ath9k: classify DFS debug header further
      ath9k: fix roadkill due to Joe's patch on ath_dbg() changes
      atheros: force endian checks on atheros wireless drivers
      ath9k_hw: fix sparse warnings on ar9003_rtt.c
      ath9k: fix tx queue sparse complaint
      ath5k: avoid sparse warnings on tracing
      ath9k_hw: fix sparse complaint on ar9003_switch_com_spdt_get()
      cfg80211: replace reg.c Nokia commit c4c32294
      cfg80211: replace reg.c Nokia commit 269ac5
      cfg80211: relicense reg.c reg.h and genregdb.awk to ISC
      ath9k: make ath_mci_duty_cycle static

Luiz Augusto von Dentz (7):
      Bluetooth: replace list_for_each with list_for_each_entry whenever possible
      Bluetooth: set skbuffer priority based on L2CAP socket priority
      Bluetooth: make use sk_priority to priritize RFCOMM packets
      Bluetooth: prioritizing data over HCI
      Bluetooth: handle priority change within quote
      Bluetooth: recalculate priorities when channels are starving
      Bluetooth: use buffer priority to mark URB_ISO_ASAP flag

Maciej ≈ªenczykowski (2):
      net: make ipv6 bind honour freebind
      net: make ipv6 PKTINFO honour freebind

Marc Kleine-Budde (1):
      net/can/mscan: add listen only mode

Marcel Apfelbaum (3):
      mlx4_core: Added FW commands and their wrappers for supporting SRIOV
      mlx4_core: mtts resources units changed to offset
      mlx4_core: fix mtt range deallocation

Marcel Holtmann (1):
      Bluetooth: Process recv path in a workqueue instead of a tasklet

Marek Lindner (4):
      batman-adv: refactoring gateway handling code
      batman-adv: report compat_version in version field in case of version mismatch
      batman-adv: readme update (mention ap isolation and new log level)
      mac80211: ibss should not purge clients it is not responsible for

Mat Martineau (10):
      Bluetooth: Add BT_CHANNEL_POLICY socket option
      Bluetooth: Change scope of the enable_hs module parameter
      Bluetooth: Add channel policy to getsockopt/setsockopt
      Bluetooth: Add AMP-related data and structures for channel signals
      Bluetooth: Add signal handlers for channel creation
      Bluetooth: Add definitions for L2CAP fixed channels
      Bluetooth: Use symbolic values for the fixed channel map
      Bluetooth: Add signal handlers for channel moves
      Bluetooth: Guarantee BR-EDR device will be registered as hci0
      Bluetooth: Incoming ACL packets do not force active mode

Matt Carlson (20):
      net: Add ethtool to mii advertisment conversion helpers
      net: Change mii to ethtool advertisement function names
      tg3: Make 1000Base-X FC resolution look like 1000T
      tg3: Adjust BD replenish thresholds
      tg3: Restrict large prod ring cap devices
      tg3: Add MDI-X reporting
      tg3: Fix TSO CAP for 5704 devs w / ASF enabled
      tg3: Scale back code that modifies MRRS
      tg3: Remove ethtool stats member from dev struct
      tg3: Save stats across chip resets
      tg3: Integrate flowctrl check into AN adv check
      tg3: Track LP advertising
      tg3: Return flowctrl config through ethtool
      tg3: Update version to 3.122
      tg3: Enable EEE support for capable 10/100 devs
      tg3: Make the TX BD DMA limit configurable
      tg3: Add 57766 ASIC rev support
      tg3: Use mii_advertise_flowctrl
      tg3: Break out RSS indir table init and assignment
      tg3: Make the RSS indir tbl admin configurable

Matthew Vick (1):
      igb: Update DMA Coalescing threshold calculation.

Matti Vaittinen (4):
      IPv6 routing, NLM_F_* flag support: warn if new route is created without NLM_F_CREATE
      IPv6 routing, NLM_F_* flag support: REPLACE and EXCL flags support, warn about missing CREATE flag
      IPv6: Removing unnecessary NULL checks.
      IPV6 Fix a crash when trying to replace non existing route

Michael Buesch (1):
      p54spi: Remove FIXME in op_stop

Michael Chan (4):
      bnx2x: Fix compile errors if CONFIG_CNIC is not set
      bnx2: Update driver to use new mips firmware.
      cnic: Re-init dev->stats_addr after chip reset
      cnic: Improve error recovery on bnx2x devices

Michael Maxim (1):
      IPVS: Modify the SH scheduler to use weights

Michal Simek (1):
      net: ethernet: xilinx: Don't use NO_IRQ in xilinx

Micha≈Ç Miros≈Çaw (12):
      net: remove legacy ethtool ops
      net: ethtool: break association of ETH_FLAG_* with NETIF_F_*
      net: split netdev features to separate header
      net: introduce and use netdev_features_t for device features sets
      net: Define enum for net device features.
      net: ethtool: use C99 array initialization for feature-names table
      ethtool: prepare for larger netdev_features_t type
      net: extend netdev_features_t to 64 bits
      net: remove NETIF_F_NO_CSUM feature bit
      net: ethtool: fix coding style
      net: drivers: use bool type instead of double negation
      net: verify GSO flag bits against netdev features

Michio Honda (2):
      sctp: fasthandoff with ASCONF at mobile-node
      sctp: fasthandoff with ASCONF at server-node

Mihai Maruseac (1):
      ipv6/addrconf: speedup /proc/net/if_inet6 filling

Mike Ditto (1):
      forcedeth: Add messages to indicate using MSI or MSI-X

Mike Waychison (1):
      virtio_net: Pass gfp flags when allocating rx buffers.

Mohammed Shafi Shajakhan (37):
      ath9k_hw: cosmetic change in calibration debug log
      mac80211: remove unused function declaration
      ath9k: Fix LED GPIO pin for AR9462
      ath9k: change the default antenna settings based on diversity
      ath9k_hw: add definitions to support MCI h/w code
      ath9k_hw: add GPIO output MUX related macros
      ath9k_hw: Add MCI h/w specific structure
      ath9k_hw: initialize MCI parameters
      ath9k_hw: Add MCI h/w code and state machine
      ath9k: Add MCI interrupt to interrupt mask
      ath9k_hw: take care of enabling MCI interrupts
      ath9k_hw: check for asynchronous MCI interrupt pending
      ath9k_hw: check for MCI interrupt in get_isr
      ath9k: add MCI specific definitions and structures
      ath9k: Add functions to allocate/free buffers for MCI
      ath9k_hw: MCI related changes in chip management
      ath9k_hw: MCI related changes in set_reset_reg
      ath9k_hw: Add support for MCI WLAN calibration
      ath9k_hw: Add MCI related changes in chip reset
      ath9k: MCI state machine based on MCI interrupt
      ath9k: fix a typo
      ath9k: minor cleanup
      ath9k_hw: Fix TX IQ calibration for AR9003
      ath9k_hw: add default chainmask for AR9462
      ath9k_hw: sync to latest AR9462 INI
      ath9k: clarify max_streams for AR9462
      ath9k_hw: check for asynchronous interrupts before bailing out
      ath9k_hw: Fix handling of MCI interrupt
      mac80211: remove an unnecessary paraenthesis
      mac80211: Fix power save in change interface
      ath9k: validate for non-zero BSSID
      ath9k_hw: remove ATH9K_HW_CAP_CST
      mac80211: fix scan state machine
      mac80211: fix kernel panic in IBSS due to a regression
      mac80211: use RCU read locks for sta_info_get
      ath9k: tx queue enable is read only for EDMA chipsets
      mac80211: remove dead code

Naveen Gangadharan (1):
      ath6kl: AR6004 SDIO support

Neal Cardwell (6):
      tcp: make is_dupack a parameter to tcp_fastretrans_alert()
      tcp: use DSACKs that arrive when packets_out is 0
      tcp: use SACKs and DSACKs that arrive on ACKs below snd_una
      tcp: allow undo from reordered DSACKs
      tcp: skip cwnd moderation in TCP_CA_Open in tcp_try_to_open
      tcp: do not scale TSO segment size with reordering degree

Neerav Parikh (2):
      netdev: FCoE: Add new ndo_get_fcoe_hbainfo() call
      ixgbe: FCoE: Add support for ndo_get_fcoe_hbainfo() call

Neil Horman (4):
      net: add network priority cgroup infrastructure (v4)
      net: add documentation for net_prio cgroups (v4)
      netprio_cgroup: Fix build break
      ipv6: Check RA for sllao when configuring optimistic ipv6 address (v2)

Nick Kossifidis (12):
      ath5k: Switch from read-and-clear to write-to-clear method when handling PISR/SISR registers
      ath5k: Add TXNOFRM to INT_TX_ALL
      ath5k: Cleanups v1
      ath5k: Calibration re-work
      ath5k: Use usleep_range where possible
      ath5k: Cleanups v2 + add kerneldoc on all hw functions
      ath5k: We always do full calibration on AR5210
      ath5k: Add a module parameter to disable hw rf kill switch
      ath5k: MRR support and 2GHz radio override belong in ah_capabilities
      ath5k: ath5k_ani_period_restart only touches struct ath5k_ani_state
      ath5k: Renumber hw queue ids
      ath5k: Optimize ath5k_cw_validate

Nicolas de Peslo√ºan (1):
      bonding: document undocumented active_slave sysfs entry.

Nikolay Martynov (10):
      ath9k: improve ath_tx_aggr_stop to avoid TID stuck in cleanup state
      mac80211: timeout tx agg sessions in way similar to rx agg sessions
      mac80211: trivial: use WLAN_BACK_RECIPIENT instead of hardcoded 0
      mac80211: log reason and initiator when rx agg is stopped
      ath9k: trivial: cosmetic fix in calibration debug log
      ath9k: change calibration debug log to output all calibration types
      ath9k: use config.enable_ani to check if ani should be performed
      ath9k: enable ANI for ar9100 chips
      iwlwifi regression in 20111205 merge
      mac80211: split addba retries in time

Or Gerlitz (3):
      net/mlx4: move RSS related definitions to be global
      net/mlx4: fix UDP RSS related settings
      net/mlx4_en: fix sparse warning on a cast which truncates bits from constant value

Oren Duer (1):
      net/mlx4_en: fix WOL handlers were always looking at port2 capability bit

Pablo Neira Ayuso (8):
      netfilter: ctnetlink: use expect instead of master tuple in get operation
      netfilter: ctnetlink: support individual atomic-get-and-reset of counters
      netfilter: rework user-space expectation helper support
      netfilter: ctnetlink: get and zero operations must be atomic
      netfilter: add extended accounting infrastructure over nfnetlink
      netfilter: xtables: add nfacct match to support extended accounting
      netfilter: Kconfig: fix unmet xt_nfacct dependencies
      netfilter: nfnetlink_acct: fix nfnl_acct_get operation

Padmanabh Ratnakar (11):
      be2net: Fix TX queue create for Lancer
      be2net: add register dump feature for Lancer
      be2net: Add EEPROM dump feature for Lancer
      be2net: Fix VLAN promiscous mode for Lancer
      be2net: Use V1 query link status command for lancer
      be2net: Move to new SR-IOV implementation in Lancer
      be2net: Fix error recovery paths
      be2net: Add error handling for Lancer
      be2net: Use new hash key
      be2net: Fix non utilization of RX queues
      be2net: Fix INTx processing for Lancer

Pascal Hambourg (2):
      atm: br2684: Make headroom and hard_header_len depend on the payload type
      atm: br2684: Avoid alignment issues

Patrick Kelle (3):
      minstrel: Remove unused function parameter in calc_rate_durations()
      minstrel_ht: Remove unused function parameters
      icplus: mdio_write(), remove unnecessary for loop

Patrick McHardy (8):
      netfilter: nf_nat: export NAT definitions to userspace
      netfilter: nf_nat: use hash random for bysource hash
      netfilter: nf_nat: add missing nla_policy entry for CTA_NAT_PROTO attribute
      netfilter: nat: remove module reference counting from NAT protocols
      netfilter: nf_nat: remove obsolete code from nf_nat_icmp_reply_translation()
      netfilter: nf_nat: remove obsolete check in nf_nat_mangle_udp_packet()
      netfilter: ctnetlink: remove dead NAT code
      netfilter: xtables: add an IPv6 capable version of the ECN match

Paul Bolle (2):
      Bluetooth: btusb: also be quiet when suspending
      Bluetooth: btusb: hide more usb_submit_urb errors

Paul Fertser (1):
      Bluetooth: ath3k: output firmware filename when request_firmware failed

Paul Gortmaker (8):
      tipc: rename struct media to struct tipc_media
      tipc: rename struct port_list to struct tipc_port_list
      tipc: rename struct subscription to struct tipc_subscription
      tipc: rename struct subscriber to struct tipc_subscriber
      tipc: rename struct bclink to struct tipc_bclink
      tipc: rename struct bcbearer* to tipc_bcbearer*
      tipc: rename struct link* to struct tipc_link*
      tipc: rename struct bearer_name to struct tipc_bearer_names

Paul Kot (1):
      batman-adv: bat_socket_read missing checks

Paul Stewart (1):
      cfg80211: Return beacon loss count in station

Pavel Emelyanov (47):
      inet_diag: Partly rename inet_ to sock_
      sock_diag: Introduce new message type
      inet_diag: Move byte-code finding up the call-stack
      inet_diag: Switch from _GETSOCK to IPPROTO_ numbers
      sock_diag: Initial skeleton
      inet_diag: Introduce new inet_diag_req header
      inet_diag: Switch the _get_exact to work with new header
      inet_diag: Switch the _dump to work with new header
      inet_diag: Introduce socket family checks
      inet_diag: Cleanup type2proto last user
      sock_diag: Move the sock_ code to net/core/
      inet_diag: Remove indirect sizeof from inet diag handlers
      inet_diag: Reduce the number of args for bytecode run routine
      inet_diag: Export inet diag cookie checking routine
      inet_diag: Split inet_diag_get_exact into parts
      inet_diag: Split inet_diag_get_exact into parts
      inet_diag: Introduce the byte-code run on an inet socket
      inet_diag: Introduce the inet socket dumping routine
      inet_diag: Generalize inet_diag dump and get_exact calls
      udp: Export code sk lookup routines
      udp_diag: Basic skeleton
      udp_diag: Implement the get_exact dumping functionality
      udp_diag: Implement the dump-all functionality
      udp_diag: Wire the udp_diag module into kbuild
      udp_diag: Make it module when ipv6 is a module
      udp_diag: Fix the !ipv6 case
      sock_diag: Move the SOCK_DIAG_BY_FAMILY cmd declaration
      sock_diag: Fix module netlink aliases
      sock_diag: Generalize requests cookies managements
      af_unix: Export stuff required for diag module
      unix_diag: Basic module skeleton
      unix_diag: Dumping all sockets core
      unix_diag: Dumping exact socket core
      unix_diag: Unix socket name NLA
      unix_diag: Unix inode info NLA
      unix_diag: Unix peer inode NLA
      unix_diag: Pending connections IDs NLA
      unix_diag: Receive queue lenght NLA
      unix_diag: Write it into kbuild
      unix_diag: Fix incoming connections nla length
      sock_diag: Arrange sock_diag.h such that it is exportable to userspace
      unix_diag: Include unix_diag.h into header-y target
      sock_diag: Introduce the meminfo nla core (v2)
      inet_diag: Add the SKMEMINFO extension
      unix_diag: Add the MEMINFO extension
      af_unix: Move CINQ/COUTQ code to helpers
      unix_diag: Fixup RQLEN extension report

Peter Hurley (1):
      Bluetooth: hidp: safely acquire hci connection

Pontus Fuchs (5):
      wl12xx: Validate FEM index from ini file and FW
      wl12xx: Check buffer bound when processing nvs data
      wl12xx: Print nvs/fw file name if loading fails.
      wl12xx: Restore testmode ABI
      Set wlvif->ps_compl to NULL in before return

Pravin B Shelar (3):
      genetlink: Add genl_notify()
      genetlink: Add lockdep_genl_is_held().
      vlan: Move vlan_set_encap_proto() to vlan header file

Rafa≈Ç Mi≈Çecki (31):
      bcma: pci: use fixed windows when possible
      ssb: extract FEM info from SPROM
      bcma: extract FEM info from SPROM
      bcma: support for suspend and resume
      b43: N-PHY: random trivial fixes for typos, missing writes
      b43: N-PHY: update some init values
      b43: N-PHY: workaround BCM43224 hw bug in writing table id 9
      b43: N-PHY: add table for antenna software control
      b43: N-PHY: determine various PHY params
      b43: N-PHY: finish 2.4GHz 0x2056 radio setup
      b43: N-PHY: implement spurious tone avoidance
      bcma: extract revision and TX power IDs from SPROM
      b43: N-PHY: fix 32-bit reads of tables
      b43: N-PHY: workaround broken auto-increment on BCM43224
      b43: N-PHY: update TX power fix
      b43: N-PHY: check for bustype before touching BCMA CC PLLs
      b43: N-PHY: reorder functions: put basic ones at beginning
      b43: N-PHY: reorder functions: collect radio ones
      b43: N-PHY: reorder functions: collect samples ones
      b43: N-PHY: reorder functions: collect RSSI selects
      b43: N-PHY: split gain control workarounds
      b43: N-PHY: reorder functions: move RSSI calibration
      b43: N-PHY: reorder functions: move rest of workarounds
      b43: N-PHY: reorder functions: random cleanups
      b43: N-PHY: move common TX/RX functions
      b43: N-PHY: fix success condition of running samples
      b43: N-PHY: get idle TSSI values
      b43: add lacking boardflags defines
      b43: N-PHY: update gain ctl workarounds
      b43: N-PHY: fix controling RF override
      b43: N-PHY: fix typo in TX power fix

Raja Mani (14):
      ath6kl: Add wmi functions to add/delete WOW patterns
      ath6kl: Add wmi functions to configure WOW mode and host sleep mode
      ath6kl: Add WOW suspend/resume implementation
      ath6kl: Include new parameter in suspend path for wowlan
      ath6kl: Add new state for WOW mode
      ath6kl: Move ath6kl_cfg80211_stop() call specific to deep sleep and cut pwr
      ath6kl: Invoke WOW suspend/resume calls during PM operation
      ath6kl: Perform WOW resume in RX path in case of SDIO IRQ wake up
      ath6kl: Remove WARN_ON msg in Suspend path
      ath6kl: Expose ath6kl's WOW capabilities to cfg80211
      ath6kl: Remove few unused WMI stuff
      ath6kl: Fix cfg80211 warning while starting IBSS mode
      ath6kl: Clear WPS ctrl flag if zero length IE is received from cfg80211
      ath6kl: Use mutex to protect dma buffer in sync read write

Rajkumar Manoharan (15):
      ath9k_hw: Update CCK spur mitigation for AR9462
      ath9k: Add btcoex profile management support for AR9462
      ath9k_hw: Updated AR9462 initval table to improve rx performance
      ath9k_hw: Read and configure quick drop for AR9003
      ath9k_hw: Read and configure xpa timing field
      ath9k_hw: Fix channel list of CalFreqPeir for AR938x
      ath9k_hw: Fix tx power settings for AR9003
      ath9k: Remove enabling btcoex from stomp type change
      ath9k_hw: Cleanup btcoex wlan weights
      ath9k_hw: set btcoex weights for AR9462
      ath9k_hw: Fix minimum CTL power for each runtime mode
      ath9k: Reconfigure tx power on regulatory update
      cfg80211: notify core hints that helps to restore regd settings
      cfg80211: Restore orig channel values upon disconnect
      ath9k_hw: increase tx status ring buffer size

Ralf Baechle (4):
      NET: AX.25: Check ioctl arguments to avoid overflows further down the road.
      NET: NETROM: When adding a route verify length of mnemonic string.
      NET: NETROM: Cleanup argument SIOCADDRT ioctl argument checking.
      NET: NETROM: Fix formatting.

Ricardo Ribalda (1):
      ll_temac: Add support for phy_mii_ioctl

Rick Jones (9):
      sweep the floors and convert some .get_drvinfo routines to strlcpy
      Sweep additional floors of strcpy in .get_drvinfo routines
      Sweep the last of the active .get_drvinfo floors under ethernet/
      enable virtio_net to return bus_info in ethtool -i consistent with emulated NICs
      net: sweep-up some straglers in strlcpy conversion of .get_drvinfo routines
      wireless: use strlcpy routine in .get_drvinfo
      Sweep away N/A fw_version dustbunnies from the .get_drvinfo routine of a number of drivers
      virtio_net: return already tracked tx_fifo_errors via virtnet_getstats()
      corral some wayward N/A fw_version dust bunnies

Rishi Panjwani (4):
      ath6kl: Implement support for QOS-enable and QOS-disable from userspace
      ath6kl: Implement support for background scan control from userspace
      ath6kl: Implement support for listen interval from userspace
      ath6kl: Implement support for power parameter control from userspace

Roar F√∏rde (1):
      caif: Replace BUG_ON with WARN_ON.

Rob Herring (1):
      net: add calxeda xgmac ethernet driver

Robert Marklund (1):
      net/smsc911x: Add regulator support

Rogerio Pimentel (1):
      net: fec: Adjust ENET MDIO timeouts

Roland Vossen (14):
      brcm80211: smac: removed support for SROM rev < 8
      brcm80211: fmac: annotated little endian struct with _le
      brmc80211: fmac: reworked next_bss()
      brcm80211: fmac: changed two scan related structures
      brcm80211: smac: indicate severe problems to Mac80211
      brcm80211: smac: removed MPC related code
      brcm80211: smac: removed MPC related variables
      brcm80211: smac: removed down-on-watchdog MPC functionality
      brcm80211: smac: removed down-on-rf-kill functionality
      brcm80211: smac: bugfix for tx mute in brcms_b_init()
      brcm80211: smac: fixed inconsistency in transmit mute
      brcm80211: smac: modified Mac80211 callback interface
      brcm80211: smac: mute transmit on ops_start
      brcm80211: smac: changed check to confirm STA only support

RongQing.Li (2):
      ipv4: fix a memory leak in ic_bootp_send_if
      ipv4: remove useless codes in ipmr_device_event()

Rusty Russell (4):
      net: fix assignment of 0/1 to bool variables.
      module_param: make bool parameters really bool (net & drivers/net)
      virtio_net: set/cancel work on ndo_open/ndo_stop
      virtio_net: use non-reentrant workqueue.

Ryan Hsu (1):
      ath6kl: Support different uart_tx pin and refclk configuration

Sam Leffler (1):
      ath6kl: unbreak suspend

Sameer Nanda (1):
      forcedeth: allow to silence "TX timeout" debug messages

Samuel Ortiz (9):
      NFC: Add function name to the NFC pr_fmt() routine
      NFC: Add tx skb allocation routine
      NFC: Do not take the genl mutex from the netlink release notifier
      NFC: Atomic socket allocation
      NFC: Add a DEP link control netlink command
      NFC: Set and get DEP general bytes
      NFC: DEP link hook implementation for pn533
      NFC: Initial LLCP support
      NFC: Fix LLCP related build failure

Sangwook Lee (1):
      ath6kl: Fix compilation error from of.h

Sanjay Hortikar (1):
      net-forcedeth: Add internal loopback support for forcedeth NICs.

Sascha Hauer (1):
      net/davinci: do not use all descriptors for tx packets

Sathya Perla (6):
      be2net: init (vf)_if_handle/vf_pmac_id to handle failure scenarios
      be2net: stop checking the UE registers after an EEH error
      be2net: don't log more than one error on detecting EEH/UE errors
      be2net: stop issuing FW cmds if any cmd times out
      be2net: fix ethtool ringparam reporting
      be2net: refactor/cleanup vf configuration code

Shahar Lev (1):
      wl12xx: remove warning message during IBSS Tx

Shan Wei (1):
      net: doc: fix many typos in scaling.txt

Simon Wunderlich (10):
      batman-adv: directly write tt entries without buffering
      batman-adv: Fix range check for expected packets
      batman-adv: check return value for hash_add()
      batman-adv: use unregister_netdevice() when softif_create fails
      mac80211: remove debugfs noack test
      wireless: Add NoAck per tid support
      mac80211: Add NoAck per tid support
      mac80211: fix duration calculation for QoS NOACK frames
      mac80211: handle protection mode, RIFS and ADDBA for HT IBSS
      mac80211: free skb on error path of ieee80211_ibss_join()

Srinivas Kandagatla (1):
      mdio-gpio: Add reset functionality to mdio-gpio driver(v2).

Stanislav Yakovlev (2):
      ipw2x00: remove unused function libipw_ratelimit_debug.
      ipw2x00: remove reset_port functionality

Stanislaw Gruszka (82):
      mac80211: remove uneeded scan_chan variable
      mac80211: remove useless brackets in ieee80211_cfg_on_oper_channel
      mac80211: simplify ieee80211_work_work
      iwlegacy: remove tracing
      iwlegacy: rename iwl to il
      iwlegacy: rename priv to il
      iwlegacy: rename iwlegacy to il
      iwlegacy: remove DEBUG_IO
      iwlegacy: remove DEBUG_LIMIT
      iwlegacy: rename IL_DEBUG_ to D_
      iwlegacy: remove il argument from IWL_ERR/INFO/WARN/CRIT
      iwlegacy: remove IL_CRIT
      iwlegacy: rename il_{read,write}32 to _il_{rd,wr}
      iwlegacy: mark poll bit as unlocked function
      iwlegacy: mark il_{grab,release}_nic_access as unlocked
      iwlegacy: remove _il_{read,write}_direct32
      iwlegacy: rename i/o direct methods
      iwlegacy: rename il_{read,write}_prph
      iwlegacy: remove not needed parentheses
      iwlegacy: rename remaining IWLs to ILs
      iwlegacy: s/iwl_rx_packet/iwl_rx_pkt/
      iwlegacy: partial rxon context cleanup
      iwlegacy: s/il_rx_mem_buffer/il_rx_buf/
      iwlegacy: s/statistics/stats/
      iwlegacy: s/window/win/
      iwlegacy: s/IL_RATE/RATE/
      iwlegacy: s/INDEX/IDX/
      iwlegacy: s/index/idx/
      iwlegacy: s/TABLE/TBL/
      iwlegacy: remove for_each_context
      iwlegacy: rename base 4965 and 3945 file names
      iwlegacy: merge iwl-4965-led.c into 4965.c
      iwlegacy: merge iwl-3945-led.c into 3945.c
      iwlegacy: merge iwl-4965-eeprom.c into 4965.c
      iwlegacy: merge iwl-4965-ucode.c into 4965.c
      iwlegacy: merge iwl-4965-sta.c into 4965-mac.c
      iwlegacy: merge iwl-4965-{tx,rx}.c into 4965-mac.c
      iwlegacy: merge iwl-4965-lib.c into 4965-mac.c
      iwlegacy: rename iwl-4965-{rs,calib,debugfs}.c to 4965-{rs,calib,debug}.c
      iwlegacy: rename iwl-3945-{rs,debugfs}.c to 3945-{rs,debug}.c
      iwlegacy: add accidentally removed comments
      iwlegacy: move iwl-4965-{,hw,debugfs,calib}.h to 4965.h
      iwlegacy: move iwl-3945-{,hw,fh,debugfs}.h to 3945.h
      iwlegacy: s/STATUS_/S_/
      iwlegacy: s/STATISTICS/STATS/
      iwlegacy: rename REPLY_ to N_ or C_
      iwlegacy: s/rx_handler/handler/
      iwlegacy: s/rx_reply/hdl/
      iwlegacy: rename other handlers
      iwlegacy: rename iwl-core.c to common.c
      iwlegacy: merge common .c files
      iwlegacy: rename module name
      iwlegacy: rename iwl-commands.h to commands.h
      iwlegacy: remove il_ieee80211_get_hw_conf
      iwlegacy: move IL_MASK
      iwlegacy: rename iwl-csr.h to csr.h
      iwlegacy: rename iwl-core.h to common.h
      iwlegacy: merge common header files
      iwlegacy: remove iwl-helpers.h
      iwlegacy: merge iwl-legacy-rs.h into common.h
      iwlegacy: merge iwl-power.h into common.h
      iwlegacy: merge iwl-{eeprom,led}.h into common.h
      iwlegacy: rename iwl-prph.h to prph.h
      iwlegacy: use FH39_ prefix in 3945 code
      iwlegacy: use FH49_ prefix in 4965 code
      iwlegacy: merge iwl-fh.h into 4965.h
      iwlegacy: rename iwl-debug.c to debug.c
      iwlegacy: merge iwl-debug.h into common.h
      iwlegacy: indentions and whitespaces
      iwlegacy: checkpatch.pl fixes
      iwlegacy: remove unused IL_AC_UNSET define
      rtlwifi: use work for lps
      rtlwifi: merge ips,lps spinlocks into one mutex
      iwlegacy: remove iwl-sta.c
      iwlegacy: move some i/o helpers out of inline
      iwlegacy: 4965: toggle tx antenna inline
      iwlegacy: 4965: small tx_cmd build cleanup
      iwlegacy: 3945: get rid of hw_{set,get}_rate
      iwlegacy: 4965: remove one il4965_hdl_beacon
      iwlegacy: random 3945-rs.c cleanups
      iwlegacy: 3945: simplify calculations of retry limit
      iwlegacy: 3945: fix hw passive scan on radar channels

Stephen Hemminger (2):
      genetlink: add auto module loading
      ixgbe: fix typo's

Sven Eckelmann (4):
      batman-adv: update internal version number
      batman-adv: Replace obsolete strict_strto<foo> with kstrto<foo>
      batman-adv: Directly check read of icmp packet in copy_from_user
      batman-adv: Only write requested number of byte to user buffer

Szymon Janc (8):
      Bluetooth: rfcomm: Fix sleep in invalid context in rfcomm_security_cfm
      Bluetooth: Increase HCI reset timeout in hci_dev_do_close
      Bluetooth: Add debug print to l2cap_chan_create
      Bluetooth: Fix possible NULL pointer derefence in l2cap code
      Bluetooth: Simplify l2cap_add_to_srej_queue
      Bluetooth: Refactor loop in l2cap_retransmit_one_frame
      Bluetooth: Simplify __l2cap_global_chan_by_addr
      Bluetooth: Fix some checkpatch.pl errors and warnings

Thomas Meyer (13):
      irttp: Use kmemdup rather than duplicating its implementation
      ks8*/ksz8*: Casting (void *) value returned by kmalloc is useless
      ksz884x: Use kzalloc rather than kmalloc followed by memset with 0
      RxRPC: Use kmemdup rather than duplicating its implementation
      gianfar: Use kmemdup rather than duplicating its implementation
      brcm80211: smac: Use kmemdup rather than duplicating its implementation
      CDC NCM: Use kzalloc rather than kmalloc followed by memset with 0
      bnx2x: Use kcalloc instead of kzalloc to allocate array
      enic: Use kcalloc instead of kzalloc to allocate array
      ll_temac: Use kcalloc instead of kzalloc to allocate array
      sfc: Use kcalloc instead of kzalloc to allocate array
      rt2x00: Use kcalloc instead of kzalloc to allocate array
      iwlegacy: Use kcalloc instead of kzalloc to allocate array

Thomas Pedersen (12):
      mac80211: comment allocation of mesh frames
      mac80211: add HT IEs to mesh frames
      mac80211: set HT capabilities for mesh peer
      mac80211: allow frame aggregation for mesh
      mac80211: QoS multicast frames have No Ack policy
      mac80211: check if frame is really part of this BA
      mac80211: failed forwarded mesh frame addressing
      mac80211: fix switched HWMP frame addresses
      mac80211: fix forwarded mesh frame queue mapping
      {nl,cfg,mac}80211: implement dot11MeshHWMPperrMinInterval
      mac80211: don't initiate path discovery when forwarding frame with unknown DA
      mac80211: clean up rx_h_mesh_fwding

Tilman Schmidt (1):
      isdn/gigaset: report ISDN4Linux interface only once

Todd Previte (1):
      iwlwifi: Suppress noisy syslog messages when RF_KILL switch engaged

Tom Herbert (10):
      dql: Dynamic queue limits
      net: Add queue state xoff flag for stack
      net: Add netdev interfaces for recording sends/comp
      xps: Add xps_queue_release function
      bql: Byte queue limits
      e1000e: Support for byte queue limits
      forcedeth: Support for byte queue limits
      tg3: Support for byte queue limits
      bnx2x: Support for byte queue limits
      sfc: Support for byte queue limits

Tristram Ha (1):
      KSZ8851-SNL: Fix MAC address change problem

Ulisses Furquim (4):
      Bluetooth: Remove global mutex hci_task_lock
      Bluetooth: Always compile SCO and L2CAP in Bluetooth Core
      Bluetooth: Make HCI call directly into SCO and L2CAP event functions
      Bluetooth: Fix deadlocks with sock lock and L2CAP timers locks

Ursula Braun (8):
      af_iucv: support ancillary data with HS transport
      af_iucv: accelerate close for HS transport
      af_iucv: release reference to HS device
      af_iucv: remove unused timer infrastructure
      af_iucv: get rid of state IUCV_SEVERED
      qeth: suspicious rcu_dereference_check in recovery
      qeth: forbid recovery during shutdown
      netiucv: allow multiple interfaces to same peer

Vasanthakumar Thiagarajan (52):
      ath6kl: Enable force foreground scan in connected state
      ath6kl: Fix sparse warning "symbol 'conn' shadows an earlier one"
      ath6kl: Replace spin_lock_irqsave with spin_lock_bh
      ath6kl: Claim sdio function only at appropriate places
      ath6kl: Fix htc_packet leak in ath6kl_htc_rx_process_packets()
      ath6kl: Fix htc_packet leak in ath6kl_htc_rx_fetch()
      ath6kl: Avoid processing failed rx packets
      ath6kl: Minor cleanup in msg_look_ahead parameter in ath6kl_htc_rxmsg_pending_handler()
      ath6kl: Pass ath6kl structure to ath6kl_init() instead of net_device
      ath6kl: Keep wiphy reference in ath6kl structure
      ath6kl: Refactor wiphy dev and net dev init functions
      ath6kl: Cleanup fw interface type setting
      ath6kl: Define an initial vif structure and use it
      ath6kl: Define interface specific states
      ath6kl: Move ssid and crypto information to vif structure
      ath6kl: Move nw_type to vif structure
      ath6kl: Move bssid information to vif structure
      ath6kl: Move channel information to vif structure
      ath6kl: Move key information to vif structure
      ath6kl: Move aggregation information to vif structure
      ath6kl: Move disconnect timer to vif structure
      ath6kl: Move scan_req info and sme_state to vif
      ath6kl: Move few more vif specific information to struct ath6kl_vif
      ath6kl: Make net and target stats vif specific
      ath6kl: Maintain firmware interface index in struct ath6kl_vif
      ath6kl: Take vif information from wmi event
      ath6kl: Remove net_device from ath6kl
      ath6kl: Cleanup parameters in ath6kl_init_control_info() and ath6kl_init_profile_info()
      ath6kl: Refactor ath6kl_destroy()
      ath6kl: Use interface index from wmi data headr
      ath6kl: Store hw mac address in struct ath6kl
      ath6kl: Introduce spinlock to protect vif specific information
      ath6kl: Maintain virtual interface in a list
      ath6kl: Use the other variant of netdev (un)register APIs
      ath6kl: Configure inteface information at init time
      ath6kl: Implement add_virtual_intf() and del_virtual_intf()
      ath6kl: Add a modparam to enable multi normal interface support
      ath6kl: Initialize target wlan values for every vif
      ath6kl: Use appropriate wdev from vif
      ath6kl: Fix lockdep warning
      ath6kl: Fix tx packet drop in AP mode with bridge
      ath6kl: Fix error in writing create_qos debugfs
      ath6kl: Fix accessing wrong skb->data in ath6kl_tx_complete()
      ath6kl: Fix packet drop when ath6kl_cookie runs out
      ath6kl: Fix bug in setting default key index for tx in AP mode
      ath6kl: Fix bug in setting dot11_auth_mode in AP mode
      ath6kl: Fix AP mode operation after interface down/up
      ath6kl: Remove modparam multi_norm_if_support
      ath6kl: Find ar->max_norm_iface in firmware IE parsing
      ath6kl: Enable multiple vif support
      ath6kl: Increase the maximum number of connections in AP mode
      cfg80211: Fix race in bss timeout

Veli-Pekka Peltola (1):
      hostap_cs: add ID for Canon K30225

Venkataraman, Meenakshi (2):
      iwlwifi: fix rate-scaling algorithm for BT combo devices
      iwlwifi: Execute runtime calibration always

Vijay Subramanian (1):
      tcp: Replace constants with #define macros

Vinson Lee (1):
      myri10ge: Fix typo of 'VMware' in comment.

Wei Liu (2):
      netback: remove redundant assignment
      netback: fix typo in comment

Wei Yongjun (1):
      packet: fix typo in packet_mmap.txt

Wey-Yi Guy (34):
      iwlwifi: HW rev for 105 and 135 series
      iwlwifi: two more SKUs for 6x05 series
      iwlagn: check for SMPS mode
      iwlwifi: remove un-supported SKUs
      iwlwifi: move all mac80211 related functions to one place
      iwlwifi: move more mac80211 callback function
      iwlwifi: move hw_scan into _mac80211 file
      iwlwifi: move station functions to mac80211
      iwlwifi: Move the core suspend function to iwl-agn-lib
      iwlwifi: set "echo" host command length
      iwlwifi: check status before send command
      iwlwifi: remove redundancy
      iwlwifi: remove redundancy
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into wireless-next
      iwlwifi: show command string for REPLY_D3_CONFIG
      iwlwifi: show the configuration option
      iwlwifi: show command string for REPLY_D3_CONFIG
      iwlwifi: show the configuration option
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into wireless-next
      iwlwifi: do not re-configure HT40 after associated
      iwlwifi: declare static for iwl_sram_cleanup function
      iwlwifi: Rename file name from iwl-sv-open.c to iwl-testmode.c
      iwlwifi: declare static for iwl_sram_cleanup function
      iwlwifi: Rename file name from iwl-sv-open.c to iwl-testmode.c
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into wireless-next
      iwlwifi: Display more uCode debug info
      iwlwifi: minor cleanup
      iwlwifi: remove reference to legacy devices
      iwlwifi: rename CONFIG_IWLWIFI_DEVICE_SVTOOL to CONFIG_IWLWIFI_DEVICE_TESTMODE
      iwlwifi: P2P is not enabled by default
      iwlwifi: set TX_CMD_FLG_STA_RATE_MSK for BAR frame
      iwlwifi: deliver hw version in both string and u32 format
      iwlwifi: set hw_version in wiphy
      iwlwifi: use bus_get_hw_id for IWL_TM_CMD_APP2DEV_GET_DEVICE_ID

Wolfgang Grandegger (10):
      net/can/mscan: Fix buggy listen only mode setting
      ibm/emac: fix improper cleanup when device is removed to allow re-bind
      can: sja1000_isa: fix "limited range" compiler warnings
      can: sja1000_isa: convert to platform driver to support x86_64 systems
      can: cc770: add driver core for the Bosch CC770 and Intel AN82527
      can: cc770: legacy CC770 ISA bus driver
      can: cc770: add driver core for the Bosch CC770 and Intel AN82527
      can: cc770: add legacy ISA bus driver for the CC770 and AN82527
      can: cc770: add platform bus driver for the CC770 and AN82527
      powerpc: tqm8548/tqm8xx: add and update CAN device nodes

Xi Wang (3):
      irda: use msecs_to_jiffies() rather than manual calculation
      ax25: avoid overflows in ax25_setsockopt()
      netrom: avoid overflows in nr_setsockopt()

Yan, Zheng (1):
      igb: add basic runtime PM support

Yaniv Rosner (9):
      bnx2x: PFC changes
      bnx2x: ETS changes
      bnx2x: Warpcore HW reset following fan failure
      bnx2x: Fix BCM84833 link and LED behavior
      bnx2x: Change Warpcore MDIO work around mode
      bnx2x: Add known PHY type check
      bnx2x: Fix self test of BCM57800
      bnx2x: Cosmetic changes
      bnx2x: Change value comparison order

Yevgeny Petrilin (12):
      net/mlx4_en: using non collapsed CQ on TX
      net/mlx4_core: Implement the master-slave communication channel
      mlx4_core: updated driver version to 1.1
      mlx4_en: updated driver version to 2.0
      mlx4: capability for link sensing
      mlx4_core: Changing link sensing logic
      mlx4: not using spin_lock_irq when getting vf by resource.
      mlx4: Fixing wrong error codes in communication channel
      mlx4_en: FIX: Setting default_qpn before using it
      mlx4_core: using array index for sense_allowed
      mlx4_core: limiting VF port options
      mlx4_core: Elaborating limitation on VF port options

Yogesh Ashok Powar (11):
      mwifiex: fix ht_cap_info in ibss beacons
      mwifiex: use existing helper function mwifiex_fill_cap_info
      mwifiex: change return types to void
      mwifiex: fix coding style
      mwifiex: fix 'Smatch' warnings
      mac80211: Purge A-MPDU TX queues before station destructions
      mac80211: Fixing sparse warning at sta_info.c
      mwl8k: Call ieee80211_stop_tx_ba_cb_irqsafe for already deleted BA stream
      mac80211: Call driver commands after drv_start in mac80211 restart code
      mwl8k: Recover from firmware crash
      mwl8k: Changing the driver version to 0.13

Zefir Kurtisi (4):
      ath9k: trivial: reorder rx_tasklet processing
      ath: add a debug level for DFS
      ath9k_hw: add DFS testing check
      ath9k: add DFS radar pulse processing

alex.bluesman.smirnov@gmail.com (6):
      6LoWPAN: add fragmentation support
      6LoWPAN: disable debugging by default
      6LoWPAN: set proper netdev flags
      6LoWPAN: UDP header compression
      6LoWPAN: UDP header decompression
      6LoWPAN: update documentation

allan (1):
      drivers/net/usb/asix: fixed asix_get_wol reported wrong wol status issue

chas williams - CONTRACTOR (1):
      atm: eliminate atm_guess_pdu2truesize()

david decotigny (7):
      forcedeth: fix stats on hardware without extended stats support
      net-sysfs: fixed minor sparse warning
      net: new counter for tx_timeout errors in sysfs
      forcedeth: implement ndo_get_stats64() API
      forcedeth: account for dropped RX frames
      forcedeth: stats updated with a deferrable timer
      net-forcedeth: fix possible stats inaccuracies on 32b hosts

francesco.gringoli@ing.unibs.it (1):
      b43: avoid packet losses in the dma worker code.

sjur.brandeland@stericsson.com (10):
      caif: Allow cfpkt_extr_head to process empty message
      caif: Restructure how link caif link layer enroll
      caif: Remove unused enum and parameter in cfserl
      caif: Remove unused attributes from struct cflayer
      if_ether.h: Add IEEE 802.1 Local Experimental Ethertype 1.
      caif: Add support for CAIF over CDC NCM USB interface
      caif: Add support for flow-control on device's tx-queue
      caif: Stash away hijacked skb destructor and call it later
      caif: Bad assert triggering false positive.
      caif-shm: Bugfixes for caif_shmcore.c

stephen hemminger (15):
      bridge: add NTF_USE support
      sky2: add bql support
      bridge: refactor fdb_notify
      bridge: rearrange fdb notifications (v2)
      bridge: add local MAC address to forwarding table (v2)
      netlink: af_netlink cleanup (v2)
      netlink: wake up netlink listeners sooner (v2)
      netem: loss model API sizes
      bonding: fix error handling if slave is busy (v2)
      xen-netback: make ops structs const
      vmxnet3" make ethtool ops const
      net: make ethtool_ops const
      xgmac: cleanups
      bna: make ethtool_ops and strings const
      bna: fix sparse warnings/errors

 Documentation/cgroups/memory.txt                   |   28 +-
 Documentation/cgroups/net_prio.txt                 |   53 +
 .../devicetree/bindings/net/calxeda-xgmac.txt      |   15 +
 .../devicetree/bindings/net/can/cc770.txt          |   53 +
 Documentation/feature-removal-schedule.txt         |    3 +-
 Documentation/networking/00-INDEX                  |    2 +
 Documentation/networking/batman-adv.txt            |    7 +-
 Documentation/networking/bonding.txt               |   17 +
 Documentation/networking/ieee802154.txt            |   27 +
 Documentation/networking/ifenslave.c               |    2 +
 Documentation/networking/ip-sysctl.txt             |   13 +
 Documentation/networking/openvswitch.txt           |  195 +
 Documentation/networking/packet_mmap.txt           |    2 +-
 Documentation/networking/scaling.txt               |    8 +-
 Documentation/networking/stmmac.txt                |   16 +-
 Documentation/networking/team.txt                  |    2 +
 MAINTAINERS                                        |   17 +-
 arch/alpha/include/asm/socket.h                    |    3 +
 arch/arm/include/asm/socket.h                      |    3 +
 arch/avr32/include/asm/socket.h                    |    3 +
 arch/cris/include/asm/socket.h                     |    3 +
 arch/frv/include/asm/socket.h                      |    3 +
 arch/h8300/include/asm/socket.h                    |    3 +
 arch/ia64/include/asm/socket.h                     |    3 +
 arch/m32r/include/asm/socket.h                     |    3 +
 arch/m68k/include/asm/socket.h                     |    3 +
 arch/mips/include/asm/ip32/mace.h                  |    2 +-
 arch/mips/include/asm/socket.h                     |    3 +
 arch/mn10300/include/asm/socket.h                  |    3 +
 arch/parisc/include/asm/socket.h                   |    3 +
 arch/powerpc/boot/dts/tqm8548-bigflash.dts         |   19 +-
 arch/powerpc/boot/dts/tqm8548.dts                  |   19 +-
 arch/powerpc/boot/dts/tqm8xx.dts                   |   25 +
 arch/powerpc/include/asm/socket.h                  |    3 +
 arch/s390/include/asm/socket.h                     |    3 +
 arch/sparc/include/asm/socket.h                    |    3 +
 arch/xtensa/include/asm/socket.h                   |    3 +
 drivers/atm/iphase.c                               |    4 +-
 drivers/bcma/bcma_private.h                        |    3 +
 drivers/bcma/host_pci.c                            |   69 +-
 drivers/bcma/main.c                                |   16 +
 drivers/bcma/sprom.c                               |   61 +
 drivers/bluetooth/ath3k.c                          |   15 +-
 drivers/bluetooth/bfusb.c                          |    4 +-
 drivers/bluetooth/bluecard_cs.c                    |    4 +-
 drivers/bluetooth/bt3c_cs.c                        |    4 +-
 drivers/bluetooth/btuart_cs.c                      |    4 +-
 drivers/bluetooth/btusb.c                          |   26 +-
 drivers/bluetooth/dtl1_cs.c                        |    4 +-
 drivers/bluetooth/hci_vhci.c                       |   13 +-
 drivers/ieee802154/fakehard.c                      |    2 +-
 drivers/infiniband/core/addr.c                     |   53 +-
 drivers/infiniband/core/cma.c                      |    8 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |   15 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |  220 +-
 drivers/infiniband/hw/mlx4/mad.c                   |    6 +-
 drivers/infiniband/hw/mlx4/main.c                  |   14 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |   14 +-
 drivers/infiniband/hw/nes/nes_nic.c                |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |   32 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c     |    4 +-
 drivers/isdn/gigaset/i4l.c                         |    3 +-
 drivers/lguest/lguest_device.c                     |    6 +
 drivers/misc/eeprom/eeprom_93cx6.c                 |   88 +
 drivers/misc/sgi-xp/xpnet.c                        |    2 +-
 drivers/net/Kconfig                                |    4 +
 drivers/net/Makefile                               |    2 +
 drivers/net/bonding/bond_ipv6.c                    |  225 -
 drivers/net/bonding/bond_main.c                    |   83 +-
 drivers/net/caif/caif_hsi.c                        |   13 +-
 drivers/net/caif/caif_serial.c                     |   10 +-
 drivers/net/caif/caif_shmcore.c                    |   27 +-
 drivers/net/caif/caif_spi.c                        |  178 +-
 drivers/net/can/Kconfig                            |    2 +
 drivers/net/can/Makefile                           |    1 +
 drivers/net/can/at91_can.c                         |   13 +-
 drivers/net/can/bfin_can.c                         |   12 +-
 drivers/net/can/c_can/c_can_platform.c             |   12 +-
 drivers/net/can/cc770/Kconfig                      |   21 +
 drivers/net/can/cc770/Makefile                     |    9 +
 drivers/net/can/cc770/cc770.c                      |  881 +++
 drivers/net/can/cc770/cc770.h                      |  203 +
 drivers/net/can/cc770/cc770_isa.c                  |  367 ++
 drivers/net/can/cc770/cc770_platform.c             |  272 +
 drivers/net/can/dev.c                              |    2 +-
 drivers/net/can/flexcan.c                          |   15 +-
 drivers/net/can/janz-ican3.c                       |   13 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |   12 +-
 drivers/net/can/mscan/mscan.c                      |    8 +-
 drivers/net/can/sja1000/Kconfig                    |    1 -
 drivers/net/can/sja1000/sja1000_isa.c              |  118 +-
 drivers/net/can/sja1000/sja1000_of_platform.c      |   12 +-
 drivers/net/can/sja1000/sja1000_platform.c         |   13 +-
 drivers/net/can/slcan.c                            |    2 +-
 drivers/net/can/softing/softing_main.c             |   16 +-
 drivers/net/can/ti_hecc.c                          |   15 +-
 drivers/net/can/vcan.c                             |    2 +-
 drivers/net/dsa/Kconfig                            |   36 +
 drivers/net/dsa/Makefile                           |    9 +
 {net => drivers/net}/dsa/mv88e6060.c               |    7 +-
 {net => drivers/net}/dsa/mv88e6123_61_65.c         |   19 +-
 {net => drivers/net}/dsa/mv88e6131.c               |   20 +-
 {net => drivers/net}/dsa/mv88e6xxx.c               |   29 +-
 {net => drivers/net}/dsa/mv88e6xxx.h               |    3 +
 drivers/net/dummy.c                                |    2 +-
 drivers/net/ethernet/3com/3c589_cs.c               |    7 +-
 drivers/net/ethernet/3com/3c59x.c                  |   12 +-
 drivers/net/ethernet/3com/typhoon.c                |   16 +-
 drivers/net/ethernet/8390/8390.h                   |    2 -
 drivers/net/ethernet/8390/apne.c                   |    2 +-
 drivers/net/ethernet/8390/ax88796.c                |   18 +-
 drivers/net/ethernet/8390/es3210.c                 |    2 +-
 drivers/net/ethernet/8390/hp-plus.c                |    2 +-
 drivers/net/ethernet/8390/hp.c                     |    2 +-
 drivers/net/ethernet/8390/hydra.c                  |    2 +-
 drivers/net/ethernet/8390/lne390.c                 |    4 +-
 drivers/net/ethernet/8390/ne-h8300.c               |    2 +-
 drivers/net/ethernet/8390/ne.c                     |    4 +-
 drivers/net/ethernet/8390/ne2.c                    |    2 +-
 drivers/net/ethernet/8390/ne2k-pci.c               |    6 +-
 drivers/net/ethernet/8390/ne3210.c                 |    2 +-
 drivers/net/ethernet/8390/stnic.c                  |    2 +-
 drivers/net/ethernet/8390/zorro8390.c              |    2 +-
 drivers/net/ethernet/Kconfig                       |    1 +
 drivers/net/ethernet/Makefile                      |    1 +
 drivers/net/ethernet/adaptec/starfire.c            |   14 +-
 drivers/net/ethernet/aeroflex/greth.c              |   13 +-
 drivers/net/ethernet/amd/amd8111e.c                |   15 +-
 drivers/net/ethernet/amd/amd8111e.h                |    5 +-
 drivers/net/ethernet/amd/au1000_eth.c              |   15 +-
 drivers/net/ethernet/amd/nmclan_cs.c               |   19 +-
 drivers/net/ethernet/amd/pcnet32.c                 |   10 +-
 drivers/net/ethernet/amd/sunlance.c                |   15 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c |    1 -
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   13 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c |   10 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   13 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |    1 -
 drivers/net/ethernet/atheros/atlx/atl2.c           |   23 +-
 drivers/net/ethernet/atheros/atlx/atlx.c           |   13 +-
 drivers/net/ethernet/broadcom/bnx2.c               |  196 +-
 drivers/net/ethernet/broadcom/bnx2.h               |   17 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   70 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  366 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |  116 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c    |   61 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h    |    4 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |   76 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h    |  217 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   | 1060 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h   |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  478 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h    |   69 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c     |   35 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h     |   13 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c  |  112 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h  |    6 +
 drivers/net/ethernet/broadcom/cnic.c               |  130 +-
 drivers/net/ethernet/broadcom/cnic_defs.h          |    1 +
 drivers/net/ethernet/broadcom/cnic_if.h            |   16 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c         |   16 +-
 drivers/net/ethernet/broadcom/tg3.c                |  707 ++-
 drivers/net/ethernet/broadcom/tg3.h                |   44 +-
 drivers/net/ethernet/brocade/bna/Makefile          |    2 +-
 drivers/net/ethernet/brocade/bna/bfa_cee.c         |   35 +
 drivers/net/ethernet/brocade/bna/bfa_cee.h         |    4 +-
 drivers/net/ethernet/brocade/bna/bfa_defs.h        |   98 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c         |  493 ++
 drivers/net/ethernet/brocade/bna/bfa_ioc.h         |   54 +
 drivers/net/ethernet/brocade/bna/bfi.h             |   97 +
 drivers/net/ethernet/brocade/bna/bna_enet.c        |   13 +-
 drivers/net/ethernet/brocade/bna/bna_types.h       |    7 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |   70 +-
 drivers/net/ethernet/brocade/bna/bnad.h            |   29 +-
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c    |  623 ++
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c    |  157 +-
 drivers/net/ethernet/brocade/bna/cna.h             |    3 +-
 drivers/net/ethernet/brocade/bna/cna_fwimg.c       |    1 +
 drivers/net/ethernet/calxeda/Kconfig               |    7 +
 drivers/net/ethernet/calxeda/Makefile              |    1 +
 drivers/net/ethernet/calxeda/xgmac.c               | 1928 ++++++
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |   15 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c            |    2 +-
 drivers/net/ethernet/chelsio/cxgb/sge.h            |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   21 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c |   26 +-
 drivers/net/ethernet/chelsio/cxgb3/l2t.c           |   27 +-
 drivers/net/ethernet/chelsio/cxgb3/l2t.h           |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   56 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |    6 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   17 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c         |    5 +-
 drivers/net/ethernet/cisco/enic/enic_dev.c         |   14 +-
 drivers/net/ethernet/cisco/enic/enic_dev.h         |    4 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   10 +-
 drivers/net/ethernet/davicom/dm9000.c              |    5 +-
 drivers/net/ethernet/dec/tulip/de2104x.c           |    6 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |   13 +-
 drivers/net/ethernet/dec/tulip/dmfe.c              |    7 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |    6 +-
 drivers/net/ethernet/dec/tulip/uli526x.c           |    7 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |    6 +-
 drivers/net/ethernet/dlink/de600.c                 |    2 +-
 drivers/net/ethernet/dlink/sundance.c              |    6 +-
 drivers/net/ethernet/dnet.c                        |   19 +-
 drivers/net/ethernet/emulex/benet/be.h             |   39 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |  237 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h        |   84 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  120 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |  586 ++-
 drivers/net/ethernet/ethoc.c                       |   13 +-
 drivers/net/ethernet/fealnx.c                      |    6 +-
 drivers/net/ethernet/freescale/Kconfig             |    2 +-
 drivers/net/ethernet/freescale/fec.c               |   68 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |   15 +-
 .../net/ethernet/freescale/fs_enet/mii-bitbang.c   |   13 +-
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c   |   13 +-
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |   16 +-
 drivers/net/ethernet/freescale/gianfar.c           |   28 +-
 drivers/net/ethernet/freescale/gianfar.h           |    7 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |   12 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c       |   16 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |    2 +-
 drivers/net/ethernet/freescale/ucc_geth.h          |    6 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |    7 +-
 drivers/net/ethernet/i825xx/eepro.c                |    7 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   21 +-
 drivers/net/ethernet/ibm/emac/core.c               |    3 +
 drivers/net/ethernet/ibm/ibmveth.c                 |    6 +-
 drivers/net/ethernet/icplus/ipg.c                  |   13 +-
 drivers/net/ethernet/intel/e100.c                  |    8 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |   12 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.h        |    5 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   61 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |    1 +
 drivers/net/ethernet/intel/e1000e/ethtool.c        |   18 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |  465 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c       |    5 +-
 drivers/net/ethernet/intel/igb/igb.h               |    5 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   37 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  359 +-
 drivers/net/ethernet/intel/igbvf/ethtool.c         |   10 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |   37 +-
 drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c     |   10 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |   22 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c     |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |   10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c    |   96 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   31 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |   83 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   49 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |   13 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h     |    1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |   10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c      |   18 +-
 drivers/net/ethernet/intel/ixgbevf/defines.h       |    1 -
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |   16 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   40 +-
 drivers/net/ethernet/intel/ixgbevf/mbx.h           |    4 +-
 drivers/net/ethernet/intel/ixgbevf/regs.h          |   42 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c            |    4 +-
 drivers/net/ethernet/jme.c                         |   16 +-
 drivers/net/ethernet/korina.c                      |   13 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   14 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |   13 +-
 drivers/net/ethernet/marvell/skge.c                |   12 +-
 drivers/net/ethernet/marvell/sky2.c                |   39 +-
 drivers/net/ethernet/mellanox/mlx4/Makefile        |    2 +-
 drivers/net/ethernet/mellanox/mlx4/catas.c         |    7 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           | 1332 ++++-
 drivers/net/ethernet/mellanox/mlx4/cq.c            |  141 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c         |    7 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   31 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   60 +-
 drivers/net/ethernet/mellanox/mlx4/en_port.c       |   84 +-
 drivers/net/ethernet/mellanox/mlx4/en_port.h       |   43 -
 drivers/net/ethernet/mellanox/mlx4/en_resources.c  |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   31 +-
 drivers/net/ethernet/mellanox/mlx4/en_selftest.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   96 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |  430 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  415 ++-
 drivers/net/ethernet/mellanox/mlx4/fw.h            |   28 +
 drivers/net/ethernet/mellanox/mlx4/icm.c           |    5 +-
 drivers/net/ethernet/mellanox/mlx4/intf.c          |    6 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  902 +++-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |  228 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |  670 ++-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   17 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c            |  486 ++-
 drivers/net/ethernet/mellanox/mlx4/pd.c            |   19 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          |  616 ++-
 drivers/net/ethernet/mellanox/mlx4/profile.c       |    9 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |  238 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  | 3104 ++++++++++
 drivers/net/ethernet/mellanox/mlx4/sense.c         |    3 +-
 drivers/net/ethernet/mellanox/mlx4/srq.c           |  132 +-
 drivers/net/ethernet/micrel/Kconfig                |    2 +
 drivers/net/ethernet/micrel/ks8842.c               |   13 +-
 drivers/net/ethernet/micrel/ks8851.c               |  513 +-
 drivers/net/ethernet/micrel/ks8851.h               |   15 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |   16 +-
 drivers/net/ethernet/micrel/ksz884x.c              |   77 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |    5 +-
 .../net/ethernet/myricom/myri10ge/myri10ge_mcp.h   |    2 +-
 drivers/net/ethernet/natsemi/jazzsonic.c           |   13 +-
 drivers/net/ethernet/natsemi/macsonic.c            |   13 +-
 drivers/net/ethernet/natsemi/natsemi.c             |    6 +-
 drivers/net/ethernet/natsemi/ns83820.c             |    6 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |   13 +-
 drivers/net/ethernet/neterion/s2io.c               |   11 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |   15 +-
 drivers/net/ethernet/nuvoton/w90p910_ether.c       |   13 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |  503 ++-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c    |    8 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    5 +-
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |   12 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    6 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |    9 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h        |    5 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |   13 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c     |    9 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   12 +-
 drivers/net/ethernet/qlogic/qlge/qlge_ethtool.c    |   11 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       |   48 +-
 drivers/net/ethernet/rdc/r6040.c                   |   42 +-
 drivers/net/ethernet/realtek/8139cp.c              |   19 +-
 drivers/net/ethernet/realtek/8139too.c             |    8 +-
 drivers/net/ethernet/realtek/r8169.c               |   22 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   19 +-
 drivers/net/ethernet/seeq/sgiseeq.c                |   18 +-
 drivers/net/ethernet/sfc/efx.c                     |    9 +-
 drivers/net/ethernet/sfc/efx.h                     |   20 +-
 drivers/net/ethernet/sfc/ethtool.c                 |  221 +-
 drivers/net/ethernet/sfc/falcon.c                  |    2 +-
 drivers/net/ethernet/sfc/filter.c                  |  310 +-
 drivers/net/ethernet/sfc/filter.h                  |   12 +
 drivers/net/ethernet/sfc/mtd.c                     |    6 +-
 drivers/net/ethernet/sfc/net_driver.h              |    2 +-
 drivers/net/ethernet/sfc/rx.c                      |    9 +-
 drivers/net/ethernet/sfc/selftest.c                |    4 +-
 drivers/net/ethernet/sfc/siena.c                   |    2 +-
 drivers/net/ethernet/sfc/tx.c                      |   29 +-
 drivers/net/ethernet/sgi/meth.c                    |   67 +-
 drivers/net/ethernet/sis/sis190.c                  |   15 +-
 drivers/net/ethernet/sis/sis900.c                  |    7 +-
 drivers/net/ethernet/smsc/epic100.c                |    6 +-
 drivers/net/ethernet/smsc/smc911x.c                |   13 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c            |    4 +-
 drivers/net/ethernet/smsc/smc91x.c                 |   13 +-
 drivers/net/ethernet/smsc/smsc911x.c               |  203 +-
 drivers/net/ethernet/smsc/smsc911x.h               |    4 +
 drivers/net/ethernet/smsc/smsc9420.c               |    7 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   27 +-
 drivers/net/ethernet/stmicro/stmmac/Makefile       |    2 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |    7 +
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |   13 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   13 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |    7 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  441 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |    3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |  221 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  198 +
 drivers/net/ethernet/sun/cassini.c                 |    7 +-
 drivers/net/ethernet/sun/niu.c                     |   42 +-
 drivers/net/ethernet/sun/sunbmac.c                 |   13 +-
 drivers/net/ethernet/sun/sungem.c                  |    6 +-
 drivers/net/ethernet/sun/sunhme.c                  |   18 +-
 drivers/net/ethernet/tehuti/tehuti.c               |    6 +-
 drivers/net/ethernet/ti/davinci_emac.c             |    8 +
 drivers/net/ethernet/tile/tilepro.c                |    4 +-
 drivers/net/ethernet/tundra/tsi108_eth.c           |   20 +-
 drivers/net/ethernet/via/via-rhine.c               |   21 +-
 drivers/net/ethernet/via/via-velocity.c            |   12 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   30 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   30 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    2 +-
 drivers/net/ifb.c                                  |    2 +-
 drivers/net/irda/bfin_sir.c                        |   13 +-
 drivers/net/irda/donauboe.c                        |    2 +-
 drivers/net/irda/pxaficp_ir.c                      |   13 +-
 drivers/net/irda/sh_irda.c                         |   13 +-
 drivers/net/irda/sh_sir.c                          |   13 +-
 drivers/net/irda/smsc-ircc2.c                      |    2 +-
 drivers/net/loopback.c                             |    2 +-
 drivers/net/macvlan.c                              |   14 +-
 drivers/net/macvtap.c                              |   24 +-
 drivers/net/mii.c                                  |   53 +-
 drivers/net/phy/Kconfig                            |    4 +
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/mdio-bitbang.c                     |    9 +
 drivers/net/phy/mdio-gpio.c                        |    1 +
 drivers/net/phy/phy_device.c                       |   20 +-
 drivers/net/phy/smsc.c                             |   21 +-
 drivers/net/phy/spi_ks8995.c                       |  375 ++
 drivers/net/ppp/pptp.c                             |    2 +-
 drivers/net/team/Kconfig                           |   43 +
 drivers/net/team/Makefile                          |    7 +
 drivers/net/team/team.c                            | 1684 +++++
 drivers/net/team/team_mode_activebackup.c          |  136 +
 drivers/net/team/team_mode_roundrobin.c            |  107 +
 drivers/net/tun.c                                  |   16 +-
 drivers/net/usb/asix.c                             |    6 +-
 drivers/net/usb/cdc-phonet.c                       |   10 +-
 drivers/net/usb/cdc_ncm.c                          |    4 +-
 drivers/net/usb/pegasus.c                          |    8 +-
 drivers/net/usb/smsc75xx.c                         |    5 +-
 drivers/net/usb/smsc95xx.c                         |    5 +-
 drivers/net/veth.c                                 |    9 +-
 drivers/net/virtio_net.c                           |   48 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   11 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   46 +-
 drivers/net/vmxnet3/vmxnet3_int.h                  |    2 +-
 drivers/net/wan/sbni.c                             |    2 +-
 drivers/net/wan/sealevel.c                         |    2 +-
 drivers/net/wimax/i2400m/tx.c                      |    8 +-
 drivers/net/wimax/i2400m/usb-tx.c                  |    7 +-
 drivers/net/wireless/Makefile                      |    8 +-
 drivers/net/wireless/airo.c                        |    4 +-
 drivers/net/wireless/ath/Makefile                  |    1 +
 drivers/net/wireless/ath/ath.h                     |   14 +-
 drivers/net/wireless/ath/ath5k/ahb.c               |    4 +-
 drivers/net/wireless/ath/ath5k/ani.c               |   91 +-
 drivers/net/wireless/ath/ath5k/ani.h               |   32 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |  571 ++-
 drivers/net/wireless/ath/ath5k/attach.c            |   16 +-
 drivers/net/wireless/ath/ath5k/base.c              |  293 +-
 drivers/net/wireless/ath/ath5k/caps.c              |   27 +-
 drivers/net/wireless/ath/ath5k/desc.c              |  217 +-
 drivers/net/wireless/ath/ath5k/desc.h              |  124 +-
 drivers/net/wireless/ath/ath5k/dma.c               |  370 +-
 drivers/net/wireless/ath/ath5k/gpio.c              |   81 +-
 drivers/net/wireless/ath/ath5k/initvals.c          |   75 +-
 drivers/net/wireless/ath/ath5k/pci.c               |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |  222 +-
 drivers/net/wireless/ath/ath5k/phy.c               |  853 ++-
 drivers/net/wireless/ath/ath5k/qcu.c               |  143 +-
 drivers/net/wireless/ath/ath5k/reg.h               |   27 +-
 drivers/net/wireless/ath/ath5k/reset.c             |  234 +-
 drivers/net/wireless/ath/ath5k/rfbuffer.h          |   59 +-
 drivers/net/wireless/ath/ath5k/rfgain.h            |   22 +-
 drivers/net/wireless/ath/ath5k/trace.h             |    5 +-
 drivers/net/wireless/ath/ath6kl/Makefile           |    2 +-
 drivers/net/wireless/ath/ath6kl/bmi.c              |  244 +-
 drivers/net/wireless/ath/ath6kl/bmi.h              |    8 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         | 1695 ++++--
 drivers/net/wireless/ath/ath6kl/cfg80211.h         |   32 +-
 drivers/net/wireless/ath/ath6kl/common.h           |   17 +-
 drivers/net/wireless/ath/ath6kl/core.h             |  309 +-
 drivers/net/wireless/ath/ath6kl/debug.c            |  849 +++-
 drivers/net/wireless/ath/ath6kl/debug.h            |   34 +-
 drivers/net/wireless/ath/ath6kl/hif-ops.h          |   79 +-
 .../net/wireless/ath/ath6kl/{htc_hif.c => hif.c}   |  150 +-
 drivers/net/wireless/ath/ath6kl/hif.h              |   66 +-
 drivers/net/wireless/ath/ath6kl/htc.c              |  725 ++-
 drivers/net/wireless/ath/ath6kl/htc.h              |   18 +-
 drivers/net/wireless/ath/ath6kl/htc_hif.h          |   92 -
 drivers/net/wireless/ath/ath6kl/init.c             | 1013 ++--
 drivers/net/wireless/ath/ath6kl/main.c             |  771 +--
 drivers/net/wireless/ath/ath6kl/sdio.c             |  660 ++-
 drivers/net/wireless/ath/ath6kl/target.h           |   19 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |  219 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |  834 ++-
 drivers/net/wireless/ath/ath6kl/wmi.h              |  386 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |   31 +
 drivers/net/wireless/ath/ath9k/Makefile            |    6 +-
 drivers/net/wireless/ath/ath9k/ani.c               |   29 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   42 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |  136 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |  155 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |  223 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   45 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.h        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c        | 1493 +++++
 drivers/net/wireless/ath/ath9k/ar9003_mci.h        |  102 +
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |   17 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   48 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |    5 +
 drivers/net/wireless/ath/ath9k/ar9003_rtt.c        |    1 +
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |   60 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   19 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   46 +-
 drivers/net/wireless/ath/ath9k/btcoex.c            |  135 +-
 drivers/net/wireless/ath/ath9k/btcoex.h            |   41 +-
 drivers/net/wireless/ath/ath9k/calib.c             |   20 +-
 drivers/net/wireless/ath/ath9k/debug.c             |   18 +-
 drivers/net/wireless/ath/ath9k/debug.h             |    2 +
 drivers/net/wireless/ath/ath9k/dfs.c               |  215 +
 drivers/net/wireless/ath/ath9k/dfs.h               |   43 +
 drivers/net/wireless/ath/ath9k/dfs_debug.c         |   81 +
 drivers/net/wireless/ath/ath9k/dfs_debug.h         |   57 +
 drivers/net/wireless/ath/ath9k/eeprom.c            |    3 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |    3 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |   29 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |   20 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |   36 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |   28 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |   51 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c      |   20 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   25 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   93 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   13 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |    9 +
 drivers/net/wireless/ath/ath9k/hw.c                |  282 +-
 drivers/net/wireless/ath/ath9k/hw.h                |  243 +-
 drivers/net/wireless/ath/ath9k/init.c              |   66 +-
 drivers/net/wireless/ath/ath9k/mac.c               |   53 +-
 drivers/net/wireless/ath/ath9k/main.c              |  333 +-
 drivers/net/wireless/ath/ath9k/mci.c               |  668 ++
 drivers/net/wireless/ath/ath9k/mci.h               |  134 +
 drivers/net/wireless/ath/ath9k/pci.c               |   23 +-
 drivers/net/wireless/ath/ath9k/rc.c                |    7 +-
 drivers/net/wireless/ath/ath9k/recv.c              |   52 +-
 drivers/net/wireless/ath/ath9k/reg.h               |  321 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |    8 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  359 +-
 drivers/net/wireless/ath/carl9170/fw.c             |   97 +-
 drivers/net/wireless/ath/carl9170/main.c           |   14 +-
 drivers/net/wireless/ath/carl9170/tx.c             |    4 +-
 drivers/net/wireless/ath/key.c                     |    8 +-
 drivers/net/wireless/ath/regd.c                    |   77 +-
 drivers/net/wireless/b43/b43.h                     |   20 +-
 drivers/net/wireless/b43/dma.c                     |   27 +-
 drivers/net/wireless/b43/leds.c                    |   16 +-
 drivers/net/wireless/b43/lo.c                      |    8 +-
 drivers/net/wireless/b43/main.c                    |  155 +-
 drivers/net/wireless/b43/phy_common.c              |    8 +-
 drivers/net/wireless/b43/phy_g.c                   |   34 +-
 drivers/net/wireless/b43/phy_lp.c                  |    8 +-
 drivers/net/wireless/b43/phy_n.c                   | 4460 ++++++++------
 drivers/net/wireless/b43/phy_n.h                   |   14 +
 drivers/net/wireless/b43/pio.c                     |    6 +-
 drivers/net/wireless/b43/radio_2056.c              |   25 +-
 drivers/net/wireless/b43/radio_2056.h              |    1 +
 drivers/net/wireless/b43/tables_nphy.c             |  183 +-
 drivers/net/wireless/b43/tables_nphy.h             |   31 +-
 drivers/net/wireless/b43/xmit.c                    |    4 +-
 drivers/net/wireless/b43legacy/b43legacy.h         |   20 +
 drivers/net/wireless/b43legacy/dma.c               |   81 +-
 drivers/net/wireless/b43legacy/dma.h               |    5 +-
 drivers/net/wireless/b43legacy/leds.c              |    4 +-
 drivers/net/wireless/b43legacy/main.c              |  150 +-
 drivers/net/wireless/b43legacy/radio.c             |   20 +-
 drivers/net/wireless/brcm80211/Kconfig             |   21 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |   21 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h  |   32 -
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |  153 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  218 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  140 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   96 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   50 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   38 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   15 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  711 +--
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    7 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c | 1292 ++---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  607 ++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |  136 +
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   41 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   50 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    9 -
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  | 1251 +----
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |  224 +-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |   13 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |  118 -
 drivers/net/wireless/brcm80211/brcmsmac/d11.h      |    3 +
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |  469 +-
 drivers/net/wireless/brcm80211/brcmsmac/dma.h      |   12 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  328 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     | 1408 ++---
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |   29 +-
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c   |  241 +-
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h   |   11 +-
 drivers/net/wireless/brcm80211/brcmsmac/otp.c      |   76 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |  241 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_hal.h  |    4 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_int.h  |   11 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  101 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |  122 +-
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |  271 +-
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h      |    5 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |   44 +-
 drivers/net/wireless/brcm80211/brcmsmac/rate.h     |    5 +-
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |  503 +--
 drivers/net/wireless/brcm80211/brcmsmac/srom.h     |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/types.h    |   54 +-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |  218 +-
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   30 +-
 .../net/wireless/brcm80211/include/chipcommon.h    |    2 +
 drivers/net/wireless/brcm80211/include/defs.h      |    1 -
 drivers/net/wireless/brcm80211/include/soc.h       |   12 +-
 drivers/net/wireless/hostap/hostap_cs.c            |    3 +
 drivers/net/wireless/hostap/hostap_ioctl.c         |    4 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |    7 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |   15 +-
 drivers/net/wireless/ipw2x00/libipw.h              |   12 -
 drivers/net/wireless/ipw2x00/libipw_wx.c           |   25 -
 drivers/net/wireless/iwlegacy/3945-debug.c         |  505 ++
 drivers/net/wireless/iwlegacy/3945-mac.c           | 3976 ++++++++++++
 drivers/net/wireless/iwlegacy/3945-rs.c            |  986 +++
 drivers/net/wireless/iwlegacy/3945.c               | 2743 ++++++++
 drivers/net/wireless/iwlegacy/3945.h               |  607 ++
 .../iwlegacy/{iwl-4965-calib.c => 4965-calib.c}    |  613 +-
 drivers/net/wireless/iwlegacy/4965-debug.c         |  746 +++
 drivers/net/wireless/iwlegacy/4965-mac.c           | 6515 ++++++++++++++++++++
 drivers/net/wireless/iwlegacy/4965-rs.c            | 2860 +++++++++
 drivers/net/wireless/iwlegacy/4965.c               | 2402 ++++++++
 drivers/net/wireless/iwlegacy/4965.h               | 1301 ++++
 drivers/net/wireless/iwlegacy/Kconfig              |   43 +-
 drivers/net/wireless/iwlegacy/Makefile             |   24 +-
 .../iwlegacy/{iwl-commands.h => commands.h}        | 1134 ++--
 drivers/net/wireless/iwlegacy/common.c             | 5867 ++++++++++++++++++
 drivers/net/wireless/iwlegacy/common.h             | 3246 ++++++++++
 drivers/net/wireless/iwlegacy/{iwl-csr.h => csr.h} |   93 +-
 drivers/net/wireless/iwlegacy/debug.c              | 1411 +++++
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c   |  523 --
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h   |   60 -
 drivers/net/wireless/iwlegacy/iwl-3945-fh.h        |  187 -
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h        |  291 -
 drivers/net/wireless/iwlegacy/iwl-3945-led.c       |   63 -
 drivers/net/wireless/iwlegacy/iwl-3945-led.h       |   32 -
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c        |  996 ---
 drivers/net/wireless/iwlegacy/iwl-3945.c           | 2741 --------
 drivers/net/wireless/iwlegacy/iwl-3945.h           |  308 -
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c   |  774 ---
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h   |   59 -
 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c    |  154 -
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h        |  811 ---
 drivers/net/wireless/iwlegacy/iwl-4965-led.c       |   73 -
 drivers/net/wireless/iwlegacy/iwl-4965-led.h       |   33 -
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c       | 1194 ----
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c        | 2871 ---------
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c        |  215 -
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c       |  721 ---
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c        | 1378 -----
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c     |  166 -
 drivers/net/wireless/iwlegacy/iwl-4965.c           | 2183 -------
 drivers/net/wireless/iwlegacy/iwl-4965.h           |  282 -
 drivers/net/wireless/iwlegacy/iwl-core.c           | 2661 --------
 drivers/net/wireless/iwlegacy/iwl-core.h           |  636 --
 drivers/net/wireless/iwlegacy/iwl-debug.h          |  198 -
 drivers/net/wireless/iwlegacy/iwl-debugfs.c        | 1314 ----
 drivers/net/wireless/iwlegacy/iwl-dev.h            | 1364 ----
 drivers/net/wireless/iwlegacy/iwl-devtrace.c       |   42 -
 drivers/net/wireless/iwlegacy/iwl-devtrace.h       |  210 -
 drivers/net/wireless/iwlegacy/iwl-eeprom.c         |  553 --
 drivers/net/wireless/iwlegacy/iwl-eeprom.h         |  344 --
 drivers/net/wireless/iwlegacy/iwl-fh.h             |  513 --
 drivers/net/wireless/iwlegacy/iwl-hcmd.c           |  271 -
 drivers/net/wireless/iwlegacy/iwl-helpers.h        |  196 -
 drivers/net/wireless/iwlegacy/iwl-io.h             |  545 --
 drivers/net/wireless/iwlegacy/iwl-led.c            |  205 -
 drivers/net/wireless/iwlegacy/iwl-led.h            |   56 -
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h      |  456 --
 drivers/net/wireless/iwlegacy/iwl-power.c          |  165 -
 drivers/net/wireless/iwlegacy/iwl-power.h          |   55 -
 drivers/net/wireless/iwlegacy/iwl-rx.c             |  282 -
 drivers/net/wireless/iwlegacy/iwl-scan.c           |  550 --
 drivers/net/wireless/iwlegacy/iwl-spectrum.h       |    4 +-
 drivers/net/wireless/iwlegacy/iwl-sta.c            |  817 ---
 drivers/net/wireless/iwlegacy/iwl-sta.h            |  148 -
 drivers/net/wireless/iwlegacy/iwl-tx.c             |  659 --
 drivers/net/wireless/iwlegacy/iwl3945-base.c       | 4016 ------------
 drivers/net/wireless/iwlegacy/iwl4965-base.c       | 3281 ----------
 .../net/wireless/iwlegacy/{iwl-prph.h => prph.h}   |  133 +-
 drivers/net/wireless/iwlwifi/Kconfig               |   30 +-
 drivers/net/wireless/iwlwifi/Makefile              |    6 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |   23 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c            |   62 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |   48 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |   58 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c       |   84 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h       |    4 -
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         |  436 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |   37 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c          |   78 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c        |   27 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c         |   98 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |  360 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             | 1909 +-----
 drivers/net/wireless/iwlwifi/iwl-agn.h             |   62 +-
 drivers/net/wireless/iwlwifi/iwl-bus.h             |   16 +-
 drivers/net/wireless/iwlwifi/iwl-cfg.h             |    6 -
 drivers/net/wireless/iwlwifi/iwl-commands.h        |  111 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  381 +--
 drivers/net/wireless/iwlwifi/iwl-core.h            |   92 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h           |  102 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |   49 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |  190 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h        |   52 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |  252 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |    7 +-
 drivers/net/wireless/iwlwifi/iwl-io.c              |   21 +-
 drivers/net/wireless/iwlwifi/iwl-io.h              |    5 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |    8 +-
 drivers/net/wireless/iwlwifi/iwl-led.h             |   14 -
 drivers/net/wireless/iwlwifi/iwl-mac80211.c        | 1601 +++++
 drivers/net/wireless/iwlwifi/iwl-pci.c             |   30 +-
 drivers/net/wireless/iwlwifi/iwl-power.c           |    8 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |   66 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h          |  237 +-
 .../iwlwifi/{iwl-sv-open.c => iwl-testmode.c}      |  265 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.h        |   66 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h  |   53 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c   |  140 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c   |  188 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      |  181 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |   94 +-
 .../iwlwifi/{iwl-agn-ucode.c => iwl-ucode.c}       |  418 +-
 .../iwl-4965-calib.h => iwlwifi/iwl-wifi.h}        |   21 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |   15 +-
 drivers/net/wireless/iwmc3200wifi/main.c           |    6 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |   12 +-
 drivers/net/wireless/libertas/cfg.c                |   35 +-
 drivers/net/wireless/libertas/ethtool.c            |    7 +-
 drivers/net/wireless/libertas/if_cs.c              |    4 +-
 drivers/net/wireless/libertas/if_spi.c             |    1 -
 drivers/net/wireless/libertas_tf/main.c            |    4 +-
 drivers/net/wireless/mac80211_hwsim.c              |   27 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c       |   18 +-
 drivers/net/wireless/mwifiex/Kconfig               |    4 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |  323 +-
 drivers/net/wireless/mwifiex/cfg80211.h            |    1 -
 drivers/net/wireless/mwifiex/cfp.c                 |   38 +-
 drivers/net/wireless/mwifiex/fw.h                  |    5 +-
 drivers/net/wireless/mwifiex/init.c                |   46 +-
 drivers/net/wireless/mwifiex/ioctl.h               |   11 -
 drivers/net/wireless/mwifiex/join.c                |  106 +-
 drivers/net/wireless/mwifiex/main.c                |   13 +-
 drivers/net/wireless/mwifiex/main.h                |   26 +-
 drivers/net/wireless/mwifiex/pcie.c                |   27 +-
 drivers/net/wireless/mwifiex/scan.c                |   28 +-
 drivers/net/wireless/mwifiex/sdio.c                |   43 +-
 drivers/net/wireless/mwifiex/sdio.h                |    1 +
 drivers/net/wireless/mwifiex/sta_cmd.c             |    2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c         |    2 +-
 drivers/net/wireless/mwifiex/sta_event.c           |   23 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   69 +-
 drivers/net/wireless/mwifiex/sta_rx.c              |   12 +-
 drivers/net/wireless/mwifiex/txrx.c                |    5 +-
 drivers/net/wireless/mwl8k.c                       |  162 +-
 drivers/net/wireless/orinoco/main.c                |    2 +-
 drivers/net/wireless/orinoco/scan.c                |   16 +-
 drivers/net/wireless/p54/main.c                    |    2 +-
 drivers/net/wireless/p54/p54spi.c                  |    7 +-
 drivers/net/wireless/p54/txrx.c                    |    4 +-
 drivers/net/wireless/prism54/isl_ioctl.c           |  333 -
 drivers/net/wireless/prism54/isl_ioctl.h           |    2 -
 drivers/net/wireless/prism54/islpci_dev.c          |    5 +-
 drivers/net/wireless/ray_cs.c                      |    4 +-
 drivers/net/wireless/rayctl.h                      |    4 +-
 drivers/net/wireless/rndis_wlan.c                  |  109 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2800.h               |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |   53 +-
 drivers/net/wireless/rt2x00/rt2800pci.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |   69 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c            |   16 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    2 +-
 drivers/net/wireless/rtlwifi/base.c                |   10 +-
 drivers/net/wireless/rtlwifi/base.h                |    2 +-
 drivers/net/wireless/rtlwifi/pci.c                 |   42 +-
 drivers/net/wireless/rtlwifi/ps.c                  |   22 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c  |   62 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h  |   23 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |   11 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c       |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |   40 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c        |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c        |    4 +-
 drivers/net/wireless/rtlwifi/usb.c                 |   55 +-
 drivers/net/wireless/rtlwifi/wifi.h                |   14 +-
 drivers/net/wireless/wl1251/spi.c                  |    1 -
 drivers/net/wireless/wl12xx/Kconfig                |   10 -
 drivers/net/wireless/wl12xx/Makefile               |    3 -
 drivers/net/wireless/wl12xx/acx.c                  |  172 +-
 drivers/net/wireless/wl12xx/acx.h                  |   91 +-
 drivers/net/wireless/wl12xx/boot.c                 |   15 +
 drivers/net/wireless/wl12xx/cmd.c                  |  371 +-
 drivers/net/wireless/wl12xx/cmd.h                  |   50 +-
 drivers/net/wireless/wl12xx/conf.h                 |    4 +
 drivers/net/wireless/wl12xx/debug.h                |  101 +
 drivers/net/wireless/wl12xx/debugfs.c              |  157 +-
 drivers/net/wireless/wl12xx/event.c                |  216 +-
 drivers/net/wireless/wl12xx/event.h                |    3 -
 drivers/net/wireless/wl12xx/init.c                 |  491 +-
 drivers/net/wireless/wl12xx/init.h                 |    8 +-
 drivers/net/wireless/wl12xx/io.c                   |   12 +-
 drivers/net/wireless/wl12xx/io.h                   |   23 +-
 drivers/net/wireless/wl12xx/main.c                 | 2062 ++++---
 drivers/net/wireless/wl12xx/ps.c                   |   62 +-
 drivers/net/wireless/wl12xx/ps.h                   |    9 +-
 drivers/net/wireless/wl12xx/reg.h                  |    2 +-
 drivers/net/wireless/wl12xx/rx.c                   |   38 +-
 drivers/net/wireless/wl12xx/scan.c                 |  120 +-
 drivers/net/wireless/wl12xx/scan.h                 |    8 +-
 drivers/net/wireless/wl12xx/sdio.c                 |  259 +-
 drivers/net/wireless/wl12xx/sdio_test.c            |  543 --
 drivers/net/wireless/wl12xx/spi.c                  |  215 +-
 drivers/net/wireless/wl12xx/testmode.c             |   77 +-
 drivers/net/wireless/wl12xx/tx.c                   |  382 +-
 drivers/net/wireless/wl12xx/tx.h                   |   11 +-
 drivers/net/wireless/wl12xx/wl12xx.h               |  386 +-
 drivers/net/wireless/wl12xx/wl12xx_80211.h         |    5 -
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |   25 +-
 drivers/net/xen-netback/interface.c                |    7 +-
 drivers/net/xen-netback/netback.c                  |    6 +-
 drivers/net/xen-netfront.c                         |   12 +-
 drivers/nfc/pn533.c                                |  170 +-
 drivers/s390/kvm/kvm_virtio.c                      |    6 +
 drivers/s390/net/netiucv.c                         |  217 +-
 drivers/s390/net/qeth_core_main.c                  |   45 +-
 drivers/s390/net/qeth_l2_main.c                    |   19 +-
 drivers/s390/net/qeth_l3_main.c                    |   32 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |    8 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   10 +-
 drivers/ssb/pci.c                                  |   23 +
 drivers/usb/gadget/f_phonet.c                      |   11 +-
 drivers/virtio/virtio_mmio.c                       |    6 +
 drivers/virtio/virtio_pci.c                        |    8 +
 fs/dlm/lowcomms.c                                  |    2 +-
 include/asm-generic/socket.h                       |    3 +
 include/linux/Kbuild                               |    3 +
 include/linux/atmdev.h                             |   10 -
 include/linux/bcma/bcma.h                          |   55 +-
 include/linux/bcma/bcma_driver_chipcommon.h        |    1 +
 include/linux/can/platform/cc770.h                 |   33 +
 include/linux/cgroup_subsys.h                      |    8 +
 include/linux/dynamic_queue_limits.h               |   97 +
 include/linux/eeprom_93cx6.h                       |    8 +
 include/linux/errqueue.h                           |    7 +-
 include/linux/ethtool.h                            |  116 +-
 include/linux/genetlink.h                          |   24 +
 include/linux/ieee80211.h                          |   32 +
 include/linux/if.h                                 |    1 +
 include/linux/if_ether.h                           |    1 +
 include/linux/if_team.h                            |  242 +
 include/linux/if_vlan.h                            |   80 +-
 include/linux/inet_diag.h                          |   43 +-
 include/linux/ipv6.h                               |    4 +-
 include/linux/lockd/lockd.h                        |    6 +-
 include/linux/mdio-bitbang.h                       |    2 +
 include/linux/mdio-gpio.h                          |    2 +
 include/linux/memcontrol.h                         |   23 +
 include/linux/mii.h                                |  200 +
 include/linux/mlx4/cmd.h                           |   51 +-
 include/linux/mlx4/device.h                        |   80 +-
 include/linux/mlx4/qp.h                            |   28 +
 include/linux/neighbour.h                          |    1 +
 include/linux/netdev_features.h                    |  146 +
 include/linux/netdevice.h                          |  343 +-
 include/linux/netfilter.h                          |   26 +-
 include/linux/netfilter/Kbuild                     |    4 +
 include/linux/netfilter/nf_conntrack_common.h      |    4 +
 .../linux/netfilter/nf_conntrack_tuple_common.h    |   27 +
 include/linux/netfilter/nf_nat.h                   |   25 +
 include/linux/netfilter/nfnetlink.h                |    3 +-
 include/linux/netfilter/nfnetlink_acct.h           |   36 +
 include/linux/netfilter/xt_CT.h                    |    3 +-
 include/linux/netfilter/xt_ecn.h                   |   35 +
 include/linux/netfilter/xt_nfacct.h                |   13 +
 include/linux/netfilter/xt_rpfilter.h              |   23 +
 include/linux/netfilter_ipv4/Kbuild                |    1 -
 include/linux/netfilter_ipv4/ipt_ecn.h             |   38 +-
 include/linux/netfilter_ipv4/nf_nat.h              |   58 -
 include/linux/netlink.h                            |    4 +-
 include/linux/nfc.h                                |   31 +-
 include/linux/nl80211.h                            |  171 +-
 include/linux/openvswitch.h                        |  452 ++
 include/linux/phonet.h                             |    2 +
 include/linux/pkt_sched.h                          |   32 +-
 include/linux/skbuff.h                             |   86 +-
 include/linux/smscphy.h                            |   25 +
 include/linux/sock_diag.h                          |   48 +
 include/linux/ssb/ssb.h                            |    9 +
 include/linux/ssb/ssb_regs.h                       |   17 +
 include/linux/sunrpc/clnt.h                        |    8 +-
 include/linux/tcp.h                                |    5 +
 include/linux/unix_diag.h                          |   54 +
 include/linux/virtio_config.h                      |   14 +
 include/linux/wl12xx.h                             |    5 +-
 include/net/addrconf.h                             |    3 +-
 include/net/af_unix.h                              |    6 +
 include/net/arp.h                                  |    2 +-
 include/net/atmclip.h                              |    7 -
 include/net/bluetooth/bluetooth.h                  |   56 +-
 include/net/bluetooth/hci.h                        |   83 +-
 include/net/bluetooth/hci_core.h                   |  366 +-
 include/net/bluetooth/l2cap.h                      |  457 ++-
 include/net/bluetooth/mgmt.h                       |  251 +-
 include/net/bluetooth/smp.h                        |    6 +
 include/net/caif/caif_dev.h                        |   21 +
 include/net/caif/caif_layer.h                      |    4 -
 include/net/caif/caif_spi.h                        |    4 +-
 include/net/caif/cfcnfg.h                          |   23 +-
 include/net/caif/cfserl.h                          |    4 +-
 include/net/cfg80211.h                             |  269 +-
 include/net/dsa.h                                  |  144 +-
 include/net/dst.h                                  |    6 +-
 include/net/flow.h                                 |    5 +-
 include/net/flow_keys.h                            |   16 +
 include/net/genetlink.h                            |    2 +
 include/net/icmp.h                                 |    4 +-
 include/net/ieee80211_radiotap.h                   |    8 -
 include/net/ieee802154.h                           |    6 +
 include/net/inet6_hashtables.h                     |    4 +-
 include/net/inet_connection_sock.h                 |    6 +-
 include/net/inet_sock.h                            |    6 +-
 include/net/inet_timewait_sock.h                   |   12 +-
 include/net/inetpeer.h                             |    2 +-
 include/net/ip.h                                   |    8 +-
 include/net/ip6_fib.h                              |    7 +-
 include/net/ip6_route.h                            |    6 +-
 include/net/ip_vs.h                                |    8 +-
 include/net/ipv6.h                                 |   22 +-
 include/net/iucv/af_iucv.h                         |    2 -
 include/net/mac80211.h                             |   62 +-
 include/net/ndisc.h                                |   45 +-
 include/net/neighbour.h                            |   17 +-
 include/net/net_namespace.h                        |    2 +-
 include/net/netfilter/nf_conntrack_acct.h          |    4 +-
 include/net/netfilter/nf_conntrack_expect.h        |    1 -
 include/net/netfilter/nf_conntrack_tuple.h         |    1 -
 include/net/netfilter/nf_nat.h                     |   10 +-
 include/net/netfilter/nf_nat_core.h                |    2 +-
 include/net/netfilter/nf_nat_protocol.h            |   17 +-
 include/net/netfilter/nf_tproxy_core.h             |    2 +-
 include/net/netns/ipv4.h                           |    1 +
 include/net/netns/mib.h                            |    6 +-
 include/net/netns/xfrm.h                           |    2 +-
 include/net/netprio_cgroup.h                       |   57 +
 include/net/nfc/nci.h                              |  178 +-
 include/net/nfc/nci_core.h                         |   13 +-
 include/net/nfc/nfc.h                              |   24 +-
 include/net/protocol.h                             |   12 +-
 include/net/red.h                                  |  187 +-
 include/net/regulatory.h                           |    6 +
 include/net/sctp/sctp.h                            |    4 +-
 include/net/sctp/structs.h                         |    5 +-
 include/net/snmp.h                                 |    4 +-
 include/net/sock.h                                 |  277 +-
 include/net/tcp.h                                  |   25 +-
 include/net/tcp_memcontrol.h                       |   19 +
 include/net/udp.h                                  |   13 +-
 include/net/xfrm.h                                 |   12 +-
 init/Kconfig                                       |   11 +
 lib/Kconfig                                        |    3 +
 lib/Makefile                                       |    2 +
 lib/dynamic_queue_limits.c                         |  133 +
 lib/reciprocal_div.c                               |    2 +
 lib/vsprintf.c                                     |   19 +
 mm/memcontrol.c                                    |  100 +-
 net/8021q/vlan.c                                   |  126 +-
 net/8021q/vlan.h                                   |   43 +-
 net/8021q/vlan_core.c                              |  270 +-
 net/8021q/vlan_dev.c                               |  140 +-
 net/8021q/vlan_gvrp.c                              |    4 +-
 net/8021q/vlan_netlink.c                           |   10 +-
 net/8021q/vlanproc.c                               |   42 +-
 net/Kconfig                                        |   14 +
 net/Makefile                                       |    1 +
 net/atm/atm_misc.c                                 |    2 +-
 net/atm/br2684.c                                   |   38 +-
 net/atm/clip.c                                     |  159 +-
 net/atm/common.c                                   |   34 +-
 net/atm/common.h                                   |    1 +
 net/atm/pppoatm.c                                  |    4 +
 net/ax25/af_ax25.c                                 |   26 +-
 net/batman-adv/bat_sysfs.c                         |    4 +-
 net/batman-adv/bitarray.c                          |    2 +-
 net/batman-adv/gateway_client.c                    |  153 +-
 net/batman-adv/gateway_client.h                    |    5 +-
 net/batman-adv/gateway_common.c                    |    4 +-
 net/batman-adv/hash.c                              |    4 +-
 net/batman-adv/hash.h                              |   13 +-
 net/batman-adv/icmp_socket.c                       |   14 +-
 net/batman-adv/main.h                              |    2 +-
 net/batman-adv/originator.c                        |   13 +-
 net/batman-adv/originator.h                        |    2 +-
 net/batman-adv/routing.c                           |   21 +-
 net/batman-adv/soft-interface.c                    |   45 +-
 net/batman-adv/translation-table.c                 |  437 +-
 net/batman-adv/types.h                             |   14 +-
 net/batman-adv/vis.c                               |   23 +-
 net/bluetooth/Kconfig                              |   37 +-
 net/bluetooth/Makefile                             |    5 +-
 net/bluetooth/af_bluetooth.c                       |   11 +-
 net/bluetooth/bnep/Kconfig                         |    2 +-
 net/bluetooth/bnep/core.c                          |   17 +-
 net/bluetooth/cmtp/Kconfig                         |    2 +-
 net/bluetooth/cmtp/core.c                          |   13 +-
 net/bluetooth/hci_conn.c                           |  186 +-
 net/bluetooth/hci_core.c                           |  707 ++-
 net/bluetooth/hci_event.c                          |  474 +-
 net/bluetooth/hci_sock.c                           |   23 +-
 net/bluetooth/hci_sysfs.c                          |  131 +-
 net/bluetooth/hidp/Kconfig                         |    2 +-
 net/bluetooth/hidp/core.c                          |  157 +-
 net/bluetooth/l2cap_core.c                         | 1458 +++--
 net/bluetooth/l2cap_sock.c                         |  168 +-
 net/bluetooth/mgmt.c                               | 1886 ++++---
 net/bluetooth/rfcomm/Kconfig                       |    2 +-
 net/bluetooth/rfcomm/core.c                        |   36 +-
 net/bluetooth/rfcomm/sock.c                        |    2 +
 net/bluetooth/rfcomm/tty.c                         |   45 +-
 net/bluetooth/sco.c                                |   44 +-
 net/bluetooth/smp.c                                |  268 +-
 net/bridge/br.c                                    |    4 +-
 net/bridge/br_device.c                             |   14 +-
 net/bridge/br_fdb.c                                |  102 +-
 net/bridge/br_forward.c                            |    2 +-
 net/bridge/br_if.c                                 |    5 +-
 net/bridge/br_multicast.c                          |   45 +-
 net/bridge/br_netfilter.c                          |    4 +-
 net/bridge/br_private.h                            |    8 +-
 net/bridge/netfilter/ebt_ip6.c                     |    3 +-
 net/bridge/netfilter/ebt_log.c                     |    5 +-
 net/caif/Kconfig                                   |   11 +
 net/caif/Makefile                                  |    1 +
 net/caif/caif_dev.c                                |  273 +-
 net/caif/caif_usb.c                                |  208 +
 net/caif/cfcnfg.c                                  |   47 +-
 net/caif/cfpkt_skbuff.c                            |   15 +-
 net/caif/cfrfml.c                                  |    2 +-
 net/caif/cfserl.c                                  |    3 +-
 net/core/Makefile                                  |    6 +-
 net/core/dev.c                                     |  307 +-
 net/core/dst.c                                     |    2 +-
 net/core/ethtool.c                                 |  712 +--
 net/core/flow_dissector.c                          |  143 +
 net/core/neighbour.c                               |  222 +-
 net/core/net-sysfs.c                               |  323 +-
 net/core/netpoll.c                                 |   10 +-
 net/core/netprio_cgroup.c                          |  344 ++
 net/core/pktgen.c                                  |   17 +-
 net/core/rtnetlink.c                               |   25 +-
 net/core/secure_seq.c                              |    6 +-
 net/core/skbuff.c                                  |   89 +-
 net/core/sock.c                                    |  197 +-
 net/core/sock_diag.c                               |  192 +
 net/core/sysctl_net_core.c                         |    9 +-
 net/dccp/ccids/ccid2.c                             |    4 +-
 net/dccp/ccids/ccid3.c                             |    2 +-
 net/dccp/ccids/lib/tfrc.c                          |    2 +-
 net/dccp/ccids/lib/tfrc.h                          |    2 +-
 net/dccp/dccp.h                                    |    4 +-
 net/dccp/diag.c                                    |   20 +-
 net/dccp/feat.c                                    |   16 +-
 net/dccp/ipv4.c                                    |    5 +-
 net/dccp/ipv6.c                                    |   42 +-
 net/dccp/minisocks.c                               |    8 +-
 net/dccp/options.c                                 |    2 +-
 net/dccp/probe.c                                   |   14 +-
 net/dccp/proto.c                                   |    2 +-
 net/decnet/dn_neigh.c                              |    8 +-
 net/decnet/dn_route.c                              |    8 +-
 net/dsa/Kconfig                                    |   38 +-
 net/dsa/Makefile                                   |   19 +-
 net/dsa/dsa.c                                      |   51 +-
 net/dsa/dsa_priv.h                                 |  127 +-
 net/dsa/tag_dsa.c                                  |   15 +-
 net/dsa/tag_edsa.c                                 |   15 +-
 net/dsa/tag_trailer.c                              |   15 +-
 net/econet/af_econet.c                             |    7 +-
 net/ieee802154/6lowpan.c                           |  374 ++-
 net/ieee802154/6lowpan.h                           |   23 +
 net/ieee802154/dgram.c                             |    7 +-
 net/ieee802154/raw.c                               |    7 +-
 net/ipv4/Kconfig                                   |    4 +
 net/ipv4/Makefile                                  |    2 +
 net/ipv4/af_inet.c                                 |   13 +-
 net/ipv4/arp.c                                     |   40 +-
 net/ipv4/fib_rules.c                               |    1 +
 net/ipv4/fib_trie.c                                |    1 +
 net/ipv4/igmp.c                                    |   17 +-
 net/ipv4/inet_connection_sock.c                    |   19 +-
 net/ipv4/inet_diag.c                               |  470 +-
 net/ipv4/ip_gre.c                                  |   14 +-
 net/ipv4/ip_output.c                               |   23 +-
 net/ipv4/ip_sockglue.c                             |   41 +-
 net/ipv4/ipconfig.c                                |   15 +-
 net/ipv4/ipip.c                                    |    2 +-
 net/ipv4/ipmr.c                                    |    4 +-
 net/ipv4/netfilter/Kconfig                         |   18 +-
 net/ipv4/netfilter/Makefile                        |    2 +-
 net/ipv4/netfilter/ip_queue.c                      |    6 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                |   16 +-
 net/ipv4/netfilter/ipt_NETMAP.c                    |   14 +-
 net/ipv4/netfilter/ipt_REDIRECT.c                  |   16 +-
 net/ipv4/netfilter/ipt_ULOG.c                      |    2 +-
 net/ipv4/netfilter/ipt_ecn.c                       |  127 -
 net/ipv4/netfilter/ipt_rpfilter.c                  |  141 +
 net/ipv4/netfilter/iptable_filter.c                |    2 +-
 net/ipv4/netfilter/nf_nat_core.c                   |   96 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |   20 +-
 net/ipv4/netfilter/nf_nat_helper.c                 |   16 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |   14 +-
 net/ipv4/netfilter/nf_nat_proto_common.c           |   36 +-
 net/ipv4/netfilter/nf_nat_proto_dccp.c             |    6 +-
 net/ipv4/netfilter/nf_nat_proto_gre.c              |   10 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c             |    6 +-
 net/ipv4/netfilter/nf_nat_proto_sctp.c             |    6 +-
 net/ipv4/netfilter/nf_nat_proto_tcp.c              |    6 +-
 net/ipv4/netfilter/nf_nat_proto_udp.c              |    6 +-
 net/ipv4/netfilter/nf_nat_proto_udplite.c          |    6 +-
 net/ipv4/netfilter/nf_nat_proto_unknown.c          |    3 +-
 net/ipv4/netfilter/nf_nat_rule.c                   |   22 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |   10 +-
 net/ipv4/netfilter/nf_nat_standalone.c             |    2 +-
 net/ipv4/proc.c                                    |   15 +-
 net/ipv4/raw.c                                     |   10 +-
 net/ipv4/route.c                                   |   12 +-
 net/ipv4/syncookies.c                              |    2 +-
 net/ipv4/sysctl_net_ipv4.c                         |   69 +-
 net/ipv4/tcp.c                                     |   57 +-
 net/ipv4/tcp_cong.c                                |    2 +-
 net/ipv4/tcp_diag.c                                |   20 +-
 net/ipv4/tcp_input.c                               |   66 +-
 net/ipv4/tcp_ipv4.c                                |   15 +-
 net/ipv4/tcp_memcontrol.c                          |  272 +
 net/ipv4/tcp_minisocks.c                           |   12 +-
 net/ipv4/tcp_output.c                              |   27 +-
 net/ipv4/tcp_timer.c                               |    8 +-
 net/ipv4/tunnel4.c                                 |   10 +-
 net/ipv4/udp.c                                     |    9 +-
 net/ipv4/udp_diag.c                                |  201 +
 net/ipv4/xfrm4_tunnel.c                            |    6 +-
 net/ipv6/addrconf.c                                |   75 +-
 net/ipv6/af_inet6.c                                |   29 +-
 net/ipv6/ah6.c                                     |   12 +-
 net/ipv6/anycast.c                                 |    8 +-
 net/ipv6/datagram.c                                |   36 +-
 net/ipv6/exthdrs.c                                 |   18 +-
 net/ipv6/exthdrs_core.c                            |   11 +-
 net/ipv6/fib6_rules.c                              |    2 +-
 net/ipv6/icmp.c                                    |   25 +-
 net/ipv6/inet6_connection_sock.c                   |   12 +-
 net/ipv6/ip6_fib.c                                 |  234 +-
 net/ipv6/ip6_flowlabel.c                           |    2 +-
 net/ipv6/ip6_input.c                               |    3 +-
 net/ipv6/ip6_output.c                              |   35 +-
 net/ipv6/ip6_tunnel.c                              |   24 +-
 net/ipv6/ip6mr.c                                   |   12 +-
 net/ipv6/ipv6_sockglue.c                           |    8 +-
 net/ipv6/mcast.c                                   |   44 +-
 net/ipv6/mip6.c                                    |    4 +-
 net/ipv6/ndisc.c                                   |   54 +-
 net/ipv6/netfilter/Kconfig                         |   10 +
 net/ipv6/netfilter/Makefile                        |    1 +
 net/ipv6/netfilter/ip6_queue.c                     |    5 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |   11 +-
 net/ipv6/netfilter/ip6t_rpfilter.c                 |  133 +
 net/ipv6/netfilter/ip6table_filter.c               |    2 +-
 net/ipv6/proc.c                                    |   15 +-
 net/ipv6/raw.c                                     |   19 +-
 net/ipv6/reassembly.c                              |    4 +-
 net/ipv6/route.c                                   |  311 +-
 net/ipv6/sit.c                                     |   10 +-
 net/ipv6/syncookies.c                              |    8 +-
 net/ipv6/tcp_ipv6.c                                |   54 +-
 net/ipv6/udp.c                                     |   17 +-
 net/ipv6/xfrm6_mode_beet.c                         |    8 +-
 net/ipv6/xfrm6_mode_tunnel.c                       |    4 +-
 net/ipv6/xfrm6_output.c                            |    4 +-
 net/ipv6/xfrm6_policy.c                            |    4 +-
 net/ipv6/xfrm6_state.c                             |    4 +-
 net/irda/af_irda.c                                 |    4 +-
 net/irda/irlan/irlan_common.c                      |    2 +-
 net/irda/irttp.c                                   |    4 +-
 net/iucv/af_iucv.c                                 |  103 +-
 net/key/af_key.c                                   |   20 +-
 net/mac80211/Kconfig                               |   12 -
 net/mac80211/Makefile                              |    4 +-
 net/mac80211/agg-rx.c                              |   16 +-
 net/mac80211/agg-tx.c                              |  100 +-
 net/mac80211/cfg.c                                 |  293 +-
 net/mac80211/debugfs.c                             |   37 +-
 net/mac80211/debugfs_netdev.c                      |    5 +
 net/mac80211/debugfs_sta.c                         |    4 +-
 net/mac80211/driver-ops.h                          |   90 +-
 net/mac80211/driver-trace.h                        |   11 -
 net/mac80211/ht.c                                  |   92 +-
 net/mac80211/ibss.c                                |  258 +-
 net/mac80211/ieee80211_i.h                         |  146 +-
 net/mac80211/iface.c                               |   66 +-
 net/mac80211/key.c                                 |    9 +-
 net/mac80211/main.c                                |  102 +-
 net/mac80211/mesh.c                                |   71 +-
 net/mac80211/mesh.h                                |    9 +
 net/mac80211/mesh_hwmp.c                           |  195 +-
 net/mac80211/mesh_pathtbl.c                        |   59 +-
 net/mac80211/mesh_plink.c                          |   58 +-
 net/mac80211/mlme.c                                |  139 +-
 net/mac80211/offchannel.c                          |   34 +-
 net/mac80211/pm.c                                  |    2 +-
 net/mac80211/rc80211_minstrel.c                    |    7 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   62 +-
 net/mac80211/rc80211_pid_algo.c                    |    4 +-
 net/mac80211/rx.c                                  |  279 +-
 net/mac80211/scan.c                                |  201 +-
 net/mac80211/sta_info.c                            |  373 +-
 net/mac80211/sta_info.h                            |   60 +-
 net/mac80211/status.c                              |  102 +-
 net/mac80211/tx.c                                  |  407 +-
 net/mac80211/util.c                                |  328 +-
 net/mac80211/wep.c                                 |    5 +-
 net/mac80211/wme.c                                 |   38 +-
 net/mac80211/wme.h                                 |    3 +
 net/mac80211/work.c                                |  153 +-
 net/mac80211/wpa.c                                 |   34 +-
 net/netfilter/Kconfig                              |   37 +
 net/netfilter/Makefile                             |    3 +
 net/netfilter/core.c                               |   15 +-
 net/netfilter/ipset/ip_set_getport.c               |    6 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |    2 +-
 net/netfilter/ipset/ip_set_hash_net.c              |    2 +-
 net/netfilter/ipvs/Kconfig                         |   15 +
 net/netfilter/ipvs/ip_vs_core.c                    |    2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |    2 +-
 net/netfilter/ipvs/ip_vs_pe_sip.c                  |    4 +-
 net/netfilter/ipvs/ip_vs_sh.c                      |   18 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |    6 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |   20 +-
 net/netfilter/nf_conntrack_acct.c                  |    6 +-
 net/netfilter/nf_conntrack_core.c                  |   20 +-
 net/netfilter/nf_conntrack_expect.c                |   75 +-
 net/netfilter/nf_conntrack_ftp.c                   |    2 +-
 net/netfilter/nf_conntrack_h323_main.c             |    9 +-
 net/netfilter/nf_conntrack_helper.c                |   12 +
 net/netfilter/nf_conntrack_netlink.c               |   82 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |    6 +-
 net/netfilter/nf_conntrack_proto_gre.c             |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |    6 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |    6 +-
 net/netfilter/nf_conntrack_proto_udp.c             |    4 +-
 net/netfilter/nf_conntrack_proto_udplite.c         |    4 +-
 net/netfilter/nf_conntrack_standalone.c            |    4 +-
 net/netfilter/nf_conntrack_timestamp.c             |    2 +-
 net/netfilter/nfnetlink_acct.c                     |  361 ++
 net/netfilter/xt_AUDIT.c                           |    3 +-
 net/netfilter/xt_CT.c                              |    8 +-
 net/netfilter/xt_NFQUEUE.c                         |    4 +-
 net/netfilter/xt_TCPMSS.c                          |   11 +-
 net/netfilter/xt_TCPOPTSTRIP.c                     |    7 +-
 net/netfilter/xt_TEE.c                             |   11 +-
 net/netfilter/xt_TPROXY.c                          |    2 +-
 net/netfilter/xt_addrtype.c                        |   10 +-
 net/netfilter/xt_connbytes.c                       |   32 +-
 net/netfilter/xt_ecn.c                             |  179 +
 net/netfilter/xt_hashlimit.c                       |   19 +-
 net/netfilter/xt_nfacct.c                          |   76 +
 net/netfilter/xt_socket.c                          |    8 +-
 net/netlabel/netlabel_addrlist.c                   |    8 +-
 net/netlabel/netlabel_addrlist.h                   |    2 +-
 net/netlabel/netlabel_domainhash.c                 |   20 +-
 net/netlabel/netlabel_domainhash.h                 |    2 +-
 net/netlabel/netlabel_kapi.c                       |   22 +-
 net/netlabel/netlabel_mgmt.c                       |   10 +-
 net/netlabel/netlabel_unlabeled.c                  |   30 +-
 net/netlink/af_netlink.c                           |   30 +-
 net/netlink/genetlink.c                            |   32 +-
 net/netrom/af_netrom.c                             |   17 +-
 net/netrom/nr_route.c                              |   11 +-
 net/nfc/Kconfig                                    |    1 +
 net/nfc/Makefile                                   |    1 +
 net/nfc/core.c                                     |  201 +-
 net/nfc/llcp/Kconfig                               |    7 +
 net/nfc/llcp/commands.c                            |  399 ++
 net/nfc/llcp/llcp.c                                |  971 +++
 net/nfc/llcp/llcp.h                                |  193 +
 net/nfc/llcp/sock.c                                |  675 ++
 net/nfc/nci/core.c                                 |  124 +-
 net/nfc/nci/data.c                                 |   35 +-
 net/nfc/nci/lib.c                                  |   11 +-
 net/nfc/nci/ntf.c                                  |  209 +-
 net/nfc/nci/rsp.c                                  |  131 +-
 net/nfc/netlink.c                                  |  179 +-
 net/nfc/nfc.h                                      |   70 +-
 net/nfc/rawsock.c                                  |   37 +-
 net/openvswitch/Kconfig                            |   28 +
 net/openvswitch/Makefile                           |   14 +
 net/openvswitch/actions.c                          |  415 ++
 net/openvswitch/datapath.c                         | 1912 ++++++
 net/openvswitch/datapath.h                         |  125 +
 net/openvswitch/dp_notify.c                        |   66 +
 net/openvswitch/flow.c                             | 1346 ++++
 net/openvswitch/flow.h                             |  199 +
 net/openvswitch/vport-internal_dev.c               |  241 +
 net/openvswitch/vport-internal_dev.h               |   28 +
 net/openvswitch/vport-netdev.c                     |  198 +
 net/openvswitch/vport-netdev.h                     |   42 +
 net/openvswitch/vport.c                            |  398 ++
 net/openvswitch/vport.h                            |  205 +
 net/packet/af_packet.c                             |   21 +-
 net/phonet/pep.c                                   |  106 +-
 net/rfkill/core.c                                  |    4 +-
 net/rfkill/rfkill-gpio.c                           |   15 +-
 net/rfkill/rfkill-regulator.c                      |   18 +-
 net/rxrpc/ar-ack.c                                 |   14 +-
 net/rxrpc/ar-key.c                                 |    6 +-
 net/rxrpc/ar-output.c                              |    4 +-
 net/sched/cls_flow.c                               |  182 +-
 net/sched/sch_api.c                                |   14 +-
 net/sched/sch_choke.c                              |  161 +-
 net/sched/sch_generic.c                            |    9 +-
 net/sched/sch_gred.c                               |   81 +-
 net/sched/sch_hfsc.c                               |   10 +
 net/sched/sch_multiq.c                             |    6 +-
 net/sched/sch_netem.c                              |  278 +-
 net/sched/sch_qfq.c                                |   17 +-
 net/sched/sch_red.c                                |   57 +-
 net/sched/sch_sfb.c                                |   17 +-
 net/sched/sch_sfq.c                                |  369 +-
 net/sched/sch_tbf.c                                |    1 +
 net/sched/sch_teql.c                               |    8 +-
 net/sctp/input.c                                   |    2 +-
 net/sctp/ipv6.c                                    |   40 +-
 net/sctp/protocol.c                                |    2 +-
 net/sctp/sm_make_chunk.c                           |    4 +-
 net/sctp/sm_sideeffect.c                           |    8 +-
 net/sctp/socket.c                                  |    6 +-
 net/sctp/transport.c                               |   16 +
 net/socket.c                                       |   22 +-
 net/sunrpc/addr.c                                  |    8 +-
 net/sunrpc/svc.c                                   |    8 +-
 net/sunrpc/svc_xprt.c                              |    8 +-
 net/sunrpc/svcauth_unix.c                          |    8 +-
 net/sunrpc/svcsock.c                               |    4 +-
 net/tipc/bcast.c                                   |  161 +-
 net/tipc/bcast.h                                   |   16 +-
 net/tipc/bearer.c                                  |  190 +-
 net/tipc/bearer.h                                  |   77 +-
 net/tipc/config.c                                  |   13 +-
 net/tipc/core.c                                    |    2 +-
 net/tipc/discover.c                                |   27 +-
 net/tipc/discover.h                                |    8 +-
 net/tipc/eth_media.c                               |  159 +-
 net/tipc/link.c                                    |  346 +-
 net/tipc/link.h                                    |   63 +-
 net/tipc/msg.c                                     |    9 +-
 net/tipc/msg.h                                     |   16 +-
 net/tipc/name_distr.c                              |   14 +-
 net/tipc/name_table.c                              |   15 +-
 net/tipc/name_table.h                              |   10 +-
 net/tipc/net.c                                     |    7 +-
 net/tipc/node.c                                    |   25 +-
 net/tipc/node.h                                    |   12 +-
 net/tipc/port.c                                    |    8 +-
 net/tipc/port.h                                    |    4 +-
 net/tipc/ref.c                                     |    3 +-
 net/tipc/socket.c                                  |    3 -
 net/tipc/subscr.c                                  |   46 +-
 net/tipc/subscr.h                                  |   10 +-
 net/unix/Kconfig                                   |    7 +
 net/unix/Makefile                                  |    3 +
 net/unix/af_unix.c                                 |   68 +-
 net/unix/diag.c                                    |  329 +
 net/wireless/Kconfig                               |    7 +-
 net/wireless/chan.c                                |   12 +-
 net/wireless/core.c                                |    4 +
 net/wireless/core.h                                |   20 +-
 net/wireless/genregdb.awk                          |   13 +-
 net/wireless/mesh.c                                |    2 +
 net/wireless/mlme.c                                |   72 +-
 net/wireless/nl80211.c                             |  855 ++-
 net/wireless/nl80211.h                             |    5 +
 net/wireless/reg.c                                 |  141 +-
 net/wireless/reg.h                                 |   16 +
 net/wireless/regdb.h                               |   16 +
 net/wireless/scan.c                                |  117 +-
 net/wireless/sme.c                                 |   68 +-
 net/wireless/util.c                                |  198 +-
 net/wireless/wext-compat.c                         |   12 +
 net/x25/af_x25.c                                   |    2 +-
 net/x25/x25_dev.c                                  |    6 +-
 net/x25/x25_route.c                                |    2 +-
 net/xfrm/xfrm_policy.c                             |   12 +-
 net/xfrm/xfrm_state.c                              |   12 +-
 net/xfrm/xfrm_user.c                               |   12 +-
 security/lsm_audit.c                               |    7 +-
 security/selinux/hooks.c                           |   11 +-
 security/selinux/netnode.c                         |    2 +-
 1398 files changed, 115824 insertions(+), 74140 deletions(-)
 create mode 100644 Documentation/cgroups/net_prio.txt
 create mode 100644 Documentation/devicetree/bindings/net/calxeda-xgmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/cc770.txt
 create mode 100644 Documentation/networking/openvswitch.txt
 create mode 100644 Documentation/networking/team.txt
 delete mode 100644 drivers/net/bonding/bond_ipv6.c
 create mode 100644 drivers/net/can/cc770/Kconfig
 create mode 100644 drivers/net/can/cc770/Makefile
 create mode 100644 drivers/net/can/cc770/cc770.c
 create mode 100644 drivers/net/can/cc770/cc770.h
 create mode 100644 drivers/net/can/cc770/cc770_isa.c
 create mode 100644 drivers/net/can/cc770/cc770_platform.c
 create mode 100644 drivers/net/dsa/Kconfig
 create mode 100644 drivers/net/dsa/Makefile
 rename {net => drivers/net}/dsa/mv88e6060.c (96%)
 rename {net => drivers/net}/dsa/mv88e6123_61_65.c (96%)
 rename {net => drivers/net}/dsa/mv88e6131.c (96%)
 rename {net => drivers/net}/dsa/mv88e6xxx.c (93%)
 rename {net => drivers/net}/dsa/mv88e6xxx.h (95%)
 create mode 100644 drivers/net/ethernet/brocade/bna/bnad_debugfs.c
 create mode 100644 drivers/net/ethernet/calxeda/Kconfig
 create mode 100644 drivers/net/ethernet/calxeda/Makefile
 create mode 100644 drivers/net/ethernet/calxeda/xgmac.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
 create mode 100644 drivers/net/phy/spi_ks8995.c
 create mode 100644 drivers/net/team/Kconfig
 create mode 100644 drivers/net/team/Makefile
 create mode 100644 drivers/net/team/team.c
 create mode 100644 drivers/net/team/team_mode_activebackup.c
 create mode 100644 drivers/net/team/team_mode_roundrobin.c
 rename drivers/net/wireless/ath/ath6kl/{htc_hif.c => hif.c} (80%)
 delete mode 100644 drivers/net/wireless/ath/ath6kl/htc_hif.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mci.c
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9003_mci.h
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs.h
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dfs_debug.h
 create mode 100644 drivers/net/wireless/ath/ath9k/mci.c
 create mode 100644 drivers/net/wireless/ath/ath9k/mci.h
 delete mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
 create mode 100644 drivers/net/wireless/iwlegacy/3945-debug.c
 create mode 100644 drivers/net/wireless/iwlegacy/3945-mac.c
 create mode 100644 drivers/net/wireless/iwlegacy/3945-rs.c
 create mode 100644 drivers/net/wireless/iwlegacy/3945.c
 create mode 100644 drivers/net/wireless/iwlegacy/3945.h
 rename drivers/net/wireless/iwlegacy/{iwl-4965-calib.c => 4965-calib.c} (55%)
 create mode 100644 drivers/net/wireless/iwlegacy/4965-debug.c
 create mode 100644 drivers/net/wireless/iwlegacy/4965-mac.c
 create mode 100644 drivers/net/wireless/iwlegacy/4965-rs.c
 create mode 100644 drivers/net/wireless/iwlegacy/4965.c
 create mode 100644 drivers/net/wireless/iwlegacy/4965.h
 rename drivers/net/wireless/iwlegacy/{iwl-commands.h => commands.h} (79%)
 create mode 100644 drivers/net/wireless/iwlegacy/common.c
 create mode 100644 drivers/net/wireless/iwlegacy/common.h
 rename drivers/net/wireless/iwlegacy/{iwl-csr.h => csr.h} (84%)
 create mode 100644 drivers/net/wireless/iwlegacy/debug.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-fh.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-hw.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-led.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-led.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945-rs.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-3945.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-hw.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-led.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-led.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-lib.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-rs.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-rx.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-sta.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-tx.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-4965.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-core.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-core.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-debug.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-debugfs.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-dev.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-devtrace.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-devtrace.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-eeprom.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-eeprom.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-fh.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-hcmd.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-helpers.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-io.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-led.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-led.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-power.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-power.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-rx.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-scan.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-sta.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-sta.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-tx.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl3945-base.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl4965-base.c
 rename drivers/net/wireless/iwlegacy/{iwl-prph.h => prph.h} (83%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-mac80211.c
 rename drivers/net/wireless/iwlwifi/{iwl-sv-open.c => iwl-testmode.c} (74%)
 rename drivers/net/wireless/iwlwifi/{iwl-agn-ucode.c => iwl-ucode.c} (57%)
 rename drivers/net/wireless/{iwlegacy/iwl-4965-calib.h => iwlwifi/iwl-wifi.h} (85%)
 create mode 100644 drivers/net/wireless/wl12xx/debug.h
 delete mode 100644 drivers/net/wireless/wl12xx/sdio_test.c
 create mode 100644 include/linux/can/platform/cc770.h
 create mode 100644 include/linux/dynamic_queue_limits.h
 create mode 100644 include/linux/if_team.h
 create mode 100644 include/linux/netdev_features.h
 create mode 100644 include/linux/netfilter/nf_nat.h
 create mode 100644 include/linux/netfilter/nfnetlink_acct.h
 create mode 100644 include/linux/netfilter/xt_ecn.h
 create mode 100644 include/linux/netfilter/xt_nfacct.h
 create mode 100644 include/linux/netfilter/xt_rpfilter.h
 delete mode 100644 include/linux/netfilter_ipv4/nf_nat.h
 create mode 100644 include/linux/openvswitch.h
 create mode 100644 include/linux/smscphy.h
 create mode 100644 include/linux/sock_diag.h
 create mode 100644 include/linux/unix_diag.h
 create mode 100644 include/net/flow_keys.h
 create mode 100644 include/net/netprio_cgroup.h
 create mode 100644 include/net/tcp_memcontrol.h
 create mode 100644 lib/dynamic_queue_limits.c
 create mode 100644 net/caif/caif_usb.c
 create mode 100644 net/core/flow_dissector.c
 create mode 100644 net/core/netprio_cgroup.c
 create mode 100644 net/core/sock_diag.c
 delete mode 100644 net/ipv4/netfilter/ipt_ecn.c
 create mode 100644 net/ipv4/netfilter/ipt_rpfilter.c
 create mode 100644 net/ipv4/tcp_memcontrol.c
 create mode 100644 net/ipv4/udp_diag.c
 create mode 100644 net/ipv6/netfilter/ip6t_rpfilter.c
 create mode 100644 net/netfilter/nfnetlink_acct.c
 create mode 100644 net/netfilter/xt_ecn.c
 create mode 100644 net/netfilter/xt_nfacct.c
 create mode 100644 net/nfc/llcp/Kconfig
 create mode 100644 net/nfc/llcp/commands.c
 create mode 100644 net/nfc/llcp/llcp.c
 create mode 100644 net/nfc/llcp/llcp.h
 create mode 100644 net/nfc/llcp/sock.c
 create mode 100644 net/openvswitch/Kconfig
 create mode 100644 net/openvswitch/Makefile
 create mode 100644 net/openvswitch/actions.c
 create mode 100644 net/openvswitch/datapath.c
 create mode 100644 net/openvswitch/datapath.h
 create mode 100644 net/openvswitch/dp_notify.c
 create mode 100644 net/openvswitch/flow.c
 create mode 100644 net/openvswitch/flow.h
 create mode 100644 net/openvswitch/vport-internal_dev.c
 create mode 100644 net/openvswitch/vport-internal_dev.h
 create mode 100644 net/openvswitch/vport-netdev.c
 create mode 100644 net/openvswitch/vport-netdev.h
 create mode 100644 net/openvswitch/vport.c
 create mode 100644 net/openvswitch/vport.h
 create mode 100644 net/unix/diag.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
