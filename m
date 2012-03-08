Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab2CHUdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:33:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab2CHUdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:33:42 -0500
Date: Thu, 8 Mar 2012 15:33:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk,
        hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120308203331.GE22922@redhat.com>
References: <20120305221321.GF1263@google.com>
 <20120306210954.GF32148@redhat.com>
 <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307150549.955d6f9c.akpm@linux-foundation.org>
 <20120308175708.GB22922@redhat.com>
 <20120308180833.GA25508@google.com>
 <20120308201616.GD22922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308201616.GD22922@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 03:16:16PM -0500, Vivek Goyal wrote:
> On Thu, Mar 08, 2012 at 10:08:33AM -0800, Tejun Heo wrote:
> 
> [..]
> > > Tejun, I noticed that in UP case, once in a while cgroup removal is
> > > hanging. Looks like it is hung in cgroup_rmdir() somewhere. I will debug
> > > more to find out what is happening. May be blkcg->refcount issue.
> > 
> > It's probably from something forgetting to put cgroup and pre_destroy
> > waiting for it.  Such bugs would have been masked before but now show
> > up as stalls during rmdir.
> 
> I am not sure what is happening here yet. What I have noticed that
> somebody is holding a reference on blkg->refcnt and that's why css->refcnt
> is not zero hence rmdir is hanging.
> 
> I susect it is cfqq refcount on blkg which is not released till cfqq is
> reclaimed.
> 
> Looking at the code, in general it seems to be a problem. If a task 
> issues bunch of IO, changes the cgroup and does not issue IO any more
> for some time, that means old cfqq will still be linked to task's
> cic and still be holding reference to blkg and one can't remove the
> cgroup.
> 
> We had this disucssion in the past. So looks like to get rid of this
> problem, you will have to drop old cic->cfqq association during
> cgroup change to avoid hanging rmdir.

Ok, I can confirm that it is cfqq reference on blkg which is an issue. If
I move my shell to a child cgroup and try to do some operations (in the
context of shell, like autocompletion/reading an uncached dir), then IO
is issued in the context of shell, I move out the shell out of cgroup and
then try to delete it, it hangs. Once I exit out of shell, blkg reference
is dropped and cgroup is deleted.

So we do need to cleanup the cic->cfqq upon cgroup change synchronously.

That will still not solve the issue of a process dumping tons of
IO on device (large nr_requests) and then moving out of cgroup. Now
cgroup deletion will still hang till all the IO in the cgroup
completes.

Thanks
Vivek
