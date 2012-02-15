Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2BOKo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 05:44:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64484 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2BOKo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 05:44:28 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <201202142311.41483.rjw@sisk.pl>
References: <1329186372-2376-1-git-send-email-myungjoo.ham@samsung.com>
	<201202142311.41483.rjw@sisk.pl>
Date: Wed, 15 Feb 2012 19:44:26 +0900
X-Google-Sender-Auth: Z2KEtAPrjzU57LkX7QUdd4BVjPs
Message-ID: <CAJ0PZbSODSJvV-_Gje9Hm9Ek22Z9m+PAcsf071OCmAOtsnKzyg@mail.gmail.com>
Subject: Re: [RFC PATCH] PM / QoS: Introduce new classes: DMA-Throughput and DVFS-Latency
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
> Hi,
>
> On Tuesday, February 14, 2012, MyungJoo Ham wrote:
>> 1. CPU_DMA_THROUGHPUT
>> 2. DVFS_LATENCY
> Who's going to use the new classes?
>
> Rafael
>

Hello,

1. CPU_DMA_THROUGHPUT:
QoS-request handler: bus/memory devfreq driver.
QoS-requester: multimedia block device drivers (MFC decoder, MFC
endoder, TV-out, Camera, ...)

2. DVFS_LATENCY:
QoS-request handler: devfreq framework and cpufreq governors
(ondemand/conservative).
QoS-requester: those who need faster DVFS reactions temporarily as
mentioned in the thread of pm_qos_update_request_timeout().


Cheers!
MyungJoo.

>
>> ---
>>  include/linux/pm_qos.h |    6 +++++-
>>  kernel/power/qos.c     |   31 ++++++++++++++++++++++++++++++-
>>  2 files changed, 35 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
>> index e5bbcba..f8ccb7b 100644
>> --- a/include/linux/pm_qos.h
>> +++ b/include/linux/pm_qos.h
>> @@ -13,13 +13,17 @@
>>  #define PM_QOS_CPU_DMA_LATENCY 1
>>  #define PM_QOS_NETWORK_LATENCY 2
>>  #define PM_QOS_NETWORK_THROUGHPUT 3
>> +#define PM_QOS_CPU_DMA_THROUGHPUT 4
>> +#define PM_QOS_DVFS_RESPONSE_LATENCY 5
>>
>> -#define PM_QOS_NUM_CLASSES 4
>> +#define PM_QOS_NUM_CLASSES 6
>>  #define PM_QOS_DEFAULT_VALUE -1
>>
>>  #define PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE     (2000 * USEC_PER_SEC)
>>  #define PM_QOS_NETWORK_LAT_DEFAULT_VALUE     (2000 * USEC_PER_SEC)
>>  #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE      0
>> +#define PM_QOS_CPU_DMA_THROUGHPUT_DEFAULT_VALUE      0
>> +#define PM_QOS_DVFS_LAT_DEFAULT_VALUE        (2000 * USEC_PER_SEC)
>>  #define PM_QOS_DEV_LAT_DEFAULT_VALUE         0
>>
>>  struct pm_qos_request {
>> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
>> index 995e3bd..b15e0b7 100644
>> --- a/kernel/power/qos.c
>> +++ b/kernel/power/qos.c
>> @@ -101,11 +101,40 @@ static struct pm_qos_object network_throughput_pm_qos = {
>>  };
>>
>>
>> +static BLOCKING_NOTIFIER_HEAD(cpu_dma_throughput_notifier);
>> +static struct pm_qos_constraints cpu_dma_tput_constraints = {
>> +     .list = PLIST_HEAD_INIT(cpu_dma_tput_constraints.list),
>> +     .target_value = PM_QOS_CPU_DMA_THROUGHPUT_DEFAULT_VALUE,
>> +     .default_value = PM_QOS_CPU_DMA_THROUGHPUT_DEFAULT_VALUE,
>> +     .type = PM_QOS_MAX,
>> +     .notifiers = &cpu_dma_throughput_notifier,
>> +};
>> +static struct pm_qos_object cpu_dma_throughput_pm_qos = {
>> +     .constraints = &cpu_dma_tput_constraints,
>> +     .name = "cpu_dma_throughput",
>> +};
>> +
>> +
>> +static BLOCKING_NOTIFIER_HEAD(dvfs_lat_notifier);
>> +static struct pm_qos_constraints dvfs_lat_constraints = {
>> +     .list = PLIST_HEAD_INIT(dvfs_lat_constraints.list),
>> +     .target_value = PM_QOS_DVFS_LAT_DEFAULT_VALUE,
>> +     .default_value = PM_QOS_DVFS_LAT_DEFAULT_VALUE,
>> +     .type = PM_QOS_MIN,
>> +     .notifiers = &dvfs_lat_notifier,
>> +};
>> +static struct pm_qos_object dvfs_lat_pm_qos = {
>> +     .constraints = &dvfs_lat_constraints,
>> +     .name = "dvfs_latency",
>> +};
>> +
>>  static struct pm_qos_object *pm_qos_array[] = {
>>       &null_pm_qos,
>>       &cpu_dma_pm_qos,
>>       &network_lat_pm_qos,
>> -     &network_throughput_pm_qos
>> +     &network_throughput_pm_qos,
>> +     &cpu_dma_throughput_pm_qos,
>> +     &dvfs_lat_pm_qos,
>>  };
>>
>>  static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>>
>



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
