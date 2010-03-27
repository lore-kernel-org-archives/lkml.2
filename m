Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0C0Ah2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 20:37:28 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53460 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0C0Ah1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 20:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uc5w3sMSn8eBZKZdDtAOppyzU9d2x+NC/c8qbJc1ibKRDmB3cFURkD86SRGkBGO/Ii
         SviLHpWB5CtFzUd+I/N4vE7VKomjAl2JPs4yrT5n0cAdCxa4/PS3oUUBP66dy4YdH1Xh
         Q6F7JJWd1nQF8pbQYV7j8uDoHZhjphD2Ieg/g=
Date: Sat, 27 Mar 2010 01:37:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: Re: [PATCH 08/12] perf: export some syscall metadata
Message-ID: <20100327003724.GJ7166@nowhere>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com> <1264580883-15324-9-git-send-email-tzanussi@gmail.com> <20100223214445.GF5357@nowhere> <1266991243.6427.44.camel@tropicana> <20100225024259.GD7491@nowhere> <1267080695.6611.188.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267080695.6611.188.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 12:51:35AM -0600, Tom Zanussi wrote:
> On Thu, 2010-02-25 at 03:43 +0100, Frederic Weisbecker wrote:
> > On Wed, Feb 24, 2010 at 12:00:43AM -0600, Tom Zanussi wrote:
> > > Re event injection - I don't know that much about it, but if it can be
> > > used for this, could it also be applied to the rest of the trace and
> > > header data too?  If so, that would enable 'live mode' tracing.  I
> > > already have a working prototype that does it by converting all those
> > > things into synthesized pseudo-events, but it would be nicer to use the
> > > event injection framework instead, if I understand it correctly...
> > 
> > 
> > I'm not sure what you mean about live mode tracing. But yeah this
> > about synthetizing pseudo-events. The purpose is to catchup with
> > "past events" or "dead events".
> > 
> > The first trial was for lock_init events. Lock init events send
> > the address of the lock plus its name, so that subsequent lock
> > events (lock acquire, lock_release) can just send the address
> > in the event and not the name which can then be retrieved
> > from past lock_init events.
> > 
> > One problem though: when we enable the lock_init event, we
> > only catch the new locks created. So we need the previously
> > registered locks. There may be severals ways to do that: using
> > a perf ioctl or so, it's still in discussion.
> > 
> > But then for syscalls we would have a kind of dead events
> > catching up by asking the kernel to send us the nr:name
> > pairs.
> > 
> 
> By 'live mode' tracing, I mean feeding the trace stream continuously to
> the script rather than writing it to disk and then later running the
> script on the file data.  Basically something like this:
> 
> $ perf record -e event1 -e event2 -o - | perf trace -s myscript.py -i -
> 
> where the output of perf record is streamed to stdout and piped to the
> the script, which continuously reads and processes events from stdin,
> until the user hits ctrl-c or the script detects some arbitrary pattern
> or condition in the trace stream and stops and prints out the results.
> 
> This would allow a whole new class of use cases e.g. you could easily
> convert any of the current scripts into 'top' versions by adding a timer
> that would display and clear the current results on each tick, say every
> 5 seconds.  Or just actively scan the trace data for some arbitrarily
> complex condition, while also saving the last n trace records and
> dumping them when the condition is found, etc...
> 
> The main obstacle to doing this with the current perf is the header
> data, which in my prototype I've converted into 4 pseudo events - attrs,
> event_types, tracing_data and build_ids, basically getting rid of
> everything than uses a seek, so I can shove it all over a pipe.
> 
> It does seem to me that event injection could be used for this instead
> e.g. similar to the case of lock_init/subsequent lock events, for the
> script to be able to process an event it needs the event information
> contained in the trace_data, which could be sent as an injected event,
> for that subsequent event.  My prototype just sends it all as one huge
> event right now, but if it were broken down into individual events, that
> would also allow new events to be added and removed dynamically.  So in
> addition to 'live mode' we could add 'dynamic' mode as well. :-)
> 
> So yeah, it looks like it would be useful for the syscall names, but
> hopefully much more than that...


Ok, I see what you mean by live mode now.
But I  don't understand why you'd need the injection for that.
If you start a recording, even if it is launched in live mode, you
can parse the necessary format information before, right?

