Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030663Ab2HWQEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:04:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34443 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934124Ab2HWQEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:04:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP13LBR6GD=VomBPim3mDPy1bJ=eFBZ=oDaKZCjEo=Xp94Q@mail.gmail.com>
References: <CACVXFVNYCZqxt9B=9F_71KP0gdinGbNXd_ePQ10NKsCGd1dY4g@mail.gmail.com>
	<CACVXFVOMdWQSutkBzdcLJ-ozmecq_p-yzYJbtoLVUafz5KV=KQ@mail.gmail.com>
	<CAPXgP13LBR6GD=VomBPim3mDPy1bJ=eFBZ=oDaKZCjEo=Xp94Q@mail.gmail.com>
Date: Fri, 24 Aug 2012 00:04:32 +0800
Message-ID: <CACVXFVMFKGPv9Am0KzKSVsRamcA8EMMnD0kQO40MJ6OsjK4Eow@mail.gmail.com>
Subject: Re: udev 182: response timeout for request_firmware in module_probe path
From: Ming Lei <tom.leiming@gmail.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 11:31 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Thu, Aug 23, 2012 at 5:16 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>> On Tue, Aug 21, 2012 at 1:34 PM, Ming Lei <tom.leiming@gmail.com> wrote:
>
>>> I found that udev 182 doesn't response for the request_firmware in
>>> module_probe path until 30sec later after the 'ADD' event of firmware
>>> device, but no such problem in udev175, sounds like a regression of udev?
>>
>> Looks udevd is capable of handling the firmware ADD event even though
>> the device ADD event is being processed( modprobe is triggered by device
>> ADD event).
>
> Calling out from inside the kernel and blocking in a firmware loading
> userspace transaction during module_init() is kind of weird.

Strictly speaking, the request_firmware is not called by module_init()
directly, but called by driver .probe() which is triggered inside module_init().

I admit that it is weird if the driver is built in kernel. But considered that
most of drivers are built as module, it should be workable since the
userspace is already ready during module probing.

Also from the viewpoint of device driver, loading driver inside .probe()
is reasonable since the device may be powered on just now and
can't work further without the firmware.

Finally, the reality is that hundreds of drivers call request_firmware()
inside their.probe(), and converting them into its asynchronous pair
will introduce much much works, :-(

>
> The firmware loading call should not rely on a fully functional
> userspace, and modprobe should not hang and block until the firmware
> request is handled.

IMO, the driver probing path is allowed to sleep, so looks request firmware
should be allowed inside .probe().

In the patch I posted, it will make the situation workable at least.

>From udevd code, the firmware ADD event isn't run until its parent
device has been handled. IMO,  looks like there is no obvious side
effect to loose the constraint for firmware device.

Correct me if it is wrong, and I am not familiar with udev.

>
> The firmware should be requested asynchronously or from a different
> context as module_init(). It depends on the type of driver/hardware
> what's the best approach here.

Requesting firmware asynchronously should be better, but may
introduce some complexity to drivers, for example, race between
request/release firmware context and hotplug contexts.


Thanks,
-- 
Ming Lei
