Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2BTKUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:20:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab2BTKUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:20:08 -0500
MIME-Version: 1.0
In-Reply-To: <4F421A0E.8030805@broadcom.com>
References: <4F414230.5040506@lwfinger.net> <4F421A0E.8030805@broadcom.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 20 Feb 2012 11:19:48 +0100
Message-ID: <CAPXgP10qa_g6R=pOWd8JuXpw0wPdJ4rP7B_4YHDU91mhC0N6Vg@mail.gmail.com>
Subject: Re: will these methods work with firmware loading?
To: Arend van Spriel <arend@broadcom.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        wireless <linux-wireless@vger.kernel.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 11:01, Arend van Spriel <arend@broadcom.com> wrote:
> On 02/19/2012 07:40 PM, Larry Finger wrote:

>> Similarly, if I were to create a work queue, init and schedule it from
>> module_init(), and then use synchronous loads to get the firmware from the
>> work
>> queue callback, would that get around the boot problem? I know it works as
>> I
>> have trial patches; however, my version of udev is not one affected. This
>> method
>> is very easy to implement, but again I would like confirmation from an
>> expert.

It sounds like it should work, because the modprobe event returns, not
waiting for the firmware request. Chaining one firmware request after
the other sounds not like a problem, as long as they are chained with
the return from the earlier request and not from inside the earlier
request, which would have duplicated device name issues in the kernel
too.

> What boot problem are you referring to?

The pci event calls modprobe, the module init for the pci driver
creates a child event of the pci device, this child event is queued in
udev to be started after the pci event has finished. The pci event
does not finish in time because the firmware request blocks itself.

The current udev logic limits the timeout to 30 sec, while the
firmware request is 60 sec, so it usually works with a logged error,
and a 30 second delay.

> The blocking modprobe?

Yes, blocking in the module init path, will deadlock udev. Linking
code into the kernel must not depend on device init or firmware
loading.

> For that
> problem I would say yes. Also here the problem of handling error flows
> exist. If the driver is kicked of during boot with a initramfs missing the
> firmware, should we retry until the real root is mounted?

I don't think so. Drivers are not supposed to know about bootup or
initramfs issues. If they want, they can disable the timeout, and wait
for userspace to handle the request any time later, but they should
not try to be smart here.

Currently, firmware requests are cancelled if the firmware isn't
found, but that's a userspace issue, and nothing the kernel should try
to work around.

Kay
