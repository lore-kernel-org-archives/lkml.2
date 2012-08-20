Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2HTUpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:45:10 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:41443 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754524Ab2HTUpI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:45:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAJK669YTW7Uxm3HtT2ZKoZ6ScTWgc8F9jL8uHqn4p676iw_z-Q@mail.gmail.com>
References: <CAJK669YTW7Uxm3HtT2ZKoZ6ScTWgc8F9jL8uHqn4p676iw_z-Q@mail.gmail.com>
Date: Mon, 20 Aug 2012 15:45:06 -0500
Message-ID: <CACY--9EWSRWu9sxq62rmOwNR0tzzr-1HEwH4gnWd4z0xtrAKpw@mail.gmail.com>
Subject: Re: [PATCH 2/3] remoteproc: recover a remoteproc when it has crashed
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Mon, Aug 20, 2012 at 8:07 AM, Sjur Brændeland
<sjur.brandeland@stericsson.com> wrote:
>
> Hi Fernando,
>
> >This patch is introducing rproc_trigger_recover function which is in
> >charge of recovering the rproc. One way to recover the rproc after a
> > crash
> >is resetting all its virtio devices. Doing that, all rpmsg drivers are
> >restored along with the rpmsg devices and that also causes the reset of
> >the remoteproc making the rpmsg communication with the remoteproc
> >functional again. So far, rproc_trigger_recover function is only
> > resetting
> >all virtio devices, if in the future other rproc features are introduced
> >and need to be reset too, rproc_trigger_recover function should take care
> >of that.
>
> I think you drop the driver module's ref count during recovery, because
> rproc_shutdown calls module_put(). Maybe you should move driver
> ref count handling to rproc_add and rproc_type_release, instead of
> rproc_boot() and rproc_shutdown()?

How could you remove the remoteproc modules then?

omap remoteproc for example:

# modprobe omap_remoteproc

# lsmod
Module                  Size  Used by    Tainted: G
virtio_rpmsg_bus       12557  0
omap_remoteproc         6194  1
remoteproc             31112  1 omap_remoteproc
virtio_ring             9820  2 virtio_rpmsg_bus,remoteproc
virtio                  4865  2 virtio_rpmsg_bus,remoteproc

here if I want to remove the modules I can do:

modprobe -r virtio_rpmsg_bus

getting:

# lsmod
Module                  Size  Used by    Tainted: G
omap_remoteproc         6194  0
remoteproc             31112  1 omap_remoteproc
virtio_ring             9820  1 remoteproc
virtio

So, at this moment omap_remoteproc use count becomes 0 and then I can remove
omap_remoteproc and then remoteproc modules.

However if I do what you suggested then:
- omap_remoteproc depends on remoteproc module and it will increase the use
count of remoteproc module.
- as soon omap_remoteproc call rproc_add, remoteproc module will call
module_get on omap_remoteproc module so it will increase omap_remoteproc use
counter.

At this point we have a circular dependency, omap_remoteproc depends on
remoteproc and vice-versa. Making impossible to remove the remoteproc
modules. So, I don't think it is a good idea to move module_get/put calls.

what I could do is call module_get before calling rproc_remove_virtio_dev
for the virtio devices and call module_put after loading the firmware.
However, I am no sure why you want to address something like that. Don't
expect recovery to work if you call rmmod <platform rproc driver> at the
middle of the recovery, is like if in my example I would do

# modprobe omap_remoteproc

# rmmod virtio_rpmsg_bus
# rmmod omap_remoteproc

# modprobe virtio_rpmsg_bus

At this moment the remote proce will not boot because there is not more omap
remoteproc devices, that is expected and it won't generate any crash the
same way recovery won't generate any crash it will only do nothing after
removing the devices or it will fail gracefully because the rproc name does
not exists anymore.

However, if you still have concerns about that or a valid testcase where
that would have an unexpected behaviour we can think in a way to fix it.
Probably just calling module_get/put inside  rproc_trigger_recover is the
easiest way. Please let me know what you think.

>
>
> ...
> >+int rproc_trigger_recover(struct rproc *rproc)
> >+{
> >+      struct rproc_vdev *rvdev, *rvtmp;
> >+
> >+      dev_err(&rproc->dev, "recovering %s\n", rproc->name);
> >+
> >+      /* clean up remote vdev entries */
> >+      list_for_each_entry_safe(rvdev, rvtmp, &rproc->rvdevs, node)
> >+              rproc_remove_virtio_dev(rvdev);
>
> ...
>
> Is this safe? Are you guaranteed that rproc->power
> is counted down to zero at this point.

if the remoteproc is using rpmsg and there is no other module/user calling
rproc_boot it is guaranteed. Otherwise, it does not.

>
> Won't this fail if the
> firmware loading starts before all clients has called
> rproc_shutdown()?

Yes, the rproc refcount will never reach 0. Therefore, the remoteproc will
not be reset. At this moment we only support recovery of rprocs which are
only used by rpmsg module. If there are any other user which call directly
to rproc_boot then the recovery will not work for that case. AFAIK, there is
no such users right now, and we will need to implement some kind of rproc
crash notifications in order to address those cases. At the moment we don't
need that, but if you have some of those test cases we can discuss how to
address them. Please let me know what do you think.

>
>
> I guess virtio drivers potentially could defer the call to del_vqs()
> to a work-queue.

that would need to change the remoteproc_virtio.c which means change the
remoteproc module, that is not a thing that the platform remoteproc
implementation can change. So, if there are some changes in the remoteproc
core module to defer the find_vqs, the recovery should also change to
guarantee it will be functional.

>
> In this case  you cannot be guaranteed that the
> rproc is shut down at this point. You may also have e.g. platform
> driver who has previously called rproc_boot() and calls
> rproc_shutdown() after calling rproc_crash().

do you mean rproc_report_crash()? that function is not supposed to be called
by any platform driver which uses remoteproc, expect for the platform driver
which implements a specific remoteproc. So, that sequence should not be
valid at first place.

>
>
> I think you should wait for the rproc->power count to go to zero
> before initiating the firmware_loading. You could e.g.
> move firmware_loading to rproc_shutdown(), or add a
> completion.

Yes, that sounds good and it will work when we supports rproc_boot/shutdown
calls from anywhere and not only from rpmsg module(find_vqs). Also, I think
with that wait_for_completion inside rproc_trigger_recover will make more
clear how the recovery is performed (actually the need for ref counter to
become 0 in order to work).

I will try that and send a new patch to get more comments.

>
>
> BTW: I ran into a bug in unregister_virtio_device when testing
> your feature with SLAB_DEBUG=y. The dev->index is accessed
> after the device is freed. I'll submit a patch on this at some point.

good!

>
>
> After fixing that, your patch works for me!

Excellent news :).

Thanks for the comments and for try them out on your system.

Regards,
Fernando.

>
>
> Regards,
> Sjur
