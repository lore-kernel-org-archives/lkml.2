Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab2CHTAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:00:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:41296 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2CHTAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:00:21 -0500
Message-ID: <4F58FEC0.8080706@arm.com>
Date: Thu, 8 Mar 2012 18:47:28 +0000
From: Richard Earnshaw <Richard.Earnshaw@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Dave Martin <dave.martin@linaro.org>,
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
Subject: Re: [PATCH-WIP 01/13] xen/arm: use r12 to pass the hypercall number
 to the hypervisor
References: <alpine.DEB.2.00.1202231714590.23091@kaball-desktop> <1330019314-20865-1-git-send-email-stefano.stabellini@eu.citrix.com> <1330360043.8557.302.camel@zakaz.uk.xensource.com> <20120227180355.GB2023@linaro.org> <1330371219.10008.34.camel@dagon.hellion.org.uk> <20120228102040.GB2063@linaro.org> <1330426133.31269.70.camel@zakaz.uk.xensource.com> <alpine.DEB.2.00.1202281149210.23091@kaball-desktop> <20120229093436.GA2077@linaro.org> <1330509362.4270.20.camel@zakaz.uk.xensource.com> <20120229125826.GC2077@linaro.org> <alpine.LFD.2.02.1203021528150.31242@xanadu.home> <4F5882BF.1030104@arm.com> <alpine.LFD.2.02.1203081041340.24151@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1203081041340.24151@xanadu.home>
X-Enigmail-Version: 1.3.5
X-MC-Unique: 112030818473101502
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/12 17:21, Nicolas Pitre wrote:
> On Thu, 8 Mar 2012, Richard Earnshaw wrote:
>
>> On 02/03/12 21:15, Nicolas Pitre wrote:
>>> So, to me, the gcc documentation is perfectly clear on this topic.
>>> there really _is_ a guarantee that those asm marked variables will be in
>>> the expected registers on entry to the inline asm, given that the
>>> variable is _also_ listed as an operand to the asm statement.  But only
>>> in that case.
>>>
>>> It is true that gcc may reorder other function calls or other code
>>> around the inline asm and then intervening code can clobber any
>>> registers.  Then it is up to gcc to preserve the variable's content
>>> elsewhere when its register is used for other purposes, and restore it
>>> when some inline asm statement is referring to it.
>>>
>>> And if gcc does not do this then it is buggy.  Version 3.4.0 of gcc was
>>> buggy.  No other gcc versions in the last 7 years had such a problem or
>>> the __asmeq macro in the kernel would have told us.
>>>
>>>> Or, to summarise another way, there is no way to control which register
>>>> is used to pass something to an inline asm in general (often we get away
>>>> with this, and there are a lot of inline asms in the kernel that assume
>>>> it works, but the more you inline the more likely you are to get nasty
>>>> surprises).
>>>
>>> This statement is therefore unfounded and wrong.  Please direct the
>>> tools guy who mislead you to the above gcc documentation.
>>>
>>
>> The problem is not really about re-ordering functions but about implicit
>> functions that come from the source code; for example
>>
>> int foo (int a, int b)
>> {
>>   register int x __asm__("r0") = 33;
>>
>>   register int c __asm__("r1") = a / b; /* Ooops, clobbers r0 with
>> division function call.  */
>>
>>   asm ("svc 0" : : "r" (x));
>> }
>>
>> There's nothing in the specification to say what happens if there's a
>> statement in the code that causes an implicit clobber of your assembly
>> register.
>
> I'm sure gcc is full of implicit behaviors that are not mentioned in
> the specification.  But as long as the specification is respected, then
> there is no need to mention any unobservable side effects from a program
> flow point of view, right?
>
> Why wouldn't gcc be able to respect the documented feature by
> preventing live variable from being clobbered and reloading them in
> the specified register at the inline asm entry point, just like it does
> for function calls?
>
> Here's an example code that shows that, unfortunately, gcc is still
> broken with regards to the documented behavior:
>
> extern int bar(int);
> int foo(int y)
> {
>         register int x __asm__("r1") = 33;
>         y += bar(x);
>         asm ("@ x should be live in %0 here" : "+r" (x) : "r" (y));
>         y += bar(x);
>         asm ("@ x should be live in %0 here" : "+r" (x) : "r" (y));
>         return x;
> }
>
> Result is:
>
> foo:
>         stmfd   sp!, {r4, lr}
>         mov     r4, r0
>         mov     r0, #33
>         bl      bar
>         add     r4, r0, r4
>         @ x should be live in r1 here
>         mov     r0, r1
>         bl      bar
>         add     r0, r0, r4
>         @ x should be live in r1 here
>         mov     r0, r1
>         ldmfd   sp!, {r4, lr}
>         bx      lr
>
> To me this is clearly a bug if gcc is not able to meet the documented
> expectation.  And the documented expectation is not at all unreasonable.
>
No, in this case it is presumed that /you/ know that calling bar() will
modify x.  Thus the code is either well defined (if you know what is in
r1 after each call to bar), or undefined (if you can't say anything
about r1 after each call).

As I said, the problem really comes from compiler generated calls which
are not mentioned explicitly in the source code.

R.


--
Richard Earnshaw             Email: Richard.Earnshaw@arm.com
Engineering Manager          Phone: +44 1223 400569 (Direct + VoiceMail)
OpenSource Tools             Switchboard: +44 1223 400400
ARM Ltd                      Fax: +44 1223 400410
110 Fulbourn Rd              Web: http://www.arm.com/
Cambridge, UK. CB1 9NJ

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

