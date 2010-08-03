Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0HCKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:25:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48994 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0HCKZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:25:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C57EE60.2000601@s5r6.in-berlin.de>
Date: Tue, 03 Aug 2010 12:24:32 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Donald Parsons <dparsons@brightdsl.net>,
        Harald Hoyer <harald.hoyer@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.35
References: <1280716262.5125.42.camel@falcon.homelinux.org>	<201008012138.39036.bjorn.helgaas@hp.com>	<1280722876.5125.83.camel@falcon.homelinux.org>	<AANLkTimK8sv5aWfcv_BAmipgVnukR5NJsZQOXYbb2LAH@mail.gmail.com>	<1280802701.5836.10.camel@falcon.homelinux.org> <20100802214249.b0fee617.rdunlap@xenotime.net>
In-Reply-To: <20100802214249.b0fee617.rdunlap@xenotime.net>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Mon, 02 Aug 2010 22:31:41 -0400 Donald Parsons wrote:
>>>>> On Sunday, August 01, 2010 08:31:02 pm Donald Parsons wrote:
>>>>>> 2.6.35 still fails to boot for me, as first reported here:
>>>>>>  http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/01144.html
>>>>>>
>>>>>> I've manually bisected it down to around May 20 between
>>>>>>   2.6.34-git4 (boots) and 2.6.34-git5 (boot fails)
>>>>>> Also -git[23] boot, and -git8, -rc[126], rc6-git[136] all fail.
[...]

To recap:  Donald uses ata_generic,pata_acpi,pata_jmicron,ahci for Asus
P5B Deluxe which has

00:1f.2 SATA controller: Intel Corporation 82801HB (ICH8) SATA AHCI
Controller (rev 02)
03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363
AHCI Controller (rev 02)
03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363
AHCI Controller (rev 02)

On which interface is the disk with the root filesystem?

[...]
>> Using your suggestion as to where the problem lies, I investigated
>> more deeply and found:
>>
>> I've now got 2.6.35-rc6-git3 to boot (and almost certainly 2.6.35 final)
>>
>> Make oldconfig broke at the transition where boot began failed, ie,
>> between 2.6.34-git4 and 2.6.34-git5.   Even though modules are the
>> same, boot fails.  If I use gconfig and set CONFIG_SATA_AHCI=y
>> instead of CONFIG_SATA_AHCI=m it works, except cannot select =y
>> unless CONFIG_ATA changed from m to y.
>>
>> So at some point in past, make oldconfig had apparently changed
>> CONFIG_SATA_AHCI from y to m and system still booted.  But between
>> 2.6.34-git4 and 2.6.34-git5 the ability to boot was lost.
>>
>> So make oldconfig is not 100% trustworthy in this case.  I do not
>> know if this is a problem that should be fixed.  Ask if you want
>> any .config diffs.
>>
>> I am going to reboot with 2.6.35 to make sure it boots. Yes!
>>
>> I consider this boot problem solved unless someone wants to
>> improve "make oldconfig" behavior.

There was at least the following notable change in drivers/ata/Kconfig:
Commit 9a7780c9acb821fe1c2b6fc53f74cc2556ff5364 "libata-sff: make BMDMA
optional" added a new intermediary configuration option, ATA_SFF.  The
option PATA_JMICRON depends on this new option now.  ATA_GENERIC,
PATA_ACPI, SATA_AHCI do not depend on it.

("make oldconfig" asks for ATA_BMDMA and defaults to Y, as does the help
text recommend.  Still, people who switch from 2.6.34 to 2.6.35 might be
convied that they do not need it as they already used kernels that did
not have this option with their controllers.)

Might the problem be with the order in which interfaces and disks are
discovered and hence enumerated?

> It would be good to be able to explain what you are seeing & describing,
> so yes, if you can send a .config file that exhibits the problem, I'd
> love to look at it.

Could be enlightening.
-- 
Stefan Richter
-=====-==-=- =--- ---==
http://arcgraph.de/sr/
