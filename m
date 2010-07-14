Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0GNXit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:38:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45090 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0GNXir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UxmPRwaglJUxQBedWN6geguz/L8aZQX0yaMjKtX7FJJcT2KYQMKNMEKIkxnH3YmNTX
         myxbUsc+TJmXo8ij5oVOPLXmd+9colUjsMUECTlXfmcIWnoRQHch8rmiGG7JGum5SDF9
         lnnI0ac2Mu3YUYGIznmdBqr8AbNaK9QSpSaYI=
Date: Thu, 15 Jul 2010 01:38:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100714233843.GD14533@nowhere>
References: <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714184642.GA9728@elte.hu> <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com> <20100714193652.GA13630@nowhere> <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com> <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714231117.GA22341@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 07:11:17PM -0400, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Wed, Jul 14, 2010 at 06:31:07PM -0400, Mathieu Desnoyers wrote:
> > > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > > On Wed, Jul 14, 2010 at 12:54:19PM -0700, Linus Torvalds wrote:
> > > > > On Wed, Jul 14, 2010 at 12:36 PM, Frederic Weisbecker
> > > > > <fweisbec@gmail.com> wrote:
> > > > > >
> > > > > > There is also the fact we need to handle the lost NMI, by defering its
> > > > > > treatment or so. That adds even more complexity.
> > > > > 
> > > > > I don't think your read my proposal very deeply. It already handles
> > > > > them by taking a fault on the iret of the first one (that's why we
> > > > > point to the stack frame - so that we can corrupt it and force a
> > > > > fault).
> > > > 
> > > > 
> > > > Ah right, I missed this part.
> > > 
> > > Hrm, Frederic, I hate to ask that but.. what are you doing with those percpu 8k
> > > data structures exactly ? :)
> > > 
> > > Mathieu
> > 
> > 
> > 
> > So, when an event triggers in perf, we sometimes want to capture the stacktrace
> > that led to the event.
> > 
> > We want this stacktrace (here we call that a callchain) to be recorded
> > locklessly. So we want this callchain buffer per cpu, with the following
> > type:
> 
> Ah OK, so you mean that perf now has 2 different ring buffer implementations ?
> How about using a single one that is generic enough to handle perf and ftrace
> needs instead ?
> 
> (/me runs away quickly before the lightning strikes) ;)
> 
> Mathieu


:-)

That's no ring buffer. It's a temporary linear buffer to fill a stacktrace,
and get its effective size before committing it to the real ring buffer.

Sure that involves two copies.

But I don't have a better solution in mind than using a pre-buffer for that,
since we can't know the size of the stacktrace in advance. We could
always reserve the max stacktrace size, but that would be wasteful.

