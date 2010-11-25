Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab0KYRqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:46:04 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:40097 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab0KYRqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:46:02 -0500
Subject: Re: [patch 3/4] taskstats: Introduce cdata_acct for complete
 cumulative accounting
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
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20101125132155.GA25836@redhat.com>
References: <20101119201108.269346583@linux.vnet.ibm.com>
	 <20101119201144.542948128@linux.vnet.ibm.com>
	 <20101123165951.GA5938@redhat.com>
	 <1290678022.1941.29.camel@holzheu-laptop>
	 <20101125132155.GA25836@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 25 Nov 2010 18:45:58 +0100
Message-ID: <1290707158.1941.79.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 14:21 +0100, Oleg Nesterov wrote:
> On 11/25, Michael Holzheu wrote:
> But in fact this reminds we should cleanup this code somehow.
> By the time we call thread_group_times() there are no other
> threads.

Couldn't we just replace thread_group_times() with the following:

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -101,12 +101,13 @@ static void __account_cdata(struct task_
         * group, which consolidates times for all threads in the
         * group including the group leader.
         */
-       thread_group_times(p, &tgutime, &tgstime);
        pcd = &p->real_parent->signal->cdata_wait;
        tcd = &p->signal->cdata_threads;
        cd = &p->signal->cdata_wait;

        spin_lock_irqsave(&p->real_parent->sighand->siglock, flags);
+       tgutime = cputime_add(tcd->utime, p->utime);
+       tgstime = cputime_add(tcd->stime, p->stime);
        pcd->utime =
                cputime_add(pcd->utime,
                cputime_add(tgutime,

Then we can move the __account_cdata() invocation down to the second
group_dead check.

Michael

