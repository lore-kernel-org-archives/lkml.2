Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2CDS7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:59:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53562 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2CDS7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:59:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kay.sievers@vrfy.org designates 10.50.178.6 as permitted sender) smtp.mail=kay.sievers@vrfy.org; dkim=pass header.i=kay.sievers@vrfy.org
MIME-Version: 1.0
In-Reply-To: <14955578.F1pbkdA1CJ@harkonnen>
References: <20120224152051.GA23232@mail.gnudd.com> <20120302223853.GA24929@kroah.com>
 <CAPXgP13-5URbxH9u344CnreRP2v9VR-ADcQRUBA5AdNj26P+LA@mail.gmail.com> <14955578.F1pbkdA1CJ@harkonnen>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 4 Mar 2012 19:59:23 +0100
Message-ID: <CAPXgP10__1iCP8yCbfg7fJpK85_7C=P2MdP78b-1UwmOOt4OFA@mail.gmail.com>
Subject: Re: How to make a bus with heterogeneous devices?
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 3, 2012 at 16:44, Federico Vaga <federico.vaga@gmail.com> wrote:
>> Maybe I miss something but it sounds not that different from USB.
>>
>> You have a bus that enumerates devices and a "bus driver" creates a
>> generic device on that bus for everything it finds. These devices stay
>> generic, do not have type-specific attributes, but export matches
>> again to bind other device-specific drivers, which create _new_ child
>> devices below the generic ones with the proper attributes matching
>> their individual type of devices. So every "logical" device is always
>> represented by one generic device and one type-specific child device.

>> 5- The real attributes may live in another device, which is a child of
>> the one used within the bus abstraction.  Here the drawback is using
>> an additional device and directory level for no reason.
>
> - I register the generic (empty) device on the bus

You can always add some generic, no-type specific attributes there, if
that fits in your model.

> - when the device match with a driver
>  - I register a new device child of the matched one but without connect
>    it directly on the bus.

You can assign all these devices to the same bus (see details below).

> The result will be something like (zio is our bus):
>
> /sys/bus/zio/devices/<generic-dev1>/<real-device1>/<attributes>
> /sys/bus/zio/devices/<generic-dev2>/<real-device2>/<attributes>
> /sys/bus/zio/devices/<generic-devN>/<real-deviceN>/<attributes>
>
> When there is not a driver:
>
> /sys/bus/zio/devices/<generic-dev1>/<device-stuff>
> /sys/bus/zio/devices/<generic-devN>/<device-stuff>
>
> Where the generic-dev is an empty device used to make the bus work. Is
> it correct?

All buses have have a 'subsystem directory' at:
  /sys/bus/
This location exposes the 'device tree classification', like the
'collection of devices by subsystem'

The bus "zio" has its directory at:
  /sys/bus/zio/

All devices known to the bus "zio" are referenced at:
  /sys/bus/zio/devices/*

Which is a bunch of symlinks pointing into the:
  /sys/devices/
directory, which is the tree of all devices from all subsystems. This
tree exposes the 'device tree hierarchy'.

So your registered devices would all show up in:
  /sys/bus/zio/devices/generic0 --> ../../../devices/.../generic0
  /sys/bus/zio/devices/generic1 --> ../../../devices/.../generic1
 /sys/bus/zio/devices/generic2 --> ../../../devices/.../generic2
  /sys/bus/zio/devices/type-a0 --> ../../../devices/.../generic0/type-a0
  /sys/bus/zio/devices/type-a1 --> ../../../devices/.../generic1/type-a1
  /sys/bus/zio/devices/type-b0 --> ../../../devices/.../generic2/type-b0

They all show up on the same bus, but the type-specific devices are
child devices of the generic ones.

>> All these devices, the generic ones and the type-specific ones can be
>> on the same bus (struct bus_type) when they get a "struct device_type"
>> assigned which carries the device-type specific set of attributes.
>
> But if all devices can live on the bus (set device->bus for all
> devices), when I register the "real-device" (type-specific)  the bus try
> to match it with a driver (again); but we already matched the device
> with its driver. it is better if the type-specific devices are not
> directly on the bus but only a child of a device on the bus.

You can sort them out by 'struct device_type' in your probe functions,
that should  not be a problem.

We generally do not like devices which do not belong to a bus or
class, they are kind of 'invisible' to userspace, and udev can not use
them directly, it sees them only as a parent device of a device with a
bus or class.

Kay
