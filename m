Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab1F0TBC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 15:01:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50008 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1F0S7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 14:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dAtp9gZY2KTSHHujo6RFhMUu5qrufcj9h+tAS/xq8HjDxSv4Riq2XTHKgNBQ3Dfe5P
         AO0J3sqG6UHD9njM6ZJ9OFbFjAyt1wAdtGfZxpB3DJiFhcR8iHROREVVr80q6QswfYeo
         tb5p0kdVVVPJVGSX985jQAqwIQkZXl6G2ofTg=
Date: Mon, 27 Jun 2011 20:59:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@gmail.com>
Subject: Re: perf: is PERF_COUNT_SW_CONTEXT_SWITCHES a kernel or user event?
Message-ID: <20110627185933.GA3726@somewhere>
References: <alpine.DEB.2.00.1106241658420.23095@cl320.eecs.utk.edu>
 <1309171403.6701.77.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309171403.6701.77.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 12:43:23PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-06-24 at 17:03 -0400, Vince Weaver wrote:
> > Hello
> > 
> > the commit included in 2.6.34:
> >   perf: Use hot regs with software sched switch/migrate events
> >   e49a5bd38159dfb1928fd25b173bc9de4bbadb21
> > 
> > Changes the behavior of the PERF_COUNT_SW_CONTEXT_SWITCHES
> > counter.
> > 
> > Before 2.6.34 all of the PERF_COUNT_SW_CONTEXT_SWITCHES events were 
> > counted as happening in userspace (they show up in "perf stat -e cs:u") 
> > but after the commit they always happen in kernelspace ("perf stat -e 
> > cs:k").
> > 
> > Was this intended behavior?
> > I'm writing a validation test for this and want to make sure I get it
> > right.
> > 
> > This can be confusing if your tool defaults to userspace only counts (PAPI 
> > does this).
> 
> hurm, difficult case, like the changelog explains the previous behaviour
> wasn't ideal either. Seems like we want somewhat of a middle ground
> there, but I'm not quite sure how to make that happen.
> 
> Let me ponder things for a bit.

If you consider the strict meaning of exclude_user/exclude_kernel, they exclude
events that _happen_ in user/kernel space. And context switches happen in kernel
space.

Using the resuming ip in userspace if exclude_kernel and the current kernel
ip if exclude_user or default no exclude is a pure arbitrary interpretation of the
exclude things. We could, but I believe it only makes the things confusing for people.

If some users want an option where the event can trigger everywhere but hists are
sorted by the resuming userspace ip, let's tweak the "perf report -s parent" thing
to take the resuming userspace ip from the callchain as the parent and you get
the desired result.

This will have the advantage to keep exclude_* behaviour consistent everywhere and
if we want to have that user resuming ip feature, it will be available for any kind of
events.
