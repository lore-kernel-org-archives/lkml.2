Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0I1Iws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:52:48 -0400
Received: from smtp.nokia.com ([192.100.122.230]:34376 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab0I1Iwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:52:46 -0400
Message-ID: <4CA1ACC3.4000809@nokia.com>
Date: Tue, 28 Sep 2010 12:52:19 +0400
From: Yuri Kululin <ext-yuri.kululin@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: ext Guenter Roeck <guenter.roeck@ericsson.com>
CC: Yuri Ershov <ext-yuri.ershov@nokia.com>, eric.piel@tremplin-utc.net,
        samu.p.onkalo@nokia.com, akpm@linux-foundation.org, daniel@caiaq.de,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [1/2] lis3: Add device owner
References: <ee6b20c71d49b8438ced798a9e561dbbd2991cf6.1282647258.git.ext-yuri.kululin@nokia.com> <20100924202404.GA20813@ericsson.com>
In-Reply-To: <20100924202404.GA20813@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Sep 2010 08:51:52.0422 (UTC) FILETIME=[653FA860:01CB5EEA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Guenter Roeck wrote:
> On Fri, Aug 27, 2010 at 02:33:20PM -0000, Yuri Ershov wrote:
>> Add device owner and change /dev/freefall file operations owner
>> according to the used driver
>>
>> Signed-off-by: Yuri Kululin <ext-yuri.kululin@nokia.com>
>>
>> ---
>> drivers/hwmon/lis3lv02d.c |    8 ++++++--
>>  drivers/hwmon/lis3lv02d.h |    2 ++
>>  2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
>> index e278f0e..0f1bd36 100644
>> --- a/drivers/hwmon/lis3lv02d.c
>> +++ b/drivers/hwmon/lis3lv02d.c
>> @@ -591,8 +591,7 @@ static int lis3lv02d_misc_fasync(int fd, struct file *file, int on)
>>  	return fasync_helper(fd, file, on, &lis3_dev.async_queue);
>>  }
>>  
>> -static const struct file_operations lis3lv02d_misc_fops = {
>> -	.owner   = THIS_MODULE,
>> +static struct file_operations lis3lv02d_misc_fops = {
>>  	.llseek  = no_llseek,
>>  	.read    = lis3lv02d_misc_read,
>>  	.open    = lis3lv02d_misc_open,
>> @@ -1007,6 +1006,11 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
>>  		goto out;
>>  	}
>>  
>> +	if (dev->owner)
>> +		lis3lv02d_misc_fops.owner = dev->owner;
>> +	else
>> +		lis3lv02d_misc_fops.owner = THIS_MODULE;
>> +
> If you retained the static assignment to .owner above, you would not need
> the else part here.

Yes, you are right. I can change this.

> Also, this depends on patch#2, which actually sets dev->owner.
> So the problem isn't really addressed w/o patch #2. Given that,
> I am not sure if it makes sense to have two separate patches.

Ok, I can merge my patches.

> If both patches were applied as one, you might not need the if ()
> above in the first place. And if you do, you might still not have solved
> the problem completely since .owner would not be set correctly
> if dev->owner is NULL. 

I've added "if" here to keep the situation "as is" for all other drivers
(HP driver - hp_accel.c and spi part - lis3lv02d_spi.c. I don't have the HW to 
test) which are using the lis3 core. If we want to avoid the issues with 
unloading completely all parts should set the dev->owner. Not a problem to add 
this to HP driver and lis3lv02d_spi.c.

> On a higher level, reassigning the owner like this seems to be quite uncommon,
> at least in hwmon. I would like to see an Acked-by from Eric to ensure
> that the fix is correct.

I tried to use the standard way of module usage control because all functions 
provided by lis3lv02d_i2c.c, lis3lv02d_spi.c or hp_accel.c can be called through 
  lis3lv02d_misc_fops file ops or joystick poll device.

I can propose another solution. We can use try_module_get(owner) during device 
registration (in lis3lv02d_add_fs()), release module by using module_put(owner) 
  after device unregister (in lis3lv02d_remove_fs()) and do not touch 
lis3lv02d_misc_fops. But anyway dev->owner should be set.

Thanks a lot for reviewing,
Yuri K
> 
> Thanks,
> Guenter

