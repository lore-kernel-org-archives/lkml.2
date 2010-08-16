Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab0HPUZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:25:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57162 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab0HPUZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:25:39 -0400
MIME-Version: 1.0
In-Reply-To: <4C6987B0.7030703@codeaurora.org>
References: <1281484174-32174-1-git-send-email-ppannuto@codeaurora.org>
 <1281484174-32174-3-git-send-email-ppannuto@codeaurora.org>
 <AANLkTi=GduvsmkXpxsVoN7k3gPDjjRgqe0E_Z2YeEVS5@mail.gmail.com> <4C6987B0.7030703@codeaurora.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 Aug 2010 14:25:18 -0600
X-Google-Sender-Auth: u4TGjM_lSCkEY8OGCoJYq7iYZIw
Message-ID: <AANLkTimxOgZPC_MiecEDRXoAcGRnsuUe31KkJJKDekev@mail.gmail.com>
Subject: Re: [PATCH 2/2] platform: Facilitate the creation of pseudo-platform buses
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        magnus.damm@gmail.com, gregkh@suse.de,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Miao <eric.y.miao@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 12:47 PM, Patrick Pannuto
<ppannuto@codeaurora.org> wrote:
> On 08/13/2010 03:05 PM, Grant Likely wrote:
>>> @@ -1017,6 +1022,87 @@ struct bus_type platform_bus_type = {
>>>  };
>>>  EXPORT_SYMBOL_GPL(platform_bus_type);
>>>
>>> +/** pseudo_platform_bus_register - register an "almost platform bus"
>>
>> Kerneldoc style error.  Should be:
>>
>> +/**
>> + * pseudo_platform_bus_register - register an "almost platform bus"
>>
>
> Fixed.

Actually, I also made a kerneldoc style error here because the braces
are missing.  This should be:

+/**
+ * pseudo_platform_bus_register() - register an "almost platform bus"

See Documentation/kernel-doc-nano-HOWTO.txt for details.

I'm also not fond of the "pseudo" name.  It isn't really a pseudo bus,
but rather a different bus type that happens to inherit most of the
platform_bus infrastructure.  It may be better just to expose the
platform_bus helper functions without any reference to pseudo, and let
the users be responsible for any naming differentiation.  This is
particularly true if the custom bus becomes responsible for
registering itself and only the initialization functions are exposed.

[...]
>>> +       heap_pm = kmalloc(sizeof (*heap_pm), GFP_KERNEL);
>>> +
>>> +       if (!heap_pm)
>>> +               return -ENOMEM;
>>> +
>>> +       if (!bus->dev_attrs)
>>> +               bus->dev_attrs = platform_bus_type.dev_attrs;
>>> +       if (!bus->match)
>>> +               bus->match = platform_bus_type.match;
>>> +       if (!bus->uevent)
>>> +               bus->uevent = platform_bus_type.uevent;
>>> +       if (!bus->pm)
>>> +               memcpy(heap_pm, &platform_bus_type.pm, sizeof(*heap_pm));
>>> +       else {
>>> +               heap_pm->prepare = (bus->pm->prepare) ?
>>> +                       bus->pm->prepare : platform_pm_prepare;
>>> +               heap_pm->complete = (bus->pm->complete) ?
>>> +                       bus->pm->complete : platform_pm_complete;
>>> +               heap_pm->suspend = (bus->pm->suspend) ?
>>> +                       bus->pm->suspend : platform_pm_suspend;
>>> +               heap_pm->resume = (bus->pm->resume) ?
>>> +                       bus->pm->resume : platform_pm_resume;
>>> +               heap_pm->freeze = (bus->pm->freeze) ?
>>> +                       bus->pm->freeze : platform_pm_freeze;
>>> +               heap_pm->thaw = (bus->pm->thaw) ?
>>> +                       bus->pm->thaw : platform_pm_thaw;
>>> +               heap_pm->poweroff = (bus->pm->poweroff) ?
>>> +                       bus->pm->poweroff : platform_pm_poweroff;
>>> +               heap_pm->restore = (bus->pm->restore) ?
>>> +                       bus->pm->restore : platform_pm_restore;
>>> +               heap_pm->suspend_noirq = (bus->pm->suspend_noirq) ?
>>> +                       bus->pm->suspend_noirq : platform_pm_suspend_noirq;
>>> +               heap_pm->resume_noirq = (bus->pm->resume_noirq) ?
>>> +                       bus->pm->resume_noirq : platform_pm_resume_noirq;
>>> +               heap_pm->freeze_noirq = (bus->pm->freeze_noirq) ?
>>> +                       bus->pm->freeze_noirq : platform_pm_freeze_noirq;
>>> +               heap_pm->thaw_noirq = (bus->pm->thaw_noirq) ?
>>> +                       bus->pm->thaw_noirq : platform_pm_thaw_noirq;
>>> +               heap_pm->poweroff_noirq = (bus->pm->poweroff_noirq) ?
>>> +                       bus->pm->poweroff_noirq : platform_pm_poweroff_noirq;
>>> +               heap_pm->restore_noirq = (bus->pm->restore_noirq) ?
>>> +                       bus->pm->restore_noirq : platform_pm_restore_noirq;
>>> +               heap_pm->runtime_suspend = (bus->pm->runtime_suspend) ?
>>> +                       bus->pm->runtime_suspend : platform_pm_runtime_suspend;
>>> +               heap_pm->runtime_resume = (bus->pm->runtime_resume) ?
>>> +                       bus->pm->runtime_resume : platform_pm_runtime_resume;
>>> +               heap_pm->runtime_idle = (bus->pm->runtime_idle) ?
>>> +                       bus->pm->runtime_idle : platform_pm_runtime_idle;
>>> +       }
>>> +       bus->pm = heap_pm;
>>> +
>>> +       error = bus_register(bus);
>>> +       if (error)
>>> +               kfree(bus->pm);
>>> +
>>> +       return error;
>>> +}
>>> +EXPORT_SYMBOL_GPL(pseudo_platform_bus_register);
>>
>> Ick, this is a nasty list of conditional statements.  :-)  Instead it
>> could have an unconditional initialize function which sets it up just
>> like the platform bus without registering.  Then allow the
>> foo_bus_type initialization code override the ones it cares about, and
>> then register directly.
>>
>
> No, this won't work. (Unless, every pseudo_bus_type author did this same
> kludge to work around const - better to do once IMHO)
>
> struct bus_type {
>        ...
>        const struct dev_pm_ops *pm;
>        ...
> };
>
> That const is there to *prevent* device/driver writers from overriding
> pm ops on accident, and to that end, it has value. What we would really
> like here is 'const after registered' semantics, where the bus author
> can fill in half the structure, and the platform code can fill in the
> rest. However, allowing subclasses to modify private data elements isn't
> possible in C :)

Okay then, here is a better approach:  Don't do any allocation in this
function.  Just initialize the bus_type exactly the way it is
initialized for the platform bus and assign the default dev_pm_ops.
If the custom bus needs to override them, then it should be
responsible to kmemdup the default dev_pm_ops structure and modify the
copy.  The code will be a lot simpler that way.

> I believe the 'const' here provides valuable safety. My original attempt
> at doing this removed the const, and I overwrote one of the pointers in
> platform_dev_pm_ops on my first try at implementing it!

Yes, overriding the const is a bad idea and you'd be wrong to override it.  :-)

Cheers,
g.
