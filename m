Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2EIN5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:57:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56892 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2EIN5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:57:37 -0400
Date: Wed, 9 May 2012 06:57:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, yinghan@google.com,
        kosaki.motohiro@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: rcu: BUG on exit_group
Message-ID: <20120509135714.GC21152@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+1xoqd_z8Zavzraq1oXVRpwkJRoac57tojBYf7x=Kzs+cbJ_w@mail.gmail.com>
 <20120503154140.GA2592@linux.vnet.ibm.com>
 <CA+1xoqepggR4YRzDXFz=Hk9EeXACMRyeXorQm7rE3r5MQyY6Fw@mail.gmail.com>
 <20120503170101.GF2592@linux.vnet.ibm.com>
 <CA+1xoqcXMVG0J4r8XhtzcxxDqLuyR30x5a3o8BsrBqDakDdHgg@mail.gmail.com>
 <20120504053331.GA16836@linux.vnet.ibm.com>
 <4FA9F9CF.8050706@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA9F9CF.8050706@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050913-7606-0000-0000-000000364A91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 01:59:59PM +0900, KAMEZAWA Hiroyuki wrote:
> (2012/05/04 14:33), Paul E. McKenney wrote:
> 
> > On Fri, May 04, 2012 at 06:08:34AM +0200, Sasha Levin wrote:
> >> On Thu, May 3, 2012 at 7:01 PM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >>> On Thu, May 03, 2012 at 05:55:14PM +0200, Sasha Levin wrote:
> >>>> On Thu, May 3, 2012 at 5:41 PM, Paul E. McKenney
> >>>> <paulmck@linux.vnet.ibm.com> wrote:
> >>>>> On Thu, May 03, 2012 at 10:57:19AM +0200, Sasha Levin wrote:
> >>>>>> Hi Paul,
> >>>>>>
> >>>>>> I've hit a BUG similar to the schedule_tail() one when. It happened
> >>>>>> when I've started fuzzing exit_group() syscalls, and all of the traces
> >>>>>> are starting with exit_group() (there's a flood of them).
> >>>>>>
> >>>>>> I've verified that it indeed BUGs due to the rcu preempt count.
> >>>>>
> >>>>> Hello, Sasha,
> >>>>>
> >>>>> Which version of -next are you using?  I did some surgery on this
> >>>>> yesterday based on some bugs Hugh Dickins tracked down, so if you
> >>>>> are using something older, please move to the current -next.
> >>>>
> >>>> I'm using -next from today (3.4.0-rc5-next-20120503-sasha-00002-g09f55ae-dirty).
> >>>
> >>> Hmmm...  Looking at this more closely, it looks like there really is
> >>> an attempt to acquire a mutex within an RCU read-side critical section,
> >>> which is illegal.  Could you please bisect this?
> >>
> >> Right, the issue is as you described, taking a mutex inside rcu_read_lock().
> >>
> >> The offending commit is (I've cc'ed all parties from it):
> >>
> >> commit adf79cc03092ee4aec70da10e91b05fb8116ac7b
> >> Author: Ying Han <yinghan@google.com>
> >> Date:   Thu May 3 15:44:01 2012 +1000
> >>
> >>     memcg: add mlock statistic in memory.stat
> >>
> >> With the issue there being is that in munlock_vma_page(), it now does
> >> a mem_cgroup_begin_update_page_stat() which takes the rcu_read_lock(),
> >> so when the older code that was there previously will try taking a
> >> mutex you'll get a BUG.
> > 
> > Hmmm...  One approach would be to switch from rcu_read_lock() to
> > srcu_read_lock(), though this means carrying the index returned from
> > the srcu_read_lock() to the matching srcu_read_unlock() -- and making
> > the update side use synchronize_srcu() rather than synchronize_rcu().
> > Alternatively, it might be possible to defer acquiring the lock until
> > after exiting the RCU read-side critical section, but I don't know enough
> > about mm to even guess whether this might be possible.
> > 
> > There are probably other approaches as well...
> 
> 
> How about this ?

That looks to me to avoid acquiring the mutex within an RCU read-side
critical section, so good.  I have to defer to you guys on whether the
placement of the mem_cgroup_end_update_page_stat() works.

							Thanx, Paul

> ==
> [PATCH] memcg: fix taking mutex under rcu at munlock
> 
> Following bug was reported because mutex is held under rcu_read_lock().
> 
> [   83.820976] BUG: sleeping function called from invalid context at
> kernel/mutex.c:269
> [   83.827870] in_atomic(): 0, irqs_disabled(): 0, pid: 4506, name: trinity
> [   83.832154] 1 lock held by trinity/4506:
> [   83.834224]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff811a7d87>]
> munlock_vma_page+0x197/0x200
> [   83.839310] Pid: 4506, comm: trinity Tainted: G        W
> 3.4.0-rc5-next-20120503-sasha-00002-g09f55ae-dirty #108
> [   83.849418] Call Trace:
> [   83.851182]  [<ffffffff810e7218>] __might_sleep+0x1f8/0x210
> [   83.854076]  [<ffffffff82d9540a>] mutex_lock_nested+0x2a/0x50
> [   83.857120]  [<ffffffff811b0830>] try_to_unmap_file+0x40/0x2f0
> [   83.860242]  [<ffffffff82d984bb>] ? _raw_spin_unlock_irq+0x2b/0x80
> [   83.863423]  [<ffffffff810e7ffe>] ? sub_preempt_count+0xae/0xf0
> [   83.866347]  [<ffffffff82d984e9>] ? _raw_spin_unlock_irq+0x59/0x80
> [   83.869570]  [<ffffffff811b0caa>] try_to_munlock+0x6a/0x80
> [   83.872667]  [<ffffffff811a7cc6>] munlock_vma_page+0xd6/0x200
> [   83.875646]  [<ffffffff811a7d87>] ? munlock_vma_page+0x197/0x200
> [   83.878798]  [<ffffffff811a7e7f>] munlock_vma_pages_range+0x8f/0xd0
> [   83.882235]  [<ffffffff811a8b8a>] exit_mmap+0x5a/0x160
> 
> This bug was introduced by mem_cgroup_begin/end_update_page_stat()
> which uses rcu_read_lock(). This patch fixes the bug by modifying
> the range of rcu_read_lock().
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/mlock.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 2fd967a..05ac10d1 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -123,6 +123,7 @@ void munlock_vma_page(struct page *page)
>  	if (TestClearPageMlocked(page)) {
>  		dec_zone_page_state(page, NR_MLOCK);
>  		mem_cgroup_dec_page_stat(page, MEMCG_NR_MLOCK);
> +		mem_cgroup_end_update_page_stat(page, &locked, &flags);
>  		if (!isolate_lru_page(page)) {
>  			int ret = SWAP_AGAIN;
> 
> @@ -154,8 +155,8 @@ void munlock_vma_page(struct page *page)
>  			else
>  				count_vm_event(UNEVICTABLE_PGMUNLOCKED);
>  		}
> -	}
> -	mem_cgroup_end_update_page_stat(page, &locked, &flags);
> +	} else
> +		mem_cgroup_end_update_page_stat(page, &locked, &flags);
>  }
> 
>  /**
> -- 
> 1.7.4.1
> 
> 
> 

