Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0C3U3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:29:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28413 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab0C3U3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:29:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=cP4RISI39QEUCLwMyo0dN6piIft6Kj6A4+LXcu1JMpL14JD6q/CaQiwIM62FyqXzv
	n4MPJKvtblfEE1/CynfvA==
Date: Tue, 30 Mar 2010 13:29:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: anfei <anfei.zhou@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom killer: break from infinite loop
In-Reply-To: <20100330142923.GA10099@desktop>
Message-ID: <alpine.DEB.2.00.1003301326490.5234@chino.kir.corp.google.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com> <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com>
 <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329140633.GA26464@desktop> <alpine.DEB.2.00.1003291259400.14859@chino.kir.corp.google.com> <20100330142923.GA10099@desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, anfei wrote:

> > > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > > index afeab2a..9aae208 100644
> > > --- a/mm/oom_kill.c
> > > +++ b/mm/oom_kill.c
> > > @@ -588,12 +588,8 @@ retry:
> > >  	if (PTR_ERR(p) == -1UL)
> > >  		return;
> > >  
> > > -	/* Found nothing?!?! Either we hang forever, or we panic. */
> > > -	if (!p) {
> > > -		read_unlock(&tasklist_lock);
> > > -		dump_header(NULL, gfp_mask, order, NULL);
> > > -		panic("Out of memory and no killable processes...\n");
> > > -	}
> > > +	if (!p)
> > > +		p = current;
> > >  
> > >  	if (oom_kill_process(p, gfp_mask, order, points, NULL,
> > >  			     "Out of memory"))
> > 
> > The reason p wasn't selected is because it fails to meet the criteria for 
> > candidacy in select_bad_process(), not necessarily because of a race with 
> > the !p->mm check that the -mm patch cited above fixes.  It's quite 
> > possible that current has an oom_adj value of OOM_DISABLE, for example, 
> > where this would be wrong.
> 
> I see.  And what about changing mem_cgroup_out_of_memory() too?
> 

The memory controller is different because it must kill a task even if 
another task is exiting since the imposed limit has been reached.

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 0cb1ca4..9e89a29 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -510,8 +510,10 @@ retry:
>  	if (PTR_ERR(p) == -1UL)
>  		goto out;
>  
> -	if (!p)
> -		p = current;
> +	if (!p) {
> +		read_unlock(&tasklist_lock);
> +		panic("Out of memory and no killable processes...\n");
> +	}
>  
>  	if (oom_kill_process(p, gfp_mask, 0, points, limit, mem,
>  				"Memory cgroup out of memory"))
> 

This actually does appear to be necessary but for a different reason: if 
current is unkillable because it has OOM_DISABLE, for example, then 
oom_kill_process() will repeatedly fail and mem_cgroup_out_of_memory() 
will infinitely loop.

Kame-san?
