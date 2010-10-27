Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0J0XeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:34:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:43278 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983Ab0J0XeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:34:05 -0400
Message-ID: <50748.84.105.60.153.1288222432.squirrel@gate.crashing.org>
In-Reply-To: <20101027225855.25345.qmail@kosh.dhis.org>
References: <20101027225855.25345.qmail@kosh.dhis.org>
Date: Thu, 28 Oct 2010 01:33:52 +0200 (CEST)
Subject: Re: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug,
From: "Segher Boessenkool" <segher@kernel.crashing.org>
To: pacman@kosh.dhis.org
Cc: "Segher Boessenkool" <segher@kernel.crashing.org>,
        "Olaf Hering" <olaf@aepfle.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 1) Figure out what exactly is going on;
>
> I thought we were past that.

We are not.

> The startup sequence leaves the device in a
> bad
> state (writing 1000 times per second to memory that the kernel believes is
> not in use), so it needs to be given a reset command before the kernel
> tries
> to use that memory.

The question now is what causes the firmware to do that, and then
what is the best way to stop it from doing that.

>> > The big question that I'm still stumbling over is how to access the
>> device
>> > registers. The "reg" property looks like this:
>>
>> You should look at "assigned-addresses", not "reg".  Well,
>> you first need to look at "reg" to figure out what entry
>> in "assigned-addresses" to use.

Ignore this part, I was confused.

> The properties look like this:
>
> /pci@80000000/usb@5/assigned-addresses
>  02002810 00000000 80000000 00000000 00001000

Lovely, incorrect data (it should start with 82002810, i.e.,
not relocatable -- it is already an assigned address!).

This means: 32-bit MMIO address space for bus 0 dev 5 fn 0,
first BAR; assigned to address 80000000; size is 1000.

You could try a boot script like this:


dev /pci
0 ffff04 DO 0 i config-w! -100 +LOOP
device-end


which should disable all PCI devices on all busses, on that
PCI host bus (it disables every device behind pci-pci bridges
separately, as long as every such bridge has a higher secondary
bus number than primary bus number; if you only want to disable
everything on the root bus (which should be sufficient), use
ff04 instead of ffff04).


Segher

