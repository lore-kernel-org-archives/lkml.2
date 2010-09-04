Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0IDRM4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 13:12:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55138 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab0IDRMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 13:12:55 -0400
Message-ID: <4C827E16.9090409@criticallink.com>
Date: Sat, 04 Sep 2010 13:12:54 -0400
From: Michael Williamson <michael.williamson@criticallink.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de
Subject: Re: [PATCH RESEND] tps65023: Allow platforms to specify DCDC_2 and
 DCDC_3 value.
References: <1283616271-6286-1-git-send-email-michael.williamson@criticallink.com> <20100904170116.GA10918@core.coreip.homeip.net>
In-Reply-To: <20100904170116.GA10918@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

On 09/04/2010 01:01 PM, Dmitry Torokhov wrote:
> Hi Michael,
> 
> On Sat, Sep 04, 2010 at 12:04:31PM -0400, Michael Williamson wrote:
>> The TPS65023 regulator includes 5 regulators (3 DCDC and 2 LDO's).
>> 2 of the DCDC regulators are of fixed voltage and can only be
>> turned on or off via the I2C interface.  The current driver defaults
>> the values of the fixed DCDC regulators.  However, the actual
>> voltage of these regulators may be set differently for a board (via
>> voltage divider circuit, etc.).
>>
>> This patch allows a platform to pass in the actual voltage used
>> for these DCDC supplies such that they are reported correctly in
>> sysfs.
>>
>> Signed-off-by: Michael Williamson <michael.williamson@criticallink.com>
>> ---
>> Previous submission said 1/3.  Should only be 1/1.
>>
>>  drivers/regulator/tps65023-regulator.c |   17 +++++++++++++----
>>  1 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
>> index cd6d4fc..68cd7d3 100644
>> --- a/drivers/regulator/tps65023-regulator.c
>> +++ b/drivers/regulator/tps65023-regulator.c
>> @@ -124,7 +124,7 @@ struct tps_pmic {
>>  	struct regulator_desc desc[TPS65023_NUM_REGULATOR];
>>  	struct i2c_client *client;
>>  	struct regulator_dev *rdev[TPS65023_NUM_REGULATOR];
>> -	const struct tps_info *info[TPS65023_NUM_REGULATOR];
>> +	struct tps_info *info[TPS65023_NUM_REGULATOR];
>>  	struct mutex io_lock;
>>  };
>>  
>> @@ -462,9 +462,10 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
>>  				     const struct i2c_device_id *id)
>>  {
>>  	static int desc_id;
>> -	const struct tps_info *info = (void *)id->driver_data;
>> +	struct tps_info *info = (void *)id->driver_data;
> 
> id is shared between multiple instances of the device and is constant.
> It is a bad idea to cast away constness and modify the data; you should
> move data that may be adjusted into tps_pmic structure.
> 
> Even if we expect to only a single instance of the device in question we
> should follow best practices.
> 
Yes of course.  Hadn't thought of multiple instances.  I will correct and resubmit.  
Thank you.

>>  	struct regulator_init_data *init_data;
> 
> This should probably be marked const too as it comes from platform code.
> 
>>  	struct regulator_dev *rdev;
>> +	struct regulation_constraints *c;
> 
> const as well?
> 
Right.

>>  	struct tps_pmic *tps;
>>  	int i;
>>  	int error;
>> @@ -501,6 +502,14 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
>>  		tps->desc[i].type = REGULATOR_VOLTAGE;
>>  		tps->desc[i].owner = THIS_MODULE;
>>  
>> +		/* Override default DCDC2/3 values if provided */
>> +		c = &init_data->constraints;
>> +		if ((i == TPS65023_DCDC_2) || (i == TPS65023_DCDC_3)
>> +			&& c->min_uV && c->min_uV == c->max_uV) {
> 
> Min and max are the same? You sure you got the condition right? 
> 
These DCDC regulators are fixed in hardware, they cannot be controlled and should
only have one value (minus hardware tolerance, I suppose).  I thought that such a 
sanity check would be required.  What should the reported value be if a range is 
provided? 

>> +			info->min_uV = c->min_uV;
>> +			info->max_uV = c->max_uV;
>> +		}
>> +
>>  		/* Register the regulators */
>>  		rdev = regulator_register(&tps->desc[i], &client->dev,
>>  					  init_data, tps);
>> @@ -519,7 +528,7 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
>>  
>>  	return 0;
>>  
>> - fail:
>> +fail:
>>  	while (--i >= 0)
>>  		regulator_unregister(tps->rdev[i]);
>>  
>> @@ -546,7 +555,7 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
>>  	return 0;
>>  }
>>  
>> -static const struct tps_info tps65023_regs[] = {
>> +static struct tps_info tps65023_regs[] = {
>>  	{
>>  		.name = "VDCDC1",
>>  		.min_uV =  800000,
>> -- 
>> 1.7.0.4
>>
> 

