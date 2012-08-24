Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2HXBXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:23:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50550 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2HXBXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:23:14 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7fc66d0000043b7-e2-5036d78010f4
Message-id: <5036D77D.9040308@samsung.com>
Date: Fri, 24 Aug 2012 10:23:09 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mike Turquette <mturquette@ti.com>,
        Xiaoguang Chen <chenxg@marvell.com>
Subject: Re: [PATCH 1/2] devfreq: Add sysfs node for representing frequency
 transition information.
References: <1345099767-13467-1-git-send-email-jonghwa3.lee@samsung.com>
 <1345099767-13467-2-git-send-email-jonghwa3.lee@samsung.com>
 <201208240021.15115.rjw@sisk.pl>
In-reply-to: <201208240021.15115.rjw@sisk.pl>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jAd2G62YBBtf2yVtc3jWHzeJz7xFG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLWfd7EUrDHuGLytA6WBsY5ml2MnBwSAiYSc49/Z4Ow
	xSQu3FsPZHNxCAksYpRY9WI/M0iCV0BQ4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUf+S
	UWLq8pXsEPVaEu8f3GIEsVkEVCXuvdzCCmKzCchJvG36xggyR1QgQuJXPwdIWASoZMuT/+wg
	c5gFWpkkXrXfZAFJCAukStx8eIQVYsEqRom+Rf+ZQBKcAroSK+b9ZJ/AKDALyX2zEO6bheS+
	BYzMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCQ/GZ1A7GlQ0WhxgFOBiVeHh3tJgFCLEm
	lhVX5h5ilOBgVhLh/TofKMSbklhZlVqUH19UmpNafIhRmoNFSZyXv88wQEggPbEkNTs1tSC1
	CCbLxMEp1cAYJ3JujcP/YzuZGcRCfoq9a+J2mVLqkS2Z+PANV+BBDRbBO61pLZk/H//+KCuU
	m3XtrZLpm4kzWma+DxGc97lrstf2K8JOHyoddwWVpP5fO8X8l/bktrlqLHs2G4rf1zzIbVCa
	mf+WbUp0oSHHKb0Ft+oYwnIcPz6JcJqUV6ozoyQ2fFbK5BdKLMUZiYZazEXFiQDwFmXtQQIA	AA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rafael.

On 2012년 08월 24일 07:21, Rafael J. Wysocki wrote:
> On Thursday, August 16, 2012, Jonghwa Lee wrote:
>> This patch adds sysfs node which can be used to get information of frequency
>> transition. It represents transition table which contains total number of transition of
>> each freqeuncy state and time spent. It is inspired CPUFREQ's status driver.
> First off, please add kerneldoc comments to the new functions.
> It would be good to know what they are intended to do.
Okay, I'll add document for describing what it'll be used to .
> Second, multiline files in sysfs are generally not welcome.  Perhaps this
> should go into debugfs instead?
>
> Rafael
Yes, you're right. I didn't know the sysfs constraints until I checked
debugfs kerneldoc.
I'll update it either.

