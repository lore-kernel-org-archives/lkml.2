Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab2AIDsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 22:48:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44668 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2AIDsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 22:48:09 -0500
Message-ID: <4F0A6370.6040405@gmail.com>
Date: Mon, 09 Jan 2012 14:48:00 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, MyungJoo Ham <myungjoo.ham@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Multithread initcalls to auto-resolve ordering issues.
References: <20120109112113.07882ed9@notabene.brown>	<4F0A3D58.6050400@gmail.com> <20120109142920.4aa2162c@notabene.brown>
In-Reply-To: <20120109142920.4aa2162c@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/12 14:29, NeilBrown wrote:

> On Mon, 09 Jan 2012 12:05:28 +1100 Ryan Mallon <rmallon@gmail.com> wrote:
> 
>> On 09/01/12 11:21, NeilBrown wrote:
>>
>>>
>>> [ To: list stolen from "introduce External Connector Class (extcon)" thread
>>>   where this topic was briefly mentioned. ]
>>>
>>> Hi,
>>>  I welcome review/feedback on the following idea and code.
>>
>>
>> Hi Neil,
>>
>> Interesting idea, some comments below.
>>
> 
> Thanks for the quick review!
> 
>>> Proposed solution:
>>>
>>>   The solution I am proposing is to:
>>>    1/ allow the 'request' functions which find and provide a resource to block
>>>       until the resource is available
>>>    2/ run the init calls in multiple threads so that when one blocks waiting
>>>       for a resource, another starts up to run subsequent initcalls until
>>>       the blocking call gets its resource and can complete.
>>
>> What happens if the resource isn't actually present (driver/hardware
>> missing or resource probe fails for example)? Does the initcall thread
>> get stuck forever, or is there a timeout?
> 
> With my code it will get stuck forever.
> What is the alternative?  Just fail?
> 
> Is this a realistic scenario?  If it is we would probably need some way to
> say "this resource is no longer expected" .. sounds messy.


I think this is a realistic scenario in the cases I gave. A resource may
fail to load properly for a variety of reasons. For example in an
embedded system a regulator driver could be dependent on an i2c io
expander to provide some of its gpios. If the expander or i2c bus
hardware are faulty then it will fail to probe and the regulator driver
probe will get stuck forever.

If the resource driver is present, then it could notify the waiter if
its probe fails. It's a bit trickier if the resource driver probe never
even runs (driver missing, etc). Having a long timeout for the waiter
might be annoying if the dependency is missing since it will
unnecessarily stall the boot, and having too short a timeout could
result in the dependency being missed.

> 
>>
>>> Details and issues.
>>>
>>>   1/ Sometimes it is appropriate to fail rather than to block, and a resource
>>>      providers need to know which.
>>>      This is unlikely to be an issue with GPIO and IRQ as is the identifying
>>>      number is >= 0, then the resource must be expected at some stage.
>>>      However for regulators a name is not given to the driver but rather the
>>>      driver asks if a supply is available with a given name for the device.
>>>      If not, it makes do without.
>>>      So for regulators (and probably other resources) we need to know what
>>>      resources to expect so we know if a resource will never appear.
>>>
>>>      In this sample code I have added a call 
>>>           regulator_has_full_constraints_listed()
>>>      which not only assures that all constraints are known, but list
>>>      them (array of pointers to regulator_init_data) so when a supply is
>>>      requested the regulator code can see if it expected.
>>>
>>>   2/ We probably don't want lots of threads running at once as there is
>>>      no good way to decide how many (maybe num_cpus??).
>>>      This patch takes the approach that only one thread should be runnable
>>>      at once in most cases.
>>
>>
>> num_cpus won't work for UP systems. In practice the number of threads
>> needed is probably low, since most devices probably only have a short
>> dependency chain.
> 
> My reference to "num_cpus" was for how many threads should be runnable
> concurrently (rather than blocking on something) so a value of '1' would be
> OK and is what I (mostly) impose with the current code.
> 
> The total number of threads created with be the number of devices that are
> dependent on something later in the default initcall order.  So it could be
> longer than the longest chain if there are multiple long chains that all
> block at once.  It could likely be a few, quite possibly be dozens, very
> unlikely to be hundreds unless you really had lots and lots of devices.


Ah, yes. I was mistakenly thinking that when an initcall thread blocked,
the newly launched thread would be for its dependency, which is not
always going to be true.

Your solution seems like a good starting point. Without knowledge of how
many devices/dependencies there are, limiting the number of threads may
result in a situation where the system is unable to boot because all of
the threads are blocked and no more are allowed to be allocated.

I remember reading a few threads about making the boot process parallel,
and vaguely recall that there were a few difficulties in doing so. Is
making these initcalls parallel completely safe?


> 
> 
>>
>>>
>>>      We keep a count of the number of threads started and the number of
>>>      threads that are blocked, and only start a new thread when all threads
>>>      are blocked, and only start a new initcall when all other threads are
>>>      blocked.
>>>
>>>      So when one initcall makes a resource available, another thread which
>>>      was waiting could wake up and both will run concurrently.  However no
>>>      more initcalls will start until all threads have completed or blocked.
>>
>>
>> With this approach having an unbounded number of threads should be okay
>> right? The number of threads shouldn't exceed the length of a dependency
>> chain.
>>
>>>
>>>   3/ The parent locking that __driver_attach() does which is "Needed for USB"
>>>      was a little problem - I changed it to alert the initcall thread
>>>      management so it knew that thread was blocking.  I think this wouldn't be
>>>      a problem is the parent lock was *only* taken for USB...
>>>
>>>   4/ It is possible that some existing code registers a resource before it is
>>>      really ready to be used.  Currently that isn't a problem as no-one will
>>>      actually try to use it until the initcall has completed.  However with
>>>      this patch the device that wants to use a resource can do so the moment
>>>      it is registered.
>>
>>
>> Such code would be buggy and need fixing correct? This patch could
>> possibly help identify such buggy code?
> 
> Probably.  When drivers are built as modules the initcalls can already run in
> parallel so getting the setup wrong could conceivably be an issue already -
> but yes, I think this patch could make those bugs more obvious.
> 
> As an example of something that might be a bug (And I had to look hard to
> find it), in gpio-pl061.c in the _probe function it calls:
> 
> 		set_irq_flags(i+chip->irq_base, IRQF_VALID);
> 		irq_set_chip_data(i + chip->irq_base, chip);
> 
> Now I haven't set up any code for blocking when IRQs aren't available yet,
> but I suspect that the point they become available is when set_irq_flags is
> called to set IRQF_VALID.  If some other driver immediately tired to use that
> irq it would find that the ->chip_data is NULL. e.g. it could call
> pl061_irq_enable() which immediately gets the chip_data and dereferences it.
> 
> 
>>> @@ -1179,15 +1195,41 @@ int gpio_request(unsigned gpio, const char *label)
>>>  	struct gpio_chip	*chip;
>>>  	int			status = -EINVAL;
>>>  	unsigned long		flags;
>>> +	int			can_wait = !in_atomic();
>>
>>
>> I don't think you can reliably do this. Callers should always track
>> whether they can sleep or not. See: http://lwn.net/Articles/274695/
> 
> Undoubtedly true.  I'm not even sure that gpio_request can be called from
> atomic context, but as spin_lock_irqsave was used (below) instead of
> spin_lock_irq, I thought it safest to test.
> 
> If this gets past the initial review stage I'm sure I'll get help from
> someone how knows this code to make it right.

Yeah, I figured you may have done this just for testing purposes.

~Ryan
