Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0HPX6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 19:58:46 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37759 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab0HPX6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 19:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Smsbbv7mnrlc4KMumq6a5ULMWTlCrrlW6V8SsWfieCOftNlJQAjhddFqQDTAtfcb5S
         3FY3zDntJGez3hpjbVwzQmvLkr3X+3tHATRpJW2sn4ccHUdRyUTm8+QOAWKdeVf4osfq
         lVwzOEYokstVgl4hQrk2sVidu8Cvvj2Vxf8m4=
MIME-Version: 1.0
In-Reply-To: <4C6987B0.7030703@codeaurora.org>
References: <1281484174-32174-1-git-send-email-ppannuto@codeaurora.org>
	<1281484174-32174-3-git-send-email-ppannuto@codeaurora.org>
	<AANLkTi=GduvsmkXpxsVoN7k3gPDjjRgqe0E_Z2YeEVS5@mail.gmail.com>
	<4C6987B0.7030703@codeaurora.org>
Date: Mon, 16 Aug 2010 23:58:42 +0000
Message-ID: <AANLkTink7MB8JbSz1cguVLviqkF0OTt=gHMjUi3j0bfB@mail.gmail.com>
Subject: Re: [PATCH 2/2] platform: Facilitate the creation of pseudo-platform buses
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, magnus.damm@gmail.com, gregkh@suse.de,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Miao <eric.y.miao@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/16 Patrick Pannuto <ppannuto@codeaurora.org>:
> On 08/13/2010 03:05 PM, Grant Likely wrote:
>> On Tue, Aug 10, 2010 at 5:49 PM, Patrick Pannuto
[...]
>>> + * @bus: partially complete bus type to register
>>> + *
>>> + * This init will fill in any ommitted fields in @bus, however, it
>>> + * also allocates memory and replaces the pm field in @bus, since
>>> + * pm is const, but some of its pointers may need this one-time
>>> + * initialziation overwrite.
>>> + *
>>> + * @bus's registered this way should be released with
>>> + * pseudo_platform_bus_unregister
>>> + */
>>> +int pseudo_platform_bus_register(struct bus_type *bus)
>>> +{
>>> +       int error;
>>> +       struct dev_pm_ops* heap_pm;
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
[and so on ...]
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
> No, this won't work. (Unless, every pseudo_bus_type author did this same
> kludge to work around const - better to do once IMHO)

Actually you can do:

const struct dev_pm_ops test = {
    DEFAULT_PLATFORM_PM_OPS,
    .prepare = my_func,
    ...
};

where:

#define DEFAULT_PLATFORM_PM_OPS \
    .prepare = platform_pm_prepare, \
    .complete = platform_pm_complete, \
    ...

In case of repeated field assignments, gcc uses the last value (as per
http://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html).

Best Regards,
Micha³ Miros³aw
