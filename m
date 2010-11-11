Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab0KKWZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 17:25:26 -0500
Received: from smtp-out.google.com ([74.125.121.35]:53068 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073Ab0KKWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 17:25:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=Eixgpe9yKtoEO0/MwgvBl4kJ8zJX9TvhJzLd41VqhtnJVyd9jQ/LNqahobFcvqHqVy
         PUpwuhWCtsG0vTUJH+mQ==
Date: Thu, 11 Nov 2010 14:25:10 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org
Subject: Re: [PATCH] oom: create a resource limit for oom_adj
Message-ID: <20101111222509.GJ7363@google.com>
References: <20101111043541.GA4588@google.com>
 <alpine.DEB.2.00.1011102328080.7571@chino.kir.corp.google.com>
 <20101111183050.GI7363@google.com>
 <alpine.DEB.2.00.1011111241450.25829@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011111241450.25829@chino.kir.corp.google.com>
X-Operating-System: Linux/2.6.32-gg252-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes (rientjes@google.com) wrote:
> On Thu, 11 Nov 2010, Mandeep Singh Baines wrote:
> 
> > > What is the anticipated use case for this?  We know that you want to lower 
> > > oom_adj without CAP_SYS_RESOURCE, but what's the expected behavior when an 
> > > app moves from foreground to background?  I assume it's something like 
> > 
> > The focus here is the web browser's tabs. In our case, each is a process. If
> > OOM is going to kill a process, you'd rather it kill the tab you looked at
> > hours ago instead of the one you're looking at now. So you'd like to have a
> > policy where the LRU tab gets killed first. We'd like to use oom_score_adj
> > as the mechanism to implement an LRU policy like this.
> > 
> 
> Hmm, at first glance that seems potentially dangerous if the current tab 
> generates a burt of memory allocations and it ends up killing all other 
> tabs before finally targeting the culprit whereas currently the heuristic 
> should do a good job of finding this problematic tab and killing it 
> instantly.
> 

If you're watching a movie, video chatting, playing a game, etc. What
would you rather have killed: the current tab you are interacting with or
some tab you opened a while back and are no longer interacting with.

> Perhaps that can't happen and it probably doesn't even matter: 
> oom_score_adj allows users to determine which process to kill regardless 
> of the underlying reason.
> 
> > > What do you anticipate will be writing to oom_score_adj with this patch, 
> > > the app itself?
> > 
> > A process in the browser session will do the adusting. We'd rather not give
> > it CAP_SYS_RESOURCE. It should only be allowed to change oom_score_adj up
> > and down within the bounds set by the administrator. Analagous to renice()
> > which we also do using a similar policy.
> > 
> 
> So as more and more tabs get used, the least recently used tab gets its 
> oom_score_adj raised higher and higher until it is reused itself and then 
> it gets reset back to 0 for the current tab?
> 

Exactly.

> Is there a reason you don't want to give the underlying browser session 
> process CAP_SYS_RESOURCE?  Will it not be enforcing resource limits to 

Security. We want to use the least-privilege possible. We really want to
avoid giving special privileges to the browser. You shouldn't need
administrative privileges to run the browser. We'd like for oom_score_adj
to work the same as nice. An unprivileged user can nice up and down as
long as the new setting is within the administratively configured
resource limit: ulimit -e.

> ensure tabs don't deplete all memory when certain sites are opened?  Are 
> you concerned that it may deplete all memory itself (for which case you 
> could raise its own oom_score_adj, which is a proportion of available 
> memory so you can define where that point of depletiong is)?
