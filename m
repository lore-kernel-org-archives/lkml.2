Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1CPVWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:22:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36082
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab1CPVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:21:17 -0400
Date: Wed, 16 Mar 2011 14:21:51 -0700 (PDT)
Message-Id: <20110316.142151.212683519.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2GLMegG005890


I just did a test merge of this work into your tree and it went without
any conflicts, so it should go easy for you too.

1) The long awaited addition of Jozsef Kadlecsik's totally awesome
   "ipset" to netfilter.

2) Several major changes to our routing infrastructure:

   a) Routing metrics are stored in inetpeer cache and are COW'able.

   b) PMTU and redirect information can be stored in the inetpeer
      cache as well.  IPV4 is fully converted over to this scheme.

      Changes 'a' and 'b' are significant because it paves the way
      to be able to legitimately remove the ipv4 routing cache once
      we can get the FIB backend efficient enough.

   c) Route flow lookup keys and compacted, and optimized for the
      individual address families.  On ipv4 this means the (often
      on-stack) flow keys are 32 bytes in size, instead of the
      whopping 60 bytes they used to be.

   d) Instead of returning an error code, and writing the resulting
      route entry pointer on the callers stack by reference, we
      return error encoded pointers instead.

   e) We had two ipv4 routing table lookup algorithms, selected
      at compile time, one based upon a set of hash tables and
      another based upon the LC-trie data structure.  After many
      years it is time to stop having two sets of code to update
      when fixes or API changes take place, and settle on the
      LC-trie.  fib_hash has therefore been completely removed.

   f) Several optimizations to the slow paths of IPV4 routing lookups,
      in particular caching of per-nexthop source address selection
      values in the FIB table entries.

   g) The routing cache entry data structure, struct rtable, has
      been completely stripped of extraneous and unnecessary members.

3) The initial TCP congestion window is increased to 10, as per
   draft-hkchu-tcpm-initcwnd-01

4) Multi-threaded sending on UDP sockets are significantly improved
   by eliminating the use of shared socket state in the non-cork
   cases of I/O.  From Herbert Xu.

5) Several fixes to the Hystart mechanism of CUBIC TCP congestion
   control.  From Stephem Hemminger, Sangtae Ha, and Lucas Nussbaum.

6) Many cleanups and improvements to IPVS support in netfilter from
   Simon Horman, Julian Anastasov, and many others.

7) Add the XEN network backend driver, from Ian Campbell.

8) Numerous cleanups, simplifications, and fixes to the TIPC stack
   from Allan Stephens and Paul Gortmaker.

9) Support for extended sequence numbers in IPSEC, from Steffen
   Klassert.

10) Socket filters can now be used with AF_UNIX sockets.  From
    Alban Crequy.

11) Socket filter running no longer blocks softirqs, as they are fully
    re-entrant and lock-less.  From Eric Dumazet.

12) Support for network device groups, which allows manipulation of
    settings on a group basis, from Vlad Dogaru.

13) Add HW based qos support, in that we can now use the skb->priority
    field to steer packets to individual HW TX queues.  From John
    Fastabend.

14) Convert PPP away from direct SKB list implementation details as
    much as possible, with much help from Paul Mackerras.

15) RPS can now be accelerated directly in hardware, thanks to
    Ben Hutchings.

16) New packet schedulers, CHOKe and SFB, From Stephen Hemminger and
    Eric Dumazet.

17) Consolidation of how bonding binds master and slave devices, as well	
    as how RX packet processing works.  From Jiri Pirko and others.

18) Harmonization of network device checksum offload setting
    management, from Micha≈Ç Miros≈Çaw.

19) Support correlated packet loss support to the network emulator
    packet scheduler, from Stephen Hemminger and based upon work done
    by Stefano Salsano and Fabio Ludovici.

20) An entry in the ip_tos2prio[] table has been wrong for ~8 years :-)
    Thanks to Dan Siemon and Eric Dumazet.

21) As usual the wired and wireless developers have been busy little
    bees fixing bugs, improving performance, and adding new features.
    See the changelog for details.

Please pull, thanks a lot.

The following changes since commit 76ca07832842100b14a31ad8996dab7b0c28aa42:

  Merge branch 'for-linus' of git://xenbits.xen.org/people/sstabellini/linux-pvhvm (2011-03-15 10:59:09 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-next-2.6.git master

Ajit Khaparde (23):
      be2net: While configuring QOS for VF, pass proper domain id
      be2net: endianness fix in be_cmd_set_qos().
      be2net: Use domain id when be_cmd_if_destroy is called.
      be2net: Initialize and cleanup sriov resources only if pci_enable_sriov has succeeded.
      be2net: call be_vf_eth_addr_config() after register_netdev
      be2net: Cleanup the VF interface handles
      be2net: For the VF MAC, use the OUI from current MAC address
      be2net: pass domain numbers for pmac_add/del functions
      be2net: Allow VFs to call be_cmd_reset_function.
      be2net: Fix broken priority setting when vlan tagging is enabled.
      be2net: pass proper hdr_size while flashing redboot.
      be2net: fix be_suspend/resume/shutdown
      be2net: gracefully handle situations when UE is detected
      be2net: detect a UE even when a interface is down.
      be2net: restrict WOL to PFs only.
      be2net: add new counters to display via ethtool stats
      be2net: fixes in ethtool selftest
      be2net: variable name change
      be2net: fix to ignore transparent vlan ids wrongly indicated by NIC
      be2net: add code to display temperature of ASIC
      be2net: use hba_port_num instead of port_num
      be2net: Copyright notice change. Update to Emulex instead of ServerEngines
      be2net: Bump up the version number

Alban Crequy (2):
      af_unix: implement socket filter
      af_unix: coding style: remove one level of indentation in unix_shutdown()

Alessio Igor Bogani (2):
      rtlwifi: Add the missing rcu_read_lock/unlock
      rtlwifi: fix places where uninitialized data is used

Alexander Duyck (1):
      ixgbe: balance free_irq calls with request_irq calls

Allan Stephens (42):
      tipc: Combine port structure with tipc_port structure
      tipc: Combine bearer structure with tipc_bearer structure
      tipc: Remove unused global variable tipc_user_count
      tipc: Prevent invalid memory access when sending to configuration service
      tipc: Improve handling of invalid link tolerance values
      tipc: Fix print statements that assume pointers are 32-bit values
      tipc: Clean out all remaining instances of #if 0'd unused code
      tipc: Clean up tracking of node requesting a broadcast retransmit
      tipc: Eliminate unnecessary locking when starting topology service
      tipc: Improve accuracy of link transmit queue maximum size statistic
      tipc: Set unused probe field of link protocol messages to defined value
      tipc: Minor optimization to topology service connection establishment
      tipc: Fix port counter handling to correct congestion control
      tipc: Add in missing lock during link initialization
      tipc: Remove support for per-connection message sequence numbering
      tipc: Remove unused message header field for requested number of links
      tipc: Avoid reliable broadcast preparation for NACK messages
      tipc: Allow receiving into iovec containing multiple entries
      tipc: Correct broadcast link peer info when displaying links
      tipc: Add network address mask helper routines
      tipc: Prevent null pointer error when removing a node subscription
      tipc: Cosmetic changes to node subscription code
      tipc: Add support for SO_RCVTIMEO socket option
      tipc: Fix problem with missing link in "tipc-config -l" output
      tipc: Split up unified structure of network-related variables
      tipc: Eliminate configuration for maximum number of cluster nodes
      tipc: Convert node object array to a hash table
      tipc: manually inline net_start/stop, make assoc. vars static
      tipc: Eliminate timestamp from link protocol messages
      tipc: make msg_set_redundant_link() consistent with other set ops
      tipc: Fix redundant link field handling in link protocol message
      tipc: Cosmetic changes to neighbor discovery logic
      tipc: Give Tx of discovery responses priority over link messages
      tipc: Optimizations to link creation code
      tipc: Correct misnamed references to neighbor discovery domain
      tipc: Remove unused field in bearer structure
      tipc: Eliminate unnecessary constant for neighbor discovery msg size
      tipc: Don't respond to neighbor discovery request on blocked bearer
      tipc: Remove bearer flag indicating existence of broadcast address
      tipc: Eliminate remaining support for routing table messages
      tipc: Eliminate obsolete routine for handling routed messages
      tipc: Update maintenance information

Amerigo Wang (5):
      bonding: sync netpoll code with bridge
      netpoll: remove IFF_IN_NETPOLL flag
      bond: service netpoll arp queue on master device
      bonding: use the correct size for _simple_hash()
      bonding: move procfs code into bond_procfs.c

Anand Gadiyar (2):
      Bluetooth: fix build break on hci_sock.c
      Bluetooth: remove unnecessary call to hci_sock_cleanup

Anders Berggren (2):
      net: TX timestamps for IPv6 UDP packets
      igb: fix hw timestamping

Anderson Briglia (1):
      Bluetooth: Fix LE conn creation

Andrei Emeltchenko (3):
      Bluetooth: Use non-flushable by default L2CAP data packets
      Bluetooth: Do not use assignments in IF conditions
      Bluetooth: fix crash by disabling tasklet in sock accept

Andrei Warkentin (1):
      Bluetooth: Make hci a child of the corresponding tty device.

Andy Gospodarek (2):
      ixgbe: fix compile failure in ixgbe_init_mbx_params_pf
      bonding: enable netpoll without checking link status

Ariel Elior (1):
      bnx2x: fix swap of rx-ticks and tx-ticks parameters in interrupt coalescing flow

Arik Nemtsov (33):
      wl12xx: Add AP related configuration to conf_drv_settings
      wl12xx: AP mode - AP specific CMD_CONFIGURE sub-commands
      wl12xx: AP mode - add AP specific event
      wl12xx: AP-mode high level commands
      wl12xx: AP mode - workaround for FW bug on station remove
      wl12xx: AP mode - init sequence
      wl12xx: AP specific RX filter configuration
      wl12xx: Add AP related definitions to HOST-FW interface
      wl12xx: Configure AP on BSS info change
      wl12xx: AP mode config in ieee80211_ops.config
      wl12xx: AP mode - change filter config
      wl12xx: AP mode - add STA add/remove ops
      wl12xx: AP mode - changes in TX path
      wl12xx: AP mode - record TX configuration settings
      wl12xx: AP mode - encryption support
      wl12xx: AP mode - fetch appropriate firmware for AP
      wl12xx: Read MAC address from NVS file on HW startup
      wl12xx: Enable AP-mode
      wl12xx: add missing MODULE_FIRMWARE statment for AP-mode FW
      wl12xx: Add channel 14 to list of supported 2ghz channels
      mac80211: do not calc frame duration when using HW rate-control
      mac80211: add HW flag for disabling auto link-PS in AP mode
      mac80211: pass up beacons from external BSS when operating as AP
      wl12xx: avoid blocking while holding rcu lock on bss info change
      wl12xx: fix potential race condition with TX queue watermark
      wl12xx: AP-mode - fix race condition on sta connection
      wl12xx: AP-mode - TX queue per link in AC
      wl12xx: report invalid TX rate when returning non-TX-ed skbs
      wl12xx: AP-mode - support HW based link PS monitoring
      wl12xx: AP mode - fix bug in cleanup of wl1271_op_sta_add()
      wl12xx: AP-mode - count free FW TX blocks per link
      wl12xx: AP-mode - management of links in PS-mode
      wl12xx: wakeup chip from ELP during scan

Atita Shirwaikar (1):
      ixgbe: Adding 100MB FULL support in ethtool

Bala Shanmugam (1):
      Bluetooth: Add firmware support for Atheros 3012

Baruch Siach (1):
      phy/micrel: add ability to support 50MHz RMII clock on KZS8051RNL

Ben Dooks (1):
      DM9000: Allow randomised ethernet address

Ben Greear (32):
      mac80211: Show max retry-counts in kernel messages.
      ath9k: Fix up hardware mode and beacons with multiple vifs.
      mac80211: Fix skb-copy failure debug message.
      ath9k: Show some live tx-queue values in debugfs.
      ath9k: Initialize ah->hw
      ath9k: Add more information to debugfs xmit file.
      ath9k: Remove un-used member from ath_node.
      ath9k: Ensure xmit makes progress.
      ath9k: Add counters to distinquish AMPDU enqueues.
      ath9k: Keep track of stations for debugfs.
      ath9k: More xmit queue debugfs information.
      ath9k: Restart xmit logic in xmit watchdog.
      ath9k: Add 'misc' file to debugfs, fix queue indexes.
      ath9k: Try more than one queue when scheduling new aggregate.
      mac80211: Add sdata state and flags to debugfs.
      mac80211: Be more careful when changing channels.
      mac80211: Show configured channel-type in netdev debugfs.
      mac80211: Warn users if HT fails because of freq mismatch.
      ath9k: Show channel type and frequency in debugfs.
      mac80211: Recalculate channel-type on iface removal.
      mac80211: Optimize scans on current operating channel.
      mac80211: Make some mlme timers module paramaters.
      ath9k: Print channel-type in chan-change dbg message.
      mac80211: Properly set work-item channel-type.
      mac80211: Allow scanning on existing channel-type.
      mac80211: Allow work items to use existing channel type.
      ath9k: Add debug info for configuring power level.
      mac80211: Ensure power-level set properly for scanning.
      network: Allow af_packet to transmit +4 bytes for VLAN packets.
      mac80211: Add power to debugfs.
      ath9k: Fix txq memory address printing in debugfs.
      ath5k: Put hardware in PROMISC mode if there is more than 1 stations.

Ben Hutchings (18):
      genirq: Add IRQ affinity notifiers
      lib: cpu_rmap: CPU affinity reverse-mapping
      net: RPS: Enable hardware acceleration of RFS
      sch_mqprio: Always set num_tc to 0 in mqprio_destroy()
      net: Adjust TX queue kobjects if number of queues changes during unregister
      sfc: Move TX queue core queue mapping into tx.c
      sfc: Distinguish queue lookup from test for queue existence
      sfc: Add TX queues for high-priority traffic
      net: RPS: Make hardware-accelerated RFS conditional on NETIF_F_NTUPLE
      sfc: Limit filter search depth further for performance hints (i.e. RFS)
      sfc: Implement hardware acceleration of RFS
      sfc: Read MC firmware version when requested through ethtool
      sfc: Do not read STAT1.FAULT in efx_mdio_check_mmd()
      sfc: Update copyright dates
      sfc: Expose TX push and TSO counters through ethtool statistics
      sfc: Remove configurable FIFO thresholds for pause frame generation
      sfc: Bump version to 3.1
      sfc: Use write-combining to reduce TX latency

Bernard Pidoux (2):
      ROSE: rose AX25 packet routing improvement
      ROSE: AX25: finding routes simplification

Bhupesh Sharma (1):
      can: c_can: Added support for Bosch C_CAN controller

Bing Zhao (1):
      ieee80211: add IEEE80211_COUNTRY_STRING_LEN definition

Bob Copeland (3):
      ath5k: use tracing for packet tx/rx dump
      ath5k: remove debug_dump_skb() functions
      ath5k: move external function definitions to a header file

Bruce Allan (13):
      e1000e: reduce scope of some variables, remove unnecessary ones
      e1000e: Use kmemdup rather than duplicating its implementation
      e1000e: replace unbounded sprintf with snprintf
      e1000e: use correct pointer when memcpy'ing a 2-dimensional array
      e1000e: return appropriate errors for 'ethtool -r'
      e1000e: use dev_kfree_skb_irq() instead of dev_kfree_skb()
      e1000e: magic number cleanup - ETH_ALEN
      e1000e: extend timeout for ethtool link test diagnostic
      e1000e: extend EEE LPI timer to prevent dropped link
      e1000e: do not toggle LANPHYPC value bit when PHY reset is blocked
      e1000e: disable jumbo frames on 82579 when MACsec enabled in EEPROM
      e1000e: do not suggest the driver supports Wake-on-ARP
      e1000e: bump version number

Bruno Randolf (14):
      cfg80211: Extend channel to frequency mapping for 802.11j
      ath5k: Use mac80211 channel mapping function
      ath5k: Rename ath5k_copy_channels
      ath5k: Add 802.11j 4.9GHz channels to allowed channels
      ath5: Remove unused CTL definitions
      ath5k: Remove unused sc->curmode
      ath5k: Remove redundant sc->curband
      ath5k: Simplify loop when setting up channels
      ath5k: ath5k_setup_channels cleanup and whitespace
      ath5k: Use local variable for capabilities
      ath: Add function to check if 4.9GHz channels are allowed
      ath5k: Enable 802.11j 4.9GHz frequencies
      ath9k: Remove unused IEEE80211_WEP_NKID
      ath5k: Fix short and long retry configuration

Carolyn Wyborny (12):
      igb: Add support for i340 Quad Port Fiber Adapter
      igb: Enable PF side of SR-IOV support for i350 devices
      igb: Update Intel copyright notice for driver source.
      igb: update version string
      igb: Fix reg pattern test in ethtool for i350 devices
      igb: Fix strncpy calls to be safe per source code review tools
      igb: Add stats output for OS2BMC feature on i350 devices
      igb: Add Energy Efficient Ethernet (EEE) for i350 devices.
      igb: Update NVM functions to work with i350 devices
      igb: Add DMA Coalescing feature to driver
      igb: Bump version to 3.0.6
      igb: Add messaging for thermal sensor events on i350 devices

Changli Gao (22):
      netfilter: nf_conntrack: don't always initialize ct->proto
      netfilter: xt_NFQUEUE: remove modulo operations
      netfilter: ct_extend: fix the wrong alloc_size
      netfilter: nf_conntrack: define ct_*_info as needed
      netfilter: nf_nat: don't use atomic bit operation
      netfilter: ct_extend: define NF_CT_EXT_* as needed
      netfilter: nf_nat: define nat_pptp_info as needed
      netfilter: nf_nat: fix conversion to non-atomic bit ops
      netfilter: nf_conntrack: remove an atomic bit operation
      netfilter: nf_nat: place conntrack in source hash after SNAT is done
      netfilter: ipvs: fix compiler warnings
      netfilter: ipvs: fix compiler warnings
      ipvs: use hlist instead of list
      ipvs: use enum to instead of magic numbers
      ipvs: unify the formula to estimate the overhead of processing connections
      llc: avoid skb_clone() if there is only one handler
      bonding: remove the unused dummy functions when net poll controller isn't enabled
      bonding: COW before overwriting the destination MAC address
      netfilter: xt_connlimit: fix daddr connlimit in SNAT scenario
      netfilter: xt_connlimit: use kmalloc() instead of kzalloc()
      netfilter: xt_connlimit: use hlist instead
      netfilter: xt_connlimit: remove connlimit_rnd_inited

Chaoming Li (1):
      rtlwifi: Fix error registering rate-control

Christian Lamparter (11):
      carl9170: update fw/hw headers
      carl9170: enable wake-on-lan feature testing
      carl9170: utilize fw seq counter for mgmt/non-QoS data frames
      mac80211: fix race between next beacon dtim and ieee80211_get_buffered_bc
      p54: sort channel list by frequency instead of channel index
      p54: p54_generate_band cleanup
      p54: enhance rssi->dBm database import
      p54spi: update sample eeprom
      p54: implement flush callback
      ar9170usb: mark the old driver as obsolete
      p54: implement set_coverage_class

Claudio Takahasi (3):
      Bluetooth: Add LE signaling commands handling
      Bluetooth: Add connection parameter update response
      Bluetooth: Send LE Connection Update Command

Dan Carpenter (6):
      wl12xx: use after free in debug code
      IPVS: precedence bug in ip_vs_sync_switch_mode()
      mac80211: remove unneeded check
      wl12xx: change type from u8 to int
      iwlwifi: remove duplicate initialization
      libertas: fix write past end of array in mesh_id_get()

Dan Siemon (1):
      net_sched: fix ip_tos2prio

Daniel Baluta (1):
      af_unix: update locking comment

Daniel Halperin (1):
      mac80211: update minstrel_ht sample rate when probe is set

Daniel Lezcano (1):
      macvlan : fix checksums error when we are in bridge mode

Daniel Turull (1):
      pktgen: bug fix in transmission headers with frags=0

David Gnedt (6):
      wl1251: fix queue stopping/waking for TX path
      wl1251: fix 4-byte TX buffer alignment
      wl1251: enable beacon early termination while in power-saving mode
      wl1251: implement connection quality monitoring
      wl1251: enable adhoc mode
      wl1251: set rate index and preamble flag on received packets

