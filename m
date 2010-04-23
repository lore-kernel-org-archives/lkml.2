Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0DWHZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 03:25:13 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:58319 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0DWHZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 03:25:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=aKFxu9edVSVuuTNzUPnj9d2f1b/DO9c9ptRjCK+ZF2/5ZL7/Ah1YfrB8zHVSltV4Ru
         +AiWhT2N27g5dhiuazc/rgHpLvG3bY0NvFZHSk0hWnQrv0xxYJZUbc4oMXtNY2/gd3FF
         VfbFnejxUyqswcp+gNMGDLj8K5RnmNpre8pLw=
Date: Fri, 23 Apr 2010 09:24:55 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost
To: Yong Zhang <yong.zhang@windriver.com>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH] lockdep: Add nr_save_trace_invocations counter
In-Reply-To: <20100423025850.GA21328@windriver.com>
Message-ID: <alpine.LFD.2.00.1004230907050.4151@localhost>
References: <alpine.LFD.2.00.1004222208310.3155@localhost> <20100423025850.GA21328@windriver.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
On Fri, 23 Apr 2010, Yong Zhang wrote:

> On Thu, Apr 22, 2010 at 10:15:48PM +0200, John Kacur wrote:
> > NOT FOR INCLUSION
> > 
> > I created this patch as a result of Peter Zilstra's request to get more 
> > info from lockdep. This patch is not for inclusion, at least in its 
> > present form, because it adds some redunant info to /proc/lockdep_stats
> > 
> > However, some of the fields are new, and it is worth examining, and / or 
> > applying if you are looking at the MAX_STACK_TRACE_ENTRIES too big 
> > problem.
> > 
> > I generated this patch against a recent tip/master but it applies without 
> > conflicts to the latest rt kernel as well. Comments are welcome, in fact 
> > they are appreciated.
> > 
> > >From 5181c0296dd1549e4e706ff25a4cd81a1d90137d Mon Sep 17 00:00:00 2001
> > From: John Kacur <jkacur@redhat.com>
> > Date: Thu, 22 Apr 2010 17:02:42 +0200
> > Subject: [PATCH] lockdep: Add nr_save_trace_invocations counter
> > 
> > Add the nr_save_trace_invocations counter which counts the number of
> > time save_trace() is invoked when relevant for trace enteries.
> > 
> > This means, those invocations from mark_lock() and add_lock_to_list()
> > 
> > When called from mark_lock() we break it down into LOCKSTATE categories.
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> 
> Just take a rough look at it. I don't think this can give more info.
> 
> > +/* Calls to save_trace() from mark_lock() and add_lock_to_list() only*/
> > +unsigned long nr_save_trace_invocations;
> 
> It will equal to nr_list_entries.
> 
> > +unsigned long nr_save_trace_invocations_type[LOCK_USAGE_STATES];
> 
> And each item in this array will equal to nr_hardirq_[un]safe,
> nr_softirq_[un]safe and such things under lockdep_stats_show(). Right?
> 
> Thanks,
> Yong
> 

Hi Yong

Some context here - Peter asked me to see if we could get some more 
detailed stats on why some configurations reach the 
MAX_STACK_TRACE_ENTRIES limit - whether the limit was really too low for 
some circumstances, or whether we were counting somethings unnecessarily.

In any case, I stamped a big NOT FOR INCLUSION on my mail, because I 
noticed that somethings were redundant - albeit, obtained in a slightly 
different manner, however, not everything is redundant.

In particular, nr_save_trace_invocations is NOT equal to nr_list_entries.
You will see that reported in /proc/lockdep_stats as
direct dependencies:                  8752 [max: 16384]
I have
stack-trace invocations: 10888
from the same run.

Still trying to figure out what the meaning is of that though to be 
honest.

Here is a portion of the lockdep_stats, with all of the new fields and the 
redundant ones.

stack-trace invocations: 10888
	LOCK_USED_IN_HARDIRQ: 15
	LOCK_USED_IN_HARDIRQ_READ: 0
	LOCK_ENABLED_HARDIRQ: 543
	LOCK_ENABLED_HARDIRQ_READ: 28
	LOCK_USED_IN_SOFTIRQ: 0
	LOCK_USED_IN_SOFTIRQ_READ: 0
	LOCK_ENABLED_SOFTIRQ: 543
	LOCK_ENABLED_SOFTIRQ_READ: 28
	LOCK_USED_IN_RECLAIM_FS: 5
	LOCK_USED_IN_RECLAIM_FS_READ: 0
	LOCK_ENABLED_RECLAIM_FS: 95
	LOCK_ENABLED_RECLAIM_FS_READ: 8
	LOCK_USED: 871
 combined max dependencies:          139841
 hardirq-safe locks:                     15
 hardirq-unsafe locks:                  543
 softirq-safe locks:                      0
 softirq-unsafe locks:                  543
 irq-safe locks:                         15
 irq-unsafe locks:                      543
 hardirq-read-safe locks:                 0
 hardirq-read-unsafe locks:              28
 softirq-read-safe locks:                 0
 softirq-read-unsafe locks:              28
 irq-read-safe locks:                     0
 irq-read-unsafe locks:                  28

So, you see that all of the reclaim fields are new,
        LOCK_USED_IN_RECLAIM_FS: 5
        LOCK_USED_IN_RECLAIM_FS_READ: 0
        LOCK_ENABLED_RECLAIM_FS: 95
        LOCK_ENABLED_RECLAIM_FS_READ: 8

I can create a patch for inclusion that adds the reclaim fields, the 
question is, is the nr_save_trace_invocations a useful stat for us or not?

Thanks
