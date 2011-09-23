Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab1IWP6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:58:51 -0400
Received: from lo.gmane.org ([80.91.229.12]:47259 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab1IWP6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:58:50 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [3.1-rc6] kmalloc(64) leak from IDE
Date: Fri, 23 Sep 2011 17:58:31 +0200
Message-ID: <j5iab7$j8m$1@dough.gmane.org>
References: <20110922072643.GA27232@hostway.ca> <20110922084811.GC17640@liondog.tnic> <20110922202337.GB32661@hostway.ca> <20110923072118.GA13293@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: tc-gate2.pci.uni-heidelberg.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
In-Reply-To: <20110923072118.GA13293@liondog.tnic>
Cc: linux-acpi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 09:21 AM, Borislav Petkov wrote:
> On Thu, Sep 22, 2011 at 01:23:37PM -0700, Simon Kirby wrote:
>> Yes, that seems to have made it stop complaining about the IDE path.
>
> Good, thanks for testing. It would be great if you left it running for
> a couple of days like this to see whether there aren't any other issues
> with the patch. I'll send it with a proper description to Dave soonish
> since this is a real bug.
>
>> All I see from kmemleak now is:
>
> Yep, not IDE-related. Adding linux-acpi.


>
>> unreferenced object 0xe7481a00 (size 256):
>>    comm "swapper", pid 1, jiffies 4294892509 (age 515.560s)
>>    hex dump (first 32 bytes):
>>      00 00 00 28 ff ff ef ff 60 78 4e e7 00 02 00 00  ...(....`xN.....
>>      47 01 f8 0c f8 0c 01 08 00 00 00 00 0c 03 00 00  G...............
>>    backtrace:
>>      [<c1495c47>] kmemleak_alloc+0x27/0x50
>>      [<c10b3563>] __kmalloc+0xf3/0x1c0
>>      [<c149e0b0>] pci_acpi_scan_root+0x11e/0x272
>>      [<c149916b>] acpi_pci_root_add+0x163/0x256
>>      [<c12adddc>] acpi_device_probe+0x3a/0xf4
>>      [<c1302e38>] driver_probe_device+0x68/0x160
>>      [<c1302fb9>] __driver_attach+0x89/0x90
>>      [<c1302718>] bus_for_each_dev+0x48/0x70
>>      [<c1302cc9>] driver_attach+0x19/0x20
>>      [<c130213f>] bus_add_driver+0x17f/0x240
>>      [<c1303345>] driver_register+0x65/0x120
>>      [<c12af273>] acpi_bus_register_driver+0x3a/0x3f
>>      [<c16d421f>] acpi_pci_root_init+0x1b/0x2a
>>      [<c1001030>] do_one_initcall+0x30/0x160
>>      [<c16b920b>] kernel_init+0x78/0x10c
>>      [<c14a1b76>] kernel_thread_helper+0x6/0xd
>> unreferenced object 0xe74e7860 (size 16):
>>    comm "swapper", pid 1, jiffies 4294892509 (age 515.560s)
>>    hex dump (first 16 bytes):
>>      50 43 49 20 42 75 73 20 30 30 30 30 3a 30 30 00  PCI Bus 0000:00.
>>    backtrace:
>>      [<c1495c47>] kmemleak_alloc+0x27/0x50
>>      [<c10b3563>] __kmalloc+0xf3/0x1c0
>>      [<c1290cce>] kvasprintf+0x2e/0x50
>>      [<c1290d01>] kasprintf+0x11/0x20
>>      [<c149e0da>] pci_acpi_scan_root+0x148/0x272
>>      [<c149916b>] acpi_pci_root_add+0x163/0x256
>>      [<c12adddc>] acpi_device_probe+0x3a/0xf4
>>      [<c1302e38>] driver_probe_device+0x68/0x160
>>      [<c1302fb9>] __driver_attach+0x89/0x90
>>      [<c1302718>] bus_for_each_dev+0x48/0x70
>>      [<c1302cc9>] driver_attach+0x19/0x20
>>      [<c130213f>] bus_add_driver+0x17f/0x240
>>      [<c1303345>] driver_register+0x65/0x120
>>      [<c12af273>] acpi_bus_register_driver+0x3a/0x3f
>>      [<c16d421f>] acpi_pci_root_init+0x1b/0x2a
>>      [<c1001030>] do_one_initcall+0x30/0x160
>>
>> ...which is probably a separate, non-recurring leak.
>>
>>> Also, I'm sure you know IDE is deprecated, so what are the chances of
>>> moving this box to libata? Also, can you send me your .config pls?
>>
>> Yeah, I was going to get around to that eventually. :) Config (and
>> earlier kmemleak output) here: http://0x.ca/sim/ref/3.1-rc6-blue/
>
> Ok, thanks.
>

I think I reported those already some time ago:

https://lkml.org/lkml/2011/6/21/95


Cheers,
Bernd

