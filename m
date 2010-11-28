Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751158Ab0K1Bpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 20:45:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13949 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0K1Bpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 20:45:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=M1ItwdHYMPi7pm0EYjzGY/sbVYGStXnpPvbqAdQMAbplj/qis94yhCUxLJRpQvkjjI
         2j9Lc4ATv83KQwWXZVDg==
Date: Sat, 27 Nov 2010 17:45:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
In-Reply-To: <20101123151731.7B7B.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011271743180.3764@chino.kir.corp.google.com>
References: <20101115113238.BF06.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com> <20101123151731.7B7B.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010, KOSAKI Motohiro wrote:

> > You may remember that the initial version of my rewrite replaced oom_adj 
> > entirely with the new oom_score_adj semantics.  Others suggested that it 
> > be seperated into a new tunable and the old tunable deprecated for a 
> > lengthy period of time.  I accepted that criticism and understood the 
> > drawbacks of replacing the tunable immediately and followed those 
> > suggestions.  I disagree with you that the deprecation of oom_adj for a 
> > period of two years is as dramatic as you imply and I disagree that users 
> > are experiencing problems with the linear scale that it now operates on 
> > versus the old exponential scale.
> 
> Yes and No. People wanted to separate AND don't break old one.
> 

You're arguing on the behalf of applications that don't exist.

> > > 1) About two month ago, Dave hansen observed strange OOM issue because he
> > >    has a big machine and ALL process are not so big. thus, eventually all 
> > >    process got oom-score=0 and oom-killer didn't work.
> > > 
> > >    https://kerneltrap.org/mailarchive/linux-driver-devel/2010/9/9/6886383
> > > 
> > >    DavidR changed oom-score to +1 in such situation. 
> > > 
> > >    http://kerneltrap.org/mailarchive/linux-kernel/2010/9/9/4617455
> > > 
> > >    But it is completely bognus. If all process have score=1, oom-killer fall
> > >    back to purely random killer. I expected and explained his patch has
> > >    its problem at half years ago. but he didn't fix yet.
> > > 
> > 
> > The resolution with which the oom killer considers memory is at 0.1% of 
> > system RAM at its highest (smaller when you have a memory controller, 
> > cpuset, or mempolicy constrained oom).  It considers a task within 0.1% of 
> > memory of another task to have equal "badness" to kill, we don't break 
> > ties in between that resolution -- it all depends on which one shows up in 
> > the tasklist first.  If you disagree with that resolution, which I support 
> > as being high enough, then you may certainly propose a patch to make it 
> > even finer at 0.01%, 0.001%, etc.  It would only change oom_badness() to 
> > range between [0,10000], [0,100000], etc.
> 
> No.
> Think Moore's Law. rational value will be not able to work in future anyway.
> 10 years ago, I used 20M bytes memory desktop machine and I'm now using 2GB.
> memory amount is growing and growing. and bash size doesn't grwoing so fast.
> 

If you'd like to suggest an increase to the upper-bound of the badness 
score, please do so, although I don't think we need to break ties amongst 
tasks that differ by at most <0.1% of the system's capacity.
