Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0HWWRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:17:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57871 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0HWWRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:17:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aLL+kFqyYDTdJz/5XkdvUUZV70sPpTv1sN/bPwmsIl0ZqZouVf0KdvcUYm9oUUi9i+
         QYXt2b+kjRfsiJrNbFf59jTrmKYSzR8uytURCD5PxuT4b71/nWMhmmYZvlsyhwcPC2mg
         4o0BGgF1KRq3h3/BtveePWZqJKdqAb3VbRNtc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikTF9uvKw+48_jJKLAwqp7MJnypvvUsHN3qQ58+@mail.gmail.com>
References: <AANLkTi=ivkOHRYwLy5FDg3RnK18+opjGd9XsxC7yZqi7@mail.gmail.com>
	<AANLkTik0ZGs3i_mHtB0s6iT6X0cLgxMjRN7Hi9FK_ZLF@mail.gmail.com>
	<AANLkTikTF9uvKw+48_jJKLAwqp7MJnypvvUsHN3qQ58+@mail.gmail.com>
Date: Mon, 23 Aug 2010 15:17:39 -0700
X-Google-Sender-Auth: wUUUsvdW1e-M4VUao3SuZipsOYc
Message-ID: <AANLkTin80q4tGPZ1FefWCUMmhpNKj3_-KZZB12gZvwSA@mail.gmail.com>
Subject: Re: System time drifts when processor idle.
From: john stultz <johnstul@us.ibm.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: Lin Ming <lin@ming.vg>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 1:46 AM, jean-philippe francois
<jp.francois@cynove.com> wrote:
> 2010/8/21 Lin Ming <lin@ming.vg>:
>> On Fri, Aug 20, 2010 at 8:55 AM, jean-philippe francois
>> <jp.francois@cynove.com> wrote:
>>> Hi,
>>>
>>> Please correct me if I am sending this to the wrong list.
>>
>> LKML is better for this issue. Added.
>>
>
> Thank you. I have been looking at the ML archives, and it seems there
> has been issue related to timekeeping lately. So I tested my script
> with a decently recent kernel : 2.6.36-rc1.
>
> The timekeeping bug described below still exists.
>>>
>>> I would like to debug the following issue, which I suspect is related
>>> to cpu losing track of time when going idle.
>>>
>>> When I run the following script :
>>>
>>> #!/bin/bash
>>> # set hwclock to system clock to start
>>> # the log file with the same time
>>> hwclock -w
>>> #start with a fresh logfile
>>> touch clocktest.log
>>> echo START > clocktest.log
>>> while [[ true ]]
>>> do
>>>    systime=$(date)
>>>    hwtime=$(hwclock -r)
>>>    echo "$systime | $hwtime" >> clocktest.log
>>>    sleep 20
>>> done
>>>
>>> Expected output :
>>> On each line, the system time (left) and hardware time (right)
>>> should be roughly the same. Time delta between each line should be
>>> around 20 seconds
>>>
>>> Observed output :
>>> This is an edited version of the real logfile  so that it fits on one
>>> line. the date was removed.
>>> START
>>> 15:09:43 (UTC+0200) |  15:09:44 CEST -0.500555 secondes
>>> 15:10:04 (UTC+0200) |  15:10:05 CEST -1.001562 secondes
>>> 15:10:25 (UTC+0200) |  15:10:26 CEST -0.985944 secondes
>>> 15:10:46 (UTC+0200) |  15:15:46 CEST -0.032792 secondes <-- 5 minute lag !
>>> 15:11:06 (UTC+0200) |  15:16:07 CEST -0.985926 secondes
>>> 15:11:27 (UTC+0200) |  15:16:28 CEST -1.001539 secondes
>>> 15:11:48 (UTC+0200) |  15:16:49 CEST -0.985969 secondes
>>> 15:12:09 (UTC+0200) |  15:17:10 CEST -0.985977 secondes
>>> 15:12:30 (UTC+0200) |  15:17:31 CEST -1.001544 secondes
>>> 15:12:51 (UTC+0200) |  15:17:52 CEST -0.985920 secondes
>>> 15:13:12 (UTC+0200) |  15:18:13 CEST -0.985939 secondes
>>> 15:13:33 (UTC+0200) |  15:18:34 CEST -1.001581 secondes
>>> 15:13:54 (UTC+0200) |  15:18:55 CEST -0.985917 secondes
>>> 15:14:15 (UTC+0200) |  15:29:15 CEST -0.079685 secondes <-- add
>>> another 10 minute
>>> 15:14:35 (UTC+0200) |  15:29:36 CEST -1.001568 secondes
>>> 15:14:56 (UTC+0200) |  15:29:57 CEST -0.985952 secondes
>>>
>>> As you can see, after 20 minutes without touching the computer, the
>>> system time is late by 15 minutes.
>>> This was tested on ubuntu 10.04 with a 2.6.32  "vanilla" kernel where
>>> "vanilla" means ubuntu packaged
>>> upstream kernel  closest to the distribution shipped kernel.

Could you provide the output of:
cat /sys/devices/system/clocksource/clocksource0/available_clocksource
cat /sys/devices/system/clocksource/clocksource0/current_clocksource

I assume you're using the TSC, and hitting the halt-in-c3 issue, but
I'm curious why the clocksource watchdog isn't catching this and
dropping you back to a more stable clocksource.

thanks
-john
