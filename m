Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2CNLyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:54:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41759 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629Ab2CNLyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:54:10 -0400
X-AuditID: cbfee61b-b7c62ae000000989-2c-4f6086e04ea7
Message-id: <4F6086E3.2060906@samsung.com>
Date: Wed, 14 Mar 2012 20:54:11 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [PATCH v3 2/2] input: add driver support for MAX8997-haptic
References: <4F5DB459.9090701@samsung.com>
 <20120314084652.GC3964@core.coreip.homeip.net>
In-reply-to: <20120314084652.GC3964@core.coreip.homeip.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2012 05:46 PM, Dmitry Torokhov wrote:
> Hi Chanwoo,
> 
> On Mon, Mar 12, 2012 at 05:31:21PM +0900, Chanwoo Choi wrote:
>> +
>> +static int __devexit max8997_haptic_remove(struct platform_device *pdev)
>> +{
>> +	struct max8997_haptic *chip = platform_get_drvdata(pdev);
>> +
>> +	destroy_work_on_stack(&chip->work);
> 
> This does not make sense because:
> 
> - chip->work is not on stack
> - even if you "destroy" work nothing stops play effect to schedule a new
>   one - you need to cancel work in close method.
> 
Agreed, I will fix it.

>> +	input_unregister_device(chip->input_dev);
>> +	regulator_put(chip->regulator);
>> +
>> +	if (chip->mode == MAX8997_EXTERNAL_MODE)
>> +		pwm_free(chip->pwm);
>> +
>> +	kfree(chip);
>> +
>> +	return 0;
>> +}
>> +
>> +static int max8997_haptic_suspend(struct device *dev)
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct max8997_haptic *chip = platform_get_drvdata(pdev);
>> +	struct input_dev *input_dev = chip->input_dev;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&input_dev->event_lock, flags);
>> +	max8997_haptic_enable(chip, false);
>> +	spin_unlock_irqrestore(&input_dev->event_lock, flags);
>> +
> 
> This is not proper locking between playing effect and suspend. Now that
> you are using workqueue you need to synchronize access with it, not with
> play_effect method.
> 
> Does the following patch work for you?
You're right. As you said, I face with the kernel panic when enter
suspend state
while testing max8997-haptic by using fftest at once.

Previously, I  tested for each operation of max8997-haptic and
suspend/resume.
I will fix it according to your comment.

Thank you for your comment.

Best Regards,
Chanwoo Choi
