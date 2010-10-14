Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab0JNJ1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:27:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:44307 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab0JNJ1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:27:52 -0400
Subject: Re: [PATCH v3 2/7] sched: accumulate per-cfs_rq cpu usage
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Nikhil Rao <ncrao@google.com>
In-Reply-To: <AANLkTimj5Ft6ft8u5NxZmT4MAMai24Ke7LeZ0QaucQmM@mail.gmail.com>
References: <20101012074910.GA9893@in.ibm.com>
	 <20101012075109.GC9893@in.ibm.com> <1287046900.29097.161.camel@twins>
	 <AANLkTimj5Ft6ft8u5NxZmT4MAMai24Ke7LeZ0QaucQmM@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 11:27:08 +0200
Message-ID: <1287048428.29097.174.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 02:14 -0700, Paul Turner wrote:
> On Thu, Oct 14, 2010 at 2:01 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-10-12 at 13:21 +0530, Bharata B Rao wrote:
> >> +static void account_cfs_rq_quota(struct cfs_rq *cfs_rq,
> >> +               unsigned long delta_exec)
> >> +{
> >> +       if (cfs_rq->quota_assigned == RUNTIME_INF)
> >> +               return;
> >> +
> >> +       cfs_rq->quota_used += delta_exec;
> >> +
> >> +       if (cfs_rq->quota_used < cfs_rq->quota_assigned)
> >> +               return;
> >> +
> >> +       cfs_rq->quota_assigned += tg_request_cfs_quota(cfs_rq->tg);
> >> +}
> >
> > That looks iffy, quota_assigned is only ever incremented and can wrap.
> 
> This can't advance at a rate faster than ~vruntime and we can't handle
> wrapping there anyway (fortunately it would take something like 35k
> years?)

You can't go faster than wall-time, vruntime can actually go a lot
faster and can deal with wrapping.

> > Why not subtract delta_exec and replenish when <0? That keeps the
> > numbers small.
> >
> 
> Accounting in the opposite direction allows us to catch-up in
> subsequent periods when a task exceeds its bandwidth across an
> interval where we are not able to immediately throttle it (e.g. costly
> syscall without config_prempt).  Since we'll continue to accrue the
> execution time in this case it will be effectively pre-charged against
> the next slice received.

Humm, how so, that's a simply matter of the quota going negative, right?
