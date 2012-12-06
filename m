Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946945Ab2LFTTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:19:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30618 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946899Ab2LFTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:19:44 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=KKAkSRfTAAAA:8 a=qyRwAtYM7W7NhZJjX_kA:9 a=PUjeQqilurYA:10 a=WwgC8nHKvroA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354821581.17101.17.camel@gandalf.local.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 14:19:41 -0500
In-Reply-To: <1354817466.30905.13.camel@linaro1.home>
References: <1354817466.30905.13.camel@linaro1.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 18:11 +0000, Jon Medhurst (Tixy) wrote:
> When the generic ftrace implementation modifies code for trace-points it
> uses stop_machine() to call ftrace_modify_all_code() on one CPU. This
> ultimately calls the ARM specific function ftrace_modify_code() which
> updates the instruction and then does flush_icache_range(). As this
> cache flushing only operates on the local CPU then other cores may end
> up executing the old instruction if it's still in their icaches.
> 
> This may or may not cause problems for the use of ftrace on kernels
> compiled for ARM instructions. However, Thumb2 instructions can straddle
> two cache lines so its possible for half the old instruction to be in
> the cache and half the new one, leading to the CPU executing garbage.

Hmm, your use of "may or may not" seems as you may not know this answer.
I wonder if you can use the break point method as x86 does now, and
remove the stop machine completely. Basically this is how it works:

add sw breakpoints to all locations to modify (the bp handler just does
a nop over the instruction).

send an IPI to all CPUs to flush their icache.

Modify the non breakpoint part of the instruction with the new
instruction.

send an IPI to all CPUs to flush their icache

Replace the breakpoint with the finished instruction.

Then you don't suffer the stomp_machine() latency hit. The system will
slow a bit due to the breakpoints but there wont be a huge "halt" in the
middle of processing.

-- Steve

> 
> This patch fixes this situation by providing an arch-specific
> implementation of arch_ftrace_update_code() which ensures that after one
> core has modified all the code, the other cores invalidate their icaches
> before continuing.
> 
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> ---


