Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0KJBTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:19:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64423 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0KJBTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <1289351423.22787.22.camel@concordia>
References: <1289339119.2191.92.camel@laptop> <20101109221338.GA19947@suse.de>
 <1289345811.10536.8.camel@concordia> <AANLkTi=UftgQn0ydRd2wszqFtpRrkEcW7dzfapKKix_V@mail.gmail.com>
 <1289350360.22787.9.camel@concordia> <AANLkTikGHNkUN6t9rPhdE6XOQiqb5xAzH_9eY6L9h2H2@mail.gmail.com>
 <1289351423.22787.22.camel@concordia>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 10 Nov 2010 02:19:18 +0100
Message-ID: <AANLkTin_VixECn4AdQW_xC=_5ZNY5wBsif6cW5dDEJFe@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
To: michael@ellerman.id.au
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 02:10, Michael Ellerman <michael@ellerman.id.au> wrote:
> On Wed, 2010-11-10 at 01:57 +0100, Kay Sievers wrote:
>> Stay on the list please, with any possible reply. Thanks!
>
> You dropped the CC when you replied, or is my mailer being weird?

You replied to me only:
  From: Michael Ellerman <michael@ellerman.id.au>
  To: Kay Sievers <kay.sievers@vrfy.org>

>> On Wed, Nov 10, 2010 at 01:52, Michael Ellerman <michael@ellerman.id.au> wrote:
>> > On Wed, 2010-11-10 at 00:45 +0100, Kay Sievers wrote:
>> >> On Wed, Nov 10, 2010 at 00:36, Michael Ellerman <michael@ellerman.id.au> wrote:
>> >> > On Tue, 2010-11-09 at 14:13 -0800, Greg KH wrote:
>> >> >> On Tue, Nov 09, 2010 at 10:45:19PM +0100, Peter Zijlstra wrote:
>> >> >> > The below is a RFC patch adding dynamic type ids to perf.
>> >> >> >
>> >> >> > We need to represent PMUs in sysfs because we want to allow multiple
>> >> >> > (loadable) PMUs and need a way to identify them.
>> >> >> >
>> >> >> > This patch creates a new device class "pmu" and adds a single attribute
>> >> >> > "type" to it. This device attribute will expose the dynamic type id as
>> >> >> > required by perf_event_attr::type.
>> >> >> >
>> >> >> > The sysfs layout looks like:
>> >> >> >
>> >> >> > [root@westmere ~]# cd /sys/class/pmu/
>> >> >>
>> >> >> You missed the embedded track at Plumbers where we talked about never
>> >> >> adding another class to the kernel.  Please use bus_id instead for this.
>> >> >
>> >> > At least in the examples I've seen creating a bus requires a lot more
>> >> > code than a class. Or is there a shortcut I don't know about when it's a
>> >> > virtual bus?
>> >>
>> >> What do you mean? Instead of registering a class you register a bus?
>> >
>> > Yeah. From what I've seen doing the latter is a lot more involved.
>> >
>> >> Instead of assigning a class to the device, you assign the bus before
>> >> you add it. Other than this you do the same with the device.
>> >
>> > Sure. My point is creating a bus (from what I've seen) is not as easy as
>> > creating a bus. No one said kernel hacking should be easy, but if the
>> > advice is "use a bus not a class" it'd be good if they were
>> > approximately equivalent in effort.
>> >
>> > My code to use a class is ~=:
>> >
>> > struct class foo_class;
>> > foo_class = class_create(THIS_MODULE, "foo");
>> > device = device_create(foo_class, NULL, dev, "foo0");
>>
>> device_create must not be used for devices without a dev_t.
>> device_destroy, which is the counterpart can not work.
>
> It has a dev_t, that's the third argument?

Yeah, and that's not the case for the perf stuff.

>> If you use device_del/device_unregister, you need to use
>> device_add/device_register.
>
> I don't use them.

As said, the class devices have a convenience API which saves a few
lines, but they only work for devices with device nodes.

>> The pseudo-convenience device_register/device_unregister should also
>> not be used.
>
> Why are they in the tree if they shouldn't be used?

Because they save one line and do improper error handling.
They should all be converted to device_init+device_add/device_del/device_put.

> So far you are failing to dispel my notion that sysfs is a place where
> mortals dare not tread ;)

Oh, you are welcome to join the endless fixing rounds. Most of the
weird stuff if from people who moved to islands far away and never
touched any Linux code anymore (no kidding). :)

>> > And I'm looking at eg. drivers/usb/serial/bus.c as an example bus.
>> >
>> > But in my case (and I think perf too), we don't need a bus that probes
>> > etc. it's just a virtual bus that groups things, so it seems like it
>> > should be simple.
>> >
>> > Anyway I feel like I'm missing something, so hopefully you can clue me
>> > in :)
>>
>> Buses without drivers do not probe at all, they behave like classes.
>
> OK, good, that would seem to be a prerequisite for replacing the latter
> with the former.
>
> I'm just not clear on how that actually works in the code. For example I
> have a device which is on a bus (that's how it got probed), how do I
> also put it on another bus (my virtual bus replacing my class) ?

Nothing gets probed ever, if no driver is registered. To get a device
on a bus, just assign the bus to the 'struct device' before calling
device_add, that's all.

Devices can never be on two subsystems at the same time. Not with
classes, not with buses, that was never, and probably will never be
possible.

Kay
