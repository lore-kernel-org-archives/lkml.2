Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0F3NXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:23:54 -0400
Received: from claw.goop.org ([74.207.240.146]:46559 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0F3NXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:23:53 -0400
Message-ID: <4C2B4564.7030203@goop.org>
Date: Wed, 30 Jun 2010 15:23:48 +0200
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Ky Srinivasan <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -	 Xen
  implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com> <4C2B1769.5090107@goop.org> <4C2B47190200007800008CB7@vpn.id2.novell.com>
In-Reply-To: <4C2B47190200007800008CB7@vpn.id2.novell.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 01:31 PM, Jan Beulich wrote:
>>>> On 30.06.10 at 12:07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>>>         
>> On 06/29/2010 04:32 PM, Jan Beulich wrote:
>>     
>>> Use the (alternative instructions based) callout hooks to the ticket
>>> spinlock code to enlighten ticket locks when running fully virtualized
>>> on Xen. Ultimately, this code might also be a candidate to be used
>>> when running para-virtualized.
>>>   
>>>       
>> I'm not sure what the gain is by making this independent of all the rest
>> of the Xen support in the kernel.  Stefano is working on a series
>> (posted a few times now) to add more paravirtual features for Xen HVM
>> guests, and this work is conceptually very similar.
>>     
> The intention really is for PARAVIRT_SPINLOCKS to go away as soon
> as pv-ops Xen can be switched over to this mechanism.
>   

I don't see the point of having two distinct implementations of
paravirtualization, especially since they have similar mechanisms
(patching, etc).

>> Also, I'm not very keen on adding yet another kind of patching mechanism
>> to the kernel.  While they're easy enough to get working in the first
>> place, they do tend to be fragile when other changes get introduced
>> (like changes to how the kernel is mapped RO/NX, etc), and this one will
>> be exercised relatively rarely.  I don't see why the pvops mechanism
>> couldn't be reused, especially now that each set of ops can be
>> individually configured on/off.
>>     
> Wasn't the main complaint with using pvops patching that it
> introduced extra calls into the native execution path? The point
> of this "new" (it's not really new, it's using existing infrastructure)
> mechanism is just to avoid such overhead for native.
>   

When a particular class of pv calls is enabled in the config file, then
their baseline overhead amounts to a 6 byte nop.  When in use, they are
a direct call (or <= 6 bytes of inlined instruction).  It's possible to
add more padding space if its important to have larger inlined sequences.

For spinlocks, the pvop calls should only be in the slow case: when a
spinlock has been spinning for long enough, and on unlock when there's
someone waiting for the lock.  The fastpath (no contention lock and
unlock) should have no extra calls.

So I don't think pvops overhead is really an issue here.  Certainly I
don't think its worth prematurely optimising for.

>> This is especially acute in the case where you are using a full
>> pvops-using PV kernel, where it ends up using two mechanisms to put
>> paravirtualizations in place.
>>     
> And I see nothing wrong with this - if the individual pieces are
> separate anyway, why shouldn't each of them use the most
> efficient technique?

Pluralitas non est ponenda sine necessitate.

Each of them doesn't need the most efficient technique, as that just
multiplies the number of different mechanisms which need to be
maintained.  New mechanisms should only be introduced if one of the
existing ones is really, clearly, deficient.

>  Or if a single mechanism is desirable, shouldn't
> one rather ask to convert the newer pvops patching mechanism
> to the alternative instruction patching one, as that had been in
> place long before?

pvops is a superset of alternative instruction patching, and are really
designed to serve different purposes.  There are some areas in which
there's some overlap, but otherwise they are distinct.  In particular,
alternative instructions are really only useful if you can express the
patch in terms of the presence or absence of a particular cpu feature. 
It can't do multi-way choice, and it can't do anything other than insert
literal instructions.  pvops patching can do multi-way, and has a
higher-level view of each patch site which allows it to do things like
generate appropraite save/restores, make inline vs call decisions, nop
out nop callsites, etc.

    J
