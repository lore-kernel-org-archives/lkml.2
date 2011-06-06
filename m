Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab1FFOpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:45:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45370 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1FFOpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g3A91e1O2Ut15RfJpWqPOgKHFl0L3LieKfLwk8GYGFd/0OyL0+7GU5GzRR7HuXWPee
         ERrMAxXfB0Korni7QeyCtOrRv4WYvjDl4opssJf05uAVXT0CfPeXJySktl5bqfBnA3JE
         +cYKu8OhNe4RY6c6ZJaJlvdPFd9RGeG6+QgTE=
Date: Mon, 6 Jun 2011 23:44:59 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: caiqian@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Subject: Re: [PATCH v2 0/5] Fix oom killer doesn't work at all if system
 have > gigabytes memory  (aka CAI founded issue)
Message-ID: <20110606144458.GG1686@barrios-laptop>
References: <348391538.318712.1306828778575.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <4DE4A2A0.6090704@jp.fujitsu.com>
 <4DE4BC64.3040807@jp.fujitsu.com>
 <20110601033258.GA12653@barrios-laptop>
 <4DEC4463.1060206@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEC4463.1060206@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 12:07:15PM +0900, KOSAKI Motohiro wrote:
> >> Of course, we recommend to drop privileges as far as possible
> >> instead of keeping them. Thus, oom killer don't have to check
> >> any capability. It implicitly suggest wrong programming style.
> >>
> >> This patch change root process check way from CAP_SYS_ADMIN to
> >> just euid==0.
> > 
> > I like this but I have some comments.
> > Firstly, it's not dependent with your series so I think this could
> > be merged firstly.
> 
> I agree.
> 
> > Before that, I would like to make clear my concern.
> > As I look below comment, 3% bonus is dependent with __vm_enough_memory's logic?
> 
> No. completely independent.
> 
> vm_enough_memory() check the task _can_ allocate more memory. IOW, the task
> is subjective. And oom-killer check the task should be protected from oom-killer.
> IOW, the task is objective.
> 

Hmm, maybe I can't understand your point.
My though was below.

Assumption)
1. root allocation bonus point -> 10% 
2. OOM have no bonus about root process

Scenario)
1.
System has 101 free pages and 10 normal tasks.
Ideally, 10 tasks allocates free memory fairly so each task will have 10 pages.
So OOM killer can select victim fairly when new task which requires 10 pages forks.

2.
System has 101 free pages and 10 tasks. (9 normal task , 1 root task)
10 * 9 + 11 will be consumed. So each normal task will have 10 pages
but a root task have 11 pages.
So OOM killer can always selectd root process as vicim.(We assumed
OOM doesn't have a bonus on root process)

Conclusion)
For solving above problem, we have to give bonus which was given
in allocation to OOM, too. It's fair.
So I think it has a dependency.

-- 
Kind regards
Minchan Kim
