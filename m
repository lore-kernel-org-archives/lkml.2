Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2DXQc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:32:28 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45343 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab2DXQc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:32:26 -0400
Message-ID: <4F96D58A.3070008@ahsoftware.de>
Date: Tue, 24 Apr 2012 18:32:10 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120303 Thunderbird/10.0.1
MIME-Version: 1.0
To: shuahkhan@gmail.com
CC: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] leds: heartbeat: stop on shutdown
References: <1335275034-22135-1-git-send-email-holler@ahsoftware.de>  <1335280022-16308-1-git-send-email-holler@ahsoftware.de> <1335281074.2347.4.camel@lorien2>
In-Reply-To: <1335281074.2347.4.camel@lorien2>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.04.2012 17:24, schrieb Shuah Khan:
> On Tue, 2012-04-24 at 17:07 +0200, Alexander Holler wrote:
>> A halted kernel should not show a heartbeat.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>> ---
>>  drivers/leds/ledtrig-heartbeat.c |   18 +++++++++++++++++-
>>  1 files changed, 17 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
>> index 759c0bb..1c05bd9 100644
>> --- a/drivers/leds/ledtrig-heartbeat.c
>> +++ b/drivers/leds/ledtrig-heartbeat.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/timer.h>
>>  #include <linux/sched.h>
>>  #include <linux/leds.h>
>> +#include <linux/reboot.h>
>>  #include "leds.h"
>>  
>>  struct heartbeat_trig_data {
>> @@ -101,13 +102,28 @@ static struct led_trigger heartbeat_led_trigger = {
>>  	.deactivate = heartbeat_trig_deactivate,
>>  };
>>  
>> +static int heartbeat_reboot_notifier(struct notifier_block *nb,
>> +				     unsigned long code, void *unused)
>> +{
>> +	led_trigger_unregister(&heartbeat_led_trigger);
>> +	return NOTIFY_DONE;
>> +}
>> +
>> +static struct notifier_block heartbeat_reboot_nb = {
>> +	.notifier_call = heartbeat_reboot_notifier,
>> +};
>> +
>>  static int __init heartbeat_trig_init(void)
>>  {
>> -	return led_trigger_register(&heartbeat_led_trigger);
>> +	int rc = led_trigger_register(&heartbeat_led_trigger);
>> +	if( ! rc )
>> +		register_reboot_notifier(&heartbeat_reboot_nb);
> 
> Do you need to check return value here? I see return value being checked
> in some places in the kernel and not in others. Not checking is fine for
> now since register_reboot_notifier() always returns 0.
> 
> Maybe adding return handling might not be a bad idea to be consistent
> with other places that do check.

What to do if it fails? As long as unregister_reboot_notifier() doesn't
do something bad with non-registered notifiers (which it doesn't), I
would let the init still succeed. And to not unregister a
non-registered-reboot_notifier, a long-living bool would be needed.

> FYI - Andrew Morton is handling led patches these days. You might want
> to send include him  <akpm@linux-foundation.org>

I have added him to CC, thanks.

Regards,

Alexander
