Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0JWOoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 10:44:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65466 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab0JWOoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 10:44:21 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <1287843531.29752.10.camel@maxim-laptop>
References: <1286788315.3101.11.camel@sven> <1286955116-22793-1-git-send-email-ohad@wizery.com>
 <1287704855.12734.14.camel@maxim-laptop> <AANLkTi=iC1uKyToEXrroOj+JxQ2mW97WRVEXjv+9oQEa@mail.gmail.com>
 <1287843531.29752.10.camel@maxim-laptop>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 23 Oct 2010 16:44:00 +0200
Message-ID: <AANLkTikgrsyeZVEnce1ouCD2ehrYg7=w54MYCSLi5Ekp@mail.gmail.com>
Subject: Re: [PATCH] sdio: fix suspend/resume regression
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-mmc@vger.kernel.org, Sven Neumann <s.neumann@raumfeld.com>,
        Chris Ball <cjb@laptop.org>, Nicolas Pitre <nico@fluxnic.net>,
        libertas-dev@lists.infradead.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Mack <daniel@caiaq.de>, Colin Cross <ccross@android.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 4:18 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Sat, 2010-10-23 at 12:09 +0200, Ohad Ben-Cohen wrote:
...
>> >> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
>> >> index c94565d..515ff39 100644
>> >> --- a/drivers/mmc/core/core.c
>> >> +++ b/drivers/mmc/core/core.c
>> >> @@ -1682,6 +1682,19 @@ int mmc_suspend_host(struct mmc_host *host)
>> >>       if (host->bus_ops && !host->bus_dead) {
>> >>               if (host->bus_ops->suspend)
>> >>                       err = host->bus_ops->suspend(host);
>> >> +             if (err == -ENOSYS || !host->bus_ops->resume) {

>> > This reintroduces the bug I fixed.
...
>> In this case, mmc_suspend_host() should skip the code you are concerned about.

> You are right here.
> There is a very unlikely case that suspend of sd/mmc card fails (with
> CONFIG_MMC_UNSAFE_RESUME set, and that will trigger the hang, but that
> currently isn't possible because both mmc_sd_suspend and mmc_suspend
> just return 0 unconditionally).

Please note that the card is removed only on -ENOSYS, which is not a
random error that can happen. In this context, it's a deliberate
request (from the underlying bus) to remove the card.

So even if mmc_{sd_}suspend will be changed to propagate an error code
one day, it is unlikely that they will trigger this bug even if they
fail.

> Btw, two above functions are identical, so some refactoring won't hurt.

Feel free to send a patch ;)

Regards,
Ohad.
