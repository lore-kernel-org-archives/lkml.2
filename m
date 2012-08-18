Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2HRNIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 09:08:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4565 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab2HRNIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 09:08:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 18 Aug 2012 06:08:19 -0700
Message-ID: <502F8F83.5030902@nvidia.com>
Date: Sat, 18 Aug 2012 18:20:11 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "olof@lixom.net" <olof@lixom.net>
Subject: Re: [PATCH REBASE 1/2] i2c: tegra: I2_M_NOSTART functionality not
 supported in Tegra20
References: <1345230155-4252-1-git-send-email-ldewangan@nvidia.com> <20120818124703.GC12839@pengutronix.de>
In-Reply-To: <20120818124703.GC12839@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for review.

On Saturday 18 August 2012 06:17 PM, Wolfram Sang wrote:
> * PGP Signed by an unknown key
>
> On Sat, Aug 18, 2012 at 12:32:34AM +0530, Laxman Dewangan wrote:
>> +	bool has_continue_xfer_support;
> I wonder if it makes sense to carry a pointer here to the
> tegra_i2c_hw_feature in use instead of copying all entries by hand,
> since they might get more and more.
>

Ok, we can store the hw pointer in device structure. I will send the new 
patch.

>>   };
>>
>>   static void dvc_writel(struct tegra_i2c_dev *i2c_dev, u32 val, unsigned long reg)
>> @@ -563,7 +574,17 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
>>   	if (i2c_dev->is_suspended)
>>   		return -EBUSY;
>>
>> -	clk_prepare_enable(i2c_dev->div_clk);
>> +	/* Support I2C_M_NOSTART only if HW support continue xfer. */
>> +	for (i = 0; i<  num - 1; i++) {
>> +		if ((msgs[i + 1].flags&  I2C_M_NOSTART)&&
>> +			!i2c_dev->has_continue_xfer_support) {
>> +			dev_err(i2c_dev->dev,
>> +				"mesg %d have illegal flag\n", i + 1);
>> +			return -EINVAL;
>> +		}
>> +	}
> Drivers are requested to explicitly check for features of the I2C bus
> (like M_NOSTART) before using them, so I'd skip this extra check.
>

Ok, I kept this as part of flag checking so illegal flag should not be 
passed. I will remove this on next version patch.

>> +
>> +	clk_prepare_enable(i2c_dev->clk);
>  From a glimpse, this change looks unrelated at least. Even wrong, no?
>

It was already there, just before above check. Due to insertion of 
check, this code shifted, otherwise it is not a new code.

