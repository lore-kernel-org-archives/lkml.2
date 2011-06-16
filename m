Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab1FPVBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:01:36 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64240 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab1FPVBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rjL+h/Np4U0SpWFoAtXvghQltFwqhtpB9Ljsg3aObKVV0y7BbCevN7VzQJ8PUPZ75T
         oStEamODPN9T9R4mMYwJhZCDwEAhCZiatCrqSeCE0i7gRdw7kEeTwpXClgAwih3GT24Z
         Zn7VdYPiN0Z9dW8tYSk5OKGdOhY3IidFsiAdw=
Date: Thu, 16 Jun 2011 23:01:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, ak@linux.intel.com,
        shaohua.li@intel.com, alex.shi@intel.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PULL] Re: REGRESSION: Performance regressions from
 switching anon_vma->lock to mutex
Message-ID: <20110616210119.GD23624@somewhere.redhat.com>
References: <1308097798.17300.142.camel@schen9-DESK>
 <1308134200.15315.32.camel@twins>
 <1308135495.15315.38.camel@twins>
 <BANLkTikt88KnxTy8TuGGVrBVnXvsnL7nMQ@mail.gmail.com>
 <20110615201216.GA4762@elte.hu>
 <35c0ff16-bd58-4b9c-9d9f-d1a4df2ae7b9@email.android.com>
 <20110616070335.GA7661@elte.hu>
 <20110616171644.GK2582@linux.vnet.ibm.com>
 <20110616202550.GA16214@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616202550.GA16214@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 10:25:50PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > > The funny thing about this workload is that context-switches are 
> > > really a fastpath here and we are using anonymous IRQ-triggered 
> > > softirqs embedded in random task contexts as a workaround for 
> > > that.
> > 
> > The other thing that the IRQ-triggered softirqs do is to get the 
> > callbacks invoked in cases where a CPU-bound user thread is never 
> > context switching.
> 
> Yeah - but this workload didnt have that.
> 
> > Of course, one alternative might be to set_need_resched() to force 
> > entry into the scheduler as needed.
> 
> No need for that: we can just do the callback not in softirq but in 
> regular syscall context in that case, in the return-to-userspace 
> notifier. (see TIF_USER_RETURN_NOTIFY and the USER_RETURN_NOTIFIER 
> facility)
> 
> Abusing a facility like setting need_resched artificially will 
> generally cause trouble.

If the task enqueued callbacks in the kernel, thus started a new grace period,
it might return to userspace before every CPUs have completed that grace period,
and you need that full completion to happen before invoking the callbacks.

I think you need to keep the tick in such case because you can't count on
the other CPUs to handle that completion as they may be all idle.

So when you resume to userspace and you started a GP, either you find another
CPU to handle the GP completion and callbacks executions, or you keep the tick
until you are done.
