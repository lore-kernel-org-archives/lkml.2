Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2KMU7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 15:59:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12797 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab2KMU67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 15:58:59 -0500
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MbCFXo7hY28A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=2HxqKFuZ9XIA:10 a=Olpd5A85YGfAUBk8Mi4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352840337.18025.43.camel@gandalf.local.home>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Steven Rostedt <rostedt@goodmis.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <will.deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>
Date: Tue, 13 Nov 2012 15:58:57 -0500
In-Reply-To: <509DB632.7070305@linaro.org>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop> <509DB632.7070305@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-09 at 18:04 -0800, John Stultz wrote:
> On 10/16/2012 10:23 AM, Peter Zijlstra wrote:

> > I've no problem with adding CLOCK_PERF (or another/better name).
> Hrm. I'm not excited about exporting that sort of internal kernel 
> details to userland.
> 
> The behavior and expectations from sched_clock() has changed over the 
> years, so I'm not sure its wise to export it, since we'd have to 
> preserve its behavior from then on.
> 
> Also I worry that it will be abused in the same way that direct TSC 
> access is, where the seemingly better performance from the more 
> careful/correct CLOCK_MONOTONIC would cause developers to write fragile 
> userland code that will break when moved from one machine to the next.
> 
> I'd probably rather perf output timestamps to userland using sane clocks 
> (CLOCK_MONOTONIC), rather then trying to introduce a new time domain to 
> userland.   But I probably could be convinced I'm wrong.

I'm surprised that perf has its own clock anyway. But I would like to
export the tracing clocks. We have three (well four) of them:

trace_clock_local() which is defined to be a very fast clock but may not
be synced with other cpus (basically, it just calls sched_clock).

trace_clock() which is not totally serialized, but also not totally off
(between local and global). This uses local_clock() which is the same
thing that perf_clock() uses.

trace_clock_global() which is a monotonic clock across CPUs. It's much
slower than the above, but works well when you require synced
timestamps.

There's also trace_clock_counter() which isn't even a clock :-)  It's
just a incremental atomic counter that goes up every time it's called.
This is the most synced clock, but is absolutely meaningless for
timestamps. It's just a way to show ordered events.

-- Steve


