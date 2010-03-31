Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab0CaBBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 21:01:07 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52660 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab0CaBBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 21:01:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 31 Mar 2010 09:57:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: anfei <anfei.zhou@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom killer: break from infinite loop
Message-Id: <20100331095714.9137caab.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1003301326490.5234@chino.kir.corp.google.com>
References: <1269447905-5939-1-git-send-email-anfei.zhou@gmail.com>
	<20100326150805.f5853d1c.akpm@linux-foundation.org>
	<20100326223356.GA20833@redhat.com>
	<20100328145528.GA14622@desktop>
	<20100328162821.GA16765@redhat.com>
	<alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com>
	<20100329140633.GA26464@desktop>
	<alpine.DEB.2.00.1003291259400.14859@chino.kir.corp.google.com>
	<20100330142923.GA10099@desktop>
	<alpine.DEB.2.00.1003301326490.5234@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010 13:29:29 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 0cb1ca4..9e89a29 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -510,8 +510,10 @@ retry:
> >  	if (PTR_ERR(p) == -1UL)
> >  		goto out;
> >  
> > -	if (!p)
> > -		p = current;
> > +	if (!p) {
> > +		read_unlock(&tasklist_lock);
> > +		panic("Out of memory and no killable processes...\n");
> > +	}
> >  
> >  	if (oom_kill_process(p, gfp_mask, 0, points, limit, mem,
> >  				"Memory cgroup out of memory"))
> > 
> 
> This actually does appear to be necessary but for a different reason: if 
> current is unkillable because it has OOM_DISABLE, for example, then 
> oom_kill_process() will repeatedly fail and mem_cgroup_out_of_memory() 
> will infinitely loop.
> 
> Kame-san?
> 

When a memcg goes into OOM and it only has unkillable processes (OOM_DISABLE),
we can do nothing. (we can't panic because container's death != system death.)

Because memcg itself has mutex+waitqueue for mutual execusion of OOM killer, 
I think infinite-loop will not be critical probelm for the whole system.

And, now, memcg has oom-kill-disable + oom-kill-notifier features.
So, If a memcg goes into OOM and there is no killable process, but oom-kill is
not disabled by memcg.....it means system admin's mis-configuraton.

He can stop inifite loop by hand, anyway.
# echo 1 > ..../group_A/memory.oom_control

Thanks,
-Kame


