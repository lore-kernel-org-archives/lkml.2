Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0K0HMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 02:12:32 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61129 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0K0HMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 02:12:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=I4zIZJYc5oFNh+aMPmCywOMQ03Mje2xd05qyuqiUG4d5Y3L4uq8gf14skC+qMYcV86
         h8gUcE4UuUV/QQ1zDxkhqiO2yPqBGg4BFW8vmAgQWKrcZs1TgBYm5Tiu4EX8QLueVlNv
         Ph3e4jNEeKQRZpguq6lhxbNaKySL0Vn5yUQzQ=
Message-ID: <4CF0AF5C.6010003@gmail.com>
Date: Sat, 27 Nov 2010 12:12:28 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101029 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Nobody cared about IRQs at shutdown
References: <Pine.LNX.4.44L0.1011251522380.26094-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011251522380.26094-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

26.11.2010 01:25, Alan Stern wrote:
> On Thu, 25 Nov 2010, Alexander E. Patrakov wrote:
>
>> 25.11.2010 21:06, Alan Stern wrote:
>>> On Thu, 25 Nov 2010, Alexander E. Patrakov wrote:
>>>
>>>> Hello.
>>>>
>>>> After switching my Gentoo desktop from sysvinit + openrc to systemd, I
>>>> started getting "nobody cared" messages about IRQs 16 and 19 (common
>>>> thing: they are assigned to the USB controllers, that's why CC:
>>> According to your listing, they are used by uhci-hcd.  Do the messages
>>> go away if you unload uhci-hcd before shutting down?
>> It is not a module here, so I have to recompile the kernel in order to
>> try this. Will do that tomorrow.
>>
>>> You may need to debug the uhci-hcd driver. Look into
>>> drivers/usb/host/uhci-hcd.c; the uhci_shutdown() routine ought to be
>>> called and it ought to call uhci_hc_died(), which in turn calls
>>> uhci_reset_hc() in pci-quirks.c, which is supposed to prevent the
>>> controller from generating any IRQs.
>> OK, tomorrow I will add some printks there.

Sorry, I didn't add them due to being busy with a different (non-kernel) 
bug. What do you want to know - just the fact that these functions are 
called before or after reporting the bad IRQ?

>>> Do you have any USB devices attached to bus 3 or bus 6?
>> Yes:
>>
>> Bus 006 Device 002: ID 05d8:4002 Ultima Electronics Corp. Artec Ultima
>> 2000 (GT6801 based)/Lifetec LT9385/ScanMagic 1200 UB Plus Scanner
>>
>> Should I unplug it and retest the bug now?
> Sure.

Tried, it didn't change anything.

> Even without rebuilding the kernel, you can unbind the uhci-hcd driver
> from the hardware by going to the /sys/bus/pci/drivers/uhci_hcd
> directory and doing:
>
> 	echo -n device-name>unbind
>
> where "device-name" is the name of one of the symlinks in that
> directory.

Thanks for the tip. Below are the updated test results, including the 
ones posted in my first mail, for completeness.

1. No irqpoll, no unbind: the system reports that nobody cared for IRQs, 
then waits, displays SATA errors, waits again, shuts down.

2. irqpoll, no unbind: the system shuts down without any delays.

3. No irqpoll, unbind uhci-hcd from everything it controls: the system 
reports bad IRQ 19 (consumed by firewire-ohci), waits, displays SATA 
errors, waits again, shuts down.

4. No irqpoll, unbind both uhci-hcd and firewire-ohci from everything: 
the system does not report any bad IRQs, waits, displays SATA errors, 
waits again, shuts down.

5. irqpoll, unbind both uhci-hcd and firewire-ohci from everything: same 
as (4).

I have no firewire devices.

-- 
Alexander E. Patrakov
