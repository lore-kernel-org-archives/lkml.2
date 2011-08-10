Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1HJN7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:59:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46413 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1HJN7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:59:16 -0400
Message-ID: <4E428EB0.1080204@gmail.com>
Date: Wed, 10 Aug 2011 08:59:12 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, weizeng.he@csr.com, workgroup.linux@csr.com,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Barry Song'" <21cnbao@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Olof Johansson'" <olof@lixom.net>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: Subject: L2x0 OF properties do not include interrupt #
References: <000201cc575b$c1229010$4367b030$@rutland@arm.com>
In-Reply-To: <000201cc575b$c1229010$4367b030$@rutland@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On 08/10/2011 07:48 AM, Mark Rutland wrote:
> Hi all,
> 
> I'm working on a driver for the PMU found in L220/PL310 L2 Cache Controllers
> (as an extension to the existing L2x0 code).
> 
> I've taken a look into what BSP support would be required and mocked up some
> platform_device support, though I notice that Rob Herring has provided
> devicetree bindings for the L2x0 ("l2x0: Add OF based initialization") which
> should probably be used to initialize the PMU (if present) from devicetree.
> 
> The L2x0 hardware supports a combined interrupt line, which is present on the
> Vexpress A9x4, EB11MPcore, PB1176, etc. This can be used to signal errors on
> read/write, parity checks, etc. The PMU also fires an interrupt on this line
> when any of its counters saturate.
> 
> Unfortunately the L2x0 OF bindings introduced by the patch don't include an
> (optional) interrupt property, which means the PMU driver won't be able to be
> initialised via devicetree. As we want to get as much as possible dynamically
> configured via devicetree, this is problematic.
> 
> I realise I'm a bit late to the party here, but I'd like to propose adding an
> optional interrupt parameter to the binding. I'm not aware of any
> implementations which use separate interrupts, but given the binding
> seems to be generic across L2CC implementations (and is not limited simply to
> the L2x0), having a list rather than a single interrupt may be appropriate for
> someone.

Good thing the party never ends...

> This would boil down to (for the moment) a Documentation change along the lines of:
> 
>> diff --git a/Documentation/devicetree/bindings/arm/l2cc.txt b/Documentation/devicetree/bindings/arm/l2cc.txt
>> index f50e021..d4b387b 100644
>> --- a/Documentation/devicetree/bindings/arm/l2cc.txt
>> +++ b/Documentation/devicetree/bindings/arm/l2cc.txt
>> @@ -28,6 +28,7 @@ Optional properties:
>>  - arm,filter-ranges : <start length> Starting address and length of window to
>>    filter. Addresses in the filter window are directed to the M1 port. Other
>>    addresses will go to the M0 port.
>> +- interrupt : A combined interrupt.
>>  
>>  Example:
>>  
>> @@ -39,4 +40,5 @@ L2: cache-controller {
>>          arm,filter-latency = <0x80000000 0x8000000>;
>>          cache-unified;
>>          cache-level = <2>;
>> +        interrupt = <45>;
>>  };
> 
> Any thoughts?

I think you should allow for either the single irq or individual irqs.
You can specify that the event counter interrupt must be first, then the
pmu driver could work either way ignoring the rest. The driver probably
needs to mark the handler as shared if there is only the combined
interrupt unless you expect all interrupts to be handled by 1 driver.

Rob

> 
> Thanks,
> Mark
> 
> 

