Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2AYGPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 01:15:25 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:34931 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752423Ab2AYGPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 01:15:23 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/2tuki7LT2cjo6lJ4xM1zFwOPNdCvycY9nUTLr8U
	adBPLmgFYP6nKq
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
 condition
From: Mike Galbraith <efault@gmx.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: peterz@infradead.org, kosaki.motohiro@gmail.com, oleg@redhat.com,
        y-goto@jp.fujitsu.com, mingo@elte.hu, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <4F1EF1E8.4090909@jp.fujitsu.com>
References: <1324633794.24803.48.camel@twins>
	 <20111223154137.GA27901@redhat.com>
	 <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com>
	 <20111226171151.GA4472@redhat.com>  <4EFB8523.6080708@gmail.com>
	 <1327400618.2614.13.camel@laptop>  <4F1EF1E8.4090909@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 07:15:17 +0100
Message-ID: <1327472117.7591.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 13:01 -0500, KOSAKI Motohiro wrote:
> On 1/24/2012 5:23 AM, Peter Zijlstra wrote:
> > On Wed, 2011-12-28 at 16:07 -0500, KOSAKI Motohiro wrote:
> >> I looked at scheduler code today briefly. now I'm afraid following code 
> >> have similar race.
> >>
> >>
> >>          if (task_contributes_to_load(p))
> >>                  rq->nr_uninterruptible--;
> >>
> >>
> >>
> >> Can't following schenario be happen?
> >>
> >>
> >> CPU0                    CPU1
> >> --------------------------------------------------------
> >> deactivate_task()
> >>                         task->state = TASK_UNINTERRUPTIBLE;
> >> activate_task()
> >>    rq->nr_uninterruptible--;
> >>
> >>                         schedule()
> >>                           deactivate_task()
> >>                             rq->nr_uninterruptible++;
> >>
> >> Totally, nr_uninterruptible wasn't incremented.
> >>
> >>
> >> I'm still not sure. I need to read more sched code. 
> > 
> > You shouldn't ever set another tasks ->state. 
> 
> I'm sorry. I haven't catch your point. I think following step is
> valid kernel code. Do you disagree?
> 
> >>                         task->state = TASK_UNINTERRUPTIBLE;
> >>                         schedule()

I think you meant:
	__set_current_state(TASK_UNINTERRUPTIBLE);
	schedule();

The way you wrote it, task doesn't have to be current, so could be doing
the bad thing Peter pointed out, diddling *another* tasks ->state.

	-Mike

