Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab2HTGNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:13:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47420 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab2HTGNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:13:30 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Bryan Wu <bryan.wu@canonical.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] leds-lm3530: replace pwm platform functions with
 generic pwm functions
Thread-Topic: [PATCH] leds-lm3530: replace pwm platform functions with
 generic pwm functions
Thread-Index: Ac1+iI3X+iN5rabESjyXTrhr06HT3P//lKUA//95SCA=
Date: Mon, 20 Aug 2012 06:13:20 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF092A@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
 <201208200537.48993.arnd@arndb.de>
In-Reply-To: <201208200537.48993.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Rather than having to do the #ifdef here, I think it would be better
> if
>   the PWM subsystem provided stub functions for pwm_request, pwm_config,
>   pwm_enable, pwm_disable and pwm_free that do nothing, so you can in
> effect
>   let the compiler optimize away the above code.

Thanks a lot for catching this!

This is really what I'm hesitating to use #ifdef.
Do you mean making PWM exported functions in pwm.h with CONFIG_PWM condition as below?

#ifdef CONFIG_PWM
...
int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
...
#else
...
static inline int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
{
	return 0;
}
...
#endif


> * I don't understand why you need the "if (rvdata->pwm) return 0;" case.
>   It's normally better to do the initialization exactly once from the
>   probe() function. You might want to return -EPROBE_DEFER if the pwm
>   source is not yet available though.

This device has 3 control mode. - register access, sensor input and PWM input.
One of modes can be selected on-the-fly.
So that's why I add code which returning 0 when PWM device exists.
Whenever mode change occurs from/to 'PWM input', pwm_request() and pwm_free() should be called.


Best Regards,
Milo



