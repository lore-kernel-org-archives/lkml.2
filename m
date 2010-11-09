Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab0KIWlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:41:01 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48256 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab0KIWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:40:59 -0500
MIME-Version: 1.0
In-Reply-To: <1289341347.2191.97.camel@laptop>
References: <1289339119.2191.92.camel@laptop> <AANLkTimb=R0aqtfL=eZpwj=KqJchHU+nhMnjk5ME9BNr@mail.gmail.com>
 <1289341347.2191.97.camel@laptop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 9 Nov 2010 23:40:43 +0100
Message-ID: <AANLkTinGJApOAnQVfwLNcV1H2CUPNR4JbKASi92HgUro@mail.gmail.com>
Subject: Re: [RFC][PATCH] perf: sysfs type id
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 23:22, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-11-09 at 23:11 +0100, Kay Sievers wrote:
>> On Tue, Nov 9, 2010 at 22:45, Peter Zijlstra <peterz@infradead.org> wrote:
>> > The below is a RFC patch adding dynamic type ids to perf.
>> >
>> > We need to represent PMUs in sysfs because we want to allow multiple
>> > (loadable) PMUs and need a way to identify them.
>> >
>> > This patch creates a new device class "pmu" and adds a single attribute
>> > "type" to it. This device attribute will expose the dynamic type id as
>> > required by perf_event_attr::type.
>> >
>> > The sysfs layout looks like:
>> >
>> > [root@westmere ~]# cd /sys/class/pmu/
>>
>> Please use a 'bus_type' instead of 'class'.
>>
>> I'm very sure, some day, you'll need global attributes for the pmu
>> stuff, and class -- unlike bus -- has its own subdir where you can go
>> wild, without mixing things with the list-of-devices. :)
>
> Having its own subdir sounds like a pro, so I'm somewhat confused. Also
> the pmu (or event_source as Ingo would like it getting called) seems
> like a class of devices not a bus.
>
> USB/PCI/I2C/ISA are all buses.. pmu/event_source not so much, they are
> very different (sometimes even pure software) things that provide a
> common interface -- they generate events which we can count and sample.
>
> /me dazed & confused, please do explain.

Don't get confused by the 'bus' name, it's used for many things which
are not hardware buses. Class is just almost the same as a bus inside
and outside the kernel. Things like libudev don't even allow you to
distinguish the both, there is only a 'subsystem'. The class export in
/sys is not extensible at all, and therefore it should be avoided for
new stuff.

We will make all classes and buses show up in /sys/subsystem/. The
current silly split between a class and a bus has absolutely no
consistent meaning, and serves no purpose. After /sys/subsystem/
exists, class and bus will only be compat links pointing to the
entries in /sys/subsystem/.

There is _one_ tree at /sys/devices/, and will be _one_ classification
at /sys/subsystem/ which lists all-devices-of-the-same-subsystem and
has an extensible subdir like bus has today.

It's partly described in some outdated version in Documentation/sysfs-rules.txt.

>> No new stuff should use 'class', it's not extensible.
>
> Hrm.. when I introduced the bdi stuff class was _the_ thing to use.

Yeah, it does really matter for very simple things, but never for
stuff that reads -- before it even exists -- as "we will add links to
... and subbdirs, and have ...' :)

Kay
