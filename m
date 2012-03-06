Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030601Ab2CFTp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:45:27 -0500
Received: from www.linutronix.de ([62.245.132.108]:59335 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965176Ab2CFTpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:45:25 -0500
Date: Tue, 6 Mar 2012 20:45:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
cc: Sven Joachim <svenjoac@gmx.de>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Nieder <jrnieder@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
In-Reply-To: <201203050143.24541.s.L-H@gmx.de>
Message-ID: <alpine.LFD.2.02.1203062043500.2742@ionos>
References: <20120228010511.GA8453@kroah.com> <20120228010434.412979550@linuxfoundation.org> <87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2012, Stefan Lippers-Hollmann wrote:
> On Monday 05 March 2012, Sven Joachim wrote:
> > On 2012-02-28 02:05 +0100, Greg KH wrote:
> > 
> > > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > Alas, the commit below broke the WiFi on my laptop, where
> > "iwlist wlan0 scan" now just reports: " wlan0     No scan results".
> > 
> > This is not specific to 3.2, the same problem exists in 3.0.23 and
> > 3.3-rc6 while previous releases worked.
> 
> I can confirm this regression on an old PIII based notebook with a 
> 32 bit BCM4306/3 PCMCIA card:
> 
> 02:00.0 Network controller [0280]: Broadcom Corporation BCM4306 802.11b/g Wireless LAN Controller [14e4:4320] (rev 03)
>         Subsystem: Linksys WPC54G v1 / WPC54GS v1 802.11g Wireless-G Notebook Adapter [1737:4320]
>         Flags: bus master, fast devsel, latency 64, IRQ 10
>         Memory at 20000000 (32-bit, non-prefetchable) [size=8K]
>         Capabilities: [40] Power Management version 2
>         Kernel driver in use: b43-pci-bridge
> 
> I can observe these differences in the dmesg output (3.2.9 + current 
> stable queue-3.2):
> 
> The kernel configuration is identical in both cases, the only 
> difference is "genirq: Unmask oneshot irqs when thread was not woken"
> being applied or not.
> 
> --- working	<-- 3.2.9 + current stable queue-3.2, with "genirq: Unmask oneshot irqs when thread was not woken" reverted
> +++ broken	<-- 3.2.9 + current stable queue-3.2
> @@ -125,6 +125,7 @@ Initializing cgroup subsys freezer
>  Initializing cgroup subsys net_cls
>  Initializing cgroup subsys blkio
>  Initializing cgroup subsys perf_event
> +CPU serial number disabled.

I can't see why reverting that genirq patch would cause this.

>  mce: CPU supports 5 MCE banks
>  SMP alternatives: switching to UP code
>  Freeing SMP alternatives: 8k freed
> @@ -137,9 +138,16 @@ SMP disabled
>  Performance Events: 
>  no APIC, boot with the "lapic" boot parameter to force-enable it.
>  no hardware sampling interrupt available.
> -Broken PMU hardware detected, using software events only.
> +p6 PMU driver.
> +... version:                0
> +... bit width:              32
> +... generic registers:      2
> +... value mask:             00000000ffffffff
> +... max period:             000000007fffffff
> +... fixed-purpose events:   0
> +... event mask:             0000000000000003

Ditto.

>  Brought up 1 CPUs
>  Total of 1 processors activated (1989.75 BogoMIPS).
>  devtmpfs: initialized
>  PM: Registering ACPI NVS region at eeff000 (4096 bytes)
>  print_constraints: dummy: 
> @@ -174,12 +182,12 @@ pci 0000:00:00.0: reg 10: [mem 0xec00000
>  type 1 class 0x000604
>  pci 0000:00:01.0: supports D1
>  type 2 class 0x000607
> -pci 0000:00:04.0: reg 10: [mem 0x10000000-0x10000fff]
> +pci 0000:00:04.0: reg 10: [mem 0x00000000-0x00000fff]

Even more. 

There is something extremly fishy.

Thanks,

	tglx
