Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab2LKHIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:08:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:59283 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2LKHII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:08:08 -0500
Message-ID: <1355209663.7057.77.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH RT 3/4] sched/rt: Use IPI to trigger RT task push
 migration instead of pulling
From: Mike Galbraith <bitbucket@online.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: frank.rowand@am.sony.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 11 Dec 2012 08:07:43 +0100
In-Reply-To: <1355190830.17101.280.camel@gandalf.local.home>
References: <20121207235615.206108556@goodmis.org>
	 <20121208000900.613917378@goodmis.org> <50C682F6.5030709@am.sony.com>
	 <50C68922.5030203@am.sony.com>
	 <1355190830.17101.280.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:thx5dQMMz0GqmmZ/TAsvw4cSDEg1VlG7ERkba7+a8Gq
 GHlob1Ftv+5rA0W0Xaff/a5Jb1BI4LctS1vKXPMuNatPFFyBCw
 aKY6BZBsCyTDdF4YbY00wd5y6c0mV3VawzCbaMBfX1grKsX0LA
 zc717ap2+i8mbm0EA5PBg9Li4T4he+3qlvZo2+0cuYf+k/G1q9
 qNLv66wWVBW2W2NJntZIggqzzQjjB+yA01hfegfgRjHyj8zfTg
 Z06hgT7G7cW9U49f2uq01OEJPU0DnltLXa4PnFl0z53nvDtH0m
 ISfeKaSdkE9d7SE0lejMX9iS2fg2R6dfDO9ivw7SccqnP/YHyQ
 Q1GdWS3fDlhMJ0Rd/7UykcvzvCk0lanzwfcYM+/zry1nJaXeg8
 NTL51GbqRyD8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 20:53 -0500, Steven Rostedt wrote: 
> On Mon, 2012-12-10 at 17:15 -0800, Frank Rowand wrote:
> 
> > I should have also mentioned some previous experience using IPIs to
> > avoid runq lock contention on wake up.  Someone encountered IPI
> > storms when using the TTWU_QUEUE feature, thus it defaults to off
> > for CONFIG_PREEMPT_RT_FULL:
> > 
> >   #ifndef CONFIG_PREEMPT_RT_FULL
> >   /*
> >    * Queue remote wakeups on the target CPU and process them
> >    * using the scheduler IPI. Reduces rq->lock contention/bounces.
> >    */
> >   SCHED_FEAT(TTWU_QUEUE, true)
> >   #else
> >   SCHED_FEAT(TTWU_QUEUE, false)
> > 
> 
> Interesting, but I'm wondering if this also does it for every wakeup? If
> you have 1000 tasks waking up on another CPU, this could potentially
> send out 1000 IPIs. The number of IPIs here looks to be # of tasks
> waking up, and perhaps more than that, as there could be multiple
> instances that try to wake up the same task.

Yeah.  In mainline, wakeup via IPI is disabled within a socket, because
it's too much of a performance hit for high frequency switchers.  (It
seems we're limited by the max rate at which we can IPI)

-Mike

