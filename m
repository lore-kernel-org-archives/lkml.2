Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2DTG7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 02:59:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18299 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2DTG7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 02:59:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6686"; a="181088131"
Message-ID: <4F910941.4000702@codeaurora.org>
Date: Thu, 19 Apr 2012 23:59:13 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@canonical.com>
CC: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com
Subject: Re: [PATCH 01/18] led-triggers: create a trigger for CPU activity
References: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com> <1334660025-20442-2-git-send-email-bryan.wu@canonical.com>
In-Reply-To: <1334660025-20442-2-git-send-email-bryan.wu@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/2012 3:53 AM, Bryan Wu wrote:
> +static int __init ledtrig_cpu_init(void)
> +{
> +	int cpu;
> +
> +	/* Supports up to 9999 cpu cores */
> +	BUILD_BUG_ON(CONFIG_NR_CPUS > 9999);
> +
> +	/*
> +	 * Registering CPU led trigger for each CPU cores here
> +	 * ignores CPU hotplug, but after this CPU hotplug works
> +	 * fine with this trigger.
> +	 */
> +	for_each_possible_cpu(cpu) {
> +		struct led_trigger *trig;
> +		char *name = per_cpu(trig_name, cpu);
> +		struct rw_semaphore *lock = &per_cpu(trig_lock, cpu);
> +
> +		init_rwsem(lock);

What is this lock protecting?

> +
> +		snprintf(name, MAX_NAME_LEN, "cpu%d", cpu);
> +
> +		down_write(lock);
> +		led_trigger_register_simple(name, &trig);
> +		per_cpu(cpu_trig, cpu) = trig;
> +		up_write(lock);

This is the only place it is locked and unlocked.

I think the previous comment was about how led_trigger_register_simple()
exposed a live trigger but it wasn't assigned to the per_cpu variable
yet. Can we not just reorder the assignment so we have

  struct led_trigger *trig = NULL;
  ...
  per_cpu(cpu_trig, cpu) = trig;
  led_trigger_register_simple();

?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

