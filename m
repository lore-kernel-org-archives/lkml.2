Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153Ab1D3BMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 21:12:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52900 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760998Ab1D3BMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 21:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1104300220040.3005@ionos>
References: <tip-304529b1b6f8612ccbb4582e997051b48b94f4a4@git.kernel.org>
	<BANLkTin12hcs1Q=4E4REdF_-zn08EJXzvw@mail.gmail.com>
	<alpine.LFD.2.02.1104300220040.3005@ionos>
Date: Fri, 29 Apr 2011 18:12:05 -0700
Message-ID: <BANLkTi=9rW=U-Excx+xJb1h3mVvfEaxhKw@mail.gmail.com>
Subject: Re: [tip:timers/core] time: Add timekeeping_inject_sleeptime
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        john.stultz@linaro.org, arnd@arndb.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/29 Thomas Gleixner <tglx@linutronix.de>:
> On Fri, 29 Apr 2011, Arve Hjønnevåg wrote:
>> On Fri, Apr 29, 2011 at 10:31 AM, tip-bot for John Stultz
>> <john.stultz@linaro.org> wrote:
>> > -       set_normalized_timespec(&time,
>> > -                               newtime + delta.tv_sec,
>> > -                               (NSEC_PER_SEC >> 1) + delta.tv_nsec);
>> > -       do_settimeofday(&time);
>> > +       /* subtract kernel time between rtc_suspend to rtc_resume */
>> > +       time = timespec_sub(time, timespec_sub(newts, oldts));
>>
>> The delta you got from the rtc can be almost a second to long or
>> short. Do you do anything to prevent these errors from accumulating?
>
> By using the the magic crystal ball to avoid it or what do you have in
> mind ?
>

This is how we worked around the problem with the old code:

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 09b4437..e55828a 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -42,25 +42,32 @@ static void rtc_device_release(struct device *dev)
  */

 static struct timespec delta;
+static struct timespec delta_delta;
 static time_t          oldtime;

 static int rtc_suspend(struct device *dev, pm_message_t mesg)
 {
        struct rtc_device       *rtc = to_rtc_device(dev);
        struct rtc_time         tm;
-       struct timespec         ts = current_kernel_time();
+       struct timespec         ts;
+       struct timespec         new_delta;

        if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
                return 0;

+       getnstimeofday(&ts);
        rtc_read_time(rtc, &tm);
        rtc_tm_to_time(&tm, &oldtime);

        /* RTC precision is 1 second; adjust delta for avg 1/2 sec err */
-       set_normalized_timespec(&delta,
+       set_normalized_timespec(&new_delta,
                                ts.tv_sec - oldtime,
                                ts.tv_nsec - (NSEC_PER_SEC >> 1));

+       /* prevent 1/2 sec errors from accumulating */
+       delta_delta = timespec_sub(new_delta, delta);
+       if (delta_delta.tv_sec < -2 || delta_delta.tv_sec >= 2)
+               delta = new_delta;
        return 0;
 }

@@ -80,6 +87,8 @@ static int rtc_resume(struct device *dev)
                return 0;
        }
        rtc_tm_to_time(&tm, &newtime);
+       if (delta_delta.tv_sec < -1)
+               newtime++;
        if (newtime <= oldtime) {
                if (newtime < oldtime)
                        pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));



-- 
Arve Hjønnevåg
