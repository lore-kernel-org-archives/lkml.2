Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab1EYOLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:11:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34792 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab1EYOLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:11:51 -0400
Date: Wed, 25 May 2011 16:11:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] HWPoison: add memory_failure_queue()
Message-ID: <20110525141115.GE19118@elte.hu>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
 <1305619719-7480-6-git-send-email-ying.huang@intel.com>
 <20110517084622.GE22093@elte.hu>
 <4DD23750.3030606@intel.com>
 <20110517092620.GI22093@elte.hu>
 <4DD31C78.6000209@intel.com>
 <20110520115614.GH14745@elte.hu>
 <BANLkTi=5Y0fqsmhsoPm8si=nQBc-tCwtrw@mail.gmail.com>
 <20110522100021.GA28177@elte.hu>
 <4DDCB294.9000405@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDCB294.9000405@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> (2011/05/22 19:00), Ingo Molnar wrote:
> > * huang ying <huang.ying.caritas@gmail.com> wrote:
> >> How to do hardware error recovering in your perf framework?  IMHO, it can be 
> >> something as follow:
> >>
> >> - NMI handler run for the hardware error, where hardware error
> >> information is collected and put into a ring buffer, an irq_work is
> >> triggered for further work
> >> - In irq_work handler, memory_failure_queue() is called to do the real
> >> recovering work for recoverable memory error in ring buffer.
> >>
> >> What's your idea about hardware error recovering in perf?
> > 
> > The first step, the whole irq_work and ring buffer already looks largely 
> > duplicated: you can collect into a perf event ring-buffer from NMI context like 
> > the regular perf events do.
> > 
> > The generalization that *would* make sense is not at the irq_work level really, 
> > instead we could generalize a 'struct event' for kernel internal producers and 
> > consumers of events that have no explicit PMU connection.
> > 
> > This new 'struct event' would be slimmer and would only contain the fields and 
> > features that generic event consumers and producers need. Tracing events could 
> > be updated to use these kinds of slimmer events.
> > 
> > It would still plug nicely into existing event ABIs, would work with event 
> > filters, etc. so the tooling side would remain focused and unified.
> > 
> > Something like that. It is rather clear by now that splitting out irq_work was 
> > a mistake. But mistakes can be fixed and some really nice code could come out 
> > of it! Would you be interested in looking into this?
> 
> Err...?
> 
> Then is it better to write some nice code and throw away the following patch?

No, i think your patch is already a pretty nice simplification of the 
MCE code - using irq_work is obviously better than the open-coded MCE 
vector approach!

These are exactly the kind of small steps towards generalizations 
that i wanted to see: each step without being intrusive and breaking 
stuff and working towards improving the status quo.

Thanks,

	Ingo
