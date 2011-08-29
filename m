Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1H2XSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:18:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1709 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab1H2XSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:18:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=fEvBRZF705ktIjmEu7S5TPZcFu46PZEWgDARhM/n3cuLFYAcdKFaZcZ2+vi+eLx1b
	NS1lAFILpL/5e0X8rXWWQ==
Date: Mon, 29 Aug 2011 16:17:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>, Ying Han <yinghan@google.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, roland@hack.frob.com,
        tj@kernel.org, dvlasenk@redhat.com, matt.fleming@linux.intel.com,
        linux-kernel@vger.kernel.org, avagin@openvz.org, fhrbata@redhat.com
Subject: Re: mm->oom_disable_count is broken
In-Reply-To: <20110829183743.GA15216@redhat.com>
Message-ID: <alpine.DEB.2.00.1108291611070.32495@chino.kir.corp.google.com>
References: <20110727163159.GA23785@redhat.com> <20110727163610.GJ23793@redhat.com> <20110727175624.GA3950@redhat.com> <20110728154324.GA22864@redhat.com> <alpine.DEB.2.00.1107281341060.16093@chino.kir.corp.google.com> <20110729141431.GA3501@redhat.com>
 <20110730143426.GA6061@redhat.com> <20110730152238.GA17424@redhat.com> <4E369372.80105@jp.fujitsu.com> <20110829183743.GA15216@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Oleg Nesterov wrote:

> > IIRC, I did pointed out this issue. But nobody replied.
> > I think ->oom_disable_count is currently broken. but now I have no time to
> > audit this stuff. So, I'd suggest to revert this code if nobody don't fix it.
> 
> I tend to agree, of course we can fix oom_disable_count but I don't
> really understand why do we want it.
> 

I'd rather just remove it entirely, we'll have to ask it's author.  Ying, 
do you see a reason to keep oom_disable_count around?

The only thing that I can see it doing is preventing a thread that shares 
an ->mm with an unkillable thread from being killed itself since it won't 
lead to future memory freeing.  It prevents the second tasklist iteration 
after a task has been chosen to check if another thread sharing the memory 
cannot be killed.

I'd rather just kill the thread anyway because there's a chance that the 
OOM_DISABLE thread is waiting on it and may free its memory as well and 
there's no guarantee that when you set a thread to be OOM_DISABLE that all 
threads sharing the same memory are disabled as well.

> And. personally I dislike it because ->oom_disable_count is just another
> proof that ->oom_score_adj should be in ->mm, not per-process. IIRC,
> you already explained me why we can't do this, but - sorry - I forgot.
> May be something with vfork... Could you explain this again?
> 

I actually really wanted oom_score_adj to be in the ->mm, it would 
simplify a lot of the code :)  The problem was the inheritance property: 
we expect a job scheduler that is OOM_DISABLE to be able to vfork, change 
the oom_score_adj of the child, and then exec so that it is not oom 
disabled before starting to allocate memory.  If this were in the mm, then 
setting the oom_score_adj of the child prior to exec would change the job 
scheduler's oom score as well.
