Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0IIVKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:10:18 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56317 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0IIVKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:10:16 -0400
Subject: Re: [patch -rc] oom: always return a badness score of non-zero for
 eligible tasks
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1009091351090.19800@chino.kir.corp.google.com>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>
	 <1284053081.7586.7910.camel@nimitz>
	 <alpine.DEB.2.00.1009091152090.5556@chino.kir.corp.google.com>
	 <1284061683.7586.8100.camel@nimitz>
	 <alpine.DEB.2.00.1009091351090.19800@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 09 Sep 2010 14:10:08 -0700
Message-ID: <1284066608.7586.8189.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 14:00 -0700, David Rientjes wrote:
> On Thu, 9 Sep 2010, Dave Hansen wrote:
> > > I'm curious why there are no killable processes on the system; it seems 
> > > like the triggering task here, cat, would at least be killable itself.  
> > > Could you post the tasklist dump that preceeds this (or, if you've 
> > > disabled it try echo 1 > /proc/sys/vm/oom_dump_tasks first)?
> > 
> > That was one odd part here.  I didn't disable the tasklist dump, and
> > there was none in the dump.
> 
> Hmm, could you very that /proc/sys/vm/oom_dump_tasks is set?  Perhaps it's 
> getting cleared by something else before you use zram.  The sysctl should 
> default to on as of 2.6.36-rc1.

I double-checked.  It defaults to on and remains that way.

> > > It's possible that if you have enough swap that none of the eligible tasks 
> > > actually have non-zero badness scores either because they are being run as 
> > > root or because the amount of RAM or swap is sufficiently high such that 
> > > (task's rss + swap) / (total rss + swap) is never non-zero.  And, since 
> > > root tasks have a 3% bonus, it's possible these are all root tasks and no 
> > > single task uses more than 3% of rss and swap.
> > 
> > It's a 64GB machine with ~30GB of swap and very little RSS.  Your
> > hypothesis seems correct.  Just grepping through /proc/[0-9]*/oom_score
> > shows nothing other than 0's.
> 
> Presumably you're not using a large amount of swap, either, or that would 
> be accounted for in oom_score.

Nope.  There's very little happening on the system except for me toying
with the compcache device.

> > Trying this again, I just hung the system instead of OOM'ing straight
> > away like last time.
> 
> with the patch, you should still be calling the oom killer and instead of 
> panicking it will go on a serial killing spree because everything that it 
> wasn't judging as a candidate before (oom_score of 0) now is if it's truly 
> killable (oom_score of 1).  The patch is definitely needed for correctness 
> since an oom_score of 0 implies the task is unkillable.
> 
> We're apparently hanging in the exit path for the oom killed task or 
> something is constantly respawning threads that repeatedly get killed.  It 
> appears as though nothing is actually a worthwhile target for the oom 
> killer, however, and this is a bad configuration.

I'll give the patch a shot and see if I get any better behavior.  But, I
really do think the root cause here is compcache exhausting the system
when you feed incompressible pages into it.  We can kill all the tasks
we want, but I think it'll continue to gobble memory up as fast as we
free it.

We either need to put some upper bounds on the amount of memory that
compcache uses for its backing store, or reintroduce the code that lets
it fall back to swap.

> > Your patch makes a lot of sense to me in any case where there aren't
> > large-RSS tasks around using memory.  That definitely applies here
> > because of the amount in the compcache store and might also apply with
> > ramfs and hugetlbfs.
> > 
> 
> Agreed, we'll need to address hugepages specifically because they don't 
> get accounted for in rss but do free memory when the task is killed.

They do sometimes.  But, if they're preallocated, or stuck in a linked
file on the filesystem, killing the task doesn't do any good.

-- Dave

