Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0J1Tu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:50:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:37228 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab0J1TuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:50:25 -0400
Message-ID: <52441.84.105.60.153.1288295412.squirrel@gate.crashing.org>
In-Reply-To: <20101028011147.26254.qmail@kosh.dhis.org>
References: <20101028011147.26254.qmail@kosh.dhis.org>
Date: Thu, 28 Oct 2010 21:50:12 +0200 (CEST)
Subject: Re: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug,
From: "Segher Boessenkool" <segher@kernel.crashing.org>
To: pacman@kosh.dhis.org
Cc: "Segher Boessenkool" <segher@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So is it wrong to leave the host controller enabled when the OS is booted?

Yes.  Or, rather, there should be some way for the client to turn off
all dma and interrupt activity; if the client closes the ihandles in
"/chosen", and perhaps calls "quiesce", that should be enough.



> If
> not, then the error must be in the communication of which memory addresses
> are in use by OF. I've got a node /memory@0 whose "available" property
> looks
> like this:
>  00000000 00400000
>  00584000 0007c000
>  0092a1d8 00004e28
>  00a2f000 005d1000
>  01800000 0e3fd000
>  0fbffab4 0000054c
>>From that list, it looks to me like OF is telling the kernel that it
>> should
> not attempt to use any address above 0xfbffab4+0x54c == 0xfc00000.

The client is allowed to "take over" all memory, if it doesn't call OF
after doing so.  This won't work if some device scribbles on it, as
you have seen.

> Later, when the kernel decides it's done using OF, what's supposed to
> happen?
> It closes stdin, but that doesn't help here since the offending device is
> a
> bus node, not an input node. It looks to me like the kernel makes the
> assumption that all devices other than stdin and stdout will have been
> deactivated already when the kernel starts, and that this assumption has
> been violated. Who is wrong, from the perspective of the OF standard, the
> assumer or the violator?

The violator.

>> Lovely, incorrect data (it should start with 82002810, i.e.,
>> not relocatable -- it is already an assigned address!).
>
> Now you see how I have trouble relating the docs to the reality...

Yeah :-(

>> This means: 32-bit MMIO address space for bus 0 dev 5 fn 0,
>> first BAR; assigned to address 80000000; size is 1000.
>
> But "address 80000000" is a physical address (I think), so do I need to do
> a
> map-in on it before using it?

Yes.

>> You could try a boot script like this:
>>
>>
>> dev /pci
>> 0 ffff04 DO 0 i config-w! -100 +LOOP
>> device-end
>>
>>
>> which should disable all PCI devices on all busses, on that
>
> Almost all of my devices are under that PCI node. What will I prove by
> disabling them?

You should put it after "load", and before "go".

It should give you a working system; it's a sledgehammer workaround.


Segher

