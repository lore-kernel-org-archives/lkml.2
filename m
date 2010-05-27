Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0E0GWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:22:44 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36169 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0E0GWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DfINcuBTHfrKCLhL52EY7NJ9GP16qeCUX1WaLmBhvtNmVHiI7cl37nWTDYJIN1wG9L
         7PxUxfSw5u5Xk8UatA3wNAuEJL6MJeUULlDtr/nEY6jrShE8x9vj/gZ7gqFtFJTAzLCb
         o6vkPIUksCPhj1Mr3nHf3BgjAa+pnfh8bWNIk=
Message-ID: <4BFE0FAB.9040009@gmail.com>
Date: Thu, 27 May 2010 00:22:35 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100513160117.GB22238@core.coreip.homeip.net> <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 10:54 AM, Linus Torvalds wrote:
>
>
> On Thu, 13 May 2010, Dmitry Torokhov wrote:
>>
>> Apple does proper thing in BIOS and omits keyboard and mouse PNP
>> devices, but because of other players we do not really trust PNP BIOS
>> and resort to banding on ports directly - there are cases when box has
>> mouse and/or keyboard but they are not present in BIOS. Damed if you do,
>> damned if you don't...
>
> Umm. No.
>
> PnP information _commonly_ doesn't inclure PS/2 ports, even when they
> exist. Lack of PnP information about the keyboard port means absolutely
> nothing, and anybody who tells you otherwise is totally and utterly wrong.
>
> So don't confuse this with PnP issues. That's a total red herring, and
> Apple is _not_at_all_ "doing the proper thing in the BIOS".
>
> Quite the reverse. Apple is very clearly doing something horribly _wrong_
> in their BIOS. Don't give them kudos for being incompetent morons.

I don't think they did anything wrong in their BIOS, it's working 
exactly as the spec intended. There is no PS/2 controller, and the ACPI 
PnP tables do not list one. I wouldn't argue that it was a good decision 
of them to have the hardware somehow blow up if something poked those 
ports anyway, but from a BIOS point of view they did the right thing.

>
> Just google for
>
> 	"Probing ports directly" "i8042 KBD port"
>
> and you'll get a lot of hits. That's not because those machines have wrong
> PnP tables - it's because fundamentally PNP is a joke, and on PC's what is
> much more important is "standard IO ports".
>
> For example, in that thread, Bastien is quoted:
>
> 	>  In other words, on x86, if PNP and/or ACPI don't indicate any PS/2
> 	>  controller exists, we randomly bang on the ports in the expectation
> 	>  they'll be there anyway. This seems rather misguided.
>
> and all that tells me is that Bastien doesn't know what he is doing. It is
> _not_ "randomly bang" - it's called standard PC hardware.  And it's not
> "misguided" - it's very much correct and required, exactly because PnP
> itself is the misguided aborted fetus of a braindamaged mind.

I think that may have been me, actually, not Bastien. Misguided may have 
been a too strong term, but in this case I think the PnP information is 
quite trustable because Windows trusts it. Definitely for the PS/2 mouse 
controller (quite likely the keyboard too), if Windows is in ACPI mode 
and the PnP tables do not list it, it will not detect or use it.

Now, many BIOSes seem to have have code (like an "auto" mode for the 
PS/2 port, which may or may not be always set) which disables the PnP 
entry if it doesn't detect a mouse or keyboard connected on boot. If 
memory serves, this is because I think at least on some versions, if 
Windows finds a controller but no mouse is responding then it shows up 
with an error indication in Device Manager, which tends to make people 
unhappy. This is likely what's responsible for most of those cases where 
Linux detects devices after "probing ports directly", because the BIOS 
hid the device but we were too "clever" for it and found it anyway.

In fact on a lot of boards, Linux still detects the port even if set as 
"disabled" in the BIOS, because all that does is disable the PnP entry.

Long and the short of it is, it seems pretty safe to say that on any 
ACPI machine, if there's no PnP entry for PS/2 devices, the BIOS does 
not intend for the OS to use them. There may be cases where you might 
want to try to locate ports anyway (maybe you really want to hotplug a 
mouse in after boot, or you have an ancient KVM which doesn't emulate a 
device presence on the non-selected machine), but those seem like very 
much the exception rather than the rule.

>
> We do not trust BIOS tables, because BIOS writers are invariably totally
> incompetent crack-addicted monkeys. If they weren't, they wouldn't be BIOS
> writers. QED. And in fact the Apple problem is an _example_ of this BIOS
> writer incompetence, not some shining example of them doing something
> right.
>
> 			Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

