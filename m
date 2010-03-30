Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0C3U0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:26:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27506 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab0C3U0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:26:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Iv87JxM9YijnYXjHwPokqM9oqswsHV7IXEiPlfv7D+kRKBlgETg5+9NxIwI80Hj55
	tGD3p/f0rpPhz5Gq8ACog==
Date: Tue, 30 Mar 2010 13:26:39 -0700 (PDT)
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
In-Reply-To: <20100330154659.GA12416@redhat.com>
Message-ID: <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com> <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com>
 <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, Oleg Nesterov wrote:

> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -681,6 +681,16 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
> >  	}
> >
> >  	/*
> > +	 * If current has a pending SIGKILL, then automatically select it.  The
> > +	 * goal is to allow it to allocate so that it may quickly exit and free
> > +	 * its memory.
> > +	 */
> > +	if (fatal_signal_pending(current)) {
> > +		__oom_kill_task(current);
> 
> I am worried...
> 
> Note that __oom_kill_task() does force_sig(SIGKILL) which assumes that
> ->sighand != NULL. This is not true if out_of_memory() is called after
> current has already passed exit_notify().
> 

We have an even bigger problem if current is in the oom killer at 
exit_notify() since it has already detached its ->mm in exit_mm() :)

> Hmm. looking at oom_kill.c... Afaics there are more problems with mt
> apllications. select_bad_process() does for_each_process() which can
> only see the group leaders. This is fine, but what if ->group_leader
> has already exited? In this case its ->mm == NULL, and we ignore the
> whole thread group.
> 
> IOW, unless I missed something, it is very easy to hide the process
> from oom-kill:
> 
> 	int main()
> 	{
> 		pthread_create(memory_hog_func);
> 		syscall(__NR_exit);
> 	}
> 

The check for !p->mm was moved in the -mm tree (and the oom killer was 
entirely rewritten in that tree, so I encourage you to work off of it 
instead) with 
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch to 
even after the check for PF_EXITING.  This is set in the exit path before 
the ->mm is detached so if the oom killer finds an already exiting task, 
it will become a no-op since it should eventually free memory and avoids a 
needless oom kill.
