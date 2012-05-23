Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab2EWEIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:08:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39351 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2EWEIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:08:35 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FBC6234.50804@jp.fujitsu.com>
Date: Wed, 23 May 2012 13:06:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Wen Congyang <wency@cn.fujitsu.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: add max_addr boot option
References: <4FBB3A23.50102@cn.fujitsu.com> <4FBBEE49.2020806@landley.net>
In-Reply-To: <4FBBEE49.2020806@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/23 4:51), Rob Landley wrote:

> On 05/22/2012 02:02 AM, Wen Congyang wrote:
>> If we only want to use node0, we can specify the max_addr. The boot
>> option "mem=" can do the same thing now. But the boot option "mem="
>> means the total memory used by the system. If we tell the user
>> that the boot option "mem=" can do this, it will confuse the user.
>> So we need an new boot option "max_addr" on x86 platform.
> 
> I didn't follow that reasoning at all.  Care to try again?
> 
> (mem= can do this, but telling users that would confuse them?  What?)
> 


Kernel doc says

mem=nn[KMG]             [KNL,BOOT] Force usage of a specific amount of memory
                        Amount of memory to be used when the kernel is not able
                        to see the whole system memory or for test.
                        [X86-32] Use together with memmap= to avoid physical
                        address space collisions. Without memmap= PCI devices
                        could be placed at addresses belonging to unused RAM.

max_addr=nn[KMG]        [KNL,BOOT,ia64] All physical memory greater
                        than or equal to this physical address is ignored.

And, now, on x86+e820, mem= option works as max_addr= option.

This caused some troubles in our customer sometimes. In many server, address
range 3G-4g are reserved for PCI.

This is my host's dmesg.
==
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bfee0000 (usable)
 BIOS-e820: 00000000bfee0000 - 00000000bfee7000 (ACPI data)
 BIOS-e820: 00000000bfee7000 - 00000000bff00000 (ACPI NVS)
 BIOS-e820: 00000000bff00000 - 00000000bff80000 (usable)
 BIOS-e820: 00000000bff80000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fe000000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000640000000 (usable)
==

So, if customer sets mem=10G, the system will boot with 9G memory.
I think this is a bug and mem= should see 'amount of memory'.

For users who want to hide memory in higher address, I think
max_addr= option is suitable.

Thanks,
-Kame











