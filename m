Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934363Ab0HFJva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 05:51:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:53117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759021Ab0HFJvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 05:51:25 -0400
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>,
        2nddept-manager@sdl.hitachi.co.jp
In-Reply-To: <4C5BA937.5010504@hitachi.com>
References: <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
	 <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal>
	 <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal>
	 <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal>
	 <1280855904.1923.675.camel@laptop> <20100803182556.GA13798@Krystal>
	 <1280904410.1923.700.camel@laptop>  <20100804144539.GA4617@Krystal>
	 <1280933788.1923.1281.camel@laptop>  <4C5BA937.5010504@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 06 Aug 2010 11:50:40 +0200
Message-ID: <1281088240.1947.357.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 15:18 +0900, Masami Hiramatsu wrote:
> Peter Zijlstra wrote:
> > On Wed, 2010-08-04 at 10:45 -0400, Mathieu Desnoyers wrote:
> > 
> >> How do you plan to read the data concurrently with the writer overwriting the
> >> data while you are reading it without corruption ?
> > 
> > I don't consider reading while writing (in overwrite mode) a valid case.
> > 
> > If you want to use overwrite, stop the writer before reading it.
> 
> For example, would you like to read system audit log always after
> stop the audit?
> 
> NO, that's a most important requirement for tracers, especially for
> system admins (they're the most important users of Linux) to check
> the system health and catch system troubles.
> 
> For performance measurement and checking hotspot, one-shot tracing
> is enough. But it's just for developers. But for the real world
> computing, Linux is just an OS, users want to run their system,
> middleware and applications, without troubles. But when they hit
> a trouble, they wanna shoot it ASAP.
> The flight recorder mode is mainly for those users.

You cannot over-write and consistently read the buffer, that's plain
impossible. With sub-buffers you can swivel a sub-buffer and
consistently read that, but there is no guarantee the next sub-buffer
you steal was indeed adjacent to the previous buffer you stole as that
might have gotten over-written by the active writer while you were
stealing the previous one.

If you want to snapshot buffers, do that, simply swivel the whole trace
buffer, and continue tracing in a new one, then consume the old trace in
a consistent manner.

I really see no value in being able to read unrelated bits and pieces of
a buffer.

So no, I will _not_ support reading an over-write buffer while there is
an active reader.
