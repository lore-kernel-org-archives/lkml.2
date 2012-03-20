Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030242Ab2CTVZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:25:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54018 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab2CTVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:24:52 -0400
Date: Tue, 20 Mar 2012 17:24:44 -0400 (EDT)
Message-Id: <20120320.172444.2225133582832122925.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 20 Mar 2012 14:24:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2KLPNxR005605


There are three conflicts to resolve here, two trivial and one of
medium difficulty:

1) drivers/isdn/gigaset/interface.c

   tree wide TTY driver cleanups in your tree remove the initialization
   of ->magic, whereas a change in the net-next tree changed "," to
   ";" in these lines.  A sample resolution is:

- 	tty->type =		TTY_DRIVER_TYPE_SERIAL,
- 	tty->subtype =		SERIAL_TYPE_NORMAL,
 -	tty->magic =		TTY_DRIVER_MAGIC;
+ 	tty->type =		TTY_DRIVER_TYPE_SERIAL;
+ 	tty->subtype =		SERIAL_TYPE_NORMAL;

2) drivers/net/usb/Kconfig

   Trivial, net-next adds a select statement to a Kconfig entry.

3) drivers/net/usb/qmi_wwan.c

   The thing to do for this one is to simply use pretty much all of
   the HEAD hunks in your tree.  Basically what happened is that an
   earlier, less cooked, version of the Huawei QMI device support
   went into the net-next tree, and the more polished version ended
   up in Greg's USB tree which you pulled already.

Anyways, highlights:

1) Move ixgbe driver over to purely page based buffering on receive.
   From Alexander Duyck.

2) Add receive packet steering support to e1000e, from Bruce Allan.

3) Convert TCP MD5 support over to RCU, from Eric Dumazet.

4) Reduce cpu usage in handling out-of-order TCP packets on modern
   systems, also from Eric Dumazet.

5) Support the IP{,V6}_UNICAST_IF socket options, making the wine
   folks happy, from Erich Hoover.

6) Support VLAN trunking from guests in hyperv driver, from Haiyang
   Zhang.

7) Support byte-queue-limtis in r8169, from Igor Maravic.

8) Outline code intended for IP_RECVTOS in IP_PKTOPTIONS existed but
   was never properly implemented, Jiri Benc fixed that.

9) 64-bit statistics support in r8169 and 8139too, from Junchang Wang.

10) Support kernel side dump filtering by ctmark in netfilter ctnetlink,
    from Pablo Neira Ayuso.

11) Support byte-queue-limits in gianfar driver, from Paul Gortmaker.

12) Add new peek socket options to assist with socket migration, from
    Pavel Emelyanov.

13) Add sch_plug packet scheduler whose queue is controlled by
    userland daemons using explicit freeze and release commands.  From
    Shriram Rajagopalan.

14) Fix FCOE checksum offload handling on transmit, from Yi Zou.

Please pull, thanks a lot!

The following changes since commit ed378a52dabf77b406b447fd3238f83ea24b71fa:

  Merge tag 'usb-3.3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2012-03-20 11:26:30 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

Aarthi Thiruvengadam (2):
      ath6kl: Clear the IE in firmware if not set
      ath6kl: Fix merge error in ath6kl_set_ies()

Ajit Khaparde (4):
      be2net: enable WOL by default if h/w supports it
      be2net: Program secondary UC MAC address into MAC filter
      be2net: Fix number of vlan slots in flex mode
      be2net: fix programming of VLAN tags for VF

Akinobu Mita (1):
      mISDN: use memchr_inv

Alex Yang (1):
      ath6kl: add testmode 2 for 6003 ART

Alexander Duyck (41):
      ixgbe: Minor refactor of RSC
      ixgbe: Address fact that RSC was not setting GSO size for incoming frames
      ixgbe: Let the Rx buffer allocation clear status bits instead of cleanup
      ixgbe: Add function for testing status bits in Rx descriptor
      ixgbe: Drop the _ADV of descriptor macros since all ixgbe descriptors are ADV
      ixgbe: Combine post-DMA processing of sk_buff fields into single function
      skbuff: Move rxhash and vlan_tci to consolidate holes in sk_buff
      ixgbe: Minor formatting and comment corrections for ixgbe_xmit_frame_ring
      ixgbe: Fix comments that are out of date or formatted incorrectly
      ixgbe: add support for byte queue limits
      net: Fix issue with netdev_tx_reset_queue not resetting queue from XOFF state
      net: Add memory barriers to prevent possible race in byte queue limits
      ixgbe: Do no clear Tx status bits since eop_desc provides enough info
      ixgbe: Reorder adapter contents for better cache utilization
      ixgbe: Address issues with Tx WHTRESH value not being set correctly
      ixgbe: Correct Adaptive Interrupt Moderation so that it will change values
      ixgbe: Default to queue pairs when number of queues is less than CPUs
      ixgbe: Drop unnecessary napi_schedule_prep and spare blank line from ixgbe_intr
      ixgbe: Allocate rings as part of the q_vector
      ixgbe: Add iterator for cycling through rings on a q_vector
      ixgbe: Simplify logic for ethtool loopback frame creation and testing
      ixgbe: Do not disable read relaxed ordering when DCA is enabled
      ixgbe: Replace eitr_low and eitr_high with static values in ixgbe_update_itr
      ixgbe: Replace standard receive path with a page based receive
      ixgbe: cleanup logic in ixgbe_change_mtu
      ixgbe: Make certain that all frames fit minimum size requirements
      ixgbe: Modify setup of descriptor flags to avoid conditional jumps
      ixgbe: Use packets to track Tx completions instead of a seperate value
      ixgbe: Place skb on first buffer_info structure to avoid using stack space
      ixgbe: Write gso_segs and bytcount to the ring sooner
      ixgbe: always write DMA for single_mapped value with skb
      ixgbe: Store Tx flags and protocol information to tx_buffer sooner
      ixgbe: Update layout of ixgbe_ring structure to improve cache performance
      ixgbe: cleanup logic for the service timer and VF hang detection
      ixgbe: Move poll routine in order to improve readability
      ixgbe: drop err_eeprom tag which is at same location as err_sw_init
      ixgbe: Two minor fixes for RSS and FDIR set queues functions
      ixgbe: Whitespace cleanups
      ixgbe: Add support for enabling UDP RSS via the ethtool rx-flow-hash command
      ixgbe: Correct flag values set by ixgbe_fix_features
      ixgbe: Fix issues with SR-IOV loopback when flow control is disabled

Alexey Orishko (4):
      cdc_ncm: reduce driver latency in the data path
      cdc_ncm: fix MTU and max_datagram_size handling
      cdc_ncm: avoid discarding datagrams in rx path
      usbnet: use netif_tx_wake_queue instead of netif_start_queue

Allan Stephens (31):
      tipc: improve the link deferred queue insertion algorithm
      tipc: Prevent transmission of outdated link protocol messages
      tipc: Prevent broadcast link stalling in dual LAN environments
      tipc: Ensure broadcast link re-acquires node after link failure
      tipc: Fix problem with broadcast link synchronization between nodes
      tipc: Add missing broadcast link lock when sending NACK
      tipc: Fix node lock reclamation issues in broadcast link reception
      tipc: Fix bug in broadcast link duplicate message statistics
      tipc: Add missing locks in broadcast link statistics accumulation
      tipc: Major redesign of broadcast link ACK/NACK algorithms
      tipc: Remove obsolete broadcast tag capability
      tipc: Prevent loss of fragmented messages over unicast links
      tipc: Prevent loss of fragmented messages over broadcast link
      tipc: Eliminate alteration of publication key during name table purging
      tipc: Minor optimization to rejection of connection-based messages
      tipc: Introduce node signature field in neighbor discovery message
      tipc: Detect duplicate nodes using different network interfaces
      tipc: Remove duplicate check of message destination node
      tipc: Simplify enforcement of reserved name type prohibition
      tipc: Add check to prevent insertion of duplicate name table entries
      tipc: Eliminate a test for negative unsigned quantities
      tipc: Hide internal details of node table implementation
      tipc: Eliminate trivial buffer manipulation helper routines
      tipc: Remove obsolete comments about routing table updates
      tipc: Minor optimization to broadcast link synchronization logic
      tipc: Revert name table translation optimization
      tipc: Eliminate obsolete support for "not running" mode
      tipc: Eliminate support for tipc_mode global variable
      tipc: Un-inline port routine for processing incoming messages
      tipc: Eliminate obsolete code for re-sending a message
      tipc: Optimize setting of immutable payload message header fields

Amit Beka (7):
      iwlwifi: range check to testmode direct reg access
      iwlwifi: testmode new indirect RW API
      iwlwifi: added reply data to testmode HCMD send
      iwlwifi: fixes to testmode indirect access
      iwlwifi: send testmode hcmd reply with rx header
      iwlwifi: add testmode command for rx forwarding
      iwlwifi: fixed testmode notifications length

Amitkumar Karwar (12):
      mwifiex: update BSS parameters in dump_station_info()
      mwifiex: fix NULL pointer dereference in set_channel()
      mwifiex: enable HT operating mode
      mwifiex: cleanup in snmp_mib command preparation code
      mwifiex: update correct dtim_period in dump_station()
      mwifiex: remove redundant scan operation
      mwifiex: remove unnecessary enum MWIFIEX_802_11_WEP_STATUS
      mwifiex: handle auto authentication mode correctly
      mwifiex: remove unnecessary struct mwifiex_802_11_ssid
      mwifiex: fix bug in wildcard scan handling
      mwifiex: correction in number of bitrates
      mwifiex: correction in structure name passed to sizeof()

Andre Guedes (25):
      Bluetooth: Add 'eir_len' param to mgmt_device_found()
      Bluetooth: Report LE devices
      Bluetooth: Use GFP_KERNEL in hci_conn_add()
      Bluetooth: Use GFP_KERNEL in hci_chan_create()
      Bluetooth: Fix potential deadlock
      Bluetooth: Remove unneeded locking
      Bluetooth: Use GFP_KERNEL in hci_add_adv_entry()
      Bluetooth: LE scan should send Discovering events
      Bluetooth: Minor code refactoring
      Bluetooth: Add hci_do_le_scan()
      Bluetooth: Add hci_le_scan()
      Bluetooth: MGMT start discovery LE-Only support
      Bluetooth: Fix indentation
      Bluetooth: Add BT_DBG to mgmt_discovering()
      Bluetooth: Fix discovery state machine
      Bluetooth: Fix event sending with DISCOVERY_STOPPED state
      Bluetooth: Prepare start_discovery
      Bluetooth: Track discovery type
      Bluetooth: Merge INQUIRY and LE_SCAN discovery states
      Bluetooth: Interleaved discovery support
      Bluetooth: Set DISCOVERY_STOPPED if controller resets
      Bluetooth: Change interleaved discovery behavior
      Bluetooth: Fix Kconfig help description
      Bluetooth: Check capabilities in BR/EDR and LE-Only discovery
      Bluetooth: Don't force DISCOVERY_STOPPED state in inquiry_cache_flush

Andrei Emeltchenko (30):
      Bluetooth: Process num completed data blocks event
      Bluetooth: Remove magic number from ACL TO
      Bluetooth: Use chan instead of sk
      Bluetooth: Change sk to l2cap_chan
      Bluetooth: trivial: space correction
      Bluetooth: Add alloc_skb chan operator
      Bluetooth: Use list _safe deleting from conn_hash_list
      Bluetooth: Use list _safe deleting from conn chan_list
      Bluetooth: Recalculate sched HCI blk/pkt flow ctrl
      Bluetooth: Helper removes duplicated code
      Bluetooth: Change chan_ready param from sk to chan
      Bluetooth: Clean up l2cap_chan_add
      Bluetooth: Remove unneeded sk variable
      Bluetooth: Do not dereference zero sk
      Bluetooth: Move scope of state_to_string
      Bluetooth: Use symbolic names for state in debug
      Bluetooth: Prefix hex numbers with object name
      Bluetooth: trivial: Fix long line
      Bluetooth: Revert to mutexes from RCU list
      Bluetooth: Add l2cap_chan_lock
      Bluetooth: Add locked and unlocked state_change
      Bluetooth: Add socket error function
      Bluetooth: Fix coding style issues in mgmt code
      Bluetooth: Add unlocked __l2cap_chan_add function
      Bluetooth: Change sk lock to chan lock in L2CAP core
      Bluetooth: Remove socket lock check
      Bluetooth: Fix init request completion with AMP controllers
      Bluetooth: Fix double locking in LE and conless chan
      Bluetooth: Remove duplicated code in l2cap conn req
      Bluetooth: Save remote L2CAP fixed channel mask

Andrzej Kaczmarek (2):
      Bluetooth: Fix sk_sndtimeo initialization for L2CAP socket
      Bluetooth: l2cap_set_timer needs jiffies as timeout value

Antonio Quartulli (12):
      mac80211: In IBSS the DA field of auth frames is different from BSSID
      mac80211: remove useless DA checking in ieee80211_rx_mgmt_probe_resp()
      ath5k: claim support for IBSS RSN
      mac80211: add a 2-way Authentication challenge to IBSS mode
      mac80211: in IBSS use the Auth frame to trigger STA reinsertion
      ath9k_htc: claim support for IBSS RSN
      cfg80211/mac80211: userspace peer authorization in IBSS
      batman-adv: add tt_initialised flag to the orig_node struct
      batman-adv: set TT_CLIENT_NEW flag before invoking hash_add()
      batman-adv: code refactoring - move debug print into tt_local_set_pending
      batman-adv: TT_CLIENT_PENDING is never set in struct tt_global_entry
      mac80211_hwsim: correctly line up a multiline printk

Arend van Spriel (23):
      brcm80211: update the maintainers listed for brcm80211 drivers
      brcm80211: smac: fix unintended fallthru in wlc_phy_radio_init_2057()
      brcm80211: smac: remove redundant assignments from txpwrctrl_pwr_setup_nphy
      brcm80211: smac: fix endless retry of A-MPDU transmissions
      brcm80211: smac: remove smatch warnings from brcmsmac code
      brcm80211: fmac: resolve smatch issues in brcmfmac code
      brcm80211: fmac: use specific types in struct brcmf_bus
      brcm80211: fmac: move module entry points to dhd_linux.c
      brcm80211: fmac: only return success in brcmf_sdbrcm_bus_init() when true
      brcm80211: fmac: update bus state in common driver part
      brcm80211: fmac: change allocation flag in brcmf_enq_event() function
      brcm80211: fmac: use spinlock calls saving irq flags in brcmf_enq_event()
      brcm80211: fmac: add USB support for bcm43235/6/8 chipsets
      brcm80211: fmac: make sdio firmware filename specific
      brcm80211: fmac: remove unnecessary NULL pointer check
      brcm80211: fmac: remove brcmf_usb_attrib structure
      brcm80211: fmac: use counters in brcmf_bus structure
      brcm80211: fmac: initialize host interface drivers regardless result
      brcm80211: fmac: remove firmware requests from init_module syscall
      brcm80211: smac: remove firmware requests from init_module syscall
      brcm80211: smac: cleanup couple of debug output statements
      bcma: return error in bcma_sprom_get() when fallback fails
      bcma: add support for on-chip OTP memory used for SPROM storage

Ariel Elior (10):
      bnx2x: Support Queue Per Cos in 5771xx devices
      bnx2x: Removing indirect register access
      bnx2x: Obtain Bus Device Function from register
      bnx2x: Function Level Reset Final Cleanup
      bnx2x: Loaded Firmware Version Validation
      bnx2x: Lock PF-common resources
      bnx2x: Track active PFs with bitmap
      bnx2x: Recovery flow bug fixes
      bnx2x: Recoverable and unrecoverable error statistics
      bnx2x: Update version to 1.72.0 and copyrights

Arik Nemtsov (8):
      wl12xx: set the ELP entry delay to the FW dyn-ps timeout
      wl12xx: change bits in the link_map under spin lock
      wl12xx: reset link Tx queues when freeing it
      wl12xx: avoid starving the system hlid
      wl12xx: flush all Tx queues on tx_flush timeout
      wl12xx: flush Tx during suspend and 802.11h chan switch
      wl12xx: increase dynamic PS timeout to 200ms
      wl12xx: implement SW Tx watchdog

Ashok Nagarajan (4):
      {nl,cfg,mac}80211: Implement RSSI threshold for mesh peering
      mac80211: Fix potential null pointer dereferencing
      mac80211_hwsim: Fix set mactime on receiver hwsim radio
      ath9k: Fix mactime from being clobbered in rx_status

Atita Shirwaikar (1):
      ixgbe: Fix race condition where RX buffer could become corrupted.

Attila Fazekas (1):
      rtl8187: Add AD-HOC support

Avinash Patil (2):
      mwifiex: pass priv pointer instead of adapter
      mwifiex: correct bitrates advertised to cfg80211

Bala Shanmugam (1):
      cfg80211: Add background scan period attribute.

Belinda Thompson (1):
      ctcm: use correct idal word list for ctcmpc

Ben Greear (22):
      net: Support RXFCS feature flag.
      e1000e: Support RXFCS feature flag.
      net: Add framework to allow sending packets with customized CRC.
      e1000e: Support sending custom Ethernet CRC.
      net: Support RX-ALL feature flag.
      e1000e: Support RXALL feature flag.
      e1000: Support sending custom Ethernet CRC.
      e1000: Support RX-FCS flag.
      8139too: Support RX-ALL logic.
      8139too: Support RX-FCS flag.
      r8169: Support RX-ALL flag.
      r8169: Support RX-FCS flag.
      e100: Support RXFCS feature flag.
      e100: Support sending custom Ethernet CRC
      e100: Support RXALL feature flag.
      e100: Fix rx-over-length statistics.
      e100: Show short v/s long rx length errors in ethtool stats.
      ath9k: Add wiphy name to log messages.
      igb: Support sending custom Ethernet FCS.
      igb: Support RX-ALL feature flag.
      ixgbe: Support sending custom Ethernet FCS.
      ixgbe: Support RX-ALL feature flag.

Ben Hutchings (67):
      sfc: Fix some formatting errors reported by checkpatch
      sfc: Avoid assignment in an if-statement, reported by checkpatch
      sfc: Remove parentheses around return expressions, reported by checkpatch
      sfc: Const-qualify static data as appropriate, partly prompted by checkpatch
      sfc: Remove unnecessary inclusion of <asm/io.h>, prompted by checkpatch
      sfc: Update MCDI (firmware interface) definitions
      sfc: Rename efx_wanted_channels() to efx_wanted_parallelism()
      sfc: Set default parallelism to per-core by default
      sfc: Remove fallback for invalid permanent MAC address
      sfc: Make handling of MC reboot more reliable
      sfc: Use new names for MC shared memory layout constants
      sfc: Hold efx_nic::stats_lock while reading efx_nic::mac_stats
      sfc: Merge efx_mac_operations into efx_nic_type
      sfc: Merge efx_mcdi_mac_check_fault() and efx_mcdi_get_mac_faults()
      sfc: Remove efx_nic_type::push_multicast_hash operation
      sfc: Consistently test DEBUG macro, not EFX_ENABLE_DEBUG
      sfc: Correct interrupt timer quantum for Siena (normal and turbo mode)
      sfc: Remove dependence on NAPI polling in efx_test_eventq_irq()
      Partly revert "sfc: Handle serious errors in exactly one interrupt handler"
      sfc: Clean up test interrupt handling
      sfc: Add hwmon driver for boards using SFC9000-family controllers
      sfc: Update the description of SFC_MTD
      sfc: Remove obsolete function efx_dev_name()
      sfc: Remove remnants of on-load self-test
      sfc: Use existing local variables instead of repeated indirect lookups
      sfc: Minor formatting fixes
      sfc: Remove redundant 'rc' variable, always set to 0
      sfc: Rename implementation of ndo_set_rx_mode
      sfc: Make all MAC statistics consistently 64 bits wide
      sfc: Move the end of the non-GRO RX path into its own function
      sfc: Replace efx_rx_buffer::is_page and other booleans with a flags field
      sfc: MTD: Leave the DEBUG macro alone
      sfc: Use a more sensible cast in efx_rx_buf_offset()
      sfc: Skip RX end-of-batch work on channels without an RX queue
      sfc: Do not retry hardware probe if it schedules a reset
      sfc: Replace some literal constants with EFX_PAGE_SIZE/EFX_BUF_SIZE
      sfc: Warn if unable to create MTDs
      sfc: Add support for configuring RX unicast/multicast default filters
      sfc: Add support for TX MAC filters
      sfc: Correct MAC filter bitfield definitions
      sfc: Generalise driver event generation
      sfc: Generate RX fill events based on RX queues, not channels
      sfc: Leave interrupts and event queues enabled whenever we can
      sfc: Use proper function to test for RX channel in efx_poll()
      sfc: Generalise event generation to cover VF-owned event queues
      sfc: Make buffer table indices and counts consistently unsigned
      sfc: Make all CPU/IRQ/channel/queue counts unsigned
      sfc: Add support for 'extra' channel types
      sfc: Pass NIC structure into efx_wanted_parallelism()
      sfc: Allocate SRAM between buffer table and descriptor caches at init time
      sfc: Add SR-IOV back-end support for SFC9000 family
      sfc: Specify that the VFDI status page has page alignment and size
      sfc: Correct validation of peer_page_count in efx_vfdi_set_status_page()
      sfc: Reverse initial buffer table allocation to allow for later resizing
      sfc: Minor formatting cleanup
      sfc: Correct efx_for_each_possible_channel_tx_queue() to skip non-TX channels
      mdio: Export mdio.h to userland
      ethtool, mdio, mii: Specify MDIO information fields in struct ethtool_cmd
      sfc: Remove redundant function efx_nic_has_mc()
      sfc: Update comments on efx_rx_packet_gro()
      sfc: Remove TX completions from adaptive IRQ scoring
      sfc: Raise self-test timeouts
      sfc: Test all event queues in parallel
      sfc: Encapsulate access to efx_{channel,nic}::last_irq_cpu in self-test
      sfc: Run event/IRQ self-test asynchronously when interface is brought up
      sfc: Remove efx_channel::last_eventq_read_ptr
      sfc: Log the part number on probe

Benjamin LaHaise (1):
      Fix pppol2tp getsockname()

Benjamin Poirier (2):
      sctp: Export sctp_do_peeloff
      dlm: Do not allocate a fd for peeloff

Bhanu Prakash Gollapudi (1):
      bnx2fc: HSI dependent changes for 7.2.xx FW

Bj√∏rn Mork (2):
      net: usb: qmi_wwan: New driver for Huawei QMI based WWAN devices
      net: qmi_wwan: fix build error due to cdc-wdm dependecy

Bruce Allan (69):
      e1000e: cleanup Rx checksum offload code
      e1000e: add Receive Packet Steering (RPS) support
      e1000e: re-enable alternate MAC address for all devices which support it
      e1000e: convert head, tail and itr_register offsets to __iomem pointers
      e1000e: pass pointer to ring struct instead of adapter struct
      e1000e: re-factor ethtool get/set ring parameter
      e1000e: default IntMode based on kernel config & available hardware support
      e1000e: always set transmit descriptor control registers the same
      e1000e: 82579: workaround for link drop issue
      e1000e: use default settings for Tx Inter Packet Gap timer
      e1000e: use hardware default values for Transmit Control register
      e1000e: 82574/82583 Tx hang workaround
      e1000e: disable Early Receive DMA on ICH LOMs
      e1000e: update workaround for 82579 intermittently disabled during S0->Sx
      e1000e: ICHx/PCHx LOMs should use LPLU setting in NVM when going to Sx
      e1000e: increase Rx PBA to prevent dropping received packets on 82566/82567
      e1000e: conditionally restart autoneg on 82577/8/9 when setting LPLU state
      e1000e: concatenate long debug strings which span multiple lines
      e1000e: convert final strncpy() to strlcpy()
      e1000e: increase version number
      e1000e: call er16flash() instead of __er16flash()
      e1000e: split lib.c into three more-appropriate files
      e1000e: update copyright year
      e1000e: add missing initializers reported when compiling with W=1
      e1000e: cleanup - check return values consistently
      e1000e: cleanup e1000_init_mac_params_80003es2lan()
      e1000e: cleanup e1000_init_mac_params_82571()
      e1000e: cleanup e1000_set_phys_id
      e1000e: cleanup - use braces in both branches of a conditional statement
      e1000e: fix checkpatch warning from MINMAX test
      e1000e: fix sparse warnings with -D__CHECK_ENDIAN__
      e1000e: minor whitespace and indentation cleanup
      e1000e: remove test that is always false
      e1000e: remove unnecessary returns from void functions
      e1000e: remove unnecessary parentheses
      e1000e: use true/false for bool autoneg_false
      e1000e: pass pointer to hw struct for e1000_init_mac_params_XXX()
      e1000e: replace '1' with 'true' for boolean get_link_status
      e1000e: cleanup: use goto for common work needed by multiple exit points
      e1000e: cleanup: rename goto labels to be more meaningful
      e1000e: potentially incorrect return for e1000_cfg_kmrn_10_100_80003es2lan
      e1000e: potential incorrect return for e1000_setup_copper_link_80003es2lan
      e1000e: cleanup: remove unnecessary assignments just before returning
      e1000e: cleanup: always return 0
      e1000e: potentially incorrect return for e1000_set_d3_lplu_state_ich8lan
      e1000e: cleanup: remove unreachable statement
      e1000e: cleanup: remove unnecessary variable ret_val
      e1000e: cleanup: remove unnecessary test and return
      e1000e: cleanup: remove unnecessary variable initializations
      e1000e: cleanup: minor whitespace addition (insert blank line separator)
      e1000e: potentially incorrect return for e1000_init_hw_ich8lan
      e1000e: potentially incorrect return for e1000e_setup_fiber_serdes_link
      e1000e: cleanup goto statements to exit points without common work
      e1000e: cosmetic change to boolean comparisons
      e1000e: cosmetic comment changes to make lines less than 80 characters
      e1000e: cleanup: rename e1000e_id_led_init() and call as function pointer
      e1000e: cleanup: rename e1000e_setup_link() and call as function pointer
      e1000e: cleanup use of check_mng_mode function pointer
      e1000e: cleanup use of check_reset_block function pointer
      e1000e: cleanup calls to setup_physical_interface function pointer
      e1000e: comment correction in e1000e_set_kmrn_lock_loss_workaround_ich8lan
      e1000e: rename e1000e_config_collision_dist() and call as function pointer
      e1000e: cleanup comment in e1000_hash_mc_addr()
      e1000e: use true/false for boolean send_xon, do not assume always true
      e1000e: cleanup - remove unnecessary variable
      e1000e: rename e1000e_reload_nvm() and call as function pointer
      e1000e: cleanup incorrect filename in comment
      e1000e: cleanup whitespace and indentation
      e1000e: use msleep instead of mdelay

Chilam Ng (3):
      ath6kl: initialize the 'nominal_phy' field in the 'wmi_create_pstream_cmd' struct for create_qos command
      ath6kl: prioritize Tx bundling based on AC priorities
      ath6kl: assign Tx packet drop threshold per endpoint based on AC priority

