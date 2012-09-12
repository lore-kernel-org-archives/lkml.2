Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2ILH7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:59:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61131 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2ILH7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:59:08 -0400
Message-ID: <505040C6.1020501@linaro.org>
Date: Wed, 12 Sep 2012 13:29:02 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-kernel@vger.kernel.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: Re: [PATCH v2] pwm: Fix compilation error when CONFIG_PWM is not
 defined
References: <1347356655-17191-1-git-send-email-tushar.behera@linaro.org> <20120911144814.GB3824@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120911144814.GB3824@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 08:18 PM, Thierry Reding wrote:
> On Tue, Sep 11, 2012 at 03:14:15PM +0530, Tushar Behera wrote:
>> Add dummy implemention of public symbols for compilation-safe inclusion
>> of include/linux/pwm.h file when CONFIG_PWM is not defined.
>>
>> While at it, also reorganize the file.
>>
>> Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>> Changes since v1:
>> * Incorporated Thierry's suggestions regarding adding dummy function
>> implemention for all global functions
>> * Reorganized header file to have structure definitions first and then the
>> function definitions.
>>
>>  include/linux/pwm.h |  135 ++++++++++++++++++++++++++++++++++++--------------
>>  1 files changed, 97 insertions(+), 38 deletions(-)
>>
>> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
>> index 21d076c..f1e685b 100644
>> --- a/include/linux/pwm.h
>> +++ b/include/linux/pwm.h
>> @@ -6,32 +6,6 @@
>>  struct pwm_device;
>>  struct seq_file;
>>  
>> -/*
>> - * pwm_request - request a PWM device
>> - */
>> -struct pwm_device *pwm_request(int pwm_id, const char *label);
>> -
>> -/*
>> - * pwm_free - free a PWM device
>> - */
>> -void pwm_free(struct pwm_device *pwm);
>> -
>> -/*
>> - * pwm_config - change a PWM device configuration
>> - */
>> -int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
>> -
>> -/*
>> - * pwm_enable - start a PWM output toggling
>> - */
>> -int pwm_enable(struct pwm_device *pwm);
>> -
>> -/*
>> - * pwm_disable - stop a PWM output toggling
>> - */
>> -void pwm_disable(struct pwm_device *pwm);
>> -
>> -#ifdef CONFIG_PWM
>>  struct pwm_chip;
>>  
>>  enum {
>> @@ -113,18 +87,6 @@ struct pwm_chip {
>>  	unsigned int		of_pwm_n_cells;
>>  };
>>  
>> -int pwm_set_chip_data(struct pwm_device *pwm, void *data);
>> -void *pwm_get_chip_data(struct pwm_device *pwm);
>> -
>> -int pwmchip_add(struct pwm_chip *chip);
>> -int pwmchip_remove(struct pwm_chip *chip);
>> -struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
>> -					 unsigned int index,
>> -					 const char *label);
>> -
>> -struct pwm_device *pwm_get(struct device *dev, const char *consumer);
>> -void pwm_put(struct pwm_device *pwm);
>> -
>>  struct pwm_lookup {
>>  	struct list_head list;
>>  	const char *provider;
>> @@ -141,8 +103,105 @@ struct pwm_lookup {
>>  		.con_id = _con_id,			\
>>  	}
>>  
>> +#ifdef CONFIG_PWM
>> +/*
>> + * pwm_request - request a PWM device
>> + */
>> +struct pwm_device *pwm_request(int pwm_id, const char *label);
>> +
>> +/*
>> + * pwm_free - free a PWM device
>> + */
>> +void pwm_free(struct pwm_device *pwm);
>> +
>> +/*
>> + * pwm_config - change a PWM device configuration
>> + */
>> +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
>> +
>> +/*
>> + * pwm_enable - start a PWM output toggling
>> + */
>> +int pwm_enable(struct pwm_device *pwm);
>> +
>> +/*
>> + * pwm_disable - stop a PWM output toggling
>> + */
>> +void pwm_disable(struct pwm_device *pwm);
> 
> The legacy functions probably need to be declared unconditionally
> because they are also available if HAVE_PWM is defined. Or rather than
> unconditionally they should probably be protected by something like:
> 
> #if IS_ENABLED(CONFIG_PWM) || IS_ENABLED(CONFIG_HAVE_PWM)
>   ...
> #else
>   dummies go here
> #endif
> 
> In that case it may be worth splitting this into two #if blocks, one for
> the legacy API and one for the new stuff, maybe even keeping the file
> layout to reduce the patch size.
> 

Let me repost this series with two #if blocks as suggested by you.

> Alternatively we could postpone this patch a bit until HAVE_PWM can be
> removed. I've posted patches that convert all remaining legacy
> implementations and except for Unicore32 it looks like we may be able to
> get all of them into 3.7.
> 
> In the meantime you could solve the problem on your end, as I mentioned,
> by selecting PWM from the board's Kconfig. If enough people think this

Yeah, sure.

> needs to be done now I may just be persuaded to accept a patch like this
> and remove the extra check for HAVE_PWM along with HAVE_PWM when that
> happens.
> 
> Thierry
> 


-- 
Tushar Behera
