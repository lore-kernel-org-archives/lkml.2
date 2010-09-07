Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab0IGOuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:50:12 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:55061 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab0IGOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:50:08 -0400
X-Greylist: delayed 1498 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Sep 2010 10:50:08 EDT
X-Spam-Flag: NO
X-Spam-Score: -24.389
Message-ID: <4C864B3E.5060603@tremplin-utc.net>
Date: Tue, 07 Sep 2010 16:25:02 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100809 Mandriva/3.1.2-3mdv2011.0 (2011.0) Thunderbird/3.1.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3: Add axes module parameter for custom axis-mapping
References: <s5htymla56q.wl%tiwai@suse.de> <s5haanuvypc.wl%tiwai@suse.de>
In-Reply-To: <s5haanuvypc.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-09-10 08:45, Takashi Iwai schreef:
> At Mon, 23 Aug 2010 14:23:25 +0200,
> Takashi Iwai wrote:
>>
>> The axis-mapping of lis3dev device on many (rather most) HP machines
>> doesn't follow the standard.  When each new model appears, users need
>> to adjust again.  Testing this requires the rebuild of kernel, thus
>> it's not trivial for end-users.
>>
>> This patch adds a module parameter "axes" to allow a custom
>> axis-mapping without patching and recompiling the kernel driver.
>> User can pass the parameter such as axes=3,2,1.  Also it can be
>> changed via sysfs.
>>
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> 
> Can anyone review / take this?
> Jean, should it be through hwmon tree? 
Sorry for not answering before, but I'm very busy currently.

I like the idea, but the implementation seems weird. Maybe it's just
that I don't understand well enough module_param_array_named() though.

Each time the user changes the axis parameter, param_set_axis() is
called three times (once per axis), right? Why always calling
copy_to_axis_array() ? Does param_set_int(val, kp) return null only on
the 3rd time? This function really looks like a kludge. Either you need
to put more comments in order to make clear why things work, or rework it.

Wouldn't it be much cleaner if lis3_dev.ac was an array instead of a
struct? I don't mind that it involves changing more line if it makes
things more understandable.

Cheers,
Eric

> 
> 
> thanks,
> 
> Takashi
> 
>> ---
>>  drivers/hwmon/hp_accel.c  |    5 ++++-
>>  drivers/hwmon/lis3lv02d.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 49 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
>> index 7580f55..3462a5d 100644
>> --- a/drivers/hwmon/hp_accel.c
>> +++ b/drivers/hwmon/hp_accel.c
>> @@ -297,7 +297,10 @@ static int lis3lv02d_add(struct acpi_device *device)
>>  	lis3lv02d_enum_resources(device);
>>  
>>  	/* If possible use a "standard" axes order */
>> -	if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
>> +	if (lis3_dev.ac.x && lis3_dev.ac.y && lis3_dev.ac.z) {
>> +		printk(KERN_INFO DRIVER_NAME ": Using custom axes %d,%d,%d\n",
>> +		       lis3_dev.ac.x, lis3_dev.ac.y, lis3_dev.ac.z);
>> +	} else if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
>>  		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
>>  				 "using default axes configuration\n");
>>  		lis3_dev.ac = lis3lv02d_axis_normal;
>> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
>> index 6138f03..4b179d5 100644
>> --- a/drivers/hwmon/lis3lv02d.c
>> +++ b/drivers/hwmon/lis3lv02d.c
>> @@ -75,6 +75,51 @@ struct lis3lv02d lis3_dev = {
>>  
>>  EXPORT_SYMBOL_GPL(lis3_dev);
>>  
>> +static int axis_array[3];
>> +static void copy_to_axis_array(void)
>> +{
>> +	axis_array[0] = lis3_dev.ac.x;
>> +	axis_array[1] = lis3_dev.ac.y;
>> +	axis_array[2] = lis3_dev.ac.z;
>> +}
>> +
>> +static void copy_from_axis_array(void)
>> +{
>> +	lis3_dev.ac.x = axis_array[0];
>> +	lis3_dev.ac.y = axis_array[1];
>> +	lis3_dev.ac.z = axis_array[2];
>> +}
>> +
>> +static int param_set_axis(const char *val, const struct kernel_param *kp)
>> +{
>> +	int ret;
>> +	copy_to_axis_array();
>> +	ret = param_set_int(val, kp);
>> +	if (!ret) {
>> +		int val = *(int *)kp->arg;
>> +		if (val < 0)
>> +			val = -val;
>> +		if (!val || val > 3)
>> +			return -EINVAL;
>> +		copy_from_axis_array();
>> +	}
>> +	return ret;
>> +}
>> +
>> +static int param_get_axis(char *buffer, const struct kernel_param *kp)
>> +{
>> +	copy_to_axis_array();
>> +	return param_get_int(buffer, kp);
>> +}
>> +
>> +static struct kernel_param_ops param_ops_axis = {
>> +	.set = param_set_axis,
>> +	.get = param_get_axis,
>> +};
>> +
>> +module_param_array_named(axes, axis_array, axis, NULL, 0644);
>> +MODULE_PARM_DESC(axes, "Axis-mapping for x,y,z directions");
>> +
>>  static s16 lis3lv02d_read_8(struct lis3lv02d *lis3, int reg)
>>  {
>>  	s8 lo;
