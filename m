Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab0HDOuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:50:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838Ab0HDOuu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:50:50 -0400
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <20100804140605.GA29371@Krystal>
References: <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
	 <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal>
	 <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal>
	 <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal>
	 <1280855904.1923.675.camel@laptop>
	 <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
	 <1280903273.1923.682.camel@laptop>  <20100804140605.GA29371@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 16:50:10 +0200
Message-ID: <1280933410.1923.1267.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 10:06 -0400, Mathieu Desnoyers wrote:

> The first major gain is the ability to implement flight recorder tracing
> (overwrite mode), which Perf still lacks.

http://lkml.org/lkml/2009/7/6/178

I've send out something like that several times, but nobody took it
(that is, tested it and provided a user). Note how it doesn't require
anything like sub-buffers.

> A second major gain: having these sub-buffers lets the trace analyzer seek in
> the trace very efficiently by allowing it to perform a binary search for time to
> find the appropriate sub-buffer. It becomes immensely useful with large traces.

You can add sync events with a specific magic cookie in. Once you find
the cookie you can sync and start reading it reliably -- the advantage
is that sync events are very easy to have as an option and don't
complicate the reserve path.

> The third major gain: for live streaming of traces, having sub-buffer lets you
> "package" the event data you send over the network into sub-buffers.

See the sync events. Also, a transport can rewrite the stream any which
way it pretty well wants to, as long as the kernel<->user interface is
reliable an unreliable user<->user transport can repackage it to suit
its needs.

> Making sure events don't cross sub-buffer boundaries simplify a lot of things,
> starting with dealing with "overwritten" sub-buffers in flight recorder mode.
> Trying to deal with a partially overwritten event is just insane.

See the above patch, simply parse the events and push the tail pointer
ahead of the reservation before you trample on it.

If you worry about the cost of parsing the events, you can amortize that
by things like keeping the offset of the first event in every page in
the pageframe, or the offset of the next sync event or whatever scheme
you want.

Again, no need for sub-buffers.

Also, not having sub-buffers makes reservation easier since you don't
need to worry about those empty tails.
