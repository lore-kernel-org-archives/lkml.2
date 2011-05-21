Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1EUHq5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 03:46:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47827 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1EUHqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 03:46:55 -0400
MIME-Version: 1.0
In-Reply-To: <4DD6FB9E.2050604@tilera.com>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
	<201105050841.40576.arnd@arndb.de>
	<4DD6AD51.7090900@tilera.com>
	<201105202046.40696.arnd@arndb.de>
	<BANLkTimMndGzjZJ0xUNgStY7kwM0aW7Ojg@mail.gmail.com>
	<4DD6FB9E.2050604@tilera.com>
Date: Sat, 21 May 2011 00:46:55 -0700
Message-ID: <BANLkTin5cE-u-J_88UC6ROxvwiMxR6Ro-Q@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM driver
From: Eric Biederman <ebiederm@aristanetworks.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 4:39 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 5/20/2011 6:40 PM, Eric Biederman wrote:
>> Please do not make sysfs the direct access method to your device.
>> I may be wrong but I don't think any other driver relies exclusively on sysfs.
>
> I'm basing my implementation on drivers/misc/eeprom/.  All the drivers
> there use the same sysfs model.
>
>> Certainly with the introduction of a flush you are introducing an completely
>> different usage paradigm from current users and will need an entirely different
>> set of tools.
>
> I don't think using my proposed implementation will be detectably different
> for most user tools.  The addition of the flush() method just allows my
> implementation to defer the final sector's write until the device is closed
> (sectors are in fact still written to hardware as one does seek() or
> write() from one sector to another; only the "current" sector is cached by
> the hypervisor).  I suppose some third-party tool that kept the eeprom file
> descriptor open indefinitely and did multiple writes to the same sector
> might not work as expected with this implementation.  But it seems hard to
> imagine a use case for such a tool.
>
> The direct motivation for this case is to "impedance match" to the
> hypervisor driver for this device, which handles sector management
> internally, so the Linux device doesn't have to.  Having a 'flush' method
> avoids excessive re-writes of the same sector for certain access patterns.
> The only alternatives that I see are to rewrite the tile userspace tools,
> but they are the way they are because the current model gives good
> consistency guarantees for writing the boot rom in the presence of
> arbitrary failure modes; or, to add something like a delayed timer event
> that allows the Linux driver to notify the hypervisor driver that writes
> are likely complete and it can write out the last sector.  Neither of these
> are particularly attractive.

What is wrong with an mtd driver?

Looking a bit back into the conversation it appears clear that you are
talking about something that resembles NOR flash with multiple sectors,
etc.

eeproms have random byte access and are typically 256 bytes.  You devices
doesn't sound anything like an eeprom.

> I apologize for not including more of the back story in this email when
> adding the cc's, by the way.  Originally I proposed a straightforward
> character device for this role.  Arnd Bergmann encouraged me to look at
> kernel precedents like drivers/char/eeprom/, which is why I converted this
> driver to sysfs.  The first post in this thread is here:
> https://lkml.org/lkml/2011/5/4/415 .  Since then I've come around to
> believing that it's more valuable to group this driver with the other
> eeprom drivers, rather than with the other paravirtualized tile drivers.

Again this sounds most like an mtd driver to me, and arguably should
be grouped there.

If you have to worry about keeping sectors open or closed your hardware
is very much not an eeprom.

Eric
