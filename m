Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1JJToH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:44:07 -0400
Received: from claw.goop.org ([74.207.240.146]:41516 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1JJToG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:44:06 -0400
Message-ID: <4E934B01.4040805@goop.org>
Date: Mon, 10 Oct 2011 12:44:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
CC: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "Andi@domain.invalid" <Andi@domain.invalid>,
        Nick Piggin <npiggin@kernel.dk>, KVM <kvm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Kleen <andi@firstfloor.org>,
        Avi Kivity <avi@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the@domain.invalid" <the@domain.invalid>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <4E8DE7F1.3050108@goop.org> <2523929.AGG4U997NO@d-allen> <2222671.j13duhYQpt@d-allen>
In-Reply-To: <2222671.j13duhYQpt@d-allen>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2011 07:01 AM, Stephan Diestelhorst wrote:
> On Monday 10 October 2011, 07:00:50 Stephan Diestelhorst wrote:
>> On Thursday 06 October 2011, 13:40:01 Jeremy Fitzhardinge wrote:
>>> On 10/06/2011 07:04 AM, Stephan Diestelhorst wrote:
>>>> On Wednesday 28 September 2011, 14:49:56 Linus Torvalds wrote:
>>>>> Which certainly should *work*, but from a conceptual standpoint, isn't
>>>>> it just *much* nicer to say "we actually know *exactly* what the upper
>>>>> bits were".
>>>> Well, we really do NOT want atomicity here. What we really rather want
>>>> is sequentiality: free the lock, make the update visible, and THEN
>>>> check if someone has gone sleeping on it.
>>>>
>>>> Atomicity only conveniently enforces that the three do not happen in a
>>>> different order (with the store becoming visible after the checking
>>>> load).
>>>>
>>>> This does not have to be atomic, since spurious wakeups are not a
>>>> problem, in particular not with the FIFO-ness of ticket locks.
>>>>
>>>> For that the fence, additional atomic etc. would be IMHO much cleaner
>>>> than the crazy overflow logic.
>>> All things being equal I'd prefer lock-xadd just because its easier to
>>> analyze the concurrency for, crazy overflow tests or no.  But if
>>> add+mfence turned out to be a performance win, then that would obviously
>>> tip the scales.
>>>
>>> However, it looks like locked xadd is also has better performance:  on
>>> my Sandybridge laptop (2 cores, 4 threads), the add+mfence is 20% slower
>>> than locked xadd, so that pretty much settles it unless you think
>>> there'd be a dramatic difference on an AMD system.
>> Indeed, the fences are usually slower than locked RMWs, in particular,
>> if you do not need to add an instruction. I originally missed that
>> amazing stunt the GCC pulled off with replacing the branch with carry
>> flag magic. It seems that two twisted minds have found each other
>> here :)
>>
>> One of my concerns was adding a branch in here... so that is settled,
>> and if everybody else feels like this is easier to reason about...
>> go ahead :) (I'll keep my itch to myself then.)
> Just that I can't... if performance is a concern, adding the LOCK
> prefix to the addb outperforms the xadd significantly:

Hm, yes.  So using the lock prefix on add instead of the mfence?  Hm.

    J
