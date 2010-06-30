Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab0F3N2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:28:14 -0400
Received: from claw.goop.org ([74.207.240.146]:33013 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0F3N2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:28:13 -0400
Message-ID: <4C2B4667.9050103@goop.org>
Date: Wed, 30 Jun 2010 15:28:07 +0200
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Ky Srinivasan <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 1/4, v2] x86: enlightenment for ticket spin locks -	 base
 implementation
References: <4C2A1FE902000078000089E1@vpn.id2.novell.com> <1277885133.1868.71.camel@laptop> <4C2B23CD0200007800008BFA@vpn.id2.novell.com> <1277889116.1868.95.camel@laptop> <4C2B2180.6040401@goop.org> <4C2B4C050200007800008CDB@vpn.id2.novell.com> <4C2B3E42.1070808@goop.org> <4C2B60FE0200007800008D3B@vpn.id2.novell.com>
In-Reply-To: <4C2B60FE0200007800008D3B@vpn.id2.novell.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 03:21 PM, Jan Beulich wrote:
>>>> On 30.06.10 at 14:53, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>>         
>> On 06/30/2010 01:52 PM, Jan Beulich wrote:
>>     
>>> I fail to see that: Depending on the hypervisor's capabilities, the
>>> two main functions could be much smaller (potentially there wouldn't
>>> even be a need for the unlock hook in some cases),
>>>       
>> What mechanism are you envisaging in that case?
>>     
> A simple yield is better than not doing anything at all.
>   

Is that true?  The main problem with ticket locks is that it requires
the host scheduler to schedule the correct "next" vcpu after unlock.  If
the vcpus are just bouncing in and out of the scheduler with yields then
there's still no guarantee that the host scheduler will pick the right
vcpu at anything like the right time.  I guess if a vcpu knows its next
it can plain spin while everyone else yields and that would work
approximately OK.

>>> The list really juts is needed to not pointlessly tickle CPUs that
>>> won't own the just released lock next anyway (or would own
>>> it, but meanwhile went for another one where they also decided
>>> to go into polling mode).
>>>       
>> Did you measure that it was a particularly common case which was worth
>> optimising for?
>>     
> I didn't measure this particular case. But since the main problem
> with ticket locks is when (host) CPUs are overcommitted, it
> certainly is a bad idea to create even more load on the host than
> there already is (the more that these are bursts).
>   

A directed wakeup is important, but I'm not sure how important its
efficiency is (since you're already deep in slowpath if it makes a
difference at all).

    J
