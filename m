Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab2JVXMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 19:12:36 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37326 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2JVXMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 19:12:35 -0400
MIME-Version: 1.0
In-Reply-To: <1350944894.19698.208.camel@doorstop.aus.2wire.com>
References: <CAK5ve-JAc2Env1AyZMY178QobhqmAh4euHQdPS=UH3mGGeSgLA@mail.gmail.com>
 <1350944894.19698.208.camel@doorstop.aus.2wire.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 22 Oct 2012 16:12:13 -0700
Message-ID: <CAK5ve-Jsz9wULvuhPw98_DLEDWXVhbZrmExBPq5D80teUMuGEQ@mail.gmail.com>
Subject: Re: [PATCH] ledtrig-cpu: use spin_lock to replace mutex lock
To: Nathan Lynch <ntl@pobox.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Miles Lane <miles.lane@gmail.com>,
        akpm <akpm@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 3:28 PM, Nathan Lynch <ntl@pobox.com> wrote:
> Hi Bryan,
>
> On Thu, 2012-10-18 at 11:18 -0700, Bryan Wu wrote:
>> @@ -117,14 +117,14 @@ static int __init ledtrig_cpu_init(void)
>>       for_each_possible_cpu(cpu) {
>>               struct led_trigger_cpu *trig = &per_cpu(cpu_trig, cpu);
>>
>> -             mutex_init(&trig->lock);
>> +             spin_lock_init(&trig->lock);
>>
>>               snprintf(trig->name, MAX_NAME_LEN, "cpu%d", cpu);
>>
>> -             mutex_lock(&trig->lock);
>> +             spin_lock(&trig->lock);
>>               led_trigger_register_simple(trig->name, &trig->_trig);
>>               trig->lock_is_inited = 1;
>> -             mutex_unlock(&trig->lock);
>> +             spin_unlock(&trig->lock);
>
> I wouldn't know how to fix the original problem, but I don't think this
> patch is okay -- led_trigger_register_simple() does things that
> potentially sleep (GFP_KERNEL allocation, down_write), so it's not safe
> to call while holding a spinlock.
>

Looks like we got a hard issue, since led_trigger_register() families
and even led_trigger_event() might use rwsem for locking, these are
all potentially sleep, which are not easy to modified for atomic
context.

Any hints are welcome.

Thanks,
-Bryan
