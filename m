Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab1H3WG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:06:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6805 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1H3WG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:06:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=gGcT/818Up6hqvQHDGx9mJAC/HgF6riwnrHj20B32JhGeq+ESBng186O0ZwEI5TXG
	xX3aEzUmd83hlJLD3rrJw==
Date: Tue, 30 Aug 2011 15:06:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ying Han <yinghan@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/2] oom: remove oom_disable_count
In-Reply-To: <20110830152856.GA22754@redhat.com>
Message-ID: <alpine.DEB.2.00.1108301503510.2730@chino.kir.corp.google.com>
References: <20110727175624.GA3950@redhat.com> <20110728154324.GA22864@redhat.com> <alpine.DEB.2.00.1107281341060.16093@chino.kir.corp.google.com> <20110729141431.GA3501@redhat.com> <20110730143426.GA6061@redhat.com> <20110730152238.GA17424@redhat.com>
 <4E369372.80105@jp.fujitsu.com> <20110829183743.GA15216@redhat.com> <alpine.DEB.2.00.1108291611070.32495@chino.kir.corp.google.com> <alpine.DEB.2.00.1108300040490.21066@chino.kir.corp.google.com> <20110830152856.GA22754@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011, Oleg Nesterov wrote:

> > @@ -447,6 +431,9 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
> >  	for_each_process(q)
> >  		if (q->mm == mm && !same_thread_group(q, p) &&
> >  		    !(q->flags & PF_KTHREAD)) {
> 
> (I guess this is on top of -mm patch)
> 

Yes, it's based on 
oom-avoid-killing-kthreads-if-they-assume-the-oom-killed-threads-mm.patch 
which I thought would be pushed for the 3.1 rc series, we certainly don't 
want to SIGKILL kthreads :)

> > +			if (q->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
> > +				continue;
> > +
> 
> Afaics, this is the only change apart from "removes mm->oom_disable_count
> entirely", looks reasonable to me.
> 

Yeah, it's necessary because this loop in oom_kill_task() kills all 
user threads in different thread groups unconditionally if they share the 
same mm, so we need to ensure that we aren't sending a SIGKILL to anything 
that is actually oom disabled.  Before, the check in oom_badness() would 
have prevented the task (`p' in this function) from being chosen in the 
first place.
