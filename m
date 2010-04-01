Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab0DATMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:12:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:48512 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab0DATMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:12:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Fv+9/gO8oQIU8vREVBH4DjKlKtkx0BOAvdX95nx9htlkrbMwsCY+1tekNdnj/u5WH
	i1kt8CurUpiiqTuAyXDXw==
Date: Thu, 1 Apr 2010 12:12:30 -0700 (PDT)
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
In-Reply-To: <20100401135927.GA12460@redhat.com>
Message-ID: <alpine.DEB.2.00.1004011210380.30661@chino.kir.corp.google.com>
References: <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com>
 <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com> <20100331175836.GA11635@redhat.com> <20100331204718.GD11635@redhat.com> <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com>
 <20100401135927.GA12460@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010, Oleg Nesterov wrote:

> > > @@ -159,13 +172,9 @@ unsigned int oom_badness(struct task_str
> > >  	if (p->flags & PF_OOM_ORIGIN)
> > >  		return 1000;
> > >
> > > -	task_lock(p);
> > > -	mm = p->mm;
> > > -	if (!mm) {
> > > -		task_unlock(p);
> > > +	p = find_lock_task_mm(p);
> > > +	if (!p)
> > >  		return 0;
> > > -	}
> > > -
> > >  	/*
> > >  	 * The baseline for the badness score is the proportion of RAM that each
> > >  	 * task's rss and swap space use.
> > > @@ -330,12 +339,6 @@ static struct task_struct *select_bad_pr
> > >  			*ppoints = 1000;
> > >  		}
> > >
> > > -		/*
> > > -		 * skip kernel threads and tasks which have already released
> > > -		 * their mm.
> > > -		 */
> > > -		if (!p->mm)
> > > -			continue;
> > >  		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
> > >  			continue;
> >
> > You can't do this for the reason I cited in another email, oom_badness()
> > returning 0 does not exclude a task from being chosen by
> > selcet_bad_process(), it will use that task if nothing else has been found
> > yet.  We must explicitly filter it from consideration by checking for
> > !p->mm.
> 
> Yes, you are right. OK, oom_badness() can never return points < 0,
> we can make it int and oom_badness() can return -1 if !mm. IOW,
> 
> 	- unsigned int points;
> 	+ int points;
> 	...
> 
> 	points = oom_badness(...);
> 	if (points >= 0 && (points > *ppoints || !chosen))
> 		chosen = p;
> 

oom_badness() and its predecessor badness() in mainline never return 
negative scores, so I don't see the value in doing this; just filter the 
task in select_bad_process() with !p->mm as it has always been done.
