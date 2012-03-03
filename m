Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2CCPlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 10:41:07 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53358 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2CCPlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 10:41:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of federico.vaga@gmail.com designates 10.213.20.201 as permitted sender) smtp.mail=federico.vaga@gmail.com; dkim=pass header.i=federico.vaga@gmail.com
From: Federico Vaga <federico.vaga@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org
Subject: Re: How to make a bus with heterogeneous devices?
Date: Sat, 03 Mar 2012 16:44:05 +0100
Message-ID: <14955578.F1pbkdA1CJ@harkonnen>
User-Agent: KMail/4.7.4 (Linux/3.2.7-1.fc16.x86_64; KDE/4.7.4; x86_64; ; )
In-Reply-To: <CAPXgP13-5URbxH9u344CnreRP2v9VR-ADcQRUBA5AdNj26P+LA@mail.gmail.com>
References: <20120224152051.GA23232@mail.gnudd.com> <20120302223853.GA24929@kroah.com> <CAPXgP13-5URbxH9u344CnreRP2v9VR-ADcQRUBA5AdNj26P+LA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe I miss something but it sounds not that different from USB.
> 
> You have a bus that enumerates devices and a "bus driver" creates a
> generic device on that bus for everything it finds. These devices stay
> generic, do not have type-specific attributes, but export matches
> again to bind other device-specific drivers, which create _new_ child
> devices below the generic ones with the proper attributes matching
> their individual type of devices. So every "logical" device is always
> represented by one generic device and one type-specific child device.

It sounds like our option 5:

> 5- The real attributes may live in another device, which is a child of
> the one used within the bus abstraction.  Here the drawback is using
> an additional device and directory level for no reason.

- I register the generic (empty) device on the bus
- when the device match with a driver 
  - I register a new device child of the matched one but without connect     
    it directly on the bus.

The result will be something like (zio is our bus):

/sys/bus/zio/devices/<generic-dev1>/<real-device1>/<attributes>
/sys/bus/zio/devices/<generic-dev2>/<real-device2>/<attributes>
/sys/bus/zio/devices/<generic-devN>/<real-deviceN>/<attributes>

When there is not a driver:

/sys/bus/zio/devices/<generic-dev1>/<device-stuff>
/sys/bus/zio/devices/<generic-devN>/<device-stuff>

Where the generic-dev is an empty device used to make the bus work. Is 
it correct?

> All these devices, the generic ones and the type-specific ones can be
> on the same bus (struct bus_type) when they get a "struct device_type"
> assigned which carries the device-type specific set of attributes.

But if all devices can live on the bus (set device->bus for all 
devices), when I register the "real-device" (type-specific)  the bus try 
to match it with a driver (again); but we already matched the device 
with its driver. it is better if the type-specific devices are not 
directly on the bus but only a child of a device on the bus.

-- 
Federico Vaga
