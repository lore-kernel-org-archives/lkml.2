Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab2DKRGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:06:44 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42331 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020Ab2DKRGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:06:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120411163849.GE4794@alberich.amd.com>
References: <20120411163849.GE4794@alberich.amd.com>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 11 Apr 2012 19:06:21 +0200
Message-ID: <CAPXgP11mjyK7vJoQtsSf3kD-SYn6d_Y9feobY9KiiSYcFqOwwA@mail.gmail.com>
Subject: Re: x86, microcode: Conversion from sysdev class caused regression
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 18:38, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:

> The reason for the error is that subsys_interface_register() doesn't
> handle the return value of sif->add_dev (and there's also no unwinding
> of the interface registration). Instead subsys_interface_register
> always returns 0.

Which is the intended behaviour of 'subsystem interfaces' from the
driver-core perspective. It should not matter if one of a bunch of
devices do not 'like' this 'interface'. It is the same model as a
'driver', we do not cancel the link-in of a driver if one device does
not like the driver.

> This is different to what we had for
> sysdev_driver_register(). The latter properly handled return codes of
> drv->add() functions.

A 'subsystem interface' is a global instance per subsystem, not
something _all_ devices must agree on, to be registered. We can load
almost all drivers in the kernel, without even having a device around;
the 'interfaces' should not be that different in their model.

> See Boris' commit f4203e3032e5ae74c3e89df85a5a6d96022d0c49 (sysdev: Do
> not register with sysdev when erroring on add).

It seems to paper over a bug of the microcode driver, we should not do
that, or make such assumptions.

> I don't know whether the microcode driver is the only driver that
> is affected.

All interfaces with the same assumption of the microcode driver might,
but see below.

> What's your suggestion for a fix? Should subsys_interface_register()
> be fixed or should each affected driver be adapted?

All the drivers, if there are any more, who are as naive as the
microcode driver. :)

"Subsystem interfaces' users must not assume that they can blindly
unwind their own stuff, which they have never registered.
mc_device_remove() just goes ahead without any check and calls
sysfs_remove_group(), while it should check its own state of this
specific CPU it acts on.

I think a quick return in the microcode driver, for a device which has
no active interface state is the best solution here.

Thanks,
Kay
