Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1LEK0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:26:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53812 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab1LEK0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:26:04 -0500
MIME-Version: 1.0
X-Originating-IP: [85.250.72.170]
In-Reply-To: <20111205125416.6093ecd8@notabene.brown>
References: <20111205125416.6093ecd8@notabene.brown>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 5 Dec 2011 12:25:42 +0200
Message-ID: <CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
Subject: Re: [PATCH] mmc/sdio: don't allow interface to runtime-suspend until
 probe is finished.
To: NeilBrown <neilb@suse.de>
Cc: linux-mmc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Daniel Drake <dsd@laptop.org>, Joe Woodward <jw@terrafix.co.uk>,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On Mon, Dec 5, 2011 at 3:54 AM, NeilBrown <neilb@suse.de> wrote:
>  I've been chasing down a problem with the SDIO-attached wifi card in the
>  GTA04 (www.gta04.org).

8686, right ?

>  The problem seems very similar to that described in
>
>    http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg04289.html

Don't go that far back, Joe just reported this exact problem in :

http://comments.gmane.org/gmane.linux.kernel.mmc/11231

> commit 08da834a24312157f512224691ad1fddd11c1073
> Author: Daniel Drake <dsd@laptop.org>
> Date:   Wed Jul 20 17:39:22 2011 +0100
>
>    mmc: enable runtime PM by default
>
>
> and if I revert that commit so that runtime PM is not enabled the problem
> goes away.

And this is most likely what we're going to do, unless someone with
the 8686 can further look into the problem.

> (The wifi chip is a libertas_sdio supported chip connected to an mmc
> interface on an omap3, and has a separate regulator for power supply, plus a
> GPIO pin for reset, just like in the email thread.  The problem is
> exemplified by:
> [   64.643981] libertas_sdio: probe of mmc1:0001:1 failed with error -16
> ).

Yes, the same issue that Joe is seeing.

> I finally managed to track down exactly what was happening - runtime PM was
> putting the interface to sleep before the SDIO functions were probed so
> initialising them failed.

Yeah, but the question is why it fails.

It's perfectly fine to power the card down before the functions are
probed, because just before they are probed the bus is responsible to
power the card up again.

> From: NeilBrown <neilb@suse.de>
> Date: Mon, 5 Dec 2011 11:34:47 +1100
> Subject: [PATCH] mmc/sdio: don't allow interface to runtime-suspend until probe is finished.

You can't tell when probe is finished. In fact, in can happen very far
in the future or even never at all (e.g. when the function driver
isn't loaded).

> mmc_attach_sdio currently enables runtime power management on
> the mmc interface before it completes the probe of functions.
> This means that it might be asleep during the probe and the probe
> will fail.

No - the sdio bus powers the card up before probing the drivers. See
sdio_bus_probe.

> In particular, if 'drivers_autoprobe' is enabled on the mmc bus, then
> device_attach() will be called by bus_probe_device() from device_add()
> and it will pm_runtime_get_noresume()/pm_runtime_put_sync().
>
> As runtime power management this the device is running
> (pm_runtime_set_active() in mmc_attach_sdio()) and rtpm is enabled
> (pm_runtime_enable()), the pm_runtime_put_sync() call puts the mmc
> interface to sleep,

This is fine

> so function probing fails.

The question is why. Again - sdio_bus_probe should power up the card.
For some reason, it (or something else) fails to do so with the 8686
on some setups. Other chips might have similar issues, too - we just
don't know (all we know is that it works great with the wl12xx, and
with the Daniel's 8686 setup).

> So this patch moves the call to pm_runtime_enable to after all the
> calls to sdio_add_func.

Looks like this will have the undesired side-effect of keeping the
chip powered up, even if it doesn't have any driver loaded for it.

And this doesn't really address the problem: we still don't know why
the 8686 fails to power up at this point.

Can you please tell us where exactly is the first failure coming from
? is this from libertas own probe function ? is this sdio_bus_probe
getting an error from calling pm_runtime_get_sync ?

Thanks,
Ohad
