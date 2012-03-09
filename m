Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab2CIP6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:58:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40022 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab2CIP6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:58:05 -0500
MIME-Version: 1.0
In-Reply-To: <4F58FEC0.8080706@arm.com>
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop>
	<1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com>
	<1330360043.8557.302.camel@zakaz.uk.xensource.com>
	<20120227180355.GB2023@linaro.org>
	<1330371219.10008.34.camel@dagon.hellion.org.uk>
	<20120228102040.GB2063@linaro.org>
	<1330426133.31269.70.camel@zakaz.uk.xensource.com>
	<alpine.DEB.2.00.1202281149210.23091@kaball-desktop>
	<20120229093436.GA2077@linaro.org>
	<1330509362.4270.20.camel@zakaz.uk.xensource.com>
	<20120229125826.GC2077@linaro.org>
	<alpine.LFD.2.02.1203021528150.31242@xanadu.home>
	<4F5882BF.1030104@arm.com>
	<alpine.LFD.2.02.1203081041340.24151@xanadu.home>
	<4F58FEC0.8080706@arm.com>
Date: Fri, 9 Mar 2012 15:58:03 +0000
Message-ID: <CA+wbFdfF5c+Bw6RrxCm3YThqCRDuDYzanq+HV8a6LyXaBqWrQA@mail.gmail.com>
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
From: Dave Martin <dave.martin@linaro.org>
To: Richard Earnshaw <Richard.Earnshaw@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 6:47 PM, Richard Earnshaw
<Richard.Earnshaw@arm.com> wrote:
> On 08/03/12 17:21, Nicolas Pitre wrote:
>> On Thu, 8 Mar 2012, Richard Earnshaw wrote:
>>
>>> On 02/03/12 21:15, Nicolas Pitre wrote:
>>>> So, to me, the gcc documentation is perfectly clear on this topic.
>>>> there really _is_ a guarantee that those asm marked variables will be in
>>>> the expected registers on entry to the inline asm, given that the
>>>> variable is _also_ listed as an operand to the asm statement.  But only
>>>> in that case.
>>>>
>>>> It is true that gcc may reorder other function calls or other code
>>>> around the inline asm and then intervening code can clobber any
>>>> registers.  Then it is up to gcc to preserve the variable's content
>>>> elsewhere when its register is used for other purposes, and restore it
>>>> when some inline asm statement is referring to it.
>>>>
>>>> And if gcc does not do this then it is buggy.  Version 3.4.0 of gcc was
>>>> buggy.  No other gcc versions in the last 7 years had such a problem or
>>>> the __asmeq macro in the kernel would have told us.
>>>>
>>>>> Or, to summarise another way, there is no way to control which register
>>>>> is used to pass something to an inline asm in general (often we get away
>>>>> with this, and there are a lot of inline asms in the kernel that assume
>>>>> it works, but the more you inline the more likely you are to get nasty
>>>>> surprises).
>>>>
>>>> This statement is therefore unfounded and wrong.  Please direct the
>>>> tools guy who mislead you to the above gcc documentation.
>>>>
>>>
>>> The problem is not really about re-ordering functions but about implicit
>>> functions that come from the source code; for example
>>>
>>> int foo (int a, int b)
>>> {
>>>   register int x __asm__("r0") = 33;
>>>
>>>   register int c __asm__("r1") = a / b; /* Ooops, clobbers r0 with
>>> division function call.  */
>>>
>>>   asm ("svc 0" : : "r" (x));
>>> }
>>>
>>> There's nothing in the specification to say what happens if there's a
>>> statement in the code that causes an implicit clobber of your assembly
>>> register.
>>
>> I'm sure gcc is full of implicit behaviors that are not mentioned in
>> the specification.  But as long as the specification is respected, then
>> there is no need to mention any unobservable side effects from a program
>> flow point of view, right?
>>
>> Why wouldn't gcc be able to respect the documented feature by
>> preventing live variable from being clobbered and reloading them in
>> the specified register at the inline asm entry point, just like it does
>> for function calls?
>>
>> Here's an example code that shows that, unfortunately, gcc is still
>> broken with regards to the documented behavior:
>>
>> extern int bar(int);
>> int foo(int y)
>> {
>>         register int x __asm__("r1") = 33;
>>         y += bar(x);
>>         asm ("@ x should be live in %0 here" : "+r" (x) : "r" (y));
>>         y += bar(x);
>>         asm ("@ x should be live in %0 here" : "+r" (x) : "r" (y));
>>         return x;
>> }
>>
>> Result is:
>>
>> foo:
>>         stmfd   sp!, {r4, lr}
>>         mov     r4, r0
>>         mov     r0, #33
>>         bl      bar
>>         add     r4, r0, r4
>>         @ x should be live in r1 here
>>         mov     r0, r1
>>         bl      bar
>>         add     r0, r0, r4
>>         @ x should be live in r1 here
>>         mov     r0, r1
>>         ldmfd   sp!, {r4, lr}
>>         bx      lr
>>
>> To me this is clearly a bug if gcc is not able to meet the documented
>> expectation.  And the documented expectation is not at all unreasonable.
>>
> No, in this case it is presumed that /you/ know that calling bar() will
> modify x.  Thus the code is either well defined (if you know what is in
> r1 after each call to bar), or undefined (if you can't say anything
> about r1 after each call).

