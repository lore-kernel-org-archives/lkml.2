Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1GHLh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 07:37:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38858 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1GHLh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 07:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
Date: Fri, 8 Jul 2011 13:37:27 +0200
Message-ID: <CAHXqBFJiovYq5x_JDAxikvFs-t1To6yC-1uajBJFRX_jwjvejA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] Core device subsystem
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/8 Marc Zyngier <marc.zyngier@arm.com>:
> There is a small number of devices that the core kernel needs very
> early in the boot process, namely an interrupt controller and a timer,
> long before the driver model is up and running.
>
> Most architectures implement this requirement by hardcoding the
> initialisation of a "well known" piece of hardware which is standard
> enough to work on any platform.
>
> This is very different on the ARM architecture, where platforms have a
> variety of interrupt controllers and timers. While the same hardcoding
> is possible (and is actually used), it makes it almost impossible to
> support several platforms in the same kernel.
>
> Though the device tree is helping greatly to solve this problem, some
> platform won't ever be converted to DT, hence the need to have a
> mechanism supporting a variety of information source. Early platform
> devices having been deemed unsuitable (complexity, abuse of various
> subsystems), this subsystem has been designed to provide the very
> minimal level of functionality.
>
> The "core device subsystem" offers a class based device/driver
> matching model, doesn't rely on any other subsystem, is very (too?)
> simple, and support getting information both from DT as well as from
> static data provided by the platform. It also gives the opportunity to
> define the probing order by offering a sorting hook at run-time.
[...]

I gave it some thought and it looks like your idea can be modified to
make it even less demanding on machine setup code.

For the DT case, all this can work without adding a single
board-specific code (even machine_desc->init_irq() is not needed).

of_init_core_device_class(class)
{
  int ids_count = 0;
  struct of_device_id *ids, *p;

  for_each_core_device_driver(drv, class)
    for_each_core_device_id(id, drv)
      ++ids_count;

  p = ids = kzalloc(...);

  for_each_core_device_driver(drv, class)
    for_each_core_device_id(id, drv) {
      p->compatible = id->name;
      p->data = drv;
    }

  // generate matching device list from devicetree

  if (class == CORE_DEV_CLASS_IRQ)
    // sort the list (for intc class)

  core_driver_init_class(class);
  // call above could use matched ids' data field for finding
  // driver struct instead of traversing the driver list again
}

For non-DT case, the board code would need to provide the devices with
core_device_register() in init_irq() or wherever is apropriate.

For simplicity I thing mixing static and DT initialization should not
be allowed (for a single machine) - then static/DT initialization
order won't matter.

I hope this is useful for you. :)

Best Regards,
Micha³ Miros³aw
