Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1BGB2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 20:28:30 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:51359 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030Ab1BGB23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 20:28:29 -0500
Message-ID: <4D4F4B18.6030502@metafoo.de>
Date: Mon, 07 Feb 2011 02:30:00 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Grazvydas Ignotas <notasas@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] POWER: BQ27x00: New Properties, fixes, bq27000
 support
References: <1296953291-10373-1-git-send-email-lars@metafoo.de> <AANLkTimN1ACy=rREGhvAqTwfywHb7_Td7ZeKosQc9txC@mail.gmail.com>
In-Reply-To: <AANLkTimN1ACy=rREGhvAqTwfywHb7_Td7ZeKosQc9txC@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 01:58 AM, Grazvydas Ignotas wrote:
> On Sun, Feb 6, 2011 at 2:47 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> This patch series contains a few updates for the bq27x00 driver:
>> * Support for additional power supply properties
>> * Support for the bq27000 battery which is identical to the bq27200 but is
>>  connected through the HDQ bus.
>> * Adds a register cache to the driver and introduces polling the batteries state
>> * Minor improvements and cleanups
>>
>> The last patch in this series is not specific to the bq27x00 driver but is
>> required for uevents to be generated properly for this driver.
>> The patch makes properties which return -ENODATA to be ignored when generating
>> uevents. Previously in such a case uevent generation would have been aborted
>> with an error. But since the bq27x00 return -ENODATA for the TIME_TO_FULL
>> property when the battery is not charging and for the TIME_TO_EMPTY property
>> when the battery is not discharging and at least one of them is always true
>> uevent generation would always fail.
>>
>> This series has so far been tested with the bq27000 and the bq27200 battery, but
>> not with the bq27500 battery, so it would be nice if somebody with a board
>> containing such a battery could test the patches to make sure that there are no
>> regressions.
> 
> Trying this on pandora board (bq27500 over i2c) and it seems there is
> something wrong with the cache, I'm always getting the old values. I'm
> reading them manually over sysfs, uptime is over 25min but values
> still match ones on boot, even after turning off the backlight.
> 
> Looking at the code delayed_work handling looks suspicious,
> bq27x00_battery_get_property() flushes it and nothing ever reschedules
> it. Other than that all new property values looks sane.

Hi

Hm, I tought that rescheduling from withing the work function would work, even when
flushing the work, at least it did here.
But the current code is broken if poll_interval is 0 anyway, cause then it wont
reschedule itself and is never run again.

Could you try:

if (time_is_before_jiffies(di->last_update + 6 * HZ)) {
	cancel_delayed_work_sync(&di->work);
	bq27x00_battery_work(&di->work);
}

- Lars
