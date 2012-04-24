Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2DXH33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:29:29 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:51128 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2DXH32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:29:28 -0400
Date: Tue, 24 Apr 2012 15:29:18 +0800
From: Richard Yang <weiyang@linux.vnet.ibm.com>
To: Don Dutile <ddutile@redhat.com>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
Message-ID: <20120424072918.GA9138@richard>
Reply-To: Richard Yang <weiyang@linux.vnet.ibm.com>
References: <20120410090306.GA7056@richard>
 <20120422155202.GA13540@richard>
 <4F95B17B.3030401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F95B17B.3030401@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12042407-4790-0000-0000-000002529400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 03:46:03PM -0400, Don Dutile wrote:
>On 04/22/2012 11:52 AM, Richard Yang wrote:
>>All,
>>
>>I am reading the pci_scan_bridge() and not sure what will happen in
>>following situation.
>>
>>Suppose the kernel is not passed the pci=assign-busses.
>>
>>Below is a picture about the pci system.
>>
>>                    +-------+
>>                    |       | root bridge(0,255)
>>                    +---+---+
>>                        |          Bus 0
>>       -----+-----------+------------------------------+--
>>            |                                          |
>>            |                                          |
>>            |                                          |
>>       +----+----+                               +-----+-----+
>>       |         |  B1(1,15)                     |           |B2(16,28)
>>       +----+----+                               +-----+-----+
>>            |  Bus 1                                   |    Bus 16
>>       -----+-----------------------         ----------+----------------
>>                             |
>>                        +----+----+
>>                        |         | B3
>>                        +---------+
>>
>>Suppose B1 and B2 works fine with the BIOS, which get the right bus
>>number and range.
>>
>>B3 does not works fine with the BIOS, which doesn't get the bus number.
>>
>>So in pci_scan_bridge(), B3 will be met in the second pass and get bus
>>number 16?
>
>unfortunately, today, the answer is yes.
>I have run into a similar problem recently when trying to use pci=assign-busses
>with an SRIOV device behind a non-ARI-capable PCIe switch.
>In this scenario, the assign-busses code assigned the next bus number,
>which conflicted with an existing one on the system, and hangs the
>system -- two bridges responding to the same PCI bus num evidently
>confuses the hw! ;-)
Hmm... seems we are not talking about the same case.
My case is the kernel not passed with pci=assign-busses.

I think, if pci=assign-busses is used, kernel will just ignore the bus
number assigned by BIOS, and do the assignment itself.
>
>The PCI code is suppose to do two bus scans -- pass=0: to see what the BIOS
>has setup, and then pass=1 to assign non-BIOS setup devices.
>But, what I'm finding is that when pci=assign-busses is set, the
>pass=0 scan is not doing a full PCI tree scan and registering all
>the BIOS-setup busses first, and it tries to do extended bus assignment in pass=0,
>not pass=1; in the above configuration, it expands B1's bus num range from (1,15)
>to (1,16), then tries to scan behind it.  that creates an overlap btwn
>B1 & B2's sec/sub bus-num ranges, and they both respond to a Type1 config cycle
>with a bus-number of 16 (typically when trying to read the VID register of 16:0.0
>in this case).... boom! ... or more like silence due to system hang...
>
>*If* the system spaces bus ranges apart, e.g., in your config above,
>if the BIOS setup B1(1,15) and B2(24,32), then pci=assign-busses will
>work because bus num 16 is free, and two bridges won't think they both
>respond to type1 pci config cycle (with bus-number=16 lying in their sec/sub-bus num range),
>and all will (luckily) work.
>
>Unfortunately, I'm in & out of work due to at-home time requirements,
>so I haven't had a chance to work out a proper patch.
>What should happen in the above case, is the kernel prints a warning saying
>it couldn't do needed assign-busses operations due to configuration constraints...
>and continue to do pci (pass=1) bridge scanning.... and not wedge the system
>as it does now.
>The base problem is that
>(a)pass=0 is doing bus-assigning, and it shouldn't be done
>    until pass=1, after all known BIOS-setup busses are known
>(b) the code doesn't have a nice warning and continuation when this
>    conflict occurs.
>
>>Would this be a conflict?
>>
>summary: yes.

-- 
Richard Yang
Help you, Help me

