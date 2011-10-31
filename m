Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1JaNGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 09:06:13 -0400
Received: from marge.uochb.cas.cz ([147.231.129.3]:46601 "EHLO
	marge.uochb.cas.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1JaNGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 09:06:09 -0400
Message-ID: <4EAE9D3A.7000108@atlas.cz>
Date: Mon, 31 Oct 2011 14:06:02 +0100
From: Clarinet <clarinet@atlas.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: 647095@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: CPU hyperthreading turned on after soft power-cycle
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz> <1319988329.6759.88.camel@deadeye>
In-Reply-To: <1319988329.6759.88.camel@deadeye>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2011 4:25 PM, Ben Hutchings wrote:
> On Sun, 2011-10-30 at 07:05 -0400, Jiri Polach wrote:
>> Package: linux-2.6
>> Version: 2.6.39-3~bpo60+1
>> Severity: normal
>>
>>
>> When the computer is turned off using "shutdown -h" or "halt" command,
>> the hypertherading BIOS setting is changed - even if hypertherading is
>> disabled in BIOS, the kernel detects twice as many "processors" on
>> next boot as if hyperthreading was enabled. Please see details below.
>>
>> I have observed the problem on several Supermicro platforms with
>> various Intel Xeon processors. The particular case I report was
>> observed on Supermicro X8DTT-F mainboard with two Intel Xeon E5645
>> processors (6core). The problem can be reproduced the following way:
>
> By my understanding of how hyperthreading is controlled, this has to be
> a BIOS bug, as you seem to have suspected.  But if the BIOS behaviour is
> kernel version-dependent, then presumably there is something the kernel
> can do to work around it.

Yes, there are reasons that support my suspicion that BIOS is not doing 
its work properly. But I cannot prove it until it is clear what has been 
changed in the kernel.

>> 1. Turn on the computer, go to BIOS setup and turn "Simultaneous
>> multithreading" to "Disabled". Boot Debian.
>>
>> 2. Check with "cat /proc/cpuinfo" that the system reports 12 CPUs (2 x
>> six-core processor).
>>
>> 3. (optionally) Reboot the system (shutdown -r) and check that there
>> are still 12 CPUs detected and reported.
>>
>> 4. Halt the system using "shutdown -h" or "halt", turn it on again,
>> and boot Debian.
>
> I assume from this that shutdown -h is configured to turn the system
> off.

I do not know. I have been using mostly "halt" to shutdown the system 
and turn the server off and I tried "shutdown -h" only several times to 
see if there is any difference. Both commands have turned the computer 
off, but I did not do any special "shutdown -h" configuration.

>> 5. Check the number of CPUs reported - it will show you that there are
>> 24 CPUs as if hyperthreading was enabled.
>>
>> 6. Reboot and go to BIOS setup - it still shows that "Simultaneous
>> multithreading" is set to "Disabled". Do not change anythig, just
>> select "Save and Exit". Boot Debian and check the number of CPUs - it
>> now shows 12 CPUs again.
>>
>> I have tested several kernel versions and it seems that this behavior
>> appeared for the first time somewhere between 2.6.35.7 and 2.6.38.6
>> versions (ok = does not show the decribed behavior, not ok = does
>> show):
>>
>> * linux-image-2.6.32-5-amd64 official Debian - ok
>> * linux-image-2.6.39-bpo.2-amd64 official Debian from backports - not
>> ok
>>
>> * linux 2.6.35.7 - custom compiled from source - ok
>> * linux 2.6.38.6 - custom compiled from source - not ok
>> * linux 2.6.39.4 - custom compiled from source - not ok
>> * linux 3.0.4 - custom compiled from source - not ok
>
> That might be too large a range for developers to consider.  Can you
> test some versions between 2.6.35.7 and 2.6.38.6 (bisection)?

OK, after another day of testing it seems that the problem appears in 
2.6.38.1, because

* linux 2.6.37.6 - custom compiled from source - ok
* linux 2.6.38.1 - custom compiled from source - not ok

Best regards,

Jiri Polach

> Ben.
>
>> I have exchnged many e-mails with Supermicro distributor who
>> apparently is in direct contact with Supermicro technicians. They more
>> or less deny any responsibility for this problem and repeatedly point
>> to the fact that some (older) kernels do not exhibit this behavior so
>> it must be a kernel problem. Their representative writes:
>>
>> "I discussed this with supermicro and they informed me that the Kernel
>> itself is causing the issue, that it may be sending the hyperthreading
>> command code to the BIOS."
>>
>> Although I do not completely agree with their arguments, my knowledge
>> is not deep enough to recognize where exactly the core of the problem
>> is so I report this as a bug in a hope that someone will know what
>> happens when a kernel turns a computer off and what has changed in
>> kernel somewhere between the versions I mention above. I have asked
>> Supermicro distributor for more information on what they think happens
>> there and what exactly they mean by "hyperhreading command code" and I
>> am waiting for their response.
>>
>> -- Package-specific info:
>> ** Version:
>> Linux version 2.6.39-bpo.2-amd64 (Debian 2.6.39-3~bpo60+1) (norbert@tretkowski.de) (gcc version 4.4.5 (Debian 4.4.5-8) ) #1 SMP Tue Jul 26 10:35:23 UTC 2011
> [...]
>> ** Model information
>> sys_vendor: Supermicro
>> product_name: X8DTT
>> product_version: 1234567890
>> chassis_vendor: Supermicro
>> chassis_version: 1234567890
>> bios_vendor: American Megatrends Inc.
>> bios_version: 080016
>> board_vendor: Supermicro
>> board_name: X8DTT
>> board_version: 2.0
> [...]

