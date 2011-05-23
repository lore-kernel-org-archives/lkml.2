Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab1EWW2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:28:39 -0400
Received: from smtp-out.google.com ([74.125.121.67]:51005 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010Ab1EWW2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gzvExn+VpQeZ5fu9tB/FaWs4rkuLPsCwgtEvWoTdE9JQxtCN3zbC8anIy2HyJbqevc
         qGeyozM65x9WFNPTbKtQ==
Date: Mon, 23 May 2011 15:28:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram
 internally
In-Reply-To: <4DD6204D.5020109@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105231522410.17840@chino.kir.corp.google.com>
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6204D.5020109@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011, KOSAKI Motohiro wrote:

> CAI Qian reported his kernel did hang-up if he ran fork intensive
> workload and then invoke oom-killer.
> 
> The problem is, current oom calculation uses 0-1000 normalized value
> (The unit is a permillage of system-ram). Its low precision make
> a lot of same oom score. IOW, in his case, all processes have smaller
> oom score than 1 and internal calculation round it to 1.
> 
> Thus oom-killer kill ineligible process. This regression is caused by
> commit a63d83f427 (oom: badness heuristic rewrite).
> 
> The solution is, the internal calculation just use number of pages
> instead of permillage of system-ram. And convert it to permillage
> value at displaying time.
> 
> This patch doesn't change any ABI (included  /proc/<pid>/oom_score_adj)
> even though current logic has a lot of my dislike thing.
> 

Same response as when you initially proposed this patch: 
http://marc.info/?l=linux-kernel&m=130507086613317 -- you never replied to 
that.

The changelog doesn't accurately represent CAI Qian's problem; the issue 
is that root processes are given too large of a bonus in comparison to 
other threads that are using at most 1.9% of available memory.  That can 
be fixed, as I suggested by giving 1% bonus per 10% of memory used so that 
the process would have to be using 10% before it even receives a bonus.

I already suggested an alternative patch to CAI Qian to greatly increase 
the granularity of the oom score from a range of 0-1000 to 0-10000 to 
differentiate between tasks within 0.01% of available memory (16MB on CAI 
Qian's 16GB system).  I'll propose this officially in a separate email.

This patch also includes undocumented changes such as changing the bonus 
given to root processes.
