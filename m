Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0DBTCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:02:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59664 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0DBTCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:02:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ilmIsJ5wZnAuxmulpe0R94e44W3yhf+8QibMGEmRMTYeONmfuZ4xMBdtI+6bpHFs2
	LGX908scBRXH4LHkRx3ig==
Date: Fri, 2 Apr 2010 12:02:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: give current access to memory reserves if it has
 been killed
In-Reply-To: <20100402111406.GA4432@redhat.com>
Message-ID: <alpine.DEB.2.00.1004021159310.1773@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com>
 <20100331175836.GA11635@redhat.com> <20100331204718.GD11635@redhat.com> <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com> <20100401135927.GA12460@redhat.com> <alpine.DEB.2.00.1004011210380.30661@chino.kir.corp.google.com>
 <20100402111406.GA4432@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010, Oleg Nesterov wrote:

> > > Yes, you are right. OK, oom_badness() can never return points < 0,
> > > we can make it int and oom_badness() can return -1 if !mm. IOW,
> > >
> > > 	- unsigned int points;
> > > 	+ int points;
> > > 	...
> > >
> > > 	points = oom_badness(...);
> > > 	if (points >= 0 && (points > *ppoints || !chosen))
> > > 		chosen = p;
> > >
> >
> > oom_badness() and its predecessor badness() in mainline never return
> > negative scores, so I don't see the value in doing this; just filter the
> > task in select_bad_process() with !p->mm as it has always been done.
> 
> David, you continue to ignore my arguments ;) select_bad_process()
> must not filter out the tasks with ->mm == NULL.
> 
> Once again:
> 
> 	void *memory_hog_thread(void *arg)
> 	{
> 		for (;;)
> 			malloc(A_LOT);
> 	}
> 
> 	int main(void)
> 	{
> 		pthread_create(memory_hog_thread, ...);
> 		syscall(__NR_exit, 0);
> 	}
> 
> Now, even if we fix PF_EXITING check, select_bad_process() will always
> ignore this process. The group leader has ->mm == NULL.
> 
> See?
> 
> That is why I think we need something like find_lock_task_mm() in the
> pseudo-patch I sent.
> 

I'm not ignoring your arguments, I think you're ignoring what I'm 
responding to.  I prefer to keep oom_badness() to be a positive range as 
it always has been (and /proc/pid/oom_score has always used an unsigned 
qualifier), so I disagree that we need to change oom_badness() to return 
anything other than 0 for such tasks.  We need to filter them explicitly 
in select_bad_process() instead, so please do this there.
