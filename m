Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1CPOc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:32:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab1CPOcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:32:25 -0400
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
In-Reply-To: <20110316140242.GB1774@nowhere>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
	 <1300228374.2250.42.camel@laptop> <20110316135308.GA1774@nowhere>
	 <1300283775.2203.1516.camel@twins>  <20110316140242.GB1774@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Mar 2011 15:31:52 +0100
Message-ID: <1300285912.2203.1580.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 15:02 +0100, Frederic Weisbecker wrote:

> The possible usecase is so wide that I have a hard time to find a good
> example. Counting instructions in exceptions on some specific syscalls,
> counting instructions when some lock is taken on some irq handler, or
> whatever...

All of which can be done without the recursion, but ok.

But what you're saying is that you want to be able to build a full
expression tree of events.

Now the things I dislike about the whole thing is that its essentially a
filter, and we already have a filter thing, this adds a second totally
dis-joint filter capability.

Futhermore, you've split the start/stop things, as if they're somehow
different, when in fact they're pretty much the same thing, and you can
even think of more classes like a toggle event or whatever.

You've also split the start/stop events from the regular event lists
making the whole event management and inheritance stuff even more
complicated.

Furthermore, there is a definite possibility for weird behaviour in
there, in that if you're trying to measure a similar event to the one
that is used to enable/disable it, it very much depends on the order of
the demux lists as to which is processed first.


The simply scheme I came up with is having these events be part of the
event_group and add only one field:

  pause_ops : 2

with:

enum perf_event_pause_ops {
  PERF_PAUSE_OP_NOP = 0,
  PERF_PAUSE_OP_INC,
  PERF_PAUSE_OP_DEC,
  PERF_PAUSE_OP_TOGGLE,
};

and have INC increment the parent pause field and clip at INT_MAX, DEC
decrement the pause field and clip at 0, and TOGGLE do ^1.

That however doesn't allow for these full expression trees, so we need
to come up with something else. It does however do away with the
ioctl()s, that redundant flag and the weird event separation.

It is still susceptible to the demux order.


