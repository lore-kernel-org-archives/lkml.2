Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1CYOrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 10:47:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60273 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1CYOrW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 10:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=luffojfcOM7XiDKXKYtr51eMugrxqRG6z4MP1x2DuZt90Gr5Yj4SCEwg9R5uwBw2y5
         dIWg2eq0oTc7QZzHVDirxxnIh8rGd8oRAjhyM4CuES83kB/8rbyRuLZ4peR1lHyb2hmR
         TVpUT1OYbeWGGQBEtYghhTeJZg4DcwVxMRdxo=
MIME-Version: 1.0
In-Reply-To: <1300285912.2203.1580.camel@twins>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
	<1300228374.2250.42.camel@laptop>
	<20110316135308.GA1774@nowhere>
	<1300283775.2203.1516.camel@twins>
	<20110316140242.GB1774@nowhere>
	<1300285912.2203.1580.camel@twins>
Date: Fri, 25 Mar 2011 15:47:20 +0100
Message-ID: <AANLkTimNE102hf7=6c1txpKhF+9U=2Yq4RN7X0E=wb28@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/16 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Wed, 2011-03-16 at 15:02 +0100, Frederic Weisbecker wrote:
>
>> The possible usecase is so wide that I have a hard time to find a good
>> example. Counting instructions in exceptions on some specific syscalls,
>> counting instructions when some lock is taken on some irq handler, or
>> whatever...
>
> All of which can be done without the recursion, but ok.
>
> But what you're saying is that you want to be able to build a full
> expression tree of events.

Yep.

>
> Now the things I dislike about the whole thing is that its essentially a
> filter, and we already have a filter thing, this adds a second totally
> dis-joint filter capability.
>
> Futhermore, you've split the start/stop things, as if they're somehow
> different, when in fact they're pretty much the same thing, and you can
> even think of more classes like a toggle event or whatever.

Indeed, there are a lot of code duplications I wanted to clean up into
some toggle thing. Just wanted to get an early ping about the design
first. And I was right :)

> You've also split the start/stop events from the regular event lists
> making the whole event management and inheritance stuff even more
> complicated.

Agreed. I wish we can solve that too.

> Furthermore, there is a definite possibility for weird behaviour in
> there, in that if you're trying to measure a similar event to the one
> that is used to enable/disable it, it very much depends on the order of
> the demux lists as to which is processed first.

Do you have an example of that? I have some trouble to figure out the
issue.

>
> The simply scheme I came up with is having these events be part of the
> event_group and add only one field:
>
>  pause_ops : 2
>
> with:
>
> enum perf_event_pause_ops {
>  PERF_PAUSE_OP_NOP = 0,
>  PERF_PAUSE_OP_INC,
>  PERF_PAUSE_OP_DEC,
>  PERF_PAUSE_OP_TOGGLE,
> };
>
> and have INC increment the parent pause field and clip at INT_MAX, DEC
> decrement the pause field and clip at 0, and TOGGLE do ^1.
>
> That however doesn't allow for these full expression trees, so we need
> to come up with something else. It does however do away with the
> ioctl()s, that redundant flag and the weird event separation.

That's a great idea! It indeed utterly simplifies the implementation
and the interface
and reuse what we already habe.
This makes me double reconsider the recursive issue now.

But I'm still worried. I don't know how useful the event tree could be. But
I have the feeling we are losing a nice and very flexible feature if
we get rid of it.
This can be something we solve later if we accept recursive groups may
be, although
things may be even more complicated if we take that path.

Thanks.
