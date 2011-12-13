Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1LMJuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:50:11 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:46915
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750873Ab1LMJuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:50:08 -0500
Message-ID: <4EE71FCA.8040000@compulab.co.il>
Date: Tue, 13 Dec 2011 11:50:02 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Igor Grinberg <grinberg@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: TWL: add power off functionality
References: <1321177790-5886-1-git-send-email-grinberg@compulab.co.il> <4ED205F9.3070908@compulab.co.il>
In-Reply-To: <4ED205F9.3070908@compulab.co.il>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel,

Can we get this one into 3.3?

Thanks

On 11/27/11 11:42, Igor Grinberg wrote:
> ping!
> 
> 
> On 11/13/11 11:49, Igor Grinberg wrote:
>> TWL family of PMICs, used in master mode, have a power off
>> functionality. The resulting power off sequence shuts down all the SoC
>> supplies, LDOs, etc. The sequence is described in the datasheets
>> chapter "Power-Off Sequence".
>> Note, that board must be wired correctly for the power off to work as
>> expected.
>>
>> Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
>> ---
>>  drivers/mfd/twl4030-power.c |   42 ++++++++++++++++++++++++++++++++++++++++--
>>  include/linux/i2c/twl.h     |    2 ++
>>  2 files changed, 42 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
>> index a764676..d905f51 100644
>> --- a/drivers/mfd/twl4030-power.c
>> +++ b/drivers/mfd/twl4030-power.c
>> @@ -34,7 +34,8 @@
>>  static u8 twl4030_start_script_address = 0x2b;
>>  
>>  #define PWR_P1_SW_EVENTS	0x10
>> -#define PWR_DEVOFF	(1<<0)
>> +#define PWR_DEVOFF		(1 << 0)
>> +#define SEQ_OFFSYNC		(1 << 0)
>>  
>>  #define PHY_TO_OFF_PM_MASTER(p)		(p - 0x36)
>>  #define PHY_TO_OFF_PM_RECEIVER(p)	(p - 0x5b)
>> @@ -511,12 +512,27 @@ int twl4030_remove_script(u8 flags)
>>  	return err;
>>  }
>>  
>> +/*
>> + * In master mode, start the power off sequence.
>> + * After a successful execution, TWL shuts down the power to the SoC
>> + * and all peripherals connected to it.
>> + */
>> +void twl4030_power_off(void)
>> +{
>> +	int err;
>> +
>> +	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, PWR_DEVOFF,
>> +			       TWL4030_PM_MASTER_P1_SW_EVENTS);
>> +	if (err)
>> +		pr_err("TWL4030 Unable to power off\n");
>> +}
>> +
>>  void __init twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
>>  {
>>  	int err = 0;
>>  	int i;
>>  	struct twl4030_resconfig *resconfig;
>> -	u8 address = twl4030_start_script_address;
>> +	u8 val, address = twl4030_start_script_address;
>>  
>>  	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER,
>>  			TWL4030_PM_MASTER_KEY_CFG1,
>> @@ -548,6 +564,28 @@ void __init twl4030_power_init(struct twl4030_power_data *twl4030_scripts)
>>  		}
>>  	}
>>  
>> +	/* Board has to be wired properly to use this feature */
>> +	if (twl4030_scripts->use_poweroff && !pm_power_off) {
>> +		/* Default for SEQ_OFFSYNC is set, lets ensure this */
>> +		err = twl_i2c_read_u8(TWL4030_MODULE_PM_MASTER, &val,
>> +				      TWL4030_PM_MASTER_CFG_P123_TRANSITION);
>> +		if (err) {
>> +			pr_warning("TWL4030 Unable to read registers\n");
>> +
>> +		} else if (!(val & SEQ_OFFSYNC)) {
>> +			val |= SEQ_OFFSYNC;
>> +			err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, val,
>> +					TWL4030_PM_MASTER_CFG_P123_TRANSITION);
>> +			if (err) {
>> +				pr_err("TWL4030 Unable to setup SEQ_OFFSYNC\n");
>> +				goto relock;
>> +			}
>> +		}
>> +
>> +		pm_power_off = twl4030_power_off;
>> +	}
>> +
>> +relock:
>>  	err = twl_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0,
>>  			TWL4030_PM_MASTER_PROTECT_KEY);
>>  	if (err)
>> diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
>> index 114c0f6..78d3465 100644
>> --- a/include/linux/i2c/twl.h
>> +++ b/include/linux/i2c/twl.h
>> @@ -652,10 +652,12 @@ struct twl4030_power_data {
>>  	unsigned num;
>>  	struct twl4030_resconfig *resource_config;
>>  #define TWL4030_RESCONFIG_UNDEF	((u8)-1)
>> +	bool use_poweroff;	/* Board is wired for TWL poweroff */
>>  };
>>  
>>  extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
>>  extern int twl4030_remove_script(u8 flags);
>> +extern void twl4030_power_off(void);
>>  
>>  struct twl4030_codec_data {
>>  	unsigned int digimic_delay; /* in ms */
> 

-- 
Regards,
Igor.
