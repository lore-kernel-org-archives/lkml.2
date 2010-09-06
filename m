Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab0IFLyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:54:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43900 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0IFLyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:54:17 -0400
Subject: Re: disabling group leader perf_event
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4C84D1CE.3070205@redhat.com>
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop>
	 <4C84D1CE.3070205@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Sep 2010 13:54:05 +0200
Message-ID: <1283774045.1930.341.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-06 at 14:34 +0300, Avi Kivity wrote:
> On 09/06/2010 02:24 PM, Peter Zijlstra wrote:
> > On Mon, 2010-09-06 at 12:12 +0300, Avi Kivity wrote:
> >> If I read the code correctly, disabling a group leader perf_event will
> >> disable the entire group.
> >>
> >> Is this correct?
> > Yeah, pretty much.
> 
> Well, I never liked group_leader style APIs.  I like different types for 
> the container and the contained.  But such is not unix.
> 
> >> If so, how can I disable just the event itself?  Can I allocate a dummy
> >> invent for the group leader so I can enable and disable each perf_event
> >> in the group individually?
> > Which makes me wonder why you use groups in the first place.
> 
> Basically, to read() all events in one go.  I have many of them.
> 
> My current problem is that I have an event (kvm_exit) which I want to 
> drill down by looking at a field (exit_reason).  So I create lots of 
> separate perf_events with a filter for each reason: 
> kvm_exit(exit_reason==0), kvm_exit(exit_reason==1), etc.  But filters 
> are fairly slow (can have ~60 such events on AMD), so I want to make 
> this drill-down optional.

Yeah, filters suck.

So what you're basically trying to do is create some histogram of
exit_reason?

Being able to make histograms in-kernel has been on the todo list for a
long while, its just that I never could come up with a sane
interface.. :/

> Current plan is to have a group for the basic events and another group 
> for the drilldown events (each per-cpu), and activate the drilldown 
> group on user request.  perf will be able to schedule both groups 
> concurrently since they only contain tracepoints, yes?

More or less, yeah (the scheduling of software and hardware events isn't
properly separated atm -- am working on that). Software events have no
scheduling constraints and should always get scheduled.


