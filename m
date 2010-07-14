Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0GNCXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:23:07 -0400
Received: from mail.candelatech.com ([208.74.158.172]:48218 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0GNCXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:23:05 -0400
Message-ID: <4C3D1F82.1040907@candelatech.com>
Date: Tue, 13 Jul 2010 19:22:58 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, jbarnes@virtuousgeek.org,
        jacob.jun.pan@intel.com
Subject: Re: Regression:  2.6.34 boot fails on E5405 system, bisected:  de08e2c26
References: <4C3D067C.10507@candelatech.com> <4C3D101E.5010605@candelatech.com> <4C3D1942.1090207@gmail.com>
In-Reply-To: <4C3D1942.1090207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 06:56 PM, Robert Hancock wrote:
> On 07/13/2010 07:17 PM, Ben Greear wrote:
>> On 07/13/2010 05:36 PM, Ben Greear wrote:
>>> We're seeing boot failures on multiple machines, running FC8 and
>>> F11. I bisected on an FC8 32-bit system. Newer hardware works,
>>> but these older ones do not.
>>>
>>> A console log of the hang is found later in this email.
>>>
>>> Please let me know if you would like any additional information,
>>> and I will be happy to test patches.
>>>
>>> The same failure happens in 2.6.34.1, so the fix does not appear to
>>> be in the stable tree yet.
>>
>>
>> I added some printks to the offending code. It seems the problem
>> is that the fixed_bar_cap method in arch/x86/pci/mrst.c loops forever:
>>
>> # Endless loop of this spewing to console...
>>
>> pcie_cap: 268435456Checking vendor..
>> pos after shift: 256
>> Before read..
>
> Can you print out bus->number and devfn and look that up in lspci to
> find out which device it's hitting? It looks like there's a device with
> a PCI Express extended capability header that has a extended capability
> ID of 0000h and a next capability offset of 100h, which points to
> itself, causing the infinite loop. I'm guessing that if pcie_cap >> 20
> <= pos then it should give up and break out of the loop, since it means
> that the next capability pointer is invalidly pointing to the same or a
> previous entry..

Bailing out like that does let it boot.

As for the bus and devfn:  bus: 0   devfn: 129 (decimal)

I'm not sure what to look for in lspci, but here is the output with -n:

[root@ice-si-dmz ~]# lspci -n
00:00.0 0600: 8086:25d8 (rev b1)
00:02.0 0604: 8086:25f7 (rev b1)
00:04.0 0604: 8086:25f8 (rev b1)
00:06.0 0604: 8086:25f9 (rev b1)
00:08.0 0880: 8086:1a38 (rev b1)
00:10.0 0600: 8086:25f0 (rev b1)
00:10.1 0600: 8086:25f0 (rev b1)
00:10.2 0600: 8086:25f0 (rev b1)
00:11.0 0600: 8086:25f1 (rev b1)
00:13.0 0600: 8086:25f3 (rev b1)
00:15.0 0600: 8086:25f5 (rev b1)
00:16.0 0600: 8086:25f6 (rev b1)
00:1d.0 0c03: 8086:2688 (rev 09)
00:1d.1 0c03: 8086:2689 (rev 09)
00:1d.2 0c03: 8086:268a (rev 09)
00:1d.7 0c03: 8086:268c (rev 09)
00:1e.0 0604: 8086:244e (rev d9)
00:1f.0 0601: 8086:2670 (rev 09)
00:1f.1 0101: 8086:269e (rev 09)
00:1f.2 0106: 8086:2681 (rev 09)
00:1f.3 0c05: 8086:269b (rev 09)
01:00.0 0604: 8086:3500 (rev 01)
01:00.3 0604: 8086:350c (rev 01)
02:00.0 0604: 8086:3510 (rev 01)
02:02.0 0604: 8086:3518 (rev 01)
04:00.0 0200: 8086:1096 (rev 01)
04:00.1 0200: 8086:1096 (rev 01)
06:00.0 0604: 111d:8018 (rev 04)
07:00.0 0604: 111d:8018 (rev 04)
07:01.0 0604: 111d:8018 (rev 04)
08:00.0 0200: 8086:10a4 (rev 06)
08:00.1 0200: 8086:10a4 (rev 06)
09:00.0 0200: 8086:10a4 (rev 06)
09:00.1 0200: 8086:10a4 (rev 06)
0a:00.0 0604: 111d:8018 (rev 04)
0b:00.0 0604: 111d:8018 (rev 04)
0b:01.0 0604: 111d:8018 (rev 04)
0c:00.0 0200: 8086:10a4 (rev 06)
0c:00.1 0200: 8086:10a4 (rev 06)
0d:00.0 0200: 8086:10a4 (rev 06)
0d:00.1 0200: 8086:10a4 (rev 06)
0e:01.0 0300: 1002:515e (rev 02)


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
