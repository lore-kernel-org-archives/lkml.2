Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0IFUhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 16:37:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53142 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0IFUhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 16:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=aLplrkrJi7yq635zL60GmAcfJRLBmLFLS5KemBFvY1oT3law4lSIeN7RBoyHBMSGZ/
         6j7n4abAu+3bsWUPB7+rzTDGkR3ZrQcUY4dn0PXc8OiIw+rfJte/z3IlpyMhGcMKY5lu
         RL0j137YwNLO2SSnhES6sO+K8ksbwSkN+3cH8=
MIME-Version: 1.0
In-Reply-To: <AANLkTikQk0S-mR2Ow2NgdzqAMB0DD05Vd1Th99gNRy8h@mail.gmail.com>
References: <4C84B088.5050003@redhat.com>
	<1283772256.1930.303.camel@laptop>
	<4C84D1CE.3070205@redhat.com>
	<1283774045.1930.341.camel@laptop>
	<4C84D77B.6040600@redhat.com>
	<20100906124330.GA22314@elte.hu>
	<4C84E265.1020402@redhat.com>
	<20100906125905.GA25414@elte.hu>
	<4C850147.8010908@redhat.com>
	<20100906154737.GA4332@elte.hu>
	<AANLkTikQk0S-mR2Ow2NgdzqAMB0DD05Vd1Th99gNRy8h@mail.gmail.com>
Date: Mon, 6 Sep 2010 23:37:06 +0300
X-Google-Sender-Auth: e8ojHJsVhKSUQeidvOvkTDHzLGw
Message-ID: <AANLkTimsP=qgtoCDg9So=r8tbD+a+ZBJYPEhFUmQ4ZYv@mail.gmail.com>
Subject: Re: disabling group leader perf_event
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 6, 2010 at 6:47 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>> The actual language doesn't really matter.
>>
>> There are 3 basic categories:
>>
>>  1- Most (least abstract) specific code: a block of bytecode in the form
>>    of a simplified, executable, kernel-checked x86 machine code block -
>>    this is also the fastest form. [yes, this is actually possible.]
>>
>>  2- Least specific (most abstract) code: A subset/sideset of C - as it's
>>    the most kernel-developer-trustable/debuggable form.
>>
>>  3- Everything else little more than a dot on the spectrum between the
>>    first two points.
>>
>> I lean towards #2 - but #1 looks interesting too. #3 is distinctly
>> uninteresting as it cannot be as fast as #1 and cannot be as convenient
>> as #2.

2010/9/6 Pekka Enberg <penberg@kernel.org>:
> It's a question where you want to push the complexity of parsing the
> language and verifying the executed code. I'd image it's easier to
> evolve an ABI if we use an intermediate form ("bytecode") on the
> kernel side. Supporting multiple versions of a C-like language is
> probably going to be painful. You also probably don't want to put
> heavy-weight compiler optimization passes in the kernel so with an
> intermediate form, you can do much of that in user-space.
>
> I'm guessing this thing is expected to work on all architectures? If
> that's true, I'd forget about JIT'ing for the time being and write an
> interpreter first because it's much easier to port. There are
> techniques in making an interpreter pretty fast too. Google for
> "inlining interpreter" if you're interested.
>
> As for the intermediate form, you might want to take a look at Dalvik:
>
> http://www.netmite.com/android/mydroid/dalvik/docs/dalvik-bytecode.html
>
> and probably ParrotVM bytecode too. The thing to avoid is stack-based
> instructions like in Java bytecode because although it's easy to write
> interpreters for them, it makes JIT'ing harder (which needs to convert
> stack-based representation to register-based) and probably doesn't
> lend itself well to stack-constrained kernel code.

Btw, the alternative route is to imitate how compilers like tcc and
lcc (and IIRC go and one of the plan9 languages) go about compiling C
language code into native code directly. They are pretty light-weight,
fast, and generate decent code. The down-side is that verification is
going to be more tricky and ABI issues might turn out to be nasty.

                        Pekka
