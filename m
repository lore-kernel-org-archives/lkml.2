Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab2FSCAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:00:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50320 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2FSCAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:00:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120618222550.GB11737@kroah.com>
References: <1339391600-17815-1-git-send-email-ming.lei@canonical.com>
	<20120615220343.GA8928@kroah.com>
	<CACVXFVO6h6wiHdTwVcjQLNtncO+ezVX3RJZPVenHEmhHjErRhg@mail.gmail.com>
	<20120618222550.GB11737@kroah.com>
Date: Tue, 19 Jun 2012 10:00:36 +0800
Message-ID: <CACVXFVOr1mnjaEoGpc3O_MDuvi_KHTXtsEBQ7LLoaeWxWRa0aQ@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 6:25 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> Have you read Documentation/stable_kernel_patches.txt?  Please do so and

I haven't read Documentation/stable_kernel_patches.txt, but read
Documentation/stable_kernel_rules.txt, :-)

> see why I can't take this patch for a stable tree.  Note that no one has
> ever reported this as a bug before, and the original poster ran away
> never to be heard from again, so I really don't think it was a real
> problem that people ever saw.

If Documentation/stable_kernel_rules.txt is the correct doc for stable rule,
looks reporter requirement isn't listed in the file, but the below can be found:

          - No "theoretical race condition" issues, unless an explanation of
         how the race can be exploited is also provided.

so I marked it as -stable because I have explained how the race can be
exploited in reality.

>
>> >> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> >> ---
>> >> v2:
>> >>       - take Alan's suggestion to use device_trylock to avoid
>> >>       hanging during shutdown by buggy device or driver
>> >>       - hold parent reference counter
>> >>
>> >>  drivers/base/core.c |   32 ++++++++++++++++++++++++++++++++
>> >>  1 file changed, 32 insertions(+)
>> >>
>> >> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> >> index 346be8b..f2fc989 100644
>> >> --- a/drivers/base/core.c
>> >> +++ b/drivers/base/core.c
>> >> @@ -1796,6 +1796,16 @@ out:
>> >>  }
>> >>  EXPORT_SYMBOL_GPL(device_move);
>> >>
>> >> +static int __try_lock(struct device *dev)
>> >> +{
>> >> +     int i = 0;
>> >> +
>> >> +     while (!device_trylock(dev) && i++ < 100)
>> >> +             msleep(10);
>> >> +
>> >> +     return i < 100;
>> >> +}
>> >
>> > That's a totally arbritary time, why does this work and other times do
>> > not?  And what is this returning, if the lock was grabbed successfully?
>>
>>  It is a timeout time and is 1sec now. If the lock can't be held in 1sec, the
>>  function will return 0, otherwise it will return 1 and indicates that the lock
>>  has been held successfully.
>
> My point is why 1 second?  That's completly arbitrary and means nothing.

1 second is a estimated value, just like many other timeout values in kernel.

For example, the timeout passed to usb_control_msg() is mostly estimated
first, then may be adjusted later from some new report.

Another example is one recent xhci fix commit:

622eb783fe(xHCI: Increase the timeout for controller save/restore state
operation)

the timeout value is just increased arbitrarily to adapt new device.

I still have more many examples in kernel about timeout value...

> Why not just do a real lock and try for forever?

IMO, there are two advantages not just doing a real lock for forever:

- avoiding buggy device/driver to hang the system
- with trylock, we can log the buggy device so that it is a bit
easier to troubleshoot the buggy drivers, suppose the bug is
only triggered 1 time in one year or more

>
>> Considered device lock is often held during probe and release in most
>> of situations, 1sec should be a sane value because it may be abnormal
>> if one driver's probe or release lasts for more than 1sec.
>
> How do you know how long a probe takes?  I know of some that take far
> longer than 1 second, so your patch just failed there :(

Could you share the device or driver so that a better timeout value is
set firstly?
Also, the timeout value is just valid for hotplug device.

>
>> Also taking trylock is to prevent buggy drivers from hanging system during
>> shutdown. If the timeout is too large, it may prolong shutdown time in
>> the situation.
>
> If a buggy driver hangs, then we fix the buggy driver.  We have the
> source, we can do that.

The problem may be triggered one time for one year or more, without the log
provided by trylock, it is a bit difficult to fix it.

>
>> I will appreciate it very much if you can suggest a better timeout value.
>
> None, spin forever, take a lock for real.
>
>> > What's with the __ naming?
>>
>> No special meaning, if is not allowed, I can remove the '__'.
>
> Please do, it makes no sense.

OK.

>
>> > I really don't like this at all.
>> >
>> >
>> >> +
>> >>  /**
>> >>   * device_shutdown - call ->shutdown() on each device to shutdown.
>> >>   */
>> >> @@ -1810,8 +1820,11 @@ void device_shutdown(void)
>> >>        * devices offline, even as the system is shutting down.
>> >>        */
>> >>       while (!list_empty(&devices_kset->list)) {
>> >> +             int nonlocked;
>> >> +
>> >>               dev = list_entry(devices_kset->list.prev, struct device,
>> >>                               kobj.entry);
>> >> +             get_device(dev->parent);
>> >
>> > Why grab the parent reference?
>>
>> If it is not grabbed,  device_del may happen after the line below
>>
>>          spin_unlock(&devices_kset->list_lock);
>>
>> so use-after-free may be triggered because the parent's lock
>> is to be locked/unlocked in this patch.
>
> Then document that.

OK.

>
>> >>               get_device(dev);
>> >>               /*
>> >>                * Make sure the device is off the kset list, in the
>> >> @@ -1820,6 +1833,18 @@ void device_shutdown(void)
>> >>               list_del_init(&dev->kobj.entry);
>> >>               spin_unlock(&devices_kset->list_lock);
>> >>
>> >> +             /* hold lock to avoid race with .probe/.release */
>> >> +             if (dev->parent && !__try_lock(dev->parent))
>> >> +                     nonlocked = 2;
>> >> +             else if (!__try_lock(dev))
>> >> +                     nonlocked = 1;
>> >> +             else
>> >> +                     nonlocked = 0;
>> >
>> > Ick ick ick.  Why can't we just grab the lock to try to only call these
>> > callbacks one at a time?  What is causing the big problem here that I am
>> > missing?
>>
>> As discussed before in the thread, trylock is introduced to prevent buggy
>> drivers from hanging system during shutdown.
>
> Fix buggy drivers, don't paper over them.

As said above, the log may be very helpful for fixing the buggy drivers.

Thanks,
--
Ming Lei
