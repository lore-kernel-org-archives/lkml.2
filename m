Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1I1Pza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:55:30 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60625 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab1I1Pz3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:12:2>);
	Wed, 28 Sep 2011 11:55:29 -0400
Message-Id: <4E835F8C0200007800058461@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 28 Sep 2011 16:55:24 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Stephan Diestelhorst" <stephan.diestelhorst@amd.com>,
        "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Nick Piggin" <npiggin@kernel.dk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        <xen-devel@lists.xensource.com>, "Avi Kivity" <avi@redhat.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>, "KVM" <kvm@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized
	 ticketlocks
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
 <3300108.XQUp9Wrktc@chlor> <4E81FD52.50106@goop.org>
 <CA+55aFx7dv4C4ZB_3CFjdJmX_wpoxecpqo1ARYr1=zTVP=CVVA@mail.gmail.com>
In-Reply-To: <CA+55aFx7dv4C4ZB_3CFjdJmX_wpoxecpqo1ARYr1=zTVP=CVVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.09.11 at 17:38, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Tue, Sep 27, 2011 at 9:44 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>> I guess it comes down to throwing myself on the efficiency of some kind
>> of fence instruction.  I guess an lfence would be sufficient; is that
>> any more efficient than a full mfence?  At least I can make it so that
>> its only present when pv ticket locks are actually in use, so it won't
>> affect the native case.
> 
> Please don't play with fences, just do the final "addb" as a locked 
> instruction.
> 
> In fact, don't even use an addb, this whole thing is disgusting:
> 
>   movzwl (%rdi),%esi (esi:=0x0400)
>   addb   $0x2,(%rdi) (LOCAL copy of lock is now: 0x0402)
>   movzwl (%rdi),%eax (local forwarding from previous store: eax := 0x0402)
> 
> just use "lock xaddw" there too.

I'm afraid that's not possible, as that might carry from the low 8 bits
into the upper 8 ones, which must be avoided.

Jan

