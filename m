Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2CFSAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:00:07 -0500
Received: from plane.gmane.org ([80.91.229.3]:54726 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab2CFSAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:00:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tom Goetz <tom.goetz@virtualcomputer.com>
Subject: Re: [PATCH 1/3] USB: Try MSI first before line IRQ for Intel PCIe USB3 HCD
Date: Tue, 6 Mar 2012 17:55:47 +0000 (UTC)
Message-ID: <loom.20120306T175128-616@post.gmane.org>
References: <1329728733-32419-1-git-send-email-alex.shi@intel.com> <1329728733-32419-2-git-send-email-alex.shi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 75.150.106.249 (Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_3) AppleWebKit/534.53.11 (KHTML, like Gecko) Version/5.1.3 Safari/534.53.10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Shi <alex.shi <at> intel.com> writes:

> > From: Sarah Sharp <sarah.a.sharp <at> linux.intel.com> > > We have a
PCI USB xhci host controller on a new platform. It doesn't > have a line
IRQ definition in BIOS. The Linux driver refuses to > initial this
controller, but Windows works well because it only depends > on MSI. >

We're having problems with XHCI on 3.2.9 on a new HP Ivybridge laptop.
Some of the evidence suggests that it is MSI related. After suspending
and resuming the platform the XHCI device is not functional.

also submitted here:
http://lists.xen.org/archives/html/xen-devel/2012-03/msg00363.html

Data dump:

- Xen 4.0.3, Linux 3.2.7 PVOPs, Linux 3.2.9 PVOPs
- Happens on HP Ivybridge. Doesn't happen on very similar HP Sandybridge
Clash system.
- Happens on battery, but not on AC.
- Doesn't happen on first suspend/resume. First resume may be long.
Don't have enough samples to be sure of this.
- CPU power governor doesn't effect the issue. Happens regardless of governor.
- Seems to effect MSI devices only.
- IRQ changes appear in good resume case. Not just bad.
- XHCI driver crashes during suspend with pci=nomsi.
- Remove USB HCD drivers from SUSPEND_MODULES and XHCI functionality
survives suspend/resume.
- Is not removing XHCI enough? Guess is that it is.
- Unloading/loading the XHCI driver after a broken resume also fixes it.
- Received a bad IRQ warning in atleast one resume.

I've diffed lspci output across a working resume on AC and across a bad resume
on battery. There seem to be the differences unique to the bad case:

 00:14.0 USB controller: Intel Corporation Panther Point USB xHCI Host
 Controller (rev 04) (prog-if 30 [XHCI])
 Subsystem: Hewlett-Packard Company Device 179b
-Flags: bus master, medium devsel, latency 0, IRQ 326
+Flags: medium devsel, IRQ 327       <-------------- lose bus master, latency 0
 Memory at 94720000 (64-bit, non-prefetchable) [size=64K]
 Capabilities: [70] Power Management version 2
 Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
 Kernel driver in use: xhci_hcd
 Kernel modules: xhci-hcd

--- 

 00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network
 Connection (rev 04)
 Subsystem: Hewlett-Packard Company Device 179b
-Flags: bus master, fast devsel, latency 0, IRQ 327
-Memory at 94700000 (32-bit, non-prefetchable) [size=128K]
-Memory at 9473a000 (32-bit, non-prefetchable) [size=4K]
-I/O ports at 4060 [size=32]
+Flags: fast devsel, IRQ 20    <-------------- lose bus master, latency 0
+Memory at 94700000 (32-bit, non-prefetchable) [disabled] [size=128K]
	<------ becomes disabled
+Memory at 9473a000 (32-bit, non-prefetchable) [disabled] [size=4K]
	<------ becomes disabled
+I/O ports at 4060 [disabled] [size=32]     <------ becomes disabled
 Capabilities: [c8] Power Management version 2
-Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
+Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
	<---- toggle enable polarity
 Capabilities: [e0] PCI Advanced Features
 Kernel driver in use: e1000e
 Kernel modules: e1000e

---

 00:1a.0 USB controller: Intel Corporation Panther Point USB Enhanced Host
 Controller #2 (rev 04) (prog-if 20 [EHCI])
 Subsystem: Hewlett-Packard Company Device 179b
-Flags: bus master, medium devsel, latency 0, IRQ 16
+Flags: medium devsel, IRQ 16  <-------------- lose bus master, latency 0
 Memory at 94739000 (32-bit, non-prefetchable) [size=1K]
 Capabilities: [50] Power Management version 2
 Capabilities: [58] Debug port: BAR=1 offset=00a0
 Capabilities: [98] PCI Advanced Features
 Kernel driver in use: ehci_hcd
 Kernel modules: ehci-hcd

syslog looks like this for both good and bad resumes:

[  289.730303] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[  289.730311] xhci_hcd 0000:00:14.0: PCI INT A: no GSI - using ISA IRQ 10
[  289.730319] xen: registering gsi 10 triggering 0 polarity 1
[  289.730327] xen_map_pirq_gsi: returning irq 10 for gsi 10
[  289.730332] xen: --> pirq=10 -> irq=10 (gsi=10)
[  289.730337] Already setup the GSI :10
[  289.730445] xhci_hcd 0000:00:14.0: setting latency timer to 64
[  289.730455] xhci_hcd 0000:00:14.0: xHCI Host Controller
[  289.730687] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus
number 3
[  289.730826] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[  289.730858] xhci_hcd 0000:00:14.0: irq 10, io mem 0x94720000
[  289.731470] xHCI xhci_add_endpoint called for root hub
[  289.731477] xHCI xhci_check_bandwidth called for root hub
[  289.731551] hub 3-0:1.0: USB hub found
[  289.731568] hub 3-0:1.0: 4 ports detected
[  289.843501] xhci_hcd 0000:00:14.0: xHCI Host Controller
[  289.843722] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus
number 4
[  289.844015] xHCI xhci_add_endpoint called for root hub
[  289.844021] xHCI xhci_check_bandwidth called for root hub
[  289.844084] hub 4-0:1.0: USB hub found
[  289.844104] hub 4-0:1.0: 4 ports detected


