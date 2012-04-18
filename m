Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2DRWl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:41:26 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63297 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2DRWlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:41:24 -0400
MIME-Version: 1.0
In-Reply-To: <4F8F3C74.7040000@genband.com>
References: <4F8F3563.9020701@genband.com> <4F8F3C74.7040000@genband.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 19 Apr 2012 00:41:03 +0200
Message-ID: <CAPXgP12TVseisuH1+-c1pCPudaTmueEu4dQGStg9zv5TSVJsag@mail.gmail.com>
Subject: Re: "udevadm info --attribute-walk --path=/block/sda" doesn't show parents
To: Chris Friesen <chris.friesen@genband.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 00:13, Chris Friesen <chris.friesen@genband.com> wrote:
> On 04/18/2012 03:42 PM, Chris Friesen wrote:
>>
>> I have a 2.6.34.10-based kernel with udev-161 (also tested with udevadm from udev-173).
>>
>> When I run "udevadm info --attribute-walk --path=/block/sda" it just shows the device
>> itself, and doesn't walk the whole chain showing the parents.
>>
>> Is there anything I can do, or am I caught with a kernel that isn't properly supported?
>> I'm not subscribed to the hotplug list, so cc'ing me would be appreciated.
>>
>> I don't know what's causing the problem, but I find it suspicious that /sys/block/sda
>> is a directory rather than a symlink like it is on my 2.6.35.14 laptop.  I'm poking
>> around in the udevadm code now.
>
> Looking at the udevadm code led me to the following:
>
> On the problematic 2.6.34 machine:
>
> root@typhoon-base-unit0:/root> ls -l /sys/dev/block/
> <snip>
> lrwxrwxrwx 1 root root 0 Apr 18 14:34 8:0 -> ../../block/sda
>
> On my 2.6.35 machine:
>
> [cfriesen@blah udev-173]$ ls -l /sys/dev/block/
> <snip>
> lrwxrwxrwx. 1 root root 0 Apr 18 15:54 8:0 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda
>
> So where do I go from here?  Is there a simple kernel change to make my 2.6.34
> kernel behave more like the more recent one?  Would an older version of udev be
> able to parse my 2.6.34 /sys directory properly, or do I need to figure out a
> way to parse /sys manually?

On old kernels, the chain of parent devices was not always properly
exported, because the "struct class_device" created all device
directories and spread spread them all over the the /sys/class tree.
There was a "device" link created at these disconnected device
directories, which udev tried to follow to find the parents.

We cleaned that up that mess, by having a single and unified tree in
/sys/devices, and /sys/class and /sys/bus just have symlinks pointing
into that tree. "Hierarchy" vs. "classification" are properly
separated that way.

For a while the CONFIG_SYSFS_DEPRECATED controlled the behaviour, you
might check if that is available in your kernel and can be turned off
to switch to the unified hierarchy. I kind of lost track which kernel
versions did what here.

In general, if you need the more recent udev tools to work regarding
the chain of parents, which "udevadm info --attribute-walk" uses, you
need a newer kernel, which exports that natively. There is no support
for the "device" link in newer versions of udev. We only really
supports it the other way around, which is new kernels on older
userspace. So you either use a newer kernel for a new udev, or also
stick with the old udev if you are stuck with that old kernel.

Or alternatively, you patch-in the support for the old "struct
class_device" stuff into the curent udev, to support older kernels; it
should be fairly simple. If that's what you look for, I can look up
the stuff you need to add, just let me know.

Kay
