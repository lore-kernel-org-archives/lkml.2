Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1C3BEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:04:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:48544 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab1C3BEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:04:15 -0400
X-AuditID: b753bd60-9f758ba000007e19-1d-4d92818c98e1
X-AuditID: b753bd60-9f758ba000007e19-1d-4d92818c98e1
Message-ID: <4D92818A.8020405@hitachi.com>
Date: Wed, 30 Mar 2011 10:04:10 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC PATCH] perf report: add sort by file lines
References: <1301391136.14111.98.camel@minggr.sh.intel.com> <1301392457.4859.74.camel@twins> <1301417155.3620.8.camel@localhost> <1301418183.2250.416.camel@laptop> <1301418404.2250.417.camel@laptop> <1301418533.2250.419.camel@laptop> <20110329174556.GC24129@ghostprotocols.net>
In-Reply-To: <20110329174556.GC24129@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/30 2:45), Arnaldo Carvalho de Melo wrote:
> Em Tue, Mar 29, 2011 at 07:08:53PM +0200, Peter Zijlstra escreveu:
>> On Tue, 2011-03-29 at 19:06 +0200, Peter Zijlstra wrote:
>>> On Tue, 2011-03-29 at 19:03 +0200, Peter Zijlstra wrote:
>>>>> Is it an unwind of the call frame stack to find out what data member was
>>>>> accessed?
> 
>>>> No need to unwind stacks, DWARF should have information on function
>>>> local stack. It should be able to tell you the type of things like -8(%
>>>> rbp). 
> 
>>> That is, we don't even have a life stack to unwind, so we simply cannot
>>> unwind at all, but the debug information should be able to tell you the
>>> type of whatever would live at a certain stack position if we were to
>>> have a stack.
> 
>> Furthermore, I've now completely exhausted my knowledge of debuginfo and
>> hope Masami and Arnaldo will help with further details ;-)
> 
> :-)
> 
> I think the place to look is 'perf probe', look for the way one
> variable is translated to an expression passed to the kprobe_tracer, I
> think you'll need the reverse operation.
> 
> Look at tools/perf/util/probe-finder.c, function find_variable() and
> convert_variable_location().

Right, perf probe is available for looking up a variable at
an address, however, since it just depends on the dwarf,
we can just know the mapping from (actual) variables to
locations (registers/stacks etc.)

It seems that Peter requires more than that, his request is
getting a map from (temporarily used) register to a specific
member of a data structure pointed by a pointer. But dwarf is
not enough for that.

Peter gave us a good example of that.

> void foo(struct foo *foo, struct tmp *tmp)
> {
>         foo->bar->fubar = tmp->blah;
> }
>
> foo:
> 	.cfi_startproc
> 	pushq	%rbp
> 	.cfi_def_cfa_offset 16
> 	movq	%rsp, %rbp
> 	.cfi_offset 6, -16
> 	.cfi_def_cfa_register 6
> 	movq	%rdi, -8(%rbp)
> 	movq	%rsi, -16(%rbp)
> 	movq	-8(%rbp), %rax    /* load foo arg from stack */
> 	movq	24(%rax), %rax    /* load foo->bar */
> 	movq	-16(%rbp), %rdx   /* load tmp arg from stack */
> 	movl	32(%rdx), %edx    /* load tmp->blah */
> 	movl	%edx, 20(%rax)    /* store bar->fubar */  <<==(1)
> 	leave
> 	ret
> 	.cfi_endproc

At (1), dwarf tells us the location of 'foo' is -8(%rbp) and 'tmp' is
-16(%rbp), but doesn't know to what 20(%rax) is mapped, because
foo->bar->fubar is not a real variable.

So that what we need is a kind of the reverse compiler which generates
intermediate code (a sequence of register assignments) from
instruction code. That's not impossible task, but just hard and fun. :)
For that purpose, we'll need an instruction decoder and an evaluator
which allows us to trace the sequence of address dereferences.

Anyway, I'd recommend that we should start with just showing
the corresponding "source line" of the address. It may be
enough for some cases.

Thank you,


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
