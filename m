Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1ASSbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:31:13 -0500
Received: from claw.goop.org ([74.207.240.146]:59329 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab1ASSbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:31:11 -0500
Message-ID: <4D372DEA.1060004@goop.org>
Date: Wed, 19 Jan 2011 10:31:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Eric Dumazet <dada1@cosmosbay.com>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        suzuki@in.ibm.com
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com> <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com> <20110117152222.GA19233@linux.vnet.ibm.com>
In-Reply-To: <20110117152222.GA19233@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2011 07:22 AM, Srivatsa Vaddagiri wrote:
> On Tue, Nov 16, 2010 at 01:08:44PM -0800, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> Maintain a flag in both LSBs of the ticket lock which indicates whether
>> anyone is in the lock slowpath and may need kicking when the current
>> holder unlocks.  The flags are set when the first locker enters
>> the slowpath, and cleared when unlocking to an empty queue.
>>
>> In the specific implementation of lock_spinning(), make sure to set
>> the slowpath flags on the lock just before blocking.  We must do
>> this before the last-chance pickup test to prevent a deadlock
>> with the unlocker:
>>
>> Unlocker			Locker
>> 				test for lock pickup
>> 					-> fail
>> test slowpath + unlock
>> 	-> false
>> 				set slowpath flags
>> 				block
>>
>> Whereas this works in any ordering:
>>
>> Unlocker			Locker
>> 				set slowpath flags
>> 				test for lock pickup
>> 					-> fail
>> 				block
>> test slowpath + unlock
>> 	-> true, kick
> I think this is still racy ..
>
> Unlocker				Locker
>
> 				
> test slowpath
> 	-> false
> 		
> 				set slowpath flag
> 				test for lock pickup
> 					-> fail
> 				block
>
>
> unlock
>
> unlock needs to happen first before testing slowpath? I have made that change
> for my KVM guest and it seems to be working well with that change .. Will
> cleanup and post my patches shortly

I think you're probably right; when I last tested this code, it was
hanging in at about the rate this kind of race would cause.  And in my
previous analysis of similar schemes (the current pv spinlock code), it
was always correct to do the "slowpath" test after doing do the unlock.

*But* I haven't yet had the chance to specifically go through and
analyse your patch in detail to make sure there's nothing else going on,
so take this as provisional.

How much testing have you given it?

Thanks,
    J
