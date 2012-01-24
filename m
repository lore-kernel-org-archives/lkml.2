Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2AXMUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:20:31 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16503 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2AXMU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:20:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 Jan 2012 04:20:26 -0800
Message-ID: <4F1EA1E8.90104@nvidia.com>
Date: Tue, 24 Jan 2012 17:49:52 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>, "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regulator: tps65910: Sleep control through external
 inputs
References: <1327395919-32378-1-git-send-email-ldewangan@nvidia.com> <20120124115855.GC14888@opensource.wolfsonmicro.com>
In-Reply-To: <20120124115855.GC14888@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much for review.

On Tuesday 24 January 2012 05:28 PM, Mark Brown wrote:
> On Tue, Jan 24, 2012 at 02:35:19PM +0530, Laxman Dewangan wrote:
>
>> +	/*
>> +	 * Rail can not be control from all external input EN1, EN2 and EN3
>> +	 * together.
>> +	 */
>> +	if ((ext_sleep_config&  EXT_SLEEP_CONTROL) == EXT_SLEEP_CONTROL) {
>> +		dev_err(mfd->dev, "External sleep control flag is not "
>> +					" not proper\n");
>> +		return -EINVAL;
>> +	}
> Don't split log messages over multiple lines, it makes grepping the logs
> harder.  Also, are combinations of two external enables valid?
>
OK, I will make the log message as single liner.
Combination of two external enables are also invalid. Need to check 
differently.
probably by:
int en_count = 0;
en_count += ((ext_sleep_config & TPS65910_SLEEP_CONTROL_EXT_INPUT_EN1) 
== 0);
en_count += ((ext_sleep_config & TPS65910_SLEEP_CONTROL_EXT_INPUT_EN2) 
== 0);
en_count += ((ext_sleep_config & TPS65910_SLEEP_CONTROL_EXT_INPUT_EN3) 
== 0);
if (en_count > 1)
     return -EINVAL.

>> +static void tps65910_shutdown(struct platform_device *pdev)
>> +{
>> +	struct tps65910_reg *pmic = platform_get_drvdata(pdev);
>> +	int i;
>> +	int err;
>> +	dev_err(&pdev->dev, "%s() is called\n", __func__);
>> +
>> +	/* Remove all external control before shutting down the device */
>> +	for (i = 0; i<  pmic->num_regulators; i++) {
>> +		if (!pmic->rdev[i])
>> +			continue;
>> +
>> +		err = tps65910_set_ext_sleep_config(pmic, i, 0);
>> +		if (err<  0)
>> +			dev_err(&pdev->dev, "Error in clearing external "
>> +				"control\n");
>> +	}
> Why?
The external controls for different rails are managed by power manament 
driver of soc in kernel to toggel them. The bootloader make sure that 
all external control signals are active just before jumping into kernel 
so that there is no issue during regulator init.
When system reboots in kernel by kernel command, the configuration of 
the pmu still maintain as what it was in kernel before reboot and issue  
system reboots. There is possibility that the default (POR) of these 
control signals are not active on soc reset or initial stage of the 
bootloader and hence it can turn off the rails which can avoid system 
booting.
So kernel need to remove all external controls before reboot system.

>> +/*
>> + * Regulator mode when rail is in sleep state which controlled by external
>> + * input. The regultor will be OFF if it is in sleep state by default but
>> + * can be set in LOW power mode by ORing following macro with any of
>> + * above exterenl input option.
>> + */
>> +#define TPS65910_SLEEP_CONTROL_REG_LOW_POWER		0x10
> There's the suspend mode API for configuring suspend modes.
>
Hmm.., I thought that  suspend mode apis manages the low/full-on power 
mode when the controls are not through external inputs. There is 
different register for configuring the power mode by i2c- write.
This macro help in configuration of mode when enabled with external 
controls which configures in different sets of register.
>> +
>>   /**
>>    * struct tps65910_board
>>    * Board platform data may be used to initialize regulators.
>> @@ -779,6 +792,7 @@ struct tps65910_board {
>>   	int irq_base;
>>   	int vmbch_threshold;
>>   	int vmbch2_threshold;
>> +	unsigned long regulator_ext_sleep_control[TPS65910_NUM_REGS];
> I can't see anything in this code which will manage the enable signals?
I used this  member in the probe as for configuring the rails..
+        err = tps65910_set_ext_sleep_config(pmic, i,
+                pmic_plat_data->regulator_ext_sleep_control[i]);

> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

