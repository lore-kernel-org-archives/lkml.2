Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab0FCAF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:05:29 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:51173 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647Ab0FCAF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:05:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xEcFMaAN1+t3Q13SaLJOl0rUlZvLtFWYd9tdzF3BN/cspcIhpjDnjVVbF0SVc+RW1I
         UijcnM31sh4kKMfi1UU7nGgDpFx7Pa6XzmahtToPmdKdSVljfbUhg5vFCHi8Cq58cBCZ
         EibahlDBri88ZkKeO3A85CFjOvZEanjoy3C+A=
Message-ID: <4C06F1DD.8060004@gmail.com>
Date: Wed, 02 Jun 2010 17:05:49 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
References: <20100601192101.GA15086@srcf.ucam.org>	<4C056839.8020605@gmail.com>	<20100601200704.GA16091@srcf.ucam.org>	<4C056AE6.3000409@gmail.com>	<20100601202130.GA16391@srcf.ucam.org>	<4C056E0C.2030709@gmail.com>	<20100601203351.GA16575@srcf.ucam.org>	<4C0572B4.6000201@gmail.com>	<20100601211219.GA17719@srcf.ucam.org>	<4C057AE9.9020307@gmail.com>	<20100601212901.GA18390@srcf.ucam.org>	<4C057EF0.2030808@gmail.com>	<4C05E800.1010400@gmail.com>	<4C05F3BF.6090503@gmail.com> <AANLkTinyxtHQrsgvV0CMQZnyEelVnrpCTM05PLAj-ZYx@mail.gmail.com> <4C06ECAA.3060708@gmail.com> <4C06ED18.2010400@gmail.com>
In-Reply-To: <4C06ED18.2010400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 04:45 PM, Robert Hancock wrote:
> On 06/02/2010 05:43 PM, Justin P. Mattock wrote:
>> On 06/02/2010 04:18 PM, Robert Hancock wrote:
>>> On Wed, Jun 2, 2010 at 12:01 AM, Justin P. Mattock
>>> <justinmattock@gmail.com> wrote:
>>>>> Can you post the FACP section of the acpidump output from this
>>>>> machine?
>>>>>
>>>>
>>>> here you go:
>>>>
>>>
>>>
>>>> Reset Register Supported (V2) : 1
>>>
>>>> [074h 116 12] Reset Register :<Generic Address Structure>
>>>> [074h 116 1] Space ID : 01 (SystemIO)
>>>> [075h 117 1] Bit Width : 08
>>>> [076h 118 1] Bit Offset : 00
>>>> [077h 119 1] Access Width : 00
>>>> [078h 120 8] Address : 0000000000000CF9
>>>>
>>>> [080h 128 1] Value to cause reset : 06
>>>
>>> Hmm, so the FADT says the reset register is listed as supported, and
>>> says writing 0x06 to 0xCF9 is supposed to do it.. That's exactly what
>>> this should do:
>>>
>>> #include<sys/io.h>
>>>
>>> int main() {
>>> iopl(3);
>>> outb(6, 0xcf9);
>>> return 0;
>>> }
>>>
>>> but you said that didn't do anything.. It kind of seems like ACPI
>>> reboot is busted on this machine then, but then I wonder how Windows
>>> manages to work..
>>>
>>
>>
>> alright!! I have a better idea at what this is now..
>> as for the above code, yes this one segfaults,
>> the other code posted on the thread just returns
>> a command prompt(testing:
>
> You get a segfault on that one? Running as root?
>

my bad(tired)I left out iopl(3);
in the code which was giving a segfault.

running the below code(s) just gives a command prompt

int main() {
	iopl(3);
	outb(0xfe, 0xcf9);
	return 0;
}

int main() {
	iopl(3);
	outb(6, 0xcf9);
	return 0;
}

int main() {
	iopl(3);
	outb(6, 0x64);
	return 0;
}

int main() {
	iopl(3);
	outb(0xfe, 0x64);
	return 0;
}


(and yes I made sure I did this as root!!)

:-)

>>
>> #include <sys/io.h>
>>
>> int main() {
>> iopl(3);
>> outb(0xfe, 0xcf9);
>> return 0;
>> }
>> on a dell reboot's as is.)
>>
>> both my macbook, and imac are
>> broken with the above.(but for whatever
>> reason the macbook doesnt need an dmi entry
>> in reboot.c just iMac9,1 etc..)
>>
>> so the address for the CF9 is this:
>>
>> [074h 116 12] Reset Register : <Generic Address Structure>
>> [074h 116 1] Space ID : 01 (SystemIO)
>> [075h 117 1] Bit Width : 08
>> [076h 118 1] Bit Offset : 00
>> [077h 119 1] Access Width : 00
>> [078h 120 8] Address : 0000000000000CF9
>>
>> [080h 128 1] Value to cause reset : 06
>> [081h 129 3] Reserved : 000000
>> [084h 132 8] FACS Address : 00000000BFECD000
>> [08Ch 140 8] DSDT Address : 00000000BFEE0000
>> [094h 148 12] PM1A Event Block : <Generic Address Structure>
>> [094h 148 1] Space ID : 01 (SystemIO)
>> [095h 149 1] Bit Width : 20
>> [096h 150 1] Bit Offset : 00
>> [097h 151 1] Access Width : 00
>> [098h 152 8] Address : 0000000000000400
>>
>> not sure how to read this, but are there
>> two devices here i.g.
>> is the top a cold boot(reset register) and
>> the bottom(value to cause reset) a warm boot?
>
> No, the stuff after "Value to cause reset" is something else entirely.
>
alright!!
Im wondering if KBD_STATUS_REG is wrong on this machine?
and/or 0x472(will look into this stuff)
>>
>> at the moment I'm trying to figure out what/where
>> *((unsigned short *)__va(0x472)) = reboot_mode;
>> 0x472 comes from as well as 0x1234 then
>> #define KBD_STATUS_REG 0x64
>> to see if I can see anything.
>>
>>
>> thanks for the info on this..
>>
>> Justin P. Mattock
>>
>
>

cheers,

Justin P. Mattock
