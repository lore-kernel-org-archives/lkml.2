Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab0FOKgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:36:46 -0400
Received: from mail-yw0-f204.google.com ([209.85.211.204]:55564 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab0FOKgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:36:44 -0400
MIME-Version: 1.0
In-Reply-To: <4C16AAEE.5090204@kernel.org>
References: <1276443098-20653-1-git-send-email-tj@kernel.org> 
	<1276443098-20653-13-git-send-email-tj@kernel.org> <20100614214122.GA21064@suse.de> 
	<4C16A48A.2070404@kernel.org> <4C16AAEE.5090204@kernel.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 15 Jun 2010 12:30:00 +0200
Message-ID: <AANLkTilG1KAVOe5DcpLEFAJ-37PQJCgVT-jLZhr1e6tC@mail.gmail.com>
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

On Tue, Jun 15, 2010 at 00:19, Tejun Heo <tj@kernel.org> wrote:
> On 06/14/2010 11:52 PM, Tejun Heo wrote:
>> On 06/14/2010 11:41 PM, Greg KH wrote:
>>> So if there's a routing problem, it turns into a polled interrupt?  Do
>>> we really want that?
>>
>> Oh yeah, I really want that for libata.  Routing is only part of the
>> problem and flaky IRQ is something we have to learn to cope with.
>>
>>> I wonder how long people will run without realizing that there are
>>> problems with their system if their devices still work.
>>
>> I think things would be better this way.  If the drives (both cd and
>> hard) / input devices are not accessible, most people would simply
>> give up rather than reporting, and many cases are transient problems
>> which happen only once in the blue moon.
>>
>> It would be great if some kind of automatic reporting can be used
>> (similar to kerneloops?).  Hmm... maybe make the warnings scarier?
>
> Hmm... maybe what we can do is generating an uevent when an IRQ is
> confirmed to be bad and then let udev notify the user.  That way we'll
> probably have better chance of getting bug reports and users have
> whiny but working system.

Not really, uevents are not picked up by anything that could report an
error to userspace, they are just seen by udev. Also uevents are
usually not the proper passing method. They are not meant to ever
transport higher frequency events, or structured data. They cause to
run the entire udev rule matching machine, and update symlinks and
permissions with every event.

We will need some better error reporting facility. On Linux you don't
even get notified when the kernel mounts your filesystem read-only
because of an error. It will only end up in 'dmesg' as a pretty much
undefined bunch of words. :)

We will need some generic error reporting facility, with structured
data exported, and where userspace stuff can subscribe to.
Uevents/udev can not really properly provide such infrastructure.
Maybe that can be extended somehow, but using kobject_uevent() and
trigger the usual udev rule engine is not what we are looking for, for
sane error reporting.

Kay
