Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0DTBb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 21:31:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65344 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab0DTBb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 21:31:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SJSz5WLlM2CxuYUEYGGZcyw58/xVykt4IkjdE/4yBFN8ScJUgQzU75Z3eoflbsgHGR
         D5DC74yrl7FvejQRdfuwSRWT+frBGNaUeqpBXUJsFk22GAP0hUFvqfJ0KANNbeco/uKI
         pNhc3aWpG0gttbq8i917dTUR8DFV7H2A+mJEQ=
Message-ID: <4BCD03E9.3080700@gmail.com>
Date: Mon, 19 Apr 2010 19:31:21 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?SmFuIEt1bmRyw6F0?= <jkt@gentoo.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: boot device order troubleshooting without an initrd
References: <4BCB87E2.4090807@gentoo.org> <20100418165125.1d2b2843@infradead.org> <4BCC203F.4070501@gentoo.org>
In-Reply-To: <4BCC203F.4070501@gentoo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 03:19 AM, Jan Kundrát wrote:
> Arjan van de Ven wrote:
>> so the problem is that the boot order you want is pretty much opposite
>> from what "normal" people want.
>> AHCI sata before CF slots is pretty much the right thing and what most
>> people will use.... most people will have their OS on AHCI SATA, and
>> occasionally stick in some photo card or whatever.... and they'd ask
>> the flipside question basically.
>
> On this particular motherboard, the CF slot is soldered to the bottom
> side of the PCB, so it is normally situated between the motherboard and
> the computer case, completely inaccessible to the user at runtime.
>
>> We could have pretty evil things in the kernel, so that we'd deal with
>> multiple root= lines in the kernel, one by one trying them until one
>> sticks. Right now we don't.... but if you make a clean enough patch
>> it might even pass the review here...
>
> If the ordering stays the same and such patch existed, I should probably
> use something like
> "root=/dev/sdf1,/dev/sde1,/dev/sdd1,/dev/sdc1,/dev/sdb1,/dev/sda1". Now,
>   I'd guess this would break as soon as I attempt to boot with a USB
> flash device present (I'm assuming it will be enumerated after the CF
> card, right?).
>
> So, in short, what I'd love to see is a special device alias which would
> mean the "BIOS-provided boot device". Would such an approach be
> reasonable? Is it possible at all?

The BIOS EDD information may provide information that would be useful 
for this. However, it seems not all systems implement it, and it's also 
not trivial to map the information it provides all the way back to 
figure out what actual device node to use. It gives you something like 
"BIOS INT13 device 0x80, which was presumably the boot device, is a SATA 
drive on port blah of PCI device blah", and then you have to dig up 
which device instance that is, look up the port it gives you, hoping the 
driver's port numbering is the same as whatever the BIOS used, then 
figure out what disk device that is, etc. And the whole thing is 
assuming the BIOS actually gave you correct information, which is far 
from certain.

It's possible to do all that, but that sort of logic likely doesn't 
really belong in the kernel, which means - you guessed it - an initrd. 
And in that case it's likely easier to just use mounting by label or 
UUID and avoid all the complexity.