It could be argued that since the set of registers involved in the PCS
are well-known, then if the programmer assigns a variable to one of
those registers, then that is a conscious aliasing of the variable
with a global register which can be destroyed at any time as a
consequence of the ABI.  Because there are few guarantees about how
the compiler will or won't transform the code, this suggessts that
asm("rX") annotations can't work reliably for r0-r3 or r12 with the
ARM PCS.

Indeed, the GCC docs do in fact have this to say:

    "register int *p1 asm ("r0") = ...;
    register int *p2 asm ("r1") = ...;
    register int *result asm ("r0");
    asm ( [...] );

[...] beware that a register that is call-clobbered by the target ABI
will be overwritten by any function call in the assignment including
library calls for arithmetic operators.  Also a register may be
clobbered when generating some operations, like variable shift, memory
copy or memory move on x86.  Assuming it is a call-clobbered register,
this may happen to `r0' above by the assignment to `p2'.  Ig you have
to use such a register, use temporary variables for expressions
between the register assignment and use:

    int t1 = ...;
    register int *p1 asm("r0") = ...;
    register int *p2 asm("r1") = t1;
    register int *result asm("r0");
    asm ( [...] )"

But this is at least somewhat in conflict with "The compiler's data
flow analysis is capable of determining where the specified registers
contain live values, and where they are available for other uses."

It also seems to assume -O0 type behaviour where the compiler is doing
a straightforward sequential translation of the code.  Why it is
guaranteed that the assignment to p2 now certainly does not clobber p1
(even as a side effect), what the implied aliasing of result with p1
actually guarantees (or whether the compiler really understands it at
all); or what constraints there are on the compiler reordering or
inserting random extraneous code into the above, I have no idea.  Such
assumptions don't feel very safe in the presence of optimisation.

In other words, all sorts of undocumented guarantees beyond the C
language are needed for it even to be possible to interpret what the
above code examples should mean in the first place.

The documentation leaves a lot of questions unanswered, but it does at
least suggest that other arches have the same kind of potential
pitfalls that we observed on ARM.


Register variables feel like a red herring though.  We're only using
those because we can't do the needful thing and actually desscribe
these constraints in the asm constraints (which would seem to be the
right place).  We specifically don't care where those values are
except at the boundaries of the asm block itself.

Is there a reason why ARM gcc doesn't provide the ability to specify
such exact-register constraints, or is this more for historical
reasons?  It is possible?

Cheers
---Dave