Christian Lamparter (4):
      carl9170: remove eeprom data injection option
      carl9170: allow users to lower output power level
      p54: pass interface setup errors back to mac80211
      p54pci: use new driver.pm interface for suspend/resume

Christian Riesch (2):
      davinci_cpdma: Fix channel number written to teardown registers
      davinci_mdio: Correct bitmask for clock divider value

Chun-Yeow Yeoh (4):
      {nl,cfg,mac}80211: Add support of setting non-forwarding entity in Mesh
      mac80211: Fix the generation of PREQs in proactive RANN mechanism of HWMP
      mac80211: fix the support of setting non-forwarding entity in Mesh
      ath5k: allow AP and mesh mode to operate simultaneously

Dan Carpenter (17):
      bnx2x: unlock before returning an error
      nfc: NULL vs zero in nci_activate_target()
      xfrm6: remove unneeded NULL check in __xfrm6_output()
      mac80211: off by one in mcs mask handling
      ath9k: cleanup a min_t() cast
      caif: remove duplicate initialization
      netxen_nic: signedness bug in netxen_md_entry_err_chk()
      wl12xx: remove some dead code in wl1271_plt_init()
      brcm80211: fmac: fix a couple checking after dereference bugs
      Bluetooth: use kfree_skb() instead of kfree()
      Bluetooth: change min_t() cast in hci_reassembly()
      rndis_wlan: integer overflows in rndis_wlan_do_link_up_work()
      rndis_wlan: remove unneeded variables
      rndis_wlan: make some variables unsigned
      rndis_wlan: prevent integer overflow in indication()
      mwifiex: endian bug in mwifiex_drv_change_adhoc_chan()
      airo: fix test for FLAG_RADIO_DOWN

Daniel Drake (1):
      libertas: remove dump_survey implementation

Daniel Wagner (1):
      Bluetooth: Don't mark non xfer isoc endpoint URBs with URB_ISO_ASAP

Danny Kukawka (39):
      hamradio: fix incompatible pointer in module parameter
      eicon: fix -Warray-bounds warning
      eth: reset addr_assign_type if eth_mac_addr() called
      rename dev_hw_addr_random and remove redundant second
      mISDN/hfcsusb: remove unused variable hfcsusb_rev
      net: replace random_ether_addr() with eth_hw_addr_random()
      net: use eth_hw_addr_random() and reset addr_assign_type
      renesas/sh_eth.c: fix linux/interrupt.h included twice
      au1000_eth: use eth_hw_addr_random() instead of random_ether_addr()
      lantiq_etop: set addr_assign_type if random_ether_addr() used
      davinci_emac: use eth_hw_addr_random() instead of random_ether_addr()
      xilinx ll_temac: use eth_hw_addr_random() instead of random_ether_addr()
      igbvf: reset netdevice addr_assign_type if changed
      batman-adv: use eth_hw_addr_random() instead of random_ether_addr()
      ethoc: set addr_assign_type if random_ether_addr() used
      atheros eth: set addr_assign_type if random_ether_addr() used
      UML net: set addr_assign_type if random_ether_addr() used
      cisco/enic: use eth_hw_addr_random() instead of random_ether_addr()
      arch/blackfin: don't generate random mac in bfin_get_ether_addr()
      adi: adapt to eth_hw_addr_random() and changes in arch/blackfin
      3com/typhoon: reuse eth_mac_addr()
      net/ieee802154/6lowpan.c: reuse eth_mac_addr()
      ethernet: unify return value of .ndo_set_mac_address if address is invalid
      mcs7830: unify return value of .ndo_set_mac_address if address is invalid
      br_device: unify return value of .ndo_set_mac_address if address is invalid
      Staging: et131x: unify return value of .ndo_set_mac_address if address is invalid
      amd/hplance.c: print MAC via printk format specifier
      cirrus/mac89x0: print MAC via printk format specifier
      dec/tulip/de4x5: print MAC via printk format specifier
      ixgbevf: print MAC via printk format specifier
      sun/sunqe: print MAC via printk format specifier
      xscale/ixp2000/ixpdev: print MAC via printk format specifier
      usb/cdc_ncm: print MAC via printk format specifier
      usb/kaweth: print MAC via printk format specifier
      arch/ia64/hp/sim/simeth.c: print MAC via printk format specifier
      Staging: ft1000-pcmcia: print MAC via printk format specifier
      Staging: wlags49_h2: print MAC via printk format specifier
      iwlwifi: iwl-agn.h included twice
      can: cc770: linux/can/dev.h included twice

Dave Jones (1):
      Remove printk from rds_sendmsg

David Gibson (1):
      orinoco: Remove old mailing lists from MAINTAINERS

David Herrmann (28):
      Bluetooth: hci-uart-ll: Use GFP_ATOMIC in open()
      Bluetooth: hci-uart-h4: Use GFP_ATOMIC in open()
      Bluetooth: hci-uart-bcsp: Use GFP_ATOMIC in open()
      Bluetooth: hci-uart-ath: Use GFP_ATOMIC in open()
      Bluetooth: dtl1: Fix memleak in probe()
      Bluetooth: Make hci-destruct callback optional
      Bluetooth: bluecard-cs: Remove empty destruct cb
      Bluetooth: bt3c-cs: Remove empty destruct cb
      Bluetooth: btmrvl: Remove empty destruct cb
      Bluetooth: btuart-cs: Remove empty destruct cb
      Bluetooth: btwilink: Remove empty destruct cb
      Bluetooth: dtl1-cs: Remove empty destruct cb
      Bluetooth: vhci: Free driver_data on file release
      Bluetooth: bfusb: Free driver_data on USB shutdown
      Bluetooth: btusb: Free driver data on USB shutdown
      Bluetooth: bpa10x: Free private driver data on usb shutdown
      Bluetooth: btsdio: Free driver data on SDIO shutdown
      Bluetooth: uart-ldisc: Fix memory leak and remove destruct cb
      Bluetooth: Remove unused hci-destruct cb
      Bluetooth: Correctly acquire module ref
      Bluetooth: Remove HCI-owner field
      Bluetooth: Correctly take hci_dev->dev refcount
      Bluetooth: Remove __hci_dev_put/hold
      Bluetooth: Introduce to_hci_dev()
      Bluetooth: Remove hci_dev->driver_data
      Bluetooth: Introduce to_hci_conn
      Bluetooth: Use proper datatypes in release-callbacks
      Bluetooth: btusb: Remove device lock on release

David Miller (4):
      infiniband: Convert dst_fetch_ha() over to dst_neigh_lookup().
      infiniband: cxgb4: Convert import_ep() over to dst_neigh_lookup().
      infiniband: nes: Convert nes_addr_resolve_neigh() over to dst_neigh_lookup().
      qeth: Move away from using neighbour entries in qeth_l3_fill_header()

David S. Miller (67):
      ipv4: Remove bogus checks of rt_gateway being zero.
      ipip: Fix bug added to ipip_tunnel_xmit().
      ip_gre: Fix bug added to ipgre_tunnel_xmit().
      Merge git://git.kernel.org/.../davem/net
      ipv4/ipv6: Prepare for new route gateway semantics.
      ipv6: sit: Convert to dst_neigh_lookup()
      e1000e: Need to include vmalloc.h
      ipv6: Use ipv6_addr_any()
      ipv4: ip_gre: Convert to dst_neigh_lookup()
      ipv6: ndisc: Convert to dst_neigh_lookup()
      ipv6: fib: Convert fib6_age() to dst_neigh_lookup().
      ipv6: Remove neigh argument from ndisc_send_redirect()
      ipv6: Eliminate dst_get_neighbour_noref() usage in ip6_forward().
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'davem-next.r8169' of git://violet.fr.zoreil.com/romieu/linux
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      ipv6: Remove never used function inet6_ac_check().
      decnet: Add missing neigh->ha locking to dn_neigh_output_packet()
      atm: clip: Convert over to dst_neigh_lookup().
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://gitorious.org/linux-can/linux-can-next
      net: Make qdisc_skb_cb upper size bound explicit.
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'tipc_net-next' of git://git.kernel.org/.../paulg/linux
      sonice: Fix build due to botched netdev_alloc_skb() conversion.
      Merge branch 'master' of git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      decnet: net/dn.h needs net/flow.h
      ipv4: Eliminate spurious argument to __ipv4_neigh_lookup
      Merge git://git.kernel.org/.../bwh/sfc-next
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge git://git.kernel.org/.../davem/net
      ll_temac: Fix build.
      Merge branch '20120221_isdn' of git://repo.or.cz/linux-2.6/trivial-mods
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      net: Add missing getsockopt for SO_NOFCS.
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../davem/net
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      mac89x0: Fix build error.
      Merge branch 'tipc_net-next' of git://git.kernel.org/.../paulg/linux
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'dccp' of git://eden-feed.erg.abdn.ac.uk/net-next
      mdio.h: Include linux/types.h
      Merge branch 'master' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge git://git.kernel.org/.../davem/net
      net: Use bool for return value of dev_valid_name().
      Merge branch 'master' of git://1984.lsi.us.es/net-next
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next
      Merge git://git.kernel.org/.../davem/net
      ipv4: Make ip_call_ra_chain() return bool.
      ipv4: Make ip_rcv_options() return bool.
      net: Use bool in skbuff.h helper functions.
      net: Use bool in netdevice.h helpers.
      ptp_pch: rename pch_pcidev to pci_driver to fix section mismatch warnings.
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'davem-next.r8169' of git://violet.fr.zoreil.com/romieu/linux
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'master' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'gianfar-bql' of git://git.kernel.org/.../paulg/linux
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      cpsw: Hook up default ndo_change_mtu.

David Spinadel (7):
      iwlwifi: add option to test MFP
      iwlwifi: avoid some operations if no uCode loaded
      iwlwifi: explicitly track whether INIT uCode was run
      iwlwifi: more modularity in fw images and sections
      iwlwifi: Add TLVs and fields for 16.0 uCode
      iwlwifi: change struct iwl_fw
      iwlwifi: Add bool mvm_ucode to iwl_fw

Davidlohr Bueso (1):
      tg3: remove IRQF_SAMPLE_RANDOM flag

Denys Vlasenko (1):
      net: Deinline __nlmsg_put and genlmsg_put. -7k code on i386 defconfig.

Devendra.Naga (2):
      rtlwifi: remove return in _rtl_pci_switch_clk_req
      rtlwifi/rtl8192c: in _rtl92c_phy_calculate_bit_shift remove comparing bitmask against 1

Divy Le Ray (1):
      cxgb3: update firmware version

Dmitry Kravkov (8):
      use FW 7.2.16
      bnx2x: add gro_check
      bnx2x: update driver version to 1.72.10-0
      bnx2x: code doesn't use stats for allocating Rx BDs
      bnx2x: changed initial dcb configuration
      bnx2x: added TLV_NOT_FOUND flags to the dcb
      bnx2x: changed iscsi/fcoe mac init and macros
      bnx2x: validate FW trace prior to its printing

Dmitry Tarnyagin (1):
      caif: Fix for a race in socket transmit with flow control.

Don Fry (16):
      iwlwifi: clarify comment
      iwlwifi: move bcast_sta_id init to common routine
      iwlwifi: move all ucode routines to iwl-ucode.c
      iwlwifi: create iwl_nic structure
      iwlwifi: move ucode_ver to iwl_nic
      iwlwifi: move fw_index from iwl_priv to iwl_nic
      iwlwifi: move firmware_name to iwl_nic
      iwlwifi: move firmware_loading_complete to iwl_nic
      iwlwifi: Move ucode pointers to iwl_fw
      iwlwifi: change args to ucode routines
      iwlwifi: move event and err pointers to iwl_nic
      iwlwifi: changes args to iwl_nic for firmware operations
      iwlwifi: save ucode capabilities in iwl_fw
      iwlwifi: separate status to priv and trans
      iwlwifi: more status bit factoring
      iwlwifi: correct status bit refactoring errors

Don Skidmore (2):
      ixgbe: fix spelling errors
      ixgbe: fix obvious return value bug.

Duc Dang (2):
      powerpc/44x: Add new compatible value for EMAC node of APM821XX dts file.
      powerpc/44x: Add more changes for APM821XX EMAC driver

Eddie Wai (1):
      cnic: Update VLAN ID during ISCSI_UEVENT_PATH_UPDATE

Eliad Peller (37):
      mac80211: check sta_apply_parameters() return value
      mac80211: send null packet on active (psm) reconfiguration
      mac80211: support hw scan while idle
      wl12xx: check bss_conf->assoc on CHANGED_BSSID
      wl12xx: remove wl1271_tx_update_filters
      Revert "wl12xx: Change claiming of the SDIO bus"
      wl12xx: don't release/claim sdio on suspend/resume
      wl12xx: fw api change - add role_id to set_template
      wl12xx: use dev_role_id for scans
      wl12xx: fw api change - add role_id to tsf_info
      wl12xx: fw api change - update cmd/acx/event enums
      wl12xx: add TX_HW_ATTR_HOST_ENCRYPT flag
      wl12xx: add new coex params
      wl12xx: consider encryption and QoS in auto arp template
      wl12xx: Revert "wl12xx: disable auto-arp"
      wl12xx: configure arp filtering only after association
      wl12xx: declare support for hw scan while idle
      wl12xx: don't fail on AP scan
      wl12xx: Use a dedicated fw for PLT
      wl12xx: dynamically change fw according to number of active roles
      wl12xx: enter forced-psm on fw change
      wl12xx: delete wl->vif (and allow multiple vifs)
      mac80211: don't queue monitor work for HW_CONNECTION_MONITOR
      mac80211: remove redundant monitor_work enqueueing
      wl12xx: don't start dev role on ibss vifs
      wl12xx: consider bss_conf->idle instead of hw->conf.flags
      wl12xx: implement sta_state callback
      wl12xx: set authorized AP on sta_state notification
      wl12xx: increment session_counter for device role as well
      wl12xx: set correct vif type in change_interface callback
      wl12xx: don't handle change_channel while associated
      wl12xx: don't allow scanning while device is in ROC
      wl12xx: configure the correct beacon_interval
      wl12xx: avoid bug_on_recovery during fw switch
      wl12xx: print the tx packet len
      mac80211: add NULL terminator to debugfs_netdev write buf
      mac80211: make uapsd_* keys per-vif

Emil Tantilov (1):
      igb: fix warning about unused function

Emmanuel Grumbach (51):
      iwlwifi: add fw_alive to transport layer API, kill tx_start
      iwlwifi: separate the APM from the EEPROM
      iwlwifi: move the shrd memory from priv
      iwlwifi: allocate the transport from the bus layer
      iwlwifi: move the bus configuration to transport
      iwlwifi: the read / write register ops move to transport
      iwlwifi: give trans to all the read / write functions
      iwlwifi: remove the pointer to dev from the bus layer
      iwlwifi: don't use the bus for ucode fw_desc any more
      iwlwifi: rename trans_ops->request_irq to trans_ops->start_hw
      iwlwifi: move prepare_card_hw to start_hw
      iwlwifi: move apm_init to start_hw
      iwlwifi: introduce trans_ops->stop_hw
      iwlwifi: move the RF kill logic from iwl_probe to transport
      iwlwifi: consolidate the start_device flow
      iwlwifi: kill bus_apm_config
      iwlwifi: kill bus_is_pm_supported
      iwlwifi: kill bus_get_hw_id_string
      iwlwifi: kill bus_get_hw_id
      iwlwifi: move hw_rev to transport layer
      iwlwifi: stop_hw replace enable_rfkill_int
      iwlwifi: debug print in tx_queue_set_status is more clear
      iwlwifi: kill iwl_down and s/__iwl_down/iwl_down
      iwlwifi: iwl_set_hw_params returns always 0
      iwlwifi: use enhance_sensitivity from iwl_fw
      iwlwifi: document the transport layer
      iwlwifi: the transport knows its state
      iwlwifi: SRAM size moves from hw_params to cfg
      iwlwifi: parse_tlv functions set the fw_version string
      iwlwifi: move content of iwl_probe to post fetch_fw
      iwlwifi: introducing the drv object's flows
      iwlwifi: drv object can release its own memory
      iwlwifi: rename iwl_remove to iwl_op_mode_dvm_stop
      iwlwifi: virtualize the op_mode
      iwlwifi: use sparse compliant __aligned__ attribute
      iwlwifi: virtualize op_mode's free skb
      iwlwifi: virtualize op_mode's rx
      iwlwifi: virtualize op_mode's stop/start queue
      iwlwifi: virtualize op_mode's set_hw_rf_kill
      iwlwifi: virtualize op_mode's fw_error
      iwlwifi: remove a few dereferences to iwl_priv from the tansport
      iwlwifi: move eeprom defines to iwl-eeprom.c
      iwlwifi: eeprom gets transport and not bus
      iwlwifi: kill iwl_bus.h
      iwlwifi: remove iwl_print_rx_config_cmd from shared
      iwlwifi: remove iwl_reset_traffic_log from shared
      iwlwifi: document the operational mode
      iwlwifi: iwl-trans.h doesn't need all these includes
      iwlwifi: fix IDI compilation
      iwlwifi: log stop / wake queues
      iwlwifi: restore PAN support

Eran (1):
      Bluetooth: Adding USB device 13d3:3375 as an Atheros AR3012.

Eric Dumazet (24):
      vmxnet3: cleanup tso headers manipulation
      be2net: allocate more headroom in incoming skbs
      tcp: add LINUX_MIB_TCPRETRANSFAIL counter
      ipv6: fix RFC5722 comment
      tcp: md5: remove obsolete md5_add() method
      tcp: md5: rcu conversion
      tcp: md5: use sock_kmalloc() to limit md5 keys
      tcp: md5: protects md5sig_info with RCU
      sh-eth: use netdev stats structure and fix dma_map_single
      gro: more generic L2 header check
      virtio: net: remove sparse errors
      gro: fix truesize underestimation
      ppp: fix truesize underestimation
      net_sched: sch_plug: plug_qdisc_ops is static
      af_unix: MSG_TRUNC support for dgram sockets
      mlx4_en: dont change mac_header on xmit
      net: export netdev_stats_to_stats64
      mlx4_en: remove sparse errors
      netfilter: xt_LOG: add __printf() to sb_add()
      tcp: md5: correct a RCU lockdep splat
      asix: asix_rx_fixup surgery to reduce skb truesizes
      tcp: introduce tcp_data_queue_ofo
      tcp: reduce out_of_order memory use
      net: bpf_jit: fix BPF_S_LDX_B_MSH compilation

Erich E. Hoover (2):
      ipv4: Implement IP_UNICAST_IF socket option.
      ipv6: Implement IPV6_UNICAST_IF socket option.

Etay Luz (2):
      ath6kl: add padding to firmware log records
      ath6kl: Collect residue firmware logs

Eugenia Emantayev (8):
      mlx4_core: fix buffer overrun
      mlx4: fix QP tree trashing
      mlx4: remove unused field high_prios
      mlx4: remove unnecessary variables and arguments
      mlx4: remove redundant adding of steering type to gid
      mlx4: attach multicast with correct flag
      mlx4: add unicast steering entries to resource_tracker
      mlx4_core: fix race on comm channel

Eyal Shapira (12):
      wl12xx: remove PS management code
      wl12xx: add support for HW dynamic PS
      wl12xx: add dynamic_ps_timeout debugfs file
      wl12xx: remove 2 unused parameters in wl1271_ps_set_mode()
      wl12xx: enable/disable BET with AUTO_PS/ACTIVE
      wl12xx: change WLVIF_FLAG_PSM name and remove WLVIF_FLAG_PSM_REQUESTED
      wl12xx: Set different wake up conditions in case of suspend
      wl12xx: add suspend_listen_interval debugfs file
      wl12xx: add forced_ps mode
      wl12xx: add forced_ps debugfs file
      wl12xx: use split scan for normal scan
      wl12xx: add split_scan_timeout debugfs file

Fabio Estevam (3):
      net: fec: use module_platform_driver
      net: fec: Fix build due to wrong dev annotation
      Bluetooth: Fix 'enable_hs' type

Felix Fietkau (32):
      mac80211: add #ifdef CONFIG_MAC80211_VERBOSE_DEBUG for a debug printk
      mac80211: do not call rate control .tx_status before .rate_init
      ath9k_hw: remove duplicate initvals
      Revert "ath9k_hw: Fix false tx hung detection in AR9003 chips"
      ath9k: do not call ath9k_hw_txprocdesc on AR9003 outside of the tx tasklet
      ath9k_hw: enable interrupts for beacon tx completion events
      ath9k: fix drv_tx_last_beacon on AR9003 by processing beacon tx status
      mac80211: use 16 bit alignment for the if_ibss bssid field
      mac80211: use compare_ether_addr on MAC addresses instead of memcmp
      mac80211: add an rx flag for ignoring a packet's signal strength
      ath5k: do not stop queues for full calibration
      ath5k: do not re-run AGC calibration periodically
      ath9k_hw: use cold instead of warm reset on AR9280
      ath9k: make MAC sample statistics optional
      ath9k: remove rssi/antenna information from recv debug stats
      ath9k: get rid of double queueing of rx frames on EDMA
      ath9k: fix signal strength reporting issues
      ath9k: fix going to full-sleep on PS idle
      ath9k_hw: simplify tx queue interrupt mask handling
      ath9k_hw: clean up tx completion interrupt handling
      ath9k_hw: remove ath9k_hw_htc_resetinit
      ath9k_hw: remove ath9k_hw_getdefantenna
      ath9k: optimize register access functions
      ath9k_hw: remove ath9k_hw_gettxintrtxqs
      ath9k_hw: clean up ath9k_hw_setuprxdesc
      ath9k_hw: remove iniCommon_*_cck_fir_coeff_9271
      ath9k_hw: fold ar9002_hw_cck_chan14_spread into mode regs initialization
      ath9k_hw: fix AR9380 register settings for channel 14
      ath9k_hw: clean up iniModesAdditional
      ath9k_hw: remove iniModes_*_tx_gain_9271
      ath9k: inline AR9271 1.0 INI overrides
      ath9k_hw: remove unused initvals

Florian Fainelli (1):
      zd1211rw: wait between setting hash table and powering radio on

Francois Romieu (20):
      r8169: remove hardcoded PCIe registers accesses.
      r8169: remove rtl8169_reinit_task.
      r8169: stop delaying workqueue.
      r8169: factor out IntrMask writes.
      r8169: irq mask helpers.
      r8169: missing barriers.
      r8169: remove work from irq handler.
      r8169: fix early queue wake-up.
      r8169: bh locking redux and task scheduling.
      r8169: move task enable boolean to bitfield.
      r8169: avoid a useless work scheduling.
      r8169: spinlock redux.
      r8169: move the driver removal method to the end of the driver file.
      r8169: move the driver probe method to the end of the driver file.
      r8169: move net_device_ops beyond the methods it references.
      r8169: move rtl_set_rx_mode before its rtl_hw_start callers.
      r8169: move rtl8169_open after rtl_task it depends on.
      r8169: move the netpoll handler after the irq handler.
      r8169: move rtl_cfg_info closer to its caller.
      r8169: stop using net_device.{base_addr, irq}.

Frank Blaschka (2):
      qeth: add query OSA address table support
      qeth: synchronize discipline module loading

Franky Lin (1):
      brcm80211: fmac: make sure cancel_work_sync only called after INIT_WORK

Gao feng (1):
      ipv6: fix incorrent ipv6 ipsec packet fragment

Gerrit Renker (1):
      dccp ccid-3: replace incorrect BUG_ON

Gertjan van Wingerde (9):
      rt2x00: Introduce concept of driver data in struct rt2x00_dev.
      rt2x00: Use struct rt2x00_dev driver data in rt2800{pci,usb}.
      rt2x00: Update comment on freq_offset field in struct rt2x00_dev.
      rt2x00: Use saved BBP 25 and 26 values when configuring channel on RT3572.
      rt2x00: Fix RFCSR 12 & 13 programming on RT3572 channel switching.
      rt2x00: Align RT3572 channel switch RFCSR 1 programming with Ralink driver.
      rt2x00: Fix RT3572 channel switch RFCSR 7 programming.
      rt2x00: Correctly set txmixer_gain in RT3572 channel switching.
      rt2x00: Add support for D-Link DWA-127 to rt2800usb.

Greg Dietsche (4):
      iwlegacy: Kconfig: Move Debugging Options
      iwlegacy: Kconfig: Change Debug Option to be more clear
      iwlegacy: remove enum iw_calib and related code
      iwlegacy: remove unused enum il4965_calib_enabled_state

Greg Rose (1):
      rtnetlink: Fix VF IFLA policy

Gregory Greenman (1):
      iwlwifi: Connect IDI transport to driver.

Gustavo F. Padovan (5):
      Bluetooth: Fix coding style with breaking lines
      Bluetooth: Fix coding style in mgmt.h
      Bluetooth: Use correct type for userspace exported structs
      Bluetooth: Fix coding style in all .h files
      Bluetooth: fix conding style issues all over the tree

Haiyang Zhang (6):
      net/hyperv: Convert camel cased variables in rndis_filter.c to lower cases
      net/hyperv: Correct the assignment in netvsc_recv_callback()
      net/hyperv: Remove the unnecessary memset in rndis_filter_send()
      net/hyperv: Fix data corruption in rndis_filter_receive()
      net/hyperv: Add support for vlan trunking from guests
      net/hyperv: Fix the code handling tx busy

Hans Schillstrom (1):
      netfilter: ctnetlink: fix lockep splats

Hauke Mehrtens (22):
      bcma: add the core unit number
      bcma: add constants for PCI and use them
      bcma: export bcma_pcie_read()
      bcma: make some functions __devinit
      bcma: add PCIe host controller
      bcma: add bus num counter
      bcma: add extra sprom check
      bcma: log the id, rev and pkg of the chip found
      ssb: log the id, rev and pkg of the chip found
      ssb: add support for bcm5354
      ssb: sprom fix some sizes / signedness
      ssb: remove 5GHz antenna gain from sprom
      ssb: fix per path sprom vars
      ssb: add alpha2
      ssb: add some missing sprom attributes
      bcma: export bcma_find_core
      bcma: add support for sprom not found on the device
      MIPS: BCM47XX: return number of written bytes in nvram_getenv
      MIPS: BCM47XX: fix signature of nvram_parse_macaddr
      MIPS: BCM47XX: move and extend sprom parsing
      MIPS: BCM47XX: provide sprom to bcma bus
      b43: prevent firmware on bcm5354 from taking over wrong GPIO pins

Heiko Schocher (1):
      phy: add am79c874 PHY support

Helmut Schaa (8):
      mac80211: Fix incorrect num_sta_ps decrement in __sta_info_destroy
      mac80211: Fix incorrect num_sta_ps decrement in ap_sta_ps_end
      mac80211: Move num_sta_ps counter decrement after synchronize_rcu
      mac80211: Limit TID buffering during BA session setup/teardown
      mac80211: Disable MCS > 7 in minstrel_ht when STA uses static SMPS
      rt2x00: Fix beacon skew in rt2800pci
      rt2x00: Set IEEE80211_HW_REPORTS_TX_ACK_STATUS in rt2800
      mac80211: Don't sample max throughput rate in minstrel_ht

Hemant Gupta (2):
      Bluetooth: Send correct response to IO Capability Request
      Bluetooth: Fix clearing of debug and linkkey flags

