Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab1FJPh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:37:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:48344 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab1FJPh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:37:57 -0400
Date: Fri, 10 Jun 2011 17:37:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Remy Bohmer <linux@bohmer.net>
cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Peter Zijlstra <peterz@infradead.org>,
        Armin Steinhoff <armin@steinhoff.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
In-Reply-To: <BANLkTingXiRohBsaFbX9Jwr=Ba-ATqH4ag@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1106101728040.11814@ionos>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at> <alpine.LFD.2.02.1106071033350.11814@ionos> <4DEDF1F2.2080204@steinhoff.de> <1307439469.2322.235.camel@twins> <BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com>
 <20110607233517.GA31794@opentech.at> <BANLkTimYSEo4_3ecdEVaJxdME7n9=2Km8Q@mail.gmail.com> <alpine.LFD.2.02.1106082044040.11814@ionos> <BANLkTingXiRohBsaFbX9Jwr=Ba-ATqH4ag@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011, Remy Bohmer wrote:
> 2011/6/8 Thomas Gleixner <tglx@linutronix.de>:
> > On Wed, 8 Jun 2011, Remy Bohmer wrote:
> >> In real life you may want, for EXAMPLE, this setup:
> >> * prio 70: high priority motor control loop
> >> * prio 60: network device irq
> >> * prio 59: network softirqs
> >> * prio 55: some realtime task depending on networkingstack
> >> * prio 54: mass storage irq
> >> * prio 53: block device softirq
> >> * prio 52: some realtime task depending on mass-storage
> >> * prio 50: all remaining irq threads
> >> * prio 49: all remaining softirqs
> >>
> >> Assume here you do a ifconfig down and ifconfig up, in the current
> >> kernel behaviour you will see that the irq thread switches from prio
> >> 60 to 50.
> >> The irq-thread will become of a lower priority compared to its related
> >> softirqs due to this reason, which can result in a complete die of
> >> this network interface... even before it ever came back up again...
> >
> > Not really. If that's the case it needs to be investigated and
> > fixed.
> 
> I, of course, agree with that, but these cases are usually extremely
> hard to find, and occur typically only in the once-a-month-condition
> that you cannot reproduce...
> Do you remember why the priority of the softirqs was moved down from
> 50 to 49 ? IIRC this was because of the very same reason and IIRC
> still valid

No, it's not. The root cause was a problem with the network softirq
and a network driver, the softirq ->49 was a temporary workaround
until we had enough information to find the real root cause. I wish
I'd never committed that change at all.

> We do not have control over all kernel code, and new drivers are
> continuously being developed that make wrong implicit assumptions
> about the order of irq->sirq->everything else. Of course this is
> wrong, and there is no excuse, but it is a fact of life...
> In practice the softirq prio can be set to a higher value than 50 (or
> 1), and a hirq thread that is started at 50 (or 2) will result in
> situations that are not expected.
> 
> >> As mentioned before by Thomas, the configuration is a policy issue and
> >> must be set from user-context. I understand what he means by that and
> >> I agree, but there still has to be a mechanism to make the kernel
> >> remember the configuration set by the user to prevent all kinds of
> >> race conditions. You cannot demand from the user to run after
> >
> > Which race conditions?
> 
> Race conditions that occur when a softirq preempts a related hardirq
> what the driver did not expect or was designed for.

And making it the other way round hides the problem, which is even
worse. We want stuff to explode right away. You can run into the same
problem when the softirq holds a lock and the high prio irq thread
boosts it.

> > So moving the base priority down to 1 or 2 is probably the most
> > sensible solution to avoid that a newly brought up interrupt thread
> > interferes with anything in the rt domain and it's not rocket science
> > to adjust the priority in a ifup.post or with an udev rule.
> 
> At prio 1 or 2, _every_ RT-thread in the system is to be assumed to be
> more low-latency bound compared to _any_ interrupt handler. And you
> assume here that no user RT-thread in the system shall use any
> functionality of any driver that has an interrupt handler (otherwise
> you get the priority inversions issue)

Sigh. People who use RT threads should better know what they do and
configure their damned system correct. We cannot provide a solution
which takes every incarnatation of lusers into account.

> As mentioned in this thread before by someone else, you will get this
> old issue back: 'My drivers start to behave weird when I create a
> RT-thread...'

And I do not care at all. The answer is: Do not use an RT-thread when
you are not knowing what you are doing.

> The prio inversion issue between hirq/sirq will even become more
> worse, since there will be a smaller chance that softirqs will stay at
> prio 1 and thus there is less guarantee that they will stay below the
> hirq-prio all the time.

There is no such thing and if it's there, then it needs to be found
and fixed.

> Furthermore, I prefer the principle: _Nothing_ goes above interrupt
> (thread) priority unless there is a very special reason for it and it
> has been investigated that it is safe to do so. And a user-thread that
> requires functionality of a certain driver shall be set below the
> priority of the hirq-thread of that driver. The prio of the softirq
> must _always_ be between that user-thread and hirq-thread if there is
> a relation between the driver and softirq.
> 
> In that light I think prio 1/2 is more worse compared to 49/50. I
> think the current _default_ is okay, it makes the system at least
> boot.

It boots with 50 or whatever you set it to as well.

Thanks,

	tglx
