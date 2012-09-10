Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2IJHEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:04:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40834 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab2IJHEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:04:21 -0400
MIME-Version: 1.0
In-Reply-To: <201209100000.25104.rjw@sisk.pl>
References: <1346682578-24312-1-git-send-email-rajagopal.venkat@linaro.org>
	<1346682578-24312-4-git-send-email-rajagopal.venkat@linaro.org>
	<201209100000.25104.rjw@sisk.pl>
Date: Mon, 10 Sep 2012 12:34:20 +0530
Message-ID: <CA+Z25wW4g=J=YdWs63e1EzE1162MF6UxXy0kr-UiLDwhS=e3pQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] devfreq: Add current freq callback in device profile
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mturquette@linaro.org, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2012 03:30, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, September 03, 2012, Rajagopal Venkat wrote:
>> Devfreq returns governor predicted frequency as current
>> frequency via sysfs interface. But device may not support
>> all frequencies that governor predicts.
>
> Do you have any examples, even out of the tree?
The exynos4_bus.c devfreq driver supports five opps. But the ondemand
governor can suggest any frequency between min and max(assuming
policy is set). As per design, governors only need to provide recommended
frequency and the corresponding driver will interpret it correctly.

So, the governor recommended frequency and the frequency at which
device is running could be different. This patch attempts to add new sysfs
node for exposing device current running frequency.
>
>> Its driver
>> responsibility to maintain current frequency at which device
>> is operating. Add a callback in device profile to fix this.
>
> Obviously, there are no users of this callback in the tree right now, so it
> may not be regarded as a fix.  I'd rather say it's a new mechanism for
> drivers to use if their current frequencies differ from the governor-selected
> ones.
Ok. It will be updated in next version.

>
>> Also add a new sysfs node to expose governor predicted next
>> target frequency.
>>
>> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
>> ---
>>  Documentation/ABI/testing/sysfs-class-devfreq |  7 +++++++
>>  drivers/devfreq/devfreq.c                     | 14 ++++++++++++++
>>  include/linux/devfreq.h                       |  3 +++
>>  3 files changed, 24 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
>> index 23d78b5..9df5205 100644
>> --- a/Documentation/ABI/testing/sysfs-class-devfreq
>> +++ b/Documentation/ABI/testing/sysfs-class-devfreq
>> @@ -21,6 +21,13 @@ Description:
>>               The /sys/class/devfreq/.../cur_freq shows the current
>>               frequency of the corresponding devfreq object.
>>
>> +What:                /sys/class/devfreq/.../target_freq
>> +Date:                September 2012
>> +Contact:     MyungJoo Ham <myungjoo.ham@samsung.com>
>
> It's a bit odd to add someone else as a contact for interfaces that you're
> introducing.  I'd need MyungJoo Ham's ACK for that.
>
>> +Description:
>> +             The /sys/class/devfreq/.../target_freq shows the next governor
>> +             predicted target frequency of the corresponding devfreq object.
>> +
>>  What:                /sys/class/devfreq/.../central_polling
>>  Date:                September 2011
>>  Contact:     MyungJoo Ham <myungjoo.ham@samsung.com>
>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>> index 3a5f126..55e9046 100644
>> --- a/drivers/devfreq/devfreq.c
>> +++ b/drivers/devfreq/devfreq.c
>> @@ -400,6 +400,19 @@ static ssize_t show_governor(struct device *dev,
>>  static ssize_t show_freq(struct device *dev,
>>                        struct device_attribute *attr, char *buf)
>>  {
>> +     unsigned long freq;
>> +     struct devfreq *devfreq = to_devfreq(dev);
>> +
>> +     if (devfreq->profile->get_cur_freq)
>> +             if (!devfreq->profile->get_cur_freq(devfreq->dev.parent, &freq))
>
> That should be
>
> +       if (devfreq->profile->get_cur_freq
> +           && !devfreq->profile->get_cur_freq(devfreq->dev.parent, &freq))
Done.

>
>> +                     return sprintf(buf, "%lu\n", freq);
>> +
>
> Moreover, I suppose it should fall back to the current behavior if
> .get_cur_freq() is not present.
Agree. Done.

>
>> +     return sprintf(buf, "<unknown>");
>> +}
>> +
>> +static ssize_t show_target_freq(struct device *dev,
>> +                     struct device_attribute *attr, char *buf)
>> +{
>>       return sprintf(buf, "%lu\n", to_devfreq(dev)->previous_freq);
>>  }
>>
>> @@ -503,6 +516,7 @@ static ssize_t show_max_freq(struct device *dev, struct device_attribute *attr,
>>  static struct device_attribute devfreq_attrs[] = {
>>       __ATTR(governor, S_IRUGO, show_governor, NULL),
>>       __ATTR(cur_freq, S_IRUGO, show_freq, NULL),
>> +     __ATTR(target_freq, S_IRUGO, show_target_freq, NULL),
>>       __ATTR(polling_interval, S_IRUGO | S_IWUSR, show_polling_interval,
>>              store_polling_interval),
>>       __ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
>> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
>> index 7c7e179..d12ed41 100644
>> --- a/include/linux/devfreq.h
>> +++ b/include/linux/devfreq.h
>> @@ -66,6 +66,8 @@ struct devfreq_dev_status {
>>   *                   explained above with "DEVFREQ_FLAG_*" macros.
>>   * @get_dev_status   The device should provide the current performance
>>   *                   status to devfreq, which is used by governors.
>> + * @get_cur_freq     The device should provide the current frequency
>> + *                   at which it is operating.
>>   * @exit             An optional callback that is called when devfreq
>>   *                   is removing the devfreq object due to error or
>>   *                   from devfreq_remove_device() call. If the user
>> @@ -79,6 +81,7 @@ struct devfreq_dev_profile {
>>       int (*target)(struct device *dev, unsigned long *freq, u32 flags);
>>       int (*get_dev_status)(struct device *dev,
>>                             struct devfreq_dev_status *stat);
>> +     int (*get_cur_freq)(struct device *dev, unsigned long *freq);
>>       void (*exit)(struct device *dev);
>>  };
>
> Thanks,
> Rafael



-- 
Regards,
Rajagopal
