Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0IGNsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:48:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab0IGNsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:48:11 -0400
Message-ID: <4C864281.2020907@redhat.com>
Date: Tue, 07 Sep 2010 16:47:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop>	 <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop>	 <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu>	 <4C84E265.1020402@redhat.com> <20100906125905.GA25414@elte.hu>	 <4C850147.8010908@redhat.com>  <20100906154737.GA4332@elte.hu> <1283866558.5133.73.camel@gandalf.stny.rr.com>
In-Reply-To: <1283866558.5133.73.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/07/2010 04:35 PM, Steven Rostedt wrote:
> On Mon, 2010-09-06 at 17:47 +0200, Ingo Molnar wrote:
>
>>> The actual language doesn't really matter.
>> There are 3 basic categories:
>>
>>   1- Most (least abstract) specific code: a block of bytecode in the form
>>      of a simplified, executable, kernel-checked x86 machine code block -
>>      this is also the fastest form. [yes, this is actually possible.]
>>
>>   2- Least specific (most abstract) code: A subset/sideset of C - as it's
>>      the most kernel-developer-trustable/debuggable form.
>>
>>   3- Everything else little more than a dot on the spectrum between the
>>      first two points.
>>
>> I lean towards #2 - but #1 looks interesting too. #3 is distinctly
>> uninteresting as it cannot be as fast as #1 and cannot be as convenient
>> as #2.
> I would lean to passing a limited assembly language to the kernel, in
> ASCII. This would do the following:
>
> 1) probably the easiest to verify.
>
> 2) we could write a simple interpreter that all archs can use
>
> 3) each arch can have a simple compiler to convert the assembly to
> native byte code to optimize it.
>
>
> The input, output and memory heap can be expressed and the kernel can
> grant or deny any of what is touched.
>
> Now here's some of my concerns for any of this. Using the kvm tracepoint
> as an example:
>
> slot->base_gfn + ((hva - slot->userspace_addr)>>  PAGE_SHIFT)

We can't allow untrusted access to random kernel memory.

Let's take netfilter as an example.  Userspace downloads bytecode to 
determine whether to allow a packet or not, or to mangle it.  The kernel 
exposes APIs to read and write the packet, access the conntrack hash, 
and whatever else is needed.  The bytecode reads the packet, allows, 
denies or mangles to taste, and exits.

> If we were given "slot" and now we need to dereference it to get
> base_gfn or userspace_addr, how would the kernel know this is a valid
> address that can be read? Seems to me that this may allow userspace to
> trivially see parts of the kernel that was never meant to be seen.

I don't understand this example.  Why would you need such bytecode?

For untrusted filters, you only allow access to tracepoint arguments.  
For trusted filters, perhaps, you can allow arbitrary memory access at 
the user's own risk.

> One reason that ftrace only allows root access, is that the kernel is
> best a black box for most userspace.  Letting userspace see how SELinux
> is treating it, and finding addresses that SELinux is using, can give a
> large arsenal to black hats that are writing tools to circumvent Linux
> security.
>
> Unless we only let this interpreter access the inputs and its own
> allocated memory, it will be very difficult to verify what the
> interpreter is doing. I guess one thing we could do is to have a table
> of places in the kernel that we let userspace see. This table will need
> strict scrutinizing to verify that it can't be used to exploit other
> parts of the kernel.

The way I see it, we expose a function pointer vector to the untrusted 
code, similar to the syscall vector.  Trusted code may also see 
functions to access kernel memory (or we just loosen up the validation 
rules).

-- 
error compiling committee.c: too many arguments to function

