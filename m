Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1LTI6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 03:58:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47731 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab1LTI6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 03:58:07 -0500
Date: Tue, 20 Dec 2011 09:56:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin <bebl@mageta.org>
Cc: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111220085613.GA3091@elte.hu>
References: <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com>
 <20111218080443.GB4144@elte.hu>
 <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de>
 <20111218234309.GA12958@elte.hu>
 <20111219090923.GB16765@erda.amd.com>
 <20111219105429.GC19861@elte.hu>
 <4EEF1C3B.3010307@redhat.com>
 <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com>
 <4EEF7EC2.5060900@mageta.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEF7EC2.5060900@mageta.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin <bebl@mageta.org> wrote:

> LWP is highly limited in its ability's to support more than 
> one "LWP-Instance" being active for a thread, IOW it is not 
> possible.

That's OK, we can deal with various PMU constraints just fine.

> You can't activate LWP from a threads context and 
> simultaneously activate lwp-system-wide-profiling in the way 
> you suggested it, Ingo. Either do the first xor do the last,

We have other PMU resources that are exclusive in that sense.

> because you only have one xsave-area/msr/lwpcb that is read by 
> the hardware and only one LWP-Buffer that is written by the 
> hw.

That's similar to PEBS (which we already support), there's only 
one Debug Store per CPU, obviously.

> So, if one thread is running LWP, because he wants to 
> (selfmonitoring and stuff [like for what lwp was designed]) 
> and a su or u would activate this system-wide-monitoring, both 
> would frequently interfere with the each other. I don't think 
> you want this to be possible at all.

THe LWPCB is designed to allow multiple events, and the LWP 
ring-buffer is shared between these events.

If the kernel properly manages the lwpcb then no such 
'interference' happens during normal use - both outside and 
self-installed events can be activated at once, up to the event 
limit - similar to how we handle regular PMU events.

[ This is why the threshold IRQ support i requested is key: it 
  is needed for the flow of events and for the kernel 
  event-demultiplexer to work transparently. ]

> Frankly, it was already a pain to get LWP running from 
> in-kernel, like it is done now. I would expect a much higher 
> pain, if you would want to do this with a transparent buffer, 
> that gets passed around each scheduling (and this would 
> permanently eliminate the "lightweight" in "LWP").

There's no heavyweight 'passing around' of a buffer needed at 
context switch time. The buffer context has to be flipped - part 
of the job of context switching.

So no, i don't think any of your objections have any merit.

Thanks,

	Ingo
