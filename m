Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1BWRRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 12:17:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37266 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1BWRRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 12:17:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q+BrTI53IPB4hUGc6Yvc8FyMa/JaUTVYdvQPqVhFCm2arf0GlB5CZ+M+dB4p0r7kqG
         OZ177vno+867r0y7vT0iY8leOLXjZtsG57PlA5y21clAJpzN/WkRmI0TzjE6cZEuQhsF
         82JRdjVjHuzMTQkEhOeKMbEPZOvkzGS/nyyUQ=
Date: Wed, 23 Feb 2011 18:14:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223171444.GA2591@nowhere>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20110223161645.GA1819@nowhere>
 <1298479302.7666.94.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298479302.7666.94.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 11:41:42AM -0500, Steven Rostedt wrote:
> On Wed, 2011-02-23 at 17:16 +0100, Frederic Weisbecker wrote:
> > I see you make extensive use of per_cpu() accessors even for
> > local variables.
> > 
> > I tend to think it's better to use __get_cpu_var() for local
> > accesses and keep per_cpu() for remote accesses.
> > 
> > There are several reasons for that:
> > 
> > * __get_cpu_var() checks we are in a non-preemptible section,
> > per_cpu() doesn't. That may sound of a limited interest for code like the
> > above, but by the time code can move, and then we might lose track of some
> > things, etc...
> 
> Ah, but so does smp_processor_id() ;-)

Ah, right :)
 
> > 
> > * local accesses can be optimized by architectures. per_cpu() implies
> > finding the local cpu number, and dereference an array of cpu offsets with
> > that number to find the local cpu offset.
> > __get_cpu_var() does a direct access to __my_cpu_offset which is a nice
> > shortcut if the arch implements it.
> 
> True, but we could also argue that the multiple checks for being preempt
> can also be an issue.

It's only in debugging code, so it's not really an issue.
 
> > 
> > * It makes code easier to review: we know that __get_cpu_var() is
> > for local accesses and per_cpu() for remote.
> 
> This I'll agree with you.
> 
> In the past, I've thought about which one is better (per_cpu() vs
> __get_cpu_var()).
> 
> But, that last point is a good one. Just knowing that this is for the
> local CPU helps with the amount of info your mind needs to process when
> looking at this code. And the mind needs all the help it can get when
> reviewing this code ;-)

Yeah :-)

And that becomes even better when you have the opportunity to
use get_cpu_var(). So that tells that your are doing a local access
and the reason why you disable/enable preemption.
