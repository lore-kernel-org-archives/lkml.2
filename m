Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2LEWJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:09:25 -0500
Received: from smtp151.dfw.emailsrvr.com ([67.192.241.151]:52416 "EHLO
	smtp151.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2LEWJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:09:23 -0500
Message-ID: <50BFC628.606@calxeda.com>
Date: Wed, 05 Dec 2012 16:09:44 -0600
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 6/6 v8] cpufreq, highbank: add support for highbank cpufreq
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1354726121-17190-1-git-send-email-mark.langsdorf@calxeda.com> <1354726121-17190-7-git-send-email-mark.langsdorf@calxeda.com> <CAPtuhTg4N7zAMf_Vfw1Xfbn3OmZ7hVffVuc=kMByxf_hJLkpPw@mail.gmail.com>
In-Reply-To: <CAPtuhTg4N7zAMf_Vfw1Xfbn3OmZ7hVffVuc=kMByxf_hJLkpPw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 12:49 PM, Mike Turquette wrote:
> On Wed, Dec 5, 2012 at 8:48 AM, Mark Langsdorf
> <mark.langsdorf@calxeda.com> wrote:
>> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
>> new file mode 100644
>> index 0000000..1f28fa6
>> --- /dev/null
>> +++ b/drivers/cpufreq/highbank-cpufreq.c
>> @@ -0,0 +1,102 @@
> 
> Looks pretty good to me.  Some tedious nitpicks and discussion below.
> <snip>
> 
>> +static int hb_voltage_change(unsigned int freq)
>> +{
>> +       int i;
>> +       u32 msg[7];
>> +
>> +       msg[0] = HB_CPUFREQ_CHANGE_NOTE;
>> +       msg[1] = freq / 1000000;
>> +       for (i = 2; i < 7; i++)
>> +               msg[i] = 0;
>> +
>> +       return pl320_ipc_transmit(msg);
>> +}
>> +
>> +static int hb_cpufreq_clk_notify(struct notifier_block *nb,
>> +                               unsigned long action, void *hclk)
>> +{
>> +       struct clk_notifier_data *clk_data = hclk;
>> +       int i = 0;
>> +
>> +       if (action == PRE_RATE_CHANGE) {
>> +               if (clk_data->new_rate > clk_data->old_rate)
>> +                       while (hb_voltage_change(clk_data->new_rate))
>> +                               if (i++ > 15)
> 
> There are a few magic numbers here.  How about something like:
> 
> #define HB_VOLT_CHANGE_MAX_TRIES 15
> 
> Maybe do the same for the i2c message length?

Fixed.

>> +                                       return NOTIFY_STOP;
> 
> How about NOTIFY_BAD?  It more clearly signals that an error has occurred.

> Same as above.  It is true that the clock framework does nothing with
> post-rate change notifier aborts but that might change in the future.

Changed and added.

>> +       }
>> +
>> +       return NOTIFY_DONE;
>> +}
>> +
>> +static struct notifier_block hb_cpufreq_clk_nb = {
>> +       .notifier_call = hb_cpufreq_clk_notify,
>> +};
>> +
> 
> Do you have any plans to convert your voltage change routine over to
> the regulator framework?  Likewise do you plan to use the OPP library
> in the future?  I can understand if you do not do that since your
> regulator/dvfs programming model makes things very simple for you.

I looked at treating the ECME as a voltage regulator, but it was a very
bad fit. The ECME has a certain amount of intelligence built into it and
corporate plans are to treat voltage control as a black box.

The current solution is actually nicely generic from my perspective. The
clk notifiers guarantee we can make the voltage changes at the right
time regardless of the underlying cpufreq driver implementation. I don't
think we need more until we get into cpufreq QoS issues, and even then
I'd want to stick with something like the current structure.

--Mark Langsdorf
Calxeda, Inc.
