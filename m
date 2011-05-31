Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1EaOh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:37:59 -0400
Received: from smtpauth03.mfg.siteprotect.com ([64.26.60.137]:45302 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756777Ab1EaOh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:37:58 -0400
Date: Tue, 31 May 2011 09:49:52 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Vince Weaver <vweaver1@eecs.utk.edu>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org, acme@redhat.com
Subject: Re: perf: [patch] regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <1306826593.2530.7.camel@twins>
Message-ID: <Pine.LNX.4.64.1105310942410.9995@pianoman.cluster.toy>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu> 
 <1306182141.2497.5.camel@laptop>  <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
  <1306233036.2497.15.camel@laptop>  <alpine.DEB.2.00.1105272332400.9313@cl320.eecs.utk.edu>
  <1306578144.1200.1150.camel@twins>  <alpine.DEB.2.00.1105291253270.6774@cl320.eecs.utk.edu>
  <Pine.LNX.4.64.1105302129210.7601@pianoman.cluster.toy> <1306826593.2530.7.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Peter Zijlstra wrote:

> On Mon, 2011-05-30 at 21:33 -0400, Vince Weaver wrote:
> > the problem was the mentioned commit tried to optimize the use of 
> > watermark and wakeup_watermark without taking into account that 
> > wakeup_watermark is a union with wakeup_events. 
> 
> Note that wake_events isn't related to IOC_REFRESH, wake_events is how
> much events to buffer in the mmap-buffer before issuing a wakeup.
> 
> IOC_REFRESH increments event_limit, which is how many events to run
> before disabling yourself.
> 
> What I gather is that due to that SIGIO bug (fixed by f506b3dc0e), you
> had to have both an mmap and a wakeup in order for that signal to
> arrive.

yes, but due to a bug in the mentioned changeset, the buffer watermark 
value was being set to a low value even if *watermark* was 0.  So if you 
were using IOC_REFRESH to set the *wakeup_events* value, it was also 
setting the *wakeup_watermark* value (it's a union) and the buffer setup 
was then unconditionally setting the buffer watermark to the value of the 
supposedly unrelated *wakeup_watermark*.  Normally the wakeup watermark 
would default to something like 2048, but if you were trying to set the 
wakeup_events value to something like 3 then wakeup_watermark would be set 
to that too, causing a lot more overflow events.

I verified all the above painfully using a lot of printks.

I agree this does seem to be a combination of bugs, as even with a 
properlyu set value on affected kernels you'd get spurious watermark 
overflow events if you weren't consuming the ring buffer.

In any case, I can provide a cleaner patch than the one before that isn't 
as intrusive.

I'm also bisecting the other problem I mentioned, the one where overflows 
are 10x too large on 3.0-rc1.  I'm at work with a Nehalem machine so the 
bisect should go faster than the bisect I had to do on an atom machine 
this weekend.  

A power outage over the weekend has taken part of the 
network down here though so my e-mail access is a bit limited, so I 
apologize if I've been missing comments sent to my other e-mail address.

Vince
