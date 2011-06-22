Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab1FVXWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 19:22:24 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23612 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab1FVXWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 19:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JHiMhNVj+MnKnJIYgcI5SQ2VXY55BFhnq4ex6gHMG+lS5I7bcShdwN3/9JgeGOJRl4
         +ALnB89ssiXgZGLgwQEw==
Date: Wed, 22 Jun 2011 16:22:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 5/6] oom: don't kill random process
In-Reply-To: <4E01C88E.3070806@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1106221617280.11759@chino.kir.corp.google.com>
References: <4E01C7D5.3060603@jp.fujitsu.com> <4E01C88E.3070806@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, KOSAKI Motohiro wrote:

> CAI Qian reported oom-killer killed all system daemons in his
> system at first if he ran fork bomb as root. The problem is,
> current logic give them bonus of 3% of system ram. Example,
> he has 16GB machine, then root processes have ~500MB oom
> immune. It bring us crazy bad result. _all_ processes have
> oom-score=1 and then, oom killer ignore process memroy usage
> and kill random process. This regression is caused by commit
> a63d83f427 (oom: badness heuristic rewrite).
> 

Isn't it better to give admin processes a proportional bonus instead of a 
strict 3% bonus?  I suggested 1% per 10% of memory used earlier and I 
think it would work quite well as an alternative to this.  The highest 
bonus that would actually make any differences in which thread to kill 
would be 5% when an admin process is using 50% of memory: in that case, 
another non-admin thread would have to be using >45% of memory to be 
killed instead.

Would you be satisfied with something like

	points -= (points * 10 / totalpages);

be better?
