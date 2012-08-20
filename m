Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab2HTNHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:07:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58360 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab2HTNHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:07:34 -0400
MIME-Version: 1.0
Date: Mon, 20 Aug 2012 15:07:33 +0200
X-Google-Sender-Auth: kHK8ADvMMeCNhwa73WsnUwhaGe0
Message-ID: <CAJK669YTW7Uxm3HtT2ZKoZ6ScTWgc8F9jL8uHqn4p676iw_z-Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] remoteproc: recover a remoteproc when it has crashed
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fernando,

>This patch is introducing rproc_trigger_recover function which is in
>charge of recovering the rproc. One way to recover the rproc after a crash
>is resetting all its virtio devices. Doing that, all rpmsg drivers are
>restored along with the rpmsg devices and that also causes the reset of
>the remoteproc making the rpmsg communication with the remoteproc
>functional again. So far, rproc_trigger_recover function is only resetting
>all virtio devices, if in the future other rproc features are introduced
>and need to be reset too, rproc_trigger_recover function should take care
>of that.

I think you drop the driver module's ref count during recovery, because
rproc_shutdown calls module_put(). Maybe you should move driver
ref count handling to rproc_add and rproc_type_release, instead of
rproc_boot() and rproc_shutdown()?

...
>+int rproc_trigger_recover(struct rproc *rproc)
>+{
>+	struct rproc_vdev *rvdev, *rvtmp;
>+
>+	dev_err(&rproc->dev, "recovering %s\n", rproc->name);
>+
>+	/* clean up remote vdev entries */
>+	list_for_each_entry_safe(rvdev, rvtmp, &rproc->rvdevs, node)
>+		rproc_remove_virtio_dev(rvdev);

...

Is this safe? Are you guaranteed that rproc->power
is counted down to zero at this point. Won't this fail if the
firmware loading starts before all clients has called
rproc_shutdown()?

I guess virtio drivers potentially could defer the call to del_vqs()
to a work-queue. In this case  you cannot be guaranteed that the
rproc is shut down at this point. You may also have e.g. platform
driver who has previously called rproc_boot() and calls
rproc_shutdown() after calling rproc_crash().

I think you should wait for the rproc->power count to go to zero
before initiating the firmware_loading. You could e.g.
move firmware_loading to rproc_shutdown(), or add a
completion.

BTW: I ran into a bug in unregister_virtio_device when testing
your feature with SLAB_DEBUG=y. The dev->index is accessed
after the device is freed. I'll submit a patch on this at some point.

After fixing that, your patch works for me!

Regards,
Sjur
