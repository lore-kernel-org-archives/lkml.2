Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab0FONab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:30:31 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37806 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab0FONaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:30:30 -0400
MIME-Version: 1.0
In-Reply-To: <20100615130518.1a62210a@hyperion.delvare>
References: <1276443098-20653-1-git-send-email-tj@kernel.org> 
	<1276443098-20653-13-git-send-email-tj@kernel.org> <20100614214122.GA21064@suse.de> 
	<4C16A48A.2070404@kernel.org> <4C16AAEE.5090204@kernel.org> 
	<AANLkTilG1KAVOe5DcpLEFAJ-37PQJCgVT-jLZhr1e6tC@mail.gmail.com> 
	<20100615130518.1a62210a@hyperion.delvare>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 15 Jun 2010 15:30:14 +0200
Message-ID: <AANLkTinnpbSVfA1vWWDdVHy0UpLh-SlAXXg0o54OgXFi@mail.gmail.com>
Subject: Re: [PATCH 12/12] usb: use IRQ watching
To: Jean Delvare <khali@linux-fr.org>
Cc: Tejun Heo <tj@kernel.org>, Greg KH <gregkh@suse.de>, mingo@elte.hu,
       tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 13:05, Jean Delvare <khali@linux-fr.org> wrote:
> On Tue, 15 Jun 2010 12:30:00 +0200, Kay Sievers wrote:
>> On Tue, Jun 15, 2010 at 00:19, Tejun Heo <tj@kernel.org> wrote:
>> > Hmm... maybe what we can do is generating an uevent when an IRQ is
>> > confirmed to be bad and then let udev notify the user.  That way we'll
>> > probably have better chance of getting bug reports and users have
>> > whiny but working system.
>>
>> Not really, uevents are not picked up by anything that could report an
>> error to userspace, they are just seen by udev. Also uevents are
>> usually not the proper passing method. They are not meant to ever
>> transport higher frequency events, or structured data. They cause to
>> run the entire udev rule matching machine, and update symlinks and
>> permissions with every event.
>>
>> We will need some better error reporting facility. On Linux you don't
>> even get notified when the kernel mounts your filesystem read-only
>> because of an error. It will only end up in 'dmesg' as a pretty much
>> undefined bunch of words. :)
>>
>> We will need some generic error reporting facility, with structured
>> data exported, and where userspace stuff can subscribe to.
>> Uevents/udev can not really properly provide such infrastructure.
>> Maybe that can be extended somehow, but using kobject_uevent() and
>> trigger the usual udev rule engine is not what we are looking for, for
>> sane error reporting.
>
> Random idea of the day (I don't know anything about it all): let the
> kernel connect to D-Bus and use it somehow?

Yeah, D-Bus is an peer-to-peer IPC mechanism/protocol. The D-Bus
daemon can filter and multiplex/distibute messages.

It's very similar to what we can do with netlink. The netlink
multicast stuff can even provide lots of the functionality the D-Bus
daemon provides.

I think we should avoid the D-Bus complexity for the very low-level
stuff. Very much like udev is not using it, but has efficient
in-kernel message filtering based on Berkeley Packet Filters, and
multiple listeners event subscription/distribution based on netlink
multicast functionality.

Not sure if netlink is the right answer here, but it's surely easier
to handle than D-Bus, and would provide a very similar functionality.

Kay