David S. Miller (204):
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      ppp: Clean up kernel log messages.
      ppp: Reconstruct fragmented packets using frag lists instead of copying.
      net: Add safe reverse SKB queue walkers.
      ppp: Use SKB queue abstraction interfaces in fragment processing.
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'irq/numa' of git://git.kernel.org/.../tip/linux-2.6-tip
      typhoon: Kill references to UTS_RELEASE
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Implement read-only protection and COW'ing of metrics.
      inetpeer: Add metrics storage to inetpeer entries.
      inetpeer: Mark metrics as "new" in fresh inetpeer entries.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      net: Store ipv4/ipv6 COW'd metrics in inetpeer cache.
      Merge branch 'master' of ssh://master.kernel.org/.../linville/wireless-next-2.6
      net: Pre-COW metrics for TCP.
      ipv4: Allocate fib metrics dynamically.
      ipv4: Attach FIB info to dst_default_metrics when possible
      ipv4: If fib metrics are default, no need to grab ref to FIB info.
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/ecsv/linux-merge
      ipv4: Remember FIB alias list head and table in lookup results.
      ipv4: Consolidate all default route selection implementations.
      ipv4: Remove fib_hash.
      ipv4: Update some fib_hash centric interface names.
      ipv4: Rename fib_hash_* locals in fib_semantics.c
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      tcp: Increase the initial congestion window to 10.
      ipv4: Fix fib_trie build in some configurations.
      sch_choke: Need linux/vmalloc.h
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ipv4: Don't miss existing cached metrics in new routes.
      inetpeer: Move ICMP rate limiting state into inet_peer entries.
      tcp: Add reference to initial CWND ietf draft.
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6
      net: Remove bogus barrier() in dst_allfrag().
      net: Kill NETEVENT_PMTU_UPDATE.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      inetpeer: Abstract address representation further.
      inetpeer: Add redirect and PMTU discovery cached info.
      inet: Create a mechanism for upward inetpeer propagation into routes.
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/ecsv/linux-merge
      ipv4: Cache learned PMTU information in inetpeer.
      ipv4: Cache learned redirect information in inetpeer.
      Merge branch 'fec' of git://git.pengutronix.de/git/ukl/linux-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next-2.6
      ipv4: Simplify output route creation call sequence.
      ipv4: Move rcu_read_{lock,unlock}() into ip_route_output_slow().
      ipv4: Consolidate ipv4 dst allocation logic.
      net: Add initial_ref arg to dst_alloc().
      ipv4: Avoid use of signed integers in fib_trie code.
      ipv4: Mark fib_combine_itag()'s 'res' arg as const.
      ipv4: Use const'ify fib_result deep in the route call chains.
      ipv4: Add hash table of interface addresses.
      ipv4: Implement __ip_dev_find using new interface address hash.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'fec' of git://git.pengutronix.de/git/ukl/linux-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next-2.6
      Merge branch 'net/ax88796' of git://git.pengutronix.de/git/mkl/linux-2.6
      xfrm: Mark flowi arg const in key extraction helpers.
      xfrm: Mark flowi arg to ->get_tos() const.
      xfrm: Mark flowi arg to ->fill_dst() const.
      xfrm: Mark flowi arg to ->init_tempsel() const.
      xfrm: Mark flowi arg to xfrm_type->reject() const.
      xfrm: Mark token args to addr_match() const.
      xfrm: Mark flowi arg to xfrm_selector_match() const.
      xfrm: Mark flowi arg to security_xfrm_state_pol_flow_match() const.
      xfrm: Mark flowi arg to xfrm_state_look_at() const.
      xfrm: Mark flowi arg to xfrm_init_tempstate() const.
      xfrm: Mark flowi arg to xfrm_state_find() const.
      net: Mark flowi arg to flow_cache_uli_match() const.
      xfrm: Kill strict arg to xfrm_bundle_ok().
      xfrm: Mark flowi arg to xfrm_policy_{lookup_by_type,match}() const.
      xfrm: Mark flowi arg to xfrm_expand_policies() const.
      xfrm: Mark flowi arg to xfrm_tmpl_resolve{,_one}() const.
      xfrm: Mark flowi arg to xfrm_bundle_create() const.
      xfrm: Mark flowi arg to xfrm_dst_{alloc_copy,update_origin}() const.
      xfrm: Mark flowi arg to xfrm_resolve_and_create_bundle() const.
      net: Make flow cache paths use a const struct flowi.
      Merge branch 'tipc-Feb23-2011' of git://git.kernel.org/.../paulg/net-next-2.6
      xfrm: Pass km_event pointers around as const when possible.
      xfrm: Const'ify tmpl and address arguments to ->init_temprop()
      xfrm: Const'ify selector argument to xfrm_selector_match()
      xfrm: Const'ify address arguments to ->dst_lookup()
      xfrm: Const'ify address arguments to __xfrm_dst_lookup()
      xfrm: Const'ify address arguments to xfrm_addr_cmp()
      xfrm: Const'ify address argument to xfrm_addr_any()
      xfrm: Const'ify pointer args to migrate_tmpl_match and xfrm_migrate_check
      xfrm: Const'ify pointer args to km_migrate() and implementations.
      xfrm: Const'ify address args to hash helpers.
      xfrm: Const'ify selector args in xfrm_migrate paths.
      xfrm: Const'ify local xfrm_address_t pointers in xfrm_policy_lookup_bytype.
      xfrm: Const'ify policy arg and local selector in xfrm_policy_match.
      xfrm: Const'ify policy arg to xp_net.
      xfrm: Const'ify policy arg to clone_policy.
      xfrm: Const'ify selector arg to xfrm_dst_update_parent.
      xfrm: Const'ify xfrm_tmpl and xfrm_state args to xfrm_state_addr_cmp.
      xfrm: Const'ify ptr args to xfrm_state_*_check and xfrm_state_kern.
      xfrm: Const'ify ptr args to xfrm_state_ok.
      xfrm: Const'ify ptr args to xfrm_policy_ok.
      xfrm: Const'ify sec_path arg to secpath_has_nontransport.
      xfrm: Const'ify xfrm_address_t args to xfrm_*_hash.
      xfrm: Const'ify xfrm_tmpl arg to xfrm_init_tempstate.
      xfrm: Const'ify xfrm_address_t args to __xfrm_state_lookup{,_byaddr}.
      xfrm: Remove unused 'saddr' and 'daddr' args to xfrm_state_look_at.
      xfrm: Const'ify xfrm_address_t args to xfrm_state_find.
      ipv4: Rearrange how ip_route_newports() gets port keys.
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      sch_netem: Need to include vmalloc.h
      rtlwifi: Need to include vmalloc.h
      phonet: Protect pipe_do_remove() with appropriate ifdefs.
      pfkey: Use const where possible.
      xfrm: Pass name as const to xfrm_*_get_byname().
      xfrm: Pass const arg to xfrm_alg_len and xfrm_alg_auth_len.
      xfrm: Pass const xfrm_address_t objects to xfrm_state_lookup* and xfrm_find_acq.
      xfrm: Pass const xfrm_mark to xfrm_mark_put().
      net: Forgot to commit net/core/dev.c part of Jiri's ->rx_handler patch.
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next-2.6
      ipv6: Consolidate route lookup sequences.
      ipv4: Can final ip_route_connect() arg to boolean "can_sleep".
      ipv4: Make final arg to ip_route_output_flow to be boolean "can_sleep"
      net: Add FLOWI_FLAG_CAN_SLEEP.
      ipv4: Kill can_sleep arg to ip_route_output_flow()
      ipv6: Change final dst lookup arg name to "can_sleep"
      xfrm: Kill XFRM_LOOKUP_WAIT flag.
      ipv6: Normalize arguments to ip6_dst_blackhole().
      xfrm: Handle blackhole route creation via afinfo.
      ipv4: Make icmp route lookup code a bit clearer.
      ipv6: Make icmp route lookup code a bit clearer.
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      xfrm: Return dst directly from xfrm_lookup()
      ipv4: Make output route lookup return rtable directly.
      ipv4: ip_route_output_key() is better as an inline.
      ipv4: Fix crash in dst_release when udp_sendmsg route lookup fails.
      ipv4: Fix __ip_dev_find() to use ifa_local instead of ifa_address.
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      ipv6: Use ERR_CAST in addrconf_dst_alloc.
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'for-davem' of ssh://master.kernel.org/.../linville/wireless-next-2.6
      ipv4: Optimize flow initialization in output route lookup.
      ipv4: Get peer more cheaply in rt_init_metrics().
      ipv4: Use passed-in protocol in ip_route_newports().
      ipv4: Set rt->rt_iif more sanely on output routes.
      ipv4: Remove flowi from struct rtable.
      Merge branch 'batman-adv/next' of git://git.open-mesh.org/ecsv/linux-merge
      ipv4: Validate route entry type at insert instead of every lookup.
      ipv4: Inline fib_semantic_match into check_leaf
      Merge branch 'davem-next.r8169' of git://git.kernel.org/.../romieu/netdev-2.6
      ipv4: Cache source address in nexthop entries.
      ipv4: Fix scope value used in route src-address caching.
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next-2.6
      inetpeer: Don't disable BH for initial fast RCU lookup.
      ipv4: Lookup multicast routes by rtable using helper.
      ipv4: Optimize flow initialization in input route lookup.
      ipv4: Optimize flow initialization in fib_validate_source().
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      ipv4: Remove redundant RCU locking in ip_check_mc().
      ipv4: Remove unnecessary test from ip_mkroute_input()
      ipv4: Kill flowi arg to fib_select_multipath()
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      ipv4: Create and use route lookup helpers.
      net: Remove unnecessary padding in struct flowi
      xfrm: Eliminate "fl" and "pol" args to xfrm_bundle_ok().
      net: Put flowi_* prefix on AF independent members of struct flowi
      net: Create struct flowi_common
      net: Create union flowi_uli
      net: Make flowi ports AF dependent.
      net: Break struct flowi out into AF specific instances.
      net: Add flowiX_to_flowi() shorthands.
      ipv4: Pass ipv4 flow objects into fib_lookup() paths.
      ipv4: Use struct flowi4 internally in routing lookups.
      ipv4: Use flowi4 in public route lookup interfaces.
      ipv4: Use flowi4 in FIB layer.
      ipv4: Use flowi4 in ipmr code.
      netfilter: Use flowi4 in nf_nat_standalone.c
      ipv4: Use flowi4 in UDP
      netfilter: Use flowi4 and flowi6 in nf_conntrack_h323_main
      netfilter: Use flowi4 and flowi6 in xt_TCPMSS
      net: Add flowi6_* member helper macros.
      net: Use flowi4 and flowi6 in xfrm layer.
      ipv4: Kill fib_semantic_match declaration from fib_lookup.h
      net: Put fl4_* macros to struct flowi4 and use them again.
      ipv6: Convert to use flowi6 where applicable.
      net: Put fl6_* macros to struct flowi6 and use them again.
      decnet: Convert to use flowidn where applicable.
      Merge branch 'tipc-Mar13-2011' of git://git.kernel.org/.../paulg/net-next-2.6
      Merge branch 'tipc-Mar14-2011' of git://git.kernel.org/.../paulg/net-next-2.6
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next-2.6
      Merge branch 'master' of master.kernel.org:/.../jkirsher/net-next-2.6
      Merge branch 'irq/numa' of git://git.kernel.org/.../tip/linux-2.6-tip
      Merge branch 'master' of master.kernel.org:/.../davem/net-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'stable/backends' of git://git.kernel.org/.../konrad/xen
      Merge branch 'master' of git://git.kernel.org/.../kaber/nf-next-2.6

Denis Kirjanov (1):
      sungem: Use net_device's internal stats

Dimitris Michailidis (1):
      cxgb{3,4}*: improve Kconfig dependencies

Domenico Andreoli (2):
      CS89x0: Finish transition to CS89x0_NONISA_IRQ
      CS89x0: Add networking support for QQ2440

Don Skidmore (7):
      ixgbe: fix namespace issue with ixgbe_dcb_txq_to_tc
      ixgbe: cleanup namespace complaint by removing little used function
      ixgbe: cleanup ixgbe_init_mbx_params_pf namespace issue
      ixgbe: cleanup X540 PHY reset function pointer
      ixgbe: add function pointer for semaphore function
      ixgbe: cleanup copyright string for 2011
      ixgbe: fix missing function pointer conversion

Eliad Peller (14):
      wl12xx: remove redundant debugfs_remove_recursive() call
      wl12xx: fix some sparse warnings
      wl12xx: don't join upon disassociation
      wl12xx: fix some endianess bugs
      wl12xx: wrong values are returned in gpio_power_write()
      wl12xx: disable auto-arp
      wl12xx: mcp2.5 - add config_ps acx
      wl12xx: move to new firmware (6.1.3.50.49)
      wl12xx: use the conf struct instead of macros for memory configuration
      wl12xx: set supported_rates after association
      wl12xx: fix identification of beacon packets (debug)
      wl12xx: declare support for IEEE80211_HW_REPORTS_TX_ACK_STATUS
      wl12xx: use standard ALIGN() macro
      wl12xx: always set mac_address when configuring ht caps

Emil Tantilov (28):
      ixgbe: cleanup wake on LAN defines
      ixgbe: cleanup logic related to HW semaphores
      ixgbe: set media type for 82599 T3 LOM
      ixgbe: Add ability to double reset on failure to clear master enable
      ixgbe: cleanup code in ixgbe_identify_sfp_module_generic
      ixgbe: Check link wants report current link state
      ixgbe: add polling test to end of PHY reset
      ixgbe: Fill out PCIe speed and width enums with values
      ixgbe: Bounds checking for set_rar, clear_rar, set_vmdq, clear_vmdq
      ixgbe: rework ixgbe MTA handling to not drop packets
      ixgbe: Drop unused code for setting up unicast addresses
      ixgbe: Specific check for 100 Full link speed
      ixgbe: Numerous whitespace / formatting cleanups
      ixgbe: store permanent address before initializing Rx addresses
      ixgbe: cleanup handling of I2C interface to PHY
      e1000e: fix build issue due to undefined reference to crc32_le
      ixgbe: cleanup PHY init
      ixgbe: clear correct counters for flow control on 82599
      ixgbe: Add x540 statistic counter definitions
      ixgbe: Enable flow control pause parameter auto-negotiation support
      ixgbe: add function description
      ixgbe: improve logic in ixgbe_init_mbx_params_pf
      ixgbe: fix spelling errors
      ixgbe: fix setting and reporting of advertised speeds
      ixgb: convert to new VLAN model
      ixgbe: remove timer reset to 0 on timeout
      ixgbe: update PHY code to support 100Mbps as well as 1G/10G
      ixgbe: correct typo in define name

Eric Dumazet (38):
      netfilter: add __rcu annotations
      netfilter: nf_ct_frag6_sysctl_table is static
      netfilter: add __rcu annotations
      netfilter: nf_nat_amanda: rename a variable
      netfilter: rcu sparse cleanups
      ipvs: add static and read_mostly attributes
      ipvs: remove shadow rt variable
      netfilter: nf_conntrack: one less atomic op in nf_ct_expect_insert()
      netfilter: x_table: speedup compat operations
      netfilter: ipt_CLUSTERIP: remove "no conntrack!"
      net: filter: dont block softirqs in sk_run_filter()
      net_sched: cleanups
      netfilter: add a missing include in nf_conntrack_reasm.c
      net: dev_close_many() is static
      net_sched: sfq: allow divisor to be a parameter
      net_sched: move TCQ_F_THROTTLED flag
      net_sched: RCU conversion of stab
      net: ipv6: sit: fix rcu annotations
      neigh: __rcu annotations
      ipv6: raw: rcu annotations
      net: netif_setup_tc() is static
      net_sched: TCQ_F_CAN_BYPASS generalization
      pktgen: speedup fragmented skbs
      net_sched: sch_mqprio: dont leak kernel memory
      net: fix dev_seq_next()
      drivers/net: remove some rcu sparse warnings
      ipv4: fix rcu lock imbalance in fib_select_default()
      net: add __rcu annotations to sk_wq and wq
      net_sched: SFB flow scheduler
      sch_choke: add choke_skb_cb
      net_sched: reduce fifo qdisc size
      benet: use GFP_KERNEL allocations when possible
      inetpeer: seqlock optimization
      inetpeer: should use call_rcu() variant
      ftmac100: use GFP_ATOMIC allocations where needed
      xen: netfront: fix xennet_get_ethtool_stats()
      xfrm: fix __xfrm_route_forward()
      e1000e: fix kconfig for crc32 dependency

Felix Fietkau (33):
      ath9k: fix bogus sequence number increases on aggregation tid flush
      ath9k: fix initial sequence number after starting an ampdu session
      ath9k: reinitialize block ack window data when starting aggregation
      ath9k: reduce the likelihood of baseband hang check false positives
      ath9k_hw: partially revert "fix dma descriptor rx error bit parsing"
      ath9k: try more than one tid when scheduling a new aggregate
      ath9k: fix excessive BAR sending when a frame exceeds its retry limit
      mac80211: drop non-auth 3-addr data frames when running as a 4-addr station
      ath9k: remove a bogus error message
      ath9k_hw: replace magic values in register writes with proper defines
      ath9k: fix misplaced debug code
      ath9k: clean up the code that wakes the mac80211 queues
      ath9k: remove the virtual wiphy debugfs interface
      ath9k: remove support for virtual wiphys
      ath9k: remove the bf->aphy field
      ath9k: fold struct ath_wiphy into struct ath_softc
      ath9k: fix tx queue index confusion in debugfs code
      ath9k: use split rx buffers to get rid of order-1 skb allocations
      ath9k: fix compile error in non-debug ath_debug_stat_tx() stub
      mac80211: do not send duplicate data frames to the cooked monitor interface
      ath9k: add additional checks for the baseband hang detection
      mac80211: as a 4-addr station, do not receive packets for other stations
      p54: fix a NULL pointer dereference bug
      ath9k: use generic mac80211 LED blinking code
      cfg80211: add a field for the bitrate of the last rx data packet from a station
      mac80211: add support for showing the last rx bitrate
      ath9k: remove support for the FIF_PROMISC_IN_BSS filter flag
      ath9k_hw: fix REG_SET_BIT and REG_CLR_BIT for multiple bits
      ath9k: fix stopping tx dma on reset
      ath9k: fix the .flush driver op implementation
      ath9k: improve reliability of beacon transmission and stuck beacon handling
      mac80211: fix channel type recalculation with HT and non-HT interfaces
      ath9k: fix aggregation related interoperability issues

Florian Fainelli (1):
      r6040: bump to version 0.27 and date 23Feb2011

Florian Westphal (10):
      netfilter: ebt_ip6: allow matching on ipv6-icmp types/codes
      netfilter: Kconfig: NFQUEUE is useless without NETFILTER_NETLINK_QUEUE
      netfilter: nfnetlink_queue: return error number to caller
      netfilter: nfnetlink_queue: do not free skb on error
      netfilter: reduce NF_VERDICT_MASK to 0xff
      netfilter: allow NFQUEUE bypass if no listener is available
      netfilter: do not omit re-route check on NF_QUEUE verdict
      netfilter: nfnetlink_log: remove unused parameter
      netfilter: ipt_addrtype: rename to xt_addrtype
      netfilter: xt_addrtype: ipv6 support

Francois Romieu (1):
      r8169: convert to new VLAN model.

Frank Blaschka (1):
      qeth: change some configurations defaults

Fry, Donald H (2):
      iwlagn: Support new 1000 microcode.
      iwlagn: report correct temperature for WiFi/BT devices.

FrÈdÈric Leroy (1):
      netfilter: xt_CLASSIFY: add ARP support, allow CLASSIFY target on any table

Gabor Juhos (1):
      rt2x00: fix whitespace damage in the rt2800 specific code

George (9):
      rtlwifi: Add usb driver
      rtlwifi: Add headers for rtl8187cu
      rtlwifi: rtl8192cu: Add routines dm, fw, led and sw
      rtlwifi: rtl8192cu: Add routine hw
      rtlwifi: rtl8192cu: Add routine mac
      rtlwifi: rtl8192cu: Add routine phy
      rtlwifi: rtl8192cu: Add routine rf
      rtlwifi: rtl8192cu: Add routine table
      rtlwifi: rtl8192cu: Add routine trx

Gertjan van Wingerde (7):
      rt2x00: Fix WPA TKIP Michael MIC failures.
      rt2x00: Copy the MAC address to the WCID entry properly.
      rt2x00: Fix FIXME comments in rt61pci and rt73usb on Michael MIC.
      rt2x00: Don't treat ATIM queue as second beacon queue.
      rt2x00: Include ATIM queue support in rt2x00queue_get_tx_queue.
      rt2x00: Optimize getting the beacon queue structure.
      rt2x00: Remove unused rt2x00queue_get_queue function.

Gery Kahn (1):
      wl12xx: update PLT initialization for new firmware

Grazvydas Ignotas (2):
      wl1251: remove wl1251_ps_set_elp function
      wl1251: fix elp_work race condition

Greg Rose (7):
      ixgbe: Enable Jumbo Frames on the X540 10Gigabit Controller
      ixgbevf: Enable jumbo frame support for X540 VF
      ixgbevf: Fix name of function in function header comment
      ixgbevf: Fix Compiler Warnings
      ixgbe: X540 Cleanup
      ixgbevf: Fix Version String
      ixgbevf: Fix Driver String

Guo-Fu Tseng (9):
      jme: Extract main and sub chip revision
      jme: PHY Power control for new chip
      jme: Fix bit typo of JMC250A2 workaround
      jme: Rename phyfifo function for easier understand
      jme: Fix hardware action of full-duplex
      jme: Safer MAC processor reset sequence
      jme: Refill receive unicase MAC addr after resume
      jme: Don't show UDP Checksum error if HW misjudged
      jme: Advance driver version

