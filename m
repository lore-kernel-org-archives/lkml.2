Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0KKXTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:19:16 -0500
Received: from smtp-out.google.com ([74.125.121.35]:18291 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0KKXTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:19:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=E+xgZtCxcQSCGMvvJPMEd2pHJ8ftpmw5Yf0zMKMv7DuDI15HlEGgnanPbEfLCyNygM
         o0oqlSg1NLjcDNpVXoVA==
Date: Thu, 11 Nov 2010 15:19:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mandeep Singh Baines <msb@chromium.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
In-Reply-To: <20101111222509.GJ7363@google.com>
Message-ID: <alpine.DEB.2.00.1011111511570.3775@chino.kir.corp.google.com>
References: <20101111043541.GA4588@google.com> <alpine.DEB.2.00.1011102328080.7571@chino.kir.corp.google.com> <20101111183050.GI7363@google.com> <alpine.DEB.2.00.1011111241450.25829@chino.kir.corp.google.com> <20101111222509.GJ7363@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Mandeep Singh Baines wrote:

> > Hmm, at first glance that seems potentially dangerous if the current tab 
> > generates a burt of memory allocations and it ends up killing all other 
> > tabs before finally targeting the culprit whereas currently the heuristic 
> > should do a good job of finding this problematic tab and killing it 
> > instantly.
> > 
> 
> If you're watching a movie, video chatting, playing a game, etc. What
> would you rather have killed: the current tab you are interacting with or
> some tab you opened a while back and are no longer interacting with.
> 

Well, it's a tangential point, but I'd personally prefer that my existing 
tabs that I've decided to leave open are guaranteed to remain open 
regardless of where I'm browsing next (they could hold valuable data that 
I can't easily get back) and avoid having all of them sacrificed out from 
under me for the newly opened tab.  I can always go back and close those 
tabs for more memory if I know I don't need them anymore and then retry 
the failed allocation.

> > So as more and more tabs get used, the least recently used tab gets its 
> > oom_score_adj raised higher and higher until it is reused itself and then 
> > it gets reset back to 0 for the current tab?
> > 
> 
> Exactly.
> 

We don't necessarily want arbitrary tasks to be able to decrease their 
oom_score_adj back to 0 if a CAP_SYS_RESOURCE thread has elevated it, 
that's part of the reason for the restriction (in addition to decreasing 
your own oom_score_adj all the way to OOM_SCORE_ADJ_MIN).

Would it suffice to allow a task to decrease its oom_score_adj back to the 
highest value that a CAP_SYS_RESOURCE thread set it or its inherited value 
at fork?  Assuming the thread that has forked it has oom_score_adj of 0, 
each tab could decrease it back from 0 upon activation unless a 
CAP_SYS_RESOURCE thread elevated it to something higher.

To do this, we'd need to save the highest oom_score_adj set by a 
CAP_SYS_RESOURCE in struct signal_struct.
