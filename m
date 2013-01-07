Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3AGXCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:02:35 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:36067 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411Ab3AGXCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:02:33 -0500
Date: Mon, 7 Jan 2013 17:02:18 -0600
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org
Subject: Re: kernel BUG at kernel/sched_rt.c:493!
Message-ID: <20130107230218.GB3411@BohrerMBP.rgmadvisors.com>
References: <20130105174632.GB19226@u1004.rgmadvisors.com>
 <20130107175818.GA3411@BohrerMBP.rgmadvisors.com>
MIME-Version: 1.0
In-Reply-To: <20130107175818.GA3411@BohrerMBP.rgmadvisors.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 11:58:18AM -0600, Shawn Bohrer wrote:
> On Sat, Jan 05, 2013 at 11:46:32AM -0600, Shawn Bohrer wrote:
> > I've tried reproducing the issue, but so far I've been unsuccessful
> > but I believe that is because my RT tasks aren't using enough CPU
> > cause borrowing from the other runqueues.  Normally our RT tasks use
> > very little CPU so I'm not entirely sure what conditions caused them
> > to run into throttling on the day that this happened.
> 
> I've managed to reproduce this a couple times now on 3.1.9 I'll give
> this a try later with a more recent kernel.  Here is what I've done to
> reproduce the issue.
> 
> 
> # Setup in shell 1
> root@berbox39:/cgroup/cpuset# mkdir package0
> root@berbox39:/cgroup/cpuset# echo 0 > package0/cpuset.mems
> root@berbox39:/cgroup/cpuset# echo 0,2,4,6 > package0/cpuset.cpus
> root@berbox39:/cgroup/cpuset# cat cpuset.sched_load_balance
> 1
> root@berbox39:/cgroup/cpuset# cat package0/cpuset.sched_load_balance
> 1
> root@berbox39:/cgroup/cpuset# cat sysdefault/cpuset.sched_load_balance
> 1
> root@berbox39:/cgroup/cpuset# echo 1,3,5,7 > sysdefault/cpuset.cpus
> root@berbox39:/cgroup/cpuset# echo 0 > sysdefault/cpuset.mems
> root@berbox39:/cgroup/cpuset# echo $$ > package0/tasks
> 
> # Setup in shell 2
> root@berbox39:~# cd /cgroup/cpuset/
> root@berbox39:/cgroup/cpuset# chrt -f -p 60 $$
> root@berbox39:/cgroup/cpuset# echo $$ > sysdefault/tasks
> 
> # In shell 1
> root@berbox39:/cgroup/cpuset# chrt -f 1 /root/burn.sh &
> root@berbox39:/cgroup/cpuset# chrt -f 1 /root/burn.sh &
> 
> # In shell 2
> root@berbox39:/cgroup/cpuset# echo 0 > cpuset.sched_load_balance
> root@berbox39:/cgroup/cpuset# echo 1 > cpuset.sched_load_balance
> root@berbox39:/cgroup/cpuset# echo 0 > cpuset.sched_load_balance
> root@berbox39:/cgroup/cpuset# echo 1 > cpuset.sched_load_balance
> 
> I haven't found the exact magic combination but I've been going back
> and forth adding/killing burn.sh processes and toggling
> cpuset.sched_load_balance and in a couple of minutes I can usually get
> the machine to trigger the bug.

I've also managed to reproduce this on 3.8.0-rc2 so it appears the bug
is still present in the latest kernel.

Also just re-reading my instructions above /root/burn.sh is just a
simple:

while true; do : ; done

I've also had to make the kworker threads SCHED_FIFO with a higher
priority than burn.sh or as expected I can lock up the system due to
some xfs threads getting starved.

Let me know if anyone needs any more information, or needs me to try
anything since it appears I can trigger this fairly easily now.

--
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
