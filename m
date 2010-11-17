Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab0KQI74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:59:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62207 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab0KQI7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:59:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QOmOuGhWXHa7tvwWjDvYH1rk7mSI4wR9GAhoYnosuHqFuzVXv0Y6IHnv6donr8WQNY
         yYNifbA4CDrUbYgnaFA44o2WMxvKDXW/K3knoQRepBw4ake7BkHSL5q/v9tv1L//pEV+
         O0ZxCP8TkKAr5ueB8kdYSXYCtErAXsoHnPs5Y=
MIME-Version: 1.0
In-Reply-To: <20101117072553.GB10671@linux-sh.org>
References: <20101117064405.18139.57035.sendpatchset@t400s>
	<20101117064415.18139.28996.sendpatchset@t400s>
	<20101117072553.GB10671@linux-sh.org>
Date: Wed, 17 Nov 2010 17:51:41 +0900
Message-ID: <AANLkTi=coMHw+SZ_2DebQ29GVdAuoxRYPgbMYYkYZAXE@mail.gmail.com>
Subject: Re: [PATCH 01/05] fbdev: sh_mipi_dsi: Remove request/release mem region
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
        linux-sh@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 4:25 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Wed, Nov 17, 2010 at 03:44:15PM +0900, Magnus Damm wrote:
>> The driver core already manages resources for us, so
>> there is no need to perform request_mem_region() and
>> release_mem_region() in the MIPI-DSI driver.
>>
> No. This comes up time and time again for some reason, I'm not sure why
> this misconception keeps being propagated (and it's definitely a mistake
> I've made myself too!)

Perhaps the confusing part is the -EBUSY error case for
insert_resource() in platform_device_add() located in
drivers/base/platform. Judging by that code it sure looks like there
is some kind of conflict management, but probably not enough as you
mention below.

> The driver core simply takes your resources and inserts them in to the
> resource tree, it has nothing to do with requesting ranges, or checking
> for conflicts. The main rationale for this is that drivers (think MFDs)
> may pass in a large resource range, which in turn will be broken up and
> requested by individual drivers nested underneath it. Only at request
> time will the requested range (which can be the entire thing, or a
> subset) be flagged as busy and conflicts detected.

Right, I understand.

> The current logic is quite correct in what it is doing.

It may be correct, but I don't like the smell of it.

Sound like begging for trouble to me - to require the majority of the
drivers (the simple ones) to call request/release_mem_region() even
though by context it's quite obvious that the driver will use
resource. It doesn't make sense to pass resources that are not going
to be used, does it?

Also, there are quite a few levels of resource handling / conflict
checking / device access:

1) board/cpu code - contains struct resource for devices
2) platform_device_add() - insert_resource() does basic checks
3) driver probe() request_mem_region() does more checks, reserves
4) driver probe() ioremap() gets a virtual address range
5) driver uses ioreadN()/iowriteN() on virtual address range

The physical range provided by struct resource and the virtual address
range from ioremap() are of course different things, but i think there
is a bit of overlap there. The driver isn't supposed to be using
ioremap() on an I/O memory region that hasn't been locked down with
request_mem_region() for instance.

I'd like to see a simplified interface that handles
request_mem_region() and ioremap() in the driver code, perhaps
together with automatic handling of request_irq(). Perhaps that's
difficult in real life, but if possible then that would cut away quite
a bit of code.

And then there are device trees on top of all this, yay!

/ magnus
