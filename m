Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab1BXQjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:39:43 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57815 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab1BXQjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:39:41 -0500
Date: Thu, 24 Feb 2011 22:09:50 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Subject: Re: [CFS Bandwidth Control v4 3/7] sched: throttle cfs_rq entities
 which exceed their local quota
Message-ID: <20110224163950.GB3000@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <20110216031841.068673650@google.com>
 <1298467933.2217.765.camel@twins>
 <20110224052101.GA2755@in.ibm.com>
 <1298545501.2428.18.camel@twins>
 <20110224154547.GA3000@in.ibm.com>
 <1298562773.2428.230.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298562773.2428.230.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 04:52:53PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-02-24 at 21:15 +0530, Bharata B Rao wrote:
> > While I admit that our load balancing semantics wrt thorttled entities are
> > not consistent (we don't allow pulling of tasks directly from throttled
> > cfs_rqs, while allow pulling of tasks from a throttled hierarchy as in the
> > above case), I am beginning to think if it works out to be advantageous.
> > Is there a chance that the task gets to run on other CPU where the hierarchy
> > isn't throttled since runtime is still available ? 
> 
> Possible yes, but the load-balancer doesn't know about that, not should
> it (its complicated, and broken, enough, no need to add more cruft to
> it).
> 
> I'm starting to think you all should just toss all this and start over,
> its just too smelly.

Hmm... You have brought up 3 concerns:

1. Hierarchy semantics

If you look at the heirarchy semantics we currently have while ignoring the
load balancer interactions for a moment, I guess what we have is a reasonable
one.

- Only group entities are throttled
- Throttled entities are taken off the runqueue and hence they never
  get picked up for scheduling.
- New or child entites are queued up to the throttled entities and not
  further up. As I said in another thread, having the tree intact and correct
  underneath the throttled entity allows us to rebuild the hierarchy during
  unthrottling with least amount of effort.
- Group entities in a hierarchy are throttled independent of each other based
  on their bandwidth specification.

2. Handling of throttled entities by load balancer

This definetely needs to improve and be more consistent. We can work on this.

3. per-cgroup vs global period specification

I thought per-cgroup specification would be most flexible and hence started
out with that. This would allow groups/workloads/VMs to define their
own bandwidth rate.

Let us know if you have other design concerns besides these.

Regards,
Bharata.
