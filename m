Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2KWOkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:40:24 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50852 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2KWOkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:40:19 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6t-hfMpgM4EZicAFBFumxUeqBjQqVoDafVFvDf4iv3fvg@mail.gmail.com>
References: <1353509071-8658-1-git-send-email-grant.likely@secretlab.ca>
 <20121121145239.GA21860@kroah.com> <CAPXgP12fOANaeVQ=8ZMd1q-SdJo0xjsGoVTqs27oe44wXuSCdQ@mail.gmail.com>
 <CACxGe6t-hfMpgM4EZicAFBFumxUeqBjQqVoDafVFvDf4iv3fvg@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 23 Nov 2012 15:39:57 +0100
Message-ID: <CAPXgP12yK8LV1Qi7ykS-VbaQY-S5+bp4FX-1sOxxUTPG4UE56g@mail.gmail.com>
Subject: Re: [RFC] driver-core: Remove dummy 'platform_bus'
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 10:20 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Thu, Nov 22, 2012 at 7:17 PM, Kay Sievers <kay@vrfy.org> wrote:
>> On Wed, Nov 21, 2012 at 3:52 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

>>> If the devices don't show up under platform/ where are they going to be
>>> at now, virtual/ ?  That doesn't sound like a good plan, they should be
>>> somewhere "useful".
>>
>> Just a note to keep in mind: We usually need and want devices to have
>> a bus or class. Devices without a "subsystem" are invisible to udev,
>> and do not get proper coldplug support at bootup.
>
> Note: this patch is only about the "platform_bus" dummy device. It has
> nothing to do with platform_bus_type.

Ah, I see now.

Why do you want to remove the "platform_bus" fake-parent, entirely? I
understand and agree that drivers should not fiddle with that
directly. But I don't see a real reason why it should not be private
to the platform_bus_type. It's nothing really wrong with it, I guess.

I have on x86:
  coretemp.0 -> ../../../devices/platform/coretemp.0
  dock.0 -> ../../../devices/platform/dock.0
  dock.1 -> ../../../devices/platform/dock.1
  efifb.0 -> ../../../devices/platform/efifb.0
  i8042 -> ../../../devices/platform/i8042
  iTCO_wdt -> ../../../devices/pci0000:00/0000:00:1f.0/iTCO_wdt
  pcspkr -> ../../../devices/platform/pcspkr
  serial8250 -> ../../../devices/platform/serial8250
  thinkpad_acpi -> ../../../devices/platform/thinkpad_acpi
  thinkpad_hwmon -> ../../../devices/platform/thinkpad_hwmon

which look pretty reasonable in a "platform parent" instead of ending
up in virtual/.

We should probably remove the explicit assignment in the drivers like
your patch does, unexport "platform_bus" from the core, so nobody can
use it anymore in the future. The /sys/bus/platform/devices/ directory
can then be created on-demand only, with the first registration of a
device without a parent, we do that in other parts of the core
already.

Wouldn't that solve your problem and still do not touch any other
stuff visible in /sys?

Also, it seems there are devices without any subsystem in the list of
things your patch touches? That is really not how things should work.
All devices should have a bus or class, so userspace receives proper
events, and can enumerate them.
The /sys/devices/ hierarchy is not really meant to be used directly,
it can for some devices even change at runtime. It's not considered a
stable or reasonable predictable ABI, all lookups should start in the
flat device symlink lists of the class/ and bus/, and not in the
hierarchical tree in devices/.

Kay
