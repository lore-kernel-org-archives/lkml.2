Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab0EFRLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:11:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61951 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab0EFRLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DWlHQz8UEDWsjEUMc88hwVak9iYrHrdQkQa2tLdgeppEKB+cyMnNUlyz0qTxmbdrLF
         ICLmfeECPlRO7U2qTwFLsILQcR+K7xLwNL9VAqWSBoGTH6TqacdPPl0CvYRII+mGvadc
         Dj4LvldSlta5qcs4dMMgUsjOTSAWDytX7yFyk=
Date: Thu, 6 May 2010 19:11:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU
	utilization
Message-ID: <20100506171141.GA5562@nowhere>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com> <1273155640.5605.300.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273155640.5605.300.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 04:20:40PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-06 at 16:03 +0200, Stephane Eranian wrote:
> > Hi,
> > 
> > Looking at ctx_flexible_sched_in(), the logic is that if  group_sched_in()
> > fails for a HW group, then no other HW group in the list is even tried.
> > I don't understand this restriction. Groups are independent of each other.
> > The failure of one group should not block others from being scheduled,
> > otherwise you under-utilize the PMU.
> > 
> > What is the reason for this restriction? Can we lift it somehow?
> 
> Sure, but it will make scheduling much more expensive. The current
> scheme will only ever check the first N events because it stops at the
> first that fails, and since you can max fix N events on the PMU its
> constant time.
> 
> To fix this issue you'd have to basically always iterate all events and
> only stop once the PMU is fully booked, which reduces to an O(n) worst
> case algorithm.
> 
> But yeah, I did think of making the thing an RB-tree and basically
> schedule on service received, that should fix the lop-sided RR we get
> with constrained events.


I don't understand what you mean by schedule on service received, and why
an rbtree would solve that.

Unless you think about giving a weight to a group that has hardware events.
This weight is the number of "slots" a group would use in the hardware pmu
and you can compare this weight against the available remaining slots
in the pmu?

So yeah, if the hw group of events are sorted by weight, once one fails,
we know the following will fail too. But that doesn't seem a right solution
as it is going to always give more chances to low weight groups and very
fewer opportunities for the heavy ones to be scheduled.

