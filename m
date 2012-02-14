Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2BORpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:45:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11559 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab2BORpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:45:32 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=CvlS4R1r7kYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=0L0fD38RAAAA:8 a=VPITGj-Wx_x99NTzypQA:9 a=inKsXQS5WXIiikbx5UsA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: ftrace_enabled set to 1 on bootup, slow downs with
 CONFIG_FUNCTION_TRACER in virt environments?
From: Steven Rostedt <rostedt@goodmis.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
In-Reply-To: <20120214152955.GA17671@phenom.dumpdata.com>
References: <20120214152955.GA17671@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Feb 2012 13:22:02 -0500
Message-ID: <1329243722.7469.7.camel@acer.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-14 at 10:29 -0500, Konrad Rzeszutek Wilk wrote: 
> Hey,
> 
> I was running some benchmarks (netserver/netperf) where the init script just launched
> the netserver and nothing else and was concerned to see the performance not up to par.
> This was an HVM guest running with PV drivers.
> 
> If I compile the kernel without CONFIG_FUNCTION_TRACER it is much better

There is a known performance degrade of 1 or 2% with function tracing
enabled, on some work loads. Anything more that needs to be
investigated.

Did you also keep FRAME_POINTERS enabled? FUNCTION_TRACER selects frame
pointers which can also slow down the system.

> - but it was 
> my understanding that the tracing code does not impact the machine unless it is enabled.
> And when I inserted a bunch of print_dump_bytes I do see instructions such as
> e8 6a 90 60 e1 get replaced with 66 66 66 90 so I see the the instructions getting
> patched over.

Right on boot up (and module load) the calls do get changed to nops. Now
note that there's some calls that do not get changed at boot up, but the
most recent scripts/recordmcount.c should change them to nops at compile
time.
> 
> To get a better feel for this I tried this on baremetal, and (this is going
> to sound a bit round-about way, but please bear with me), I was working on making
> the pte_flags be paravirt (so it is a function instead of being a macro) and noticed
> that on on an AMD A8-3850, with a CONFIG_PARAVIRT and CONFIG_FUNCTION_TRACER and
> running kernelbench it would run slower than without CONFIG_FUNCTION_TRACER.

Have you tried what the difference is between !CONFIG_PARAVIRT and with
and without CONFIG_FUNCTION_TRACER?

> 
> I am not really sure what the problem is, but based on those experiments
> four things come to my mind:
>  - Lots of nops and we choke the CPU instruction decoder with 20-30 bytes
>    of 'nop', so the CPU is stalling waiting for some real instructions.

But the nop is only placed at the beginning of functions.

> - The compiler has choosen to compile most of the paravirt instructions as
>    functions making the call to mcount (which gets patched over), but the
>    end result is that we have an extra 'call' in the chain.

You mean that we get a lot more functions because the compiler made them
functions? Maybe we should add "notrace" to all paravirt functions? Then
they wont have the calls or nops.

> - Somehow the low-level para-virt (like the assembler ones) calls don't get
>    patched over and still end up calling mcount? (but I really doubt that is the
>    case - but you never know).

We only live patch code in a white list of sections. But with the latest
scripts/recordmcount.c, as I stated above, the ones that don't get
patched at boot up, should be patched at compile time. But that still
keeps the nops there.

> - Something else?
> 
> My thought was to crash the kernel as it is up and running and look at the
> diassembled core to see what the instructions end up looking to get a further feel
> for this.  But before I go with this are there some other ideas of what I should look
> for?

You can just look at the objdump of vmlinux, as the recordmcount.c would
have already patched the code that is not whitelisted, and you can also
see if things are function calls.

-- Steve

> 
> Thanks!
> 
> Note: The "working on making the pte_flags be paravirt" patches are here:
> http://darnok.org/results/baseline_pte_flags_pte_attrs/ if you are interested.



