Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab2D3FOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:14:48 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35923 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2D3FOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:14:47 -0400
MIME-Version: 1.0
In-Reply-To: <1334704072.616.152.camel@ted>
References: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
 <1334660025-20442-2-git-send-email-bryan.wu@canonical.com>
 <20120417155241.0f619a9a.akpm@linux-foundation.org> <1334704072.616.152.camel@ted>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 30 Apr 2012 13:14:26 +0800
X-Google-Sender-Auth: mgSJaFctOMFb5uVgo6LNHKD79_0
Message-ID: <CAK5ve-L_o8tr1CGkv4doNQdSXyoqnWkk8jZmkE585Z++CZDAmQ@mail.gmail.com>
Subject: Re: [PATCH 01/18] led-triggers: create a trigger for CPU activity
To: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org, tim.gardner@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 7:07 AM, Richard Purdie
<richard.purdie@linuxfoundation.org> wrote:
> On Tue, 2012-04-17 at 15:52 -0700, Andrew Morton wrote:
>> On Tue, 17 Apr 2012 18:53:28 +0800
>> Bryan Wu <bryan.wu@canonical.com> wrote:
>> > +    * ignores CPU hotplug, but after this CPU hotplug works
>> > +    * fine with this trigger.
>> > +    */
>> > +   for_each_possible_cpu(cpu) {
>> > +           struct led_trigger *trig;
>> > +           char *name = per_cpu(trig_name, cpu);
>> > +           struct rw_semaphore *lock = &per_cpu(trig_lock, cpu);
>> > +
>> > +           init_rwsem(lock);
>> > +
>> > +           snprintf(name, MAX_NAME_LEN, "cpu%d", cpu);
>> > +
>> > +           down_write(lock);
>> > +           led_trigger_register_simple(name, &trig);
>>
>> OK, problem.
>>
>> led_trigger_register_simple() calls kzalloc() and
>> led_trigger_register(), both of which can fail.
>> led_trigger_register_simple() just returns void, failing to propagate
>> the error back.  This is bad, and we (ie you ;)) should fix
>> led_trigger_register_simple() before proceeding to use it.  If at all
>> possible.  Please.  Let us not propagate the badness further.  Sorry.
>
> FWIW, this was really the way led_trigger_register_simple() was designed
> to work. It's original use was adding a trigger into other subsystems
> which didn't want a ton of LED code so it had the simple form:
>
> xxx = led_trigger_register_simple(name, &trig);
>

Richard, currently the led_trigger_register_simple() just return void,
so xxx here is wrong.

> where xxx could then be unregistered later equally simply and safely in
> one line. It didn't seem to make sense to pass the error around as it
> didn't really matter to the code it was being used in.
>
> I guess we could return an error pointer and check for that at
> unregister time in led_trigger_unregister_simple().
>

I also agree we don't need take care of failure in the caller as
led_trigger_register_simple() will take care of that.

>>
>> > +           char *name = per_cpu(trig_name, cpu);
>> > +
>> > +           led_trigger_unregister_simple(trig);
>>
>> And what happens if led_trigger_register_simple() had silently failed
>> to register this trigger?  afacit, nothing: your code handles the
>> trig==NULL case OK.  Still, we should be checking for those failures!
>
> FWIW, led_trigger_unregister_simple() will deal with NULL safely.
>

I will update my patches according to Andrew's comments shortly.

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