Gustavo F. Padovan (29):
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-2.6 into wireless
      Bluetooth: Fix setting of MTU for ERTM and Streaming Mode
      Bluetooth: Rename l2cap.c to l2cap_core.c
      Bluetooth: Initial work for L2CAP split.
      Bluetooth: move l2cap_sock_ops to l2cap_sock.c
      Bluetooth: move l2cap_sock_release() to l2cap_sock.c
      Bluetooth: move l2cap_sock_bind()/listen() to l2cap_sock.c
      Bluetooth: move l2cap_sock_accept() to l2cap_sock.c
      Bluetooth: move l2cap_sock_getname() to l2cap_sock.c
      Bluetooth: move l2cap_sock_setsockopt() to l2cap_sock.c
      Bluetooth: move l2cap_sock_getsockopt() to l2cap_sock.c
      Bluetooth: move l2cap_sock_connect() to l2cap_sock.c
      Bluetooth: move l2cap_sock_recvmsg() to l2cap_sock.c
      Bluetooth: move l2cap_sock_shutdown() to l2cap_sock.c
      Bluetooth: move l2cap_sock_sendmsg() to l2cap_sock.c
      Bluetooth: move L2CAP sock timers function to l2cap_sock.c
      Bluetooth: move l2cap_sock_kill() to l2cap_sock.c
      Bluetooth: move __l2cap_sock_close() to l2cap_sock.c
      Bluetooth: update Bluetooth daemon name in Kconfig help
      Bluetooth: Merge L2CAP and SCO modules into bluetooth.ko
      Bluetooth: remove l2cap_load() hack
      Bluetooth: Add L2CAP mode to debugfs output
      Bluetooth: Use usb_fill_int_urb()
      Bluetooth: Fix crash when ioctl(HCIUARTSETPROTO) fails
      Bluetooth: fix errors reported by checkpatch.pl
      Bluetooth: Fix errors reported by checkpatch.pl
      Bluetooth: fix checkpatch errors in af_bluetooth.c
      Bluetooth: Remove duplicated BT_INFO() from L2CAP
      Bluetooth: Fix BT_L2CAP and BT_SCO in Kconfig

Guy Eilam (1):
      wl12xx: change debug_level module param sysfs permissions

Hagen Paul Pfeifer (10):
      dccp: newdp is declared/assigned but never be used
      ipv6: totlen is declared and assigned but not used
      ipv6: hash is calculated but not used afterwards
      ipv6: variable next is never used in this function
      ipv6: ignore rtnl_unicast() return code
      sched: protocol only needed when CONFIG_NET_CLS_ACT is enabled
      mcast: net_device dev not used
      af_packet: struct socket declared/assigned but unused
      sctp: several declared/set but unused fixes
      af_unix: remove unused struct sockaddr_un cruft

Hans Schillstrom (31):
      IPVS: Backup, Prepare for transferring firewall marks (fwmark) to the backup daemon.
      IPVS: Split ports[2] into src_port and dst_port
      IPVS: skb defrag in L7 helpers
      IPVS: Handle Scheduling errors.
      IPVS: Backup, Adding structs for new sync format
      IPVS: Backup, Adding Version 1 receive capability
      IPVS: Backup, Change sending to Version 1 format
      IPVS: Backup, adding version 0 sending capabilities
      IPVS: netns, add basic init per netns.
      IPVS: netns to services part 1
      IPVS: netns awarness to lblcr sheduler
      IPVS: netns awarness to lblc sheduler
      IPVS: netns, prepare protocol
      IPVS: netns preparation for proto_tcp
      IPVS: netns preparation for proto_udp
      IPVS: netns preparation for proto_sctp
      IPVS: netns preparation for proto_ah_esp
      IPVS: netns, use ip_vs_proto_data as param.
      IPVS: netns, common protocol changes and use of appcnt.
      IPVS: netns awareness to ip_vs_app
      IPVS: netns awareness to ip_vs_est
      IPVS: netns awareness to ip_vs_sync
      IPVS: netns, ip_vs_stats and its procfs
      IPVS: netns, connection hash got net as param.
      IPVS: netns, ip_vs_ctl local vars moved to ipvs struct.
      IPVS: netns, defense work timer.
      IPVS: netns, trash handling
      IPVS: netns, svc counters moved in ip_vs_ctl,c
      IPVS: netns, misc init_net removal in core.
      IPVS: netns, final patch enabling network name space.
      IPVS netns BUG, register sysctl for root ns

Hayes Wang (2):
      r8169: adjust rtl8169_set_speed_xmii function.
      r8169: support the new chips for RTL8105E.

Helmut Schaa (34):
      rt2x00: Refactor beacon code to make use of start- and stop_queue
      rt2x00: Introduce beacon_update_locked that requires caller locking
      rt2x00: Limit beacon updates in bss_info_changed to USB devices
      rt2x00: Make periodic beacon updates for PCI devices atomic
      rt2x00: Introduce tasklets for interrupt handling
      rt2x00: Disable txstatus tasklet by default
      rt2x00: Convert rt2800pci to use tasklets
      rt2x00: Convert rt61pci to use tasklets
      rt2x00: Convert rt2500pci interrupt handling to use tasklets
      rt2x00: Convert rt2400pci interrupt handling to use tasklets
      rt2x00: Remove interrupt thread registration
      rt2x00: Remove STATE_RADIO_IRQ_OFF_ISR and STATE_RADIO_IRQ_ON_ISR
      rt2x00: Update MAINTAINERS
      mac80211: Remove superfluous if clause
      rt2x00: Minor optimization for devices with RTS/CTS offload
      Revert "rt2x00 : avoid timestamp for monitor injected frame."
      rt2x00: Remove superfluos empty line
      wl12xx: Correctly set up protection if non-GF STAs are present
      rt2x00: Optimize calls to rt2x00queue_get_queue
      rt2x00: Make use of unlikely during tx status processing
      rt2x00: Remove useless NULL check
      rt2x00: Add unlikely macro to special case tx status handling
      rt2x00: Use unlikely for unexpected error condition in rt2x00_mac_tx
      rt2x00: Generate sw sequence numbers only for devices that need it
      rt2x00: Optimize TX descriptor handling
      rt2x00: Move TX descriptor field "ifs" into plcp substruct
      rt2x00: Don't call ieee80211_get_tx_rate for MCS rates
      rt2x00: Use an enum instead of u16 for the rate_mode TX descriptor field
      rt2x00: Fix rt2800 key assignment in multi bssid setups
      rt2x00: Remove now unused crypto.aid field
      rt2x00: Revise irqmask locking for PCI devices
      rt2x00: Fix comment in rt2800pci
      mac80211: Remove redundant preamble and RTS flag setup in minstrel_ht
      mac80211: Shortcut minstrel_ht rate setup for non-MRR capable devices

Henry Ptasinski (1):
      wireless-next-2.6: brcm80211: fix compile issue

Herbert Xu (6):
      inet: Remove unused sk_sndmsg_* from UFO
      inet: Remove explicit write references to sk/inet in ip_append_data
      inet: Add ip_make_skb and ip_finish_skb
      udp: Switch to ip_finish_skb
      udp: Add lockless transmit path
      inet: Replace left-over references to inet->cork

Hiroaki SHIMODA (1):
      ipv4: Fix PMTU update.

Ian Campbell (3):
      xen/irq: implement bind_interdomain_evtchn_to_irqhandler for backend drivers
      xen: netfront: ethtool stats fields should be unsigned long
      xen network backend driver

Ido Yariv (9):
      wl12xx: Don't rely on runtime PM for toggling power
      wl12xx: Remove private headers in wl1271_tx_reset
      wl12xx: Reorder data handling in irq_work
      wl12xx: Do end-of-transactions transfers only if needed
      wl12xx: Change claiming of the SDIO bus
      wl12xx: Switch to a threaded interrupt handler
      wl12xx: Switch to level trigger interrupts
      wl12xx: Avoid redundant TX work
      wl12xx: Modify requested number of memory blocks

Ilpo J√§rvinen (1):
      tcp: document tcp_max_ssthresh (Limited Slow-Start)

Ivan Vecera (2):
      bna: use device model DMA API
      be2net: use device model DMA API

Ivo van Doorn (3):
      rt2x00: Kill all tasklets during device removal
      rt2x00: Move TX/RX work into dedicated workqueue
      rt2x00: Optimize TX descriptor memory layout

Jan Beulich (1):
      small adjustment to net/mac80211/Kconfig

Jan Engelhardt (13):
      netfilter: xt_LOG: do print MAC header on FORWARD
      netfilter: xtables: use guarded types
      netfilter: xt_comment: drop unneeded unsigned qualifier
      netfilter: xtables: add missing aliases for autoloading via iptables
      audit: export symbol for use with xt_AUDIT
      netfilter: xtables: use __uXX guarded types for userspace exports
      netfilter: xtables: add missing header files to export list
      netfilter: xtables: connlimit revision 1
      netfilter: xtables: remove extraneous header that slipped in
      netfilter: xtables: remove duplicate member
      netfilter: xtables: add missing header inclusions for headers_check
      netfilter: xt_connlimit: pick right dstaddr in NAT scenario
      netfilter: xt_conntrack: warn about use in raw table

Jason Young (1):
      mac80211: do not enable ps if 802.1x controlled port is unblocked

Jay Sternberg (1):
      iwlwifi: correct debugfs data dumped from sram

Jeff Kirsher (1):
      e1000e: convert to stats64

Jeongtae Park (1):
      smsc911x: Fix build error when SMSC_TRACE() used

Jesper Juhl (3):
      Bluetooth: Fix failure to release lock in read_index_list()
      batman-adv: Remove two duplicate includes.
      IPVS: Fix variable assignment in ip_vs_notrack

Jiri Olsa (1):
      netfilter: nf_conntrack: nf_conntrack snmp helper

Jiri Pirko (15):
      veth: remove unneeded ifname code from veth_newlink()
      bonding: fix return value of couple of store functions
      net: remove the unnecessary dance around skb_bond_should_drop
      net: make dev->master general
      rtnetlink: implement setting of master device
      bond: implement [add/del]_slave ops
      bridge: implement [add/del]_slave ops
      net: convert bonding to use rx_handler
      net: allow handlers to be processed for orig_dev
      fcoe: correct checking for bonding
      bonding: register slave pointer for rx_handler
      net: get rid of multiple bond-related netdevice->priv_flags
      bonding: wrap slave state work
      bonding: get rid of IFF_SLAVE_INACTIVE netdev->priv_flag
      net: introduce rx_handler results and logic around that

Jiri Slaby (2):
      NET: cdc-phonet, fix stop-queue handling
      NET: cdc-phonet, handle empty phonet header

Joe Gunn (1):
      orinoco: Drop scan results with unknown channels

Joe Perches (7):
      tun: Convert logging messages to pr_<level> and tun_debug
      tlan: Remove changelog
      tlan: Use pr_fmt, pr_<level> and netdev_<level>
      mv643xx_eth: Use netdev_<level> and pr_<level>
      mii: Convert printks to netdev_info
      eql: Convert printks to pr_<level> and netdev_<level>
      netdevice: Convert printk to pr_info in netif_tx_stop_queue

Joel A Fernandes (1):
      mac80211: Rewrote code for checking if destinations are proxied.

Johan Hedberg (33):
      Bluetooth: Implement automatic setup procedure for local adapters
      Bluetooth: Add support for management powered event
      Bluetooth: Add support for set_powered management command
      Bluetooth: Add support for set_discoverable management command
      Bluetooth: Add set_connectable management command
      Bluetooth: Unify mode related management messages to a single struct
      Bluetooth: Add flag to track managment controlled adapters
      Bluetooth: Add send_mode_rsp convenience function for mgmt.c
      Bluetooth: Implement set_pairable managment command
      Bluetooth: Implement UUID handling through the management interface
      Bluetooth: Implement debugfs support for listing UUIDs
      Bluetooth: Reject pairing requests when in non-pairable mode
      Bluetooth: Add special handling with __hci_request and HCI_INIT
      Bluetooth: Add controller side link key clearing to hci_init_req
      Bluetooth: Remove page timeout setting from HCI init sequence
      Bluetooth: Implement a more complete adapter initialization sequence
      Bluetooth: Add class of device control to the management interface
      Bluetooth: Implement link key handling for the management interface
      Bluetooth: Add connected/disconnected management events
      Bluetooth: Add disconnect managment command
      Bluetooth: Add support for connect failed management event
      Bluetooth: Add get_connections managment interface command
      Bluetooth: Create common cmd_complete function for mgmt.c
      Bluetooth: Add support for PIN code handling in the management interface
      Bluetooth: Add set_io_capability management command
      Bluetooth: Make pending_add return a pointer to the added entry
      Bluetooth: Add mgmt_pair_device command
      Bluetooth: Add management support for user confirmation request
      Bluetooth: Fix mgmt_pin_code_reply command status opcode
      Bluetooth: Fix mgmt_pin_code_reply return parameters
      Bluetooth: Add mgmt_auth_failed event
      Bluetooth: Fix inititial value for remote authentication requirements
      Bluetooth: Fix unnecessary list traversal in mgmt_pending_remove

Johannes Berg (30):
      mac80211: don't return beacons when mesh is disabled
      mac80211: track receiver's aggregation reorder buffer size
      mac80211: allow advertising correct maximum aggregate size
      iwlagn: make iwl_rx_handle static
      iwlagn: add support for waiting for notifications
      iwlagn: properly wait for PAN disable
      iwlagn: return error if PAN disable timeout
      iwlwifi: fix 4965 notification wait setup
      iwlwifi: implement remain-on-channel
      iwlwifi: replace minimum slot time constant
      mac80211: use DECLARE_EVENT_CLASS
      mac80211: add MCS information to radiotap
      iwlwifi: support RSN IBSS
      iwlwifi: advertise max aggregate size
      iwlwifi: use maximum aggregation size
      iwlwifi: fix beacon notification parsing
      mac80211: allow GO to scan like AP
      iwlwifi: remove unnecessary locking
      mac80211: reply to directed probes in IBSS
      mac80211: fix 2.4 GHz 40 MHz disabling
      mac80211: rename RX_FLAG_TSFT
      rtl8192c: fix compilation errors
      mac80211: make tx() operation return void
      mac80211: remove IBSS merge delay
      mac80211: copy peer MCS TX parameters
      iwlagn: fix iwlagn_check_needed_chains
      mac80211: support direct offchannel TX offload
      mac80211: make rate control Kconfig warning depend on mac80211
      mac80211: fix scan race, simplify code
      iwlagn: support off-channel TX

Johannes Stezenbach (1):
      rt2x00: trivial: add \n to WARNING message

John Fastabend (20):
      net: implement mechanism for HW based QOS
      net_sched: implement a root container qdisc sch_mqprio
      ixgbe: DCB, only reprogram HW if the FCoE priority is changed
      ixgbe: DCB, remove round robin mode on 82598 devices
      ixgbe: DCB, abstract out dcb_config from DCB hardware configuration
      ixgbe: DCB, implement 802.1Qaz routines
      ixgbe: DCB, do not reset on CEE pg changes
      ixgbe: DCB, remove RESET bit it is no longer needed
      ixgbe: DCB, use hardware independent routines
      ixgbe: DCB, implement capabilities flags
      ixgbe: DCB, implement ieee_setapp dcbnl ops
      ixgbe: DCB remove ixgbe_fcoe_getapp routine
      ixgbe: DCB, use multiple Tx rings per traffic class
      ixgbe: enable ndo_tc_setup
      ixgbe: DCB: enable RSS to be used with DCB
      ixgbe: DCB, missed translation from 8021Qaz TSA to CEE link strict
      ixgbe: IEEE 802.1Qaz, implement priority assignment table
      ixgbe: DCB during ifup use correct CEE or IEEE mode
      ixgbe: DCB, set minimum bandwidth per traffic class
      ixgbe: DCB, PFC not cleared until reset occurs

John W. Linville (26):
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next-2.6
      Merge ssh://master.kernel.org/.../linville/wireless-2.6
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      iwlegacy: change some symbols duplicated from iwlwifi directory
      at76c50x-usb: fix warning caused by at76_mac80211_tx now returning void
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      Merge branch 'master' of git://git.kernel.org/.../padovan/bluetooth-next-2.6
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'wireless-next-2.6' of git://git.kernel.org/.../iwlwifi/iwlwifi-2.6
      rtlwifi: usb parts should depend on CONFIG_USB
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      ath5k: restrict AR5K_TX_QUEUE_ID_DATA_MAX to reflect the [0,3] range
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem
      wireless: add support for ethtool_ops->{get,set}_ringparam
      mac80211: implement support for cfg80211_ops->{get,set}_ringparam
      ath5k: implement ieee80211_ops->{get,set}_ringparam
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next-2.6 into for-davem

Jon Mason (4):
      vxge: cleanup probe error paths
      vxge: correct eprom version detection
      vxge: MSIX one shot mode
      vxge: update driver version

Jouni Malinen (3):
      mac80211: Remove obsolete TKIP flexibility
      mac80211: Add testing functionality for TKIP
      ath: Fix clearing of secondary key cache entry for TKIP

Jozsef Kadlecsik (14):
      netfilter: NFNL_SUBSYS_IPSET id and NLA_PUT_NET* macros
      netfilter: ipset: IP set core support
      netfilter: ipset: bitmap:ip set type support
      netfilter: ipset: bitmap:ip,mac type support
      netfilter: ipset; bitmap:port set type support
      netfilter: ipset: hash:ip set type support
      netfilter: ipset: hash:ip,port set type support
      netfilter: ipset: hash:ip,port,ip set type support
      netfilter: ipset: hash:ip,port,net set type support
      netfilter: ipset: hash:net set type support
      netfilter: ipset: hash:net,port set type support
      netfilter: ipset: list:set set type support
      netfilter: xtables: "set" match and "SET" target support
      netfilter: ipset: send error message manually

Julia Lawall (1):
      net/wireless/nl80211.c: Avoid call to genlmsg_cancel

Julian Anastasov (9):
      ipvs: remove extra lookups for ICMP packets
      ipvs: avoid lookup for fwmark 0
      ipvs: remove _bh from percpu stats reading
      ipvs: move struct netns_ipvs
      ipvs: reorganize tot_stats
      ipvs: properly zero stats and rates
      ipvs: remove unused seqcount stats
      ipvs: optimize rates reading
      ipvs: rename estimator functions

Jussi Kivilinna (25):
      zd1211rw: use urb anchors for tx and fix tx-queue disabling
      zd1211rw: cancel process_intr work on zd_chip_disable_int()
      zd1211rw: add locking for mac->process_intr
      zd1211rw: fix beacon interval setup
      zd1211rw: move set_multicast_hash and set_rx_filter from workers to configure_filter
      zd1211rw: move set_rts_cts_work to bss_info_changed
      zd1211rw: support setting BSSID for AP mode
      zd1211rw: fix ack_pending in filter_ack causing tx-packet ordering problem on monitor
      zd1211rw: let zd_set_beacon_interval() set dtim_period and add AP-beacon flag
      zd1211rw: implement beacon fetching and handling ieee80211_get_buffered_bc()
      zd1211rw: add beacon watchdog and setting HW beacon more failsafe
      zd1211rw: batch beacon config commands together
      zd1211rw: use stack and preallocated memory for small cmd-buffers
      zd1211rw: change interrupt URB buffer to DMA buffer
      zd1211rw: lower hw command timeouts
      zd1211rw: collect driver settings and add function to restore theim
      zd1211rw: add TX watchdog and device resetting
      zd1211rw: reset device when CR_BCN_FIFO_SEMAPHORE freezes in beacon setup
      zd1211rw: reset rx urbs after idle period of 30 seconds
      zd1211rw: enable NL80211_IFTYPE_AP
      zd1211rw: add useful debug output
      zd1211rw: correct use of usb_bulk_msg on interrupt endpoints
      zd1211rw: use async urb for write command
      zd1211rw: move async iowrite16v up to callers
      zd1211rw: add unlikely to ZD_ASSERT

Justin P. Mattock (1):
      drivers:net:ipw2100.c change a typo comamnd to command

Juuso Oikarinen (4):
      wl12xx: Cleanup PLT mode when module is removed
      wl12xx: Increase scan channel dwell time for passive scans
      cfg80211: Allow non-zero indexes for device specific pair-wise ciphers
      cfg80211: Fix power save state after interface type change

KOVACS Krisztian (1):
      netfilter: fix compilation when conntrack is disabled but tproxy is enabled

Larry Finger (15):
      rtlwifi: Modify core routines
      rtlwifi: rtl8192ce: Refactor rtl8192ce/dm
      rtlwifi: rtl8192ce: Refactor rtl8192ce/fw
      rtlwifi: rtl8192ce: Rework rtl8192ce/phy.c
      p54: Fix compile warning
      rtlwifi: Make changes in rtlwifi/rtl8192ce/reg.h to support rtl8192cu
      rtlwifi: Make changes in rtlwifi/rtl8192ce/def.h to support rtl8192cu
      rtlwifi: Modify some rtl8192ce routines for merging rtl8192cu
      rtlwifi: Modify wifi.h for rtl8192cu
      rtlwifi: Move common parts of rtl8192ce/phy.c
      rtlwifi: Modify build system for rtl8192cu
      rtlwifi: rtl8192ce: Fix endian warnings
      rtlwifi: Remove obsolete/unused macros
      rtlwifi: rtl8192ce: rtl8192cu: Fix multiple def errors for allyesconfig build
      rtl8187: Change rate-control feedback

Levi, Shahar (2):
      wl12xx: BA initiator support
      wl12xx: BA receiver support

Linus L√ºssing (6):
      batman-adv: Remove duplicate types.h inclusions
      batman-adv: Disallow originator addressing within mesh layer
      batman-adv: Make bat_priv->curr_gw an rcu protected pointer
      batman-adv: Increase orig_node refcount before releasing rcu read lock
      batman-adv: Fix possible buffer overflow in softif neigh list output
      batman-adv: Remove unused hdr_size variable in route_unicast_packet()

Lior Levy (4):
      igbvf: remove Tx hang detection
      igb: add support for VF Transmit rate limit using iproute2
      ixgbevf: remove Tx hang detection
      ixgbe: add support for VF Transmit rate limit using iproute2

Luciano Coelho (7):
      mac80211: add hw configuration for max ampdu buffer size
      MAINTAINERS: update information for the wl12xx driver
      wl12xx: don't modify the global supported band structures
      wl12xx: lock the RCU when accessing sta via ieee80211_find_sta()
      wl12xx: add hw configuration for max supported AMDPU size
      wl12xx: fix warning due to missing arg in ampdu_action
      wl12xx: fix MODULE_AUTHOR email address

