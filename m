Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab2HTFiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:38:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab2HTFh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:37:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Kim, Milo" <Milo.Kim@ti.com>
Subject: Re: [PATCH] leds-lm3530: replace pwm platform functions with generic pwm functions
Date: Mon, 20 Aug 2012 05:37:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Bryan Wu <bryan.wu@canonical.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208200537.48993.arnd@arndb.de>
X-Provags-ID: V02:K0:Le+myXu809roeKGcXyhBcr2UC05aTKxztdDQg0Rq+zr
 AnbL79E07U4sehH+QVzvcyTTk4k5wbdGjI8E2n49ZDZiArtnzB
 8b0SwbVsgOrW7cSUwcw0pNdCWZxvNrYLJxymrFZYcMGxF0/hMb
 8CI9egYgGP7YinuY6K50O9NYqcU53Rm9hBj6rqi/arLaveYJTS
 hnvWpDG/3AWYyNCHnrNgpTUehcQ3BjETJAI4C2XaC0wGLYexVH
 ny6iMsvNYc/yYpXYk86+vdcIcTyvy6UFLTdLvms+xkdePvhyN9
 PaUpNc9hxCN91HKjKbMWJ+Yj9VUNsK1myviIhAdPwZRUP4MPrY
 kepFfOQH6exK7CnIpC6I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2012, Kim, Milo wrote:
> +#ifdef CONFIG_PWM
> +static int lm3530_pwm_request(struct lm3530_data *drvdata)
> +{
> +       int pwm_id;
> +
> +       /* if the pwm device exists, skip requesting the device */
> +       if (drvdata->pwm)
> +               return 0;
> +
> +       pwm_id = drvdata->pdata ? drvdata->pdata->pwm_id : 0;
> +
> +       drvdata->pwm = pwm_request(pwm_id, "lm3530-pwm");
> +       drvdata->period_ns = drvdata->pdata ? drvdata->pdata->period_ns : 0;
> +
> +       return IS_ERR(drvdata->pwm) ? PTR_ERR(drvdata->pwm) : 0;
> +}
> +

A few comments on this:

* Rather than having to do the #ifdef here, I think it would be better if
  the PWM subsystem provided stub functions for pwm_request, pwm_config,
  pwm_enable, pwm_disable and pwm_free that do nothing, so you can in effect
  let the compiler optimize away the above code.

* I don't understand why you need the "if (rvdata->pwm) return 0;" case.
  It's normally better to do the initialization exactly once from the
  probe() function. You might want to return -EPROBE_DEFER if the pwm
  source is not yet available though.

	Arnd
