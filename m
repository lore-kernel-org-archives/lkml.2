Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab2APG2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 01:28:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:63279 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab2APG2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 01:28:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="96851118"
Message-ID: <4F13C333.4050609@intel.com>
Date: Sun, 15 Jan 2012 22:26:59 -0800
From: Darren Hart <darren.hart@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: "lkml," <linux-kernel@vger.kernel.org>, Wang Qi <qi.wang@intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Porting pch_pcieqos to 3.2 for Intel EG20T with no MAC
References: <4F0CECC8.7010203@linux.intel.com> <4F106ADB.4040000@intel.com> <CANKRQnjUZt+RM20AdevFGJGM+G=+o+x6vjy7=eUnSAzYtEvqjQ@mail.gmail.com>
In-Reply-To: <CANKRQnjUZt+RM20AdevFGJGM+G=+o+x6vjy7=eUnSAzYtEvqjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2012 07:06 PM, Tomoya MORINAGA wrote:
> Hi Darren,
> 
> Can you execute like below
> root@(none):/# find /sys/bus/pci/drivers/pch_phub/0000:02:00.0
> 
> You must see pch_mac.
> 
> Or
> Is your pch_phub integrated as module ?
> If module, you can access from below.
> /sys/module/pch_phub/drivers/pci:pch_phub/0000:02:00.0

I have since resolved this particular issue. I did not disable the
pcieqos driver I forward ported. With that disabled, pch_phub works as
expected. Which is to say it lists pch_mac, reads all 0's, and does
nothing on write (since the MAC ROM doesn't exist). Please see the patch
thread from Friday to address this using a random mac if the ROM is
missing or invalid.

--
Darren

> 
> thanks,
> tomoya
> 
> 
> 2012/1/14 Darren Hart <darren.hart@intel.com>:
>> On 01/10/2012 05:58 PM, Darren Hart wrote:
>>> I find myself with a development board with no MAC address for the pch_gbe in
>>> the Platform Controller Hub EG20T. I've dusted off an old patch and am trying
>>> to get it working so it can be included upstream.
>>>
>>> I found the phub_util_mac utility on sourceforge which appears to require the
>>> following patch:
>>>
>>> http://git.yoctoproject.org/cgit/cgit.cgi/meta-extras/plain/recipes-kernel/linux/linux-netbook-2.6.33.2/linux-2.6.34-pch-pcieqos.patch
>>>
>>> I've made the obvious changes to the driver to use unlocked_ioctl as ioctl has
>>> been removed upstream. With this driver built and installed, the
>>> topcliff_mac_util command reports no errors and reads the MAC address as:
>>>
>>> 00:00:00:00:00:00
>>>
>>> Trying to set it reports no errors either, and the instrumentation suggests it
>>> is at least trying to write the correct data. Reading back still results in all
>>> zeros.
>>>
>>> During boot, the pch_gbe driver reports:
>>> [    2.211233] pch_gbe 0000:02:00.1: enabling device (0000 -> 0003)
>>> [    2.217271] pch_gbe 0000:02:00.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>>> [    2.224349] pch_gbe 0000:02:00.1: setting latency timer to 64
>>> [    2.233388] pch_gbe 0000:02:00.1: Invalid MAC Address
>>> [    2.238821] pch_gbe 0000:02:00.1: PCI INT A disabled
>>> [    2.243809] pch_gbe: probe of 0000:02:00.1 failed with error -5
>>>
>>> The patch itself follows, I have attached a rather lengthy log which includes a
>>> read/write/read cycle demonstrating the write not taking effect.
>>>
>>> Can you shed some light on why this might be the case?
>>
>> After stumbling around blindly for a bit longer, I ran across the pch_phub
>> driver, which appears to be intended for the same purpose, but uses a sysfs
>> interface rather than an ioctl interface with a separate userpsace utility.
>> Do I have this right?
>>
>> Enabling this driver doesn't change the above pch_gbe messages which still
>> include the failed probe of 0000:02:00.1. pch_phub has entries in /sys:
>>
>> root@(none):/# find /sys/bus/pci/drivers/pch_phub
>> /sys/bus/pci/drivers/pch_phub
>> /sys/bus/pci/drivers/pch_phub/uevent
>> /sys/bus/pci/drivers/pch_phub/unbind
>> /sys/bus/pci/drivers/pch_phub/bind
>> /sys/bus/pci/drivers/pch_phub/new_id
>> /sys/bus/pci/drivers/pch_phub/remove_id
>>
>> but no "pch_mac" as I was expecting after reviewing pch_phub.c.
>>
>> Am I still barking up the wrong tree here?
>>
>> --
>> Darren Hart
>> Intel Open Source Technology Center
>> Yocto Project - Linux Kernel


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