Marc Kleine-Budde (9):
      ax88796: fix codingstyle and checkpatch warnings
      ax88796: don't use magic ei_status to acces private data
      ax88796: remove memset of private data
      ax88796: remove first_init parameter from ax_init_dev()
      ax88796: use netdev_<LEVEL> instead of dev_<LEVEL> and pr_<LEVEL>
      ax88796: remove platform_device member from struct ax_device
      ax88796: make pointer to platform data const
      ax88796: clean up probe and remove function
      ax88796: use generic mdio_bitbang driver

Marek Lindner (22):
      batman-adv: Split combined variable declarations
      batman-adv: protect neighbor nodes with reference counters
      batman-adv: convert neighbor list to hlist
      batman-adv: protect neighbor list with rcu locks
      batman-adv: free neighbors when an interface is deactivated
      batman-adv: protect neigh_nodes used outside of rcu_locks with refcounting
      batman-adv: protect each hash row with rcu locks
      batman-adv: protect originator nodes with reference counters
      batman-adv: protect ogm counter arrays with spinlock
      batman-adv: Correct rcu refcounting for neigh_node
      batman-adv: Correct rcu refcounting for gw_node
      batman-adv: Correct rcu refcounting for softif_neigh
      batman-adv: Correct rcu refcounting for batman_if
      batman-adv: protect bit operations to count OGMs with spinlock
      batman-adv: make broadcast seqno operations atomic
      batman-adv: separate ethernet comparing calls from hash functions
      batman-adv: remove extra layer between hash and hash element - hash bucket
      batman-adv: Correct rcu refcounting for orig_node
      batman-adv: increase refcount in create_neighbor to be consistent
      batman-adv: remove orig_hash spinlock
      batman-adv: rename global if_list to hardif_list
      batman-adv: rename batman_if struct to hard_iface

Mario Schuknecht (1):
      tcp: ioctl type SIOCOUTQNSD returns amount of data not sent

Mark Einon (1):
      Trivial typo fix in comment

Mark Rustad (3):
      net: dcbnl: Update copyright dates
      net: dcbnl: Fix misspellings
      net: dcbnl: Add IEEE app selector value definitions

Matt Carlson (19):
      tg3: Revise 5719 internal FIFO overflow solution
      tg3: Fix 5719 A0 tx completion bug
      tg3: Use new VLAN code
      tg3: Disable multivec mode for 1 MSIX vector
      tg3: Restrict phy ioctl access
      tg3: Fix loopback tests
      tg3: Disable MAC loopback test for CPMU devices
      tg3: Disable EEE during loopback tests
      tg3: Fix EEE interoperability issue
      tg3: Fix eee preprocessor naming
      tg3: Update copyrights and update version to 3.117
      tg3: Expand 5719 workaround
      tg3: Add missed 5719 workaround change
      tg3: Fix NVRAM selftest
      tg3: Add code to verify RODATA checksum of VPD
      tg3: cleanup pci device table vars
      tg3: Refine VAux decision process
      tg3: Move tg3_init_link_config to tg3_phy_probe
      tg3: Remove 5750 PCI code

Meenakshi Venkataraman (1):
      iwlagn: Enable idle powersave mode in 1000 series

Michael Buesch (4):
      ssb: Make ssb_wait_bit multi-bit safe
      lib-average: Make config option selectable
      mac80211: Add log message to ieee80211_restart_hw()
      p54spi: Update kconfig help text

Michael Chan (1):
      bnx2: Update firmware and version

Micha≈Ç Miros≈Çaw (16):
      net: Move check of checksum features to netdev_fix_features()
      net: change netdev->features to u32
      net: reduce and unify printk level in netdev_fix_features()
      ethtool: move EXPORT_SYMBOL(ethtool_op_set_tx_csum) to correct place
      ethtool: enable GSO and GRO by default
      ethtool: factorize ethtool_get_strings() and ethtool_get_sset_count()
      ethtool: factorize get/set_one_feature
      net: Introduce new feature setting ops
      net: ethtool: use ndo_fix_features for offload setting
      net: use ndo_fix_features for ethtool_ops->set_flags
      net: introduce NETIF_F_RXCSUM
      loopback: convert to hw_features
      Fix "(unregistered net_device): Features changed" message
      net: avoid initial "Features changed" message
      net: Fix ETHTOOL_GFEATURES compatibility
      net: Implement SFEATURES compatibility for not updated drivers

Michel Lespinasse (1):
      drivers/net: fix build warnings with CONFIG_PM_SLEEP disabled

Mohammed Shafi Shajakhan (4):
      ath9k: clean up enums and unused macros
      ath9k: Fix memory leak due to failed PAPRD frames
      mac80211: Update comments on radiotap MCS index
      ath9k: Update comments for not parsing DTIM period

Nick Kossifidis (1):
      ath5k: Fix fast channel switching

Nick Ledovskikh (1):
      mac80211:mesh_mpp_table_grow call should depend on MESH_WORK_GROW_MPP_TABLE flag.

Nicolas Dichtel (1):
      ipsec: allow to align IPv4 AH on 32 bits

Nicolas de Peslo√ºan (1):
      bonding: documentation update: mailing lists.

Nishant Sarmukadam (7):
      mwl8k: Modify add_dma_header to include pad parameters
      mwl8k: Add encapsulation of data packet for crypto
      mwl8k: Set mac80211 rx status flags appropriately when hw crypto is enabled
      mwl8k: Enable HW encryption for AP mode
      mwl8k: fix rf_antenna rx argument for AP
      mwl8k: Tell mac80211 we have rate adaptation in FW
      mwl8k: Invert tx queues for set_hw_spec and set_edca_params

Nobuhiro Iwamatsu (1):
      sh: sh_eth: Add support ethtool

Oliver Neukum (1):
      r8169: support control of advertising.

Pablo Neira Ayuso (2):
      netfilter: nf_conntrack_tstamp: add flow-based timestamp extension
      netfilter: nf_ct_tcp: fix out of sync scenario while in SYN_RECV

Padmanabh Ratnakar (8):
      be2net: Remove ERR compl workaround for Lancer
      be2net: Checksum field valid only for TCP/UDP
      be2net: Add error recovery during load for Lancer
      be2net: Change f/w command versions for Lancer
      be2net: Remove TX Queue stop in close
      be2net: Disarm CQ and EQ to disable interrupt in Lancer
      be2net: Add multicast filter capability for Lancer
      be2net: Fix UDP packet detected status in RX compl

Patrick McHardy (24):
      Merge branch 'for-patrick' of git://git.kernel.org/.../horms/lvs-test-2.6
      netfilter: xt_conntrack: support matching on port ranges
      netfilter: fix Kconfig dependencies
      Merge branch 'master' of git://1984.lsi.us.es/net-next-2.6
      netfilter: nf_conntrack: use is_vmalloc_addr()
      Merge branch 'master' of git://dev.medozas.de/linux
      netfilter: nf_conntrack: fix lifetime display for disabled connections
      Merge branch 'master' of /repos/git/net-next-2.6
      Merge branch 'connlimit' of git://dev.medozas.de/linux
      Merge branch 'connlimit' of git://dev.medozas.de/linux
      netfilter: nf_conntrack: fix linker error with NF_CONNTRACK_TIMESTAMP=n
      rtnetlink: fix link attribute validation with IFLA_GROUP
      Merge branch 'connlimit' of git://dev.medozas.de/linux
      netfilter: ipset: use nla_parse_nested()
      netfilter: ipset: remove unnecessary includes
      netfilter: ctnetlink: fix ctnetlink_parse_tuple() warning
      netfilter: ipset: install ipset related header files
      netfilter: ipset: add missing break statemtns in ip_set_get_ip_port()
      netfilter: ipset: fix linking with CONFIG_IPV6=n
      netfilter: xtables: add device group match
      netfilter: ipset: add dependency on CONFIG_NETFILTER_NETLINK
      netlink: kill loginuid/sessionid/sid members from struct netlink_skb_parms
      netlink: kill eff_cap from struct netlink_skb_parms
      netfilter: x_tables: return -ENOENT for non-existant matches/targets

Patrick Schaaf (1):
      ipvs: make "no destination available" message more informative

Paul Gortmaker (2):
      tipc: cosmetic - function names are not to be full sentences
      tipc: delete extra semicolon blocking node deletion

Peter Korsgaard (2):
      dsa/mv88e6060: support nonzero mii base address
      phylib: SIOCGMIIREG/SIOCSMIIREG: allow access to all mdio addresses

Phil Oester (3):
      bonding: Incorrect TX queue offset
      bonding: Call netif_carrier_off after register_netdevice
      bonding: Improve syslog message at device creation time

Po-Yu Chuang (1):
      net: add Faraday FTMAC100 10/100 Ethernet driver

RA-Jay Hung (5):
      rt2x00: Fix radio off hang issue for PCIE interface
      rt2x00: Fix and fine-tune rf registers for RT3070/RT3071/RT3090
      rt2x00: Correct initial value of US_CYC_CNT register for pcie interface
      rt2x00: Add antenna setting for RT3070/RT3090/RT3390 with RX antenna diversity support
      rt2x00: Fix rt2800 txpower setting to correct value

RA-Shiang Tu (1):
      rt2x00: Add support for RT5390 chip

Rafael J. Wysocki (3):
      tg3: Avoid setting power.can_wakeup for devices that cannot wake up
      atl1c: Do not call device_init_wakeup() in atl1c_probe()
      atl1: Do not use legacy PCI power management

Rafa≈Ç Mi≈Çecki (14):
      ssb: extract boardflags2 for SPROMs rev 4 and 5
      ssb: trivial: fix SPROM extract warning formatting
      ssb: remove invalid define SSB_TMSLOW_PHYCLK
      ssb: when needed, reject IM input while disabling device
      ssb: reset device only if it was enabled
      b43: N-PHY: fix 0x2055 radio workaround condition
      b43: N-PHY: rev1: enable some gain ctl workarounds
      b43: N-PHY: rev1: restore PHY state after RSSI operations
      b43: fill PHY ctl word1 in TX header for N-PHY
      b43: N-PHY: rev3+: add static tables
      b43: N-PHY: rev3+: correct switching analog core
      b43: N-PHY: rev3+: add tables with gain ctl workarounds
      b43: N-PHY: rev3+: implement gain ctl workarounds
      b43: trivial: update B43_PHY_N description (PHY support)

Rajesh Borundia (1):
      qlcnic: Remove validation for max tx and max rx queues

Rajkumar Manoharan (13):
      ath9k: preserve caldata history buffer across scanning
      ath9k_htc: keep calibrated noise floor value for oper channel
      ath9k_hw: fix carrier leakage calibration for AR9271
      ath9k: use common API to avoid code duplication
      mac80211: disable power save if an infra AP vif exists
      ath9k_htc: cancel ani work in ath9k_htc_stop
      ath9k: use common get current channel function
      ath9k: move update tx power to common
      ath9k_htc: make use common of function to update txpower
      ath9k: do not access hw registers in FULL SLEEP
      ath9k: reserve a beacon slot on beaconing vif addition
      mac80211: do not restart ps timer during scan or offchannel
      ath9k: disable beaconing before stopping beacon queue

Randy Dunlap (1):
      wl12xx: fix sdio_test kconfig/build errors

Richard Weinberger (1):
      netfilter: xt_connlimit: use hotdrop jump mark

Rog√©rio Brito (1):
      Bluetooth: ath3k: Avoid duplication of code

Roopa Prabhu (3):
      enic: Bug Fix: Dont reset ENIC_SET_APPLIED flag on port profile disassociate
      enic: Decouple mac address registration and deregistration from port profile set operation
      enic: Flush driver cache of registered addr lists during port profile disassociate

R√©mi Denis-Courmont (15):
      Phonet: allow multiple listen() and fix small race condition
      Phonet: implement per-socket destination/peer address
      Phonet: use socket destination in pipe protocol
      Phonet: remove redumdant pep->pipe_state
      Phonet: don't bother with transaction IDs (especially for indications)
      Phonet: fix flawed "SYN/ACK" logic
      Phonet: fix NULL dereference on TX path with implicit source
      Phonet: return an error when packet TX fails
      Phonet: correct pipe backlog callback return values
      Phonet: factor common code to send control messages
      Phonet: allocate sock from accept syscall rather than soft IRQ
      Phonet: provide pipe socket option to retrieve the pipe identifier
      Phonet: support active connection without pipe controller on modem
      Phonet: kill the ST-Ericsson pipe controller Kconfig
      Phonet: fix aligned-mode pipe socket buffer header reserve

Sakari Ailus (3):
      tlan: Code cleanup: checkpatch.pl is relatively happy now.
      tlan: add suspend/resume support
      tlan: Fix bugs introduced by the last tlan cleanup patch

Sangtae Ha (2):
      tcp_cubic: make the delay threshold of HyStart less sensitive
      tcp_cubic: fix low utilization of CUBIC with HyStart

Sathya Perla (1):
      be2net: changes for BE3 native mode support

Scott James Remnant (1):
      net/wireless: add COUNTRY to to regulatory device uevent

Sebastien Jan (1):
      wl12xx: fix the path to the wl12xx firmwares

Senthil Balasubramanian (3):
      ath9k_hw: Fix incorrect macversion and macrev checks
      ath9k_hw: read and backup AR_WA register value even before chip reset on.
      ath9k: Fix incorrect GPIO LED pin for AR9485

Sergei Shtylyov (2):
      net: use pci_dev->revision, again
      sis900: use pci_dev->revision

Seth Forshee (1):
      rt2x00: Check for errors from skb_pad() calls

Shan Wei (10):
      net: cleanup unused macros in net directory
      dccp: clean up unused DCCP_STATE_MASK definition
      tcp: Remove debug macro of TCP_CHECK_TIMER
      sctp: fix compile warnings in sctp_tsnmap_num_gabs
      mac80211: remove unused macros
      wireless:ath: use resource_size() help function
      s2io: fix uninitialized compile warning
      netfilter: ipset: fix the compile warning in ip_set_create
      mwl8k: use kcalloc instead of kmalloc & memset
      netfilter:ipvs: use kmemdup

Shawn Lin (1):
      r6040: fix multicast operations

Shiang Tu (2):
      rt2x00: Add/Modify protection related register definitions
      rt2x00: Add/Modify the GPIO register definition

Shmulik Ravid (3):
      bnx2x: use dcb_setapp to manage negotiated application tlvs
      dcbnl: add support for retrieving peer configuration - ieee
      dcbnl: add support for retrieving peer configuration - cee

Simon Horman (28):
      IPVS: Add persistence engine to connection entry
      IPVS: Only match pe_data created by the same pe
      IPVS: Make the cp argument to ip_vs_sync_conn() static
      IPVS: Remove useless { } block from ip_vs_process_message()
      IPVS: buffer argument to ip_vs_process_message() should not be const
      ipvs: allow transmit of GRO aggregated skbs
      Merge branch 'master' of git://git.kernel.org/.../davem/net-next-2.6 into HEAD
      IPVS: Change sock_create_kernel() to __sock_create()
      IPVS: use z modifier for sizeof() argument
      IPVS: remove duplicate initialisation or rs_table
      IPVS: Remove unused variables
      IPVS: Allow compilation with CONFIG_SYSCTL disabled
      IPVS: Remove ip_vs_sync_cleanup from section __exit
      IPVS: Use correct lock in SCTP module
      IPVS: Add ip_vs_route_me_harder()
      IPVS: Add sysctl_snat_reroute()
      IPVS: Add sysctl_nat_icmp_send()
      IPVS: Add {sysctl_sync_threshold,period}()
      IPVS: Add sysctl_sync_ver()
      IPVS: Add sysctl_expire_nodest_conn()
      IPVS: Add expire_quiescent_template()
      IPVS: Conditinally use sysctl_lblc{r}_expiration
      IPVS: ip_vs_todrop() becomes a noop when CONFIG_SYSCTL is undefined
      IPVS: Conditional ip_vs_conntrack_enabled()
      IPVS: Minimise ip_vs_leave when CONFIG_SYSCTL is undefined
      IPVS: Conditionally define and use ip_vs_lblc{r}_table
      IPVS: Add __ip_vs_control_{init,cleanup}_sysctl()
      IPVS: Conditionally include sysctl members of struct netns_ipvs

Simon Wunderlich (2):
      batman-adv: remove unused parameters
      batman-adv: protect bonding with rcu locks

Sony Chacko (2):
      netxen: Notify firmware of Flex-10 interface down
      netxen: support for GbE port settings

Stanislaw Gruszka (22):
      iwlwifi: do not set tx power when channel is changing
      iwl3945: set STATUS_READY before commit_rxon
      iwlwifi: remove unneeded __packed
      iwlwifi: introduce iwl_advanced_bt_coexist()
      iwlwifi: remove unneeded disable_hw_scan check
      iwlwifi: introduce iwl_bt_statistics
      iwl3945: do not use agn specific IWL_RATE_COUNT
      iwlwifi: correct frequency settings
      iwlwifi: cleanup iwl_recover_from_statistics
      iwlwifi: cleanup iwl_good_ack_health
      iwlwifi: fix ack health for WiFi/BT combo devices
      iwlegacy: do not set tx power when channel is changing
      mac80211: better fix for conn_mon_timer running after disassociate
      iwlwifi: fix dma mappings and skbs leak
      iwlegacy: fix dma mappings and skbs leak
      iwlwifi: add {ack,plpc}_check module parameters
      iwlwifi: move check health code into iwl-rx.c
      iwlwifi: move remaining iwl-agn-rx.c code into iwl-rx.c
      iwlwifi: move rx handlers code to iwl-rx.c
      iwlwifi: cleanup iwl_good_plcp_health
      iwlwifi: avoid too frequent recover from statistics
      iwlwifi: fix iwl-rx.c compilation

Stefan Assmann (1):
      igb: warn if max_vfs limit is exceeded

Stefan Berger (2):
      netfilter: xt_connlimit: connlimit-above early loop termination
      Revert "netfilter: xt_connlimit: connlimit-above early loop termination"

Steffen Klassert (10):
      crypto: authencesn - Add algorithm to handle IPsec extended sequence numbers
      xfrm: Add basic infrastructure to support IPsec extended sequence numbers
      xfrm: Use separate low and high order bits of the sequence numbers in xfrm_skb_cb
      esp4: Add support for IPsec extended sequence numbers
      esp6: Add support for IPsec extended sequence numbers
      xfrm: Move IPsec replay detection functions to a separate file
      xfrm: Support anti-replay window size bigger than 32 packets
      xfrm: Add support for IPsec extended sequence numbers
      xfrm: Add user interface for esn and big anti-replay windows
      xfrm: Refcount destination entry on xfrm_lookup

Stephen Hemminger (4):
      pfkey: fix warning
      netfilter: x_tables: misuse of try_then_request_module
      tcp: mark tcp_congestion_ops read_mostly
      netfilter: nf_conntrack: fix sysctl memory leak

Steve Brown (1):
      ath9k: Remove redundant beacon_interval

Steve Hodgson (2):
      sfc: Reduce size of efx_rx_buffer by unionising skb and page
      sfc: Reduce size of efx_rx_buffer further by removing data member

Sujith Manoharan (28):
      ath9k_htc: Add multiple register read API
      ath9k_hw: Offload USB eeprom reading to target
      ath9k_hw: Fix opmode initialization
      ath9k_hw: Fix INI fixup
      ath9k_hw: Add RX filters
      ath9k_hw: Fix power on reset
      ath9k_htc: Handle storage devices
      ath9k_htc: Allow upto two simultaneous interfaces
      ath9k_htc: Unify target capability updating
      ath9k_htc: Fix error handling in add_interface
      ath9k_htc: Remove OP_PREAMBLE_SHORT
      ath9k_htc: Remove OP_PROTECT_ENABLE
      ath9k_htc: Remove OP_ASSOCIATED variable
      ath9k_htc: Set the BSSID mask for multiple interfaces
      ath9k_htc: Make sequence number calculation per-VIF
      ath9k_htc: Use VIF from the packet's control data
      ath9k_htc: Protect ampdu_action with a mutex
      ath9k_htc: Maintain individual counters for interfaces
      ath9k_htc: Allow AP interface to be created
      ath9k_htc: Calculate and set the HW opmode
      ath9k_htc: Add ANI for AP mode
      ath9k_htc: Configure beacon timers in AP mode
      ath9k_htc: Fix TBTT calculation for IBSS mode
      ath9k_htc: Fix host RX initialization
      ath9k_htc: Fix RX filters
      ath9k_htc: Add debug code to print endpoint mapping
      ath9k_htc: Fix error path in URB allocation
      ath9k_htc: Handle BSSID/AID for multiple interfaces

Sven Eckelmann (10):
      batman-adv: Create roughly equal sized fragments
      batman-adv: Calculate correct size for merged packets
      batman-adv: Remove dangling declaration of hash_remove_element
      batman-adv: Remove unused definitions
      batman-adv: Remove declaration of batman_skb_recv
      batman-adv: Remove unused variables
      batman-adv: Update copyright years
      batman-adv: Merge README of v2011.0.0 release
      batman-adv: Use successive sequence numbers for fragments
      batman-adv: Disallow regular interface as mesh device

Szymon Janc (13):
      Bluetooth: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
      Bluetooth: Clean up hci_sniff_subrate_evt function
      Bluetooth: Fix some code style issues in hci_core.h
      Bluetooth: Fix some code style issues in hci_core.c
      Bluetooth: Fix some code style issues in hci_event.c
      Bluetooth: Use proper command structure in remove_uuid
      Bluetooth: Move index to common header in management interface
      Bluetooth: Validate data size before accessing mgmt commands
      Bluetooth: Fix possible NULL pointer dereference in cmd_complete
      Bluetooth: Log all parameters in cmd_status for easier debugging
      Bluetooth: Remove unused code from get_connections
      Bluetooth: Use variable name instead of type in sizeof()
      Bluetooth: Fix some small code style issues in mgmt.c

