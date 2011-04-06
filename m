Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab1DFHE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 03:04:56 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5631 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1DFHEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 03:04:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XJrUYyNeibibOINaYM9770jCgX/PGsVUJMhMTm9popyOTvb2Ptj2jPwEZddhTIobps
         XLMvLpYN7tVGSC3SE1Lw==
MIME-Version: 1.0
In-Reply-To: <20110406030220.GB22535@ericsson.com>
References: <1302038697-28985-1-git-send-email-natg@google.com>
	<20110405223814.GA21350@ericsson.com>
	<BANLkTimQDVYe53K-M173iQtmkHzKg6Djyg@mail.gmail.com>
	<20110406000528.GB21350@ericsson.com>
	<BANLkTi==zj3PoNuqf2=THaHzevvHHsuh=w@mail.gmail.com>
	<20110406004312.GA21882@ericsson.com>
	<BANLkTinSAOxNkjxMGewfPUc0-bjf9MesGA@mail.gmail.com>
	<20110406030220.GB22535@ericsson.com>
Date: Wed, 6 Apr 2011 00:04:51 -0700
Message-ID: <BANLkTimTfWrx-ezyerRTtZHrLdOOf2V19w@mail.gmail.com>
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
      Thank you for your feedback. I found an easier way to deal with
the it87_lock.c file. I do not need to move it to the driver/misc
directory. The easier thing to do was to move the IT87_LOCK entry to
the beginning of the drivers/watchdog/Kconfig file. This moves the
entry before the "menuconfig WATCHDOG" entry. They use the exact same
trick in drivers/misc/Kconfig file. The very first lines of
drivers/watchdog/Kconfig file will look something like this:

#
# Watchdog device configuration
#

# This one has to live outside of the WATCHDOG conditional,
# because it may be selected by drivers/hwmon/it87.c.
config IT87_LOCK
	bool
	default n
	---help---
	  This defines the global lock needed by all IT87 drivers that
	  touch the Super I/0 chipset used on many motherboards. This
	  is needed to serialize access to the registers in SMP
	  systems. All it87 drivers will select this Kconfig option to compile
	  the lock into the kernel.

menuconfig WATCHDOG
	bool "Watchdog Timer Support"
	---help---
	  If you say Y here (and to one of the following options) and create a

Regards
Nat

On Tue, Apr 5, 2011 at 8:02 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> On Tue, Apr 05, 2011 at 10:50:47PM -0400, Natarajan Gurumoorthy wrote:
>> Guenter,
>>       Thank you for spotting the fact the everything goes south if you
>> disable "watchdog". I am working on a solution. Looks like the ideal
>> place to store it87_io_lock.c will be drivers/misc and the IT87_LOCK
>> config will be placed before the MISC_DEVICES entry in
>> drivers/misc/Kconfig file. This will be similar to the
>> SENSORS_LIS3LV02D entry in that Kconfig file.
>>
> Almost, only afaik that is only used inside the misc directory, or at least
> has some other components there. I don't really know how to handle this
> situation correctly, except you could of course write a mfd driver to handle
> the generic parts.
>
>>       Now going back to the partitioning do I send this change out as
>> a multi patch set consisting of 4 parts something as below:
>>
>> patch 0 has a description
>>
>> patch 1 has only the lock and related files
>>         drivers/misc/Kconfig
>>         drivers/misc/Makefile
>>         include/linux/it87_lock.h
>>         drivers/misc/it87_lock.c
>>
>> patch 2 has drivers/watchdog changes
>>         drivers/watchdog/Kconfig
>>         drivers/watchdog/it8712f_wdt.c
>>         drivers/watchdog/it87_wdt.c
>>
>> patch 3 has drives/hwmon changes
>>         drivers/hwmon/Kconfig
>>         drivers/hwmon/it87.c
>>
> Something like that. I have some doubts about using drivers/misc,
> but I guess you'll get feedback on that after you submit the patch set.
>
> Thanks,
> Guenter
>



-- 
Regards
Nat Gurumoorthy AB6SJ
