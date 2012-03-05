Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2CEAnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:43:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:49246 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754897Ab2CEAna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:43:30 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19RsmYWhMJR6ijRwU1fdv6mpv1pyda0urTcQSTCXD
	22Z8sb/yg/otpG
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Sven Joachim <svenjoac@gmx.de>
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
Date: Mon, 5 Mar 2012 01:43:20 +0100
User-Agent: KMail/1.13.7 (Linux/3.2-9.slh.2-aptosid-686; KDE/4.6.5; i686; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org
References: <20120228010511.GA8453@kroah.com> <20120228010434.412979550@linuxfoundation.org> <87hay4dqjr.fsf@turtle.gmx.de>
In-Reply-To: <87hay4dqjr.fsf@turtle.gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203050143.24541.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Monday 05 March 2012, Sven Joachim wrote:
> On 2012-02-28 02:05 +0100, Greg KH wrote:
> 
> > 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> Alas, the commit below broke the WiFi on my laptop, where
> "iwlist wlan0 scan" now just reports: " wlan0     No scan results".
> 
> This is not specific to 3.2, the same problem exists in 3.0.23 and
> 3.3-rc6 while previous releases worked.

I can confirm this regression on an old PIII based notebook with a 
32 bit BCM4306/3 PCMCIA card:

02:00.0 Network controller [0280]: Broadcom Corporation BCM4306 802.11b/g Wireless LAN Controller [14e4:4320] (rev 03)
        Subsystem: Linksys WPC54G v1 / WPC54GS v1 802.11g Wireless-G Notebook Adapter [1737:4320]
        Flags: bus master, fast devsel, latency 64, IRQ 10
        Memory at 20000000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: b43-pci-bridge

I can observe these differences in the dmesg output (3.2.9 + current 
stable queue-3.2):

The kernel configuration is identical in both cases, the only 
difference is "genirq: Unmask oneshot irqs when thread was not woken"
being applied or not.

--- working	<-- 3.2.9 + current stable queue-3.2, with "genirq: Unmask oneshot irqs when thread was not woken" reverted
+++ broken	<-- 3.2.9 + current stable queue-3.2
@@ -125,6 +125,7 @@ Initializing cgroup subsys freezer
 Initializing cgroup subsys net_cls
 Initializing cgroup subsys blkio
 Initializing cgroup subsys perf_event
+CPU serial number disabled.
 mce: CPU supports 5 MCE banks
 SMP alternatives: switching to UP code
 Freeing SMP alternatives: 8k freed
@@ -137,9 +138,16 @@ SMP disabled
 Performance Events: 
 no APIC, boot with the "lapic" boot parameter to force-enable it.
 no hardware sampling interrupt available.
-Broken PMU hardware detected, using software events only.
+p6 PMU driver.
+... version:                0
+... bit width:              32
+... generic registers:      2
+... value mask:             00000000ffffffff
+... max period:             000000007fffffff
+... fixed-purpose events:   0
+... event mask:             0000000000000003
 Brought up 1 CPUs
 Total of 1 processors activated (1989.75 BogoMIPS).
 devtmpfs: initialized
 PM: Registering ACPI NVS region at eeff000 (4096 bytes)
 print_constraints: dummy: 
@@ -174,12 +182,12 @@ pci 0000:00:00.0: reg 10: [mem 0xec00000
 type 1 class 0x000604
 pci 0000:00:01.0: supports D1
 type 2 class 0x000607
-pci 0000:00:04.0: reg 10: [mem 0x10000000-0x10000fff]
+pci 0000:00:04.0: reg 10: [mem 0x00000000-0x00000fff]
 pci 0000:00:04.0: supports D1 D2
 pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
 pci 0000:00:04.0: PME# disabled
 type 2 class 0x000607
-pci 0000:00:04.1: reg 10: [mem 0x14000000-0x14000fff]
+pci 0000:00:04.1: reg 10: [mem 0x00000000-0x00000fff]
 pci 0000:00:04.1: supports D1 D2
 pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
 pci 0000:00:04.1: PME# disabled
@@ -299,6 +307,10 @@ pnp: PnP ACPI: found 11 devices
 ACPI: ACPI bus type pnp unregistered
 Switching to clocksource acpi_pm
 PCI: max bus depth: 1 pci_try_num: 2
+pci 0000:00:04.0: BAR 0: assigned [mem 0x10000000-0x10000fff]
+(PCI address [0x10000000-0x10000fff])
+pci 0000:00:04.1: BAR 0: assigned [mem 0x14000000-0x14000fff]
+(PCI address [0x14000000-0x14000fff])
 pci 0000:00:11.0: BAR 6: assigned [mem 0x10020000-0x1003ffff pref]
 pci 0000:00:04.1: BAR 16: assigned [mem 0x18000000-0x1bffffff]
 pci 0000:00:04.1: BAR 15: assigned [mem 0x1c000000-0x1fffffff pref]
@@ -326,9 +338,11 @@ pci 0000:00:01.0: setting latency timer
 enabled at IRQ 10
 PCI: setting IRQ 10 as level-triggered
 -> GSI 10 (level, low) -> IRQ 10
+pci 0000:00:04.0: setting latency timer to 64
 enabled at IRQ 11
 PCI: setting IRQ 11 as level-triggered
 -> GSI 11 (level, low) -> IRQ 11
+pci 0000:00:04.1: setting latency timer to 64
 pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
 pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
 pci_bus 0000:01: resource 1 [mem 0xe8100000-0xe81fffff]
@@ -562,20 +576,6 @@ b43-phy0: Hardware crypto acceleration n
 b43-phy0: QoS not supported by firmware
 ADDRCONF(NETDEV_UP): wlan0: link is not ready
 NET: Registered protocol family 17
-wlan0: authenticate with [redacted MAC address] (try 1)
-wlan0: authenticated
-wlan0: associate with [redacted MAC address] (try 1)
-wlan0: RX AssocResp from [redacted MAC address] (capab=0x411 status=0 aid=1)
-wlan0: associated
-ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
-cfg80211: Calling CRDA for country: DE
-Intel AES-NI instructions are not detected.
-cfg80211: Regulatory domain changed to country: DE
-cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
-cfg80211:     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
-cfg80211:     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
-cfg80211:     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
-cfg80211:     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
 lp0: using parport0 (interrupt-driven).
 lp0: console ready
 ppdev: user-space parallel port driver
@@ -589,4 +589,3 @@ mtrr: base(0xf2000000) is not aligned on
 agpgart-via 0000:00:00.0: AGP 2.0 bridge
 agpgart-via 0000:00:00.0: putting AGP V2 device into 0x mode
 pci 0000:01:00.0: putting AGP V2 device into 0x mode
-wlan0: no IPv6 routers present

While I don't get any revealing error messages, once "genirq: Unmask 
oneshot irqs when thread was not woken" is applied the wlan card 
stops working (no scan results, unable to auth).

I cannot reproduce this problem on a different amd64/ 64 bit system 
with a BCM4318 PCI card, which continues to work fine.

Regards
	Stefan Lippers-Hollmann
