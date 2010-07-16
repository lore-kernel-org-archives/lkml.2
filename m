Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab0GPWkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:40:47 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43577 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759364Ab0GPWkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:40:33 -0400
Date: Fri, 16 Jul 2010 18:40:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
Message-ID: <20100716224030.GB10427@Krystal>
References: <20100716165855.GA3836@Krystal> <4C409CBA.1050709@redhat.com> <4C409F62.6030303@zytor.com> <4C40A1BD.4040507@redhat.com> <4C40A227.6000207@zytor.com> <4C40A4E8.5090605@redhat.com> <AANLkTinc_of_KYCFt9-8GZYGFLyqQLlgNttPe-YvZn-1@mail.gmail.com> <4C40B277.9030408@redhat.com> <AANLkTimfZb22E7c_ftyc5WfKsGvJKKq-J3Vq8Y6FNvhT@mail.gmail.com> <20100716220730.GH7338@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100716220730.GH7338@basil.fritz.box>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:21:18 up 175 days, 58 min,  6 users,  load average: 0.04,
	0.05, 0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> > And the thing is, if we just do NMI's correctly, and allow nesting,
> > ALL THOSE PROBLEMS GO AWAY. And there is no reason what-so-ever to do
> > stupid things elsewhere.
> 
> One issue I have with nesting NMIs is that you need 
> a nesting limit, otherwise you'll overflow the NMI stack.
> 
> We just got rid of nesting for normal interrupts because
> of this stack overflow problem which hit in real situations.
> 
> In some cases you can get quite high NMI frequencies, e.g. with
> performance counters. Now the current performance counter handlers
> do not nest by themselves of course, but they might nest 
> with other longer running NMI users.
> 
> I think none of the current handlers are likely to nest
> for very long, but there's more and more NMI coded all the time,
> so it's definitely a concern.

We're not proposing to actually "nest" NMIs per se. We copy the stack at the
beginning of the NMI handler (and then use the copy) to permit nesting of faults
over NMI handlers. Following NMIs that would "try" to nest over the NMI handler
would see their regular execution postponed until the end of the currently
running NMI handler. It's OK for these "nested" NMI handlers to use the bottom
of NMI stack because the NMI handler on which they are trying to nest is only
using the stack copy. These "nested" handlers return to the original NMI handler
very early just after setting a "pending nmi" flag. There is more to it (e.g.
handling NMI handler exit atomically with respect to incoming NMIs); please
refer to the last assembly code snipped I sent to Linus a little earlier today
for details.

Thanks,

Mathieu


> 
> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
