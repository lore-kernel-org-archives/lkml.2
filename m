Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967250Ab2ERT7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 15:59:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61921 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967148Ab2ERT7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 15:59:45 -0400
MIME-Version: 1.0
In-Reply-To: <1337351831.30231.19.camel@trivette.site>
References: <1334276935-11258-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1334276935-11258-4-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20120517210633.400633E0621@localhost> <1337290826.7033.10.camel@trivette.site>
 <CACxGe6v20FnMrpE9ZFTQuhOUoJJrAgN_YKHXDT8GF4rH0VUd6A@mail.gmail.com> <1337351831.30231.19.camel@trivette.site>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 18 May 2012 13:59:25 -0600
X-Google-Sender-Auth: HBJxJvLGCzxF0RPyLIgFSe18Q-A
Message-ID: <CACxGe6sFe0jVc-wJ1O5sroiqPQ6e=i3pxN2gBpqhbcTX7UX7qw@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] gpio: TS-5500 GPIO support
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 8:37 AM, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:
> Hi Grant,
>
> On Thu, 2012-05-17 at 16:59 -0600, Grant Likely wrote:
>> On Thu, May 17, 2012 at 3:40 PM, Vivien Didelot
>> <vivien.didelot@savoirfairelinux.com> wrote:
>> > On Thu, 2012-05-17 at 15:06 -0600, Grant Likely wrote:
>> >> >  arch/x86/include/asm/ts5500.h |   62 ++++++++
>> >>
>> >> Why the separate header file?  What will use these defines?  I
>> >> normally expect driver-specific defines to be in the driver .c file
>> >> directly; particularly for things like gpio drivers which should be a
>> >> generic interface that doesn't need to export symbols.
>> >
>> > Should an intermediate driver directly use values for GPIOs instead of
>> > these symbols? For example, how should a temperature sensor plugged on
>> > this platform refer to inputs and outputs?
>>
>> Tell me more about this platform.  Where does the data about
>> connections come from?  Is it a purpose-built embedded system?
>
> This is a generic purpose platform, the GPIO bus is exposed on an
> external DB25 connector. End-users can use it however they like.
>
>> Is the
>> GPIO controller described in ACPI? (probably not since GPIOs were only
>> added to ACPI in v5)  Does the end-user attach her own hardware to the
>> board like the temperature sensor you describe?  If so, is that
>> hardware driven by kernel drivers or user-space drivers?
>
> Both in fact. For instance, we are connecting an SHT15
> humidity/temperature sensor, which already has support in the kernel.
>
>>
>> For userspace drivers you can get information about the GPIO number
>> assignments from /sys, but it isn't well documented and can probably
>> be improved.
>>
>> If it is kernelspace, then you really need a way to add data about the
>> platform to the kernel at runtime.  Having it statically compiled in
>> isn't a very good solution.  I would recommend injecting configuration
>> data into the kernel from userspace.  You could invent something, but
>> that wouldn't be very portable.  Xilinx has done some work on this
>> using Flattened Device Tree and the firmware loading infrastructure.
>> The kernel requests a .dtb (device tree blob) from userspace and uses
>> that to configure devices.  That may do the job for you.  GPIO and
>> platform device infrastructure already have FDT support which will
>> help you here.  I expect it could be done with an ACPI fragment too,
>> but I just don't know of anybody having done any work in this area.
>>
>> That probably isn't the answer you want though since I assume you just
>> need to get something that works rather than investing a whole bunch
>> of time on generic infrastructure.
>
> Exactly.
>
>>  What I would recommend is for your
>> platform setup code to use a notifier to wait for the
>> BUS_NOTIFY_BOUND_DRIVER event and then register the temperature sensor
>> with the correct gpio number at that time (because once you have a
>> reference to the gpio controller you can calculate the assigned gpio
>> numbers).
>
> Thanks.
>
> I've been working on pushing this code mainline for a while. To
> summarize, for you to accept this code, you'd prefer me to move every
> symbol into the driver itself (in addition to addressing your and Joe's
> other requests), and then we're good?

Either that or have a *really good* argument why it should be
exposed/exported.  It is already a tough-fought battle to move away
from driver-specific hacks and custom platform code, so I don't want
to be adding yet more if at all avoided.

g.
