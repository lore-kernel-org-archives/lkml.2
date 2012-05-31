Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846Ab2EaUKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:10:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24317 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab2EaUKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:10:08 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=nA43mK65oyIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=7S2y3cM3T-zfQrycXc4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338495006.13348.418.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] ftrace: Synchronize variable setting with
 breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 16:10:06 -0400
In-Reply-To: <20120531195529.GA22976@Krystal>
References: <20120531012829.160060586@goodmis.org>
	 <20120531020440.476352979@goodmis.org> <1338462398.28384.52.camel@twins>
	 <1338473302.13348.336.camel@gandalf.stny.rr.com>
	 <1338486029.28384.93.camel@twins>
	 <1338486820.13348.366.camel@gandalf.stny.rr.com>
	 <1338487413.28384.103.camel@twins>
	 <1338490218.13348.379.camel@gandalf.stny.rr.com>
	 <1338491176.28384.114.camel@twins> <20120531195529.GA22976@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 15:55 -0400, Mathieu Desnoyers wrote:

> > Also, why did Mathieu insist on keeping that kmap()?
> 
> Not sure about the entire context here, but the goal of using kmap() is
> to allow modification of text in configurations where the kernel text
> is read-only: the kmap does a temporary shadow RW mapping that allows
> modification of the text. Presumably that Ftrace's 30k changes are done
> before the kernel text mapping is set to read-only ? If this is the
> case, then it is similar to text_poke_early, which don't use the kmap
> since it happens before kernel text gets write-protected. But text_poke
> has to deal with RO pages.

No this is also when ftrace is enabled at runtime. The trick that ftrace
does is to temporarially  convert the kernel text from ro to rw, and
then back to ro when done. You can argue that this degrades the security
of the system, but tracing every function in the kernel does too ;-)
That's why it's a root only utility.

Hmm, this brings up another question. By default, perf does not allow
users to profile trace_events correct? IOW, perf does not let
unprivileged users call text_poke()? I just tried it and got the:

$ ~/bin/perf record -e sched:sched_switch sleep 1
Permission error - are you root?
Consider tweaking /proc/sys/kernel/perf_event_paranoid:
 -1 - Not paranoid at all
  0 - Disallow raw tracepoint access for unpriv
  1 - Disallow cpu events for unpriv
  2 - Disallow kernel profiling for unpriv


> 
> Hopefully my answer makes sense in the context of your discussion.

Almost,

-- Steve

