Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab0KJUvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:51:01 -0500
Received: from smtp-out.google.com ([74.125.121.35]:11119 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab0KJUvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:51:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=hcv4DsFzLo5Mib+D4jBnJIy+xcYz5MnLhNWI1rS7Xp+PpE5Fj7mxfUIbjnsUzzUzq7
         5enSuL0mqy3EPogdQSvw==
Date: Wed, 10 Nov 2010 12:50:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <figo1802@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
In-Reply-To: <1289399891.10699.14.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1011101242240.830@chino.kir.corp.google.com>
References: <1288834737.2124.11.camel@myhost> <alpine.DEB.2.00.1011031847450.21550@chino.kir.corp.google.com> <20101109195726.BC9E.A69D9226@jp.fujitsu.com> <20101109122437.2e0d71fd@lxorguk.ukuu.org.uk> <alpine.DEB.2.00.1011091300510.7730@chino.kir.corp.google.com>
 <1289399891.10699.14.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Figo.zhang wrote:

> > I didn't check earlier, but CAP_SYS_RESOURCE hasn't had a place in the oom 
> > killer's heuristic in over five years, so what regression are we referring 
> > to in this thread?  These tasks already have full control over 
> > oom_score_adj to modify its oom killing priority in either direction.
> 
> yes, it can control by user, but is it all system administrators will
> adjust all of the processes by each one and one in real word? suppose if
> it has thousands of processes in database system.
> 

Yes, the kernel can't possibly know the oom killing priorities of your 
task so if you have such requirements then you must use the userspace 
tunable.

> > Futhermore, the heuristic was entirely rewritten, but I wouldn't consider 
> > all the old factors such as cputime and nice level being removed as 
> > "regressions" since the aim was to make it more predictable and more 
> > likely to kill a large consumer of memory such that we don't have to kill 
> > more tasks in the near future.
> 
> the goal of oom_killer is to find out the best process to kill, the one
> should be:
> 1. it is a most memory comsuming process in all processes
> 2. and it was a proper process to kill, which will not be let system 
> into unpredictable state as possible.
> 

There are four types of tasks that are improper to kill and this is 
relatively unchanged in the past five years of the oom killer:

 - init,

 - kthreads,

 - tasks that are bound to a disjoint set of cpuset mems or mempolicy 
   nodes that are not oom, and

 - those disabled from oom killing by userspace.

That does not include CAP_SYS_RESOURCE, nor CAP_SYS_ADMIN.  Your argument 
about killing some tasks that have CAP_SYS_RESOURCE leaving hardware in an 
unpredictable state isn't even addressed by your own patch, you only give 
them a 3% memory bonus so they are still eligible.

As mentioned previously, for this patch to make sense, you would need to 
show that CAP_SYS_RESOURCE equates to 3% of the available memory's 
capacity for a task.  I don't believe that evidence has been presented.  
This has nothing to do with preventing these threads from being killed (at 
the risk of possibly panicking the machine) since your patch doesn't do 
that.

> if a user process and a process such email cleint "evolution" with
> ditecly hareware access such as "Xorg", they have eat the equal memory,
> so which process are you want to kill?
> 

Both have equal oom killing priority according to the heuristic if they 
are not run by root.  If you would like to protect Xorg, then you need to 
use the userspace tunable to protect it just like everything else does.  
This is completely unchanged from the oom killer rewrite.

If you actually have a problem that you're reporting, however, it would 
probably be better to show the oom killer log from that event and let us 
address it instead of introducing arbitrary heuristics into something 
which aims to be as predictable as possible.
