Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1DFCuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 22:50:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58817 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab1DFCuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 22:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jqRINbdzndKCuxFjzPgkDc/XhYSNzyhg33p/gpLCFYfy42aaadCtBkqVYhmmYKCC7L
         X//lD4W5G/LQa7cfnbAw==
MIME-Version: 1.0
In-Reply-To: <20110406004312.GA21882@ericsson.com>
References: <1302038697-28985-1-git-send-email-natg@google.com>
	<20110405223814.GA21350@ericsson.com>
	<BANLkTimQDVYe53K-M173iQtmkHzKg6Djyg@mail.gmail.com>
	<20110406000528.GB21350@ericsson.com>
	<BANLkTi==zj3PoNuqf2=THaHzevvHHsuh=w@mail.gmail.com>
	<20110406004312.GA21882@ericsson.com>
Date: Tue, 5 Apr 2011 19:50:47 -0700
Message-ID: <BANLkTinSAOxNkjxMGewfPUc0-bjf9MesGA@mail.gmail.com>
Subject: Re: [PATCH] Make all it87 drivers SMP safe.
From: Natarajan Gurumoorthy <natg@google.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,
      Thank you for spotting the fact the everything goes south if you
disable "watchdog". I am working on a solution. Looks like the ideal
place to store it87_io_lock.c will be drivers/misc and the IT87_LOCK
config will be placed before the MISC_DEVICES entry in
drivers/misc/Kconfig file. This will be similar to the
SENSORS_LIS3LV02D entry in that Kconfig file.

      Now going back to the partitioning do I send this change out as
a multi patch set consisting of 4 parts something as below:

patch 0 has a description

patch 1 has only the lock and related files
        drivers/misc/Kconfig
        drivers/misc/Makefile
        include/linux/it87_lock.h
        drivers/misc/it87_lock.c

patch 2 has drivers/watchdog changes
        drivers/watchdog/Kconfig
        drivers/watchdog/it8712f_wdt.c
        drivers/watchdog/it87_wdt.c

patch 3 has drives/hwmon changes
        drivers/hwmon/Kconfig
        drivers/hwmon/it87.c

Regards
Nat

On Tue, Apr 5, 2011 at 5:43 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
>
> On Tue, Apr 05, 2011 at 08:13:50PM -0400, Natarajan Gurumoorthy wrote:
> > Guenter,
> >       How would you partition it out? Are you suggesting that we do
> > the following:
> >
> > Patch1:
> >    drivers/hwmon/Kconfig          |    1 +
> >    drivers/hwmon/it87.c           |   14 ++++++++++++-
> >
> > Patch2:
> >    drivers/watchdog/Kconfig       |   12 +++++++++++
> >    drivers/watchdog/Makefile      |    1 +
> >    drivers/watchdog/it8712f_wdt.c |   10 ++++----
> >    drivers/watchdog/it87_lock.c   |   27 +++++++++++++++++++++++++
> >    drivers/watchdog/it87_wdt.c    |   42 ++++++---------------------------------
> >
> > Patch3:
> >    include/linux/it87_lock.h      |   28 ++++++++++++++++++++++++++
> >
> No, not really. The include file is part of the locking code, and the sequence is wrong.
>
> I personally would introduce the lock in the 1st patch.
> This would affect
>        drivers/watchdog/it87_lock.c
>        include/linux/it87_lock.h
>        drivers/watchdog/Makefile
>        drivers/watchdog/Kconfig
>
> The second patch would update the watchdog driver, affecting
>        drivers/watchdog/Kconfig
>        drivers/watchdog/it8712f_wdt.c
>
> and the last patch would update the hwmon driver.
>        drivers/hwmon/Kconfig
>        drivers/hwmon/it87.c
>
> Others may argue that patch 1 and 2 (introducing the lock and updating
> the watchdog driver) should be in a single patch, since the lock alone
> does not do anything without being used. This is a matter of opinion
> and really depends on the maintainer of the watchdog subsystem.
>
> Note that your patch has practical problems. If I disable WATCHDOG but enable
> the IT87 hwmon driver, I get:
>
> warning: (SENSORS_IT87) selects IT87_LOCK which has unmet direct dependencies (WATCHDOG)
>
> during configuration, and undefined references to it87_io_lock when linking.
> So it looks like you might want to consider moving the locking code to a location
> outside the watchdog code.
>
> Thanks,
> Guenter



--
Regards
Nat Gurumoorthy AB6SJ
