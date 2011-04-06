Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1DFHUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 03:20:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:21280 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab1DFHUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 03:20:24 -0400
Date: Wed, 6 Apr 2011 09:19:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Natarajan Gurumoorthy <natg@google.com>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH] Make all it87 drivers SMP safe.
Message-ID: <20110406091915.59bd5ea3@endymion.delvare>
In-Reply-To: <20110406030220.GB22535@ericsson.com>
References: <1302038697-28985-1-git-send-email-natg@google.com>
	<20110405223814.GA21350@ericsson.com>
	<BANLkTimQDVYe53K-M173iQtmkHzKg6Djyg@mail.gmail.com>
	<20110406000528.GB21350@ericsson.com>
	<BANLkTi==zj3PoNuqf2=THaHzevvHHsuh=w@mail.gmail.com>
	<20110406004312.GA21882@ericsson.com>
	<BANLkTinSAOxNkjxMGewfPUc0-bjf9MesGA@mail.gmail.com>
	<20110406030220.GB22535@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 20:02:20 -0700, Guenter Roeck wrote:
> On Tue, Apr 05, 2011 at 10:50:47PM -0400, Natarajan Gurumoorthy wrote:
> > Guenter,
> >       Thank you for spotting the fact the everything goes south if you
> > disable "watchdog". I am working on a solution. Looks like the ideal
> > place to store it87_io_lock.c will be drivers/misc and the IT87_LOCK
> > config will be placed before the MISC_DEVICES entry in
> > drivers/misc/Kconfig file. This will be similar to the
> > SENSORS_LIS3LV02D entry in that Kconfig file.
> > 
> Almost, only afaik that is only used inside the misc directory, or at least
> has some other components there. I don't really know how to handle this
> situation correctly, except you could of course write a mfd driver to handle
> the generic parts.
> 
> >       Now going back to the partitioning do I send this change out as
> > a multi patch set consisting of 4 parts something as below:
> > 
> > patch 0 has a description
> > 
> > patch 1 has only the lock and related files
> >         drivers/misc/Kconfig
> >         drivers/misc/Makefile
> >         include/linux/it87_lock.h
> >         drivers/misc/it87_lock.c
> > 
> > patch 2 has drivers/watchdog changes
> >         drivers/watchdog/Kconfig
> >         drivers/watchdog/it8712f_wdt.c
> >         drivers/watchdog/it87_wdt.c
> > 
> > patch 3 has drives/hwmon changes
> >         drivers/hwmon/Kconfig
> >         drivers/hwmon/it87.c
> > 
> Something like that. I have some doubts about using drivers/misc,
> but I guess you'll get feedback on that after you submit the patch set.

I would definitely prefer drivers/mfd over drivers/misc. The
problematic we are trying to solve here is typically a multi-function
device one.

This also raises concerns about the implementation. The shared spinlock
looks like a band-aid solution to me. The initial problem is that all
these drivers access I/O ports they did NOT reserve as they were
supposed to do. If they did, the conflict would have been spotted much
earlier.

I seem to recall that there has been work in the past on a new
"superio" subsystem which would help centralize detection of and I/O
access to all Super-I/O chips (bringing driver autoloading in almost
all cases as a nice side benefit.) I never had the time to review it,
but as I recall others had reviewed it so it may be in a suitable shape
for upstream inclusion (after forward-porting - the code is getting
old.)

http://www.google.com/search?q=site%3Alists.lm-sensors.org+superio+lock

Don't get me wrong, the current situation is bad enough that a band-aid
solution is welcome. But it doesn't seem good enough for the long run.

-- 
Jean Delvare
