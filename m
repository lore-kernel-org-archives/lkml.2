Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab2HPOmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:42:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:56632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289Ab2HPOm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:42:29 -0400
Message-ID: <1345128138.29668.42.camel@twins>
Subject: Re: Add rq->nr_uninterruptible count to dest cpu's rq while CPU
 goes down.
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        paulmck <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Aug 2012 16:42:18 +0200
In-Reply-To: <CADZ9YHjPjExzuJWjziiezBch03Am0imQzDG4EDfG-NTWfz4V8A@mail.gmail.com>
References: <1345124749.31092.2.camel@localhost.localdomain>
	 <1345125384.29668.30.camel@twins>
	 <CADZ9YHjPjExzuJWjziiezBch03Am0imQzDG4EDfG-NTWfz4V8A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 20:28 +0600, Rakib Mullick wrote:

> I'm not sure which parts are missing from Changelog to patch. And this
> patch assumes that, sleeping tasks won't be scattered. From
> select_fallback_rq(), sleeping tasks might get scattered due to
> various cases like. if CPU is down, task isn't allowed to move a
> particular CPU. Other than that, dest cpu supposed to be the same.

Sure but affinities and cpusets can still scatter, and therefore your
logic doesn't hold up, but see below.

> > Furthermore there should be absolutely no impact on load calculation
> > what so ever. nr_uninterruptible is only ever useful as a sum over all
> > cpus, this total sum doesn't change regardless of where you put the
> > value.
> >
> > Worse, there's absolutely no relation to the tasks on the runqueue
> > (sleeping or otherwise) and nr_uninterruptible, so coupling these
> > actions makes no sense what so ever.
> >
> nr_uninterruptible is coupled with tasks on the runqueue to calculate
> nr_active numbers.

It is not.. nr_uninterruptible is incremented on the cpu the task goes
to sleep and decremented on the cpu doing the wakeup.

This means that nr_uninterruptible is a complete mess and any per-cpu
value isn't meaningful at all.

It is quite possible to always have the inc on cpu0 and the decrement on
cpu1, yielding results like:

{1000, -1000} for an effective nr_uninterruptible = 0. Taking either cpu
down will then migrate whatever delta it has to another cpu, but there
might only be a single task, yet the delta is +-1000.

> In calc_load_fold_active(), this nr_active numbers are used to
> calculate delta. This is how I understand this part and seeing some
> impact.

You understand wrong, please re-read the comment added in commit
5167e8d5.
