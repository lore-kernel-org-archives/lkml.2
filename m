Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab0HDXFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:05:16 -0400
Received: from mail.lang.hm ([64.81.33.126]:54458 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113Ab0HDXFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:05:10 -0400
Date: Wed, 4 Aug 2010 16:04:18 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <201008042231.51901.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1008041600060.6545@asgard.lang.hm>
References: <20100801210548.23f77ff6@infradead.org> <201008041347.25595.rjw@sisk.pl> <alpine.DEB.2.00.1008041130550.6545@asgard.lang.hm> <201008042231.51901.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Rafael J. Wysocki wrote:

> Subject: Re: Attempted summary of suspend-blockers LKML thread
> 
> On Wednesday, August 04, 2010, david@lang.hm wrote:
>> On Wed, 4 Aug 2010, Rafael J. Wysocki wrote:
>>> In the suspend case, when you have frozen all applications, you can
>>> sequentially disable all interrupts except for a few selected ("wakeup") ones
>>> in a safe way.   By disabling them, you ensure that the CPU will only be
>>> "revived" by a limited set of events and that allows the system to stay
>>> low-power for extended time intervals.
>>
>> the benifit of this will depend on what wakeups you are able to avoid by
>> putting the hardware to sleep. Depending on the hardware, this may be not
>> matter that much.
>
> That's correct, but evidently it does make a difference with the hardware
> Android commonly runs on.

Ok, but is there a way to put some of this to sleep without involving a 
full suspend?

>> In addition, there are input devices like a touchscreen that could be
>> disabled even short of a full suspend, as long as there is some way to get
>> them reactivated.
>
> That's correct again, but it doesn't matter too much as far as the difference
> between "deep idle" and suspend is concerned.  These devices are generally not
> the interrupt sources that are difficult to shut down safely in the "idle" case.
>
>>> To achieve the same result in the "idle" case, you'll need to have a mechanism
>>> to disable interrupts (except for the "wakeup" ones) avoiding synchronization
>>> problems (eg. situations in which task A, blocked on a "suspended" device
>>> access, holds a mutex waited for by task B that needs to run so that we can
>>> "suspend" another device).  That, however, is a difficult problem.
>>
>> I would say that the difficulty of the problem depends on the hardware and
>> how much userspace interaction is needed. If the kernel can disable the
>> hardware in the driver (so that it can wake it up again when accessed by
>> an application) it would seem that this isn't a problem.
>
> Well, I guess it's useful to consider the sequence of events in the "idle"
> case.
>
> We first detect that a CPU is idle, so it can be put into a C-state (or
> equivalent).  It's easy to put that CPU into such a state, but suppose we
> want to do more and put all devices into low-power states at that point.
> We have to ensure that there are no devices in the middle of DMA and that
> the other CPUs are idle (that's kind of easy, but still).  Next, we have to
> figure out the right ordering in which to put devices into low-power states
> (that is not trivial, because the tasks that use those devices may depend on
> each other in various ways).  If we decide to shut down clock source
> interrupts, we must ensure that the timekeeping will be correct after that and
> so on.  Moreover, things get ugly if there are shared interrupts.
>
> Suspend kind of works around these difficulties by taking the entire user
> space out of the picture with one big sledgehammer called the freezer,
> but these problems would have to be actually _solved_ in the "idle" case.

I'm not opposed to doing a suspend if the system is idle enough, I'm just 
questioning if suspend is really that different, or if it can be viewed as 
yet another low power mode (one that's significantly more expensive to 
transition in and out of)

David Lang
