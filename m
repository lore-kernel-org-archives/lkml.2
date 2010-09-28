Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0I1Kgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:36:37 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:57649 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0I1Kge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:36:34 -0400
Date: Tue, 28 Sep 2010 12:36:25 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
Message-ID: <20100928123625.18eec4ad@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100928092355.GA4261@balbir.in.ibm.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
	<1285250541.1837.95.camel@holzheu-laptop>
	<20100923171025.GA26623@redhat.com>
	<1285330688.2179.305.camel@holzheu-laptop>
	<20100926181127.GA26985@redhat.com>
	<20100927154257.7910cda3@mschwide.boeblingen.de.ibm.com>
	<20100928083602.GD4128@balbir.in.ibm.com>
	<20100928110828.54e1cf25@mschwide.boeblingen.de.ibm.com>
	<20100928092355.GA4261@balbir.in.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 14:53:55 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Martin Schwidefsky <schwidefsky@de.ibm.com> [2010-09-28 11:08:28]:
> 
> > On Tue, 28 Sep 2010 14:06:02 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> > > * Martin Schwidefsky <schwidefsky@de.ibm.com> [2010-09-27 15:42:57]:
> > > > Got the part about self-reaping processes. But there is another issue:
> > > > consider an exiting thread where the group leader is still active.
> > > > The time for the thread will be added to the utime/stime fields in
> > > > the signal structure. Taskstats will happily ignore that time while
> > > > the group leader is still running.
> > > >
> > > 
> > > Why do you say that? Not sure your comment is very clean, in
> > > fill_tgid, we do
> > > 
> > > 1. Accumulate signal stats (contains stats for dead threads)
> > > 2. Accumulate stats for current threads
> > > 
> > > fill_tgid_exit does something similar
> > 
> > Hmm, I can't find anything in the code where the tsk->signal->{utime,stime}
> 
> That is left to the actual subsystem (I should have been clearer in
> stating that the limitation is not with the taskstats infrastructure
> itself). Yes, your observation is indeed correct.
> 
> taskstats code is expected to contain the callback for the subsystems
> it supports. delayacct() already does the right thing today, AFAICS
> 
> > gets transferred to the taskstats record. There is a loop in fill_tgid over
> > the threads of the process but all it does is to call delayacct_add_tsk.
> > And that function does nothing with the cpu time of dead threads which is
> > stored in the signal structure. In addition which taskstats field is
> > supposed to contain the cpu time of the dead thread, ac_utime/ac_stime?
> >
> 
> I've not focused much on ac_*, The changes that need to occur are we
> need to get the tsacct.c callbacks into taskstats.

Ok, so tsacct.c is the right place to implement it. We will need new fields
in struct taskstats to contain the tsk->signal->{utime,stime} and some code
in bacct_add_tsk to do the copy. Agreed ?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

