Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1EJXWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:22:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab1EJXWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:22:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=fcU8uU6NqR3MO54kJwmos55WcVay0Lk13OhkhHD2UqtgF8g8N+xRcJ1WDKJWf9OXSd
         xgS8aoOdfwRPSAdtv4CQ==
Date: Tue, 10 May 2011 16:22:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: CAI Qian <caiqian@redhat.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: OOM Killer don't works at all if the system have >gigabytes
 memory (was Re: [PATCH] mm: check zone->all_unreclaimable in
 all_unreclaimable())
In-Reply-To: <20110510171335.16A7.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105101607200.12477@chino.kir.corp.google.com>
References: <1491537913.283996.1304930866703.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <20110509182110.167F.A69D9226@jp.fujitsu.com> <20110510171335.16A7.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011, KOSAKI Motohiro wrote:

> OK. That's known issue. Current OOM logic doesn't works if you have
> gigabytes RAM. because _all_ process have the exactly same score (=1).
> then oom killer just fallback to random process killer. It was made
> commit a63d83f427 (oom: badness heuristic rewrite). I pointed out
> it at least three times. You have to blame Google folks. :-/
> 

If all threads have the same badness score, which by definition must be 1 
since that is the lowest badness score possible for an eligible thread, 
then each thread is using < 0.2% of RAM.

The granularity of the badness score doesn't differentiate between threads  
using 0.1% of RAM in terms of priority for kill (in this case, 16MB).  The 
largest consumers of memory from CAI's log have an rss of 336MB, which is 
~2% of system RAM.  The problem is that these are forked by root and 
therefore get a 3% bonus, making their badness score 1 instead of 2.

 [ You also don't have to blame "Google folks," I rewrote the oom
   killer. ]

> 
> The problems are three.
> 
> 1) if two processes have the same oom score, we should kill younger process.
>    but current logic kill older. Oldest processes are typicall system daemons.

Agreed, that seems advantageous to prefer killing threads that have done 
the least amount of work (defined as those with the least runtime compared 
to others in the tasklist order) over others.

> 2) Current logic use 'unsigned int' for internal score calculation. (exactly says,
>    it only use 0-1000 value). its very low precision calculation makes a lot of
>    same oom score and kill an ineligible process.

The range of 0-1000 allows us to differentiate tasks up to 0.1% of system 
RAM from each other when making oom kill decisions.  If we really want to 
increase this granularity, we could increase the value to 10000 and then 
multiple oom_score_adj values by 10.

> 3) Current logic give 3% of SystemRAM to root processes. It obviously too big
>    if you have plenty memory. Now, your fork-bomb processes have 500MB OOM immune
>    bonus. then your fork-bomb never ever be killed.
> 

I agree that a constant proportion for root processes is probably not 
ideal, especially in situations where there are many small threads that 
only use about 1% of system RAM, such as in CAI's case.  I don't agree 
that we need to guard against forkbombs created by root, however.  The 
worst case scenario is that the continuous killing of non-root threads 
will allow the admin to fix his or her error.
