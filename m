Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab0FONg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:36:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55278 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab0FONg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <4C176206.90305@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org> 
	<1276443098-20653-13-git-send-email-tj@kernel.org> <20100614214122.GA21064@suse.de> 
	<4C16A48A.2070404@kernel.org> <4C16AAEE.5090204@kernel.org> 
	<AANLkTilG1KAVOe5DcpLEFAJ-37PQJCgVT-jLZhr1e6tC@mail.gmail.com> 
	<4C176206.90305@kernel.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 15 Jun 2010 15:36:41 +0200
Message-ID: <AANLkTinVL4UuF70E1dR1vbYYkVRTBDh5su5D9k0h-vVA@mail.gmail.com>
Subject: Re: [PATCH 12/12] usb: use IRQ watching
To: Tejun Heo <tj@kernel.org>
Cc: Greg KH <gregkh@suse.de>, mingo@elte.hu, tglx@linutronix.de,
       bphilips@suse.de, yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       khali@linux-fr.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 13:20, Tejun Heo <tj@kernel.org> wrote:
> On 06/15/2010 12:30 PM, Kay Sievers wrote:
>>> Hmm... maybe what we can do is generating an uevent when an IRQ is
>>> confirmed to be bad and then let udev notify the user.  That way we'll
>>> probably have better chance of getting bug reports and users have
>>> whiny but working system.
>>
>> Not really, uevents are not picked up by anything that could report an
>> error to userspace, they are just seen by udev. Also uevents are
>> usually not the proper passing method. They are not meant to ever
>> transport higher frequency events, or structured data. They cause to
>> run the entire udev rule matching machine, and update symlinks and
>> permissions with every event.
>
> Oh, these will be very low frequency event.  At most once per
> irq_expect or irqaction.  e.g. on a machine with four hard drives, it
> can only happen four times after boot unless the driver is unloaded
> and reloaded, so from frequency standpoint it should be okay.
>
>> We will need some better error reporting facility. On Linux you don't
>> even get notified when the kernel mounts your filesystem read-only
>> because of an error. It will only end up in 'dmesg' as a pretty much
>> undefined bunch of words. :)
>
> That one is a very low frequency too.
>
>> We will need some generic error reporting facility, with structured
>> data exported, and where userspace stuff can subscribe to.
>> Uevents/udev can not really properly provide such infrastructure.
>> Maybe that can be extended somehow, but using kobject_uevent() and
>> trigger the usual udev rule engine is not what we are looking for, for
>> sane error reporting.
>
> It's true that there are higher frequency events which will be
> horrible to report via kobject_uevent().  Hmmm... but the thing is
> that events which should annoy the user by userland notification can't
> be definition high freq.  There's only so many users can recognize and
> respond, so the frequency limitation of uevent might actually fit here
> although it would be nice to have some kind of safety mechanism.
> Still no go for uevent?

Yeah, I'm pretty sure that's not what we want. We want structured
data, and a generic channel to pass all sort of errors through, and a
userspace part to handle it in a sane way. Many error sources may also
not have a device path in /sys, and therefore no uevent to send.
Uevents/udev just seem so convinient because it's already there, but I
think, has too many limitations to provide the needed functionality.
Besides the fact that nothing listens to these events in userspace
today -- it's a lot more to think through and work on than passing
things through uevents, especially some generic classification and
structured data passing, which is needed, instead of the current
free-text 'dmsg' or the property-based stuff in uevents. I'm very sure
it's the wrong facility to use.

Kay
