Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2GUUJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 16:09:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43230 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2GUUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 16:09:27 -0400
MIME-Version: 1.0
In-Reply-To: <201207211949.13944.rjw@sisk.pl>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
	<201207211949.13944.rjw@sisk.pl>
Date: Sun, 22 Jul 2012 04:09:26 +0800
Message-ID: <CACVXFVM+yJeDanZaSVc-snxu6edaOy+47oMSmcDr8zngUw4DnA@mail.gmail.com>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot and resume
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 1:49 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, July 20, 2012, Ming Lei wrote:

>> +     if (system_state != SYSTEM_RUNNING)
>> +             return -EPROBE_DEFER;
>
> You can't just return here, _request_firmware_cleanup() has to be done still.

Good catch, thanks.

>
>> +
>>       ret = usermodehelper_read_trylock();
>
> So why don't you do this here, actually, like:
>
>         if (ret) {
>                 ret = -EPROBE_DEFER;

The problem is that the 'ret' is zero for early boot situation.

>         } else {
>
> instead of the WARN_ON()?
>
> Arguably, all cases in which usermodehelper_read_trylock() returns error
> codes will require deferred probing.

Yes, looks !SYSTEM_RUNNING has covered all the cases already.

>
>>       if (WARN_ON(ret)) {
>>               dev_err(device, "firmware: %s will not be loaded\n", name);
>> diff --git a/include/linux/device.h b/include/linux/device.h
>> index d0e4d99..a63d3171 100644
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -244,7 +244,7 @@ extern struct device_driver *driver_find(const char *name,
>>                                        struct bus_type *bus);
>>  extern int driver_probe_done(void);
>>  extern void wait_for_device_probe(void);
>> -
>> +extern void driver_deferred_probe_trigger(void);
>>
>>  /* sysfs interface for exporting driver attributes */
>>
>> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>> index e07f5e0..c8d74c6 100644
>> --- a/include/linux/kernel.h
>> +++ b/include/linux/kernel.h
>> @@ -378,6 +378,7 @@ extern enum system_states {
>>       SYSTEM_POWER_OFF,
>>       SYSTEM_RESTART,
>>       SYSTEM_SUSPEND_DISK,
>> +     SYSTEM_SUSPEND,
>
> First off, SYSTEM_SUSPEND_DISK is not used and probably should be removed.
> Second, both SYSTEM_SUSPEND and SYSTEM_SUSPEND_DISK would require the same
> kind of handling in the respect of device probing, so it is not sufficient
> to change the state in suspend_devices_and_enter().

suspend_devices_and_enter is used by hibernation too, and the state is just
updated to RUNNING after suspend_finish.

>
> Moreover, there are other situations in which tasks are frozen and
> request_firmware() won't work just as well, so I don't think using
> system_state for that is going to work in general.

Looks system_state becoming SYSTEM_RUNNING means all tasks has
been thawed completely.



Thanks,
-- 
Ming Lei
