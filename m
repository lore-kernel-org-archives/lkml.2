Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab0FUOAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:00:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52527 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab0FUOAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:00:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qPYFWBPOZ4luvs/J3PNmcvqMzY4acf3VGACDlBQ7DYLhxNs4NySdvpNXCPqVZnKy9s
         3os9dFY7MNkectRs26lBxMCtVyL1e10eN/rh3Mf6LNc17QtDWAIDaFTYEnvIddl/wc7t
         vA6nQgLYG9rN1DzuDE+JxfrZc/0vKTXVQDqtI=
Date: Mon, 21 Jun 2010 23:00:32 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4/9] oom: oom_kill_process() need to check p is
 unkillable
Message-ID: <20100621140032.GA2456@barrios-desktop>
References: <20100617104647.FB89.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1006162118520.14101@chino.kir.corp.google.com>
 <20100617135224.FBAA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617135224.FBAA.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 08:45:45PM +0900, KOSAKI Motohiro wrote:
> > On Thu, 17 Jun 2010, KOSAKI Motohiro wrote:
> > 
> > > When oom_kill_allocating_task is enabled, an argument task of
> > > oom_kill_process is not selected by select_bad_process(), It's
> > > just out_of_memory() caller task. It mean the task can be
> > > unkillable. check it first.
> > > 
> > 
> > This should be unnecessary if oom_kill_process() appropriately returns 
> > non-zero when it cannot kill a task.  What problem are you addressing with 
> > this fix?
> 
> oom_kill_process() only check its children are unkillable, not its own.
> To add check oom_kill_process() also solve the issue. as my previous patch does.
> but Minchan pointed out it's unnecessary. because when !oom_kill_allocating_task
> case, we have the same check in select_bad_process(). 
> 
> 
> 

If kthread doesn't use other process's mm, oom_kill_process can return non-zero.
and it might be no problem. 
but let's consider following case that kthread use use_mm. 

if (oom_kill_allocating_task)
        oom_kill_process
                pr_err("kill process.."); <-- false alarm
                oom_kill_task
                        find_lock_task_mm if kthread use use_mm
                        kill kernel thread

Yes. it's a just theory that kthread use use_mm and is selected as victim.
But although kthread doesn't use use_mm, oom_kill_process emits false alarm.
As a matter of fact, it doesn't kill itself or sacrifice child.

I think victim process selection should be done before calling 
oom_kill_process. oom_kill_process and oom_kill_task's role is  
just to try to kill the process or process's children by best effort 
as function's name.

-- 
Kind regards,
Minchan Kim
