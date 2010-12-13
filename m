Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0LMNFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:05:24 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:36194 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab0LMNFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:05:22 -0500
Subject: Re: [patch v2 4/4] taskstats: Export "cdata_wait" CPU times with
 taskstats
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Oleg Nesterov <oleg@redhat.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20101211173931.GA8084@redhat.com>
References: <20101129164237.522034198@linux.vnet.ibm.com>
	 <20101129164435.903722027@linux.vnet.ibm.com>
	 <20101201185128.GA7656@redhat.com>
	 <1291307641.1928.125.camel@holzheu-laptop>
	 <20101208202308.GA1804@redhat.com>
	 <1291987580.1933.10.camel@holzheu-laptop>
	 <20101211173931.GA8084@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 13 Dec 2010 14:05:15 +0100
Message-ID: <1292245515.2063.168.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Sat, 2010-12-11 at 18:39 +0100, Oleg Nesterov wrote:
> On 12/10, Michael Holzheu wrote:
> >
> > > > When the last thread exits and the process/thread group dies,
> > > > taskstats_exit() sends an additional taskstats struct to userspace that
> > > > aggregates the thread accounting data. Currently only the delay
> > > > accounting data is aggregated (see
> > > > taskstats_exit->fill_tgid_exit->delayacct_add_tsk). Not sure, why the
> > > > other information is not aggregated. We perhaps also should include
> > > > ac_cXtime in the aggregated taskstats.
> > >
> > > Not sure I understand... Do you mean
> > >
> > > 	if (is_thread_group)
> > > 		fill_tgid_exit(tsk);
> > >
> > > ? Afaics, this is not "When the last thread exits", this is
> > > "this program is multithreaded, it has (or had) other threads".
> >
> > fill_tgid_exit() adds the data of the dying thread to the thread group
> > data (tsk->signal->stats). Currently only for delay accounting.
> >
> > But the accumulated data is sent to userspace only after the last thread
> > has died:
> >
> >         if (!is_thread_group || >>>!group_dead<<<)
> >                 goto send;
> 
> Ah, right you are.
> 
> And this looks racy, or I missed something again. group_dead can be
> true, but this doesn't mean all other threads have already passed
> taskstats_exit()->fill_tgid_exit()->delayacct_add_tsk().

I think you are right.

One way to fix that could be to separate the aggregation from the
sending. We could call fill_tgid_exit()->delayacct_add_tsk() before
atomic_dec_and_test(&tsk->signal->live) in do_exit() and
taskstats_exit() with the sender part afterwards.

> And. Why "if (is_thread_group)" does "size *= 2" unconditionally?
> IOW, perhaps the patch below makes sense?

Yes, I think the patch makes sense. Balbir?

> 
> Oleg.
> 
> --- x/kernel/taskstats.c
> +++ x/kernel/taskstats.c
> @@ -576,7 +576,8 @@ void taskstats_exit(struct task_struct *
>  	is_thread_group = !!taskstats_tgid_alloc(tsk);
>  	if (is_thread_group) {
>  		/* PID + STATS + TGID + STATS */
> -		size = 2 * size;
> +		if (group_dead)
> +			size *= 2;
>  		/* fill the tsk->signal->stats structure */
>  		fill_tgid_exit(tsk);
>  	}
> 


