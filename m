Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0LTIjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 03:39:36 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41407 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754322Ab0LTIjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 03:39:35 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+6bjBpqJK6ls2Z3a5dQqTlNd3TzalIFWnAUKhPka
	V6JjC637Y1eoSF
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D0DCE10.7000200@redhat.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>
	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>
	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>
	 <1292699204.1181.51.camel@marge.simson.net>  <4D0DA45A.9070600@redhat.com>
	 <1292753156.16367.104.camel@marge.simson.net> <4D0DCE10.7000200@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 09:39:32 +0100
Message-ID: <1292834372.8948.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 11:19 +0200, Avi Kivity wrote:
> On 12/19/2010 12:05 PM, Mike Galbraith wrote:

> > >  We definitely want to maintain fairness.  Both with a dedicated virt
> > >  host and with a mixed workload.
> >
> > That makes it difficult to the point of impossible.
> >
> > You want a specific task to run NOW for good reasons, but any number of
> > tasks may want the same godlike power for equally good reasons.
> 
> I don't want it to run now.  I want it to run before some other task.  I 
> don't care if N other tasks run before both.  So no godlike powers 
> needed, simply a courteous "after you".

Ponders that...

What if: we test that both tasks are in the same thread group, if so,
use cfs_rq->next to pass the scheduler a HINT of what you would LIKE to
happen.  If the current task on that rq is also in your group, resched
it, then IFF the task you would like to run isn't too far right, it'll
be selected.  If the current task is not one of yours, tough, you can
set cfs_rq->next and hope it doesn't get overwritten, but you may not
preempt a stranger.  If you happen to be sharing an rq, cool, you
accomplished your yield_to().  If not, there's no practical way (I can
think of) to ensure that the target runs before you run again if you try
to yield, but you did your best to try to get him to the cpu sooner, and
in a manner that preserves fairness without dangerous vruntime diddling.

Would that be good enough to stop (or seriously improve) cpu wastage?

	-Mike

