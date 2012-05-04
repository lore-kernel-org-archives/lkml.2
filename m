Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab2EDFdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 01:33:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57327 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2EDFdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 01:33:45 -0400
Date: Thu, 3 May 2012 22:33:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, yinghan@google.com,
        kosaki.motohiro@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: rcu: BUG on exit_group
Message-ID: <20120504053331.GA16836@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+1xoqd_z8Zavzraq1oXVRpwkJRoac57tojBYf7x=Kzs+cbJ_w@mail.gmail.com>
 <20120503154140.GA2592@linux.vnet.ibm.com>
 <CA+1xoqepggR4YRzDXFz=Hk9EeXACMRyeXorQm7rE3r5MQyY6Fw@mail.gmail.com>
 <20120503170101.GF2592@linux.vnet.ibm.com>
 <CA+1xoqcXMVG0J4r8XhtzcxxDqLuyR30x5a3o8BsrBqDakDdHgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+1xoqcXMVG0J4r8XhtzcxxDqLuyR30x5a3o8BsrBqDakDdHgg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050405-4242-0000-0000-0000018D892D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 06:08:34AM +0200, Sasha Levin wrote:
> On Thu, May 3, 2012 at 7:01 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, May 03, 2012 at 05:55:14PM +0200, Sasha Levin wrote:
> >> On Thu, May 3, 2012 at 5:41 PM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Thu, May 03, 2012 at 10:57:19AM +0200, Sasha Levin wrote:
> >> >> Hi Paul,
> >> >>
> >> >> I've hit a BUG similar to the schedule_tail() one when. It happened
> >> >> when I've started fuzzing exit_group() syscalls, and all of the traces
> >> >> are starting with exit_group() (there's a flood of them).
> >> >>
> >> >> I've verified that it indeed BUGs due to the rcu preempt count.
> >> >
> >> > Hello, Sasha,
> >> >
> >> > Which version of -next are you using?  I did some surgery on this
> >> > yesterday based on some bugs Hugh Dickins tracked down, so if you
> >> > are using something older, please move to the current -next.
> >>
> >> I'm using -next from today (3.4.0-rc5-next-20120503-sasha-00002-g09f55ae-dirty).
> >
> > Hmmm...  Looking at this more closely, it looks like there really is
> > an attempt to acquire a mutex within an RCU read-side critical section,
> > which is illegal.  Could you please bisect this?
> 
> Right, the issue is as you described, taking a mutex inside rcu_read_lock().
> 
> The offending commit is (I've cc'ed all parties from it):
> 
> commit adf79cc03092ee4aec70da10e91b05fb8116ac7b
> Author: Ying Han <yinghan@google.com>
> Date:   Thu May 3 15:44:01 2012 +1000
> 
>     memcg: add mlock statistic in memory.stat
> 
> With the issue there being is that in munlock_vma_page(), it now does
> a mem_cgroup_begin_update_page_stat() which takes the rcu_read_lock(),
> so when the older code that was there previously will try taking a
> mutex you'll get a BUG.

Hmmm...  One approach would be to switch from rcu_read_lock() to
srcu_read_lock(), though this means carrying the index returned from
the srcu_read_lock() to the matching srcu_read_unlock() -- and making
the update side use synchronize_srcu() rather than synchronize_rcu().
Alternatively, it might be possible to defer acquiring the lock until
after exiting the RCU read-side critical section, but I don't know enough
about mm to even guess whether this might be possible.

There are probably other approaches as well...

							Thanx, Paul