Thomas Chou (1):
      smc91x: add devicetree support

Thomas Gleixner (1):
      genirq: Fix affinity notifier fallout

Thomas Graf (3):
      netfilter: audit target to record accepted/dropped packets
      netfilter: create audit records for x_tables replaces
      netfilter ebtables: fix xt_AUDIT to work with ebtables

Thomas Jacob (2):
      netfilter: xt_iprange: typo in IPv4 match debug print code
      netfilter: xt_iprange: add IPv6 match debug print code

Thomas Lange (1):
      Davinci: Do not reset EMAC TX overruns counter on read

Tinggong Wang (1):
      ipvs: fix timer in get_curr_sync_buff

Tom Herbert (1):
      bnx2x: Support for managing RX indirection table

Ursula Braun (1):
      qeth: remove needless IPA-commands in offline

Uwe Kleine-K√∂nig (15):
      net/fec: no need to cast arguments for memcpy
      net/fec: release mem_region requested in probe in error path and remove
      net/fec: don't free an irq that failed to be requested
      net/fec: no need to check for validity of ndev in suspend and resume
      net/fec: no need to memzero private data
      net/fec: put the ioremap cookie immediately into a void __iomem pointer
      net/fec: consolidate all i.MX options to CONFIG_ARM
      net/fec: add phy_stop to fec_enet_close
      net/fec: consistenly name struct net_device pointers "ndev"
      net/fec: some whitespace cleanup
      net/fec: reorder functions a bit allows removing forward declarations
      net/fec: provide device for dma functions and matching sizes for map and unmap
      net/fec: postpone unsetting driver data until the hardware is stopped
      net/fec: enable flow control and length check on enet-mac
      net/fec: remove unused driver data

Vasanthakumar Thiagarajan (3):
      ath9k: Implement op_flush()
      ath9k: Add a debugfs interface to dump chip registers
      ath9k_hw: Read noise floor only for available chains for AR9003

Vasanthy Kolluri (9):
      enic: Clean up: Organize devcmd wrapper routines
      enic: Bug Fix: Fix return values of enic_add/del_station_addr routines
      enic: Bug Fix: Reorder firmware devcmds - CMD_INIT and CMD_IG_VLAN_REWRITE_MODE
      enic: Clean up: Remove support for an older version of hardware
      enic: Update MAINTAINERS
      enic: Bug fix: Reset driver count of registered unicast addresses to zero during device reset
      enic: Clean up: Remove a not needed #ifdef
      enic: Always use single transmit and single receive hardware queues per device
      enic: Support newer version of firmware devcmd CMD_MCPU_FW_INFO

Vasiliy Kulikov (7):
      Bluetooth: l2cap: fix 1 byte infoleak to userspace
      Bluetooth: bnep: fix buffer overflow
      Bluetooth: sco: fix information leak to userspace
      bridge: netfilter: fix information leak
      netfilter: arp_tables: fix infoleak to userspace
      netfilter: ip_tables: fix infoleak to userspace
      ipv6: netfilter: ip6_tables: fix infoleak to userspace

Vasily Khoruzhick (2):
      libertas_spi: Use workqueue in hw_host_to_card
      libertas: Prepare stuff for if_spi.c pm support

Ville Tervo (10):
      Bluetooth: Add low energy commands and events
      Bluetooth: Add LE connect support
      Bluetooth: Use LE buffers for LE traffic
      Bluetooth: Add LE connection support to L2CAP
      Bluetooth: Add server socket support for LE connection
      Bluetooth: Do not send disconn comand over LE links
      Bluetooth: Treat LE and ACL links separately on timeout
      Bluetooth: Add SMP command structures
      Bluetooth: Use proper timer for hci command timout
      Bluetooth: Use ERR_PTR as return error from hci_connect

Vinicius Costa Gomes (1):
      Bluetooth: Fix initiated LE connections

Vivek Natarajan (15):
      ath9k_hw: Add a function to read sqsum_dvc.
      ath9k: Fix a PLL hang issue observed with AR9485.
      ath9k_hw: DDR_PLL and BB_PLL need correct setting.
      ath9k: Fix a locking related issue.
      ath9k_hw: Update PMU setting to improve ripple issue for AR9485.
      ath9k_htc: Fix a compilation warning.
      ath9k_hw: Updates for AR9485 1.1 chipsets.
      mac80211: Clear PS related flag on disabling power save.
      mac80211: Fix a race on enabling power save.
      ath9k_hw: Fix pcie_serdes setting for AR9485 1.1 version.
      ath9k: Cancel pll_work while disabling radio.
      ath9k: Fix compilation warning.
      ath9k_hw: Improve idle power consumption for AR9485.
      ath9k_hw: Fix PLL initialization for AR9485.
      ath9k_hw: Increase the wait count for nf load.

Vlad Dogaru (4):
      net_device: add support for network device groups
      netlink: support setting devgroup parameters
      net: add sysfs entry for device group
      netdevice: make initial group visible to userspace

Vladislav Zolotarov (3):
      bnx2x, cnic: Consolidate iSCSI/FCoE shared mem logic in bnx2x
      bnx2x: MTU for FCoE L2 ring
      bnx2x: Proper netdev->ndo_set_rx_mode() implementation.

Wey-Yi Guy (32):
      mac80211: mesh only parameter mppath maybe unused
      iwlwifi: use mac80211 throughput trigger
      iwlagn: remove reference to gen2a and gen2b
      iwlagn: add 2000 series EEPROM version
      iwlagn: 2000 series devices support
      iwlagn: add 2000 series pci id
      iwlagn: add 2000 series to Kconfig
      iwlagn: remove Gen2 from Kconfig
      iwlwifi: remove g2 from csr hw rev
      iwlwifi: add hw rev for 2000 series devices
      iwlwifi: initial P2P support
      iwlwifi: check ucode loading error and restart
      iwlagn: adjust rate table
      iwlagn: add IQ inversion support for 2000 series devices
      iwlwifi: always support idle mode for agn devices
      iwlagn: use 2030 macro for 2030 devices
      iwlagn: remove unsupported BT SCO command
      iiwlagn: remove unused parameter
      iwlwifi: fix compiling error with different configuration
      iwlagn: donot process bt update when bt coex disable
      iwlagn: handle bt defer work in 2000 series
      iwlwifi: Limit number of firmware reload
      iwlwifi: Loading correct uCode again when fail to load
      iwlwifi: enable 2-wire bt coex support for non-combo device
      iwlwifi: split the drivers for agn and legacy devices 3945/4965
      Revert "iwlwifi: split the drivers for agn and legacy devices 3945/4965"
      iwlwifi: split the drivers for agn and legacy devices 3945/4965
      iwlagn: name change for BT config command
      iwlagn: add bt config structure support for 2000 series
      iwlagn: add BT Session Activity 2 UART message (BT -> WiFi)
      iwlagn: split BT page and inquiry UART msg
      iwlagn: enable BT session 2 type UART for 2000 series

Willy Tarreau (4):
      rtlwifi: Fix build when RTL8192CU is selected, but RTL8192CE is not
      rtl8192cu: fix build error (vmalloc/vfree undefined)
      rtlwifi: Let rtlwifi build when PCI is not enabled
      rtlwifi: Eliminate udelay calls with too large values

Wojciech Dubowik (2):
      ath5k: Fix return codes for eeprom read functions.
      ath5k: Enable AR2315 chipset recognition

Xiaotian Feng (1):
      net: rename group sysfs entry to netdev_group

Yaniv Rosner (10):
      bnx2x: Fix line indentation
      bnx2x: Rename CL45 macro
      bnx2x: Set comments according to preferred Linux style
      bnx2x: Fix compilation warning messages
      bnx2x: Add and change some net_dev messages
      bnx2x: Enhance SFP+ module control
      bnx2x: Add support for new PHY BCM84833
      bnx2x: Add CMS functionality for 848x3
      bnx2x: Remove support for emulation/FPGA
      bnx2x: Update bnx2x version to 1.62.11-0

Yi Zou (4):
      net: add ndo_fcoe_ddp_target() to support FCoE DDP in target mode
      vlan: add support to ndo_fcoe_ddp_target()
      ixgbe: add support to FCoE DDP in target mode
      net: add proper documentation for previously added net_device_ops for FCoE

Yoshihiro Shimoda (6):
      net: sh_eth: modify the definitions of register
      net: sh_eth: remove the SH_TSU_ADDR
      net: sh_eth: remove almost #ifdef of SH7763
      net: sh_eth: modify the PHY_INTERFACE_MODE
      net: sh_eth: add support for SH7757's GETHER
      net: sh_eth: add set_mdio_gate in bb_info

amit salecha (1):
      qlcnic: fix checks for auto_fw_reset

fran√ßois romieu (3):
      atl1c: remove private #define.
      atl1e: remove private #define.
      via-velocity: fix the WOL bug on 1000M full duplex forced mode.

hartleys (1):
      phy: Remove unneeded depends on PHYLIB

roel kluin (1):
      can: wrong index used in inner loop

