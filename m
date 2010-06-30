Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0F3J4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:56:20 -0400
Received: from claw.goop.org ([74.207.240.146]:41126 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab0F3J4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:56:19 -0400
Message-ID: <4C2B14BE.6080505@goop.org>
Date: Wed, 30 Jun 2010 11:56:14 +0200
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
> On Wed, 2010-06-30 at 10:00 +0100, Jan Beulich wrote:
>   
>>>>> On 30.06.10 at 10:05, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>>           
>>> On Tue, 2010-06-29 at 15:31 +0100, Jan Beulich wrote:
>>>       
>>>> Add optional (alternative instructions based) callout hooks to the
>>>> contended ticket lock and the ticket unlock paths, to allow hypervisor
>>>> specific code to be used for reducing/eliminating the bad effects
>>>> ticket locks have on performance when running virtualized.
>>>>         
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

The fastpath of the spinlocks can be common, but if it ends up spinning
too long (however that might be defined), then it needs to call out to a
hypervisor-specific piece of code which is effectively "yield this vcpu
until its worth trying again".  In Xen we can set up an event channel
that the waiting CPU can block on, and the current lock holder can
tickle it when it releases the lock (ideally it would just tickle the
CPU with the next ticket, but that's a further refinement).

I'm not sure what the corresponding implementation for KVM or HyperV
would look like.  Modern Intel chips have a "do a VMEXIT if you've run
pause in a tight loop for too long" feature, which deals with the
"spinning too long" part, but I'm not sure about the blocking mechanism
(something based on monitor/mwait perhaps).

    J
