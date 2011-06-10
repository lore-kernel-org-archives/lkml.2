Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab1FJOEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:04:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64089 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966Ab1FJOEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:04:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=lLwYhO5z9MzCQuLqf8x2SN5x84IMsMJ6+B0c60prhzjDDX8oGHhTOjtMxkOXIiMOj2
         H0sWZTPqmeaJBWfUncDLdPKSJxWTf2lFz2n/Zf7F3Zhg7SmfliqK7oNslh7iKtQR0oRm
         QuAvab8CVkfgIVlJqFPJuUHkHa8bbvr9gJP/U=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1106082044040.11814@ionos>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at>
	<alpine.LFD.2.02.1106071033350.11814@ionos>
	<4DEDF1F2.2080204@steinhoff.de>
	<1307439469.2322.235.camel@twins>
	<BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com>
	<20110607233517.GA31794@opentech.at>
	<BANLkTimYSEo4_3ecdEVaJxdME7n9=2Km8Q@mail.gmail.com>
	<alpine.LFD.2.02.1106082044040.11814@ionos>
Date: Fri, 10 Jun 2011 16:04:03 +0200
X-Google-Sender-Auth: Vm3dA-yfhQnIx0FSINhBUcefrM4
Message-ID: <BANLkTingXiRohBsaFbX9Jwr=Ba-ATqH4ag@mail.gmail.com>
Subject: Re: Changing Kernel thread priorities
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Peter Zijlstra <peterz@infradead.org>,
        Armin Steinhoff <armin@steinhoff.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

2011/6/8 Thomas Gleixner <tglx@linutronix.de>:
> On Wed, 8 Jun 2011, Remy Bohmer wrote:
>> In real life you may want, for EXAMPLE, this setup:
>> * prio 70: high priority motor control loop
>> * prio 60: network device irq
>> * prio 59: network softirqs
>> * prio 55: some realtime task depending on networkingstack
>> * prio 54: mass storage irq
>> * prio 53: block device softirq
>> * prio 52: some realtime task depending on mass-storage
>> * prio 50: all remaining irq threads
>> * prio 49: all remaining softirqs
>>
>> Assume here you do a ifconfig down and ifconfig up, in the current
>> kernel behaviour you will see that the irq thread switches from prio
>> 60 to 50.
>> The irq-thread will become of a lower priority compared to its related
>> softirqs due to this reason, which can result in a complete die of
>> this network interface... even before it ever came back up again...
>
> Not really. If that's the case it needs to be investigated and
> fixed.

I, of course, agree with that, but these cases are usually extremely
hard to find, and occur typically only in the once-a-month-condition
that you cannot reproduce...
Do you remember why the priority of the softirqs was moved down from
50 to 49 ? IIRC this was because of the very same reason and IIRC
still valid

We do not have control over all kernel code, and new drivers are
continuously being developed that make wrong implicit assumptions
about the order of irq->sirq->everything else. Of course this is
wrong, and there is no excuse, but it is a fact of life...
In practice the softirq prio can be set to a higher value than 50 (or
1), and a hirq thread that is started at 50 (or 2) will result in
situations that are not expected.

>> As mentioned before by Thomas, the configuration is a policy issue and
>> must be set from user-context. I understand what he means by that and
>> I agree, but there still has to be a mechanism to make the kernel
>> remember the configuration set by the user to prevent all kinds of
>> race conditions. You cannot demand from the user to run after
>
> Which race conditions?

Race conditions that occur when a softirq preempts a related hardirq
what the driver did not expect or was designed for.

>> executing a shell command like ifconfig or modprobe to run some sort
>> of init-script that repairs what the kernel assumed wrong. The wrong
>> assumptions the kernel does results in: deadlocks, priority inversion
>> issues between irq-threads and softirqs and realtime behaviour impact.
>
> If you do an ifdown/up then your prio 55 task is totally irrelevant
> until the interface is back to full operation again, which includes
> setting the priority right.

I already expected that remark after I pressed the send button of that
mail... This was just meant as an example, in which you can probably
shoot more holes in. It is not about the example, it is about the
essence of what I am trying to explain here.

> There is another gotcha with your approach. It only ever works when
> the interrupt descriptors are static and not dynamically
> allocated/freed. If they are fully dynamic then you have no
> possibility to store the prio information after a full teardown of a
> device.

It depends how it is being implemented.
A mechanism to specify the policy does not mean everything has to be
already in place the policy is about at the moment you specify the
policy.
In other words, a policy may describe situations that are going to
happen in the future, not necessarily situations that are actual now.

For example, something like this:
* A user specifies a table with policy information about what each
interrupt handler in the system should do when they are being created.
* When the interrupt handler is being installed, it is looked up in
the table at what priority and scheduling policy it needs to run. If
not specified, go for a default.
* Additionally: When the table is being updated, the already running
threads can being adjusted to the new policy.

> So moving the base priority down to 1 or 2 is probably the most
> sensible solution to avoid that a newly brought up interrupt thread
> interferes with anything in the rt domain and it's not rocket science
> to adjust the priority in a ifup.post or with an udev rule.

At prio 1 or 2, _every_ RT-thread in the system is to be assumed to be
more low-latency bound compared to _any_ interrupt handler. And you
assume here that no user RT-thread in the system shall use any
functionality of any driver that has an interrupt handler (otherwise
you get the priority inversions issue)
As mentioned in this thread before by someone else, you will get this
old issue back: 'My drivers start to behave weird when I create a
RT-thread...'
The prio inversion issue between hirq/sirq will even become more
worse, since there will be a smaller chance that softirqs will stay at
prio 1 and thus there is less guarantee that they will stay below the
hirq-prio all the time.

Furthermore, I prefer the principle: _Nothing_ goes above interrupt
(thread) priority unless there is a very special reason for it and it
has been investigated that it is safe to do so. And a user-thread that
requires functionality of a certain driver shall be set below the
priority of the hirq-thread of that driver. The prio of the softirq
must _always_ be between that user-thread and hirq-thread if there is
a relation between the driver and softirq.

In that light I think prio 1/2 is more worse compared to 49/50. I
think the current _default_ is okay, it makes the system at least
boot.

Kind regards,

Remy
