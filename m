Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1EGKpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 06:45:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50020 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347Ab1EGKpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 06:45:13 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=UZYI7n2t75YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Z4Rwk6OoAAAA:8 a=1KNPB-2n3HXIAnwKeQ0A:9 a=PUjeQqilurYA:10 a=jbrJJM5MRmoA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110507065803.GA23414@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
	 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
	 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
	 <20110507065803.GA23414@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 07 May 2011 06:45:10 -0400
Message-ID: <1304765110.25414.2564.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-07 at 08:58 +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:

> You have just summed up the main philosophical difference between perf and 
> ftrace: with perf we have a "sane tooling first" approach, while ftrace is 
> still the old "kernel developers first" approach.

I actually believe that the opposite is true.

> 
> In the past 10 years i pushed tons of instrumentation code upstream and for a 
> long time the kernel-integrated ftrace approach looked like the technical best 
> solution to me, but after 2 years of sane instrumentation tooling via a proper 
> user-space ABI and tools/perf/ i'm not looking back.
> 

I would like to point out that the problem with the ABI breakage came
through perf and not ftrace. From what I gathered from Linus's response,
is that, although I made a robust interface (the format of the events)
for tools to use, but it was possible for the tools to use another
interface to directly interact with the raw binary data. Since it was
easier to just map the raw binary data instead of using the exported
format, they did that instead, even though a library already existed to
parse the format and keep the events robust. And the "reality" is that
the raw binary format became the ABI.

With ftrace, there was no easy way to get at that raw format. It was
perf that exposed the raw binary formats that tools like powerTop used.
The "easy" way was just to use the raw binary format as perf made it
easy to access. Thus, instead of spending the time to use the proper
robust format, tools just mapped the raw binary format instead. Peter
Zijlstra, wisely saw this problem and asked me to randomize the fields
to prevent the raw mappings. But that would have broken the ease of use
of TRACE_EVENTS() for kernel developers, or would have drastically
slowed down the trace recording. We both reluctantly kept the fields the
same. Once again, I feel burned because I didn't listen to Peter ;)

Now the end of Linus's email, he gave a slight "but". It seems as though
not many tools are currently accessing the raw data, if all those tools
agree to convert to the proper format before too many others start, then
he may allow this change to take place. I already discussed this with
Arjan, and he agreed to use the libparsevent.so if I can get it packaged
with Fedora and Ubuntu. This is a robust solution, so that we do not get
stuck with things like recording for every single event, the pid,
preempt count, interrupt flags and other things in the kernel forever.


> I am strongly convinced that we need to bite the bullet and unify the two 
> approaches to enable even better tooling: expose the remaining bits of tracing 
> functionality not available via perf yet via the perf ABI and move it under a 
> single umbrella, slowly phase out the ABI-unstable /debug/tracing/ debugfs crap 
> for new features and use the strict perf ABI approach. Steve?

Actually, I now want to separate ftrace from perf even more. This
problem is not a ftrace problem but a perf one. The raw abi that tools
uses is from perf. Thus, that "padding" can be added to perf directly
instead of using the ftrace code, and powertop will still work, and
ftrace can change on the fly as all its tools use the libparsevent
libary.

Here's the choices then:

1) we get libparsevent.so out into the world and all tools can use it,
and the raw formats of the trace events will no longer be an issue as
long as the names of events and fields stay the same.

2) we separate perf from ftrace and keep the "stable" ABI for perf, and
let ftrace advance into a more efficient tracer.

-- Steve


