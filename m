Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0IGJa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:30:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50826 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0IGJaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:30:52 -0400
Message-ID: <4C860632.7010700@cs.helsinki.fi>
Date: Tue, 07 Sep 2010 12:30:26 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <1283772256.1930.303.camel@laptop> <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop> <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu> <4C84E265.1020402@redhat.com> <20100906125905.GA25414@elte.hu> <4C850147.8010908@redhat.com> <20100906154737.GA4332@elte.hu> <AANLkTikQk0S-mR2Ow2NgdzqAMB0DD05Vd1Th99gNRy8h@mail.gmail.com> <20100907040331.GB14046@elte.hu>
In-Reply-To: <20100907040331.GB14046@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 9/7/10 7:03 AM, Ingo Molnar wrote:
> But i'd prefer C code really, as it's really 'abstract data' in the most
> generic sense. That's why the trace filter engine started with a subset
> of C.

I think it sounds better in principle than what it will be in practice. 
The OpenGL shadling language the same kind of model where you use an API 
call to upload C-like code that gets parsed. That of course has the 
unfortunate side-effect that compilation error reporting isn't all that 
user-friendly because you have to query for errors separately.

I think we've seen with ftrace vs. perf that it's easier to write rich, 
user-friendly interfaces in userspace than in kernel-space.

>> [...] You also probably don't want to put heavy-weight compiler
>> optimization passes in the kernel so with an intermediate form, you
>> can do much of that in user-space.
>
> The question of what can and cannot be done in the kernel is overrated.
> We sure can put a C compiler into the kernel - 10 years down the line we
> wont understand what the fuss was all about.

Yeah, I'm not saying we can't do that but it's a big chunk of code that 
can be potentially exploited.

>> As for the intermediate form, you might want to take a look at Dalvik:
>>
>> http://www.netmite.com/android/mydroid/dalvik/docs/dalvik-bytecode.html
>>
>> and probably ParrotVM bytecode too. The thing to avoid is stack-based
>> instructions like in Java bytecode because although it's easy to write
>> interpreters for them, it makes JIT'ing harder (which needs to convert
>> stack-based representation to register-based) and probably doesn't
>> lend itself well to stack-constrained kernel code.
>
> _If_ we pass in any sort of machine code to the kernel (which bytecode
> really is), then we should do the right thing and pass in raw x86
> bytecode, and verify it in the kernel.
>
> That way the compiler can be kept out of the kernel, and performance of
> the thing will be phenomenal from day 1 on.
>
> For non-x86 in most cases we can use a simple translator that runs
> during the verification run - or of course they could have their own
> native 'assembly bytecode' verifier and their user-space could compile
> to those.

If you'd go for x86 as 'assembly bytecode' which ISA would you pick? 
32-bit or 64-bit? I can see problems with both of them:

   - The register set that can be encoded with 32-bit ISA is very
     limited which will force us to spill in memory.

   - The 64-bit ISA with REX prefixes is unnecessarily fat.

   - Instructions work directly on memory addresses which makes
     verification harder

   - The 32-bit ABI uses stack for argument passing which forces us
     to verify that operations on stack make sense.

OTOH, if the ABI is that you upload _native code_ on every architecture, 
then the trade-off makes more sense to me. The downside is that we'd 
need a separate verifier for each architecture, though.

			Pekka