stephen hemminger (23):
      sfq: deadlock in error path
      sched: CHOKe flow scheduler
      cls_u32: fix sparse warnings
      socket: suppress sparse warnings
      atl1[ce]: fix sparse warnings
      afkey: add sparse annotation about rcu
      mqprio: cleanups
      em_meta: fix sparse warning
      netem: cleanup dump code
      netem: use vmalloc for distribution table
      netem: define NETEM_DIST_MAX
      Revert "sch_netem: Remove classful functionality"
      netem: revised correlated loss generator
      netem: update version and cleanup
      bonding: fix sparse warning
      qla3xxx: add missing __iomem annotation
      bridge: control carrier based on ports online
      bridge: skip forwarding delay if not using STP
      tcp: fix RTT for quick packets in congestion control
      tcp_cubic: fix comparison of jiffies
      tcp_cubic: make ack train delta value a parameter
      tcp_cubic: fix clock dependency
      tcp_cubic: enable high resolution ack time if needed

 Documentation/feature-removal-schedule.txt         |   27 +
 Documentation/networking/batman-adv.txt            |   16 +-
 Documentation/networking/bonding.txt               |   26 +-
 Documentation/networking/ip-sysctl.txt             |   11 +
 Documentation/networking/phonet.txt                |   67 +-
 MAINTAINERS                                        |   10 +-
 arch/sh/include/asm/sh_eth.h                       |   10 +
 crypto/Makefile                                    |    2 +-
 crypto/authencesn.c                                |  835 ++++
 drivers/block/drbd/drbd_nl.c                       |    2 +-
 drivers/bluetooth/ath3k.c                          |  287 ++-
 drivers/bluetooth/btusb.c                          |   13 +-
 drivers/bluetooth/hci_ldisc.c                      |    1 +
 drivers/infiniband/core/addr.c                     |   31 +-
 drivers/infiniband/hw/cxgb3/iwch_cm.c              |   22 +-
 drivers/infiniband/hw/cxgb4/cm.c                   |   22 +-
 drivers/infiniband/hw/nes/nes.c                    |    3 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |    8 +-
 drivers/md/dm-log-userspace-transfer.c             |    2 +-
 drivers/net/Kconfig                                |   90 +-
 drivers/net/Makefile                               |    2 +
 drivers/net/atl1c/atl1c_hw.c                       |   15 +-
 drivers/net/atl1c/atl1c_hw.h                       |   43 +-
 drivers/net/atl1c/atl1c_main.c                     |    5 +-
 drivers/net/atl1e/atl1e_ethtool.c                  |   12 +-
 drivers/net/atl1e/atl1e_hw.c                       |   34 +-
 drivers/net/atl1e/atl1e_hw.h                       |  111 +-
 drivers/net/atl1e/atl1e_main.c                     |   10 +-
 drivers/net/atlx/atl1.c                            |   77 +-
 drivers/net/atlx/atl2.c                            |    2 +-
 drivers/net/ax88796.c                              |  810 ++--
 drivers/net/benet/be.h                             |   55 +-
 drivers/net/benet/be_cmds.c                        |  202 +-
 drivers/net/benet/be_cmds.h                        |   96 +-
 drivers/net/benet/be_ethtool.c                     |   87 +-
 drivers/net/benet/be_hw.h                          |  110 +-
 drivers/net/benet/be_main.c                        |  620 ++--
 drivers/net/bna/bnad.c                             |  108 +-
 drivers/net/bna/bnad.h                             |    2 +-
 drivers/net/bnx2.c                                 |   16 +-
 drivers/net/bnx2.h                                 |    6 +-
 drivers/net/bnx2x/bnx2x.h                          |   35 +-
 drivers/net/bnx2x/bnx2x_cmn.c                      |   70 +-
 drivers/net/bnx2x/bnx2x_cmn.h                      |    6 +-
 drivers/net/bnx2x/bnx2x_dcb.c                      |  137 +-
 drivers/net/bnx2x/bnx2x_dcb.h                      |    5 +-
 drivers/net/bnx2x/bnx2x_ethtool.c                  |   58 +-
 drivers/net/bnx2x/bnx2x_hsi.h                      |  114 +-
 drivers/net/bnx2x/bnx2x_link.c                     | 2527 ++++++-----
 drivers/net/bnx2x/bnx2x_link.h                     |   34 +-
 drivers/net/bnx2x/bnx2x_main.c                     |  600 ++-
 drivers/net/bnx2x/bnx2x_reg.h                      |    1 +
 drivers/net/bonding/Makefile                       |    3 +
 drivers/net/bonding/bond_3ad.c                     |    2 +-
 drivers/net/bonding/bond_alb.c                     |    2 +-
 drivers/net/bonding/bond_main.c                    |  638 +--
 drivers/net/bonding/bond_procfs.c                  |  275 ++
 drivers/net/bonding/bond_sysfs.c                   |   23 +-
 drivers/net/bonding/bonding.h                      |  111 +-
 drivers/net/can/Kconfig                            |    2 +
 drivers/net/can/Makefile                           |    1 +
 drivers/net/can/c_can/Kconfig                      |   15 +
 drivers/net/can/c_can/Makefile                     |    8 +
 drivers/net/can/c_can/c_can.c                      | 1158 +++++
 drivers/net/can/c_can/c_can.h                      |   86 +
 drivers/net/can/c_can/c_can_platform.c             |  215 +
 drivers/net/can/usb/esd_usb2.c                     |    6 +-
 drivers/net/cnic.c                                 |  209 +-
 drivers/net/cnic.h                                 |    2 +-
 drivers/net/cnic_if.h                              |    8 +-
 drivers/net/cs89x0.c                               |   19 +-
 drivers/net/cxgb3/cxgb3_offload.c                  |    5 +-
 drivers/net/cxgb4/cxgb4_main.c                     |    1 -
 drivers/net/davinci_emac.c                         |    2 +-
 drivers/net/dm9000.c                               |    7 +-
 drivers/net/e1000e/defines.h                       |    1 +
 drivers/net/e1000e/e1000.h                         |    5 +-
 drivers/net/e1000e/ethtool.c                       |   92 +-
 drivers/net/e1000e/hw.h                            |    5 +-
 drivers/net/e1000e/ich8lan.c                       |   48 +-
 drivers/net/e1000e/lib.c                           |    4 +-
 drivers/net/e1000e/netdev.c                        |  129 +-
 drivers/net/e1000e/phy.c                           |    8 +-
 drivers/net/enic/Makefile                          |    2 +-
 drivers/net/enic/enic.h                            |   11 +-
 drivers/net/enic/enic_dev.c                        |  221 +
 drivers/net/enic/enic_dev.h                        |   41 +
 drivers/net/enic/enic_main.c                       |  326 +--
 drivers/net/enic/vnic_dev.c                        |   26 +-
 drivers/net/enic/vnic_dev.h                        |    8 -
 drivers/net/enic/vnic_devcmd.h                     |   38 +-
 drivers/net/enic/vnic_rq.h                         |    5 -
 drivers/net/eql.c                                  |   10 +-
 drivers/net/fec.c                                  |  650 ++--
 drivers/net/forcedeth.c                            |    8 +-
 drivers/net/ftmac100.c                             | 1198 +++++
 drivers/net/ftmac100.h                             |  180 +
 drivers/net/hamradio/bpqether.c                    |    5 +-
 drivers/net/igb/e1000_82575.c                      |  296 ++-
 drivers/net/igb/e1000_82575.h                      |    1 +
 drivers/net/igb/e1000_defines.h                    |   52 +-
 drivers/net/igb/e1000_hw.h                         |    9 +-
 drivers/net/igb/e1000_mbx.c                        |   38 +-
 drivers/net/igb/e1000_nvm.c                        |   64 +-
 drivers/net/igb/e1000_nvm.h                        |    1 +
 drivers/net/igb/e1000_regs.h                       |   27 +
 drivers/net/igb/igb.h                              |    8 +
 drivers/net/igb/igb_ethtool.c                      |   30 +-
 drivers/net/igb/igb_main.c                         |  232 +-
 drivers/net/igbvf/ethtool.c                        |    6 +-
 drivers/net/igbvf/igbvf.h                          |    3 -
 drivers/net/igbvf/netdev.c                         |   63 +-
 drivers/net/ipg.c                                  |    4 +-
 drivers/net/ixgb/ixgb.h                            |    2 +-
 drivers/net/ixgb/ixgb_ethtool.c                    |   39 +
 drivers/net/ixgb/ixgb_main.c                       |   54 +-
 drivers/net/ixgbe/ixgbe.h                          |   16 +-
 drivers/net/ixgbe/ixgbe_82598.c                    |  102 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |  228 +-
 drivers/net/ixgbe/ixgbe_common.c                   |  947 ++--
 drivers/net/ixgbe/ixgbe_common.h                   |    8 +-
 drivers/net/ixgbe/ixgbe_dcb.c                      |  160 +-
 drivers/net/ixgbe/ixgbe_dcb.h                      |   12 +-
 drivers/net/ixgbe/ixgbe_dcb_82598.c                |  138 +-
 drivers/net/ixgbe/ixgbe_dcb_82598.h                |   25 +-
 drivers/net/ixgbe/ixgbe_dcb_82599.c                |  176 +-
 drivers/net/ixgbe/ixgbe_dcb_82599.h                |   29 +-
 drivers/net/ixgbe/ixgbe_dcb_nl.c                   |  429 ++-
 drivers/net/ixgbe/ixgbe_ethtool.c                  |   57 +-
 drivers/net/ixgbe/ixgbe_fcoe.c                     |  103 +-
 drivers/net/ixgbe/ixgbe_fcoe.h                     |    6 +-
 drivers/net/ixgbe/ixgbe_main.c                     |  481 ++-
 drivers/net/ixgbe/ixgbe_mbx.c                      |   37 +-
 drivers/net/ixgbe/ixgbe_mbx.h                      |    4 +-
 drivers/net/ixgbe/ixgbe_phy.c                      |  594 ++-
 drivers/net/ixgbe/ixgbe_phy.h                      |    7 +-
 drivers/net/ixgbe/ixgbe_sriov.c                    |  116 +-
 drivers/net/ixgbe/ixgbe_sriov.h                    |    3 +-
 drivers/net/ixgbe/ixgbe_type.h                     |   65 +-
 drivers/net/ixgbe/ixgbe_x540.c                     |   43 +-
 drivers/net/ixgbevf/defines.h                      |    2 +
 drivers/net/ixgbevf/ethtool.c                      |    4 +-
 drivers/net/ixgbevf/ixgbevf.h                      |    1 -
 drivers/net/ixgbevf/ixgbevf_main.c                 |   98 +-
 drivers/net/ixgbevf/regs.h                         |    2 +-
 drivers/net/jme.c                                  |  306 +-
 drivers/net/jme.h                                  |   87 +-
 drivers/net/loopback.c                             |    9 +-
 drivers/net/macvlan.c                              |   14 +-
 drivers/net/macvtap.c                              |   18 +-
 drivers/net/mii.c                                  |   14 +-
 drivers/net/mv643xx_eth.c                          |   74 +-
 drivers/net/myri10ge/myri10ge.c                    |    4 +-
 drivers/net/netxen/netxen_nic.h                    |    6 +-
 drivers/net/netxen/netxen_nic_ctx.c                |   15 +
 drivers/net/netxen/netxen_nic_ethtool.c            |   62 +-
 drivers/net/netxen/netxen_nic_main.c               |    3 +
 drivers/net/phy/Kconfig                            |    1 -
 drivers/net/phy/micrel.c                           |   24 +-
 drivers/net/phy/phy.c                              |    8 +-
 drivers/net/ppp_generic.c                          |  148 +-
 drivers/net/pptp.c                                 |   45 +-
 drivers/net/qla3xxx.c                              |   10 +-
 drivers/net/qlcnic/qlcnic.h                        |    5 -
 drivers/net/qlcnic/qlcnic_main.c                   |   15 +-
 drivers/net/r8169.c                                |  272 +-
 drivers/net/s2io.c                                 |    2 +-
 drivers/net/sfc/efx.c                              |   86 +-
 drivers/net/sfc/efx.h                              |   19 +-
 drivers/net/sfc/ethtool.c                          |   37 +-
 drivers/net/sfc/falcon.c                           |   22 +-
 drivers/net/sfc/falcon_boards.c                    |    2 +-
 drivers/net/sfc/falcon_xmac.c                      |    2 +-
 drivers/net/sfc/filter.c                           |  117 +-
 drivers/net/sfc/io.h                               |   15 +-
 drivers/net/sfc/mcdi.c                             |   32 +-
 drivers/net/sfc/mcdi.h                             |    4 +-
 drivers/net/sfc/mcdi_mac.c                         |    2 +-
 drivers/net/sfc/mcdi_pcol.h                        |    2 +-
 drivers/net/sfc/mcdi_phy.c                         |    2 +-
 drivers/net/sfc/mdio_10g.c                         |   34 +-
 drivers/net/sfc/mdio_10g.h                         |    5 +-
 drivers/net/sfc/mtd.c                              |    2 +-
 drivers/net/sfc/net_driver.h                       |   83 +-
 drivers/net/sfc/nic.c                              |   73 +-
 drivers/net/sfc/nic.h                              |    9 +-
 drivers/net/sfc/phy.h                              |    2 +-
 drivers/net/sfc/qt202x_phy.c                       |    2 +-
 drivers/net/sfc/regs.h                             |    8 +-
 drivers/net/sfc/rx.c                               |  144 +-
 drivers/net/sfc/selftest.c                         |    4 +-
 drivers/net/sfc/selftest.h                         |    2 +-
 drivers/net/sfc/siena.c                            |   24 +-
 drivers/net/sfc/spi.h                              |    2 +-
 drivers/net/sfc/tenxpress.c                        |    4 +-
 drivers/net/sfc/tx.c                               |   92 +-
 drivers/net/sfc/txc43128_phy.c                     |    4 +-
 drivers/net/sfc/workarounds.h                      |    2 +-
 drivers/net/sh_eth.c                               |  737 +++-
 drivers/net/sh_eth.h                               |  654 ++--
 drivers/net/sis900.c                               |    4 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/smc91x.c                               |   13 +
 drivers/net/smsc911x.c                             |    4 +-
 drivers/net/sungem.c                               |   58 +-
 drivers/net/sungem.h                               |    1 -
 drivers/net/tg3.c                                  |  335 +-
 drivers/net/tg3.h                                  |   13 +-
 drivers/net/tlan.c                                 | 3840 ++++++++--------
 drivers/net/tlan.h                                 |  192 +-
 drivers/net/tun.c                                  |   85 +-
 drivers/net/typhoon.c                              |    3 +-
 drivers/net/usb/cdc-phonet.c                       |   10 +-
 drivers/net/veth.c                                 |   12 -
 drivers/net/via-velocity.c                         |    9 +
 drivers/net/via-velocity.h                         |    8 +-
 drivers/net/vxge/vxge-config.c                     |   32 +-
 drivers/net/vxge/vxge-config.h                     |   10 +
 drivers/net/vxge/vxge-main.c                       |  234 +-
 drivers/net/vxge/vxge-main.h                       |   23 +-
 drivers/net/vxge/vxge-traffic.c                    |  116 +-
 drivers/net/vxge/vxge-traffic.h                    |   14 +-
 drivers/net/vxge/vxge-version.h                    |    4 +-
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    5 +-
 drivers/net/wireless/adm8211.c                     |    4 +-
 drivers/net/wireless/at76c50x-usb.c                |   10 +-
 drivers/net/wireless/at76c50x-usb.h                |    2 +-
 drivers/net/wireless/ath/ar9170/Kconfig            |    4 +-
 drivers/net/wireless/ath/ar9170/ar9170.h           |    2 +-
 drivers/net/wireless/ath/ar9170/main.c             |    8 +-
 drivers/net/wireless/ath/ath.h                     |    2 +
 drivers/net/wireless/ath/ath5k/Kconfig             |   11 +
 drivers/net/wireless/ath/ath5k/ahb.c               |    9 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |   40 +-
 drivers/net/wireless/ath/ath5k/attach.c            |    7 +-
 drivers/net/wireless/ath/ath5k/base.c              |  176 +-
 drivers/net/wireless/ath/ath5k/base.h              |   17 +-
 drivers/net/wireless/ath/ath5k/caps.c              |   48 +-
 drivers/net/wireless/ath/ath5k/debug.c             |   20 -
 drivers/net/wireless/ath/ath5k/debug.h             |   10 -
 drivers/net/wireless/ath/ath5k/eeprom.c            |   24 +-
 drivers/net/wireless/ath/ath5k/eeprom.h            |   28 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   94 +-
 drivers/net/wireless/ath/ath5k/pci.c               |    9 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |   46 +-
 drivers/net/wireless/ath/ath5k/reg.h               |   15 +-
 drivers/net/wireless/ath/ath5k/trace.h             |  107 +
 drivers/net/wireless/ath/ath9k/Makefile            |    1 -
 drivers/net/wireless/ath/ath9k/ahb.c               |   15 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |    5 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   26 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |  112 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   37 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |    2 +
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h   | 1143 +++++
 drivers/net/wireless/ath/ath9k/ath9k.h             |  157 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   93 +-
 drivers/net/wireless/ath/ath9k/calib.c             |    9 +-
 drivers/net/wireless/ath/ath9k/common.c            |   11 +
 drivers/net/wireless/ath/ath9k/common.h            |    4 +-
 drivers/net/wireless/ath/ath9k/debug.c             |  494 ++-
 drivers/net/wireless/ath/ath9k/debug.h             |   17 +-
 drivers/net/wireless/ath/ath9k/eeprom.c            |   32 +
 drivers/net/wireless/ath/ath9k/eeprom.h            |    2 +
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |   41 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       |   45 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |   38 +-
 drivers/net/wireless/ath/ath9k/gpio.c              |  169 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   78 +-
 drivers/net/wireless/ath/ath9k/htc.h               |   80 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |  170 +-
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c      |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   48 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  485 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   84 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   65 +-
 drivers/net/wireless/ath/ath9k/hw.h                |    8 +-
 drivers/net/wireless/ath/ath9k/init.c              |   57 +-
 drivers/net/wireless/ath/ath9k/mac.c               |  103 +-
 drivers/net/wireless/ath/ath9k/mac.h               |    5 +-
 drivers/net/wireless/ath/ath9k/main.c              |  754 ++--
 drivers/net/wireless/ath/ath9k/pci.c               |   20 +-
 drivers/net/wireless/ath/ath9k/rc.c                |    3 +-
 drivers/net/wireless/ath/ath9k/recv.c              |  177 +-
 drivers/net/wireless/ath/ath9k/reg.h               |   22 +
 drivers/net/wireless/ath/ath9k/virtual.c           |  717 ---
 drivers/net/wireless/ath/ath9k/wmi.c               |    4 -
 drivers/net/wireless/ath/ath9k/xmit.c              |  308 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    3 +-
 drivers/net/wireless/ath/carl9170/fw.c             |   15 +
 drivers/net/wireless/ath/carl9170/fwcmd.h          |    1 +
 drivers/net/wireless/ath/carl9170/fwdesc.h         |   28 +-
 drivers/net/wireless/ath/carl9170/hw.h             |   25 +
 drivers/net/wireless/ath/carl9170/main.c           |    9 +-
 drivers/net/wireless/ath/carl9170/tx.c             |    8 +-
 drivers/net/wireless/ath/carl9170/version.h        |    8 +-
 drivers/net/wireless/ath/carl9170/wlan.h           |   20 +-
 drivers/net/wireless/ath/key.c                     |    5 +-
 drivers/net/wireless/ath/regd.c                    |    7 +
 drivers/net/wireless/ath/regd.h                    |    1 +
 drivers/net/wireless/b43/Kconfig                   |    2 +-
 drivers/net/wireless/b43/main.c                    |    6 +-
 drivers/net/wireless/b43/phy_n.c                   |  207 +-
 drivers/net/wireless/b43/tables_nphy.c             | 1209 +++++-
 drivers/net/wireless/b43/tables_nphy.h             |   52 +
 drivers/net/wireless/b43/xmit.c                    |   75 +-
 drivers/net/wireless/b43/xmit.h                    |    6 +
 drivers/net/wireless/b43legacy/main.c              |    5 +-
 drivers/net/wireless/b43legacy/xmit.c              |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.h             |    2 +-
 drivers/net/wireless/iwlegacy/Kconfig              |  116 +
 drivers/net/wireless/iwlegacy/Makefile             |   25 +
 .../{iwlwifi => iwlegacy}/iwl-3945-debugfs.c       |   11 +-
 .../{iwlwifi => iwlegacy}/iwl-3945-debugfs.h       |    4 +-
 .../wireless/{iwlwifi => iwlegacy}/iwl-3945-fh.h   |    5 +-
 .../wireless/{iwlwifi => iwlegacy}/iwl-3945-hw.h   |    9 +-
 .../wireless/{iwlwifi => iwlegacy}/iwl-3945-led.c  |   31 +-
 .../wireless/{iwlwifi => iwlegacy}/iwl-3945-led.h  |    2 +-
 .../wireless/{iwlwifi => iwlegacy}/iwl-3945-rs.c   |   41 +-
 .../net/wireless/{iwlwifi => iwlegacy}/iwl-3945.c  |  267 +-
 .../net/wireless/{iwlwifi => iwlegacy}/iwl-3945.h  |   12 +-
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c     |  967 ++++
 .../iwl-legacy.h => iwlegacy/iwl-4965-calib.h}     |   30 +-
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c   |  774 +++
 .../iwl-4965-debugfs.h}                            |   35 +-
 .../iwl-legacy.h => iwlegacy/iwl-4965-eeprom.c}    |  107 +-
 .../wireless/{iwlwifi => iwlegacy}/iwl-4965-hw.h   |   26 +-
 .../iwl-3945-led.c => iwlegacy/iwl-4965-led.c}     |   49 +-
 .../iwl-3945-led.h => iwlegacy/iwl-4965-led.h}     |   11 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c       | 1260 +++++
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c        | 2870 +++++++++++
 .../iwl-agn-rx.c => iwlegacy/iwl-4965-rx.c}        |  177 +-
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c       |  721 +++
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c        | 1369 ++++++
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c     |  166 +
 .../net/wireless/{iwlwifi => iwlegacy}/iwl-4965.c  |  815 +---
 drivers/net/wireless/iwlegacy/iwl-4965.h           |  282 ++
 drivers/net/wireless/iwlegacy/iwl-commands.h       | 3405 +++++++++++++
 drivers/net/wireless/iwlegacy/iwl-core.c           | 2674 +++++++++++
 drivers/net/wireless/iwlegacy/iwl-core.h           |  646 +++
 drivers/net/wireless/iwlegacy/iwl-csr.h            |  422 ++
 drivers/net/wireless/iwlegacy/iwl-debug.h          |  198 +
 drivers/net/wireless/iwlegacy/iwl-debugfs.c        | 1467 ++++++
 drivers/net/wireless/iwlegacy/iwl-dev.h            | 1426 ++++++
 .../iwl-3945-led.h => iwlegacy/iwl-devtrace.c}     |   23 +-
 drivers/net/wireless/iwlegacy/iwl-devtrace.h       |  270 ++
 drivers/net/wireless/iwlegacy/iwl-eeprom.c         |  561 +++
 drivers/net/wireless/iwlegacy/iwl-eeprom.h         |  344 ++
 drivers/net/wireless/iwlegacy/iwl-fh.h             |  513 ++
 drivers/net/wireless/iwlegacy/iwl-hcmd.c           |  271 ++
 drivers/net/wireless/iwlegacy/iwl-helpers.h        |  181 +
 drivers/net/wireless/iwlegacy/iwl-io.h             |  545 +++
 drivers/net/wireless/iwlegacy/iwl-led.c            |  188 +
 .../{iwlwifi/iwl-3945-led.h => iwlegacy/iwl-led.h} |   34 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h      |  456 ++
 drivers/net/wireless/iwlegacy/iwl-power.c          |  165 +
 drivers/net/wireless/iwlegacy/iwl-power.h          |   55 +
 drivers/net/wireless/iwlegacy/iwl-prph.h           |  523 ++
 drivers/net/wireless/iwlegacy/iwl-rx.c             |  302 ++
 drivers/net/wireless/iwlegacy/iwl-scan.c           |  625 +++
 drivers/net/wireless/iwlegacy/iwl-spectrum.h       |   92 +
 drivers/net/wireless/iwlegacy/iwl-sta.c            |  816 ++++
 drivers/net/wireless/iwlegacy/iwl-sta.h            |  148 +
 drivers/net/wireless/iwlegacy/iwl-tx.c             |  660 +++
 .../wireless/{iwlwifi => iwlegacy}/iwl3945-base.c  |  566 ++--
 drivers/net/wireless/iwlegacy/iwl4965-base.c       | 3632 ++++++++++++++
 drivers/net/wireless/iwlwifi/Kconfig               |  132 +-
 drivers/net/wireless/iwlwifi/Makefile              |   40 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c            |  560 +++
 drivers/net/wireless/iwlwifi/iwl-5000.c            |    4 -
 drivers/net/wireless/iwlwifi/iwl-6000.c            |   59 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c       |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c     |   12 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c        |   18 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.c         |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.h         |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c         |  539 +--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |   29 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h          |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c        |  101 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c          |   21 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c       |    8 -
 drivers/net/wireless/iwlwifi/iwl-agn.c             |  582 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.h             |   49 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h        |  130 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  166 +-
 drivers/net/wireless/iwlwifi/iwl-core.h            |   66 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |   16 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c         |  119 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h             |   90 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c          |    8 -
 drivers/net/wireless/iwlwifi/iwl-eeprom.h          |   26 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c            |    6 +-
 drivers/net/wireless/iwlwifi/iwl-led.c             |  199 +-
 drivers/net/wireless/iwlwifi/iwl-led.h             |   16 +-
 drivers/net/wireless/iwlwifi/iwl-legacy.c          |  662 ---
 drivers/net/wireless/iwlwifi/iwl-power.c           |   12 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c              |  880 ++++-
 drivers/net/wireless/iwlwifi/iwl-scan.c            |   54 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c             |   11 -
 drivers/net/wireless/iwlwifi/iwl-tx.c              |   78 +-
 drivers/net/wireless/iwmc3200wifi/cfg80211.c       |    3 +-
 drivers/net/wireless/iwmc3200wifi/rx.c             |    7 +-
 drivers/net/wireless/libertas/cfg.c                |    6 +-
 drivers/net/wireless/libertas/cmd.c                |   10 +-
 drivers/net/wireless/libertas/dev.h                |    2 +
 drivers/net/wireless/libertas/host.h               |    2 +-
 drivers/net/wireless/libertas/if_spi.c             |  368 +-
 drivers/net/wireless/libertas/main.c               |   77 +-
 drivers/net/wireless/libertas/mesh.c               |   11 +-
 drivers/net/wireless/libertas_tf/main.c            |    3 +-
 drivers/net/wireless/mac80211_hwsim.c              |    8 +-
 drivers/net/wireless/mwl8k.c                       |  516 ++-
 drivers/net/wireless/orinoco/scan.c                |    5 +
 drivers/net/wireless/p54/Kconfig                   |    5 +-
 drivers/net/wireless/p54/eeprom.c                  |  211 +-
 drivers/net/wireless/p54/eeprom.h                  |    7 +
 drivers/net/wireless/p54/fwio.c                    |   21 +-
 drivers/net/wireless/p54/lmac.h                    |    3 +-
 drivers/net/wireless/p54/main.c                    |   61 +-
 drivers/net/wireless/p54/p54.h                     |    7 +-
 drivers/net/wireless/p54/p54spi_eeprom.h           |    9 +-
 drivers/net/wireless/p54/txrx.c                    |   19 +-
 drivers/net/wireless/rt2x00/Kconfig                |   12 +
 drivers/net/wireless/rt2x00/rt2400pci.c            |  183 +-
 drivers/net/wireless/rt2x00/rt2500pci.c            |  179 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |   17 +-
 drivers/net/wireless/rt2x00/rt2800.h               |  139 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |  917 +++-
 drivers/net/wireless/rt2x00/rt2800lib.h            |    4 +-
 drivers/net/wireless/rt2x00/rt2800pci.c            |  239 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |   67 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |   74 +-
 drivers/net/wireless/rt2x00/rt2x00ht.c             |   29 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h            |   24 +-
 drivers/net/wireless/rt2x00/rt2x00link.c           |    7 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c            |   75 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c            |    7 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  178 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h          |   29 +-
 drivers/net/wireless/rt2x00/rt2x00reg.h            |    2 -
 drivers/net/wireless/rt2x00/rt2x00usb.c            |    8 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |  251 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |   75 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |   10 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |   33 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h     |    2 +
 drivers/net/wireless/rtlwifi/Kconfig               |   24 +-
 drivers/net/wireless/rtlwifi/Makefile              |   15 +-
 drivers/net/wireless/rtlwifi/base.c                |   91 +-
 drivers/net/wireless/rtlwifi/base.h                |   39 +-
 drivers/net/wireless/rtlwifi/core.c                |   26 +-
 drivers/net/wireless/rtlwifi/debug.h               |    1 +
 drivers/net/wireless/rtlwifi/efuse.c               |   18 -
 drivers/net/wireless/rtlwifi/efuse.h               |    3 -
 drivers/net/wireless/rtlwifi/pci.c                 |  152 +-
 drivers/net/wireless/rtlwifi/pci.h                 |   12 +-
 drivers/net/wireless/rtlwifi/ps.c                  |   58 +-
 drivers/net/wireless/rtlwifi/rtl8192c/Makefile     |    9 +
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  | 1398 ++++++
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |  204 +
 .../{rtl8192ce/fw.c => rtl8192c/fw_common.c}       |   72 +-
 .../{rtl8192ce/fw.h => rtl8192c/fw_common.h}       |    0
 .../iwl-3945-led.h => rtlwifi/rtl8192c/main.c}     |   21 +-
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c | 2042 ++++++++
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h |  246 +
 drivers/net/wireless/rtlwifi/rtl8192ce/Makefile    |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h       |  144 +
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.c        | 1364 +------
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |  158 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h        |   11 +
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c       |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       | 2095 +--------
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.h       |   35 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h       |   73 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c        |   10 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.h        |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |   22 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.h        |   14 +
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |  183 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.h       |  464 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/Makefile    |   14 +
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h       |   62 +
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c        |  113 +
 .../iwl-3945-led.h => rtlwifi/rtl8192cu/dm.h}      |   16 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        | 2504 ++++++++++
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h        |  116 +
 drivers/net/wireless/rtlwifi/rtl8192cu/led.c       |  142 +
 .../iwl-3945-led.h => rtlwifi/rtl8192cu/led.h}     |   19 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c       | 1144 +++++
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h       |  180 +
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |  607 +++
 .../iwl-3945-led.h => rtlwifi/rtl8192cu/phy.h}     |   20 +-
 .../iwl-3945-led.h => rtlwifi/rtl8192cu/reg.h}     |   16 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |  493 ++
 .../iwl-3945-led.h => rtlwifi/rtl8192cu/rf.h}      |   29 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |  336 ++
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.h        |   53 +
 drivers/net/wireless/rtlwifi/rtl8192cu/table.c     | 1888 ++++++++
 drivers/net/wireless/rtlwifi/rtl8192cu/table.h     |   71 +
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |  687 +++
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h       |  430 ++
 drivers/net/wireless/rtlwifi/usb.c                 | 1035 ++++
 drivers/net/wireless/rtlwifi/usb.h                 |  164 +
 drivers/net/wireless/rtlwifi/wifi.h                |  680 ++-
 drivers/net/wireless/wl1251/acx.c                  |   53 +
 drivers/net/wireless/wl1251/acx.h                  |   72 +
 drivers/net/wireless/wl1251/event.c                |   18 +
 drivers/net/wireless/wl1251/main.c                 |   22 +-
 drivers/net/wireless/wl1251/ps.c                   |   52 +-
 drivers/net/wireless/wl1251/rx.c                   |   51 +-
 drivers/net/wireless/wl1251/tx.c                   |   74 +-
 drivers/net/wireless/wl1251/wl1251.h               |    7 +
 drivers/net/wireless/wl1251/wl12xx_80211.h         |    3 +-
 drivers/net/wireless/wl12xx/Kconfig                |    2 +-
 drivers/net/wireless/wl12xx/acx.c                  |  277 +-
 drivers/net/wireless/wl12xx/acx.h                  |  141 +-
 drivers/net/wireless/wl12xx/boot.c                 |   38 +-
 drivers/net/wireless/wl12xx/boot.h                 |    5 +
 drivers/net/wireless/wl12xx/cmd.c                  |  319 ++-
 drivers/net/wireless/wl12xx/cmd.h                  |  161 +-
 drivers/net/wireless/wl12xx/conf.h                 |  125 +-
 drivers/net/wireless/wl12xx/debugfs.c              |   51 +-
 drivers/net/wireless/wl12xx/event.c                |   21 +-
 drivers/net/wireless/wl12xx/event.h                |   10 +-
 drivers/net/wireless/wl12xx/init.c                 |  400 ++-
 drivers/net/wireless/wl12xx/init.h                 |    2 +-
 drivers/net/wireless/wl12xx/io.h                   |    1 +
 drivers/net/wireless/wl12xx/main.c                 | 1462 +++++--
 drivers/net/wireless/wl12xx/ps.c                   |   90 +-
 drivers/net/wireless/wl12xx/ps.h                   |    4 +-
 drivers/net/wireless/wl12xx/rx.c                   |   37 +-
 drivers/net/wireless/wl12xx/rx.h                   |   17 +-
 drivers/net/wireless/wl12xx/scan.c                 |   20 +-
 drivers/net/wireless/wl12xx/sdio.c                 |   43 +-
 drivers/net/wireless/wl12xx/spi.c                  |   21 +-
 drivers/net/wireless/wl12xx/tx.c                   |  365 ++-
 drivers/net/wireless/wl12xx/tx.h                   |   15 +-
 drivers/net/wireless/wl12xx/wl12xx.h               |  211 +-
 drivers/net/wireless/wl12xx/wl12xx_80211.h         |   14 +-
 drivers/net/wireless/zd1211rw/zd_chip.c            |  169 +-
 drivers/net/wireless/zd1211rw/zd_chip.h            |    5 +-
 drivers/net/wireless/zd1211rw/zd_def.h             |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |  453 ++-
 drivers/net/wireless/zd1211rw/zd_mac.h             |   24 +-
 drivers/net/wireless/zd1211rw/zd_usb.c             |  597 ++-
 drivers/net/wireless/zd1211rw/zd_usb.h             |   37 +-
 drivers/net/xen-netback/Makefile                   |    3 +
 drivers/net/xen-netback/common.h                   |  161 +
 drivers/net/xen-netback/interface.c                |  424 ++
 drivers/net/xen-netback/netback.c                  | 1745 +++++++
 drivers/net/xen-netback/xenbus.c                   |  490 ++
 drivers/net/xen-netfront.c                         |   24 +-
 drivers/s390/net/qeth_core.h                       |    4 +-
 drivers/s390/net/qeth_core_main.c                  |   57 +-
 drivers/s390/net/qeth_l2_main.c                    |   45 +-
 drivers/s390/net/qeth_l3_main.c                    |   60 +-
 drivers/scsi/cxgbi/cxgb3i/Kconfig                  |    4 +-
 drivers/scsi/cxgbi/cxgb4i/Kconfig                  |    4 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |   21 +-
 drivers/scsi/fcoe/fcoe.c                           |    4 +-
 drivers/ssb/main.c                                 |   44 +-
 drivers/ssb/pci.c                                  |    6 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    4 +-
 drivers/staging/brcm80211/sys/wl_mac80211.c        |   28 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |    5 +-
 drivers/staging/pohmelfs/config.c                  |    2 +-
 drivers/staging/winbond/wbusb.c                    |    7 +-
 drivers/video/uvesafb.c                            |    2 +-
 drivers/xen/events.c                               |   38 +
 firmware/Makefile                                  |    2 +-
 firmware/WHENCE                                    |    2 +-
 ...9-6.2.1.fw.ihex => bnx2-mips-09-6.2.1a.fw.ihex} | 5006 ++++++++++----------
 include/linux/audit.h                              |    2 +
 include/linux/cpu_rmap.h                           |   73 +
 include/linux/dcbnl.h                              |  113 +-
 include/linux/dccp.h                               |    2 -
 include/linux/ethtool.h                            |   91 +-
 include/linux/icmpv6.h                             |    4 +-
 include/linux/ieee80211.h                          |    3 +
 include/linux/if.h                                 |    9 +-
 include/linux/if_link.h                            |    1 +
 include/linux/igmp.h                               |    2 +-
 include/linux/inetdevice.h                         |    1 +
 include/linux/interrupt.h                          |   33 +-
 include/linux/ip_vs.h                              |    8 +
 include/linux/irqdesc.h                            |    3 +
 include/linux/micrel_phy.h                         |   16 +
 include/linux/net.h                                |    3 +-
 include/linux/netdevice.h                          |  305 ++-
 include/linux/netfilter.h                          |   27 +-
 include/linux/netfilter/Kbuild                     |    7 +
 include/linux/netfilter/ipset/Kbuild               |    4 +
 include/linux/netfilter/ipset/ip_set.h             |  452 ++
 include/linux/netfilter/ipset/ip_set_ahash.h       | 1074 +++++
 include/linux/netfilter/ipset/ip_set_bitmap.h      |   31 +
 include/linux/netfilter/ipset/ip_set_getport.h     |   21 +
 include/linux/netfilter/ipset/ip_set_hash.h        |   26 +
 include/linux/netfilter/ipset/ip_set_list.h        |   27 +
 include/linux/netfilter/ipset/ip_set_timeout.h     |  127 +
 include/linux/netfilter/ipset/pfxlen.h             |   35 +
 include/linux/netfilter/nf_conntrack_snmp.h        |    9 +
 include/linux/netfilter/nfnetlink.h                |    3 +-
 include/linux/netfilter/nfnetlink_conntrack.h      |    9 +
 include/linux/netfilter/x_tables.h                 |    3 +-
 include/linux/netfilter/xt_AUDIT.h                 |   30 +
 include/linux/netfilter/xt_CT.h                    |   12 +-
 include/linux/netfilter/xt_NFQUEUE.h               |    6 +
 include/linux/netfilter/xt_TCPOPTSTRIP.h           |    4 +-
 include/linux/netfilter/xt_TPROXY.h                |   10 +-
 include/linux/netfilter/xt_addrtype.h              |   44 +
 include/linux/netfilter/xt_cluster.h               |   10 +-
 include/linux/netfilter/xt_comment.h               |    2 +-
 include/linux/netfilter/xt_connlimit.h             |   16 +-
 include/linux/netfilter/xt_conntrack.h             |   15 +
 include/linux/netfilter/xt_devgroup.h              |   21 +
 include/linux/netfilter/xt_quota.h                 |    8 +-
 include/linux/netfilter/xt_set.h                   |   56 +
 include/linux/netfilter/xt_socket.h                |    2 +
 include/linux/netfilter/xt_time.h                  |   16 +-
 include/linux/netfilter/xt_u32.h                   |   18 +-
 include/linux/netfilter_bridge/ebt_802_3.h         |   26 +-
 include/linux/netfilter_bridge/ebt_among.h         |    4 +-
 include/linux/netfilter_bridge/ebt_arp.h           |    6 +-
 include/linux/netfilter_bridge/ebt_ip.h            |   14 +-
 include/linux/netfilter_bridge/ebt_ip6.h           |   25 +-
 include/linux/netfilter_bridge/ebt_limit.h         |   10 +-
 include/linux/netfilter_bridge/ebt_log.h           |    8 +-
 include/linux/netfilter_bridge/ebt_mark_m.h        |    6 +-
 include/linux/netfilter_bridge/ebt_nflog.h         |   12 +-
 include/linux/netfilter_bridge/ebt_pkttype.h       |    6 +-
 include/linux/netfilter_bridge/ebt_stp.h           |   26 +-
 include/linux/netfilter_bridge/ebt_ulog.h          |    4 +-
 include/linux/netfilter_bridge/ebt_vlan.h          |   10 +-
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h       |   16 +-
 include/linux/netfilter_ipv4/ipt_ECN.h             |    8 +-
 include/linux/netfilter_ipv4/ipt_SAME.h            |    8 +-
 include/linux/netfilter_ipv4/ipt_TTL.h             |    6 +-
 include/linux/netfilter_ipv4/ipt_addrtype.h        |   16 +-
 include/linux/netfilter_ipv4/ipt_ah.h              |    6 +-
 include/linux/netfilter_ipv4/ipt_ecn.h             |   10 +-
 include/linux/netfilter_ipv4/ipt_ttl.h             |    6 +-
 include/linux/netfilter_ipv6/ip6t_HL.h             |    6 +-
 include/linux/netfilter_ipv6/ip6t_REJECT.h         |    4 +-
 include/linux/netfilter_ipv6/ip6t_ah.h             |   10 +-
 include/linux/netfilter_ipv6/ip6t_frag.h           |   10 +-
 include/linux/netfilter_ipv6/ip6t_hl.h             |    6 +-
 include/linux/netfilter_ipv6/ip6t_ipv6header.h     |    8 +-
 include/linux/netfilter_ipv6/ip6t_mh.h             |    6 +-
 include/linux/netfilter_ipv6/ip6t_opts.h           |   12 +-
 include/linux/netfilter_ipv6/ip6t_rt.h             |   13 +-
 include/linux/netlink.h                            |    4 -
 include/linux/nl80211.h                            |    3 +
 include/linux/pci.h                                |    1 +
 include/linux/phonet.h                             |    4 +-
 include/linux/pkt_sched.h                          |  107 +
 include/linux/security.h                           |    7 +-
 include/linux/skbuff.h                             |   16 +-
 include/linux/sockios.h                            |    4 +-
 include/linux/ssb/ssb_regs.h                       |    7 +-
 include/linux/tipc.h                               |    8 +-
 include/linux/tipc_config.h                        |   38 +-
 include/linux/xfrm.h                               |   13 +
 include/net/bluetooth/bluetooth.h                  |   33 +
 include/net/bluetooth/hci.h                        |  139 +
 include/net/bluetooth/hci_core.h                   |  173 +-
 include/net/bluetooth/l2cap.h                      |   53 +-
 include/net/bluetooth/mgmt.h                       |  171 +-
 include/net/bluetooth/smp.h                        |   76 +
 include/net/cfg80211.h                             |   16 +-
 include/net/dcbnl.h                                |    9 +
 include/net/dn.h                                   |    6 +-
 include/net/dn_fib.h                               |    8 +-
 include/net/dn_route.h                             |    8 +-
 include/net/dst.h                                  |  142 +-
 include/net/dst_ops.h                              |    1 +
 include/net/flow.h                                 |  204 +-
 include/net/icmp.h                                 |    3 -
 include/net/ieee80211_radiotap.h                   |   25 +
 include/net/inet_sock.h                            |   31 +-
 include/net/inetpeer.h                             |   44 +-
 include/net/ip.h                                   |   16 +
 include/net/ip6_fib.h                              |    5 +-
 include/net/ip6_route.h                            |    2 +-
 include/net/ip_fib.h                               |   43 +-
 include/net/ip_vs.h                                |  477 ++-
 include/net/ipv6.h                                 |   28 +-
 include/net/mac80211.h                             |  106 +-
 include/net/net_namespace.h                        |    2 +
 include/net/netevent.h                             |    1 -
 include/net/netfilter/nf_conntrack.h               |   23 +-
 include/net/netfilter/nf_conntrack_ecache.h        |   12 +-
 include/net/netfilter/nf_conntrack_extend.h        |   10 +
 include/net/netfilter/nf_conntrack_helper.h        |    6 +
 include/net/netfilter/nf_conntrack_l3proto.h       |    2 +-
 include/net/netfilter/nf_conntrack_timestamp.h     |   65 +
 include/net/netfilter/nf_nat.h                     |    6 +
 include/net/netfilter/nf_nat_core.h                |    4 +-
 include/net/netlink.h                              |    9 +
 include/net/netns/conntrack.h                      |    4 +-
 include/net/netns/ipv4.h                           |    1 -
 include/net/phonet/pep.h                           |   23 +-
 include/net/phonet/phonet.h                        |    1 +
 include/net/protocol.h                             |    4 +-
 include/net/route.h                                |  164 +-
 include/net/sch_generic.h                          |   60 +-
 include/net/sock.h                                 |    9 +-
 include/net/tcp.h                                  |   16 +-
 include/net/transp_v6.h                            |    4 +-
 include/net/udp.h                                  |   13 +-
 include/net/udplite.h                              |   12 +
 include/net/xfrm.h                                 |  213 +-
 include/xen/events.h                               |    6 +
 include/xen/interface/io/netif.h                   |   80 +-
 kernel/audit.c                                     |    8 +-
 kernel/auditfilter.c                               |   10 +-
 kernel/irq/manage.c                                |   82 +
 lib/Kconfig                                        |   13 +-
 lib/Makefile                                       |    2 +
 lib/cpu_rmap.c                                     |  269 ++
 net/8021q/vlan.c                                   |    2 +-
 net/8021q/vlan_dev.c                               |   14 +
 net/9p/trans_rdma.c                                |    1 -
 net/Kconfig                                        |    6 +
 net/atm/clip.c                                     |    8 +-
 net/batman-adv/Makefile                            |    2 +-
 net/batman-adv/aggregation.c                       |   10 +-
 net/batman-adv/aggregation.h                       |    6 +-
 net/batman-adv/bat_debugfs.c                       |    6 +-
 net/batman-adv/bat_debugfs.h                       |    2 +-
 net/batman-adv/bat_sysfs.c                         |   53 +-
 net/batman-adv/bat_sysfs.h                         |    2 +-
 net/batman-adv/bitarray.c                          |    2 +-
 net/batman-adv/bitarray.h                          |    2 +-
 net/batman-adv/gateway_client.c                    |  142 +-
 net/batman-adv/gateway_client.h                    |    2 +-
 net/batman-adv/gateway_common.c                    |    2 +-
 net/batman-adv/gateway_common.h                    |    2 +-
 net/batman-adv/hard-interface.c                    |  420 +-
 net/batman-adv/hard-interface.h                    |   21 +-
 net/batman-adv/hash.c                              |   28 +-
 net/batman-adv/hash.h                              |  119 +-
 net/batman-adv/icmp_socket.c                       |   43 +-
 net/batman-adv/icmp_socket.h                       |    4 +-
 net/batman-adv/main.c                              |   16 +-
 net/batman-adv/main.h                              |   29 +-
 net/batman-adv/originator.c                        |  254 +-
 net/batman-adv/originator.h                        |   52 +-
 net/batman-adv/packet.h                            |    3 +-
 net/batman-adv/ring_buffer.c                       |    2 +-
 net/batman-adv/ring_buffer.h                       |    2 +-
 net/batman-adv/routing.c                           | 1000 +++--
 net/batman-adv/routing.h                           |   30 +-
 net/batman-adv/send.c                              |  110 +-
 net/batman-adv/send.h                              |   12 +-
 net/batman-adv/soft-interface.c                    |   77 +-
 net/batman-adv/soft-interface.h                    |    5 +-
 net/batman-adv/translation-table.c                 |  208 +-
 net/batman-adv/translation-table.h                 |    4 +-
 net/batman-adv/types.h                             |   50 +-
 net/batman-adv/unicast.c                           |  121 +-
 net/batman-adv/unicast.h                           |   27 +-
 net/batman-adv/vis.c                               |  194 +-
 net/batman-adv/vis.h                               |    2 +-
 net/bluetooth/Kconfig                              |   20 +-
 net/bluetooth/Makefile                             |    4 +-
 net/bluetooth/af_bluetooth.c                       |   51 +-
 net/bluetooth/bnep/core.c                          |    2 -
 net/bluetooth/bnep/sock.c                          |    1 +
 net/bluetooth/cmtp/capi.c                          |    3 +-
 net/bluetooth/cmtp/core.c                          |   11 +-
 net/bluetooth/hci_conn.c                           |   80 +-
 net/bluetooth/hci_core.c                           |  345 ++-
 net/bluetooth/hci_event.c                          |  691 +++-
 net/bluetooth/hci_sock.c                           |    8 +-
 net/bluetooth/hci_sysfs.c                          |   58 +-
 net/bluetooth/hidp/core.c                          |   11 +-
 net/bluetooth/{l2cap.c => l2cap_core.c}            | 1723 ++-----
 net/bluetooth/l2cap_sock.c                         | 1156 +++++
 net/bluetooth/mgmt.c                               | 1585 ++++++-
 net/bluetooth/rfcomm/core.c                        |    2 -
 net/bluetooth/sco.c                                |   24 +-
 net/bridge/br_device.c                             |   21 +
 net/bridge/br_if.c                                 |   15 +-
 net/bridge/br_input.c                              |   25 +-
 net/bridge/br_netfilter.c                          |   14 +-
 net/bridge/br_private.h                            |    4 +-
 net/bridge/br_stp.c                                |   39 +-
 net/bridge/br_stp_timer.c                          |    1 +
 net/bridge/netfilter/ebt_ip6.c                     |   46 +-
 net/bridge/netfilter/ebtables.c                    |    3 +
 net/caif/cfcnfg.c                                  |    2 -
 net/caif/cfdgml.c                                  |    1 -
 net/caif/cfserl.c                                  |    1 -
 net/caif/cfutill.c                                 |    2 +-
 net/caif/cfveil.c                                  |    2 +-
 net/core/dev.c                                     |  463 ++-
 net/core/dst.c                                     |   43 +-
 net/core/ethtool.c                                 |  604 ++-
 net/core/fib_rules.c                               |    6 +-
 net/core/filter.c                                  |    6 +-
 net/core/flow.c                                    |   14 +-
 net/core/neighbour.c                               |   13 +-
 net/core/net-sysfs.c                               |   17 +-
 net/core/netpoll.c                                 |   13 +-
 net/core/pktgen.c                                  |  233 +-
 net/core/rtnetlink.c                               |   86 +-
 net/core/skbuff.c                                  |    8 +-
 net/dcb/dcbnl.c                                    |  148 +-
 net/dccp/ccids/ccid2.c                             |    9 +
 net/dccp/ipv4.c                                    |   50 +-
 net/dccp/ipv6.c                                    |  188 +-
 net/decnet/af_decnet.c                             |   16 +-
 net/decnet/dn_fib.c                                |   23 +-
 net/decnet/dn_nsp_out.c                            |   16 +-
 net/decnet/dn_route.c                              |  300 +-
 net/decnet/dn_rules.c                              |   17 +-
 net/decnet/dn_table.c                              |    7 +-
 net/dsa/mv88e6060.c                                |    7 +-
 net/ipv4/Kconfig                                   |   42 +-
 net/ipv4/Makefile                                  |    4 +-
 net/ipv4/af_inet.c                                 |   46 +-
 net/ipv4/ah4.c                                     |   27 +-
 net/ipv4/arp.c                                     |   25 +-
 net/ipv4/datagram.c                                |   11 +-
 net/ipv4/devinet.c                                 |   78 +
 net/ipv4/esp4.c                                    |  104 +-
 net/ipv4/fib_frontend.c                            |  105 +-
 net/ipv4/fib_hash.c                                | 1133 -----
 net/ipv4/fib_lookup.h                              |   10 +-
 net/ipv4/fib_rules.c                               |   25 +-
 net/ipv4/fib_semantics.c                           |  257 +-
 net/ipv4/fib_trie.c                                |  272 +-
 net/ipv4/icmp.c                                    |  240 +-
 net/ipv4/igmp.c                                    |   45 +-
 net/ipv4/inet_connection_sock.c                    |   27 +-
 net/ipv4/inetpeer.c                                |  148 +-
 net/ipv4/ip_gre.c                                  |   56 +-
 net/ipv4/ip_input.c                                |    2 +-
 net/ipv4/ip_output.c                               |  345 +-
 net/ipv4/ipip.c                                    |   39 +-
 net/ipv4/ipmr.c                                    |   79 +-
 net/ipv4/netfilter.c                               |   36 +-
 net/ipv4/netfilter/Kconfig                         |   13 +-
 net/ipv4/netfilter/Makefile                        |    1 -
 net/ipv4/netfilter/arp_tables.c                    |    5 +
 net/ipv4/netfilter/ip_tables.c                     |    5 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |    7 +-
 net/ipv4/netfilter/ipt_LOG.c                       |    3 +-
 net/ipv4/netfilter/ipt_addrtype.c                  |  134 -
 net/ipv4/netfilter/iptable_mangle.c                |    2 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |   17 +-
 net/ipv4/netfilter/nf_nat_amanda.c                 |    8 +-
 net/ipv4/netfilter/nf_nat_core.c                   |   33 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |    9 +-
 net/ipv4/netfilter/nf_nat_standalone.c             |    9 +-
 net/ipv4/raw.c                                     |   39 +-
 net/ipv4/route.c                                   | 1181 +++---
 net/ipv4/syncookies.c                              |   25 +-
 net/ipv4/tcp.c                                     |   20 +-
 net/ipv4/tcp_bic.c                                 |    2 +-
 net/ipv4/tcp_cubic.c                               |   47 +-
 net/ipv4/tcp_highspeed.c                           |    2 +-
 net/ipv4/tcp_htcp.c                                |    2 +-
 net/ipv4/tcp_hybla.c                               |    2 +-
 net/ipv4/tcp_illinois.c                            |    2 +-
 net/ipv4/tcp_input.c                               |    4 +-
 net/ipv4/tcp_ipv4.c                                |   37 +-
 net/ipv4/tcp_lp.c                                  |    2 +-
 net/ipv4/tcp_scalable.c                            |    2 +-
 net/ipv4/tcp_timer.c                               |    3 -
 net/ipv4/tcp_vegas.c                               |    2 +-
 net/ipv4/tcp_veno.c                                |    2 +-
 net/ipv4/tcp_westwood.c                            |    2 +-
 net/ipv4/tcp_yeah.c                                |    2 +-
 net/ipv4/udp.c                                     |  139 +-
 net/ipv4/xfrm4_policy.c                            |   74 +-
 net/ipv4/xfrm4_state.c                             |   20 +-
 net/ipv6/addrconf.c                                |    3 -
 net/ipv6/af_inet6.c                                |   49 +-
 net/ipv6/ah6.c                                     |    2 +-
 net/ipv6/datagram.c                                |   88 +-
 net/ipv6/esp6.c                                    |  109 +-
 net/ipv6/exthdrs.c                                 |   12 +-
 net/ipv6/fib6_rules.c                              |   19 +-
 net/ipv6/icmp.c                                    |  226 +-
 net/ipv6/inet6_connection_sock.c                   |   81 +-
 net/ipv6/ip6_fib.c                                 |    4 +-
 net/ipv6/ip6_flowlabel.c                           |    6 +-
 net/ipv6/ip6_output.c                              |  156 +-
 net/ipv6/ip6_tunnel.c                              |   82 +-
 net/ipv6/ip6mr.c                                   |   56 +-
 net/ipv6/ipv6_sockglue.c                           |   10 +-
 net/ipv6/mcast.c                                   |   27 +-
 net/ipv6/mip6.c                                    |   16 +-
 net/ipv6/ndisc.c                                   |   22 +-
 net/ipv6/netfilter.c                               |   19 +-
 net/ipv6/netfilter/ip6_tables.c                    |    5 +
 net/ipv6/netfilter/ip6t_LOG.c                      |    3 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |   21 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |    3 +-
 net/ipv6/raw.c                                     |  106 +-
 net/ipv6/route.c                                   |  186 +-
 net/ipv6/sit.c                                     |   56 +-
 net/ipv6/syncookies.c                              |   31 +-
 net/ipv6/tcp_ipv6.c                                |  169 +-
 net/ipv6/udp.c                                     |   91 +-
 net/ipv6/xfrm6_policy.c                            |   49 +-
 net/ipv6/xfrm6_state.c                             |   20 +-
 net/key/af_key.c                                   |  243 +-
 net/l2tp/l2tp_ip.c                                 |   36 +-
 net/llc/llc_input.c                                |   25 +-
 net/mac80211/Kconfig                               |    4 +-
 net/mac80211/agg-rx.c                              |    7 +-
 net/mac80211/agg-tx.c                              |   23 +-
 net/mac80211/cfg.c                                 |  116 +-
 net/mac80211/chan.c                                |    3 +
 net/mac80211/debugfs.c                             |    6 +
 net/mac80211/debugfs_netdev.c                      |  122 +-
 net/mac80211/driver-ops.h                          |   67 +-
 net/mac80211/driver-trace.h                        |  274 +-
 net/mac80211/ht.c                                  |    5 +-
 net/mac80211/ibss.c                                |   21 +-
 net/mac80211/ieee80211_i.h                         |   17 +-
 net/mac80211/iface.c                               |    9 +-
 net/mac80211/key.h                                 |    1 -
 net/mac80211/main.c                                |   88 +-
 net/mac80211/mesh.c                                |    4 +-
 net/mac80211/mlme.c                                |  144 +-
 net/mac80211/offchannel.c                          |   68 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   60 +-
 net/mac80211/rc80211_pid.h                         |    3 -
 net/mac80211/rx.c                                  |  130 +-
 net/mac80211/scan.c                                |  138 +-
 net/mac80211/sta_info.c                            |    3 +-
 net/mac80211/sta_info.h                            |    6 +
 net/mac80211/status.c                              |   10 +-
 net/mac80211/tx.c                                  |  194 +-
 net/mac80211/util.c                                |    6 -
 net/mac80211/work.c                                |  122 +-
 net/mac80211/wpa.c                                 |   39 +-
 net/netfilter/Kconfig                              |   77 +-
 net/netfilter/Makefile                             |   10 +
 net/netfilter/core.c                               |   20 +-
 net/netfilter/ipset/Kconfig                        |  122 +
 net/netfilter/ipset/Makefile                       |   24 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |  587 +++
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |  652 +++
 net/netfilter/ipset/ip_set_bitmap_port.c           |  515 ++
 net/netfilter/ipset/ip_set_core.c                  | 1671 +++++++
 net/netfilter/ipset/ip_set_getport.c               |  141 +
 net/netfilter/ipset/ip_set_hash_ip.c               |  464 ++
 net/netfilter/ipset/ip_set_hash_ipport.c           |  544 +++
 net/netfilter/ipset/ip_set_hash_ipportip.c         |  562 +++
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |  628 +++
 net/netfilter/ipset/ip_set_hash_net.c              |  458 ++
 net/netfilter/ipset/ip_set_hash_netport.c          |  578 +++
 net/netfilter/ipset/ip_set_list_set.c              |  584 +++
 net/netfilter/ipset/pfxlen.c                       |  291 ++
 net/netfilter/ipvs/ip_vs_app.c                     |   98 +-
 net/netfilter/ipvs/ip_vs_conn.c                    |  248 +-
 net/netfilter/ipvs/ip_vs_core.c                    |  456 ++-
 net/netfilter/ipvs/ip_vs_ctl.c                     | 1002 +++--
 net/netfilter/ipvs/ip_vs_est.c                     |  171 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |   61 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |   99 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |  114 +-
 net/netfilter/ipvs/ip_vs_lc.c                      |   20 +-
 net/netfilter/ipvs/ip_vs_nfct.c                    |    6 +-
 net/netfilter/ipvs/ip_vs_nq.c                      |    2 +-
 net/netfilter/ipvs/ip_vs_pe.c                      |   17 +-
 net/netfilter/ipvs/ip_vs_pe_sip.c                  |   12 +-
 net/netfilter/ipvs/ip_vs_proto.c                   |  129 +-
 net/netfilter/ipvs/ip_vs_proto_ah_esp.c            |   45 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |  153 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |  142 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c               |  110 +-
 net/netfilter/ipvs/ip_vs_rr.c                      |    2 +-
 net/netfilter/ipvs/ip_vs_sched.c                   |   25 +
 net/netfilter/ipvs/ip_vs_sed.c                     |    2 +-
 net/netfilter/ipvs/ip_vs_sh.c                      |    2 +-
 net/netfilter/ipvs/ip_vs_sync.c                    | 1238 ++++-
 net/netfilter/ipvs/ip_vs_wlc.c                     |   22 +-
 net/netfilter/ipvs/ip_vs_wrr.c                     |   14 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |  117 +-
 net/netfilter/nf_conntrack_broadcast.c             |   82 +
 net/netfilter/nf_conntrack_core.c                  |   58 +-
 net/netfilter/nf_conntrack_expect.c                |   34 +-
 net/netfilter/nf_conntrack_extend.c                |   11 +-
 net/netfilter/nf_conntrack_h323_main.c             |   32 +-
 net/netfilter/nf_conntrack_helper.c                |   20 +-
 net/netfilter/nf_conntrack_netbios_ns.c            |   74 +-
 net/netfilter/nf_conntrack_netlink.c               |   49 +-
 net/netfilter/nf_conntrack_proto.c                 |   24 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |    3 +
 net/netfilter/nf_conntrack_proto_sctp.c            |    1 +
 net/netfilter/nf_conntrack_proto_tcp.c             |   18 +-
 net/netfilter/nf_conntrack_snmp.c                  |   77 +
 net/netfilter/nf_conntrack_standalone.c            |   45 +-
 net/netfilter/nf_conntrack_timestamp.c             |  120 +
 net/netfilter/nf_log.c                             |    6 +-
 net/netfilter/nf_queue.c                           |   82 +-
 net/netfilter/nfnetlink_log.c                      |    9 +-
 net/netfilter/nfnetlink_queue.c                    |   22 +-
 net/netfilter/x_tables.c                           |  124 +-
 net/netfilter/xt_AUDIT.c                           |  222 +
 net/netfilter/xt_CLASSIFY.c                        |   36 +-
 net/netfilter/xt_IDLETIMER.c                       |    2 +
 net/netfilter/xt_LED.c                             |    2 +
 net/netfilter/xt_NFQUEUE.c                         |   34 +-
 net/netfilter/xt_TCPMSS.c                          |   15 +-
 net/netfilter/xt_TEE.c                             |   27 +-
 net/netfilter/xt_addrtype.c                        |  229 +
 net/netfilter/xt_connlimit.c                       |   99 +-
 net/netfilter/xt_conntrack.c                       |   80 +-
 net/netfilter/xt_cpu.c                             |    2 +
 net/netfilter/xt_devgroup.c                        |   82 +
 net/netfilter/xt_iprange.c                         |   18 +-
 net/netfilter/xt_ipvs.c                            |    2 +-
 net/netfilter/xt_set.c                             |  359 ++
 net/netlabel/netlabel_user.h                       |    6 +-
 net/netlink/af_netlink.c                           |    9 -
 net/packet/af_packet.c                             |   41 +-
 net/phonet/Kconfig                                 |   12 -
 net/phonet/af_phonet.c                             |   32 +-
 net/phonet/pep.c                                   |  834 ++--
 net/phonet/socket.c                                |  126 +-
 net/rds/rds.h                                      |    1 -
 net/rose/af_rose.c                                 |    7 -
 net/rose/rose_route.c                              |   28 +-
 net/rxrpc/ar-peer.c                                |   28 +-
 net/sched/Kconfig                                  |   39 +-
 net/sched/Makefile                                 |    4 +
 net/sched/act_api.c                                |   46 +-
 net/sched/act_csum.c                               |    2 +-
 net/sched/act_gact.c                               |    8 +-
 net/sched/act_ipt.c                                |   16 +-
 net/sched/act_mirred.c                             |    4 +-
 net/sched/act_nat.c                                |    2 +-
 net/sched/act_pedit.c                              |   10 +-
 net/sched/act_police.c                             |    9 +-
 net/sched/act_simple.c                             |   10 +-
 net/sched/act_skbedit.c                            |    8 +-
 net/sched/cls_api.c                                |   33 +-
 net/sched/cls_basic.c                              |   17 +-
 net/sched/cls_cgroup.c                             |    8 +-
 net/sched/cls_flow.c                               |    6 +-
 net/sched/cls_fw.c                                 |   38 +-
 net/sched/cls_route.c                              |  126 +-
 net/sched/cls_rsvp.h                               |   95 +-
 net/sched/cls_tcindex.c                            |    2 +-
 net/sched/cls_u32.c                                |   89 +-
 net/sched/em_cmp.c                                 |   47 +-
 net/sched/em_meta.c                                |   48 +-
 net/sched/em_nbyte.c                               |    3 +-
 net/sched/em_text.c                                |    3 +-
 net/sched/em_u32.c                                 |    2 +-
 net/sched/ematch.c                                 |   37 +-
 net/sched/sch_api.c                                |  173 +-
 net/sched/sch_atm.c                                |   16 +-
 net/sched/sch_cbq.c                                |  362 +-
 net/sched/sch_choke.c                              |  688 +++
 net/sched/sch_dsmark.c                             |   21 +-
 net/sched/sch_fifo.c                               |   50 +-
 net/sched/sch_generic.c                            |   58 +-
 net/sched/sch_gred.c                               |   85 +-
 net/sched/sch_hfsc.c                               |   37 +-
 net/sched/sch_htb.c                                |  106 +-
 net/sched/sch_mq.c                                 |    1 -
 net/sched/sch_mqprio.c                             |  418 ++
 net/sched/sch_multiq.c                             |    8 +-
 net/sched/sch_netem.c                              |  411 ++-
 net/sched/sch_prio.c                               |   34 +-
 net/sched/sch_red.c                                |   61 +-
 net/sched/sch_sfb.c                                |  709 +++
 net/sched/sch_sfq.c                                |   67 +-
 net/sched/sch_tbf.c                                |   39 +-
 net/sched/sch_teql.c                               |   36 +-
 net/sctp/associola.c                               |    2 -
 net/sctp/input.c                                   |    3 -
 net/sctp/ipv6.c                                    |   42 +-
 net/sctp/outqueue.c                                |    2 -
 net/sctp/protocol.c                                |   33 +-
 net/sctp/sm_make_chunk.c                           |    3 -
 net/sctp/socket.c                                  |   11 +-
 net/sctp/tsnmap.c                                  |    2 +-
 net/sctp/ulpqueue.c                                |    7 +-
 net/socket.c                                       |   31 +-
 net/sunrpc/svcsock.c                               |   32 +-
 net/tipc/Kconfig                                   |   12 -
 net/tipc/addr.c                                    |   15 +-
 net/tipc/addr.h                                    |   17 +-
 net/tipc/bcast.c                                   |   47 +-
 net/tipc/bcast.h                                   |    3 +-
 net/tipc/bearer.c                                  |  116 +-
 net/tipc/bearer.h                                  |   73 +-
 net/tipc/config.c                                  |   31 +-
 net/tipc/core.c                                    |    9 +-
 net/tipc/core.h                                    |    4 +-
 net/tipc/discover.c                                |  140 +-
 net/tipc/discover.h                                |    9 +-
 net/tipc/link.c                                    |  130 +-
 net/tipc/link.h                                    |   29 +-
 net/tipc/msg.c                                     |   41 +-
 net/tipc/msg.h                                     |   64 +-
 net/tipc/name_distr.c                              |   18 +-
 net/tipc/net.c                                     |   32 +-
 net/tipc/net.h                                     |   19 +-
 net/tipc/node.c                                    |  125 +-
 net/tipc/node.h                                    |   36 +-
 net/tipc/node_subscr.c                             |   21 +-
 net/tipc/node_subscr.h                             |    3 +-
 net/tipc/port.c                                    |  306 +-
 net/tipc/port.h                                    |   73 +-
 net/tipc/socket.c                                  |   76 +-
 net/tipc/subscr.c                                  |   13 +-
 net/unix/af_unix.c                                 |   72 +-
 net/wanrouter/wanmain.c                            |    2 -
 net/wireless/core.c                                |   20 +-
 net/wireless/ethtool.c                             |   33 +
 net/wireless/nl80211.c                             |   62 +-
 net/wireless/reg.c                                 |   45 +-
 net/wireless/reg.h                                 |    1 +
 net/wireless/util.c                                |   47 +-
 net/wireless/wext-compat.c                         |    5 +-
 net/xfrm/Makefile                                  |    2 +-
 net/xfrm/xfrm_algo.c                               |    8 +-
 net/xfrm/xfrm_hash.h                               |   32 +-
 net/xfrm/xfrm_input.c                              |   13 +-
 net/xfrm/xfrm_output.c                             |   15 +-
 net/xfrm/xfrm_policy.c                             |  218 +-
 net/xfrm/xfrm_replay.c                             |  534 +++
 net/xfrm/xfrm_state.c                              |  175 +-
 net/xfrm/xfrm_user.c                               |  209 +-
 security/capability.c                              |    2 +-
 security/commoncap.c                               |    3 +-
 security/security.c                                |    7 +-
 security/selinux/hooks.c                           |    8 +-
 security/selinux/include/xfrm.h                    |    2 +-
 security/selinux/xfrm.c                            |    6 +-
 1146 files changed, 118995 insertions(+), 38180 deletions(-)
 create mode 100644 crypto/authencesn.c
 create mode 100644 drivers/net/bonding/bond_procfs.c
 create mode 100644 drivers/net/can/c_can/Kconfig
 create mode 100644 drivers/net/can/c_can/Makefile
 create mode 100644 drivers/net/can/c_can/c_can.c
 create mode 100644 drivers/net/can/c_can/c_can.h
 create mode 100644 drivers/net/can/c_can/c_can_platform.c
 create mode 100644 drivers/net/enic/enic_dev.c
 create mode 100644 drivers/net/enic/enic_dev.h
 create mode 100644 drivers/net/ftmac100.c
 create mode 100644 drivers/net/ftmac100.h
 create mode 100644 drivers/net/wireless/ath/ath5k/trace.h
 delete mode 100644 drivers/net/wireless/ath/ath9k/virtual.c
 create mode 100644 drivers/net/wireless/iwlegacy/Kconfig
 create mode 100644 drivers/net/wireless/iwlegacy/Makefile
 rename drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-3945-debugfs.c (99%)
 copy drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-3945-debugfs.h (95%)
 rename drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-3945-fh.h (98%)
 rename drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-3945-hw.h (96%)
 copy drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-3945-led.c (73%)
 copy drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-3945-led.h (95%)
 rename drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-3945-rs.c (96%)
 rename drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-3945.c (92%)
 rename drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-3945.h (97%)
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-calib.c
 copy drivers/net/wireless/{iwlwifi/iwl-legacy.h => iwlegacy/iwl-4965-calib.h} (80%)
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
 rename drivers/net/wireless/{iwlwifi/iwl-3945-debugfs.h => iwlegacy/iwl-4965-debugfs.h} (61%)
 rename drivers/net/wireless/{iwlwifi/iwl-legacy.h => iwlegacy/iwl-4965-eeprom.c} (53%)
 rename drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-4965-hw.h (97%)
 rename drivers/net/wireless/{iwlwifi/iwl-3945-led.c => iwlegacy/iwl-4965-led.c} (65%)
 copy drivers/net/wireless/{iwlwifi/iwl-3945-led.h => iwlegacy/iwl-4965-led.h} (81%)
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-lib.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-rs.c
 rename drivers/net/wireless/{iwlwifi/iwl-agn-rx.c => iwlegacy/iwl-4965-rx.c} (59%)
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-sta.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-tx.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c
 rename drivers/net/wireless/{iwlwifi => iwlegacy}/iwl-4965.c (71%)
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-4965.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-commands.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-core.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-core.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-csr.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-debug.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-debugfs.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-dev.h
 copy drivers/net/wireless/{iwlwifi/iwl-3945-led.h => iwlegacy/iwl-devtrace.c} (59%)
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-devtrace.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-eeprom.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-eeprom.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-fh.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-hcmd.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-helpers.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-io.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-led.c
 copy drivers/net/wireless/{iwlwifi/iwl-3945-led.h => iwlegacy/iwl-led.h} (59%)
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-power.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-power.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-prph.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-rx.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-scan.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-spectrum.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-sta.c
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-sta.h
 create mode 100644 drivers/net/wireless/iwlegacy/iwl-tx.c
 rename drivers/net/wireless/{iwlwifi => iwlegacy}/iwl3945-base.c (89%)
 create mode 100644 drivers/net/wireless/iwlegacy/iwl4965-base.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-2000.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-legacy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192c/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
 rename drivers/net/wireless/rtlwifi/{rtl8192ce/fw.c => rtl8192c/fw_common.c} (94%)
 rename drivers/net/wireless/rtlwifi/{rtl8192ce/fw.h => rtl8192c/fw_common.h} (100%)
 copy drivers/net/wireless/{iwlwifi/iwl-3945-led.h => rtlwifi/rtl8192c/main.c} (61%)
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
 copy drivers/net/wireless/{iwlwifi/iwl-3945-led.h => rtlwifi/rtl8192cu/dm.h} (74%)
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/led.c
 copy drivers/net/wireless/{iwlwifi/iwl-3945-led.h => rtlwifi/rtl8192cu/led.h} (61%)
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/mac.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
 copy drivers/net/wireless/{iwlwifi/iwl-3945-led.h => rtlwifi/rtl8192cu/phy.h} (63%)
 copy drivers/net/wireless/{iwlwifi/iwl-3945-led.h => rtlwifi/rtl8192cu/reg.h} (74%)
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
 rename drivers/net/wireless/{iwlwifi/iwl-3945-led.h => rtlwifi/rtl8192cu/rf.h} (53%)
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192cu/trx.h
 create mode 100644 drivers/net/wireless/rtlwifi/usb.c
 create mode 100644 drivers/net/wireless/rtlwifi/usb.h
 create mode 100644 drivers/net/xen-netback/Makefile
 create mode 100644 drivers/net/xen-netback/common.h
 create mode 100644 drivers/net/xen-netback/interface.c
 create mode 100644 drivers/net/xen-netback/netback.c
 create mode 100644 drivers/net/xen-netback/xenbus.c
 rename firmware/bnx2/{bnx2-mips-09-6.2.1.fw.ihex => bnx2-mips-09-6.2.1a.fw.ihex} (62%)
 create mode 100644 include/linux/cpu_rmap.h
 create mode 100644 include/linux/micrel_phy.h
 create mode 100644 include/linux/netfilter/ipset/Kbuild
 create mode 100644 include/linux/netfilter/ipset/ip_set.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_ahash.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_bitmap.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_getport.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_hash.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_list.h
 create mode 100644 include/linux/netfilter/ipset/ip_set_timeout.h
 create mode 100644 include/linux/netfilter/ipset/pfxlen.h
 create mode 100644 include/linux/netfilter/nf_conntrack_snmp.h
 create mode 100644 include/linux/netfilter/xt_AUDIT.h
 create mode 100644 include/linux/netfilter/xt_addrtype.h
 create mode 100644 include/linux/netfilter/xt_devgroup.h
 create mode 100644 include/linux/netfilter/xt_set.h
 create mode 100644 include/net/bluetooth/smp.h
 create mode 100644 include/net/netfilter/nf_conntrack_timestamp.h
 create mode 100644 lib/cpu_rmap.c
 rename net/bluetooth/{l2cap.c => l2cap_core.c} (76%)
 create mode 100644 net/bluetooth/l2cap_sock.c
 delete mode 100644 net/ipv4/fib_hash.c
 delete mode 100644 net/ipv4/netfilter/ipt_addrtype.c
 create mode 100644 net/netfilter/ipset/Kconfig
 create mode 100644 net/netfilter/ipset/Makefile
 create mode 100644 net/netfilter/ipset/ip_set_bitmap_ip.c
 create mode 100644 net/netfilter/ipset/ip_set_bitmap_ipmac.c
 create mode 100644 net/netfilter/ipset/ip_set_bitmap_port.c
 create mode 100644 net/netfilter/ipset/ip_set_core.c
 create mode 100644 net/netfilter/ipset/ip_set_getport.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ip.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipport.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipportip.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_ipportnet.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_net.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_netport.c
 create mode 100644 net/netfilter/ipset/ip_set_list_set.c
 create mode 100644 net/netfilter/ipset/pfxlen.c
 create mode 100644 net/netfilter/nf_conntrack_broadcast.c
 create mode 100644 net/netfilter/nf_conntrack_snmp.c
 create mode 100644 net/netfilter/nf_conntrack_timestamp.c
 create mode 100644 net/netfilter/xt_AUDIT.c
 create mode 100644 net/netfilter/xt_addrtype.c
 create mode 100644 net/netfilter/xt_devgroup.c
 create mode 100644 net/netfilter/xt_set.c
 create mode 100644 net/sched/sch_choke.c
 create mode 100644 net/sched/sch_mqprio.c
 create mode 100644 net/sched/sch_sfb.c
 create mode 100644 net/xfrm/xfrm_replay.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
