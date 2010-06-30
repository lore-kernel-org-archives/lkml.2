Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab0F3Lvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:51:40 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:55627 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab0F3Lvi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 07:51:38 -0400
Message-Id: <4C2B4C050200007800008CDB@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 12:52:05 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Peter Zijlstra" <peterz@infradead.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -
	 base implementation
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>
 <1277885133.1868.71.camel@laptop>
 <4C2B23CD0200007800008BFA@vpn.id2.novell.com>
 <1277889116.1868.95.camel@laptop> <4C2B2180.6040401@goop.org>
In-Reply-To: <4C2B2180.6040401@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 12:50, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 06/30/2010 11:11 AM, Peter Zijlstra wrote:
>>>> Uhm, I'd much rather see a single alternative implementation, not a
>>>> per-hypervisor lock implementation.
>>>>       
>>> How would you imaging this to work? I can't see how the mechanism
>>> could be hypervisor agnostic. Just look at the Xen implementation
>>> (patch 2) - do you really see room for meaningful abstraction there?
>>>     
>> I tried not to, it made my eyes bleed.. 
>>
>> But from what I hear all virt people are suffering from spinlocks (and
>> fair spinlocks in particular), so I was thinking it'd be a good idea to
>> get all interested parties to collaborate on one. Fragmentation like
>> this hardly ever works out well.
>>   
> 
> Yes.  Now that I've looked at it a bit more closely I think these
> patches put way too much logic into the per-hypervisor part of the code.

I fail to see that: Depending on the hypervisor's capabilities, the
two main functions could be much smaller (potentially there wouldn't
even be a need for the unlock hook in some cases), and hence I
continue to think that all code that is in xen.c indeed is non-generic
(while I won't say that there may not be a second hypervisor where
the code might look almost identical).

>> Ah, right, after looking a bit more at patch 2 I see you indeed
>> implement a ticket like lock. Although why you need both a ticket and a
>> FIFO list is beyond me.
>>   
> 
> That appears to be a mechanism to allow it to take interrupts while
> spinning on the lock, which is something that stock ticket locks don't
> allow.  If that's a useful thing to do, it should happen in the generic
> ticketlock code rather than in the per-hypervisor backend (otherwise we
> end up with all kinds of subtle differences in lock behaviour depending
> on the exact environment, which is just going to be messy).  Even if
> interrupts-while-spinning isn't useful on native hardware, it is going
> to be equally applicable to all virtual environments.

While we do interrupt re-enabling in our pv kernels, I intentionally
didn't do this here - it complicates the code quite a bit further, and
that did seem right for an initial submission.

The list really juts is needed to not pointlessly tickle CPUs that
won't own the just released lock next anyway (or would own
it, but meanwhile went for another one where they also decided
to go into polling mode).

Jan

