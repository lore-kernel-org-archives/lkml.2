Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab1FITmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:42:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6757 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1FITmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:42:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=FND/pzvtBV5UYRvmKTwYsd0TLqe1Jqb82OgbKlIwXJlp2M9N1bMnYbXaQ6LGrYKGFl
         6ourdzojSU75mgE2gr+w==
Date: Thu, 9 Jun 2011 12:42:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, vnagarnaik@google.com,
        mingo@redhat.com, fweisbec@gmail.com, mrubin@google.com,
        dhsharp@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] trace: Set __GFP_NORETRY flag for ring buffer allocating
 process
In-Reply-To: <1307621668.9218.37.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1106091237580.11607@chino.kir.corp.google.com>
References: <1307490088-8612-1-git-send-email-vnagarnaik@google.com> <1307491302-9236-1-git-send-email-vnagarnaik@google.com> <4DF0B097.7010805@jp.fujitsu.com> <1307621668.9218.37.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011, Steven Rostedt wrote:

> > Unfortunately, __GFP_NORETRY is racy and don't work as expected.
> > If free memory is not enough, the thread may start to reclaim and
> > another thread can steal the reclaimed memory. And thread0 don't retry.
> > 
> > Then, thread0's alloc page may fail even though system have enough reclaimable
> > memory.
> > 
> >         thread0                                        thread1
> >         ---------------------------------------------------------------
> >         alloc_pages()
> >            get_page_from_freelist() -> fail
> >            try_to_free_pages()
> >                                                     alloc_pages()
> >                                                        get_page_from_freelist() -> success
> >            get_page_from_freelist() -> fail again
> > 
> > I think this is mm issue, and afaik, Minchan and some developers are
> > working on fixing it. but _now_ your patch doesn't work.
> 
> Have you seen this fail in practice?
> 
> I'm not too concern if it only triggers when memory is tight. But if it
> is triggering on normal cases, then that worries me.
> 

It would only happen if there was an antagonist that stole the reclaimed 
pages before your __GFP_NORETRY allocation could allocate them, resulting 
in the system being oom again as it was before reclaim occurred.  Without 
__GFP_NORETRY, we'd automatically retry these allocations in a loop until 
we found the memory since they are order-0, so the only side effect would 
be an increased latency in the allocation.  I think if we still end up oom 
after reclaiming memory that was allocated by another thread that we 
probably don't want to be expanding the ring buffer and, thus, I see no 
problem with just failing.