Hong Wu (2):
      wireless: Save original maximum regulatory transmission power for the calucation of the local maximum transmit power
      mac80211: Fix the maximum transmit power with power constraint

Ido Reis (1):
      wl12xx: increase max probe-req template size to WL1271_CMD_TEMPL_MAX_SIZE

Ido Yariv (5):
      wl12xx: Acquire lock before stopping plt
      wl12xx: Power off after flushing work
      wl12xx: Fix potential interrupt storm
      Bluetooth: Fix access to the STK generation methods matrix
      Bluetooth: Set security level on incoming pairing request

Igor Maravic (1):
      r8169: add byte queue limit support.

Ilan Elias (10):
      NFC: Complete NCI deactivate in deactivate_ntf
      NFC: Increase NCI deactivate timeout
      NFC: Export new attributes sensb_res and sensf_res
      NFC: Add NCI data exchange timer
      NFC: Add endian annotations to nfcwilink driver
      NFC: Download TI NFC init script
      NFC: Free sk_buff if nfcwilink_send fails
      NFC: Clearly separate NCI states from flags
      NFC: NFC core layer should not set the target_idx
      NFC: Add NCI multiple targets support

Jakub Kicinski (3):
      mac80211: use proper sub_if_data on suspend path
      rt2800: Add documentation on MCU requests
      rt2800pci: Fix 'Error - MCU request failed' during initialization

James Kime (1):
      can: plx_pci: add support for IXXAT PCI cards

James M. Leddy (1):
      Bluetooth: btusb: add support for BCM20702A0 [0a5c:21e6]

Jan Engelhardt (2):
      netfilter: ipset: use NFPROTO_ constants
      netfilter: ipset: expose userspace-relevant parts in ip_set.h

Javier Cardona (2):
      mac80211_hwsim: Add tsf to beacons, probe responses and radiotap header.
      mac80211: Modify tsf via debugfs in mesh interfaces

Jeff Kirsher (3):
      igb: fix ethtool offline test
      ixgbe: remove tie between NAPI work limits and interrupt moderation
      ixgbe: fix namespace issues when FCoE/DCB is not enabled

Jeffrey Huang (1):
      cnic: set error flag when iSCSI connection fails

Jesper Juhl (3):
      decnet: remove unused variable from dn_output()
      caif: caifdev is never used in net/caif/caif_dev.c::transmit() - remove it.
      bonding: Fix misspelling of "since"

Jesse Brandeburg (1):
      ixgbe: use typed min/max functions where possible

Jingjun Wu (1):
      rtlwifi: rtl8192ce: Fix loss of receive performance

Jiri Benc (2):
      ipv6: helper function to get tclass
      net: implement IP_RECVTOS for IP_PKTOPTIONS

Jitendra Kalsaria (4):
      qlge: Fixed invalid reference to ip header
      qlge: Removing needless print's which are not
      qlge: Fix memory leak in the process of refill
      qlge: Bumped driver version to 1.00.00.30.

