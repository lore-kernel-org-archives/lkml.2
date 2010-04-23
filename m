Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0DWIB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:01:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:47645 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab0DWIBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:01:16 -0400
Date: Fri, 23 Apr 2010 16:00:14 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: John Kacur <jkacur@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH] lockdep: Add nr_save_trace_invocations counter
Message-ID: <20100423080014.GB21328@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <alpine.LFD.2.00.1004222208310.3155@localhost>
 <20100423025850.GA21328@windriver.com>
 <alpine.LFD.2.00.1004230907050.4151@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004230907050.4151@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 08:00:16.0766 (UTC) FILETIME=[02D389E0:01CAE2BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 09:24:55AM +0200, John Kacur wrote:
> Some context here - Peter asked me to see if we could get some more 
> detailed stats on why some configurations reach the 
> MAX_STACK_TRACE_ENTRIES limit - whether the limit was really too low for 
> some circumstances, or whether we were counting somethings unnecessarily.
> 
> In any case, I stamped a big NOT FOR INCLUSION on my mail, because I 
> noticed that somethings were redundant - albeit, obtained in a slightly 
> different manner, however, not everything is redundant.
> 
> In particular, nr_save_trace_invocations is NOT equal to nr_list_entries.
> You will see that reported in /proc/lockdep_stats as
> direct dependencies:                  8752 [max: 16384]
> I have
> stack-trace invocations: 10888
> from the same run.

I missed that nr_save_trace_invocations is also increased in
inc_save_trace_invocations().
So nr_save_trace_invocations = nr_list_entries + sum of
nr_save_trace_invocations_type[].

> 
> Still trying to figure out what the meaning is of that though to be 
> honest.
> 
> Here is a portion of the lockdep_stats, with all of the new fields and the 
> redundant ones.
> 
> stack-trace invocations: 10888
> 	LOCK_USED_IN_HARDIRQ: 15
> 	LOCK_USED_IN_HARDIRQ_READ: 0
> 	LOCK_ENABLED_HARDIRQ: 543
> 	LOCK_ENABLED_HARDIRQ_READ: 28
> 	LOCK_USED_IN_SOFTIRQ: 0
> 	LOCK_USED_IN_SOFTIRQ_READ: 0
> 	LOCK_ENABLED_SOFTIRQ: 543
> 	LOCK_ENABLED_SOFTIRQ_READ: 28
> 	LOCK_USED_IN_RECLAIM_FS: 5
> 	LOCK_USED_IN_RECLAIM_FS_READ: 0
> 	LOCK_ENABLED_RECLAIM_FS: 95
> 	LOCK_ENABLED_RECLAIM_FS_READ: 8
> 	LOCK_USED: 871
>  combined max dependencies:          139841
>  hardirq-safe locks:                     15
>  hardirq-unsafe locks:                  543
>  softirq-safe locks:                      0
>  softirq-unsafe locks:                  543
>  irq-safe locks:                         15
>  irq-unsafe locks:                      543
>  hardirq-read-safe locks:                 0
>  hardirq-read-unsafe locks:              28
>  softirq-read-safe locks:                 0
>  softirq-read-unsafe locks:              28
>  irq-read-safe locks:                     0
>  irq-read-unsafe locks:                  28
> 
> So, you see that all of the reclaim fields are new,
>         LOCK_USED_IN_RECLAIM_FS: 5
>         LOCK_USED_IN_RECLAIM_FS_READ: 0
>         LOCK_ENABLED_RECLAIM_FS: 95
>         LOCK_ENABLED_RECLAIM_FS_READ: 8

Yes, indeed, data in lockdep_stats_show() is out of time.
So as Peter has said in another thread, we should add sample for RECLAIM_FS.

> 
> I can create a patch for inclusion that adds the reclaim fields, the 
> question is, is the nr_save_trace_invocations a useful stat for us or not?

Actually it's just a summation of the samples.
I don't think it's necessary.

Thanks,
Yong
