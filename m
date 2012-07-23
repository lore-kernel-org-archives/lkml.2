Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2GWOFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:05:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54285 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab2GWOFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:05:23 -0400
Message-ID: <500D5A1F.9000808@linaro.org>
Date: Mon, 23 Jul 2012 15:05:19 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Help request - ASoC recursion issue
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I was wondering if I may bother you for some help. I've been having 
serious issues with testing the new mop500 sound system you have in your 
ASoC for-next branch. I've fixed a few issues and will be submitting 
patches shortly. The most serious issue I came across was with 
recursion. Let me show you:

So here we setup the power_check function pointer with 
'dapm_supply_check_power()'.

> static struct snd_soc_dapm_widget *
> snd_soc_dapm_new_control(struct snd_soc_dapm_context *dapm,
> 			 const struct snd_soc_dapm_widget *widget)
> {
<snip>
> 	case snd_soc_dapm_regulator_supply:
> 	case snd_soc_dapm_clock_supply:
> 		w->power_check = dapm_supply_check_power;
> 		break;
<snip>
> }

Later we call 'dapm_widget_power_check()' which calls into the function 
pointer we know to be 'dapm_supply_check_power()'.

 > static int dapm_widget_power_check(struct snd_soc_dapm_widget *w)
 > {
 > 	if (w->power_checked)
 > 		return w->new_power;
 >
 > 	if (w->force)
 > 		w->new_power = 1;
 > 	else
 > 		w->new_power = w->power_check(w);
 >
 > 	w->power_checked = true;
 >
 > 	return w->new_power;
 > }

The problem seems to be that 'dapm_supply_check_power()' then calls back 
into 'dapm_widget_power_check()'. Then round and round we go!

> /* Check to see if a power supply is needed */
> static int dapm_supply_check_power(struct snd_soc_dapm_widget *w)
> {
<snip>
> 	/* Check if one of our outputs is connected */
> 	list_for_each_entry(path, &w->sinks, list_source) {
> 		DAPM_UPDATE_STAT(w, neighbour_checks);
>
> 		if (path->weak)
> 			continue;
>
> 		if (path->connected &&
> 		    !path->connected(path->source, path->sink))
> 			continue;
>
> 		if (!path->sink)
> 			continue;
>
> 		if (dapm_widget_power_check(path->sink))     /* <-- Doh! */
> 			return 1;
> 	}
<snip>
> }

Can you shed some light on what the correct solution might be?

Any help would be gratefully received.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