Joe Perches (36):
      rtlwifi: Neaten RT_ASSERT, RT_TRACE, RTPRINT, RT_PRINT_DATA macros
      rtlwifi: Standardize RT_PRINT_DATA macro and uses
      rtlwifi: Convert RT_TRACE macro to use ##__VA_ARGS__
      rtlwifi: Convert RTPRINT macro to use ##__VA_ARGS__
      rtlwifi: Convert RT_ASSERT macro to use ##__VA_ARGS__
      rtlwifi: Remove duplicate __func__
      rtlwifi: Optimize RT_TRACE macro use of KBUILD_MODNAME for size
      rtlwifi: add CONFIG_RTLWIFI_DEBUG to remove all of the debug logging code
      rtlwifi: Remove incorrect logging message prefixes
      rtlwifi: Simplify chip version id logging
      brcm80211: Use normal DEBUG define
      brcmfmac: Convert printk(KERN_DEBUG to pr_debug
      brcm80211: Add and use brcmX_dbg_dump_hex
      brcmfmac: Remove useless #ifdef DEBUG
      brcm80211: Convert printk(KERN_DEBUG to pr_debug
      brcm80211: Use brcmu_dbg_hex_dump
      brcm80211: Use pr_fmt and pr_<level>
      brcmfmac: Trivial typo of "couldn" to "could" fix
      drivers/net: Remove unnecessary k.alloc/v.alloc OOM messages
      drivers/net: Remove alloc_etherdev error messages
      netpoll: Convert printks to np_<level> and add pr_fmt
      netpoll: Neaten MAX_SKB_SIZE macro
      PATCH V2 net-next] net: dev: Convert printks to pr_<level>
      tms380tr: Fix cascading if/else tab abuse
      drivers/net: Remove boolean comparisons to true/false
      Bluetooth: Add logging functions bt_info and bt_err
      isdn: whitespace coding style cleanup
      e1000: Neaten e1000_config_dsp_after_link_change
      gigaset: Use semicolons to terminate statements
      net: Convert printks to pr_<level>
      net: ipv4: Standardize prefixes for message logging
      ixgb: Remove unnecessary defines, use pr_debug
      if_vlan: Remove VLAN_ETH_ALEN define and the 1 use of it
      atlx: Use ETH_ALEN
      igbvf: Use ETH_ALEN
      rtlwifi: Remove unused ETH_ADDR_LEN defines

Johan Hedberg (121):
      Bluetooth: Convert inquiry cache to use standard list types
      Bluetooth: Move Extended Inquiry Response defines to hci.h
      Bluetooth: Add initial mgmt_confirm_name support
      Bluetooth: Return updated name state with hci_inquiry_cache_update
      Bluetooth: Flush inquiry cache when starting mgmt triggered inquiry
      Bluetooth: Rename hdev->inq_cache to hdev->discovery
      Bluetooth: Add discovery state tracking
      Bluetooth: Add name resolving support for mgmt based discovery
      Bluetooth: Remove bogus inline declaration from l2cap_chan_connect
      Bluetooth: Move mgmt related flags from hdev->flags to hdev->dev_flags
      Bluetooth: Fix resetting HCI_MGMT flag
      Bluetooth: Sort to-be-resolved devices by RSSI during discovery
      Bluetooth: Fix clearing persistent flags
      Bluetooth: Rename mgmt connected events to match user space
      Bluetooth: Add eir_len parameter to mgmt_ev_device_found
      Bluetooth: Rename eir_has_complete_name to eir_has_data_type
      Bluetooth: Add missing EIR defines to hci.h
      Bluetooth: Move eir_has_data_field to hci_core.h
      Bluetooth: Merge device class into the EIR data in mgmt_ev_device_found
      Bluetooth: Rename conn->pend to conn->flags
      Bluetooth: Convert hdev->out to a bool type
      Bluetooth: Update device_connected and device_found events to latest API
      Bluetooth: Merge boolean members of struct hci_conn into flags
      Bluetooth: Convert hdev->ssp_mode to a flag
      Bluetooth: Add a convenience function to check for SSP enabled
      Bluetooth: Update mgmt.h to match latest API spec
      Bluetooth: mgmt: Implement Cancel Pair Device command
      Bluetooth: Add missing QUIRK_NO_RESET test to hci_dev_do_close
      Bluetooth: Fix device_found event length for remote name resolving
      Bluetooth: Update and rename mgmt_remove_keys to mgmt_unpair_device
      Bluetooth: Update mgmt_disconnect to match latest API
      Bluetooth: Add address type to user_confirm and user_passkey messages
      Bluetooth: Add address type to Out Of Band mgmt messages
      Bluetooth: Add address type to mgmt blacklist messages
      Bluetooth: Add address type to mgmt_ev_auth_failed
      Bluetooth: Fix mgmt_unpair_device command status
      Bluetooth: Add Device Unpaired mgmt event
      Bluetooth: Implement Read Supported Commands commands for mgmt
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next.git
      Bluetooth: Remove unused member from cmd_lookup struct
      Bluetooth: mgmt: Use more consistent error variable names
      Bluetooth: mgmt: Add support for Set Link Security command
      Bluetooth: mgmt: Add support for Set SSP command
      Bluetooth: mgmt: Add address type to link key messages
      Bluetooth: mgmt: Add address type to PIN code messages
      Bluetooth: mgmt: Add address type to confirm name command
      Bluetooth: Add Intel copyright to mgmt files
      Bluetooth: mgmt: Change ordering of cmd_status paramters
      Bluetooth: mgmt: Move status parameters into the cmd_complete header
      Bluetooth: mgmt: Fix Pair Device response status values
      Bluetooth: mgmt: Fix Start Discovery return parameters
      Bluetooth: mgmt: Fix (Un)Block Device return parameters
      Bluetooth: mgmt: Fix OOB command response parameters
      Bluetooth: mgmt: Bump mgmt version
      Bluetooth: Fix hci_connect error return values
      Bluetooth: mgmt: Add address type parameter to Stop Discovery command
      Bluetooth: mgmt: Add address type parameter to Discovering event
      Bluetooth: mgmt: Add basic support for Set High Speed command
      Bluetooth: mgmt: Fix Set SSP check for supported feature
      Bluetooth: mgmt: Clear EIR data when disabling SSP
      Bluetooth: mgmt: Fix powered checks for commands
      Bluetooth: mgmt: Fix set_local_name and set_dev_class powered checks
      Bluetooth: mgmt: Fix set_fast_connectable error return
      Bluetooth: mgmt: Fix pairable setting upon initialization
      Bluetooth: mgmt: Allow connectable/discoverable changes in off state
      Bluetooth: mgmt: Fix Removing discoverable timeout in set_connectable
      Bluetooth: mgmt: Fix current settings values when powered off
      Bluetooth: mgmt: Add convenience function for sending New Settings
      Bluetooth: mgmt: Fix New Settings event for connectable/discoverable
      Bluetooth: Fix clearing of persistent dev_flags
      Bluetooth: mgmt: Fix connectable/discoverable response values
      Bluetooth: mgmt: Make Set Link Security callable while powered off
      Bluetooth: Remove unneeded hci_cc_read_ssp_mode function
      Bluetooth: mgmt: Make Set SSP command callable while powered off
      Bluetooth: mgmt: Fix EIR toggling with SSP
      Bluetooth: mgmt: Fix clearing of hdev->eir
      Bluetooth: Explicitly clear EIR data upon hci_dev setup
      Bluetooth: mgmt: Fix Set SSP supported check
      Bluetooth: mgmt: Implement Set LE command
      Bluetooth: Fix EIR data clearing when powering off
      Bluetooth: mgmt: Fix updating EIR when updating the name
      Bluetooth: Add hdev->short_name for EIR generation
      Bluetooth: Fix read_name updating when HCI_SETUP is not set
      Bluetooth: mgmt: Allow local name changes while powered off
      Bluetooth: mgmt: Fix name_changed event for short name changes
      Bluetooth: mgmt: Fix missing short_name in read_info
      Bluetooth: Fix clearing of dev_class when powering down
      Bluetooth: mgmt: Fix return value for set_class
      Bluetooth: mgmt: Check for HCI_UP in update_eir() and update_class()
      Bluetooth: mgmt: Allow class of device changes while powered off
      Bluetooth: mgmt: Add missing powered checks to commands
      Bluetooth: mgmt: Fix unpair_device responses
      Bluetooth: mgmt: Fix device_found parameters
      Bluetooth: mgmt: Add legacy pairing info to dev_found events
      Bluetooth: mgmt: Fix count parameter in get_connections reply
      Bluetooth: mgmt: Fix update_eir/class with HCI_AUTO_OFF flag set
      Bluetooth: mgmt: Fix return value of add/remove_uuid
      Bluetooth: mgmt: Move service cache setting to a more sensible place
      Bluetooth: mgmt: Fix clear UUIDs response
      Bluetooth: mgmt: Add flags parameter to device_connected
      Bluetooth: mgmt: Track pending class changes
      Bluetooth: mgmt: Fix dev_class related command response timing
      Bluetooth: mgmt: Fix clear_uuids response
      Bluetooth: Fix init request completion with old controllers
      Bluetooth: Use kernel int types instead of ones from stdint.h
      Bluetooth: Don't send unnecessary write_le_enable command
      Bluetooth: Remove redundant read_host_features commands
      Bluetooth: Add missing host features definitions
      Bluetooth: Use LMP_HOST_SSP define instead of magic values
      Bluetooth: mgmt: Add missing hci_dev locking to set_le()
      Bluetooth: Fix init sequence for some CSR based controllers
      Bluetooth: mgmt: Refactor hci_dev lookup for commands
      Bluetooth: mgmt: Initialize HCI_MGMT flag for any command
      Bluetooth: mgmt: Move command handlers into a table
      Bluetooth: mgmt: Add defines for command sizes
      Bluetooth: mgmt: Centralize message length checks
      Bluetooth: Fix clearing of HCI_PENDING_CLASS flag
      Bluetooth: mgmt: Fix command status error code values
      Bluetooth: mgmt: Add new error code for invalid index
      Bluetooth: Remove HCI_PI_MGMT_INIT flag for sockets
      Bluetooth: mgmt: Fix updating local name when powering on

Johannes Berg (143):
      mac80211: refactor __ieee80211_get_channel_mode
      mac80211: clean up aggregation destruction
      mac80211: clean up rate control code
      mac80211: make beacon filtering per virtual interface
      mac80211: make CQM RSSI support per virtual interface
      mac80211: fix a few -Wshadow warnings
      cfg80211: fix a few -Wshadow warnings
      iwlwifi: fix uCode event tracing
      iwlwifi: always restrict scan dwell in P2P
      mac80211: station state transition error handling
      iwlwifi: fix uCode event tracing
      iwlwifi: always restrict scan dwell in P2P
      iwlwifi: release IRQ in error path
      mac80211: move managed mode station state modification
      mac80211: simplify AP_VLAN handling
      mac80211: dont program keys for stations not uploaded
      mac80211: add NOTEXIST station state
      mac80211: add sta_state callback
      mac80211: implement sta_add/sta_remove in sta_state
      mac80211: remove dummy STA support
      cfg80211: stop tracking authenticated state
      cfg80211: export cfg80211_ref_bss
      mac80211: redesign auth/assoc
      mac80211: call rate control only after init
      iwlwifi: trace debug messages
      iwlwifi: move workqueue to priv
      iwlwifi: give PCIe its own lock
      cfg80211: restructure AP/GO mode API
      mac80211: clean up asm/unaligned.h inclusion
      mac80211: fix associated vs. idle race
      mac80211: fix auth/assoc data & timer leak
      mac80211: fix sta_info_flush() return value
      mac80211: remove local_to_hw
      iwlwifi: move uCode flags handling to op_mode
      cfg80211: remove cookies from callbacks
      mac80211: dont call cfg80211 from ieee80211_send_deauth_disassoc
      mac80211: fix ieee80211_set_disassoc() sending DelBA
      mac80211: make deauth/disassoc sequence more natural
      mac80211: handle non-bufferable MMPDUs correctly
      cfg80211: fix kernel-doc
      mac80211: use common radiotap code for cooked monitors
      mac80211: combine QoS with other BSS changes
      cfg80211/mac80211: report signal strength for mgmt frames
      iwlwifi: always monitor for stuck queues
      iwlwifi: move iwl_clear_driver_stations to user
      iwlwifi: remove an unused argument
      iwlwifi: reduce sta_lock hold time in TX
      iwlwifi: simplify code in iwlagn_key_sta_id
      iwlwifi: build some station commands directly
      iwlwifi: introduce per-queue locks
      iwlwifi: make sta lock private & BH lock
      iwlwifi: introduce statistics lock
      iwlwifi: remove shared lock
      iwlwifi: make EXIT_PENDING depend on mac80211
      iwlwifi: simplify auth/assoc flow
      iwlwifi: remove per-device debug level
      iwlwifi: remove SKU from config
      iwlwifi: use valid TX/RX antenna from hw_params
      iwlwifi: make config const
      iwlwifi: reduce IDI code ifdef
      iwlwifi: clean up (wowlan) suspend flow
      iwlwifi: move wowlan bool into priv
      iwlwifi: use ieee80211_tx_status
      iwlwifi: pass response packet directly
      iwlwifi: don't pass iwl_rx_mem_buffer to upper layers
      iwlwifi: refactor PCI-E RX path
      iwlwifi: transport's tx_agg_alloc must not sleep
      iwlwifi: move queue functions to PCI-E
      iwlwifi: iwl_rx_cmd_buffer belongs to transport API
      iwlwifi: move tid_to_ac to PCI-E
      iwlwifi: move IWL_MASK into file using it
      iwlwifi: move traffic log definitions
      iwlwifi: fix station HT parameters
      iwlwifi: move uCode deallocation to drv
      iwlwifi: move iwl_base_params to shared header
      iwlwifi: move firmware request into drv
      iwlwifi: move firmware completion wait
      iwlwifi: move ucode loading to op_mode
      iwlwifi: split out firmware store
      iwlwifi: remove iwl-wifi.h
      iwlwifi: add wrappers for command sending
      iwlwifi: move RF/CT kill check to command wrapper
      iwlwifi: move lockdep assertion into DVM
      iwlwifi: move mutex out of shared
      iwlwifi: move rfkill status handling out of transport
      iwlwifi: rename ucode.h to fw-file.h
      iwlwifi: remove AMT check from transport
      iwlwifi: remove shadow_reg_enable from hw_params
      iwlwifi: move status check functions out of shared
      iwlwifi: make tracing use device as identifier
      iwlwifi: virtualize command queue full behaviour
      iwlwifi: clean up iwl-core.h inclusions
      iwlwifi: remove num_of_queues module parameter
      iwlwifi: remove max_txq_num from hw_params
      iwlwifi: keep plcp_delta_threshold in priv
      iwlwifi: use watchdog timeout from hw_params
      iwlwifi: put use_rts_for_aggregation into hw_params
      iwlwifi: constify remaining config data
      iwlwifi: fix notification wait bug
      iwlwifi: abstract out notification wait support
      iwlwifi: move ucode_owner to priv
      iwlwifi: move all uCode load variables
      iwlwifi: move irq to PCIe
      iwlwifi: move packet to transport
      iwlwifi: virtualize nic_config
      iwlwifi: remove priv from shared
      iwlwifi: remove PA type configuration
      iwlwifi: don't include iwl-prph.h everywhere
      iwlwifi: clean up iwl-commands.h
      iwlwifi: make iwl_fill_probe_req static
      iwlwifi: remove unused arguments from iwlagn_gain_computation
      iwlwifi: remove unused argument from rs_initialize_lq
      iwlwifi: move iwl_sta_id_or_broadcast to user
      iwlwifi: remove unused argument from iwl_init_hw_rates
      iwlwifi: remove two unused arguments in testmode
      iwlwifi: remove unused argument from iwlagn_suspend
      iwlwifi: redesign PASSIVE_NO_RX workaround
      iwlwifi: transport's tx_agg_disable must be atomic
      iwlwifi: remove BT handlers from lib_ops
      iwlwifi: move BT/HT params to shared
      iwlwifi: make EEPROM enhanced TX power a bool
      iwlwifi: remove unused max_nrg_cck from sensitivity and constify
      iwlwifi: return error if loading uCode failed
      iwlwifi: remove messages from queue wake/stop
      iwlwifi: make iwl_init_context static
      iwlwifi: don't delete AP station directly
      mac80211: remove tx_sync
      mac80211: set channel back after disassociating
      mac80211: add auth/assoc/deauth flow diagram
      iwlwifi: remove TX hex debug
      iwlwifi: abstract out missing SEQ_RX_FRAME workaround
      iwlwifi: convert bad state message into warning
      mac80211: move misplaced comment
      mac80211: simplify HT checks
      mac80211: simplify wmm check during association
      mac80211: remove spurious BSSID change flag
      mac80211: refactor common auth/assoc setup code
      mac80211: set basic rates earlier
      mac80211: move RX WEP weak IV counting
      mac80211: linearize SKBs as needed for crypto
      brmc80211: dont use jiffies for BSS TSF
      cfg80211: clarify timestamp in cfg80211_inform_bss
      mac80211: rename bss_conf timestamp to last_tsf

John Fastabend (3):
      ixgbe: dcb: check setup_tc return codes
      net: dcb: getnumtcs()/setnumtcs() should return an int
      ixgbe: dcb: use DCB config values for FCoE traffic class on open

John Li (4):
      rt2x00:Fix typo
      rt2x00:Add debug message for new chipset
      rt2x00:Add VCO recalibration
      rt2x00:Add RT5372 chipset support

John W. Linville (19):
      ath5k: use bool type for no_hw_rfkill_switch module parameter
      orinoco_usb: remove version definition
      ath9k: use WARN_ON_ONCE in ath_rc_get_highest_rix
      Revert "mac80211: Do not scan for IBSS merge with a fixed BSSID."
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://github.com/kvalo/ath6kl
      Merge branch 'wireless-next' of git://git.kernel.org/.../iwlwifi/iwlwifi
      rtlwifi: Modify rtl_pci_init to return 0 on success
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'wireless-next' of git://git.kernel.org/.../iwlwifi/iwlwifi
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      carl9170: fix breakage from "mac80211: handle non-bufferable MMPDUs correctly"
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://github.com/kvalo/ath6kl
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jonathan Bither (1):
      ath5k:Remove __raw_read and __raw_write

Jouni Malinen (3):
      ath6kl: Fix connect command to clear previously used IEs
      ath6kl: Add del_station cfg80211_ops
      ath6kl: Advertise TX/RX support for frames in AP mode

Jozsef Kadlecsik (3):
      netfilter: ipset: Log warning when a hash type of set gets full
      netfilter: ipset: Exceptions support added to hash:*net* types
      netfilter: ipset: hash:net,iface timeout bug fixed

Julia Lawall (3):
      drivers/net/wireless/mwifiex/scan.c: convert GFP_KERNEL to GFP_ATOMIC
      drivers/atm/eni.c: ensure arguments to request_irq and free_irq are compatible
      drivers/net/irda/{ali-ircc, via-ircc, w83977af-ir}.c: ensure arguments to request_irq and free_irq are compatible

Junchang Wang (2):
      r8169: add 64bit statistics.
      8139too: Add 64bit statistics

Jussi Kivilinna (3):
      rndis_wlan: fix le16/le32_to_cpu mix up with config.beacon_period
      rndis_wlan: use RNDIS_WLAN_NUM_KEYS for all key index checks
      rndis_wlan: use u8 for key indexes

Kalle Valo (36):
      ath6kl: handle firmware names more dynamically
      ath6kl: add support for FW API 3
      Merge remote branch 'wireless-next/master' into ath6kl-next
      ath6kl: use netdev_features_t
      ath6kl: remove -D__CHECK_ENDIAN__ from Makefile
      ath6kl: fix uninitialized warning in ath6kl_process_uapsdq()
      ath6kl: rename vif init and cleanup functions
      ath6kl: unify cfg80211 init/cleanup functions
      ath6kl: add ATH6KL_CONF_UART_DEBUG
      ath6kl: create core.c
      ath6kl: get rid of AR_DBG_LVL_CHECK()
      ath6kl: convert ath6kl_dbg() and ath6kl_dbg_dump() into functions
      ath6kl: create ath6kl_core.ko
      ath6kl: add back beginnings of USB support
      ath6kl: fix testmode when fw-2.bin or fw-3.bin is used
      ath6kl: fix compiler warning in ath6kl_init_hw_params()
      ath6kl: store firmware logs in skbuffs
      ath6kl: add blocking debugfs file for retrieving firmware logs
      Merge remote branch 'wireless-next/master' into ath6kl-next
      ath6kl: fix pointer style
      ath6kl: fix checkpatch error with EPSTAT() macro
      ath6kl: alignment should match open parenthesis
      ath6kl: logical continuations should be on the previous line
      ath6kl: remove multiple assignments
      ath6kl: add ath6kl_bmi_write_hi32()
      ath6kl: add ath6kl_bmi_read_hi32()
      ath6kl: fix error handling ath6kl_target_config_wlan_params()
      ath6kl: fix open paranthesis alignment in ath6kl_cfg80211_connect()
      ath6kl: document all spinlocks
      ath6kl: fix too long lines
      ath6kl: make ath6kl_bmi_[read|write]_hi32() endian safe
      ath6kl: fix regression in ath6kl_upload_board_file()
      ath6kl: replace strict_strtoul() with kstrtoul()
      ath6kl: fix open parenthesis alignment in ath6kl_sdio_suspend()
      ath6kl: use max_t() in ath6kl_cfg80211_connect()
      ath6kl: fix debug.c file mode

Keng-Yu Lin (1):
      Bluetooth: Add AR30XX device ID on Asus laptops

Kenny Hsu (8):
      iwlwifi: update testmode command of direct register access
      iwlwifi: enhance testmode command sram_read
      iwlwifi: update error dump in testmode command sram_read
      iwlwifi: add testmode cmd IWL_TM_CMD_APP2DEV_GET_FW_INFO
      iwlwifi: update testmode command of direct register access
      iwlwifi: enhance testmode command sram_read
      iwlwifi: update error dump in testmode command sram_read
      iwlwifi: add testmode cmd IWL_TM_CMD_APP2DEV_GET_FW_INFO

Klaus-Dieter Wacker (1):
      lcs: Return zero from ccwgroup devs set_offline function

Konrad Rzeszutek Wilk (1):
      xen/netfront: add netconsole support.

Krishna Gudipati (1):
      bna: Implement ethtool flash_device entry point.

Larry Finger (19):
      rtlwifi: rtl8192c_common: rtl8192de: Check for allocation failures
      rtl8192cu: Remove dead code never selected
      rtlwifi: Update copyright dates
      rtl8192c_common: Update copyright dates
      rtl8192ce: Update copyright dates
      rtl8192cu: Update copyright dates
      rtl8192de: Update copyright dates
      rtl8192se: Update copyright dates
      bcma: Enable logging of SPROM offset
      rtlwifi: Move pr_fmt macros to a single location
      rtlwifi: Convert to asynchronous firmware load
      rtlwifi: Remove extra debugging message accidentally left in
      rtlwifi: rtl8192c-common: rtl8192se: rtl8192de: Simplify if statements
      rtlwifi: Fix breakage in debug functions when built as a module
      rtlwifi: Detect misread of end-point count
      rtlwifi: Remove extraneous value return
      rtlwifi: rtl8192c: Prevent sleeping from invalid context in rtl8192cu
      b43legacy: Load firmware from work queue instead of from probe routine
      b43: Load firmware from a work queue and not from the probe routine

Li Wei (1):
      ipv6: Fix Smatch warning.

Luciano Coelho (12):
      wl1251: fix sparse warning
      wl1251: convert 32-bit values to le32 before writing to the chip
      wl1251: enable sparse endianess check by default
      wl12xx: enable sparse endianess check by default
      wl12xx: cancel delayed elp work and clear flags when stopping PLT
      wl12xx: move partition table definition to io.c
      wl12xx: read chip ID and HW PG version during probe
      wl12xx: use two MAC addresses based on the NVS or from fuse ROM
      wl12xx: add testmode operation to read the BD_ADDR from Fuse ROM
      wl12xx: remove unnecessary shadow declaration
      wl12xx: fix typo in fwlog module param description
      Merge branch 'wl12xx-next' into for-linville

Luis R. Rodriguez (1):
      mac80211: rename mesh static path_lookup()

Luiz Augusto von Dentz (1):
      Bluetooth: Fix using uninitialized variable

Maciej ≈ªenczykowski (1):
      net: get rid of some pointless casts to sockaddr

Manish chopra (2):
      netxen_nic: fw dump support
      qlcnic: Fix API unlock

Manoj Iyer (1):
      Bluetooth: btusb: Add vendor specific ID (0a5c 21f3) for BCM20702A0

Marc Kleine-Budde (1):
      can: dev: let can_get_echo_skb() return dlc of CAN frame

Marcel Holtmann (25):
      Bluetooth: Split sending for HCI raw and control sockets
      Bluetooth: Remove unneeded bt_cb(skb)->channel variable
      Bluetooth: Limit HCI raw socket options to actual raw sockets
      Bluetooth: Lock socket when reading HCI socket options
      Bluetooth: Add HCI CMSG details only to raw sockets
      Bluetooth: Simplify HCI socket bind handling
      Bluetooth: Fix issue with shared SKB between HCI raw socket and driver
      Bluetooth: Remove HCI notifier handling
      Bluetooth: Add support for HCI monitor channel
      Bluetooth: Restrict access to management interface
      Bluetooth: Set supported settings based on enabled HS and/or LE
      Bluetooth: Always enable management interface
      Bluetooth: Fix parameter list for setting local name
      Bluetooth: Only keep controller up after init if powered on
      Bluetooth: Don't send New Settings event during setup power down
      Bluetooth: Fix two minor style issues in management code
      Bluetooth: Fix two minor style issues in HCI code
      Bluetooth: Enable timestamps for control channel
      Bluetooth: Disabling discoverable with timeout is invalid
      Bluetooth: Fix handling of discoverable setting with timeout
      Bluetooth: Send management event for class of device changes
      Bluetooth: Allow HCI UART reset parameter via flags ioctl
      Bluetooth: Add support for creating HCI UART based AMP controllers
      Bluetooth: Update L2CAP timeout constants to use msecs_to_jiffies
      Bluetooth: Update MGMT and SMP timeout constants to use msecs_to_jiffies

Marek Lindner (7):
      batman-adv: simplify bat_ogm_receive API call
      batman-adv: warn if added interface is part of a bridge
      batman-adv: add infrastructure to change routing algorithm at runtime
      batman-adv: convert batman iv algorithm to use dynamic infrastructure
      batman-adv: convert time_after instances to has_timed_out
      batman-adv: allowing changing the routing algorithm via module parameter
      batman-adv: export used routing algorithm via sysfs

Martin Hundeb√∏ll (2):
      batman-adv: Rm empty line from is_my_mac() in main.c
      batman-adv: Move is_out_of_time() to main.h for general use

Masanari Iida (15):
      atm: Fix typo in lanai.c
      vmxnet3: Fix typo in vmxnet3_drv.c
      ath6kl: Fix typo in cfg80211.c
      mlx4: Fix typo in cmd.c
      net: Fix typo in ipw2x00/libipw_rx.c
      iwmc3200wifi: Fix typo in trace.h
      rtlwifi: Fix typo in dm.c
      stmmac: Fix typo in stmmac_pci.c
      aeroflex: Fix typo in greth.c
      isdn: Fix typo in callc.c and tei.c
      isdn: Fix typo in isdn_ppp.c
      mISDN: Fix typo in dsp_core.c
      stmicro: Fix typo in stmmac_pci.c and stmmac_platform.c
      ethernet: Fix typo in lantiq_etop.c
      wireless: Fix typo in mac80211_hwsim.c

Matt Carlson (23):
      tg3: Move tg3_restart_hw to a better location
      tg3: Relocate tg3_reset_task
      tg3: Move tg3_change_mtu to a better location
      tg3: Move tg3_set_rx_mode
      tg3: Move tg3_nvram_write_block functions
      tg3: Relocate tg3_find_peer
      tg3: Eliminate unneeded prototype
      tg3: Move transmit comment to a better location
      tg3: Disable new DMA engine for 57766
      tg3: Fix stats while interface is down
      tg3: Fix copper autoneg adv checks
      tg3: Fix NVRAM page writes on newer devices
      tg3: Reduce UMP event collision window
      tg3: Consolidate ASIC rev detection code
      tg3: Remove unused link config code
      tg3: Remove unneeded link_config.orig_... members
      tg3: Use *_UNKNOWN ethtool definitions
      tg3: Update copyright
      tg3: Fix link check in tg3_adjust_link
      tg3: Remove SPEED_UNKNOWN checks
      tg3: Clear RECOVERY_PENDING with reset_task_cancel
      tg3: Create timer helper functions
      tg3: Recode PCI MRRS adjustment as a PCI quirk

Matthew Slattery (1):
      sfc: Support extraction of CAPABILITIES from GET_BOARD_CFG response.

Max Filippov (1):
      p54spi: Release GPIO lines and IRQ on error in p54spi_probe

Meenakshi Venkataraman (5):
      iwlwifi: enable receiving beacons when not associated
      iwlwifi: configure transport layer from dvm op mode
      iwlwifi: move setting up fw parameters
      iwlwifi: move command queue number out of the iwl_shared struct
      iwlwifi: move wait_command_queue from shared to trans

Merav Sicron (1):
      bnx2x: revised driver prints

Michael Chan (6):
      bnx2: Add support for ethtool --show-channels|--set-channels
      cnic: Add FCoE parity error recovery
      cnic: update for FW 7.2.xx
      tg3: Fix jumbo loopback test on 5719
      tg3: Add memory barriers to sync BD data
      tg3: Fix poor tx performance on 57766 after MTU change

Michal Schmidt (1):
      bnx2x: make bnx2x_close() static again

Mintz Yuval (11):
      bnx2x: consistent statistics after internal driver reload
      bnx2x: half duplex support added for several boards
      bnx2x: ethtool publishes link partners speed and FC
      bnx2x: added autoneg-restart after link advertisement changes
      bnx2x: force 10G on 84833 phy should be autoneg with only 10G advertised
      bnx2x: allocate memory dynamically in ethtool self-test.
      bnx2x: allocate smaller Rx rings for 1G functions
      bnx2x: notify cnic of address of info-to-the-mcp
      bnx2x: allow BCM84833 phy to advertise 100Base-T speeds
      bnx2x: removed code re-checking memory base after device open
      bnx2x: allow all functions to display the phy FW version

Mitch A Williams (1):
      igbvf: refactor Interrupt Throttle Rate code

Mohammed Shafi Shajakhan (6):
      mac80211: minor cleanup
      ath9k: remove obsolete comments
      ath9k: remove unnecessary PS wrappers
      ath9k: completely zero intialize valid_phy_rate_idx
      ath9k: make use of list_for_each_entry_safe
      ath9k_hw: Fix enabling of MCI and RTT

Mugunthan V N (2):
      netdev: driver: ethernet: add cpsw address lookup engine support
      netdev: driver: ethernet: Add TI CPSW driver

Naveen Gangadharan (2):
      ath6kl: Fix firmware crash dump
      ath6kl: Add unicast mgmt frame buffering

Neel Patel (3):
      enic: Enable support for multiple hardware receive queues
      enic: Check firmware capability before issuing firmware commands
      enic: Update enic maintainers

Neil Horman (1):
      arp: allow arp processing to honor per interface arp_accept sysctl

Nicolas Cavallari (2):
      carl9170: claim to support IBSS RSN.
      mac80211: Do not scan for IBSS merge with a fixed BSSID.

Octavian Purdila (2):
      Bluetooth: silence lockdep warning
      Bluetooth: Fix RFCOMM session reference counting issue

Or Gerlitz (2):
      net/mlx4: fix sparse warnings on TX control flags, endianess
      net/mlx4: fix sparse warnings on TX blue flame buffer

Pablo Neira Ayuso (14):
      netlink: add netlink_dump_control structure for netlink_dump_start()
      netlink: allow to pass data pointer to netlink_dump_start() callback
      netfilter: ctnetlink: support kernel-space dump filtering by ctmark
      netfilter: ctnetlink: allow to set helper for new expectations
      netfilter: ctnetlink: allow to set expectation class
      netfilter: ctnetlink: add NAT support for expectations
      netfilter: ctnetlink: allow to set expectfn for expectations
      netfilter: nf_ct_udp[lite]: convert UDP[lite] timeouts to array
      netfilter: nf_ct_tcp: move retransmission and unacknowledged timeout to array
      netfilter: nf_ct_gre: add unsigned int array to define timeouts
      netfilter: nf_conntrack: pass timeout array to l4->new and l4->packet
      netfilter: add cttimeout infrastructure for fine timeout tuning
      netfilter: nf_ct_ext: add timeout extension
      netfilter: xt_CT: allow to attach timeout policy + glue code

Padmanabh Ratnakar (2):
      be2net: Fix link status query command
      be2net: Use new implementation of get mac list command

Paul Gortmaker (8):
      drivers/net: fix up stale paths from driver reorg
      drivers/net: strip unused module code from sun3_82586.c
      tipc: nuke the delimit static inline function.
      ucc_geth: separate out rx/tx ring alloc and free operations
      gianfar: Add support for byte queue limits.
      gianfar: constify giant block of status descriptor strings
      gianfar: delete orphaned version strings and dead macros
      gianfar: use netif_tx_queue_stopped instead of __netif_subqueue_stopped

Paul Mackerras (3):
      ppp: Change copyright notices from ANU to me
      ppp: Move ioctl definitions from if_ppp.h to new ppp-ioctl.h
      ppp: Replace uses of <linux/if_ppp.h> with <linux/ppp-ioctl.h>

Paul Stewart (2):
      mac80211: Filter duplicate IE ids
      mac80211: Don't let regulatory make us deaf

Pavel Emelyanov (6):
      datagram: Factor out sk queue referencing
      datagram: Add offset argument to __skb_recv_datagram
      skb: Add skb_peek_next helper
      sock: Introduce the SO_PEEK_OFF sock option
      unix: Support peeking offset for datagram and seqpacket sockets
      unix: Support peeking offset for stream sockets

Pavel Roskin (1):
      ath9k: avoid useless cast from (struct ath_rateset *) to (u8 *) and back

Peter Hurley (1):
      Bluetooth: Fix l2cap conn failures for ssp devices

Peter P Waskiewicz Jr (1):
      ixgbe: Add module parameter to allow untested and unsafe SFP+ modules

Peter Pan(ÊΩòÂç´Âπ≥) (1):
      bonding: send igmp report for its master

Philipp Zabel (1):
      net/irda: add clk_prepare/clk_unprepare to pxaficp_ir

Pontus Fuchs (3):
      wl12xx: Make sure HW is available in sched scan ops
      wl12xx: Set IEEE80211_TX_RC_MCS on MCS rates on TX complete.
      wl12xx: Set IEEE80211_TX_RC_SHORT_GI if short GI was used on

Pradeep A Dalvi (3):
      netdev: ethernet dev_alloc_skb to netdev_alloc_skb
      netdev: ethernet dev_alloc_skb to netdev_alloc_skb
      netdev: ethernet dev_alloc_skb to netdev_alloc_skb

Pradeep A. Dalvi (3):
      mace: Fix build for mace due to netdev_alloc_skb
      netdev: ethernet dev_alloc_skb to netdev_alloc_skb
      netdev: ethernet dev_alloc_skb to netdev_alloc_skb

Prasanna Kumar (1):
      ath6kl: add support for AR6003 2048 byte board file

Rafa≈Ç Mi≈Çecki (13):
      ssb: SPROM: extract each core power info
      bcma: SPROM: add macro for easier extraction
      bcma: SPROM: extract power info for cores
      b43: add maskset helpers
      b43: N-PHY: implement TX power control setup
      b43: N-PHY: add helper for getting gain table
      b43: N-PHY: fix typos in RF control
      b43: N-PHY: upload PAPD PGA gain delta table
      b43: N-PHY: implement RSSI calibration for rev3+
      b43: N-PHY: trivial: change save&rest order in RSSI polling
      MAINTAINERS: update b43(legacy) mailing list
      brcm80211: fmac: use correct firmware filename
      bcma: silence PMU warning for BCM4331

Raja Mani (14):
      ath6kl: Avoid taking struct as argument in ath6kl_wmi_set_ip_cmd
      ath6kl: Send own IP addr to the firmware during WOW suspend
      ath6kl: Remove useless initialization in ath6kl_read_fwlogs()
      ath6kl: Re-architect suspend mode handling in ath6kl_sdio_suspend
      ath6kl: Configure WOW patterns while going to wow_suspend
      ath6kl: Wait for host sleep mode cmd processed event during WOW suspend
      ath6kl: Return a proper error code when not in connected state
      ath6kl: Lower SDIO pad drive strength for hw2.1.1 board
      ath6kl: Fix random system lockup
      ath6kl: Restrict memcpy to bounce buffer only for write request
      ath6kl: Add provision to define suspend policy in disconnected state.
      ath6kl: Check wow state before sending control and data pkt
      ath6kl: Maintain the listen interval per VIF specific
      ath6kl: Set optimal listen intvl,bmiss,scan params while going to wow suspend

Rajesh Borundia (1):
      netxen: Fix a panic during driver unload in device_remove_file

Rajkumar Manoharan (1):
      ath9k: configure bss info at assoc notification

Rami Rosen (2):
      xfrm: remove unneeded method typedef declaration in net/xfrm.h.
      pxa168: remove unused stats member.

Randy Dunlap (1):
      kernel-doc: fix new warnings in cfg80211.h

Reuben Dowle (1):
      can: flexcan: Fix CAN_RAW_RECV_OWN_MSGS and CAN_RAW_LOOPBACK

Richard Cochran (3):
      r8169: enable transmit time stamping.
      MAINTAINERS: add an entry for the PHC code
      phc: Update author's email address.

Richard Weinberger (2):
      netfilter: merge ipt_LOG and ip6_LOG into xt_LOG
      netfilter: xt_LOG: fix bogus extra layer-4 logging information

Rishi Panjwani (1):
      ath6kl: Support for TCP checksum offload to firmware

Robert Stonehouse (1):
      sfc: Fix calculation of vf_i in map_vi_index()

Roland Dreier (2):
      IPoIB: Stop lying about hard_header_len and use skb->cb to stash LL addresses
      be2net: Remove unused OFFSET_IN_PAGE() macro

Roopa Prabhu (7):
      enic: Fix address deregistration for sriov vf during port profile disassociate
      enic: remove assignment of random mac on enic vf
      enic: rename CMD_MAC_ADDR to CMD_GET_MAC_ADDR
      enic: Add new fw devcmd to set mac address of an interface
      enic: Fix ndo_set_vf_mac and ndo_set_vf_port to set/get the sriov vf's mac
      enic: Add support for fw init command on sriov vf's
      enic: Fix addr valid check in enic_set_vf_mac

Samuel Jero (1):
      dccp: fix bug in sequence number validation during connection setup

Samuel Ortiz (22):
      NFC: Export NFCID1 from pn533
      NFC: Add device powered netlink attribute
      NFC: Factorize the I frame queueing routine
      NFC: Handle Receiver Not Ready LLCP frame
      NFC: LLCP socket sendmsg implemetation
      NFC: Fix bitops usage in LLCP
      NFC: Clear pn533 target structure
      NFC: Clear LLCP SDPs whan MAC goes down
      NFC: Set the right LLCP N(R) value for I frames
      NFC: Send LLCP RR frames to acknowledge received I frames
      NFC: Set MIU and RW values from CONNECT and CC LLCP frames
      NFC: Fragment LLCP I frames
      NFC: Export sensf from pn533
      NFC: Export Jewel/Topaz ID from pn533
      NFC: Export NFCID when detecting a p2p target with pn533
      NFC: Unlink LLCP child sockets from llcp_sock_release
      NFC: SN is not an invalid GT value
      NFC: Remove the rf mode parameter from the DEP link up routine
      NFC: Fix LLCP sockets releasing path
      NFC: LLCP code identation fixes
      NFC: Core code identation fixes
      NFC: NCI code identation fixes

Santosh Nayak (2):
      qla3xxx: ethernet: Silence static checker warning.
      netxen: qlogic ethernet : Fix endian bug.

Santosh Sajjan (1):
      ath6kl: Workaround to support Deep Sleep with MSM.

Sathya Perla (7):
      be2net: add descriptions for stat counters reported via ethtool
      be2net: event queue re-design
      be2net: cancel be_worker during EEH recovery
      be2net: fix tx completion cleanup
      be2net: reset queue address after freeing
      be2net: enable RSS for ipv6 pkts
      be2net: update driver version

Sebastian Haas (2):
      can: ems_usb: Removed double netif_device_detach
      can: ems_usb: Improved memory handling on ems_usb_start

Shawn Lu (1):
      tcp: md5: RST: getting md5 key from listener

Shreyas Bhatewara (1):
      vmxnet3: Fix log messages and corrects some typos

Shriram Rajagopalan (1):
      net/sched: sch_plug - Queue traffic until an explicit release command

Simon Graham (2):
      rtlwifi: Handle previous allocation failures when freeing device memory
      rtlwifi: Return correct failure code on error

Simon Wunderlich (3):
      nl80211: add support for mcs masks
      mac80211: add support for mcs masks
      mac80211: update ieee80211_tx_rate_control kerneldoc

Sony Chacko (2):
      netxen: report valid speed and duplex status when link is down
      qlcnic: report valid speed and duplex status when link is down

Sritej Velaga (6):
      netxen_nic: fix cdrp race condition
      netxen_nic: Fix phy link status
      netxen_nic: Error logging on firmware hang
      qlcnic: Stop pause ctrl frames on fw hang.
      qlcnic: Fix firmware abort code check.
      qlge: Updating Schultz LICENSE.qlge file.

Stanislav Yakovlev (4):
      net/wireless: ipw2x00: Use IW_HANDLER macro from linux/wireless.h
      ipw2x00: remove ipw2100_rates_11b[]
      net/wireless: ipw2x00: remove WEXT_USECHANNELS define
      net/wireless: ipw2x00: remove unused definitions for regulatory domain

Stanislaw Gruszka (70):
      rt2800usb: initialize H2M_INT_SRC register
      rt2800: disable DMA after firmware load
      rt2800: zero MAC_SYS_CTRL bits during BBP and MAC reset
      rt2800usb: remove PWR_PIN_CFG=0x3 during init
      rt2800: radio 3xxx: reprogram only lower bits of RF_R3
      rt2800: radio 3xxx: program RF_R1 during channel switch
      rt2800: radio 3xxx: add channel switch calibration routines
      rt2800: radio 3xxxx: channel switch RX/TX calibration fixes
      rt2800: document RF_R03 register bits [7:4]
      iwlegacy: move rxon commands out of ctx structure
      iwlegacy: get rid of ctx->rxon_cmd
      iwlegacy: get rid of ctx->rxon_timing_cmd
      iwlegacy: get rid of rxon_assoc_cmd
      iwlegacy: get rid of qos_cmd
      iwlegacy: get rid of wep_key_cmd
      iwlegacy: get rid of ap_sta_id
      iwlegacy: move bcast_sta_id to hw_params
      iwlegacy: get rid of *_devtype
      iwlegacy: get rid of ctxid
      iwlegacy: get rid of mcast_queue
      iwlegacy: move wep_keys out of context
      iwlegacy: get rid of ctx->station_flags
      iwlegacy: remove ctx interface_modes
      iwlegacy: move qos_data out of ctx structure
      iwlegacy: move ht out of ctx structure
      iwlegacy: get rid of ctx->ac_to_fifo
      iwlegacy: get rid of ctx->ac_to_queue
      iwlegacy: get rid of ctx->is_active
      iwlegacy: remove il_setup_interface()
      iwlegacy: get rid of ctx structure
      iwlegacy: move ops out of config
      iwlegacy: merge il_base_params into il_cfg
      iwlegacy: remove struct il_tx_info
      iwlegacy: remove set_hw_params callback
      iwlegacy: dump stack when fail to gain access to the device
      iwlegacy: always check if got h/w access before write
      iwlegacy: cleanup/fix memory barriers
      iwlegacy: use writeb,writel,readl directly
      iwlegacy: regulatory_bands is not an ops
      iwlegacy: gather all 4965 handlers in one place
      iwlegacy: move debugfs_ops to il_priv
      iwlegacy: remove temp_ops
      iwlegacy: merge eeprom_ops into lib_ops
      iwlegacy: remove il_apm_ops
      iwlegacy: merge il_lib_ops into il_ops
      iwlegacy: merge all ops structures into one
      iwlegacy: get rid of tx/rx traffic log
      iwlegacy: improve mac operation debuggability a bit
      iwleagcy: remove old comments
      iwleagcy: fix ident code damage
      iwlegacy: do not grab nic access if rfkill
      iwlegacy: check correct il_poll_bit error value
      iwlegacy: small il4965_set_hw_ready cleanup
      iwlegacy: enable only rfkill interrupt when rfkill switch is on during IFF_UP
      iwlegacy: small queue initializations cleanup
      iwlegacy: s/S_RF_KILL_HW/S_RFKILL/g
      iwlegacy: s/il_txq_mem/il_free_txq_mem/g
      iwlegacy: remove il_is_rfkill_hw
      iwlwifi: dump stack when fail to gain access to the device
      iwlwifi: always check if got h/w access before write
      iwlwifi: cleanup/fix memory barriers
      iwlwifi: use writeb,writel,readl directly
      iwlwifi: print DMA stop timeout error only if it happened
      iwlwifi: reintroduce iwl_enable_rfkill_int
      iwlwifi: make tx_cmd_pool kmem cache global
      rt2x00: rt2800usb: move additional txdone into new function
      rt2x00: rt2800usb: rework txdone code
      rt2x00: rt2800usb: rework txstatus code
      rt2x00: rt2800usb: do not check packedid for aggregated frames
      rt2x00: rt2800usb: limit tx queues length

Stefan Roese (1):
      stmmac: Add device-tree support

Stephane Grosjean (6):
      can: peak_pci: add support of some new PEAK-System PCI cards
      can: sja1000: add support for PEAK-System PCMCIA card
      can: usb: PEAK-System Technik USB adapters driver core
      can: usb: PEAK-System Technik PCAN-USB specific part
      can: usb: PEAK-System Technik PCAN-USB Pro specific part
      can: peak_usb: PCAN-USB specific part: fix little endian usage

Stephen Hemminger (2):
      ath6kl: make net_device_ops const
      brcm80211: make ethtool_ops const

Stephen Rothwell (1):
      net: powerpc: remove the legacy iSeries ethernet driver

Steve Hodgson (1):
      sfc: Disable flow control during flushes

Sujith Manoharan (49):
      ath6kl: Fix panic when setting a channel
      ath6kl: Fix SDIO error path
      ath6kl: Remove redundant pointer check
      ath6kl: Initialize a variable properly
      ath6kl: Fix listen interval handling
      ath9k_htc: Load firmware asynchronously
      ath9k: Print the correct channel mode
      ath9k: Remove unnecessary variable initialization
      ath9k: Merge wiphy and misc debugfs files
      ath9k: Add a debugfs file to display reset statistics
      ath9k: Prettify recv debugfs file output
      ath9k: Fix phyerr debug statistics
      ath9k: Remove unused initvals
      ath9k: Initialize NF values properly
      ath9k: Fix programming SYNTH4 for AR9462
      ath9k: Fix descriptor length for AR9462
      ath9k: Remove AR9462 v1.0 support
      ath9k: Cleanup MCI init/deinit routines
      ath9k: Initialize MCI params using a helper
      ath9k: Move BTCOEX init/deinit functions to gpio.c
      ath9k: Use proper start/stop routines for BTCOEX
      ath9k: Process BTCOEX interrupts using a helper
      ath9k: Calculate ampdu limit using a helper
      ath9k: Use CONFIG_ATH9K_BTCOEX_SUPPORT
      ath9k: Initialize BTCOEX scheme using a helper
      ath9k_hw: Use a helper function to get MCI ISR
      ath9k_hw: Handle MCI power state using a helper
      ath9k_hw: Setup MCI calibration using a helper
      ath9k_hw: Cleanup MCI bits from ath9k_hw_reset()
      ath9k_hw: Cleanup MCI bits from hw.h
      ath9k_hw: Cleanup MCI function declarations
      ath9k_hw: Use CONFIG_ATH9K_BTCOEX_SUPPORT
      ath9k_htc: Start/stop btcoex using a helper
      ath9k_htc: Init BTCOEX inside htc_drv_gpio.c
      ath9k_htc: Use CONFIG_ATH9K_BTCOEX_SUPPORT
      ath9k: Remove ATH_BTCOEX_CFG_NONE checks
      ath9k: Remove ATH9K_HW_CAP_MCI checks
      ath9k: Modify ATH9K_BTCOEX_SUPPORT
      ath9k_hw: Cleanup MCI reset routine
      ath9k_hw: Remove HW revision checks
      ath9k_hw: MCI whitespace/debug cleanup
      ath9k: Cleanup mci.c
      ath9k: Fix BTCOEX shutdown
      ath9k: Remove unnecessary initialization
      ath9k: Remove unused variables
      ath9k: Remove 'other' VIF count
      ath9k_hw: Cleanup FastChannelChange
      ath9k: Remove aggregation flags
      ath9k: Fix multi-VIF BSS handling

Sven Eckelmann (9):
      batman-adv: Explicitly mark the common header structure
      batman-adv: refactor tt_global_del() to avoid misalignment
      batman-adv: Update copyright years
      batman-adv: Start new development cycle
      batman-adv: Fix indentation of multiline statements
      batman-adv: Ignore 80-chars per line limits for strings
      batman-adv: Don't begin block comments with only a /* line
      batman-adv: Use {} braces consistent on the arms of a statement
      batman-adv: Remove spaces after a cast

Szymon Janc (9):
      Bluetooth: Make l2cap_clear_timer return if timer was running or not
      Bluetooth: Set P-bit for SREJ frame only if there are I-frames to ack
      Bluetooth: Clear ack_timer when sending ack
      Bluetooth: Don't send RNR immediately when entering local busy
      Bluetooth: Drop L2CAP chan reference if ERTM ack_timer fired
      Bluetooth: Make l2cap_ertm_data_rcv static
      Bluetooth: Fix possible missing I-Frame acknowledgement
      Bluetooth: Fix double acking I-Frames when sending pending I-Frames
      Bluetooth: Use NULL instead of integer for mgmt_device_connected param

Takahiro Shimizu (1):
      supports eg20t ptp clock

Takahiroi Shimizu (1):
      net/pch_gbe: supports eg20t ptp clock

Thirumalai Pachamuthu (1):
      ath6kl: Add support for uAPSD

Thomas Pedersen (5):
      ath6kl: send TCMD response through testmode events
      ath6kl: implement hidden ssid
      cfg80211: expose cfg80211_calculate_bitrate()
      mac80211: fix mesh airtime link metric estimating
      mac80211: fix smatch lock errors in mesh

Tim Gardner (2):
      rtlwifi: Fix PCI probe error path orphaned memory
      rtlwifi: rtl8192se firmware load can overflow target buffer

Tobias Klauser (1):
      net: ethernet: xilinx: Convert xilinx_axienet to module_platform_driver

Tomoya MORINAGA (2):
      can: pch_can: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
      can: Kconfig: add more information about Intel EG20T PCH CAN controller

Tony Zelenoff (3):
      net: Allow ipv6 proxies and arp proxies be shown with iproute2
      netfilter: nf_ct_ecache: trailing whitespace removed
      netfilter: nf_ct_ecache: refactor nf_ct_deliver_cached_events

Tristan Pourcelot (1):
      Correcting typos in rtlwifi/base.c

Tushar Dave (2):
      e1000: Adding e1000_dump function
      v2 e1000: Neaten e1000_dump function

Ulisses Furquim (2):
      Bluetooth: Remove usage of __cancel_delayed_work()
      Bluetooth: Fix possible use after free in delete path

Ursula Braun (9):
      af_iucv: remove IUCV-pathes completely
      af_iucv: block writing if msg limit is exceeded
      af_iucv: change net_device handling for HS transport
      af_iucv: allow retrieval of maximum message size
      qeth: add wake_up on write channel
      af_iucv: handle netdev events
      af_iucv: add shutdown for HS transport
      ctcm: make ctcmpc debugging compilable
      qeth: meaningful return code for set_mac_address

Uwe Kleine-K√∂nig (1):
      trivial: typo hnalder -> handler

Vasanthakumar Thiagarajan (31):
      ath6kl: Use cfg80211_roamed_bss() to report roaming event
      ath6kl: Remove few unnecessary spin_locks around set_bit()
      ath6kl: Add a module parameter to enable uart debug
      ath6kl: Add a function in wmi to send WMI_MCAST_FILTER_CMDID
      ath6kl: Add a function in wmi.c to add/delete a multicast filter
      ath6kl: Implement ndo_set_rx_mode()
      ath6kl: Remove deadcode in main.c
      ath6kl: Change ielen in ath6kl_add_new_sta() from u8 to size_t
      ath6kl: Use a mutex_lock to avoid race in diabling and handling irq
      ath6kl: Make sure to delete rx aggregation timer in aggr_reset_state()
      ath6kl: Fix memory leak when unloading ath6kl_sdio
      ath6kl: Define a structure for connection specific aggregation information
      ath6kl: Pass vif instead of ar to ath6kl_add_new_sta()
      ath6kl: Fix bug in using tid given by addba/delba req events
      ath6kl: Fix bug in maintaining aggregation state in AP mode
      ath6kl: Fix kernel panic during rx aggregation
      ath6kl: Update license header
      ath6kl: Fix missing release of semaphore in ath6kl_stop_txrx()
      ath6kl: Remove bogus non-NULL pointer check
      ath6kl: Make sure to allocate rx buffers after the endpoint connection
      ath6kl: Fix memory leak of rx packets in endpoint 0
      ath6kl: Make foreground scan a deterministic one
      ath6kl: Register driver ht capabilities in wiphy
      ath6kl: Group wiphy initialization into ath6kl_cfg80211_init()
      ath6kl: Initialize netdev hw_features for every interface
      ath6kl: Refactor ath6kl_wmi_control_rx()
      ath6kl: Skip vif index validation in ath6kl_rx() for wmi events
      ath6kl: Defer wiphy and netdev registration till the end of ath6kl_core_init()
      ath6kl: Make sure wiphy is registered before calling regulatory_hint()
      cfg80211: Add an attribute to set inactivity timeout in AP mode
      ath6kl: Fix kernel panic while receiving fwlog during boot

Vinicius Costa Gomes (11):
      Bluetooth: Fix using an absolute timeout on hci_conn_put()
      Bluetooth: Add structures for the new LTK exchange messages
      Bluetooth: Rename smp_key_size to enc_key_size
      Bluetooth: Fix invalid memory access when there's no SMP channel
      Bluetooth: Fix doing some useless casts when receiving MGMT commands
      Bluetooth: Add new structures for handling SMP Long Term Keys
      Bluetooth: Use the updated key structures for handling LTKs
      Bluetooth: Add MGMT handlers for dealing with SMP LTK's
      Bluetooth: Add support for removing LTK's when pairing is removed
      Bluetooth: Clean up structures left unused
      Bluetooth: Add support for notifying userspace of new LTK's

Vivek Natarajan (1):
      ath6kl: Remove redundant key_index check.

Vlad Zolotarov (1):
      bnx2: Add missing memory barrier in bnx2_start_xmit()

Vladimir Ermakov (1):
      fs_enet: Add MPC5125 FEC support and PHY interface selection

WANG Cong (1):
      netfilter: remove ipt_SAME.h and ipt_realm.h

Wey-Yi Guy (18):
      iwlwifi: don't process the info from uCode if does not has ownership
      iwlwifi: Sanity check for sta_id
      iwlwifi: update Copyright
      iwlwifi: don't process the info from uCode if does not has ownership
      iwlwifi: Sanity check for sta_id
      iwlwifi: update Copyright
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into wireless-next
      iwlwifi: fix typo
      iwlwifi: add option to disalbe LED
      iwlwifi: fix typo
      iwlwifi: add option to disalbe LED
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into wireless-next
      iwlwifi: log as error when error detected
      iwlwifi: remove un-necessary return
      iwlwifi: one more sku added to 6x35 series
      iwlwifi: update pci subsystem id
      iwlwifi: fix cmd_queue number merge
      iwlwifi: fix the delta for remove max_txq_num patch

Wolfgang Grandegger (2):
      can: bfin_can/ti_hecc/mscan: add missing do_get_berr_counter callback
      can: replace the dev_dbg/info/err/... with the new netdev_xxx macros

Yegor Yefremov (1):
      Documentation: make exists consistent

Yevgeny Petrilin (6):
      net/mlx4_en: Saving mem access on data path
      net/mlx4: fix sparse warnings on wrong type for RSS keys
      net/mlx4: fixing sparse warnings when copying mac, address to gid entry
      net/mlx4: fixing sparse warnings for not declared, functions
      net/mlx4: remove unused functions
      net/mlx4: defining functions as static

Yi Zou (3):
      net: do not do gso for CHECKSUM_UNNECESSARY in netif_needs_gso
      fcoe: use CHECKSUM_UNNECESSARY instead of CHECKSUM_PARTIAL on tx
      net: update the usage of CHECKSUM_UNNECESSARY

Yogesh Ashok Powar (19):
      mwifiex: use bss_type and bss_num to retrieve priv
      mwifiex: derive priv from net_device instead of wiphy
      mwl8k: Configuring correct MAC address in broadcast key
      mwl8k: Remove BSSID from the firmware when the BSS is stopped
      mwifiex: rename long function names to shorter ones
      mwifiex: rearrange switch statement
      mwifiex: merge functions to derive cfp by chan & freq in one
      mwifiex: use usleep_range instead of udelay
      mwifiex: rearrange if and else blocks to avoid extra indentation
      mwifiex: rename fuctions and variables for better readability
      mwifiex: fix checkpatch --strict warnings/errors Part 1
      mwifiex: fix checkpatch --strict warnings/errors Part 2
      mwifiex: fix checkpatch --strict warnings/errors Part 3
      mwifiex: fix checkpatch --strict warnings/errors Part 4
      mwifiex: fix checkpatch --strict warnings/errors Part 5
      mwifiex: fix checkpatch --strict warnings/errors Part 6
      mwifiex: fix checkpatch --strict warnings/errors Part 7
      mwifiex: fix checkpatch --strict warnings/errors Part 8
      mwifiex: fix checkpatch --strict warnings/errors Part 9

Yoshihiro Shimoda (5):
      net: sh_eth: add the value of tsu to the SH7757's GETHER
      net: sh_eth: change the condition of initialization
      net: sh_eth: modify a condition of ioremap for TSU
      net: sh_eth: add support for multicast filtering
      net: sh_eth: add support for VLAN tag filtering

Yuval Mintz (11):
      bnx2x: move LLH_CAM to header, apply naming conventions
      bnx2x: removed unused function bnx2x_queue_set_cos_cid
      bnx2x: set_one_mac_e1x uses raw's state as input
      bnx2x: use param's id instead of sp_obj's id
      bnx2x: mark functions as loaded on shared memory
      bnx2x: ethtool now returns unknown speed/duplex
      bnx2x: ethtool returns req. AN even when AN fails
      bnx2x: added 'likely' to fast-path skb existence
      bnx2x: reduced sparse warnings
      bnx2x: removed dcb unused code
      bnx2x: consistent statistics for old FW

Zefir Kurtisi (1):
      ath9k: decouple RX error checking for DFS

danborkmann@iogearbox.net (1):
      drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver

fran√ßois romieu (1):
      eni: fix driver remove function and driver probe error path.

sjur.brandeland@stericsson.com (4):
      caif: Kill debugfs vars for caif socket
      caif: Add drop count for caif_net device.
      caif-hsi: Add RX flip buffer
      caif: make zero a legal caif connetion id.

stigge@antcom.de (1):
      lpc32xx: Added ethernet driver

 Documentation/ABI/testing/sysfs-class-net-mesh     |    7 +
 Documentation/DocBook/80211.tmpl                   |    1 -
 Documentation/devicetree/bindings/net/stmmac.txt   |   28 +
 Documentation/ioctl/ioctl-number.txt               |    2 +-
 Documentation/magic-number.txt                     |    2 +-
 Documentation/networking/LICENSE.qlge              |  328 +-
 Documentation/networking/l2tp.txt                  |    2 +-
 .../networking/mac80211-auth-assoc-deauth.txt      |   99 +
 Documentation/networking/netdev-features.txt       |   13 +
 Documentation/networking/phy.txt                   |    3 +-
 Documentation/networking/ppp_generic.txt           |    6 +-
 Documentation/zh_CN/magic-number.txt               |    2 +-
 MAINTAINERS                                        |   26 +-
 arch/alpha/include/asm/socket.h                    |    4 +
 arch/arm/include/asm/socket.h                      |    4 +
 arch/avr32/include/asm/socket.h                    |    4 +
 arch/blackfin/mach-bf518/boards/ezbrd.c            |    3 +-
 arch/blackfin/mach-bf518/boards/tcm-bf518.c        |    5 +-
 arch/blackfin/mach-bf527/boards/ad7160eval.c       |    3 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |    5 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c            |    3 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |    3 +-
 arch/blackfin/mach-bf527/boards/tll6527m.c         |    3 +-
 arch/blackfin/mach-bf537/boards/cm_bf537e.c        |    5 +-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c        |    5 +-
 arch/blackfin/mach-bf537/boards/dnp5370.c          |    3 +-
 arch/blackfin/mach-bf537/boards/pnav10.c           |    5 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |    3 +-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |    5 +-
 arch/cris/include/asm/socket.h                     |    4 +
 arch/frv/include/asm/socket.h                      |    4 +
 arch/h8300/include/asm/socket.h                    |    4 +
 arch/ia64/hp/sim/simeth.c                          |   10 +-
 arch/ia64/include/asm/socket.h                     |    4 +
 arch/m32r/include/asm/socket.h                     |    4 +
 arch/m68k/include/asm/socket.h                     |    4 +
 arch/mips/bcm47xx/Makefile                         |    2 +-
 arch/mips/bcm47xx/nvram.c                          |    3 +-
 arch/mips/bcm47xx/setup.c                          |  188 +-
 arch/mips/bcm47xx/sprom.c                          |  620 +
 arch/mips/include/asm/mach-bcm47xx/bcm47xx.h       |    3 +
 arch/mips/include/asm/mach-bcm47xx/nvram.h         |    2 +-
 arch/mips/include/asm/socket.h                     |    4 +
 arch/mips/pci/pci-bcm47xx.c                        |   49 +-
 arch/mn10300/include/asm/socket.h                  |    4 +
 arch/parisc/include/asm/socket.h                   |    5 +
 arch/powerpc/boot/dts/bluestone.dts                |    2 +-
 arch/powerpc/include/asm/socket.h                  |    4 +
 arch/s390/include/asm/qeth.h                       |    7 +
 arch/s390/include/asm/socket.h                     |    4 +
 arch/sparc/include/asm/socket.h                    |    5 +
 arch/um/drivers/net_kern.c                         |   11 +-
 arch/x86/net/bpf_jit_comp.c                        |   14 +-
 arch/xtensa/include/asm/socket.h                   |    4 +
 crypto/crypto_user.c                               |   10 +-
 drivers/atm/eni.c                                  |  100 +-
 drivers/atm/eni.h                                  |    5 +
 drivers/atm/lanai.c                                |    2 +-
 drivers/bcma/bcma_private.h                        |    8 +-
 drivers/bcma/driver_chipcommon_pmu.c               |    1 +
 drivers/bcma/driver_pci.c                          |  168 +-
 drivers/bcma/driver_pci_host.c                     |  578 +-
 drivers/bcma/host_pci.c                            |    4 +-
 drivers/bcma/main.c                                |   17 +-
 drivers/bcma/scan.c                                |   24 +-
 drivers/bcma/sprom.c                               |  355 +-
 drivers/bluetooth/ath3k.c                          |    3 +
 drivers/bluetooth/bfusb.c                          |   23 +-
 drivers/bluetooth/bluecard_cs.c                    |   20 +-
 drivers/bluetooth/bpa10x.c                         |   35 +-
 drivers/bluetooth/bt3c_cs.c                        |   14 +-
 drivers/bluetooth/btmrvl_debugfs.c                 |   30 +-
 drivers/bluetooth/btmrvl_main.c                    |   17 +-
 drivers/bluetooth/btsdio.c                         |   23 +-
 drivers/bluetooth/btuart_cs.c                      |   14 +-
 drivers/bluetooth/btusb.c                          |   49 +-
 drivers/bluetooth/btwilink.c                       |   18 +-
 drivers/bluetooth/dtl1_cs.c                        |   34 +-
 drivers/bluetooth/hci_ath.c                        |    2 +-
 drivers/bluetooth/hci_bcsp.c                       |    2 +-
 drivers/bluetooth/hci_h4.c                         |    2 +-
 drivers/bluetooth/hci_ldisc.c                      |   34 +-
 drivers/bluetooth/hci_ll.c                         |    2 +-
 drivers/bluetooth/hci_uart.h                       |    2 +
 drivers/bluetooth/hci_vhci.c                       |   17 +-
 drivers/infiniband/core/addr.c                     |   14 +-
 drivers/infiniband/core/netlink.c                  |   10 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   10 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |    8 +-
 drivers/isdn/act2000/act2000.h                     |   28 +-
 drivers/isdn/act2000/act2000_isa.c                 |  394 +-
 drivers/isdn/act2000/act2000_isa.h                 |   32 +-
 drivers/isdn/act2000/capi.c                        |  998 +-
 drivers/isdn/act2000/capi.h                        |   50 +-
 drivers/isdn/act2000/module.c                      |  806 +-
 drivers/isdn/capi/capi.c                           |  180 +-
 drivers/isdn/capi/capidrv.c                        |  956 +-
 drivers/isdn/capi/capidrv.h                        |   42 +-
 drivers/isdn/capi/capilib.c                        |   16 +-
 drivers/isdn/capi/capiutil.c                       |  628 +-
 drivers/isdn/capi/kcapi.c                          |  116 +-
 drivers/isdn/capi/kcapi.h                          |   11 +-
 drivers/isdn/capi/kcapi_proc.c                     |   14 +-
 drivers/isdn/divert/divert_init.c                  |   75 +-
 drivers/isdn/divert/divert_procfs.c                |  152 +-
 drivers/isdn/divert/isdn_divert.c                  | 1475 +-
 drivers/isdn/divert/isdn_divert.h                  |  116 +-
 drivers/isdn/gigaset/asyncdata.c                   |    4 +-
 drivers/isdn/gigaset/bas-gigaset.c                 |   42 +-
 drivers/isdn/gigaset/capi.c                        |  228 +-
 drivers/isdn/gigaset/common.c                      |   14 +-
 drivers/isdn/gigaset/ev-layer.c                    |  328 +-
 drivers/isdn/gigaset/gigaset.h                     |   30 +-
 drivers/isdn/gigaset/i4l.c                         |    8 +-
 drivers/isdn/gigaset/interface.c                   |   20 +-
 drivers/isdn/gigaset/isocdata.c                    |  192 +-
 drivers/isdn/gigaset/proc.c                        |    4 +-
 drivers/isdn/gigaset/ser-gigaset.c                 |    6 +-
 drivers/isdn/gigaset/usb-gigaset.c                 |    8 +-
 drivers/isdn/hardware/avm/avm_cs.c                 |  134 +-
 drivers/isdn/hardware/avm/avmcard.h                |  286 +-
 drivers/isdn/hardware/avm/b1.c                     |  192 +-
 drivers/isdn/hardware/avm/b1dma.c                  |  178 +-
 drivers/isdn/hardware/avm/b1isa.c                  |   18 +-
 drivers/isdn/hardware/avm/b1pci.c                  |   44 +-
 drivers/isdn/hardware/avm/b1pcmcia.c               |   28 +-
 drivers/isdn/hardware/avm/c4.c                     |  348 +-
 drivers/isdn/hardware/avm/t1isa.c                  |  100 +-
 drivers/isdn/hardware/avm/t1pci.c                  |   32 +-
 drivers/isdn/hardware/eicon/capi20.h               |  514 +-
 drivers/isdn/hardware/eicon/capidtmf.c             | 1094 +-
 drivers/isdn/hardware/eicon/capidtmf.h             |   78 +-
 drivers/isdn/hardware/eicon/capifunc.c             |  222 +-
 drivers/isdn/hardware/eicon/capifunc.h             |    4 +-
 drivers/isdn/hardware/eicon/capimain.c             |   10 +-
 drivers/isdn/hardware/eicon/cardtype.h             | 1476 +-
 drivers/isdn/hardware/eicon/cp_vers.h              |   32 +-
 drivers/isdn/hardware/eicon/dadapter.c             |  576 +-
 drivers/isdn/hardware/eicon/dadapter.h             |   36 +-
 drivers/isdn/hardware/eicon/debug.c                | 3519 ++--
 drivers/isdn/hardware/eicon/debug_if.h             |   82 +-
 drivers/isdn/hardware/eicon/debuglib.c             |  176 +-
 drivers/isdn/hardware/eicon/debuglib.h             |  272 +-
 drivers/isdn/hardware/eicon/dfifo.h                |   56 +-
 drivers/isdn/hardware/eicon/di.c                   | 1430 +-
 drivers/isdn/hardware/eicon/di.h                   |  156 +-
 drivers/isdn/hardware/eicon/di_dbg.h               |   34 +-
 drivers/isdn/hardware/eicon/di_defs.h              |  144 +-
 drivers/isdn/hardware/eicon/did_vers.h             |   32 +-
 drivers/isdn/hardware/eicon/diddfunc.c             |   22 +-
 drivers/isdn/hardware/eicon/diva.c                 |  160 +-
 drivers/isdn/hardware/eicon/diva_didd.c            |   16 +-
 drivers/isdn/hardware/eicon/diva_dma.c             |  116 +-
 drivers/isdn/hardware/eicon/diva_dma.h             |   62 +-
 drivers/isdn/hardware/eicon/diva_pci.h             |    6 +-
 drivers/isdn/hardware/eicon/divacapi.h             |  630 +-
 drivers/isdn/hardware/eicon/divamnt.c              |   15 +-
 drivers/isdn/hardware/eicon/divasfunc.c            |   34 +-
 drivers/isdn/hardware/eicon/divasi.c               |   56 +-
 drivers/isdn/hardware/eicon/divasmain.c            |  118 +-
 drivers/isdn/hardware/eicon/divasproc.c            |   58 +-
 drivers/isdn/hardware/eicon/divasync.h             |  562 +-
 drivers/isdn/hardware/eicon/dqueue.c               |   14 +-
 drivers/isdn/hardware/eicon/dqueue.h               |   14 +-
 drivers/isdn/hardware/eicon/dsp_defs.h             |  256 +-
 drivers/isdn/hardware/eicon/dsp_tst.h              |    8 +-
 drivers/isdn/hardware/eicon/dspdids.h              |   30 +-
 drivers/isdn/hardware/eicon/dsrv4bri.h             |   34 +-
 drivers/isdn/hardware/eicon/dsrv_bri.h             |   44 +-
 drivers/isdn/hardware/eicon/dsrv_pri.h             |   46 +-
 drivers/isdn/hardware/eicon/entity.h               |   14 +-
 drivers/isdn/hardware/eicon/helpers.h              |   68 +-
 drivers/isdn/hardware/eicon/idifunc.c              |   22 +-
 drivers/isdn/hardware/eicon/io.c                   | 1414 +-
 drivers/isdn/hardware/eicon/io.h                   |  514 +-
 drivers/isdn/hardware/eicon/istream.c              |  352 +-
 drivers/isdn/hardware/eicon/kst_ifc.h              |  227 +-
 drivers/isdn/hardware/eicon/maintidi.c             | 2277 +-
 drivers/isdn/hardware/eicon/maintidi.h             |  105 +-
 drivers/isdn/hardware/eicon/man_defs.h             |   36 +-
 drivers/isdn/hardware/eicon/mdm_msg.h              |   72 +-
 drivers/isdn/hardware/eicon/message.c              |28300 ++++++++++----------
 drivers/isdn/hardware/eicon/mi_pc.h                |   86 +-
 drivers/isdn/hardware/eicon/mntfunc.c              |  186 +-
 drivers/isdn/hardware/eicon/os_4bri.c              |  352 +-
 drivers/isdn/hardware/eicon/os_4bri.h              |    2 +-
 drivers/isdn/hardware/eicon/os_bri.c               |  262 +-
 drivers/isdn/hardware/eicon/os_bri.h               |    2 +-
 drivers/isdn/hardware/eicon/os_capi.h              |   10 +-
 drivers/isdn/hardware/eicon/os_pri.c               |  390 +-
 drivers/isdn/hardware/eicon/os_pri.h               |    2 +-
 drivers/isdn/hardware/eicon/pc.h                   |  268 +-
 drivers/isdn/hardware/eicon/pc_init.h              |   48 +-
 drivers/isdn/hardware/eicon/pc_maint.h             |  158 +-
 drivers/isdn/hardware/eicon/pkmaint.h              |   43 +-
 drivers/isdn/hardware/eicon/platform.h             |  156 +-
 drivers/isdn/hardware/eicon/pr_pc.h                |  116 +-
 drivers/isdn/hardware/eicon/s_4bri.c               |  488 +-
 drivers/isdn/hardware/eicon/s_bri.c                |  288 +-
 drivers/isdn/hardware/eicon/s_pri.c                |  314 +-
 drivers/isdn/hardware/eicon/sdp_hdr.h              |  130 +-
 drivers/isdn/hardware/eicon/um_idi.c               |  224 +-
 drivers/isdn/hardware/eicon/um_idi.h               |    2 +-
 drivers/isdn/hardware/eicon/xdi_adapter.h          |   12 +-
 drivers/isdn/hardware/eicon/xdi_msg.h              |    2 +-
 drivers/isdn/hardware/eicon/xdi_vers.h             |   32 +-
 drivers/isdn/hardware/mISDN/avmfritz.c             |   68 +-
 drivers/isdn/hardware/mISDN/hfc_multi.h            |   47 +-
 drivers/isdn/hardware/mISDN/hfc_multi_8xx.h        |   28 +-
 drivers/isdn/hardware/mISDN/hfc_pci.h              |   18 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             | 1364 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |  356 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  415 +-
 drivers/isdn/hardware/mISDN/hfcsusb.h              |  120 +-
 drivers/isdn/hardware/mISDN/iohelper.h             |  136 +-
 drivers/isdn/hardware/mISDN/isar.h                 |    2 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |   36 +-
 drivers/isdn/hardware/mISDN/mISDNipac.c            |  112 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c            |  208 +-
 drivers/isdn/hardware/mISDN/netjet.c               |   98 +-
 drivers/isdn/hardware/mISDN/netjet.h               |    1 -
 drivers/isdn/hardware/mISDN/speedfax.c             |   22 +-
 drivers/isdn/hardware/mISDN/w6692.c                |   86 +-
 drivers/isdn/hisax/amd7930_fn.c                    |  786 +-
 drivers/isdn/hisax/arcofi.c                        |   88 +-
 drivers/isdn/hisax/arcofi.h                        |    2 +-
 drivers/isdn/hisax/asuscom.c                       |  110 +-
 drivers/isdn/hisax/avm_a1.c                        |   42 +-
 drivers/isdn/hisax/avm_a1p.c                       |  152 +-
 drivers/isdn/hisax/avm_pci.c                       |  324 +-
 drivers/isdn/hisax/avma1_cs.c                      |  124 +-
 drivers/isdn/hisax/bkm_a4t.c                       |   92 +-
 drivers/isdn/hisax/bkm_a8.c                        |  184 +-
 drivers/isdn/hisax/bkm_ax.h                        |   78 +-
 drivers/isdn/hisax/callc.c                         | 1074 +-
 drivers/isdn/hisax/config.c                        |  126 +-
 drivers/isdn/hisax/diva.c                          |  334 +-
 drivers/isdn/hisax/elsa.c                          |  500 +-
 drivers/isdn/hisax/elsa_cs.c                       |  164 +-
 drivers/isdn/hisax/elsa_ser.c                      |  178 +-
 drivers/isdn/hisax/enternow_pci.c                  |  200 +-
 drivers/isdn/hisax/fsm.c                           |   38 +-
 drivers/isdn/hisax/fsm.h                           |    4 +-
 drivers/isdn/hisax/gazel.c                         |  518 +-
 drivers/isdn/hisax/hfc4s8s_l1.c                    |  648 +-
 drivers/isdn/hisax/hfc4s8s_l1.h                    |    8 +-
 drivers/isdn/hisax/hfc_2bds0.c                     |  484 +-
 drivers/isdn/hisax/hfc_2bds0.h                     |   28 +-
 drivers/isdn/hisax/hfc_2bs0.c                      |  284 +-
 drivers/isdn/hisax/hfc_2bs0.h                      |    6 +-
 drivers/isdn/hisax/hfc_pci.c                       |  714 +-
 drivers/isdn/hisax/hfc_pci.h                       |   96 +-
 drivers/isdn/hisax/hfc_sx.c                        | 1126 +-
 drivers/isdn/hisax/hfc_sx.h                        |   30 +-
 drivers/isdn/hisax/hfc_usb.c                       |  586 +-
 drivers/isdn/hisax/hfc_usb.h                       |   10 +-
 drivers/isdn/hisax/hfcscard.c                      |   96 +-
 drivers/isdn/hisax/hisax.h                         |  172 +-
 drivers/isdn/hisax/hisax_cfg.h                     |    6 +-
 drivers/isdn/hisax/hisax_debug.h                   |   42 +-
 drivers/isdn/hisax/hisax_fcpcipnp.c                |   92 +-
 drivers/isdn/hisax/hisax_fcpcipnp.h                |    3 +-
 drivers/isdn/hisax/hisax_if.h                      |    4 +-
 drivers/isdn/hisax/hisax_isac.c                    |   44 +-
 drivers/isdn/hisax/hscx.c                          |  136 +-
 drivers/isdn/hisax/hscx.h                          |    2 +-
 drivers/isdn/hisax/hscx_irq.c                      |   18 +-
 drivers/isdn/hisax/icc.c                           |  314 +-
 drivers/isdn/hisax/icc.h                           |    6 +-
 drivers/isdn/hisax/ipac.h                          |    2 +-
 drivers/isdn/hisax/ipacx.c                         |  675 +-
 drivers/isdn/hisax/isac.c                          |  320 +-
 drivers/isdn/hisax/isac.h                          |    2 +-
 drivers/isdn/hisax/isar.c                          | 1796 +-
 drivers/isdn/hisax/isar.h                          |   14 +-
 drivers/isdn/hisax/isdnl1.c                        |  262 +-
 drivers/isdn/hisax/isdnl2.c                        |  342 +-
 drivers/isdn/hisax/isdnl2.h                        |    1 -
 drivers/isdn/hisax/isdnl3.c                        |  174 +-
 drivers/isdn/hisax/isdnl3.h                        |    3 +-
 drivers/isdn/hisax/isurf.c                         |  118 +-
 drivers/isdn/hisax/ix1_micro.c                     |  100 +-
 drivers/isdn/hisax/jade.c                          |  209 +-
 drivers/isdn/hisax/jade.h                          |  156 +-
 drivers/isdn/hisax/jade_irq.c                      |   48 +-
 drivers/isdn/hisax/l3_1tr6.c                       |  196 +-
 drivers/isdn/hisax/l3dss1.c                        | 1900 +-
 drivers/isdn/hisax/l3dss1.h                        |   20 +-
 drivers/isdn/hisax/l3ni1.c                         | 1838 +-
 drivers/isdn/hisax/l3ni1.h                         |   28 +-
 drivers/isdn/hisax/lmgr.c                          |   28 +-
 drivers/isdn/hisax/mic.c                           |   64 +-
 drivers/isdn/hisax/netjet.c                        |  623 +-
 drivers/isdn/hisax/netjet.h                        |    5 +-
 drivers/isdn/hisax/niccy.c                         |   78 +-
 drivers/isdn/hisax/nj_s.c                          |  112 +-
 drivers/isdn/hisax/nj_u.c                          |  100 +-
 drivers/isdn/hisax/q931.c                          |  240 +-
 drivers/isdn/hisax/s0box.c                         |  132 +-
 drivers/isdn/hisax/saphir.c                        |  122 +-
 drivers/isdn/hisax/sedlbauer.c                     |  328 +-
 drivers/isdn/hisax/sedlbauer_cs.c                  |  176 +-
 drivers/isdn/hisax/sportster.c                     |  126 +-
 drivers/isdn/hisax/st5481.h                        |   98 +-
 drivers/isdn/hisax/st5481_b.c                      |  124 +-
 drivers/isdn/hisax/st5481_d.c                      |  194 +-
 drivers/isdn/hisax/st5481_init.c                   |   64 +-
 drivers/isdn/hisax/st5481_usb.c                    |  269 +-
 drivers/isdn/hisax/tei.c                           |   76 +-
 drivers/isdn/hisax/teleint.c                       |  126 +-
 drivers/isdn/hisax/teles0.c                        |  126 +-
 drivers/isdn/hisax/teles3.c                        |  156 +-
 drivers/isdn/hisax/teles_cs.c                      |  134 +-
 drivers/isdn/hisax/telespci.c                      |   80 +-
 drivers/isdn/hisax/w6692.c                         |  412 +-
 drivers/isdn/hisax/w6692.h                         |   10 +-
 drivers/isdn/hysdn/boardergo.c                     |   28 +-
 drivers/isdn/hysdn/boardergo.h                     |   30 +-
 drivers/isdn/hysdn/hycapi.c                        |  374 +-
 drivers/isdn/hysdn/hysdn_boot.c                    |  302 +-
 drivers/isdn/hysdn/hysdn_defs.h                    |   30 +-
 drivers/isdn/hysdn/hysdn_init.c                    |    4 +-
 drivers/isdn/hysdn/hysdn_net.c                     |   20 +-
 drivers/isdn/hysdn/hysdn_pof.h                     |   26 +-
 drivers/isdn/hysdn/hysdn_procconf.c                |   10 +-
 drivers/isdn/hysdn/hysdn_proclog.c                 |   26 +-
 drivers/isdn/hysdn/hysdn_sched.c                   |   54 +-
 drivers/isdn/hysdn/ince1pc.h                       |   72 +-
 drivers/isdn/i4l/isdn_audio.c                      |  126 +-
 drivers/isdn/i4l/isdn_bsdcomp.c                    |  374 +-
 drivers/isdn/i4l/isdn_common.c                     | 1502 +-
 drivers/isdn/i4l/isdn_common.h                     |   18 +-
 drivers/isdn/i4l/isdn_concap.c                     |   36 +-
 drivers/isdn/i4l/isdn_concap.h                     |    4 +-
 drivers/isdn/i4l/isdn_net.c                        | 1498 +-
 drivers/isdn/i4l/isdn_net.h                        |   11 +-
 drivers/isdn/i4l/isdn_ppp.c                        | 1446 +-
 drivers/isdn/i4l/isdn_ppp.h                        |    2 -
 drivers/isdn/i4l/isdn_tty.c                        | 2442 +-
 drivers/isdn/i4l/isdn_tty.h                        |   10 +-
 drivers/isdn/i4l/isdn_ttyfax.c                     | 1092 +-
 drivers/isdn/i4l/isdn_ttyfax.h                     |    1 -
 drivers/isdn/i4l/isdn_v110.c                       |  294 +-
 drivers/isdn/i4l/isdn_v110.h                       |    8 +-
 drivers/isdn/i4l/isdn_x25iface.c                   |  226 +-
 drivers/isdn/i4l/isdn_x25iface.h                   |   16 +-
 drivers/isdn/i4l/isdnhdlc.c                        |   54 +-
 drivers/isdn/icn/icn.c                             |  806 +-
 drivers/isdn/icn/icn.h                             |   32 +-
 drivers/isdn/isdnloop/isdnloop.c                   |  958 +-
 drivers/isdn/isdnloop/isdnloop.h                   |    6 +-
 drivers/isdn/mISDN/clock.c                         |   25 +-
 drivers/isdn/mISDN/core.c                          |   37 +-
 drivers/isdn/mISDN/core.h                          |    8 +-
 drivers/isdn/mISDN/dsp.h                           |   25 +-
 drivers/isdn/mISDN/dsp_audio.c                     |    5 +-
 drivers/isdn/mISDN/dsp_biquad.h                    |    6 +-
 drivers/isdn/mISDN/dsp_blowfish.c                  |  112 +-
 drivers/isdn/mISDN/dsp_cmx.c                       | 1040 +-
 drivers/isdn/mISDN/dsp_core.c                      |  183 +-
 drivers/isdn/mISDN/dsp_dtmf.c                      |   66 +-
 drivers/isdn/mISDN/dsp_ecdis.h                     |   26 +-
 drivers/isdn/mISDN/dsp_hwec.c                      |   11 +-
 drivers/isdn/mISDN/dsp_hwec.h                      |    1 -
 drivers/isdn/mISDN/dsp_pipeline.c                  |   56 +-
 drivers/isdn/mISDN/dsp_tones.c                     |  165 +-
 drivers/isdn/mISDN/fsm.c                           |   42 +-
 drivers/isdn/mISDN/hwchannel.c                     |   22 +-
 drivers/isdn/mISDN/l1oip.h                         |   21 +-
 drivers/isdn/mISDN/l1oip_codec.c                   |   36 +-
 drivers/isdn/mISDN/l1oip_core.c                    |  597 +-
 drivers/isdn/mISDN/layer1.c                        |   16 +-
 drivers/isdn/mISDN/layer1.h                        |    1 -
 drivers/isdn/mISDN/layer2.c                        |   97 +-
 drivers/isdn/mISDN/layer2.h                        |   12 +-
 drivers/isdn/mISDN/socket.c                        |   89 +-
 drivers/isdn/mISDN/stack.c                         |  124 +-
 drivers/isdn/mISDN/tei.c                           |  114 +-
 drivers/isdn/mISDN/timerdev.c                      |   12 +-
 drivers/isdn/pcbit/callbacks.c                     |  303 +-
 drivers/isdn/pcbit/callbacks.h                     |   28 +-
 drivers/isdn/pcbit/capi.c                          |  585 +-
 drivers/isdn/pcbit/capi.h                          |   46 +-
 drivers/isdn/pcbit/drv.c                           |  248 +-
 drivers/isdn/pcbit/edss1.c                         |  414 +-
 drivers/isdn/pcbit/edss1.h                         |   13 +-
 drivers/isdn/pcbit/layer2.c                        |   36 +-
 drivers/isdn/pcbit/layer2.h                        |  265 +-
 drivers/isdn/pcbit/module.c                        |   35 +-
 drivers/isdn/pcbit/pcbit.h                         |   32 +-
 drivers/isdn/sc/card.h                             |    2 +-
 drivers/isdn/sc/command.c                          |  132 +-
 drivers/isdn/sc/event.c                            |   24 +-
 drivers/isdn/sc/hardware.h                         |    2 +-
 drivers/isdn/sc/init.c                             |  122 +-
 drivers/isdn/sc/interrupt.c                        |  144 +-
 drivers/isdn/sc/ioctl.c                            |  220 +-
 drivers/isdn/sc/message.c                          |  126 +-
 drivers/isdn/sc/message.h                          |   18 +-
 drivers/isdn/sc/packet.c                           |  129 +-
 drivers/isdn/sc/scioc.h                            |    5 +-
 drivers/isdn/sc/shmem.c                            |   52 +-
 drivers/isdn/sc/timer.c                            |   25 +-
 drivers/net/bonding/bond_3ad.c                     |    2 +-
 drivers/net/bonding/bond_alb.c                     |   12 +-
 drivers/net/bonding/bond_main.c                    |   18 +-
 drivers/net/caif/caif_hsi.c                        |  145 +-
 drivers/net/can/Kconfig                            |    6 +-
 drivers/net/can/bfin_can.c                         |   36 +-
 drivers/net/can/cc770/cc770.c                      |    1 -
 drivers/net/can/dev.c                              |   33 +-
 drivers/net/can/flexcan.c                          |   61 +-
 drivers/net/can/mcp251x.c                          |    3 +-
 drivers/net/can/mscan/mscan.c                      |   33 +-
 drivers/net/can/pch_can.c                          |    2 +-
 drivers/net/can/sja1000/Kconfig                    |   28 +-
 drivers/net/can/sja1000/Makefile                   |    1 +
 drivers/net/can/sja1000/peak_pci.c                 |  505 +-
 drivers/net/can/sja1000/peak_pcmcia.c              |  753 +
 drivers/net/can/sja1000/plx_pci.c                  |   22 +-
 drivers/net/can/sja1000/sja1000.c                  |   19 +-
 drivers/net/can/slcan.c                            |    6 +-
 drivers/net/can/ti_hecc.c                          |   32 +-
 drivers/net/can/usb/Kconfig                        |    6 +
 drivers/net/can/usb/Makefile                       |    1 +
 drivers/net/can/usb/ems_usb.c                      |   63 +-
 drivers/net/can/usb/esd_usb2.c                     |   27 +-
 drivers/net/can/usb/peak_usb/Makefile              |    2 +
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  899 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  951 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |  146 +
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        | 1036 +
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h        |  178 +
 drivers/net/dummy.c                                |    3 +-
 drivers/net/ethernet/3com/3c501.c                  |    2 +-
 drivers/net/ethernet/3com/3c509.c                  |    2 +-
 drivers/net/ethernet/3com/3c515.c                  |   10 +-
 drivers/net/ethernet/3com/3c574_cs.c               |    2 +-
 drivers/net/ethernet/3com/3c589_cs.c               |    2 +-
 drivers/net/ethernet/3com/3c59x.c                  |   10 +-
 drivers/net/ethernet/3com/Kconfig                  |    2 +-
 drivers/net/ethernet/3com/typhoon.c                |   19 +-
 drivers/net/ethernet/8390/ax88796.c                |    2 +-
 drivers/net/ethernet/8390/axnet_cs.c               |    4 +-
 drivers/net/ethernet/8390/lib8390.c                |    2 +-
 drivers/net/ethernet/8390/pcnet_cs.c               |    2 +-
 drivers/net/ethernet/Kconfig                       |    1 +
 drivers/net/ethernet/Makefile                      |    1 +
 drivers/net/ethernet/adaptec/starfire.c            |   13 +-
 drivers/net/ethernet/adi/bfin_mac.c                |   27 +-
 drivers/net/ethernet/adi/bfin_mac.h                |    2 +-
 drivers/net/ethernet/aeroflex/greth.c              |    5 +-
 drivers/net/ethernet/alteon/acenic.c               |    5 +-
 drivers/net/ethernet/amd/7990.c                    |    2 +-
 drivers/net/ethernet/amd/Kconfig                   |    2 +-
 drivers/net/ethernet/amd/a2065.c                   |    2 +-
 drivers/net/ethernet/amd/am79c961a.c               |    4 +-
 drivers/net/ethernet/amd/am79c961a.h               |    2 +-
 drivers/net/ethernet/amd/amd8111e.c                |    7 +-
 drivers/net/ethernet/amd/ariadne.c                 |    2 +-
 drivers/net/ethernet/amd/atarilance.c              |    2 +-
 drivers/net/ethernet/amd/au1000_eth.c              |   12 +-
 drivers/net/ethernet/amd/declance.c                |    4 +-
 drivers/net/ethernet/amd/depca.c                   |    2 +-
 drivers/net/ethernet/amd/hplance.c                 |   10 +-
 drivers/net/ethernet/amd/ni65.c                    |    6 +-
 drivers/net/ethernet/amd/nmclan_cs.c               |    2 +-
 drivers/net/ethernet/amd/pcnet32.c                 |   16 +-
 drivers/net/ethernet/amd/sun3lance.c               |    2 +-
 drivers/net/ethernet/amd/sunlance.c                |    4 +-
 drivers/net/ethernet/apple/bmac.c                  |   19 +-
 drivers/net/ethernet/apple/mace.c                  |    9 +-
 drivers/net/ethernet/apple/macmace.c               |    2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c      |    2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   12 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |    1 -
 drivers/net/ethernet/atheros/atlx/atl1.c           |   12 +-
 drivers/net/ethernet/atheros/atlx/atl2.c           |   13 +-
 drivers/net/ethernet/atheros/atlx/atl2.h           |    5 +-
 drivers/net/ethernet/atheros/atlx/atlx.c           |    1 +
 drivers/net/ethernet/atheros/atlx/atlx.h           |    1 -
 drivers/net/ethernet/broadcom/b44.c                |    1 -
 drivers/net/ethernet/broadcom/bnx2.c               |  108 +-
 drivers/net/ethernet/broadcom/bnx2.h               |    3 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   76 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  486 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |  184 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c    |  319 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h    |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dump.h   |    2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |  310 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h    |   14 +-
 .../ethernet/broadcom/bnx2x/bnx2x_fw_file_hdr.h    |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h    |   62 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init.h   |    2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h   |   55 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   |  324 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.h   |    6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |  974 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h    |   21 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c     |  180 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h     |   26 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c  |  432 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h  |  147 +-
 drivers/net/ethernet/broadcom/cnic.c               |   42 +-
 drivers/net/ethernet/broadcom/cnic_defs.h          |   27 +-
 drivers/net/ethernet/broadcom/cnic_if.h            |    4 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c         |    2 -
 drivers/net/ethernet/broadcom/tg3.c                | 1945 +-
 drivers/net/ethernet/broadcom/tg3.h                |   14 +-
 drivers/net/ethernet/brocade/bna/bfa_cee.c         |    8 +-
 drivers/net/ethernet/brocade/bna/bfa_defs.h        |    1 +
 drivers/net/ethernet/brocade/bna/bfa_ioc.c         |    2 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |    1 -
 drivers/net/ethernet/brocade/bna/bnad_debugfs.c    |   21 +-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c    |   42 +
 drivers/net/ethernet/cadence/at91_ether.c          |    2 +-
 drivers/net/ethernet/cadence/macb.c                |    8 +-
 drivers/net/ethernet/calxeda/xgmac.c               |    3 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/version.h       |    4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    2 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |    4 +-
 drivers/net/ethernet/cirrus/cs89x0.c               |    4 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |    4 +-
 drivers/net/ethernet/cirrus/mac89x0.c              |   12 +-
 drivers/net/ethernet/cisco/enic/enic.h             |    4 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   52 +-
 drivers/net/ethernet/cisco/enic/enic_pp.c          |    4 +-
 drivers/net/ethernet/cisco/enic/enic_res.c         |    2 +-
 drivers/net/ethernet/cisco/enic/vnic_dev.c         |   76 +-
 drivers/net/ethernet/cisco/enic/vnic_dev.h         |    3 +-
 drivers/net/ethernet/cisco/enic/vnic_devcmd.h      |   11 +-
 drivers/net/ethernet/cisco/enic/vnic_rq.c          |    4 +-
 drivers/net/ethernet/cisco/enic/vnic_wq.c          |    4 +-
 drivers/net/ethernet/davicom/dm9000.c              |    8 +-
 drivers/net/ethernet/dec/ewrk3.c                   |    4 +-
 drivers/net/ethernet/dec/tulip/21142.c             |    2 +-
 drivers/net/ethernet/dec/tulip/de2104x.c           |    6 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |   10 +-
 drivers/net/ethernet/dec/tulip/dmfe.c              |   20 +-
 drivers/net/ethernet/dec/tulip/eeprom.c            |    2 +-
 drivers/net/ethernet/dec/tulip/interrupt.c         |   10 +-
 drivers/net/ethernet/dec/tulip/media.c             |    2 +-
 drivers/net/ethernet/dec/tulip/pnic.c              |    2 +-
 drivers/net/ethernet/dec/tulip/pnic2.c             |    2 +-
 drivers/net/ethernet/dec/tulip/timer.c             |    2 +-
 drivers/net/ethernet/dec/tulip/tulip.h             |    2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |    9 +-
 drivers/net/ethernet/dec/tulip/uli526x.c           |   21 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |    6 +-
 drivers/net/ethernet/dec/tulip/xircom_cb.c         |    7 +-
 drivers/net/ethernet/dlink/de600.c                 |    2 +-
 drivers/net/ethernet/dlink/de620.c                 |    2 +-
 drivers/net/ethernet/dlink/sundance.c              |   11 +-
 drivers/net/ethernet/dnet.c                        |    8 +-
 drivers/net/ethernet/emulex/benet/be.h             |  111 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |  245 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h        |  137 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  187 +-
 drivers/net/ethernet/emulex/benet/be_main.c        | 1039 +-
 drivers/net/ethernet/ethoc.c                       |   23 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |    2 +-
 drivers/net/ethernet/faraday/ftmac100.c            |    2 +-
 drivers/net/ethernet/fealnx.c                      |    8 +-
 drivers/net/ethernet/freescale/fec.c               |   21 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |    4 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.h       |    2 +-
 drivers/net/ethernet/freescale/fs_enet/fec.h       |    6 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |   32 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c   |    9 +-
 drivers/net/ethernet/freescale/gianfar.c           |   24 +-
 drivers/net/ethernet/freescale/gianfar.h           |    5 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |    4 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c       |    2 +-
 drivers/net/ethernet/freescale/gianfar_sysfs.c     |    2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |  460 +-
 drivers/net/ethernet/fujitsu/at1700.c              |    2 +-
 drivers/net/ethernet/fujitsu/eth16i.c              |    2 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |    2 +-
 drivers/net/ethernet/hp/hp100.c                    |    6 +-
 drivers/net/ethernet/i825xx/3c505.c                |    2 +-
 drivers/net/ethernet/i825xx/3c507.c                |    2 +-
 drivers/net/ethernet/i825xx/3c523.c                |    2 +-
 drivers/net/ethernet/i825xx/3c527.c                |    4 +-
 drivers/net/ethernet/i825xx/82596.c                |    8 +-
 drivers/net/ethernet/i825xx/eepro.c                |    2 +-
 drivers/net/ethernet/i825xx/eexpress.c             |    2 +-
 drivers/net/ethernet/i825xx/ether1.c               |    2 +-
 drivers/net/ethernet/i825xx/lp486e.c               |    4 +-
 drivers/net/ethernet/i825xx/ni52.c                 |    2 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |   27 +-
 drivers/net/ethernet/i825xx/znet.c                 |    2 +-
 drivers/net/ethernet/ibm/Kconfig                   |    4 -
 drivers/net/ethernet/ibm/Makefile                  |    1 -
 drivers/net/ethernet/ibm/ehea/ehea.h               |    2 +-
 drivers/net/ethernet/ibm/ehea/ehea_ethtool.c       |    2 +-
 drivers/net/ethernet/ibm/ehea/ehea_hw.h            |    2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |    3 +-
 drivers/net/ethernet/ibm/ehea/ehea_phyp.c          |    2 +-
 drivers/net/ethernet/ibm/ehea/ehea_phyp.h          |    2 +-
 drivers/net/ethernet/ibm/ehea/ehea_qmr.c           |    2 +-
 drivers/net/ethernet/ibm/ehea/ehea_qmr.h           |    2 +-
 drivers/net/ethernet/ibm/emac/core.c               |   37 +-
 drivers/net/ethernet/ibm/emac/core.h               |   15 +-
 drivers/net/ethernet/ibm/emac/debug.c              |    2 +-
 drivers/net/ethernet/ibm/emac/debug.h              |    2 +-
 drivers/net/ethernet/ibm/emac/emac.h               |    4 +-
 drivers/net/ethernet/ibm/emac/mal.c                |    2 +-
 drivers/net/ethernet/ibm/emac/mal.h                |    2 +-
 drivers/net/ethernet/ibm/emac/phy.c                |    2 +-
 drivers/net/ethernet/ibm/emac/phy.h                |    2 +-
 drivers/net/ethernet/ibm/emac/rgmii.c              |    7 +-
 drivers/net/ethernet/ibm/emac/rgmii.h              |    2 +-
 drivers/net/ethernet/ibm/emac/tah.c                |    7 +-
 drivers/net/ethernet/ibm/emac/tah.h                |    2 +-
 drivers/net/ethernet/ibm/emac/zmii.c               |    7 +-
 drivers/net/ethernet/ibm/emac/zmii.h               |    2 +-
 drivers/net/ethernet/ibm/iseries_veth.c            | 1710 --
 drivers/net/ethernet/icplus/ipg.c                  |    4 -
 drivers/net/ethernet/intel/e100.c                  |   84 +-
 drivers/net/ethernet/intel/e1000/e1000.h           |    1 +
 drivers/net/ethernet/intel/e1000/e1000_hw.c        |  156 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.h        |   10 +
 drivers/net/ethernet/intel/e1000/e1000_main.c      |  249 +-
 drivers/net/ethernet/intel/e1000e/80003es2lan.c    |   99 +-
 drivers/net/ethernet/intel/e1000e/82571.c          |  147 +-
 drivers/net/ethernet/intel/e1000e/Makefile         |    5 +-
 drivers/net/ethernet/intel/e1000e/defines.h        |   11 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |   52 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  207 +-
 drivers/net/ethernet/intel/e1000e/hw.h             |   13 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  433 +-
 drivers/net/ethernet/intel/e1000e/{lib.c => mac.c} | 1132 +-
 drivers/net/ethernet/intel/e1000e/manage.c         |  367 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  722 +-
 drivers/net/ethernet/intel/e1000e/nvm.c            |  643 +
 drivers/net/ethernet/intel/e1000e/param.c          |   55 +-
 drivers/net/ethernet/intel/e1000e/phy.c            |  327 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h     |    2 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |    7 +
 drivers/net/ethernet/intel/igb/igb_main.c          |   44 +-
 drivers/net/ethernet/intel/igbvf/defines.h         |    4 -
 drivers/net/ethernet/intel/igbvf/ethtool.c         |   19 +-
 drivers/net/ethernet/intel/igbvf/igbvf.h           |   27 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |  143 +-
 drivers/net/ethernet/intel/igbvf/vf.c              |    7 +-
 drivers/net/ethernet/intel/ixgb/ixgb.h             |   12 -
 drivers/net/ethernet/intel/ixgb/ixgb_ee.c          |   12 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |    8 +-
 drivers/net/ethernet/intel/ixgbe/Makefile          |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |  225 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c     |   10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c     |   32 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |   69 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h    |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c    |   30 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |  289 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |   89 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |  929 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 3201 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |   14 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |   11 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c      |    4 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   42 +-
 drivers/net/ethernet/jme.c                         |    1 -
 drivers/net/ethernet/korina.c                      |    6 +-
 drivers/net/ethernet/lantiq_etop.c                 |   15 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    4 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |   18 +-
 drivers/net/ethernet/marvell/skge.c                |    4 +-
 drivers/net/ethernet/marvell/sky2.c                |    4 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   11 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    5 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   24 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   36 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   10 -
 drivers/net/ethernet/mellanox/mlx4/main.c          |    4 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   38 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    1 -
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |    7 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c            |   81 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          |   12 +-
 drivers/net/ethernet/micrel/ks8695net.c            |    8 +-
 drivers/net/ethernet/micrel/ks8842.c               |    3 +-
 drivers/net/ethernet/micrel/ks8851.c               |   11 +-
 drivers/net/ethernet/micrel/ks8851.h               |    2 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |   11 +-
 drivers/net/ethernet/micrel/ksz884x.c              |    8 +-
 drivers/net/ethernet/microchip/enc28j60.c          |    9 +-
 drivers/net/ethernet/mipsnet.c                     |    4 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |    4 +-
 drivers/net/ethernet/natsemi/ibmlana.c             |    2 +-
 drivers/net/ethernet/natsemi/macsonic.c            |    2 +-
 drivers/net/ethernet/natsemi/natsemi.c             |    5 +-
 drivers/net/ethernet/natsemi/sonic.c               |    4 +-
 drivers/net/ethernet/neterion/s2io.c               |    9 +-
 drivers/net/ethernet/netx-eth.c                    |    5 +-
 drivers/net/ethernet/nuvoton/w90p910_ether.c       |    2 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |   11 +-
 drivers/net/ethernet/nxp/Kconfig                   |    8 +
 drivers/net/ethernet/nxp/Makefile                  |    1 +
 drivers/net/ethernet/nxp/lpc_eth.c                 | 1604 ++
 drivers/net/ethernet/oki-semi/pch_gbe/Kconfig      |   13 +
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h    |   13 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |  230 +-
 drivers/net/ethernet/packetengines/hamachi.c       |    8 +-
 drivers/net/ethernet/packetengines/yellowfin.c     |   13 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |    6 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h    |  441 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_ctx.c    |  296 +-
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |  109 +
 .../net/ethernet/qlogic/netxen/netxen_nic_hdr.h    |    1 +
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c |  637 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_init.c   |   17 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |  138 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |    3 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h        |    2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |   14 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |   10 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |   19 +-
 drivers/net/ethernet/qlogic/qlge/qlge.h            |    2 +-
 drivers/net/ethernet/qlogic/qlge/qlge_dbg.c        |    4 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c       |   86 +-
 drivers/net/ethernet/racal/ni5010.c                |    2 +-
 drivers/net/ethernet/rdc/r6040.c                   |    3 +-
 drivers/net/ethernet/realtek/8139too.c             |  109 +-
 drivers/net/ethernet/realtek/Kconfig               |   10 +-
 drivers/net/ethernet/realtek/atp.c                 |    2 +-
 drivers/net/ethernet/realtek/r8169.c               | 3734 ++--
 drivers/net/ethernet/renesas/sh_eth.c              |  439 +-
 drivers/net/ethernet/renesas/sh_eth.h              |   15 +-
 drivers/net/ethernet/s6gmac.c                      |   15 +-
 drivers/net/ethernet/seeq/ether3.c                 |    2 +-
 drivers/net/ethernet/seeq/seeq8005.c               |    2 +-
 drivers/net/ethernet/seeq/sgiseeq.c                |    1 -
 drivers/net/ethernet/sfc/Kconfig                   |   21 +-
 drivers/net/ethernet/sfc/Makefile                  |    3 +-
 drivers/net/ethernet/sfc/bitfield.h                |   22 +-
 drivers/net/ethernet/sfc/efx.c                     |  931 +-
 drivers/net/ethernet/sfc/efx.h                     |   11 +-
 drivers/net/ethernet/sfc/ethtool.c                 |  200 +-
 drivers/net/ethernet/sfc/falcon.c                  |   54 +-
 drivers/net/ethernet/sfc/falcon_boards.c           |   25 +-
 drivers/net/ethernet/sfc/falcon_xmac.c             |   15 +-
 drivers/net/ethernet/sfc/filter.c                  |  255 +-
 drivers/net/ethernet/sfc/filter.h                  |   20 +-
 drivers/net/ethernet/sfc/mac.h                     |   21 -
 drivers/net/ethernet/sfc/mcdi.c                    |  149 +-
 drivers/net/ethernet/sfc/mcdi.h                    |   36 +-
 drivers/net/ethernet/sfc/mcdi_mac.c                |   65 +-
 drivers/net/ethernet/sfc/mcdi_mon.c                |  415 +
 drivers/net/ethernet/sfc/mcdi_pcol.h               | 3542 ++-
 drivers/net/ethernet/sfc/mcdi_phy.c                |   36 +-
 drivers/net/ethernet/sfc/mdio_10g.c                |    2 +-
 drivers/net/ethernet/sfc/mtd.c                     |   15 +-
 drivers/net/ethernet/sfc/net_driver.h              |  325 +-
 drivers/net/ethernet/sfc/nic.c                     |  602 +-
 drivers/net/ethernet/sfc/nic.h                     |  141 +-
 drivers/net/ethernet/sfc/qt202x_phy.c              |    6 +-
 drivers/net/ethernet/sfc/regs.h                    |   20 +-
 drivers/net/ethernet/sfc/rx.c                      |  133 +-
 drivers/net/ethernet/sfc/selftest.c                |  218 +-
 drivers/net/ethernet/sfc/selftest.h                |    4 +-
 drivers/net/ethernet/sfc/siena.c                   |   50 +-
 drivers/net/ethernet/sfc/siena_sriov.c             | 1643 ++
 drivers/net/ethernet/sfc/spi.h                     |    2 +-
 drivers/net/ethernet/sfc/tenxpress.c               |    2 +-
 drivers/net/ethernet/sfc/tx.c                      |    8 +-
 drivers/net/ethernet/sfc/txc43128_phy.c            |    2 +-
 drivers/net/ethernet/sfc/vfdi.h                    |  255 +
 drivers/net/ethernet/sis/sis190.c                  |    2 -
 drivers/net/ethernet/sis/sis900.c                  |    9 +-
 drivers/net/ethernet/smsc/epic100.c                |   11 +-
 drivers/net/ethernet/smsc/smc911x.c                |    3 +-
 drivers/net/ethernet/smsc/smc9194.c                |    2 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c            |    2 +-
 drivers/net/ethernet/smsc/smc91x.c                 |    3 +-
 drivers/net/ethernet/smsc/smsc911x.c               |    4 +-
 drivers/net/ethernet/smsc/smsc9420.c               |   11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |    2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   74 +-
 drivers/net/ethernet/sun/cassini.c                 |    4 +-
 drivers/net/ethernet/sun/niu.c                     |    6 +-
 drivers/net/ethernet/sun/sunbmac.c                 |    2 +-
 drivers/net/ethernet/sun/sungem.c                  |    1 -
 drivers/net/ethernet/sun/sunhme.c                  |    2 +-
 drivers/net/ethernet/sun/sunqe.c                   |   12 +-
 drivers/net/ethernet/sun/sunvnet.c                 |   13 +-
 drivers/net/ethernet/tehuti/tehuti.c               |    8 +-
 drivers/net/ethernet/ti/Kconfig                    |   11 +
 drivers/net/ethernet/ti/Makefile                   |    2 +
 drivers/net/ethernet/ti/cpmac.c                    |    5 +-
 drivers/net/ethernet/ti/cpsw.c                     | 1019 +
 drivers/net/ethernet/ti/cpsw_ale.c                 |  641 +
 drivers/net/ethernet/ti/cpsw_ale.h                 |   93 +
 drivers/net/ethernet/ti/davinci_cpdma.c            |    2 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   11 +-
 drivers/net/ethernet/ti/davinci_mdio.c             |    2 +-
 drivers/net/ethernet/ti/tlan.c                     |    1 -
 drivers/net/ethernet/tile/tilepro.c                |    9 +-
 drivers/net/ethernet/toshiba/ps3_gelic_wireless.c  |    5 +-
 drivers/net/ethernet/toshiba/tc35815.c             |    9 +-
 drivers/net/ethernet/tundra/tsi108_eth.c           |    6 +-
 drivers/net/ethernet/via/via-rhine.c               |    5 +-
 drivers/net/ethernet/via/via-velocity.c            |    6 +-
 drivers/net/ethernet/xilinx/Kconfig                |    8 +
 drivers/net/ethernet/xilinx/Makefile               |    2 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        |    9 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |  508 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  | 1669 ++
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  |  238 +
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    6 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    3 +-
 drivers/net/ethernet/xscale/ixp2000/ixpdev.c       |    7 +-
 drivers/net/hamradio/baycom_epp.c                  |    2 +-
 drivers/net/hamradio/baycom_par.c                  |    2 +-
 drivers/net/hamradio/yam.c                         |    1 -
 drivers/net/hippi/rrunner.c                        |    8 +-
 drivers/net/hyperv/hyperv_net.h                    |   34 +-
 drivers/net/hyperv/netvsc.c                        |    3 +-
 drivers/net/hyperv/netvsc_drv.c                    |   20 +-
 drivers/net/hyperv/rndis_filter.c                  |  159 +-
 drivers/net/ifb.c                                  |    2 +-
 drivers/net/irda/ali-ircc.c                        |    2 +-
 drivers/net/irda/donauboe.c                        |    2 -
 drivers/net/irda/pxaficp_ir.c                      |    6 +-
 drivers/net/irda/via-ircc.c                        |    4 +-
 drivers/net/irda/w83977af_ir.c                     |    2 +-
 drivers/net/macvlan.c                              |    3 +-
 drivers/net/mdio.c                                 |    3 +
 drivers/net/mii.c                                  |    4 +-
 drivers/net/netconsole.c                           |    8 +-
 drivers/net/phy/Kconfig                            |    5 +
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/amd.c                              |  102 +
 drivers/net/phy/broadcom.c                         |    6 +-
 drivers/net/phy/dp83640.c                          |    2 +-
 drivers/net/plip/plip.c                            |    4 +-
 drivers/net/ppp/ppp_async.c                        |    2 +-
 drivers/net/ppp/ppp_deflate.c                      |   30 +-
 drivers/net/ppp/ppp_generic.c                      |    6 +-
 drivers/net/ppp/ppp_synctty.c                      |    2 +-
 drivers/net/ppp/pppoe.c                            |    2 +-
 drivers/net/ppp/pppox.c                            |    2 +-
 drivers/net/ppp/pptp.c                             |    8 +-
 drivers/net/rionet.c                               |    2 -
 drivers/net/slip/slip.c                            |    4 +-
 drivers/net/team/team.c                            |    3 +-
 drivers/net/tokenring/3c359.c                      |    4 -
 drivers/net/tokenring/madgemc.c                    |    1 -
 drivers/net/tokenring/tms380tr.c                   |  179 +-
 drivers/net/tun.c                                  |    2 +-
 drivers/net/usb/Kconfig                            |   23 +
 drivers/net/usb/Makefile                           |    1 +
 drivers/net/usb/asix.c                             |   88 +-
 drivers/net/usb/cdc_ncm.c                          |  236 +-
 drivers/net/usb/kaweth.c                           |    8 +-
 drivers/net/usb/mcs7830.c                          |    2 +-
 drivers/net/usb/pegasus.c                          |    4 +-
 drivers/net/usb/qmi_wwan.c                         |  228 +
 drivers/net/usb/rtl8150.c                          |    4 +-
 drivers/net/usb/smsc75xx.c                         |    2 +-
 drivers/net/usb/smsc95xx.c                         |    2 +-
 drivers/net/usb/usbnet.c                           |    6 +-
 drivers/net/veth.c                                 |    4 +-
 drivers/net/virtio_net.c                           |    9 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |   63 +-
 drivers/net/wan/c101.c                             |    4 +-
 drivers/net/wan/dscc4.c                            |    8 +-
 drivers/net/wan/hdlc_fr.c                          |    2 +-
 drivers/net/wan/hdlc_raw_eth.c                     |    2 +-
 drivers/net/wan/lmc/lmc_main.c                     |    1 -
 drivers/net/wan/n2.c                               |    4 +-
 drivers/net/wan/pc300too.c                         |    1 -
 drivers/net/wan/pci200syn.c                        |    1 -
 drivers/net/wan/wanxl.c                            |    1 -
 drivers/net/wan/x25_asy.c                          |    4 +-
 drivers/net/wireless/airo.c                        |    2 +-
 drivers/net/wireless/ath/ath.h                     |   26 +-
 drivers/net/wireless/ath/ath5k/ahb.c               |   20 +-
 drivers/net/wireless/ath/ath5k/ani.c               |    8 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |    5 +-
 drivers/net/wireless/ath/ath5k/base.c              |   25 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   12 +
 drivers/net/wireless/ath/ath5k/phy.c               |   34 +-
 drivers/net/wireless/ath/ath5k/reset.c             |   10 +-
 drivers/net/wireless/ath/ath6kl/Kconfig            |   25 +-
 drivers/net/wireless/ath/ath6kl/Makefile           |   33 +-
 drivers/net/wireless/ath/ath6kl/bmi.c              |   17 +-
 drivers/net/wireless/ath/ath6kl/bmi.h              |   24 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         | 1002 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.h         |   13 +-
 drivers/net/wireless/ath/ath6kl/common.h           |    4 +-
 drivers/net/wireless/ath/ath6kl/core.c             |  299 +
 drivers/net/wireless/ath/ath6kl/core.h             |  169 +-
 drivers/net/wireless/ath/ath6kl/debug.c            |  431 +-
 drivers/net/wireless/ath/ath6kl/debug.h            |   38 +-
 drivers/net/wireless/ath/ath6kl/hif-ops.h          |    1 +
 drivers/net/wireless/ath/ath6kl/hif.c              |   27 +-
 drivers/net/wireless/ath/ath6kl/hif.h              |    4 +
 drivers/net/wireless/ath/ath6kl/htc.c              |  213 +-
 drivers/net/wireless/ath/ath6kl/htc.h              |   16 +-
 drivers/net/wireless/ath/ath6kl/init.c             |  636 +-
 drivers/net/wireless/ath/ath6kl/main.c             |  234 +-
 drivers/net/wireless/ath/ath6kl/sdio.c             |  183 +-
 drivers/net/wireless/ath/ath6kl/target.h           |    2 +
 drivers/net/wireless/ath/ath6kl/testmode.c         |  103 +-
 drivers/net/wireless/ath/ath6kl/testmode.h         |    7 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |  592 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |  432 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |  451 +-
 drivers/net/wireless/ath/ath6kl/wmi.h              |   90 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |   24 +-
 drivers/net/wireless/ath/ath9k/Makefile            |   10 +-
 drivers/net/wireless/ath/ath9k/ani.c               |    6 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   21 +-
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h   |  270 -
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |  149 +-
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h   |  104 -
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |    5 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |    2 +
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  302 -
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |   42 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |    4 -
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  113 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   74 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.h        |    3 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c        | 1250 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.h        |  233 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   34 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   23 +-
 .../net/wireless/ath/ath9k/ar9462_1p0_initvals.h   | 1833 --
 .../net/wireless/ath/ath9k/ar9462_2p0_initvals.h   |  465 -
 drivers/net/wireless/ath/ath9k/ath9k.h             |   59 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   14 +-
 drivers/net/wireless/ath/ath9k/btcoex.c            |   77 +-
 drivers/net/wireless/ath/ath9k/btcoex.h            |    4 +-
 drivers/net/wireless/ath/ath9k/debug.c             |  400 +-
 drivers/net/wireless/ath/ath9k/debug.h             |   27 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |  124 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  156 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h           |    3 +-
 drivers/net/wireless/ath/ath9k/htc.h               |   21 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c      |   73 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   34 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   31 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    5 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  323 +-
 drivers/net/wireless/ath/ath9k/hw.h                |  224 +-
 drivers/net/wireless/ath/ath9k/init.c              |   87 +-
 drivers/net/wireless/ath/ath9k/mac.c               |   42 +-
 drivers/net/wireless/ath/ath9k/mac.h               |    4 +-
 drivers/net/wireless/ath/ath9k/main.c              |   96 +-
 drivers/net/wireless/ath/ath9k/mci.c               |  290 +-
 drivers/net/wireless/ath/ath9k/mci.h               |    5 +-
 drivers/net/wireless/ath/ath9k/rc.c                |   20 +-
 drivers/net/wireless/ath/ath9k/rc.h                |    2 -
 drivers/net/wireless/ath/ath9k/recv.c              |   70 +-
 drivers/net/wireless/ath/ath9k/reg.h               |    6 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   59 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    2 +-
 drivers/net/wireless/ath/carl9170/fw.c             |   33 -
 drivers/net/wireless/ath/carl9170/mac.c            |   35 +
 drivers/net/wireless/ath/carl9170/main.c           |   18 +-
 drivers/net/wireless/ath/carl9170/phy.c            |   36 +-
 drivers/net/wireless/ath/carl9170/tx.c             |    4 +-
 drivers/net/wireless/ath/main.c                    |    9 +-
 drivers/net/wireless/atmel.c                       |    5 +-
 drivers/net/wireless/b43/b43.h                     |   15 +
 drivers/net/wireless/b43/main.c                    |  128 +-
 drivers/net/wireless/b43/phy_n.c                   |  532 +-
 drivers/net/wireless/b43/phy_n.h                   |    1 +
 drivers/net/wireless/b43/tables_nphy.c             |   76 +-
 drivers/net/wireless/b43/tables_nphy.h             |   14 +-
 drivers/net/wireless/b43legacy/b43legacy.h         |    3 +
 drivers/net/wireless/b43legacy/main.c              |   33 +-
 drivers/net/wireless/b43legacy/phy.c               |    2 +-
 drivers/net/wireless/brcm80211/Kconfig             |   17 +-
 drivers/net/wireless/brcm80211/Makefile            |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |    2 +
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   19 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   17 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    2 +
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   17 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   20 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   71 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  264 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      | 1621 ++
 drivers/net/wireless/brcm80211/brcmfmac/usb.h      |   61 +
 drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h  |   75 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   29 +-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   36 +-
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |    4 +-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |   22 +-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |    8 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   55 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |  199 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    6 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   35 +-
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |   14 +-
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   26 +-
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   15 +-
 drivers/net/wireless/hostap/hostap_hw.c            |   18 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |  108 +-
 drivers/net/wireless/ipw2x00/ipw2200.h             |   14 -
 drivers/net/wireless/ipw2x00/libipw_module.c       |    5 +-
 drivers/net/wireless/ipw2x00/libipw_rx.c           |    2 +-
 drivers/net/wireless/iwlegacy/3945-debug.c         |    6 +
 drivers/net/wireless/iwlegacy/3945-mac.c           |  286 +-
 drivers/net/wireless/iwlegacy/3945-rs.c            |    7 +-
 drivers/net/wireless/iwlegacy/3945.c               |  228 +-
 drivers/net/wireless/iwlegacy/3945.h               |   14 +-
 drivers/net/wireless/iwlegacy/4965-calib.c         |   36 +-
 drivers/net/wireless/iwlegacy/4965-debug.c         |    6 +
 drivers/net/wireless/iwlegacy/4965-mac.c           | 1058 +-
 drivers/net/wireless/iwlegacy/4965-rs.c            |   48 +-
 drivers/net/wireless/iwlegacy/4965.c               |  698 +-
 drivers/net/wireless/iwlegacy/4965.h               |   43 +-
 drivers/net/wireless/iwlegacy/Kconfig              |   78 +-
 drivers/net/wireless/iwlegacy/common.c             | 1112 +-
 drivers/net/wireless/iwlegacy/common.h             |  471 +-
 drivers/net/wireless/iwlegacy/debug.c              |  291 +-
 drivers/net/wireless/iwlwifi/Kconfig               |   11 +-
 drivers/net/wireless/iwlwifi/Makefile              |    5 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |   49 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c            |   64 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |   89 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c            |  137 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c       |   67 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         |  110 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |   26 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c          |  213 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c        |  115 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c         |  396 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c          |   67 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |  174 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             | 1241 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h             |  190 +-
 drivers/net/wireless/iwlwifi/iwl-bus.h             |  209 -
 drivers/net/wireless/iwlwifi/iwl-cfg.h             |   84 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |  110 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  262 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |   94 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |    4 +-
 .../wireless/iwlwifi/{iwl-trans.c => iwl-debug.c}  |   68 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h           |   78 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |  185 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |  185 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h        |  208 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c             |  993 +
 drivers/net/wireless/iwlwifi/iwl-drv.h             |  123 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |  240 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |   11 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h              |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h         |  165 +
 drivers/net/wireless/iwlwifi/iwl-fw.h              |  177 +
 drivers/net/wireless/iwlwifi/iwl-io.c              |  224 +-
 drivers/net/wireless/iwlwifi/iwl-io.h              |   62 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |   19 +-
 drivers/net/wireless/iwlwifi/iwl-led.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c        |  505 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c      |  157 +
 .../iwlwifi/{iwl-wifi.h => iwl-notif-wait.h}       |   81 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h         |  216 +
 drivers/net/wireless/iwlwifi/iwl-pci.c             |  264 +-
 drivers/net/wireless/iwlwifi/iwl-power.c           |   18 +-
 drivers/net/wireless/iwlwifi/iwl-power.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |    8 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |  251 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h          |  400 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.c        |  552 +-
 drivers/net/wireless/iwlwifi/iwl-testmode.h        |   99 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h  |  132 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c   |  439 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c   |  238 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c      |  918 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |  463 +-
 drivers/net/wireless/iwlwifi/iwl-ucode.c           |  428 +-
 drivers/net/wireless/iwmc3200wifi/trace.h          |    2 +-
 drivers/net/wireless/libertas/cfg.c                |   37 -
 drivers/net/wireless/libertas/if_cs.c              |    5 +-
 drivers/net/wireless/libertas/if_usb.c             |    4 +-
 drivers/net/wireless/libertas_tf/if_usb.c          |    4 +-
 drivers/net/wireless/mac80211_hwsim.c              |   56 +-
 drivers/net/wireless/mwifiex/11n.c                 |   82 +-
 drivers/net/wireless/mwifiex/11n.h                 |   16 +-
 drivers/net/wireless/mwifiex/11n_aggr.c            |   18 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c       |  211 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.h       |    5 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |  176 +-
 drivers/net/wireless/mwifiex/cfp.c                 |   90 +-
 drivers/net/wireless/mwifiex/cmdevt.c              |  177 +-
 drivers/net/wireless/mwifiex/decl.h                |   11 +-
 drivers/net/wireless/mwifiex/fw.h                  |   19 +-
 drivers/net/wireless/mwifiex/init.c                |   39 +-
 drivers/net/wireless/mwifiex/ioctl.h               |    4 +-
 drivers/net/wireless/mwifiex/join.c                |  184 +-
 drivers/net/wireless/mwifiex/main.c                |   70 +-
 drivers/net/wireless/mwifiex/main.h                |   44 +-
 drivers/net/wireless/mwifiex/pcie.c                |  394 +-
 drivers/net/wireless/mwifiex/scan.c                |  430 +-
 drivers/net/wireless/mwifiex/sdio.c                |  196 +-
 drivers/net/wireless/mwifiex/sta_cmd.c             |  235 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c         |  356 +-
 drivers/net/wireless/mwifiex/sta_event.c           |   43 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  147 +-
 drivers/net/wireless/mwifiex/sta_rx.c              |   10 +-
 drivers/net/wireless/mwifiex/sta_tx.c              |   25 +-
 drivers/net/wireless/mwifiex/txrx.c                |   17 +-
 drivers/net/wireless/mwifiex/util.c                |   21 +-
 drivers/net/wireless/mwifiex/wmm.c                 |  167 +-
 drivers/net/wireless/mwifiex/wmm.h                 |    4 +-
 drivers/net/wireless/mwl8k.c                       |   45 +-
 drivers/net/wireless/orinoco/main.c                |    6 +-
 drivers/net/wireless/orinoco/orinoco_usb.c         |    5 -
 drivers/net/wireless/p54/main.c                    |    8 +-
 drivers/net/wireless/p54/p54pci.c                  |   48 +-
 drivers/net/wireless/p54/p54spi.c                  |   14 +-
 drivers/net/wireless/p54/txrx.c                    |    2 +-
 drivers/net/wireless/prism54/islpci_mgt.c          |    6 +-
 drivers/net/wireless/rndis_wlan.c                  |   61 +-
 drivers/net/wireless/rt2x00/Kconfig                |    2 +-
 drivers/net/wireless/rt2x00/rt2800.h               |   81 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  431 +-
 drivers/net/wireless/rt2x00/rt2800lib.h            |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c            |   66 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |  232 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |   38 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |    5 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   24 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   13 +
 drivers/net/wireless/rt2x00/rt2x00link.c           |   39 +
 drivers/net/wireless/rt2x00/rt2x00queue.h          |   12 -
 drivers/net/wireless/rt2x00/rt2x00usb.c            |   21 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |  110 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h     |    9 +
 drivers/net/wireless/rtlwifi/Kconfig               |    5 +
 drivers/net/wireless/rtlwifi/base.c                |   73 +-
 drivers/net/wireless/rtlwifi/base.h                |    2 +-
 drivers/net/wireless/rtlwifi/cam.c                 |   85 +-
 drivers/net/wireless/rtlwifi/cam.h                 |    2 +-
 drivers/net/wireless/rtlwifi/core.c                |  170 +-
 drivers/net/wireless/rtlwifi/core.h                |    6 +-
 drivers/net/wireless/rtlwifi/debug.c               |    4 +-
 drivers/net/wireless/rtlwifi/debug.h               |  121 +-
 drivers/net/wireless/rtlwifi/efuse.c               |   65 +-
 drivers/net/wireless/rtlwifi/efuse.h               |    2 +-
 drivers/net/wireless/rtlwifi/pci.c                 |  280 +-
 drivers/net/wireless/rtlwifi/pci.h                 |    3 +-
 drivers/net/wireless/rtlwifi/ps.c                  |   39 +-
 drivers/net/wireless/rtlwifi/ps.h                  |    2 +-
 drivers/net/wireless/rtlwifi/rc.c                  |    4 +-
 drivers/net/wireless/rtlwifi/rc.h                  |    2 +-
 drivers/net/wireless/rtlwifi/regd.c                |   14 +-
 drivers/net/wireless/rtlwifi/regd.h                |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |  212 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c  |   99 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/main.c       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |  281 +-
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.c        |   26 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |  288 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c       |   18 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/led.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |  113 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c        |   87 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |   37 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/table.c     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/table.h     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |   25 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c        |   26 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |  464 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/led.c       |   17 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/led.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c       |  133 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |  126 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/reg.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |   75 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |   34 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/table.c     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/table.h     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |   44 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/def.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c        |  243 +-
 drivers/net/wireless/rtlwifi/rtl8192de/dm.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c        |  137 +-
 drivers/net/wireless/rtlwifi/rtl8192de/fw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |  202 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/led.c       |   16 +-
 drivers/net/wireless/rtlwifi/rtl8192de/led.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c       |  810 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h       |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192de/rf.c        |   99 +-
 drivers/net/wireless/rtlwifi/rtl8192de/rf.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.c        |   57 +-
 drivers/net/wireless/rtlwifi/rtl8192de/sw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/table.c     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/table.h     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |   28 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/def.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c        |   32 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c        |   76 +-
 drivers/net/wireless/rtlwifi/rtl8192se/fw.h        |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        |  272 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/led.c       |   22 +-
 drivers/net/wireless/rtlwifi/rtl8192se/led.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c       |  261 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/reg.h       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c        |   66 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c        |   88 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.h        |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/table.c     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/table.h     |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |   20 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.h       |    2 +-
 drivers/net/wireless/rtlwifi/usb.c                 |  110 +-
 drivers/net/wireless/rtlwifi/usb.h                 |    3 +-
 drivers/net/wireless/rtlwifi/wifi.h                |    8 +-
 drivers/net/wireless/wl1251/Makefile               |    2 +
 drivers/net/wireless/wl1251/boot.c                 |    2 -
 drivers/net/wireless/wl1251/io.h                   |    9 +-
 drivers/net/wireless/wl1251/main.c                 |    7 +-
 drivers/net/wireless/wl1251/wl1251.h               |    2 +-
 drivers/net/wireless/wl12xx/Makefile               |    2 +
 drivers/net/wireless/wl12xx/acx.c                  |   17 +-
 drivers/net/wireless/wl12xx/acx.h                  |  149 +-
 drivers/net/wireless/wl12xx/boot.c                 |  105 +-
 drivers/net/wireless/wl12xx/boot.h                 |   10 -
 drivers/net/wireless/wl12xx/cmd.c                  |  169 +-
 drivers/net/wireless/wl12xx/cmd.h                  |  148 +-
 drivers/net/wireless/wl12xx/conf.h                 |   54 +-
 drivers/net/wireless/wl12xx/debug.h                |    1 +
 drivers/net/wireless/wl12xx/debugfs.c              |  241 +-
 drivers/net/wireless/wl12xx/event.c                |  154 +-
 drivers/net/wireless/wl12xx/event.h                |   20 +-
 drivers/net/wireless/wl12xx/init.c                 |   55 +-
 drivers/net/wireless/wl12xx/io.c                   |   59 +
 drivers/net/wireless/wl12xx/io.h                   |    2 +
 drivers/net/wireless/wl12xx/main.c                 | 1115 +-
 drivers/net/wireless/wl12xx/ps.c                   |   38 +-
 drivers/net/wireless/wl12xx/ps.h                   |    2 +-
 drivers/net/wireless/wl12xx/reg.h                  |   27 +
 drivers/net/wireless/wl12xx/rx.c                   |    2 +-
 drivers/net/wireless/wl12xx/scan.c                 |   62 +-
 drivers/net/wireless/wl12xx/scan.h                 |    2 +-
 drivers/net/wireless/wl12xx/sdio.c                 |   29 +-
 drivers/net/wireless/wl12xx/spi.c                  |    8 +-
 drivers/net/wireless/wl12xx/testmode.c             |   50 +
 drivers/net/wireless/wl12xx/tx.c                   |  116 +-
 drivers/net/wireless/wl12xx/tx.h                   |    6 +-
 drivers/net/wireless/wl12xx/wl12xx.h               |   53 +-
 drivers/net/wireless/wl12xx/wl12xx_80211.h         |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |   12 +-
 drivers/net/xen-netback/netback.c                  |    4 +-
 drivers/net/xen-netfront.c                         |   62 +-
 drivers/nfc/nfcwilink.c                            |  305 +-
 drivers/nfc/pn533.c                                |   31 +-
 drivers/pci/quirks.c                               |   18 +
 drivers/ptp/Kconfig                                |   13 +
 drivers/ptp/Makefile                               |    1 +
 drivers/ptp/ptp_clock.c                            |    2 +-
 drivers/ptp/ptp_ixp46x.c                           |    2 +-
 drivers/ptp/ptp_pch.c                              |  730 +
 drivers/s390/net/ctcm_fsms.c                       |   11 +
 drivers/s390/net/ctcm_main.c                       |    3 +
 drivers/s390/net/ctcm_mpc.c                        |   12 +-
 drivers/s390/net/lcs.c                             |   12 +-
 drivers/s390/net/qeth_core.h                       |    1 +
 drivers/s390/net/qeth_core_main.c                  |  110 +-
 drivers/s390/net/qeth_core_mpc.c                   |    1 +
 drivers/s390/net/qeth_core_mpc.h                   |   14 +
 drivers/s390/net/qeth_l2_main.c                    |    7 +-
 drivers/s390/net/qeth_l3_main.c                    |   40 +-
 drivers/scsi/bnx2fc/bnx2fc_constants.h             |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |   12 +-
 drivers/scsi/fcoe/fcoe.c                           |    2 +-
 drivers/ssb/driver_chipcommon_pmu.c                |   48 +-
 drivers/ssb/driver_mipscore.c                      |    3 +
 drivers/ssb/main.c                                 |    3 +
 drivers/ssb/pci.c                                  |   81 +-
 drivers/ssb/pcmcia.c                               |   12 +-
 drivers/ssb/scan.c                                 |    3 +
 drivers/ssb/sdio.c                                 |   12 +-
 drivers/ssb/ssb_private.h                          |    4 +
 drivers/staging/et131x/et131x.c                    |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    7 +-
 drivers/staging/wlags49_h2/wl_cs.c                 |    7 +-
 drivers/tty/ipwireless/network.c                   |    2 +-
 drivers/tty/ipwireless/tty.c                       |    2 +-
 fs/compat_ioctl.c                                  |    2 +-
 fs/dlm/lowcomms.c                                  |   22 +-
 include/asm-generic/socket.h                       |    5 +
 include/linux/Kbuild                               |    2 +
 include/linux/bcma/bcma.h                          |    9 +
 include/linux/bcma/bcma_driver_chipcommon.h        |   26 +-
 include/linux/bcma/bcma_driver_pci.h               |  125 +-
 include/linux/bcma/bcma_regs.h                     |   27 +
 include/linux/can/dev.h                            |    2 +-
 include/linux/dccp.h                               |    8 +-
 include/linux/etherdevice.h                        |   13 +-
 include/linux/ethtool.h                            |   23 +-
 include/linux/if.h                                 |    2 +
 include/linux/if_ppp.h                             |  174 +-
 include/linux/if_vlan.h                            |    7 +-
 include/linux/in.h                                 |    1 +
 include/linux/in6.h                                |    1 +
 include/linux/inetdevice.h                         |    1 +
 include/linux/ipv6.h                               |    8 +-
 include/linux/isdn.h                               |    2 +-
 include/linux/mdio.h                               |   10 +-
 include/linux/mlx4/device.h                        |    5 +-
 include/linux/mlx4/qp.h                            |    5 +-
 include/linux/net.h                                |    1 +
 include/linux/netdev_features.h                    |    4 +
 include/linux/netdevice.h                          |  117 +-
 include/linux/netfilter/Kbuild                     |    2 +
 include/linux/netfilter/ipset/ip_set.h             |   35 +-
 include/linux/netfilter/ipset/ip_set_ahash.h       |  119 +-
 include/linux/netfilter/nf_conntrack_tcp.h         |    5 +-
 include/linux/netfilter/nfnetlink.h                |    3 +-
 include/linux/netfilter/nfnetlink_conntrack.h      |   12 +
 include/linux/netfilter/nfnetlink_cttimeout.h      |  114 +
 include/linux/netfilter/xt_CT.h                    |   12 +
 include/linux/netfilter/xt_LOG.h                   |   19 +
 include/linux/netfilter_ipv4/Kbuild                |    2 -
 include/linux/netfilter_ipv4/ipt_LOG.h             |    2 +
 include/linux/netfilter_ipv4/ipt_SAME.h            |   20 -
 include/linux/netfilter_ipv4/ipt_realm.h           |    7 -
 include/linux/netfilter_ipv6/ip6t_LOG.h            |    2 +
 include/linux/netlink.h                            |   30 +-
 include/linux/nfc.h                                |    8 +
 include/linux/nl80211.h                            |   72 +-
 include/linux/pci_ids.h                            |    1 +
 include/linux/pkt_sched.h                          |   21 +
 include/linux/platform_data/cpsw.h                 |   55 +
 include/linux/ppp-comp.h                           |   38 +-
 include/linux/ppp-ioctl.h                          |  119 +
 include/linux/ppp_defs.h                           |   38 +-
 include/linux/sh_eth.h                             |    1 +
 include/linux/skbuff.h                             |   46 +-
 include/linux/snmp.h                               |    2 +
 include/linux/socket.h                             |    4 +-
 include/linux/ssb/ssb.h                            |  108 +-
 include/linux/ssb/ssb_regs.h                       |   34 +
 include/linux/tcp.h                                |    5 +-
 include/net/addrconf.h                             |    1 -
 include/net/arp.h                                  |    4 +-
 include/net/bluetooth/bluetooth.h                  |   40 +-
 include/net/bluetooth/hci.h                        |   76 +-
 include/net/bluetooth/hci_core.h                   |  301 +-
 include/net/bluetooth/hci_mon.h                    |   51 +
 include/net/bluetooth/l2cap.h                      |   87 +-
 include/net/bluetooth/mgmt.h                       |  338 +-
 include/net/bluetooth/smp.h                        |    2 +-
 include/net/caif/caif_hsi.h                        |    1 +
 include/net/cfg80211.h                             |  179 +-
 include/net/compat.h                               |    2 +-
 include/net/dcbnl.h                                |    4 +-
 include/net/dn.h                                   |    1 +
 include/net/genetlink.h                            |   31 +-
 include/net/inet_sock.h                            |    3 +
 include/net/ip.h                                   |    2 +-
 include/net/iucv/af_iucv.h                         |    3 +
 include/net/mac80211.h                             |  154 +-
 include/net/ndisc.h                                |    1 -
 include/net/netfilter/nf_conntrack_extend.h        |    4 +
 include/net/netfilter/nf_conntrack_helper.h        |   13 +
 include/net/netfilter/nf_conntrack_l4proto.h       |   19 +-
 include/net/netfilter/nf_conntrack_timeout.h       |   78 +
 include/net/netfilter/xt_log.h                     |    2 +-
 include/net/netlink.h                              |   35 -
 include/net/nfc/nci.h                              |   53 +-
 include/net/nfc/nci_core.h                         |   36 +-
 include/net/nfc/nfc.h                              |   39 +-
 include/net/sctp/sctp.h                            |    1 +
 include/net/sock.h                                 |   29 +
 include/net/tcp.h                                  |   66 +-
 include/net/udplite.h                              |    4 +-
 include/net/xfrm.h                                 |    5 -
 net/atm/clip.c                                     |   17 +-
 net/atm/pppoatm.c                                  |    2 +-
 net/batman-adv/Makefile                            |    2 +-
 net/batman-adv/{bat_ogm.h => bat_algo.h}           |   20 +-
 net/batman-adv/bat_debugfs.c                       |   24 +-
 net/batman-adv/bat_debugfs.h                       |    2 +-
 net/batman-adv/bat_iv_ogm.c                        |  304 +-
 net/batman-adv/bat_sysfs.c                         |   31 +-
 net/batman-adv/bat_sysfs.h                         |    2 +-
 net/batman-adv/bitarray.c                          |   10 +-
 net/batman-adv/bitarray.h                          |    2 +-
 net/batman-adv/gateway_client.c                    |   37 +-
 net/batman-adv/gateway_client.h                    |    2 +-
 net/batman-adv/gateway_common.c                    |   14 +-
 net/batman-adv/gateway_common.h                    |    2 +-
 net/batman-adv/hard-interface.c                    |   66 +-
 net/batman-adv/hard-interface.h                    |    2 +-
 net/batman-adv/hash.c                              |    2 +-
 net/batman-adv/hash.h                              |    2 +-
 net/batman-adv/icmp_socket.c                       |   20 +-
 net/batman-adv/icmp_socket.h                       |    2 +-
 net/batman-adv/main.c                              |  113 +-
 net/batman-adv/main.h                              |   45 +-
 net/batman-adv/originator.c                        |   33 +-
 net/batman-adv/originator.h                        |    2 +-
 net/batman-adv/packet.h                            |   40 +-
 net/batman-adv/ring_buffer.c                       |    2 +-
 net/batman-adv/ring_buffer.h                       |    2 +-
 net/batman-adv/routing.c                           |   67 +-
 net/batman-adv/routing.h                           |    2 +-
 net/batman-adv/send.c                              |   15 +-
 net/batman-adv/send.h                              |    2 +-
 net/batman-adv/soft-interface.c                    |   44 +-
 net/batman-adv/soft-interface.h                    |    2 +-
 net/batman-adv/translation-table.c                 |  251 +-
 net/batman-adv/translation-table.h                 |    2 +-
 net/batman-adv/types.h                             |   23 +-
 net/batman-adv/unicast.c                           |   22 +-
 net/batman-adv/unicast.h                           |    2 +-
 net/batman-adv/vis.c                               |   19 +-
 net/batman-adv/vis.h                               |    5 +-
 net/bluetooth/Kconfig                              |    1 -
 net/bluetooth/bnep/sock.c                          |    6 +-
 net/bluetooth/cmtp/sock.c                          |    6 +-
 net/bluetooth/hci_conn.c                           |   73 +-
 net/bluetooth/hci_core.c                           |  645 +-
 net/bluetooth/hci_event.c                          |  631 +-
 net/bluetooth/hci_sock.c                           |  469 +-
 net/bluetooth/hci_sysfs.c                          |   53 +-
 net/bluetooth/hidp/sock.c                          |    6 +-
 net/bluetooth/l2cap_core.c                         |  641 +-
 net/bluetooth/l2cap_sock.c                         |   54 +-
 net/bluetooth/lib.c                                |   27 +-
 net/bluetooth/mgmt.c                               | 2697 ++-
 net/bluetooth/rfcomm/tty.c                         |    6 +-
 net/bluetooth/smp.c                                |  108 +-
 net/bridge/br_device.c                             |    5 +-
 net/caif/caif_dev.c                                |    2 -
 net/caif/caif_socket.c                             |  113 +-
 net/caif/cfdbgl.c                                  |    4 +-
 net/caif/cfdgml.c                                  |    9 +-
 net/caif/cfrfml.c                                  |   25 +-
 net/caif/cfsrvl.c                                  |    6 +-
 net/caif/cfutill.c                                 |    5 +-
 net/caif/cfvidl.c                                  |    6 +-
 net/caif/chnl_net.c                                |   24 +-
 net/compat.c                                       |    2 +-
 net/core/datagram.c                                |   26 +-
 net/core/dev.c                                     |  115 +-
 net/core/ethtool.c                                 |    2 +
 net/core/iovec.c                                   |    2 +-
 net/core/neighbour.c                               |   90 +-
 net/core/netpoll.c                                 |   71 +-
 net/core/rtnetlink.c                               |   11 +-
 net/core/skbuff.c                                  |    4 +-
 net/core/sock.c                                    |   21 +
 net/dccp/ccids/ccid3.c                             |    3 +-
 net/dccp/ipv4.c                                    |    8 +-
 net/dccp/ipv6.c                                    |    8 +-
 net/dccp/minisocks.c                               |   18 +-
 net/dccp/output.c                                  |   10 +-
 net/decnet/dn_neigh.c                              |   24 +-
 net/decnet/dn_route.c                              |    3 +-
 net/ethernet/eth.c                                 |    2 +
 net/ieee802154/6lowpan.c                           |   16 +-
 net/ipv4/af_inet.c                                 |   28 +-
 net/ipv4/ah4.c                                     |   17 +-
 net/ipv4/arp.c                                     |    2 +-
 net/ipv4/esp4.c                                    |   10 +-
 net/ipv4/fib_frontend.c                            |    6 +-
 net/ipv4/fib_semantics.c                           |    2 +-
 net/ipv4/fib_trie.c                                |    5 +-
 net/ipv4/gre.c                                     |    6 +-
 net/ipv4/icmp.c                                    |   21 +-
 net/ipv4/inet_diag.c                               |   18 +-
 net/ipv4/ip_fragment.c                             |   11 +-
 net/ipv4/ip_gre.c                                  |   29 +-
 net/ipv4/ip_input.c                                |   20 +-
 net/ipv4/ip_options.c                              |    4 +-
 net/ipv4/ip_sockglue.c                             |   37 +
 net/ipv4/ipcomp.c                                  |    8 +-
 net/ipv4/ipconfig.c                                |  110 +-
 net/ipv4/ipip.c                                    |    7 +-
 net/ipv4/ipmr.c                                    |    4 +-
 net/ipv4/netfilter/Kconfig                         |    9 -
 net/ipv4/netfilter/Makefile                        |    1 -
 net/ipv4/netfilter/ipt_LOG.c                       |  516 -
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |   60 +-
 net/ipv4/netfilter/nf_nat_core.c                   |    8 +
 net/ipv4/netfilter/nf_nat_h323.c                   |   14 +
 net/ipv4/netfilter/nf_nat_sip.c                    |    7 +
 net/ipv4/ping.c                                    |   21 +-
 net/ipv4/proc.c                                    |    2 +
 net/ipv4/raw.c                                     |   10 +-
 net/ipv4/route.c                                   |   52 +-
 net/ipv4/tcp.c                                     |   14 +-
 net/ipv4/tcp_cong.c                                |    9 +-
 net/ipv4/tcp_input.c                               |  241 +-
 net/ipv4/tcp_ipv4.c                                |  312 +-
 net/ipv4/tcp_minisocks.c                           |   12 +-
 net/ipv4/tcp_output.c                              |    4 +-
 net/ipv4/tcp_probe.c                               |    4 +-
 net/ipv4/tcp_timer.c                               |   14 +-
 net/ipv4/tunnel4.c                                 |    8 +-
 net/ipv4/udp.c                                     |   41 +-
 net/ipv4/udplite.c                                 |    7 +-
 net/ipv4/xfrm4_tunnel.c                            |   16 +-
 net/ipv6/addrconf.c                                |    2 +-
 net/ipv6/af_inet6.c                                |    1 +
 net/ipv6/anycast.c                                 |   29 -
 net/ipv6/datagram.c                                |    2 +-
 net/ipv6/icmp.c                                    |    4 +
 net/ipv6/ip6_fib.c                                 |   19 +-
 net/ipv6/ip6_output.c                              |   21 +-
 net/ipv6/ipv6_sockglue.c                           |   38 +
 net/ipv6/ndisc.c                                   |   30 +-
 net/ipv6/netfilter/Kconfig                         |    9 -
 net/ipv6/netfilter/Makefile                        |    1 -
 net/ipv6/netfilter/ip6t_LOG.c                      |  527 -
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |   60 +-
 net/ipv6/raw.c                                     |    2 +
 net/ipv6/reassembly.c                              |    7 +-
 net/ipv6/route.c                                   |   15 +-
 net/ipv6/sit.c                                     |   20 +-
 net/ipv6/tcp_ipv6.c                                |  231 +-
 net/ipv6/udp.c                                     |    7 +-
 net/ipv6/xfrm6_output.c                            |    2 +-
 net/irda/irnet/irnet.h                             |    2 +-
 net/iucv/af_iucv.c                                 |  381 +-
 net/l2tp/l2tp_eth.c                                |    2 +-
 net/l2tp/l2tp_ppp.c                                |    4 +-
 net/mac80211/Makefile                              |    4 +-
 net/mac80211/cfg.c                                 |  241 +-
 net/mac80211/chan.c                                |   55 +-
 net/mac80211/debugfs.c                             |   87 +-
 net/mac80211/debugfs_netdev.c                      |  115 +-
 net/mac80211/debugfs_sta.c                         |    5 +-
 net/mac80211/driver-ops.h                          |   68 +-
 net/mac80211/driver-trace.h                        |   77 +-
 net/mac80211/ibss.c                                |  109 +-
 net/mac80211/ieee80211_i.h                         |  173 +-
 net/mac80211/iface.c                               |   24 +-
 net/mac80211/key.c                                 |   39 +-
 net/mac80211/main.c                                |   27 +-
 net/mac80211/mesh.c                                |    2 +-
 net/mac80211/mesh.h                                |    5 +-
 net/mac80211/mesh_hwmp.c                           |   57 +-
 net/mac80211/mesh_pathtbl.c                        |   40 +-
 net/mac80211/mesh_plink.c                          |   23 +-
 net/mac80211/mlme.c                                | 1714 +-
 net/mac80211/pm.c                                  |   11 +-
 net/mac80211/rate.c                                |  151 +-
 net/mac80211/rate.h                                |    4 -
 net/mac80211/rc80211_minstrel_ht.c                 |   16 +
 net/mac80211/rx.c                                  |  123 +-
 net/mac80211/scan.c                                |   74 +-
 net/mac80211/sta_info.c                            |  341 +-
 net/mac80211/sta_info.h                            |   61 +-
 net/mac80211/status.c                              |   10 +-
 net/mac80211/tx.c                                  |   47 +-
 net/mac80211/util.c                                |   80 +-
 net/mac80211/wep.c                                 |   21 +-
 net/mac80211/wep.h                                 |    1 -
 net/mac80211/work.c                                |  814 -
 net/mac80211/wpa.c                                 |   22 +-
 net/netfilter/Kconfig                              |   30 +
 net/netfilter/Makefile                             |    3 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |    4 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |    4 +-
 net/netfilter/ipset/ip_set_bitmap_port.c           |    4 +-
 net/netfilter/ipset/ip_set_core.c                  |   26 +-
 net/netfilter/ipset/ip_set_getport.c               |    4 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |   18 +-
 net/netfilter/ipset/ip_set_hash_ipport.c           |   10 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c         |   10 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |  147 +-
 net/netfilter/ipset/ip_set_hash_net.c              |   89 +-
 net/netfilter/ipset/ip_set_hash_netiface.c         |   84 +-
 net/netfilter/ipset/ip_set_hash_netport.c          |  150 +-
 net/netfilter/ipset/ip_set_list_set.c              |    2 +-
 net/netfilter/nf_conntrack_core.c                  |   34 +-
 net/netfilter/nf_conntrack_ecache.c                |   55 +-
 net/netfilter/nf_conntrack_helper.c                |   54 +
 net/netfilter/nf_conntrack_netlink.c               |  218 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |   86 +-
 net/netfilter/nf_conntrack_proto_generic.c         |   77 +-
 net/netfilter/nf_conntrack_proto_gre.c             |   82 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   83 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |  168 +-
 net/netfilter/nf_conntrack_proto_udp.c             |  106 +-
 net/netfilter/nf_conntrack_proto_udplite.c         |  103 +-
 net/netfilter/nf_conntrack_timeout.c               |   60 +
 net/netfilter/nfnetlink_acct.c                     |    6 +-
 net/netfilter/nfnetlink_cttimeout.c                |  429 +
 net/netfilter/xt_CT.c                              |  220 +-
 net/netfilter/xt_LOG.c                             |  925 +
 net/netlink/af_netlink.c                           |   30 +-
 net/netlink/genetlink.c                            |   40 +-
 net/nfc/af_nfc.c                                   |    2 +-
 net/nfc/core.c                                     |   55 +-
 net/nfc/llcp/commands.c                            |  163 +-
 net/nfc/llcp/llcp.c                                |  201 +-
 net/nfc/llcp/llcp.h                                |   12 +-
 net/nfc/llcp/sock.c                                |  120 +-
 net/nfc/nci/core.c                                 |  209 +-
 net/nfc/nci/data.c                                 |   32 +-
 net/nfc/nci/ntf.c                                  |  360 +-
 net/nfc/nci/rsp.c                                  |   41 +-
 net/nfc/netlink.c                                  |   73 +-
 net/nfc/nfc.h                                      |   18 +-
 net/nfc/rawsock.c                                  |   28 +-
 net/openvswitch/vport-internal_dev.c               |    3 +-
 net/packet/af_packet.c                             |   32 +-
 net/rds/send.c                                     |    1 -
 net/sched/Kconfig                                  |   26 +
 net/sched/Makefile                                 |    1 +
 net/sched/sch_plug.c                               |  233 +
 net/sctp/socket.c                                  |   24 +-
 net/socket.c                                       |   36 +-
 net/tipc/bcast.c                                   |  336 +-
 net/tipc/bcast.h                                   |    2 +-
 net/tipc/bearer.c                                  |    5 +-
 net/tipc/config.c                                  |   21 +-
 net/tipc/core.c                                    |   10 -
 net/tipc/core.h                                    |   42 -
 net/tipc/discover.c                                |   79 +-
 net/tipc/link.c                                    |  299 +-
 net/tipc/log.c                                     |    2 +-
 net/tipc/msg.c                                     |    2 +-
 net/tipc/msg.h                                     |   15 +-
 net/tipc/name_distr.c                              |    8 +-
 net/tipc/name_table.c                              |   48 +-
 net/tipc/name_table.h                              |    2 -
 net/tipc/net.c                                     |   11 +-
 net/tipc/node.c                                    |   84 +-
 net/tipc/node.h                                    |   37 +-
 net/tipc/port.c                                    |   72 +-
 net/tipc/port.h                                    |   42 +-
 net/tipc/socket.c                                  |   11 +-
 net/tipc/subscr.c                                  |    2 +-
 net/unix/af_unix.c                                 |   52 +-
 net/unix/diag.c                                    |   10 +-
 net/wireless/core.h                                |   14 +-
 net/wireless/mesh.c                                |    4 +
 net/wireless/mlme.c                                |  333 +-
 net/wireless/nl80211.c                             |  397 +-
 net/wireless/nl80211.h                             |    3 +-
 net/wireless/reg.c                                 |   19 +-
 net/wireless/scan.c                                |   19 +-
 net/wireless/sme.c                                 |   41 +-
 net/wireless/util.c                                |    1 +
 net/wireless/wext-sme.c                            |    3 +
 net/xfrm/xfrm_user.c                               |    9 +-
 1690 files changed, 126263 insertions(+), 98973 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/stmmac.txt
 create mode 100644 Documentation/networking/mac80211-auth-assoc-deauth.txt
 create mode 100644 arch/mips/bcm47xx/sprom.c
 create mode 100644 drivers/net/can/sja1000/peak_pcmcia.c
 create mode 100644 drivers/net/can/usb/peak_usb/Makefile
 create mode 100644 drivers/net/can/usb/peak_usb/pcan_usb.c
 create mode 100644 drivers/net/can/usb/peak_usb/pcan_usb_core.c
 create mode 100644 drivers/net/can/usb/peak_usb/pcan_usb_core.h
 create mode 100644 drivers/net/can/usb/peak_usb/pcan_usb_pro.c
 create mode 100644 drivers/net/can/usb/peak_usb/pcan_usb_pro.h
 delete mode 100644 drivers/net/ethernet/ibm/iseries_veth.c
 rename drivers/net/ethernet/intel/e1000e/{lib.c => mac.c} (62%)
 create mode 100644 drivers/net/ethernet/intel/e1000e/manage.c
 create mode 100644 drivers/net/ethernet/intel/e1000e/nvm.c
 create mode 100644 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
 create mode 100644 drivers/net/ethernet/nxp/Kconfig
 create mode 100644 drivers/net/ethernet/nxp/Makefile
 create mode 100644 drivers/net/ethernet/nxp/lpc_eth.c
 delete mode 100644 drivers/net/ethernet/sfc/mac.h
 create mode 100644 drivers/net/ethernet/sfc/mcdi_mon.c
 create mode 100644 drivers/net/ethernet/sfc/siena_sriov.c
 create mode 100644 drivers/net/ethernet/sfc/vfdi.h
 create mode 100644 drivers/net/ethernet/ti/cpsw.c
 create mode 100644 drivers/net/ethernet/ti/cpsw_ale.c
 create mode 100644 drivers/net/ethernet/ti/cpsw_ale.h
 create mode 100644 drivers/net/ethernet/xilinx/xilinx_axienet.h
 create mode 100644 drivers/net/ethernet/xilinx/xilinx_axienet_main.c
 create mode 100644 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
 create mode 100644 drivers/net/phy/amd.c
 create mode 100644 drivers/net/usb/qmi_wwan.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/core.c
 create mode 100644 drivers/net/wireless/ath/ath6kl/usb.c
 delete mode 100644 drivers/net/wireless/ath/ath9k/ar9462_1p0_initvals.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/usb.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/usb.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/usb_rdl.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-bus.h
 rename drivers/net/wireless/iwlwifi/{iwl-trans.c => iwl-debug.c} (68%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-drv.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-drv.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-fw-file.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-fw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-notif-wait.c
 rename drivers/net/wireless/iwlwifi/{iwl-wifi.h => iwl-notif-wait.h} (55%)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-op-mode.h
 create mode 100644 drivers/ptp/ptp_pch.c
 create mode 100644 include/linux/netfilter/nfnetlink_cttimeout.h
 create mode 100644 include/linux/netfilter/xt_LOG.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_SAME.h
 delete mode 100644 include/linux/netfilter_ipv4/ipt_realm.h
 create mode 100644 include/linux/platform_data/cpsw.h
 create mode 100644 include/linux/ppp-ioctl.h
 create mode 100644 include/net/bluetooth/hci_mon.h
 create mode 100644 include/net/netfilter/nf_conntrack_timeout.h
 rename net/batman-adv/{bat_ogm.h => bat_algo.h} (51%)
 delete mode 100644 net/ipv4/netfilter/ipt_LOG.c
 delete mode 100644 net/ipv6/netfilter/ip6t_LOG.c
 create mode 100644 net/netfilter/nf_conntrack_timeout.c
 create mode 100644 net/netfilter/nfnetlink_cttimeout.c
 create mode 100644 net/netfilter/xt_LOG.c
 create mode 100644 net/sched/sch_plug.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
