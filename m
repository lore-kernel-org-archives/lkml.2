Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab0JFHg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:36:28 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:58325
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932217Ab0JFHg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:36:26 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2cK98dN4015Lzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L9UYFX-02-YP0-02
X-M-MSG: 
Date: Wed, 6 Oct 2010 09:35:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@googlemail.com>
Subject: Re: [RFC 0/3] Basic support for LWP
Message-ID: <20101006073558.GJ13563@erda.amd.com>
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
 <alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
 <20101005145155.GD173@escobedo.osrc.amd.com>
 <alpine.LFD.2.00.1010051730060.2556@localhost6.localdomain6>
 <20101005182739.GE173@escobedo.osrc.amd.com>
 <20101005190501.GA21916@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101005190501.GA21916@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.10.10 15:05:01, Ingo Molnar wrote:

> So thoughts need to be made what the point of it all is and how it 
> integrates into perf. If it doesnt integrate, if the whole plan is to 
> just get it to user-space where it can be messed up freely in some CPU 
> specific way then color me thoroughly uninterested. We have a generic 
> instrumentation framework for a reason.

I was looking at how this integrates into the perf syscall. It might
be a little disappointing, but there is not much to do for the kernel.
Ring buffer handling is implemented in hardware now, the user land
sets up address ranges in the task's address space for buffers and
thus may direct access it. We do not need an interrupt handler to fill
the buffers. The pmu state is saved and restored during context
switches in ways that has been proven for the fpu (xsave) and
virtualization (VMCB like LWPCB). So, overall hardware is now doing
the job for writing samples into a userland buffer and managing the
pmu state. This reduces system overhead while profiling a lot
especially because we don't have to walk through a software stack with
each sample (this is where the 'lightweight' comes from).

Of course this does not fit into current frameworks because of its
difference in concept, but in general we want to see it in perf. So
the main work of integration will leave here to tool and library
implementation. But for this Linux must implement LWP context switch
support. This is what Hans did.

We also measured the system impact which comes from the additional
rdmsrl() if the cpu supports LWP. There is no significant performance
decrease in a worst case scenario. So, this is how we think it is the
best to implement it and we need your feedback here.

I think we should consider to apply patch 1/3 as it is unrelated to
LWP and reworks and improves the code.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