>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>>  drivers/devfreq/devfreq.c |   89 +++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/devfreq.h   |    9 +++++
>>  2 files changed, 98 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>> index 70c31d4..8b53eaf 100644
>> --- a/drivers/devfreq/devfreq.c
>> +++ b/drivers/devfreq/devfreq.c
>> @@ -72,6 +72,41 @@ static struct devfreq *find_device_devfreq(struct device *dev)
>>  	return ERR_PTR(-ENODEV);
>>  }
>>  
>> +int devfreq_get_freq_level(struct devfreq *devfreq, unsigned long freq)
>> +{
>> +	int lev;
>> +
>> +	for (lev = 0; lev < devfreq->profile->max_state; lev++)
>> +		if (freq == devfreq->profile->freq_table[lev])
>> +			return lev;
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +int devfreq_update_status(struct devfreq *devfreq, unsigned long freq)
>> +{
>> +	int lev, prev_lev;
>> +	unsigned long cur_time;
>> +
>> +	lev = devfreq_get_freq_level(devfreq, freq);
>> +	if (lev < 0)
>> +		return lev;
>> +
>> +	cur_time = jiffies;
>> +	devfreq->time_in_state[lev] +=
>> +			 cur_time - devfreq->last_stat_updated;
>> +	if (freq != devfreq->previous_freq) {
>> +		prev_lev = devfreq_get_freq_level(devfreq,
>> +						devfreq->previous_freq);
>> +		devfreq->trans_table[(prev_lev *
>> +				devfreq->profile->max_state) + lev]++;
>> +		devfreq->total_trans++;
>> +	}
>> +	devfreq->last_stat_updated = cur_time;
>> +
>> +	return 0;
>> +}
>> +
>>  /**
>>   * update_devfreq() - Reevaluate the device and configure frequency.
>>   * @devfreq:	the devfreq instance.
>> @@ -115,6 +150,10 @@ int update_devfreq(struct devfreq *devfreq)
>>  	err = devfreq->profile->target(devfreq->dev.parent, &freq, flags);
>>  	if (err)
>>  		return err;
>> +	if (devfreq->profile->freq_table)
>> +		if (devfreq_update_status(devfreq, freq))
>> +			dev_err(&devfreq->dev,
>> +				"Couldn't update frequency transition information.\n");
>>  
>>  	devfreq->previous_freq = freq;
>>  	return err;
>> @@ -390,6 +429,15 @@ struct devfreq *devfreq_add_device(struct device *dev,
>>  			      = msecs_to_jiffies(devfreq->profile->polling_ms);
>>  	devfreq->nb.notifier_call = devfreq_notifier_call;
>>  
>> +	devfreq->trans_table =	devm_kzalloc(dev, sizeof(unsigned int) *
>> +						devfreq->profile->max_state *
>> +						devfreq->profile->max_state,
>> +						GFP_KERNEL);
>> +	devfreq->time_in_state = devm_kzalloc(dev, sizeof(unsigned int) *
>> +						devfreq->profile->max_state,
>> +						GFP_KERNEL);
>> +	devfreq->last_stat_updated = jiffies;
>> +
>>  	dev_set_name(&devfreq->dev, dev_name(dev));
>>  	err = device_register(&devfreq->dev);
>>  	if (err) {
>> @@ -587,6 +635,46 @@ static ssize_t show_max_freq(struct device *dev, struct device_attribute *attr,
>>  	return sprintf(buf, "%lu\n", to_devfreq(dev)->max_freq);
>>  }
>>  
>> +static ssize_t show_trans_table(struct device *dev, struct device_attribute *attr,
>> +				char *buf)
>> +{
>> +	struct devfreq *devfreq = to_devfreq(dev);
>> +	ssize_t len;
>> +	int i, j, err;
>> +
>> +	err = devfreq_update_status(devfreq, devfreq->previous_freq);
>> +	if (err)
>> +		return 0;
>> +
>> +	len = sprintf(buf, "   From  :   To\n");
>> +	len += sprintf(buf + len, "         :");
>> +	for (i = 0; i < devfreq->profile->max_state; i++)
>> +		len += sprintf(buf + len, "%8u",
>> +				devfreq->profile->freq_table[i]);
>> +
>> +	len += sprintf(buf + len, "   time(ms)\n");
>> +
>> +	for (i = 0; i < devfreq->profile->max_state; i++) {
>> +		if (devfreq->profile->freq_table[i]
>> +					== devfreq->previous_freq) {
>> +			len += sprintf(buf + len, "*");
>> +		} else {
>> +			len += sprintf(buf + len, " ");
>> +		}
>> +		len += sprintf(buf + len, "%8u:",
>> +				devfreq->profile->freq_table[i]);
>> +		for (j = 0; j < devfreq->profile->max_state; j++)
>> +			len += sprintf(buf + len, "%8u",
>> +					devfreq->trans_table[(i * 3) + j]);
>> +		len += sprintf(buf + len, "%10u\n",
>> +			jiffies_to_msecs(devfreq->time_in_state[i]));
>> +	}
>> +
>> +	len += sprintf(buf + len, "Total transition : %u\n",
>> +					devfreq->total_trans);
>> +	return len;
>> +}
>> +
>>  static struct device_attribute devfreq_attrs[] = {
>>  	__ATTR(governor, S_IRUGO, show_governor, NULL),
>>  	__ATTR(cur_freq, S_IRUGO, show_freq, NULL),
>> @@ -595,6 +683,7 @@ static struct device_attribute devfreq_attrs[] = {
>>  	       store_polling_interval),
>>  	__ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
>>  	__ATTR(max_freq, S_IRUGO | S_IWUSR, show_max_freq, store_max_freq),
>> +	__ATTR(trans_stat, S_IRUGO, show_trans_table, NULL),
>>  	{ },
>>  };
>>  
>> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
>> index 281c72a..30dc0d8 100644
>> --- a/include/linux/devfreq.h
>> +++ b/include/linux/devfreq.h
>> @@ -80,6 +80,9 @@ struct devfreq_dev_profile {
>>  	int (*get_dev_status)(struct device *dev,
>>  			      struct devfreq_dev_status *stat);
>>  	void (*exit)(struct device *dev);
>> +
>> +	unsigned int *freq_table;
>> +	unsigned int max_state;
>>  };
>>  
>>  /**
>> @@ -164,6 +167,12 @@ struct devfreq {
>>  
>>  	unsigned long min_freq;
>>  	unsigned long max_freq;
>> +
>> +	/* information for device freqeuncy transition */
>> +	unsigned int total_trans;
>> +	unsigned int *trans_table;
>> +	unsigned long *time_in_state;
>> +	unsigned long last_stat_updated;
>>  };
>>  
>>  #if defined(CONFIG_PM_DEVFREQ)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

