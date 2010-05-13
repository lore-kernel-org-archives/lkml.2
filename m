Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0EMCuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:50:00 -0400
Received: from home.kolivas.org ([59.167.196.135]:36836 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab0EMCt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:49:58 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
Subject: Re: Issue with SCHED_FIFO app
Date: Thu, 13 May 2010 12:49:56 +1000
User-Agent: KMail/1.12.4 (Linux/2.6.33-ck1; KDE/4.3.4; x86_64; ; )
Cc: Suresh Rajashekara <suresh.raj+linuxomap@gmail.com>,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <k2j54a292881005092139u7e120250hf530f8b688abdd22@mail.gmail.com> <t2s54a292881005092142h58ccae9ch2ecec665d06a7601@mail.gmail.com> <AANLkTillkVE9Mmz3CiQyIF5yiZfpp13g18UCyMQSuZ_K@mail.gmail.com>
In-Reply-To: <AANLkTillkVE9Mmz3CiQyIF5yiZfpp13g18UCyMQSuZ_K@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005131249.56432.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 12:46:20 Xianghua Xiao wrote:
> On Sun, May 9, 2010 at 11:42 PM, Suresh Rajashekara
> 
> <suresh.raj+linuxomap@gmail.com> wrote:
> > Hi All,
> >
> > I had a couple of application (with real time priority SCHED_FIFO)
> > which were working fine on 2.6.16. They have started behaving
> > differently on 2.6.29.
> >
> > I will explain my problem briefly.
> >
> > Application A (my main application) is scheduled with SCHED_FIFO and
> > priority 5. Application B (watchdog application) is also scheduled with
> > SCHED_FIFO but with priority 54.
> >
> > A keeps putting the OMAP to sleep and wake up every 4 seconds and
> > again puts it to sleep.
> > B is supposed to be running every 1.25 seconds to kick watchdog, but
> > since A keeps OMAP in sleep for 4 seconds, it should run as soon as
> > OMAP wakes up.
> >
> > Since B is of a higher priority, its supposed to run whenever the OMAP
> > wakes up and then A should again put it back to sleep. This happens
> > perfectly on 2.6.16
> >
> > On 2.6.29, B fails to run when OMAP wakes up and before A puts it back
> > to sleep. B only runs if there is atleast 1.5 seconds of delay between
> > the awake-sleep cycle.
> >
> > On searching the internet, I figured out that CFS (completely fair
> > scheduler) was introduced in 2.6.23, which makes some changes to the
> > RT bandwidth (and many users started facing issues with they
> > applications with SCHED_FIFO). Somewhere on the web I found that
> > issuing
> >
> > echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> >
> > should disable the changes which affects the RT bandwidth. It actually
> > did help to an extent in solving some other problem (not described
> > above. A's IOCTL call return was getting delayed), but this problem
> > still persists.
> >
> > Any pointers to where I should look for the solution.
> >
> > Is there a way I can revert back to the scheduler behavior as it was on
> > 2.6.16?
> >
> > I have disabled CONFIG_GROUP_SCHED and also CONFIG_CGROUPS. I am using
> > 2.6.29 on an OMAP1 platform.
> >
> > Thanks in advance,
> > Suresh
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I have seen similar things while upgrading a 2.6.18 RT kernel to
> 2.6.33 RT, actually exactly when CFS was introduced we found
> performance issues, in that, our main application(a multi-thread
> SCHED_FIFO / SCHED_RR mixed) runs with much higher overhead under CFS.
> In 2.6.18RT, the cpu usage is close to 0% and on newer kernel with
> CFS, the cpu usage is 12% when the application runs idle(i.e. sleeping
> and waiting for input, WCHAN shows sched_timeout or futex_wait). When
> the main application runs with real load, cpu usage gets much worse
> with CFS.
> 
> I tried various methods, including the one you described above, and
> made sure no sched_yield is used, etc, still the main application
> spends 6% cpu in user space and 6% in kernel space while at idle. I
> tried BFS schedule and it's actually better, about 8% in user space
> and 0.6% in kernel space while the application runs idle. Again with
> 2.6.18 RT it's nearly 0% cpu usage.

It's distinctly possible that there is no change in the CPU usage at all and 
this is purely representing the change in how CPU accounting is done in CFS, 
and now BFS since the older mainline scheduler. The old mainline scheduler was 
potentially very inaccurate at representing CPU usage, particularly when tasks 
were very short lived. In fact it was possible to write a carefully crafted 
application that would use 99.9% CPU and register as zero CPU usage, by 
ensuring it slept just before the accounting tick would be hit. CFS changed 
dramatically how CPU accounting was done, and on BFS I changed it yet again, 
trying to make it more accurate.

The only way to see if there is a real issue with a change in CPU usage is to 
measure CPU usage through other means, which can be incredibly difficult to 
do, such as the power consumed by the CPU, the maximum throughput of the 
applications, and so on.

I do not think this is related to the original issue reported with SCHED_FIFO 
apps on this email thread though.

-- 
-ck
