Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab0GVR0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 13:26:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41679 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab0GVR0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 13:26:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C487F2B.4040405@s5r6.in-berlin.de>
Date: Thu, 22 Jul 2010 19:26:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, Kristian Hoegsberg <krh@bitplanet.net>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [review patch 1/2] firewire: new driver: nosy - IEEE 1394 traffic
 sniffer
References: <tkrat.72756f504d6c0055@s5r6.in-berlin.de>	<tkrat.ddc816ab75cce8ac@s5r6.in-berlin.de> <20100722090751.682f3b00.randy.dunlap@oracle.com>
In-Reply-To: <20100722090751.682f3b00.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 22 Jul 2010 11:56:38 +0200 (CEST) Stefan Richter wrote:
>> --- a/drivers/firewire/Kconfig
>> +++ b/drivers/firewire/Kconfig
>> @@ -66,4 +66,27 @@ config FIREWIRE_NET
>>  
>>  source "drivers/ieee1394/Kconfig"
>>  
>> +config FIREWIRE_NOSY
>> +	tristate "Nosy - a FireWire traffic sniffer for PCILynx cards"
>> +	depends on PCI
> 
> Just curious:  why not depends on IEEE1394_PCILYNX ?

This is a stand-alone driver that interacts neither with the old nor
with the new FireWire kernel subsystem.  It contains only the minimum of
DMA programming that is required to get PCILynx' snoop mode (a catch-all
reception DMA) up and running.

IEEE1394_PCILYNX alias pcilynx on the other hand is a bigger card driver
which implements several transmit and receive DMA modes as required by a
low-level driver of the ieee1394 stack.¹

Thus, nosy does not use code from or share code with anything in
drivers/ieee1394/.

¹) except for isochronous transmission and reception; this was initially
also provided by pcilynx but became outdated early on in the history of
the ieee1394 stack when video1394 was added; and except for physical DMA
that the sbp2 driver requires

If you have a PCILynx card, you can bind either pcilynx or nosy to it.
(As the kernel's build system works, I think nosy is going to be bound
before pcilynx if both are present.)  However, nosy the bus analyzer
provides better value than pcilynx the ieee1394 lowlevel driver that
lacks 3/4 of the functionality that ohci1394 offers.

>> --- /dev/null
>> +++ b/drivers/firewire/nosy-user.h
>> @@ -0,0 +1,25 @@
>> +#ifndef __nosy_user_h
>> +#define __nosy_user_h
>> +
>> +#include <linux/ioctl.h>
>> +#include <linux/types.h>
>> +
>> +#define NOSY_IOC_GET_STATS _IOR('&', 0, struct nosy_stats)
>> +#define NOSY_IOC_START     _IO('&', 1)
>> +#define NOSY_IOC_STOP      _IO('&', 2)
>> +#define NOSY_IOC_FILTER    _IOW('&', 2, __u32)
> 
> Please add '&' to Documentation/ioctl/ioctl-number.txt.

Right, I will send a follow-up patch which does this if there are no
fundamental objections to this ioctl allocation.
-- 
Stefan Richter
-=====-==-=- -=== =-==-
http://arcgraph.de/sr/
