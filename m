Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab2LESuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:50:11 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:48823 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2LESuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:50:08 -0500
MIME-Version: 1.0
In-Reply-To: <1354726121-17190-7-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354726121-17190-1-git-send-email-mark.langsdorf@calxeda.com> <1354726121-17190-7-git-send-email-mark.langsdorf@calxeda.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Wed, 5 Dec 2012 10:49:47 -0800
Message-ID: <CAPtuhTg4N7zAMf_Vfw1Xfbn3OmZ7hVffVuc=kMByxf_hJLkpPw@mail.gmail.com>
Subject: Re: [PATCH 6/6 v8] cpufreq, highbank: add support for highbank cpufreq
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 8:48 AM, Mark Langsdorf
<mark.langsdorf@calxeda.com> wrote:
> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
> new file mode 100644
> index 0000000..1f28fa6
> --- /dev/null
> +++ b/drivers/cpufreq/highbank-cpufreq.c
> @@ -0,0 +1,102 @@

Looks pretty good to me.  Some tedious nitpicks and discussion below.
<snip>

> +static int hb_voltage_change(unsigned int freq)
> +{
> +       int i;
> +       u32 msg[7];
> +
> +       msg[0] = HB_CPUFREQ_CHANGE_NOTE;
> +       msg[1] = freq / 1000000;
> +       for (i = 2; i < 7; i++)
> +               msg[i] = 0;
> +
> +       return pl320_ipc_transmit(msg);
> +}
> +
> +static int hb_cpufreq_clk_notify(struct notifier_block *nb,
> +                               unsigned long action, void *hclk)
> +{
> +       struct clk_notifier_data *clk_data = hclk;
> +       int i = 0;
> +
> +       if (action == PRE_RATE_CHANGE) {
> +               if (clk_data->new_rate > clk_data->old_rate)
> +                       while (hb_voltage_change(clk_data->new_rate))
> +                               if (i++ > 15)

There are a few magic numbers here.  How about something like:

#define HB_VOLT_CHANGE_MAX_TRIES 15

Maybe do the same for the i2c message length?

> +                                       return NOTIFY_STOP;

How about NOTIFY_BAD?  It more clearly signals that an error has occurred.

You could also return notifier_from_errno(-ETIMEDOUT) here if you
prefer but that would only be for the sake of readability.
clk_set_rate doesn't actually return the notifier error code in the
event of a notifier abort.

> +       } else if (action == POST_RATE_CHANGE) {
> +               if (clk_data->new_rate < clk_data->old_rate)
> +                       while (hb_voltage_change(clk_data->new_rate))
> +                               if (i++ > 15)
> +                                       break;

Same as above.  It is true that the clock framework does nothing with
post-rate change notifier aborts but that might change in the future.

> +       }
> +
> +       return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block hb_cpufreq_clk_nb = {
> +       .notifier_call = hb_cpufreq_clk_notify,
> +};
> +

Do you have any plans to convert your voltage change routine over to
the regulator framework?  Likewise do you plan to use the OPP library
in the future?  I can understand if you do not do that since your
regulator/dvfs programming model makes things very simple for you.

The reason I bring this up is that I did float a patch a while back
for a generalized dvfs notifier handler.  The prereqs for using it are
1) ccf, 2) regulator fwk, 3) opp definitions.  Here is the patch:
https://github.com/mturquette/linux/commit/05a280bbc0819a6858d73088a632666f0c7f68a4

And an example usage in the OMAP CPUfreq driver:
https://github.com/mturquette/linux/commit/958f10bb98a293aa912e7eb9cd6edbdc51c1c04a

I understand if this approach incurs too much software overhead for
you but I wanted to throw it out there.  It might working nicely in
the cpufreq-cpu0 driver or some other "generic" CPUfreq driver for
implementing DVFS.

Regards,
Mike
