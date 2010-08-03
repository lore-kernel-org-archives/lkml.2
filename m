Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0HCItk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:49:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab0HCIti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:49:38 -0400
Message-ID: <4C57D836.1060106@suse.de>
Date: Tue, 03 Aug 2010 10:49:58 +0200
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: [GIT PULL tip/genirq] Please pull from lost-spurious-irq
References: <4C5033D9.7030800@kernel.org> <4C50349F.7020002@suse.de> <alpine.LFD.2.00.1007291042441.2471@localhost.localdomain> <4C529F59.3020404@suse.de> <alpine.LFD.2.00.1008020956080.9198@localhost.localdomain> <4C56E42D.5010300@suse.de> <alpine.LFD.2.00.1008021730250.27107@localhost.localdomain> <4C572F26.1040200@suse.de> <alpine.LFD.2.00.1008022353220.3225@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1008022353220.3225@localhost.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Thomas.

On 08/03/2010 12:28 AM, Thomas Gleixner wrote:
>> The current logic isn't that different except that it always considers
>> periods instead of consecutive ones and uses exponential backoff for
>> re-enable timing.
> 
> There is no need for that exponential backoff. Either the thing works
> or it does not. Where is the fcking point? If you switch the thing to
> polling mode, then it does not matter at all whether you try once a
> second, once a minute or once an hour to restore the thing. It only
> matters when you insist on collecting another 10k spurious ones before
> deciding another time that the thing is hosed.

The intention was to use the same detection code for retrials as the
initial detection.  But it sure can be done that way too.

>> WATCH shouldn't be used in normal paths because the polling code
>> doesn't have enough information to reduce overhead.  It can only be
>> used in occassional events like IRQ enable, timeout detected by driver
>> kind of events, so WATCH case overhead doesn't really matter.  Its
>> primary use case would be invoking it right after requesting IRQ as
>> USB does.
> 
> That's nonsense. You add the watch in the first place to figure out
> whether that IRQ is reliably delivered or not. If it is not, then you
> add the whole magic to the irq disabled hotpath forever. That's not a
> problem for that particular IRQ, it's a problem for the overall
> system.

For the overall system?  The thing is enabled/disabled per IRQ or are
you talking about something else?

>>>>> 3) irq expect
>>> I'm not opposed to have a generic solution for this, but I want a
>>> simple and understandable one. The irq_poll() works for everything
>>> magic is definitely not in this category.
>>
>> It's just multiplexing timer.  If the biggest issue is convolution in
>> irq_poll(), I can try to make it prettier for sure, but I guess that
>> discussion is for later time.
> 
> It's _NOT_. You _CANNOT_ make it prettier because your "design" is sucky
> by "multiplexing the timer". The multiplexing is the main issue and
> there is no way to make this less convoluted as hard as you might try.

Yeah, there's certain level of complexity w/ multiplexing timer.  It
would be nice to be able to do away with that.

>> Well, it's fairly common to have tens of secs for timeouts.  Even
>> going into minute range isn't too uncommon.
> 
> No. You just look at it from ATA or whatever, but there are tons of
> drivers which have timeouts below 100ms. You _CANNOT_ generalize that
> assumption. And if you want this for ATA where it possibly fits, then
> you just make your whole argument of generalizing the approach moot.

For most IO devices, having long timeouts is pretty common.
irq_expect doesn't make sense for cases where the usual timeouts are
pretty low.  It's for cases where the device timeout is much longer.
It probably is most useful for ATA where long timeouts and flaky IRQs
are commonplace but it's generally useful for IO initiators.

>> No, the goal is to use it for normal cases, so that we can provide
>> reasonable level of protection against occassional hiccups at fairly
>> low overhead.  Otherwise, it wouldn't be different at all from IRQ
>> watching.
> 

> WTF ? Once you switched to IRQ_EXP_VERIFIED then you run with 3sec +
> slack timeout. You only switch back when a timeout in the device
> driver happens.  That's at least how I understand the code. Correct
> me if I'm wrong,

No, it also switches on when 3sec timeout polls successfully.  The
IRQ_IN_POLLING test in unexpect_irq().

> but then you just deliver another proof for complete non
> understandble horror.

I understand the concern about and partially agree with the ugliness
of multiplexing the timer but, come on, you misunderstanding that test
can't be all my fault.  There is even a comment saying /* succesful
completion from IRQ? */ on top of that test.

>> Yeah, that's how irq_watch is supposed to be used.  irq_expect is for
>> cases where drivers can provide better information about when to start
>> and finish expecting interrupts.  For these cases, we can provide
>> protection against occassional IRQ hiccups too.  A few secs of hiccup
>> would be an order of magnitude better and will actually make such
>> failures mostly bearable.
> 
> Err. That's complete nonsense. The device driver has a timeout for the
> occasional hickup. If it happens you want to watch out for the device
> to settle back to normal.

In all or most IO drivers, the timeout only kicks in after tens of
seconds to basically clean things up and retry.  irq_expect is a
generic mechanism to detect and handle IRQ delivery hiccups which is a
specific subclass of the different timeouts.

>> Well, now we're talking about different problems.  If it were not for
>> using it in normal cases, it would be better to just rip off expecting
>> and use watching.
> 
> Oh man. You seem to be lost in some different universe. The normal
> case - and that's what it is according to your code is running the
> expect thing at low frequency (>= 3 seconds) and just swicthes back to
> quick polling when the driver code detected an error. So how is that
> fcking different from my approach ?

Gees, enough with fucks already.  As I wrote above, shorter interval
polling kicks in when an IRQ event is delivered through polling.  Why
would there be irq_expect at all otherwise?  It would be basically
identical to irq_watch.

I agree that timer multiplexing is a rather ugly thing and it would be
great to remove it.  You're right that it doesn't make whole lot of
difference whether the timer is global or local if it's low frequency
and in fast paths expect/unexpect would be able to just test its list
entry and set/clear currently expecting status without messing with
the global timer or lock.  Then, we can have a single low freq timer
for expect/unexpect and the other for actual polling.  How does that
sound to you?

Thanks.

-- 
tejun
