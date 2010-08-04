Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab0HDO4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:56:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902Ab0HDO4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:56:53 -0400
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
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
In-Reply-To: <20100804144539.GA4617@Krystal>
References: <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
	 <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal>
	 <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal>
	 <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal>
	 <1280855904.1923.675.camel@laptop> <20100803182556.GA13798@Krystal>
	 <1280904410.1923.700.camel@laptop>  <20100804144539.GA4617@Krystal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 16:56:28 +0200
Message-ID: <1280933788.1923.1281.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 10:45 -0400, Mathieu Desnoyers wrote:

> How do you plan to read the data concurrently with the writer overwriting the
> data while you are reading it without corruption ?

I don't consider reading while writing (in overwrite mode) a valid case.

If you want to use overwrite, stop the writer before reading it.

>  I think that the stack dump
> should simply be saved directly to the ring buffer, without copy. The
> dump_stack() functions might have to be extended so they don't just save text
> dumbly, but can also be used to save events into the trace in binary format,
> perhaps with the continuation cookie Linus was proposing.

Because I don't want to support truncating reservations (because that
leads to large nops for nested events) and when the event needs to go to
multiple buffers you can re-use the stack-dump without having to do the
unwind again.

The problem with the continuation thing Linus suggested is that it would
bloat the output 3 fold. A stack entry is a single u64. If you want to
wrap that in a continuation event you need: a header (u64), a cookie
(u64) and the entry (u64).

Continuation events might make heaps of sense for larger data pieces,
but I don't see them being practical for such small pieces.
