Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab1FGXHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:07:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33511 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab1FGXHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:07:44 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=Yc1t9-nblxEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=GUMpUkg2ANKXgYn302EA:9 a=kx1s7L0ZTkqJEaq_k_IA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTik5yUMVpdPmELMZfmGE=JZRQCQQ2Q@mail.gmail.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
	 <1306519125-19301-1-git-send-email-vnagarnaik@google.com>
	 <alpine.DEB.2.00.1105271618470.9445@chino.kir.corp.google.com>
	 <BANLkTimfdkpY=9pgEmBZwE3ezCmooEtQTA@mail.gmail.com>
	 <1306547453.3857.44.camel@gandalf.stny.rr.com>
	 <BANLkTik5yUMVpdPmELMZfmGE=JZRQCQQ2Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 07 Jun 2011 19:07:41 -0400
Message-ID: <1307488061.9218.16.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 16:46 -0700, Vaibhav Nagarnaik wrote:
> On Fri, May 27, 2011 at 6:50 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 2011-05-27 at 17:44 -0700, Vaibhav Nagarnaik wrote:
> >
> >> That said, I am open to changing it if Steven and you think using
> >> oom_killer_disabled is a better solution.
> >
> > My biggest concern is that we are setting policy in the kernel. If you
> > are concerned about this, why not just have the process that is going to
> > increase the size of the ring buffer adjust its own oom policy
> > with /proc/<pid>/oom_score_adj ? Only a privilege process can increase
> > the size of the ring buffer so it's not like we are worried about any
> > normal user task upping the ring buffer to kill other processes.
> >
> > -- Steve
> 
> You are right. Changing the value of oom_killer_disabled is setting
> kernel policy and I don't like the solution either.
> 
> It would be great if the user always sets oom_score_adj while
> allocating ring buffer memory, but there are different use cases I see
> where it might not be feasible. One is the number of different
> applications which use ftrace and set the ring buffer memory size
> (trace-cmd, perf, powertop, etc). The other case is where a developer
> is setting the size for his own tracing. In all these cases,
> oom_score_adj *should* be set to maximum to be safe, but it a
> developer might forget this step and can de-stabilize the system. This
> is why I think that setting oom_score_adj to maximum in the kernel
> while allocating buffer as well as using __GFP_NORETRY should suffice
> for the end goal of being a good memory citizen.


Hi Vaibhav,

I'm going though patches for v3.1 now. Where are we on this issue. I
still don't really like the ideal of having the kernel set the oom
policy by default. But I'm totally fine with changing the allocations
for NORETRY.

If you switch it to NORETRY, do you still have the issues you were
seeing? You could also add userspace helpers that would set the oom
policy of things accessing the ring buffer.

Either have a script that updates the ring buffer size and sets the oom
policy, or have a library with a helper routine.

Would those be fine for you?

-- Steve



