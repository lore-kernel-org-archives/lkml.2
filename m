Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1DFAn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 20:43:59 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45090 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596Ab1DFAn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 20:43:57 -0400
Date: Tue, 5 Apr 2011 17:43:12 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Natarajan Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH] Make all it87 drivers SMP safe.
Message-ID: <20110406004312.GA21882@ericsson.com>
References: <1302038697-28985-1-git-send-email-natg@google.com>
 <20110405223814.GA21350@ericsson.com>
 <BANLkTimQDVYe53K-M173iQtmkHzKg6Djyg@mail.gmail.com>
 <20110406000528.GB21350@ericsson.com>
 <BANLkTi==zj3PoNuqf2=THaHzevvHHsuh=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi==zj3PoNuqf2=THaHzevvHHsuh=w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 08:13:50PM -0400, Natarajan Gurumoorthy wrote:
> Guenter,
>       How would you partition it out? Are you suggesting that we do
> the following:
> 
> Patch1:
>    drivers/hwmon/Kconfig          |    1 +
>    drivers/hwmon/it87.c           |   14 ++++++++++++-
> 
> Patch2:
>    drivers/watchdog/Kconfig       |   12 +++++++++++
>    drivers/watchdog/Makefile      |    1 +
>    drivers/watchdog/it8712f_wdt.c |   10 ++++----
>    drivers/watchdog/it87_lock.c   |   27 +++++++++++++++++++++++++
>    drivers/watchdog/it87_wdt.c    |   42 ++++++---------------------------------
> 
> Patch3:
>    include/linux/it87_lock.h      |   28 ++++++++++++++++++++++++++
> 
No, not really. The include file is part of the locking code, and the sequence is wrong.

I personally would introduce the lock in the 1st patch.
This would affect
	drivers/watchdog/it87_lock.c
	include/linux/it87_lock.h
	drivers/watchdog/Makefile
	drivers/watchdog/Kconfig

The second patch would update the watchdog driver, affecting 
	drivers/watchdog/Kconfig
	drivers/watchdog/it8712f_wdt.c

and the last patch would update the hwmon driver.
	drivers/hwmon/Kconfig
	drivers/hwmon/it87.c

Others may argue that patch 1 and 2 (introducing the lock and updating
the watchdog driver) should be in a single patch, since the lock alone
does not do anything without being used. This is a matter of opinion
and really depends on the maintainer of the watchdog subsystem.

Note that your patch has practical problems. If I disable WATCHDOG but enable
the IT87 hwmon driver, I get:

warning: (SENSORS_IT87) selects IT87_LOCK which has unmet direct dependencies (WATCHDOG)

during configuration, and undefined references to it87_io_lock when linking.
So it looks like you might want to consider moving the locking code to a location
outside the watchdog code.
 
Thanks,
Guenter
