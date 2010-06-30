Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0F3Kur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:50:47 -0400
Received: from claw.goop.org ([74.207.240.146]:47814 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab0F3Kuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:50:46 -0400
Message-ID: <4C2B2180.6040401@goop.org>
Date: Wed, 30 Jun 2010 12:50:40 +0200
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jan Beulich <JBeulich@novell.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       ksrinivasan <ksrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks - base
 implementation
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com>	 <1277885133.1868.71.camel@laptop>	 <4C2B23CD0200007800008BFA@vpn.id2.novell.com> <1277889116.1868.95.camel@laptop>
In-Reply-To: <1277889116.1868.95.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 11:11 AM, Peter Zijlstra wrote:
>>> Uhm, I'd much rather see a single alternative implementation, not a
>>> per-hypervisor lock implementation.
>>>       
>> How would you imaging this to work? I can't see how the mechanism
>> could be hypervisor agnostic. Just look at the Xen implementation
>> (patch 2) - do you really see room for meaningful abstraction there?
>>     
> I tried not to, it made my eyes bleed.. 
>
> But from what I hear all virt people are suffering from spinlocks (and
> fair spinlocks in particular), so I was thinking it'd be a good idea to
> get all interested parties to collaborate on one. Fragmentation like
> this hardly ever works out well.
>   

Yes.  Now that I've looked at it a bit more closely I think these
patches put way too much logic into the per-hypervisor part of the code.

> Ah, right, after looking a bit more at patch 2 I see you indeed
> implement a ticket like lock. Although why you need both a ticket and a
> FIFO list is beyond me.
>   

That appears to be a mechanism to allow it to take interrupts while
spinning on the lock, which is something that stock ticket locks don't
allow.  If that's a useful thing to do, it should happen in the generic
ticketlock code rather than in the per-hypervisor backend (otherwise we
end up with all kinds of subtle differences in lock behaviour depending
on the exact environment, which is just going to be messy).  Even if
interrupts-while-spinning isn't useful on native hardware, it is going
to be equally applicable to all virtual environments.

    J
