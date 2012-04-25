Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab2DYGrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 02:47:06 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40878 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2DYGrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 02:47:05 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.46.74
Date: Tue, 24 Apr 2012 23:46:41 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Minho Ban <mhban@samsung.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Paul Turner <pjt@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH] Prevent wasting time to find out get_parent_ip
Message-ID: <20120425064641.GA14635@leaf>
References: <4F969E53.9080307@samsung.com>
 <1335272025.28150.193.camel@twins>
 <4F9737CC.6010703@samsung.com>
 <20120424234513.GA11841@leaf>
 <4F976DC0.6060004@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F976DC0.6060004@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 12:21:36PM +0900, Minho Ban wrote:
> On 04/25/2012 08:45 AM, Josh Triplett wrote:
> > On Wed, Apr 25, 2012 at 08:31:24AM +0900, Minho Ban wrote:
> >> On 04/24/2012 09:53 PM, Peter Zijlstra wrote:
> >>> On Tue, 2012-04-24 at 21:36 +0900, Minho Ban wrote:
> >>>> trace_preempt_on/off looks empty if PREEMPT_TRACER is off. But actually it is
> >>>> spending time to find out get_parent_ip(even CALLER_ADDR for some ARCH) which is
> >>>> in argument. This seems not fair for those who expect to do nothing but increase
> >>>> or decrease count.
> >>>
> >>> You can do the same by making them CPP macros and adding a comment as to
> >>> why they're macros instead of inlines..
> >>>
> >>
> >> Thank you for pointing this out, certainly macros look better. I'll amend this.
> > 
> > As an alternative, how about making get_parent_ip and its called
> > functions static inlines?  Then the compiler can eliminate them via dead
> > code elimination.
> > 
> > Or, how about declaring get_parent_ip with the GCC "pure" attribute?
> > That would tell GCC that it can safely eliminate calls to the function.
> > 
> > - Josh Triplett
> > 
> 
> Thank you for alternative method, but I'm afraid this could not cover the CALLER_ADDR.

As far as I can tell, CALLER_ADDR() always means ftrace_caller(), and
CALLER_ADDR[0-6] always reference __builtin_return_address() or
return_address().  In the former case, you could mark ftrace_caller
pure, and in the latter cases, if GCC for some reason generates code for
those without eliminating it as dead code, you could add trivial
wrappers around those functions that have the pure attribute set on
them.  That should allow GCC to completely eliminate all of those.

Would that work?

- Josh Triplett
