Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2DPSKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:10:11 -0400
Received: from mail.tpi.com ([70.99.223.143]:2186 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2DPSKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:10:10 -0400
Message-ID: <4F8C604B.70700@canonical.com>
Date: Mon, 16 Apr 2012 12:09:15 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Bryan Wu <bryan.wu@canonical.com>
CC: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org
Subject: Re: [PATCH 01/18] led-triggers: create a trigger for CPU activity
References: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com> <1334316377-23915-2-git-send-email-bryan.wu@canonical.com> <4F883E92.60001@canonical.com> <CAK5ve-K=KUO+uNK7bJw_RFJ55oid=q36tFHmqLJmeGdRxkt=wg@mail.gmail.com>
In-Reply-To: <CAK5ve-K=KUO+uNK7bJw_RFJ55oid=q36tFHmqLJmeGdRxkt=wg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 03:51 AM, Bryan Wu wrote:
>>> +
>>> +#define MAX_NAME_LEN 8
>>> +
>>
>> This length accommodates up to 10000 CPUs. How long will that suffice ?
>>
> 
> How about this:
> #define MAX_NAME_LEN    (4 + DIV_ROUND_UP(NR_CPUS, 255))
> 

That doesn't really work either. How about just leave MAX_NAME_LEN at 8
and add a 'BUILD_BUG_ON(CONFIG_NR_CPUS > 9999)' somewhere ?

> 
>>> +static DEFINE_PER_CPU(struct led_trigger *, cpu_trig);
>>> +static DEFINE_PER_CPU(char [MAX_NAME_LEN], trig_name);
>>> +
>>> +void ledtrig_cpu(enum cpu_led_event ledevt)
>>> +{
>>> +     struct led_trigger *trig = __get_cpu_var(cpu_trig);
>>> +
>>> +     if (!trig)
>>> +             return;
>>
>> I don't think __get_cpu_var(cpu_trig) _should_ ever return NULL. See
>> discussion about exclusion below in ledtrig_cpu_init().
>>
>>> +
>>> +     /* Locate the correct CPU LED */
>>> +     switch (ledevt) {
>>> +     case CPU_LED_IDLE_END:
>>> +     case CPU_LED_START:
>>> +             /* Will turn the LED on, max brightness */
>>> +             led_trigger_event(trig, LED_FULL);
>>> +             break;
>>> +
>>> +     case CPU_LED_IDLE_START:
>>> +     case CPU_LED_STOP:
>>> +     case CPU_LED_HALTED:
>>> +             /* Will turn the LED off */
>>> +             led_trigger_event(trig, LED_OFF);
>>> +             break;
>>> +
>>> +     default:
>>> +             /* Will leave the LED as it is */
>>> +             break;
>>> +     }
>>> +}
>>> +EXPORT_SYMBOL(ledtrig_cpu);
>>> +
>>> +static int ledtrig_cpu_syscore_suspend(void)
>>> +{
>>> +     ledtrig_cpu(CPU_LED_STOP);
>>> +     return 0;
>>> +}
>>> +
>>> +static void ledtrig_cpu_syscore_resume(void)
>>> +{
>>> +     ledtrig_cpu(CPU_LED_START);
>>> +}
>>> +
>>> +static void ledtrig_cpu_syscore_shutdown(void)
>>> +{
>>> +     ledtrig_cpu(CPU_LED_HALTED);
>>> +}
>>> +
>>> +static struct syscore_ops ledtrig_cpu_syscore_ops = {
>>> +     .shutdown       = ledtrig_cpu_syscore_shutdown,
>>> +     .suspend        = ledtrig_cpu_syscore_suspend,
>>> +     .resume         = ledtrig_cpu_syscore_resume,
>>> +};
>>> +
>>> +static int __init ledtrig_cpu_init(void)
>>> +{
>>> +     int cpu;
>>> +
>>> +     /*
>>> +      * Registering CPU led trigger for each CPU cores here
>>> +      * ignores CPU hotplug, but after this CPU hotplug works
>>> +      * fine with this trigger.
>>> +      */
>>> +     for_each_possible_cpu(cpu) {
>>> +             struct led_trigger *trig;
>>> +             char *name = per_cpu(trig_name, cpu);
>>> +
>>> +             snprintf(name, MAX_NAME_LEN, "cpu%d", cpu);
>>> +             led_trigger_register_simple(name, &trig);
>>
>> Check for trig == NULL. led_trigger_register_simple() does a
>> kzalloc(GFP_KERNEL). You'll also have to unwind any successful
>> registrations. Perhaps carve the guts out of ledtrig_cpu_exit() into a
>> function that can be called from either place.
>>
> 
> Actually, led_trigger_register_simple() will take care of kzalloc()
> failure. And if so trig will be NULL. I think it's unnecessary to
> check trig == NULL here and unwind any passed registrations, since
> those registration failure on for one CPU has no relationship with
> other successful registrations.
> 
> So it is necessary for us to check trig==NULL in ledtrig_cpu().
> 

I guess that means you're OK with partial registrations? That doesn't
seem orthogonal to me, but probably won't cause an OOPS. I'll look again
when you send out v2 of this patch set.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
