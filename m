Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423692Ab2LGSGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:06:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26768 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423611Ab2LGSGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:06:10 -0500
X-Authority-Analysis: v=2.0 cv=dttZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=6CAq29ZHfH_6C56vKmQA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354903568.17101.65.camel@gandalf.local.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 13:06:08 -0500
In-Reply-To: <1354902347.8263.12.camel@linaro1.home>
References: <1354817466.30905.13.camel@linaro1.home>
	 <1354821581.17101.17.camel@gandalf.local.home>
	 <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
	 <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
	 <1354900436.17101.58.camel@gandalf.local.home>
	 <1354902347.8263.12.camel@linaro1.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 17:45 +0000, Jon Medhurst (Tixy) wrote:
> On Fri, 2012-12-07 at 12:13 -0500, Steven Rostedt wrote:
> > I'll make my question more general:
> > 
> > If I have a nop, that is a size of a call (branch and link), which is
> > near the beginning of a function and not part of any conditional, and I
> > want to convert it into a call (branch and link), would adding a
> > breakpoint to it, modifying it to the call, and then removing the
> > breakpoint be possible? Of course it would require syncing in between
> > steps, but my question is, if the above is possible on a thumb2 ARM
> > processor?
> 
> I believe so. The details are (repeating your earlier explanation) ...
> 
> 1. Replace first half of nop with 16bit 'breakpoint' instruction.
> 
> 2. Sync.(cache flush to PoU + IPIs to make other cores invalidate the
> icache for changed part of the nop instruction).
> 
> 3. Replace second half of nop with second half of the call instruction.
> 
> 4. Sync.
> 
> 5. Replace the breakpoint with the first half of the call instruction.
> 
> 6. Sync
> 
> And if any core execute the breakpoint instruction, then the handler
> ensures execution continues at the instruction after the nop were trying
> to replace.

Exactly!

> 
> However, wouldn't we need any of this breakpoint malarkey, why not just
> just use a 16-bit branch instruction which branches over the second half
> of the nop? :-)

If you can get away with that, sure. Or better yet. If the arch supports
it, you can do what I did with powerpc. That was just replace the nop
with the 32bit branch, and the 32bit branch with a 32bit nop. No nops.
No multiple steps in between. I just did the swap of all function
tracepoints in one fell swoop, and then did the icache sync.

Now that's if the arch doesn't have issues with swapping code like this.
Can a 32bit branch-and-link be spread across cache lines? On x86 the
call is 5 bytes and can be. Thus, we were forced to do the breakpoint
because we don't know how the instructions are laid out on the cache
lines.

If 32bit can't be swapped but 16bit never crosses cache lines, then your
approach may also work.

-- Steve



