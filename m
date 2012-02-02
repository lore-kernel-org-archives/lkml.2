Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab2BBTVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:21:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54130 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214Ab2BBTVQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:21:16 -0500
MIME-Version: 1.0
X-Originating-IP: [71.233.110.244]
In-Reply-To: <4F27D9AD.1020806@pobox.com>
References: <4E68A6E8.9020700@pobox.com> <20110908165155.f661a738.akpm@linux-foundation.org>
 <4F26B162.4050000@pobox.com> <4F274E28.2010200@gmail.com> <4F27D9AD.1020806@pobox.com>
From: Edward Donovan <edward.donovan@numble.net>
Date: Thu, 2 Feb 2012 14:20:54 -0500
X-Google-Sender-Auth: MVyfuzoL6RPAC7wpgXvciByCh5g
Message-ID: <CADdbW+Eaab4ucATwX+ao-P+kcms-AJKQMGZr2E6g73gLACZSZg@mail.gmail.com>
Subject: Re: ASM1083 PCIx-PCI bridge interrupts - widespread problems
To: Chris Palmer <chris.palmer@pobox.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        ghost3k@ghost3k.net, linux-kernel@vger.kernel.org, keve@irb.hu,
        bjorn.ottervik@gmail.com, kaneda@freemail.hu,
        jeroen.vandenkeybus@gmail.com, clemens@ladisch.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm just a bystander here, but interested, since I've been asked
about it a few times)

On Tue, Jan 31, 2012 at 7:08 AM, Chris Palmer <chris.palmer@pobox.com> wrote:
>
> On 31/01/2012 02:12, Robert Hancock wrote:
>> On 01/30/2012 09:04 AM, Chris Palmer wrote:
>>> Linus et al
>>>
>>>
>>> For about 6 months many users have been having interrupt problems
>>> with PCI boards, but it hasn't been
>>> easy trying to find where the problem may be. However, it is now
>>> looking likely that the problem lies
>>> in the ASM1083 PCIe-PCI bridge chipset, as used by Asus in many
>>> Sandybridge and AMD boards.
>>>
>>> My original bug report is:
>>>      https://bugzilla.kernel.org/show_bug.cgi?id=38632  (Sandybridge)
>>>
>>> and there several other similar ones. However there is also extensive
>>> investigation in the following thread:
>>>      http://www.gossamer-threads.com/lists/linux/kernel/1466185  (AMD)
>>>
>>> There have also been reports of Windows users having similar problems.
>>>
>>> This problem prevents use of PCI boards in any motherboard with that
>>> bridge chipset - including most
>>> ASUS boards. At the moment though we don't know whether the chipset
>>> or drivers are faulty, and if a
>>> workaround is possible.
>>>
>>> At the moment my bug is assigned to drivers_network, but this doesn't
>>> look appropriate.
>>>
>>> Hoping someone can help...
>>
>> If the analysis posted in the "Unhandled IRQs on AMD E-450" thread is
>> correct, then it sounds like the bridge chip is delaying PCIe INTx
>> deassert messages. In that case there isn't much the kernel is likely
>> to be able to fix it properly, at least not without input from ASMedia
>> or someone else with detailed knowledge of the chip.
>>
>> The workaround posted in that thread (switching to IRQ polling mode on
>> the interrupt for some period of time after a screaming IRQ is
>> detected) might be a workaround, but definitely would be considered a
>> hack.
>>
>> Do you have a source/link for people having issues with this on
>> Windows? I wouldn't be surprised though - I doubt Windows has any
>> special handling for unhandled IRQs so likely it just hammers the IRQ
>> handler until the IRQ gets deasserted. In that case the only thing a
>> user might notice would be poor performance whenever the devices
>> behind that bridge raise interrupts.
>>
>
> Nothing definitive about Windows, but Edward found this discussion. It's
> a bit emotive, but suggests the problem may be manifesting itself there too:
>
> http://forums.planetz.com/viewtopic.php?f=19&t=30557&sid=00d319732500eaf99c586b73060a9602
>
> Chris

If we end up helpless with this chip, will we at least warn the user
that it's known to be buggy?  I dont' know if there's a standard
procedure when documenting bad hardware.

I've CC'd a few more people who have reported this, and Clemens, who
got to the bottom of it.

Thanks,

Ed





>>> On 09/09/2011 00:51, Andrew Morton wrote:
>>>
>>>> On Thu, 08 Sep 2011 12:28:40 +0100
>>>> Chris Palmer<chris.palmer@pobox.com>  wrote:
>>>>
>>>>> Andrew
>>>>>
>>>>> I'm writing to ask if you could cast a quick eye over the following
>>>>> bugs, to give an opinion on where they should be assigned. Mine has
>>>>> been
>>>>> reassigned to Network Drivers but I'm not convinced that is right,
>>>>> and I
>>>>> think the problem is wider than that.
>>>>>
>>>>> In summary, interrupt handling for *PCI boards with ASUS Sandybridge
>>>>> motherboards* seems to be broken.
>>>>>
>>>>> It has been seen with network and non-network PCI boards. PCIx network
>>>>> boards work OK. And all reports are for ASUS motherboards.
>>>>>
>>>>> My bug report is
>>>>>
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=38632
>>>>>
>>>>> Others that I know of are:
>>>>>
>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=713351
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=35332
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=34242
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=32242
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=39122
>>>>>
>>>>>
>>>>> I'm now on kernel 3.0.4 with the problem still there. The only thing
>>>>> that seems to make a difference is acpi=off (although one person
>>>>> reported that it merely changed it from minutes to days before
>>>>> occurring).
>>>>>
>>>>> I'd appreciate anything you could do to move this in the right
>>>>> direction...
>>>>>
>>>>
>>>> Most likely ACPI, I expect.  I think that's
>>>> acpi-config-interrupts@bugzilla.kernel.org.  kernel.org DNS is dead at
>>>> present and I can't check.
>>>>
>>>> Len, can you suggest how to triage these please?
>>
