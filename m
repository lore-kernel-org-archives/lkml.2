Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2FZJej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:34:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48085 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab2FZJeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <4FE81EEE.3040001@arm.com>
References: <1340451839-30623-1-git-send-email-devendra.aaru@gmail.com>
	<4FE81EEE.3040001@arm.com>
Date: Tue, 26 Jun 2012 15:04:37 +0530
Message-ID: <CAHdPZaO7kO=-eZ5X+9wi+KjJVwYhKKK0UkTJ_arR+YS3rqQTLg@mail.gmail.com>
Subject: Re: [PATCH] rtc/rtc-spear: remove unnecessary check against
 rtc_valid_tm and tm2bcd
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: viresh kumar <viresh.kumar2@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        "spear-devel@list.st.com" <spear-devel@list.st.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,


On Mon, Jun 25, 2012 at 1:48 PM, viresh kumar <viresh.kumar2@arm.com> wrote:
>
> Hi Devendra,
>
> On 23/06/12 12:43, Devendra Naga wrote:
>> rtc_valid_tm is always return
>> -EINVAL if the time doesn't represent a valid date and time and 0 if its.
>>
>> so we can simply do rtc_valid_tm(tm) rather doing rtc_valid_tm(tm) != 0 checking.
>> and also tm2bcd() does return -EINVAL if the time doesn't represent a valid date and time
>> and 0 if its.
>>
>> and also removing err because is_write_complete will return -EIO if our write to the
>> RTC registers didn't happen and 0 if its.
>>
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>> ---
>>
>> This is only tested by compiling the code with arm-linux-gcc
>>
>> /bin/arm-linux-gnueabihf-gcc --version
>>
>> arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-2012.05-20120523 - Linaro GCC 2012.05) 4.7.1 20120514 (prerelease)
>>
>>  drivers/rtc/rtc-spear.c |   13 +++++--------
>>  1 file changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
>> index e278547..eb7d399 100644
>> --- a/drivers/rtc/rtc-spear.c
>> +++ b/drivers/rtc/rtc-spear.c
>> @@ -172,7 +172,7 @@ static irqreturn_t spear_rtc_irq(int irq, void *dev_id)
>>
>>  static int tm2bcd(struct rtc_time *tm)
>>  {
>> -     if (rtc_valid_tm(tm) != 0)
>> +     if (rtc_valid_tm(tm))
>>               return -EINVAL;
>
> The name of this routine conflicts with its behavior (In my opinion :) )
> rtc_valid_tm() should have returned
> - false or true
> OR
> less than zero (invalid) or greater than zero (valid)
>
> Probably second one is opted for it. so, it would make more sense to have something like
>
> if (rtc_valid_tm() < 0)
>        return -EINVAL;
>
> instead of what you went for. Because that looked incorrect to me from readability point of view.
> i.e. if rtc_valid_tm, that's an error. What do you say?
>
You are right. having rtc_valid_tm() < 0 makes sense.
>>       tm->tm_sec = bin2bcd(tm->tm_sec);
>>       tm->tm_min = bin2bcd(tm->tm_min);
>> @@ -235,9 +235,9 @@ static int spear_rtc_read_time(struct device *dev, struct rtc_time *tm)
>>  static int spear_rtc_set_time(struct device *dev, struct rtc_time *tm)
>>  {
>>       struct spear_rtc_config *config = dev_get_drvdata(dev);
>> -     unsigned int time, date, err = 0;
>> +     unsigned int time, date;
>>
>> -     if (tm2bcd(tm) < 0)
>> +     if (tm2bcd(tm))
>>               return -EINVAL;
>
> Same applied here.
>
>>       rtc_wait_not_busy(config);
>> @@ -247,11 +247,8 @@ static int spear_rtc_set_time(struct device *dev, struct rtc_time *tm)
>>               (tm->tm_year << YEAR_SHIFT);
>>       writel(time, config->ioaddr + TIME_REG);
>>       writel(date, config->ioaddr + DATE_REG);
>> -     err = is_write_complete(config);
>> -     if (err < 0)
>> -             return err;
>>
>> -     return 0;
>> +     return is_write_complete(config);
>>  }
>
> This one must have returned true or false, because of nature of its name. So, still checking
> for < 0 is better.
>
right. but the function doesn't do as it expected to return true or
false. anyway, it returns -EIO in fail case and 0 in success.

The original code was easier to read than with the current code.

I think its better to leave this driver with out doing these kinds of changes.
> --
> Viresh
>
Thanks,
Devendra.
> -- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.
>
