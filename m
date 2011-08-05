Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1HEPUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:20:32 -0400
Received: from smtp-out.google.com ([74.125.121.67]:53662 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1HEPUa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:20:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tSg8EwPt5Pa7OGxhKLD0l1jlgh3NOk12yV9zaJ2f+ackRethE1pv+zBNrb9nzZhxE
	LIBWIAo9po9gZebGr++Kw==
MIME-Version: 1.0
In-Reply-To: <CAAJw_ZvZEn0qVG3JVfEWFQbOSjVUCJhBwQ2Dw5KQyDx2kY4xbA@mail.gmail.com>
References: <CAAJw_ZvnUPs5wD6hU059GcKRkyeNn7Y36fk9nNjNFJ6kNmL0uw@mail.gmail.com>
 <20110804105657.GA27681@centrinvest.ru> <CAErSpo5aE=cUPXf-bcrk8sNAWFCEAC2wQAvXZy7P9q5_A6=qMA@mail.gmail.com>
 <CAAJw_ZvZEn0qVG3JVfEWFQbOSjVUCJhBwQ2Dw5KQyDx2kY4xbA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 5 Aug 2011 09:20:07 -0600
Message-ID: <CAErSpo4uUsfKyON_5gxLikH2F0R7q-fBJ0+04vj2CrCH0r1q4g@mail.gmail.com>
Subject: Re: How to access serial port that is set in BIOS as OS Controlled
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 7:59 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
>
> On Fri, Aug 5, 2011 at 1:39 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> On Thu, Aug 4, 2011 at 4:56 AM, Andrey Panin <pazke@centrinvest.ru> wrote:
>> > On 209, 07 28, 2011 at 01:43:11PM +0800, Jeff Chua wrote:
>> >> I'm trying to access the serial port ttyS2 that is set in the BIOS as
>> >> "OS Controlled" without much success. If it's set it to "Always
>> >> Enabled",  I can access the serial port.
>>
>> >> If I set the BIOS to "OS Controlled", I can't access the serial port
>> >> no matter what parameter I pass to the setserial. The factory default
>> >> is "OS Controlled", and Window XP can detect and access the port.
>> >> There will be hundreds of CV60 to get into the BIOS to set it one by
>> >> one. If there's a way to access the port in linux, it'll be great!
>> >
>> > Does lspnp show this port in "OS Controlled" mode ?
>>
>> It would definitely be interesting to know what lspnp says, but I
>> suspect there might be even more to it.
>>
>> Linux can find UARTs via PNP (via PNPACPI on modern boxes).  But we
>> also poke blindly at the legacy I/O port addresses in
>> SERIAL_PORT_DFNS, which includes 0x3e8, so we should have found it
>> that way even if we didn't find it via PNP.
>>
>> My guess is that in "OS Controlled" mode, the port is initially
>> powered off or disconnected, so we can't find it, and there's some
>> ACPI method that would turn it on.  Windows might be enabling it
>> automatically.
>>
>> Can you also collect the DSDT so we can investigate this possibility?
>> There are instructions here:
>> http://kernel.org/pub/linux/kernel/people/helgaas/debug .  You might
>> want to open a bug report at http://bugzilla.kernel.org to have a
>> place to attach the DSDT and some dmesg logs.  I would start by filing
>> it under "ACPI / Config-Other".
>
> I tried it a bit more after reading  /usr/src/linux/Documentation/pnp.txt
> and got turned out that to enable to "OS Controlled" serial touch screen,
> I've to do this ...
>
> echo "auto" > /sys/bus/pnp/devices/00:0a/resources
>
> This seems to work.

OK.  That's a good clue, and maybe a good enough workaround for your
immediate need.

But I think the fact that it doesn't "just work" is a Linux bug, and
it'd be nice to fix it.  My guess is that running _SRS is what makes
the port work, and that Windows does this automatically but Linux does
not.  If we can figure out exactly what the difference is, there's a
good chance that we can fix several Linux issues by just doing things
the way Windows does.

Would you mind building with CONFIG_PNP_DEBUG_MESSAGES=y, booting with
"pnp.debug", issuing the "auto" command, and attaching the dmesg log
to this bug report?

  https://bugzilla.kernel.org/show_bug.cgi?id=40612

Thanks!

Bjorn
