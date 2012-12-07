Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2LGUBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 15:01:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29798 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2LGUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 15:01:44 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=0q0mCv_Vr9gA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrIq2vSOvhQA:10 a=2AmJpYytKEAYMiNU5bAA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354910502.17101.89.camel@gandalf.local.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 07 Dec 2012 15:01:42 -0500
In-Reply-To: <20121207190244.GB29618@mudshark.cambridge.arm.com>
References: <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
	 <20121207162346.GW14363@n2100.arm.linux.org.uk>
	 <1354898200.17101.50.camel@gandalf.local.home>
	 <20121207164530.GX14363@n2100.arm.linux.org.uk>
	 <1354900436.17101.58.camel@gandalf.local.home>
	 <20121207181309.GY14363@n2100.arm.linux.org.uk>
	 <1354905805.17101.86.camel@gandalf.local.home>
	 <20121207190244.GB29618@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 19:02 +0000, Will Deacon wrote:

> For ARMv7, there are small subsets of instructions for ARM and Thumb which
> are guaranteed to be atomic wrt concurrent modification and execution of
> the instruction stream between different processors:
> 
> Thumb:	The 16-bit encodings of the B, NOP, BKPT, and SVC instructions.
> ARM:	The B, BL, NOP, BKPT, SVC, HVC, and SMC instructions.
> 
> but before your eyes light up at the presence of the BKPT instruction in
> that list; we don't actually use that in Linux and instead leave it for
> external (i.e. JTAG) debuggers so that they can operate without getting
> tangled up with spurious traps from the OS. Linux actually picks its own
> undefined instructions, which are obviously not included in the lists above.

My eyes actually lit up with the B instruction :-)  As Jon showed, we
could use a 16bit jump instead. Add the B to jump over the other half of
the call (to all places that you want to modify). Send a sync to all
CPUs to flush their caches. Modify the other half of the call, send
another sync, and then modify the first half.

> 
> Also note that the 16-bit limitation for Thumb instructions above can
> actually be used to modify *half* of a BL instruction but, to keep things
> exciting, the PC-relative immediate is split across the two halves. However,
> you could in theory mess around with bottom 10 bits or so, depending on the
> exact encoding...
> 
> Obviously this doesn't preclude the need for cache maintenance on both D and
> I side, but the atomicity guarantees are as I've described above.

Right. Thanks for the update.

-- Steve


