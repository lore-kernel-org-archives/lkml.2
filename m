Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab1EXK1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 06:27:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:46731 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab1EXK1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 06:27:18 -0400
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
In-Reply-To: <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>
	 <1306182141.2497.5.camel@laptop>
	 <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 12:30:36 +0200
Message-ID: <1306233036.2497.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 02:20 -0400, Vince Weaver wrote:
> On Mon, 23 May 2011, Peter Zijlstra wrote:
> 
> > > before the changeset, you could have a counter group where only one of the 
> > > subevents was sampling.  PERF_EVENT_IOC_REFRESH would correctly enable 
> > > sampling for only that subevent.
> > 
> > But how? it adds to the event_limit of the event you call the ioctl()
> > on, not on any of the group siblings.
> 
> the old behavior did.
> 
> > > With the changeset applied, this fails with EINVALID.  Now you can only 
> > > sample in a group leader.
> > 
> > I'm not quite seeing how group-leaders are relevant here, you can only
> > call this ioctl() on sampling events, regardless of if they're they
> > group leader or a sibling.
> 
> previous behavior was that if you called it on a group leader that wasn't 
> sampling, a sibling event that was sampling would be activated.
> 
> > > Was this an intended change?  It breaks various of our PAPI regression 
> > > tests that worked fine before the change was committed.
> > 
> > I'm not quite seeing what's wrong yet, the change seemed simple enough
> > in that calling that ioctl() on an event that wasn't capable of
> > generating samples doesn't make sense, since it will increase the event
> > limit for the event you call it on.
> 
> attached is some code that will return a sampled count on older kernels
> but gives EINVAL on current kernels.
> 
> The old behavior might have been unintentional, but PAPI unfortunately 
> depends on it (not code I originaly wrote, but code I have to maintain).

Right, so what the code does is create a group of which the leader is
disabled, which effectively has the whole group disabled. It then abuses
REFRESH,0 to enable the leader.

The code should use ENABLE (surprise, surprise!) to enable the leader
and get things going.

This is very clear abuse of the API and I'm not really inclined to fix
it, in fact, I'd be tempted to add an additional test to verify the
argument to REFRESH > 0.

Then again, I do appreciate you're having a problem there, how soon can
you push this trivial fix into all maintained PAPI branches? We could
revert this for one release and then properly shut this abuse down the
next release.

