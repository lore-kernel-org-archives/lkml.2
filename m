Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0JKIpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:45:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43594 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab0JKIpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:45:30 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.86.31]
In-Reply-To: <1286785900.3101.9.camel@sven>
References: <1286177435.2140.5.camel@sven> <201010072323.05218.rjw@sisk.pl>
 <1286526197.4493.19.camel@sven> <201010082208.25767.rjw@sisk.pl>
 <AANLkTinSmPpswdHaZnP2rN688Wu1=-2Y2RBzC4+1qTpM@mail.gmail.com> <1286785900.3101.9.camel@sven>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 11 Oct 2010 10:45:07 +0200
Message-ID: <AANLkTinf-8jeaV6GZ2+pQ2FztrXDv7QhEn3brPN3osBT@mail.gmail.com>
Subject: Re: 2.6.35.6 fails to suspend (pxa2xx-mci.0)
To: Sven Neumann <s.neumann@raumfeld.com>, Chris Ball <cjb@laptop.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Daniel Mack <daniel@caiaq.de>,
        Colin Cross <ccross@android.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 10:31 AM, Sven Neumann <s.neumann@raumfeld.com> wrote:
> On Sat, 2010-10-09 at 03:07 +0200, Ohad Ben-Cohen wrote:
>> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>> index c94565d..515ff39 100644
>> --- a/drivers/mmc/core/core.c
>> +++ b/drivers/mmc/core/core.c
>> @@ -1682,6 +1682,19 @@ int mmc_suspend_host(struct mmc_host *host)
>>         if (host->bus_ops && !host->bus_dead) {
>>                 if (host->bus_ops->suspend)
>>                         err = host->bus_ops->suspend(host);
>> +               if (err == -ENOSYS || !host->bus_ops->resume) {
>> +                       /*
>> +                        * We simply "remove" the card in this case.
>> +                        * It will be redetected on resume.
>> +                        */
>> +                       if (host->bus_ops->remove)
>> +                               host->bus_ops->remove(host);
>> +                       mmc_claim_host(host);
>> +                       mmc_detach_bus(host);
>> +                       mmc_release_host(host);
>> +                       host->pm_flags = 0;
>> +                       err = 0;
>> +               }
>>         }
>>         mmc_bus_put(host);
>>
>> The reason I'm asking this is because it seems like commit
>> 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e "mmc: fix all hangs related
>> to mmc/sd card insert/removal during suspend/resume" has broken
>> suspending SDIO function drivers which don't have a suspend handler
>> (or do have one, but for some reason it returns -ENOSYS, like
>> libertas_sdio's does).
>
> Yes, this patch fixes the problem. Tested with v2.6.35-rc7. With above
> patch applied, suspend (and resume!) work again with and without
> pm_async=0.
>
> Thanks a lot to all of you for your help with this problem.

Thanks a lot for testing this Sven !

It is completely fixing the regression, but I must say the end result
is not very beautiful. We may eventually still use it, at least as an
interim solution, but I'd at least like to explain what's going on
here.

Patch 4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e "mmc: fix all hangs
related to mmc/sd card insert/removal during suspend/resume" (which
was introduced in 2.6.36 and backported to stable kernels) moved the
card remove/insert mechanism out of the suspend/resume path and into
mmc_pm_notify (which uses pm notifiers; needed in order to let user
space sync the card upon removal).

It broke (part of) SDIO suspend because SDIO relied on
mmc_suspend_host() to remove the card, and squash the error, in case
-ENOSYS is returned from the bus suspend handler (mmc_sdio_suspend()
in this case).

mmc_sdio_suspend() is using this whenever one of the card's SDIO
function drivers does not have suspend/resume handlers - in that case
it is agreed to force removal of the entire card.

So the trivial thing to do here was to bring back that part of
mmc_suspend_host(), which was removed by
4c2ef25fe0b847d2ae818f74758ddb0be1c27d8e.

The reason I said the end result is not too beautiful is because now
we have two places in the mmc suspend execution path that can remove
the card: mmc_pm_notify and mmc_suspend_host, where the second is
probably useful only for SDIO. The card re-insertion, btw, will only
take place in mmc_pm_notify, and be used by all scenarios (so it's
becoming asymmetric for SDIO).

To use mmc_pm_notify's card-removal code also for SDIO, we need to
check there if all the SDIO functions have suspend handlers. That
would probably make us add a new bus_ops handler (something like
host->bus_ops->remove_card_on_suspend ?).

It's starting to be a bit complicated though, and I'm not sure it
would make the code a lot more readable.

And, it would still not work for drivers like libertas sdio, which do
have a suspend hander, but sometimes let it return -ENOSYS, expecting
the MMC core to remove the card and squash the error. For those cases,
we still need the old card-removal logic in mmc_suspend_host().

Btw, it makes me wonder: does libertas_sdio really needs this
functionality ? When MMC_PM_KEEP_POWER is not needed, why can't
libertas_sdio just return 0 (and as a result the card will be powered
off, but not removed) ?

To sum up, I think we can begin with taking this patch, at least as an
interim solution, and take the discussion of making the whole thing
more elegant to linux-mmc.

If that's agreed, I'll send that patch again with a decent commit
message, so we can take it to 2.6.36 and stable kernels.

>
>
> Regards,
> Sven
>
>
>
