Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab1FUKz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:55:56 -0400
Received: from mailgw1.uni-kl.de ([131.246.120.220]:60771 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1FUKzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:55:52 -0400
Message-ID: <4E0078B6.1020200@itwm.fraunhofer.de>
Date: Tue, 21 Jun 2011 12:55:50 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.0-rc3 kmemleak reports
References: <itpou0$leu$1@dough.gmane.org> <20110621095733.GA10396@1n450.cable.virginmedia.net> <4E006BB9.90505@itwm.fraunhofer.de> <20110621101815.GB10396@1n450.cable.virginmedia.net>
In-Reply-To: <20110621101815.GB10396@1n450.cable.virginmedia.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ITWM-CharSet: ISO-8859-1
X-ITWM-Scanned-By: mail2.itwm.fhg.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2011 12:18 PM, Catalin Marinas wrote:
> On Tue, Jun 21, 2011 at 12:00:25PM +0200, Bernd Schubert wrote:
>> On 06/21/2011 11:57 AM, Catalin Marinas wrote:
>>> On Tue, Jun 21, 2011 at 11:40:15AM +0200, Bernd Schubert wrote:
>>>> For some reasons I build a kernel with kmemleak support and got a
>>>> few reports.
>>>
>>> Do you know if they appear in 2.6.39 as well?
>>
>> No idea, if it is important I can build a previous kernel version
>
> It would be good, if you have time, as people can at least restrict the
> range of commits to check. It could as well be a kmemleak false
> positive, can't tell for sure. The ACPI reports are in general difficult
> to identify, unless you find some commit that introduced them.

I took a quick glance into get_current_resources() and add_resources() 
and it seems to be rather simple to get memory leaks there. In

get_current_resources():

info.res = kmalloc(size, GFP_KERNEL);

=> gdb shows this is our leaking line.


Now in add_resources():

	if (!pci_use_crs)
		return;

=> First possible leak?

		if (res->flags & IORESOURCE_MEM)
			root = &iomem_resource;
		else if (res->flags & IORESOURCE_IO)
			root = &ioport_resource;
		else
			continue;


=> else branch is a possible leak?


And I think we run into the first leak, as kern.log tells us:

> Jun 20 18:20:00 fslab2 kernel: [    0.375732] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> Jun 20 18:20:00 fslab2 kernel: [    0.376146] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-03])


Actually that should be simple to fix and I rebooted now with a patch 
applied. I have no idea how to convince thunderbird to not wrap lines, 
so I will send the patch in a separate mail. Will CC you.


Cheers,
Bernd
