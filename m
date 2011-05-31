Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab1EaW3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:29:17 -0400
Received: from canuck.infradead.org ([134.117.69.58]:58866 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743Ab1EaW3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:29:16 -0400
Subject: Re: perf: [patch] regression with PERF_EVENT_IOC_REFRESH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, acme@redhat.com
In-Reply-To: <Pine.LNX.4.64.1105310942410.9995@pianoman.cluster.toy>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
	 <1306182141.2497.5.camel@laptop>
	 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
	 <1306233036.2497.15.camel@laptop>
	 <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu>
	 <1306578144.1200.1150.camel@twins>
	 <alpine.DEB.2.00.1105291253270.6774@cl320.eecs.utk.edu>
	 <Pine.LNX.4.64.1105302129210.7601@pianoman.cluster.toy>
	 <1306826593.2530.7.camel@twins>
	 <Pine.LNX.4.64.1105310942410.9995@pianoman.cluster.toy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 31 May 2011 17:52:53 +0200
Message-ID: <1306857173.2353.162.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-31 at 09:49 -0400, Vince Weaver wrote:
> On Tue, 31 May 2011, Peter Zijlstra wrote:
> 
> > On Mon, 2011-05-30 at 21:33 -0400, Vince Weaver wrote:
> > > the problem was the mentioned commit tried to optimize the use of 
> > > watermark and wakeup_watermark without taking into account that 
> > > wakeup_watermark is a union with wakeup_events. 
> > 
> > Note that wake_events isn't related to IOC_REFRESH, wake_events is how
> > much events to buffer in the mmap-buffer before issuing a wakeup.
> > 
> > IOC_REFRESH increments event_limit, which is how many events to run
> > before disabling yourself.
> > 
> > What I gather is that due to that SIGIO bug (fixed by f506b3dc0e), you
> > had to have both an mmap and a wakeup in order for that signal to
> > arrive.
> 
> yes, but due to a bug in the mentioned changeset, the buffer watermark 
> value was being set to a low value even if *watermark* was 0.  So if you 
> were using IOC_REFRESH to set the *wakeup_events* value,

IOC_REFRESH sets event->event_limit, not wakeup_events.

>  it was also 
> setting the *wakeup_watermark* value (it's a union) and the buffer setup 
> was then unconditionally setting the buffer watermark to the value of the 
> supposedly unrelated *wakeup_watermark*.  Normally the wakeup watermark 
> would default to something like 2048, but if you were trying to set the 
> wakeup_events value to something like 3 then wakeup_watermark would be set 
> to that too, causing a lot more overflow events.

poll() wakeups, which were inadvertly linked to SIGIOs

> I verified all the above painfully using a lot of printks.

I prefer to use trace_printk() and /debug/tracing/, that doesn't slow
stuff down as much.

> I agree this does seem to be a combination of bugs, as even with a 
> properlyu set value on affected kernels you'd get spurious watermark 
> overflow events if you weren't consuming the ring buffer.

*nod*

> In any case, I can provide a cleaner patch than the one before that isn't 
> as intrusive.

Appreciated.

> I'm also bisecting the other problem I mentioned, the one where overflows 
> are 10x too large on 3.0-rc1.  I'm at work with a Nehalem machine so the 
> bisect should go faster than the bisect I had to do on an atom machine 
> this weekend.  

It wouldn't be the SIGIO fix would it?, with that every overflow
generates a SIGIO, not only the poll() wakeups. And ouch at bisecting
(or even building a kernel) on an Atom, those things are horridly slow.

> A power outage over the weekend has taken part of the 
> network down here though so my e-mail access is a bit limited, so I 
> apologize if I've been missing comments sent to my other e-mail address.

I'm afraid not, I've been mostly tied up with fixing some scheduler
regressions.

Also, it looks like I just broke stuff even worse in -tip, am bisecting
that now.
