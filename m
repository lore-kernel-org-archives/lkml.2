Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab0IZSPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:15:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab0IZSPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:15:40 -0400
Date: Sun, 26 Sep 2010 20:11:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/10] taskstats: Fix exit CPU time accounting
Message-ID: <20100926181127.GA26985@redhat.com>
References: <1285249681.1837.28.camel@holzheu-laptop> <1285250541.1837.95.camel@holzheu-laptop> <20100923171025.GA26623@redhat.com> <1285330688.2179.305.camel@holzheu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285330688.2179.305.camel@holzheu-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/24, Michael Holzheu wrote:
>
> On Thu, 2010-09-23 at 19:10 +0200, Oleg Nesterov wrote:
> >
> > On 09/23, Michael Holzheu wrote:
> > >
> > > Currently there are code pathes (e.g. for kthreads) where the consumed
> > > CPU time is not accounted to the parents cumulative counters.
> >
> > Could you explain more?
>
> I think one place was "khelper" (kmod.c). It is created with
> kernel_thread() and it exits without having accounted the times with
> sys_wait() to the parent's ctimes

No. Well yes, it is not accounted, but this is not because it is
kthread.

To simplify the discussion, lets talk about utime/cutime only,
and lets forget about the multithreading.

It is very simple, currently linux accounts the exiting task's
utime and adds its to ->cutime _only_ if parent does do_wait().
If parent ignores SIGCHLD, the child reaps itself and it is not
accounted.

I do not know why it was done this way, but I'm afraid we can't
change this historical behaviour.

> Ok, the problem is that I did not consider exiting threads that are no
> thread group leaders. When they exit the ctime of the parent is not
> updated. Instead the time is accumulated in the signal struct.

I think I am a bit confused, but see above. With or without threads
the whole process can exit without accounting.

Oleg.

