Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358Ab1BRT0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:26:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57103 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1BRT0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:26:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=G8SkRmYv6lhhjpOfqcRKzQg7vYg2uLaHi6gXA6uv9i1Ff5l0o5x8i0BtmVDljZUxz2
         i/FlIWh/ag74oP0RiOo3O7QBw4MiZ8tp3iAUGCfkvLl9/CVEZrOmiew5OXsHpov/7ruv
         lPLUpiGyTa76KN5zn8lB2qQsyO0dypJYCcPlk=
MIME-Version: 1.0
In-Reply-To: <201102181928.05911.rjw@sisk.pl>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
 <AANLkTikRUZRh0YnP8nYTKFnFeUiJbK5xKvHHjn_S+gZE@mail.gmail.com>
 <AANLkTinsPqFcodH0w7LQeFEY+amodNH4CneRCRhhbKaz@mail.gmail.com> <201102181928.05911.rjw@sisk.pl>
From: Rabin Vincent <rabin@rab.in>
Date: Sat, 19 Feb 2011 00:55:28 +0530
X-Google-Sender-Auth: -nLmXum4SwoBtbGDmR1MSot0p9g
Message-ID: <AANLkTi=j9KeX2TSzMaKMWR6GpXjFcsjp0z8Rt+ArLXiV@mail.gmail.com>
Subject: Re: platform/i2c busses: pm runtime and system sleep
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: stern@rowland.harvard.edu, linux-pm@lists.linux-foundation.org,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@ti.com, magnus.damm@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 23:58, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, February 18, 2011, Rabin Vincent wrote:
>> On Thu, Feb 17, 2011 at 20:55, Rabin Vincent <rabin@rab.in> wrote:
>> > This will solve the platform vs AMBA bus, but shouldn't we really be
>> > aiming for consistent behaviour between these and the other busses such
>> > as I2C and SPI, which are also usually commonly used on the same
>> > platforms and are using GENERIC_PM_OPS?
>> >
>> > Should we be auditing all platform drivers and then switch platform to
>> > the GENERIC_PM_OPS?
>> >
>> > Or should the two points (1) and (2) be not handled in the bus at all
>> > and be left to individual drivers (in which case we should audit i2c and
>> > spi and change GENERIC_PM_OPS)?
>>
>> How about something like the below?  If we have something like this, we
>> can just switch platform to GENERIC_PM_OPS and add the
>> pm_runtime_want_interaction() (or something better named) call to the
>> i2c and spi drivers using runtime PM.
>
> Why don't we make platform_bus_type behave along the lines of generic ops
> instead?

At least drivers/spi/omap2_mcspi.c, drivers/video/sh_mobile_lcdcfb.c and
drivers/watchdog/omap_wdt.c are some pm_runtime-using drivers which seem
to do different things in their runtime vs normal suspend/resume
routines, so forcing platform into the active-on-resume behaviour of the
generic ops may make some use cases impossible.  Conversion of more OMAP
drivers to runtime pm appears to be ongoing so I'd imagine we'd be
seeing more of this.  Perhaps Kevin or Magnus will have a comment here.
The same thing applies to AMBA drivers.

Looking at the i2c drivers using runtime pm in comparison, they all seem
to be using straightforward UNIVERSAL_PM_OPS-style code with the runtime
and the system sleep doing the same things.  So maybe we do need to
treat platform/AMBA different from the I2C/SPI group?
