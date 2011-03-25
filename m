Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab1CYPBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:01:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:33533 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1CYPBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:01:48 -0400
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <AANLkTimNE102hf7=6c1txpKhF+9U=2Yq4RN7X0E=wb28@mail.gmail.com>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
	 <1300228374.2250.42.camel@laptop> <20110316135308.GA1774@nowhere>
	 <1300283775.2203.1516.camel@twins> <20110316140242.GB1774@nowhere>
	 <1300285912.2203.1580.camel@twins>
	 <AANLkTimNE102hf7=6c1txpKhF+9U=2Yq4RN7X0E=wb28@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 16:03:53 +0100
Message-ID: <1301065433.2250.221.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 15:47 +0100, Frederic Weisbecker wrote:

> > Furthermore, there is a definite possibility for weird behaviour in
> > there, in that if you're trying to measure a similar event to the one
> > that is used to enable/disable it, it very much depends on the order of
> > the demux lists as to which is processed first.
> 
> Do you have an example of that? I have some trouble to figure out the
> issue.

Suppose you for some reason or other, gate irq_enter counting with
irq_enter/irq_exit (pretty daft example but hey), they irq_enter will
have two events associated, one trigger and one counter gated by the
trigger.

Now when irq_enter happens, the software event code in
do_perf_sw_event() will iterate the events interested in the event (yay
for naming). If the trigger comes first it will have enabled the gate
and the event will count, if the event comes first then the gate will
still be disabled and we'll not count.

> > The simply scheme I came up with is having these events be part of the
> > event_group and add only one field:
> >
> >  pause_ops : 2
> >
> > with:
> >
> > enum perf_event_pause_ops {
> >  PERF_PAUSE_OP_NOP = 0,
> >  PERF_PAUSE_OP_INC,
> >  PERF_PAUSE_OP_DEC,
> >  PERF_PAUSE_OP_TOGGLE,
> > };
> >
> > and have INC increment the parent pause field and clip at INT_MAX, DEC
> > decrement the pause field and clip at 0, and TOGGLE do ^1.
> >
> > That however doesn't allow for these full expression trees, so we need
> > to come up with something else. It does however do away with the
> > ioctl()s, that redundant flag and the weird event separation.
> 
> That's a great idea! It indeed utterly simplifies the implementation
> and the interface
> and reuse what we already habe.
> This makes me double reconsider the recursive issue now.
> 
> But I'm still worried. I don't know how useful the event tree could be. But
> I have the feeling we are losing a nice and very flexible feature if
> we get rid of it.
> This can be something we solve later if we accept recursive groups may
> be, although
> things may be even more complicated if we take that path.

Yeah, like I said I'm not sure my proposal is any good because of the
limited functionality it provides, but its a different way of looking at
the problem so I provided it.

We'll have to try and explode the issue a bit more to see if there's
anything else we can come up with.

