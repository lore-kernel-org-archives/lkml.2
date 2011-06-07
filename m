Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab1FGD4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 23:56:37 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:35379 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993Ab1FGD4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 23:56:36 -0400
Message-ID: <4DEDA12D.6080406@st.com>
Date: Tue, 7 Jun 2011 09:25:25 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 1/3] drivers/pwm st_pwm: Add support for ST's Pulse
 Width Modulator
References: <cover.1306831238.git.viresh.kumar@st.com>	<af3d50b271b17e404d236e19196adfd4618e2501.1306831238.git.viresh.kumar@st.com> <20110606173339.268b9f9c.akpm@linux-foundation.org>
In-Reply-To: <20110606173339.268b9f9c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 06:03 AM, Andrew Morton wrote:
> On Tue, 31 May 2011 14:21:51 +0530
> Viresh Kumar <viresh.kumar@st.com> wrote:

>> + * lock: lock specific to a pwm device
> 
> More specificity here would be helpful.  Precisely which data does the
> lock protect?
> 

>> + * lock: lock specific to current pwm ip
> 
> Ditto.
> 

Ok.

>> +int pwm_config(struct pwm_device *pwmd, int duty_ns, int period_ns)
>> +{
>> +	u64 val, div, clk_rate;
>> +	unsigned long prescale = MIN_PRESCALE, pv, dc;
>> +	int ret = 0;
>> +
>> +	if (!pwmd) {
>> +		pr_err("pwm: config - NULL pwm device pointer\n");
>> +		return -EFAULT;
>> +	}
>> +
>> +	if (period_ns == 0 || duty_ns > period_ns) {
>> +		ret = -EINVAL;
>> +		goto err;
>> +	}
>> +
>> +	/* TODO: Need to optimize this loop */
>> +	while (1) {
>> +		div = 1000000000;
>> +		div *= 1 + prescale;
>> +		clk_rate = clk_get_rate(pwmd->pwm->clk);
>> +		val = clk_rate * period_ns;
>> +		pv = div64_u64(val, div);
>> +		val = clk_rate * duty_ns;
>> +		dc = div64_u64(val, div);
>> +
>> +		if ((pv == 0) || (dc == 0)) {
>> +			ret = -EINVAL;
>> +			goto err;
>> +		}
>> +		if ((pv > MAX_PERIOD) || (dc > MAX_DUTY)) {
>> +			prescale++;
>> +			if (prescale > MAX_PRESCALE) {
>> +				ret = -EINVAL;
>> +				goto err;
>> +			}
>> +			continue;
>> +		}
>> +		if ((pv < MIN_PERIOD) || (dc < MIN_DUTY)) {
>> +			ret = -EINVAL;
>> +			goto err;
>> +		}
>> +		break;
>> +	}
> 
> gee, is this some sort of puzzle?  So human-readable description of
> what this code is doing would be an improvement.
> 

Sure. Will add that.

>> +	spin_lock(&pwmd->pwm->lock);
>> +	ret = clk_enable(pwmd->pwm->clk);
>> +	if (ret) {
>> +		spin_unlock(&pwmd->pwm->lock);
>> +		goto err;
>> +	}
>> +
>> +	spin_lock(&pwmd->lock);
>> +	writel(prescale << PRESCALE_SHIFT, pwmd->pwm->mmio_base +
>> +			pwmd->offset + PWMCR);
>> +	writel(dc, pwmd->pwm->mmio_base + pwmd->offset + PWMDCR);
>> +	writel(pv, pwmd->pwm->mmio_base + pwmd->offset + PWMPCR);
>> +	spin_unlock(&pwmd->lock);
>> +	clk_disable(pwmd->pwm->clk);
>> +	spin_unlock(&pwmd->pwm->lock);
> 
> The nesting rules for these two locks seems sensible and obvious, but I
> guess documenting the rule wouldn't hurt.
> 

Ok.

>> +	return 0;
>> +err:
>> +	dev_err(&pwmd->pwm->pdev->dev, "pwm config fail\n");
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(pwm_config);
>> +
>>
>> ...
>>
>> +static int __devinit st_pwm_probe(struct platform_device *pdev)
> 
> And here things get rather odd.
> 
> Most of this file is a generic, non-device specific PWM layer, exported
> to other modules.  But then we get into driver bits which are specific
> to one paritular type of device.  Confused - this is like putting the
> e100 driver inside net/ipv4/tcp.c?
> 

Sorry but i couldn't get this one completely. :(
Driver is specific to pwm peripheral by ST. This driver can be used for
SPEAr or may be other SoC or Devices, and is not at all dependent on SPEAr.

-- 
viresh
