Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0EFIXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 04:23:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:26596 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab0EFIX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 04:23:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,339,1270450800"; 
   d="scan'208";a="795937113"
From: "Du, Alek" <alek.du@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Date: Thu, 6 May 2010 16:23:09 +0800
Subject: RE: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Thread-Topic: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
Thread-Index: Acrsa3NkIypAdifSR/S1kp/yKXCntAAiQ8+g
Message-ID: <1865303E0DED764181A9D882DEF65FB61A82A6DA3B@shsmsx502.ccr.corp.intel.com>
References: <20100505111245.2c480ea1@dxy2>
 <Pine.LNX.4.44L0.1005051144490.1885-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005051144490.1885-100000@iolanthe.rowland.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Alan,
>>
>> As I tested, the patch breaks phy low power mode, the EHCI works, but it
>never
>> enter phy low power mode when suspending port...
>>
>> I guess this part of the diff breaks it.
>>
>>
>>  -			/* only enable appropriate wake bits, otherwise the
>>  -			 * hardware can not go phy low power mode. If a race
>>  -			 * condition happens here(connection change during bits
>>  -			 * set), the port change detection will finally fix it.
>>  -			 */
>>  -			if (t1 & PORT_CONNECT) {
>>  -				t2 |= PORT_WKOC_E | PORT_WKDISC_E;
>>  -				t2 &= ~PORT_WKCONN_E;
>>  -			} else {
>>  -				t2 |= PORT_WKOC_E | PORT_WKCONN_E;
>>  -				t2 &= ~PORT_WKDISC_E;
>>  -			}
>
>That seems very odd.  Why should removing code that enables wakeup bits
>cause the suspend to fail?  Can't the phy go into low-power mode when
>all the wakeup bits are disabled?
>
>Does applying this additional patch on top of the previous one help?
>
>Alan Stern
>
>
>
>Index: usb-2.6/drivers/usb/host/ehci-hub.c
>===================================================================
>--- usb-2.6.orig/drivers/usb/host/ehci-hub.c
>+++ usb-2.6/drivers/usb/host/ehci-hub.c
>@@ -200,7 +200,7 @@ static int ehci_bus_suspend (struct usb_
> 	while (port--) {
> 		u32 __iomem	*reg = &ehci->regs->port_status [port];
> 		u32		t1 = ehci_readl(ehci, reg) & ~PORT_RWC_BITS;
>-		u32		t2 = t1;
>+		u32		t2;
>
> 		if (ehci->has_hostpc)
> 			hostpc_reg = (u32 __iomem *)((u8 *)ehci->regs
>@@ -209,6 +209,7 @@ static int ehci_bus_suspend (struct usb_
> 		if (t1 & PORT_OWNER)
> 			set_bit(port, &ehci->owned_ports);
> 		else if ((t1 & PORT_PE) && !(t1 & PORT_SUSPEND)) {
>+			t2 = t1 & ~PORT_WAKE_BITS;
> 			t2 |= PORT_SUSPEND;
> 			set_bit(port, &ehci->bus_suspended);
> 			ehci_vdbg (ehci, "port %d, %08x -> %08x\n",


Alan,

I think the problem is: For the original code, once t2 != t1, the HCD will try to put into phy low power mode. While after the patch, the HCD will only enter phy low power mode if PORT_PE is set and PORT_SUSPEND is not set.

Thanks,
Alek

