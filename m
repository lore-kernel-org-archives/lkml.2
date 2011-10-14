Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab1JNRCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:02:42 -0400
Received: from claw.goop.org ([74.207.240.146]:52646 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab1JNRCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:02:40 -0400
Message-ID: <4E986B2B.60803@goop.org>
Date: Fri, 14 Oct 2011 10:02:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        konrad.wilk@oracle.com
Subject: Re: [PATCH RFC V5 00/11] Paravirtualized ticketlocks
References: <cover.1318466916.git.jeremy.fitzhardinge@citrix.com> <1318503245.24856.12.camel@twins> <4E971580.6030300@goop.org> <20111014141701.GA2433@redhat.com>
In-Reply-To: <20111014141701.GA2433@redhat.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2011 07:17 AM, Jason Baron wrote:
> On Thu, Oct 13, 2011 at 09:44:48AM -0700, Jeremy Fitzhardinge wrote:
>> pvops is basically a collection of ordinary _ops structures full of
>> function pointers, but it has a layer of patching to help optimise it. 
>> In the common case, this just replaces an indirect call with a direct
>> one, but in some special cases it can inline code.  This is used for
>> small, extremely performance-critical things like cli/sti, but it
>> awkward to use in general because you have to specify the inlined code
>> as a parameterless asm.
>>
> I haven't look at the pvops patching (probably should), but I was
> wondering if jump labels could be used for it? Or is there something
> that the pvops patching is doing that jump labels can't handle?

Jump labels are essentially binary: you can use path A or path B.  pvops
are multiway: there's no limit to the number of potential number of
paravirtualized hypervisor implementations.  At the moment we have 4:
native, Xen, KVM and lguest.

As I said, pvops patching is very general since it allows a particular
op site to be either patched with a direct call/jump to the target code,
or have code inserted inline at the site.  In fact, it probably wouldn't
take very much to allow it to implement jump labels.

And the pvops patching mechanism is certainly general to any *ops style
structure which is initialized once (or rarely) and could be optimised. 
LSM, perhaps?

>> Jump_labels is basically an efficient way of doing conditionals
>> predicated on rarely-changed booleans - so it's similar to pvops in that
>> it is effectively a very ordinary C construct optimised by dynamic code
>> patching.
>>
> Another thing is that it can be changed at run-time...Can pvops be
> adjusted at run-time as opposed to just boot-time?

No.  In general that wouldn't really make sense, because once you've
booted on one hypervisor you're stuck there (though hypothetically you
could consider migration between machines with different hypervisors). 
In some cases it might make sense though, such as switching on PV
ticketlocks if the host system becomes overcommitted, but leaving the
native ticketlocks enabled if not.

    J
