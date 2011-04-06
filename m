Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab1DFNSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:18:04 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:33583 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743Ab1DFNSA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lT3F5ACLaO0DSXR2CZZfpQTgk5a9VxxW6nrCYUHA55JTxznGsgDRxUHwB58kMZ60ws
         1oRIDzfh07KjdvdwnrFBu2cjhKrHo2cz1IxQAoRYBgekoJ+JHnCV0yAXkoncBz/wcAoA
         z/O8vq37QbSGWOeEhYwhZZr5v91b0zk8IXTzA=
MIME-Version: 1.0
In-Reply-To: <1301630392-20793-3-git-send-email-bgat@billgatliff.com>
References: <1301630392-20793-1-git-send-email-bgat@billgatliff.com>
	<1301630392-20793-3-git-send-email-bgat@billgatliff.com>
Date: Wed, 6 Apr 2011 09:17:58 -0400
Message-ID: <BANLkTikzBHJxToLPXQZCLN-GjbYHMfASLw@mail.gmail.com>
Subject: Re: [PWM v9 2/3] PWM: GPIO+hrtimer device emulation
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

I tested this series on da850evm from commit
60124de319dc2800c0f75f44bf84471a8de0dbc5 of
git://git.billgatliff.com/pwm.git.

With the following commands I was able to observe the production of a
100Hz 50% output on a GPIO (specifically GPIO #125 which is GPIO7[13]
on the SoC and J15[13] on the baseboard for other da850 users).

     mount config /config -t configfs
     mkdir /config/gpio_pwm/125
     echo 1 > /sys/class/pwm/gpio_pwm\:125/export
     echo 10000000 > /sys/class/pwm/gpio_pwm\:125/period_ns
     echo 5000000 > /sys/class/pwm/gpio_pwm\:125/duty_ns
     echo 1 > /sys/class/pwm/gpio_pwm\:125/run

I noticed that the following command did not stop the pwm output.
     echo 0 > /sys/class/pwm/gpio_pwm\:125/run

But the following command did (and I did not need to echo 1 >
/sys/class/pwm/gpio_pwm\:125/unexport first)
     rm -rf /config/gpio_pwm/125

The observations from my testing above are repeated in context below:

On Thu, Mar 31, 2011 at 11:59 PM, Bill Gatliff <bgat@billgatliff.com> wrote:
> Emulates a PWM device using a GPIO pin and an hrtimer.  Subject
> to CPU, scheduler and hardware limitations, can support many
> PWM outputs, e.g. as many as you have GPIO pins available for.
>
> On a 200 MHz ARM9 processor, a PWM frequency of 100 Hz can be attained
> with this code so long as the duty cycle remains between about 20-80%.
> At higher or lower duty cycles, the transition events may arrive too
> close for the scheduler and CPU to reliably service.
>
> This driver supports creation of new GPIO+hrtimer PWM devices via
> configfs:
>
>   # mount config /config -t configfs
>   # mkdir /config/gpio-pwm/<gpio number>

minor: I observed that the configfs directory was 'gpio_pwm' not 'gpio-pwm.'

> The new PWM device will appear as /sys/class/pwm/gpio-pwm.<gpio number>.
>
> Caveats:
>   * The GPIO pin number must be valid, not already in use
>   * The output state of the GPIO pin is configured when the PWM starts
>     running i.e. not immediately upon request, because the polarity of
>     the inactive state of the pin isn't known until the pwm device's
>     'polarity' attribute is configured
>   * After creating and binding the pwm device, you must then request
>     it by writing to /sys/class/pwm/gpio-pwm.<gpio number>/export
>
> Unbind and destroy the pwm device by first stopping and unexporting
> the pwm device under sysfs as usual; then do:

I observed that

# echo 0 > /sys/class/pwm/gpio_pwm\:125/run

did not stop the pwm output and that

# echo 1 > /sys/class/pwm/gpio_pwm\:125/unexport

was not required before rm -rf'ing the /config directory:
>   # rm -rf /config/gpio-pwm/<gpio number>

> Signed-off-by: Bill Gatliff <bgat@billgatliff.com>

Overall this is a really easy to user userspace interface -- it was a
pleasure to setup and test.

Tested-by: Ben Gardiner <bengardiner@nanometrics.ca>

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
