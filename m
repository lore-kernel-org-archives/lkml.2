Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1C0AJN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 20:09:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35795 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab1C0AJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 20:09:11 -0400
Date: Sat, 26 Mar 2011 17:09:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: linux-next: Tree for March 25 (Call trace:
 RCU|workqueues|block|VFS|ext4 related?)
Message-ID: <20110327000900.GB2322@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110325155516.GA27484@feather>
 <20110325164236.GP2322@linux.vnet.ibm.com>
 <AANLkTim08Ff==7mY9fuU8tUJrTmEhZ+PrsJSQO5PKOH6@mail.gmail.com>
 <AANLkTi=N6Z0bDg1YXVFkUbv7phM8XvQ5U3=vS6Ej8Af5@mail.gmail.com>
 <20110325174855.GR2322@linux.vnet.ibm.com>
 <AANLkTin9HxOTwavbtbsMd0quYsEvhDNmuO5kOpquqoF=@mail.gmail.com>
 <20110326034210.GX2322@linux.vnet.ibm.com>
 <AANLkTi=zJZ26i14D-kyWQ1uqUPifrv+DN4So4+fC5V=d@mail.gmail.com>
 <20110326160229.GZ2322@linux.vnet.ibm.com>
 <AANLkTikzLm+ArYkG20F41JOgfNygfdhxC0+A4tV4ez-R@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikzLm+ArYkG20F41JOgfNygfdhxC0+A4tV4ez-R@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 11:15:22PM +0100, Sedat Dilek wrote:
> On Sat, Mar 26, 2011 at 5:02 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Sat, Mar 26, 2011 at 01:34:53PM +0100, Sedat Dilek wrote:
> [...]
> >> Just FYI: Changed to the following settings:
> >>
> >> - Enable Preemptible Kernel (Low-Latency Desktop)
> >> - Enable Preemptible tree-based hierarchical RCU
> >> - Enable RCU priority boosting
> >> - Reset RCU CPU stall timeout to default (60 seconds)
> >>
> >> So far I see no RCU stalls in the logs and my system runs as expected.
> >> ( I have noticed here some "stalling" in the webbrowser, but I can do
> >> my daily business. )
> >
> > OK, good to see some progress!
> >
> 
> On 1st impression thing went fine, but after a while jobs like opening
> several tabs in firefox or doing a simple df command stalled the
> machine. No, my system even got frozen and required a brutal reset.
> 
> >From the logs (more see file-attachment):
> 
> Mar 26 19:58:40 tbox kernel: [ 1440.640060] INFO: task systemd:1
> blocked for more than 120 seconds.
> Mar 26 19:58:40 tbox kernel: [ 1440.640074] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> 
> Following it -> NOPE
> $ echo 0 > /proc/sys/kernel/hung_task_timeout_secs

These are tasks that are blocked, not tasks that are consuming CPU.

> > Is there a runaway process consuming CPU?  The reason that I ask is that
> > an infinite loop in the kernel can result in a stall when PREEMPT=n
> > but is less likely to if PREEMPT=y.  Could you please check with "top",
> > "ps", or whatever?
> 
> Unsure what you mean by this, as you can see from the logs, it's not
> only one special task "stalling".
> BTW, I have systemd here running.

Right.  But I need to know if there are tasks consuming lots of CPU,
which is different than tasks that are stalled for a long time.  Look
at the message: it says "blocked for more than 120 seconds", not
"running for more than 120 seconds".

For example, if one of the RCU kthreads is consuming lots of CPU, that
would tell me that I should look for an RCU bug (and yank the patches
from -next in the meantime).  On the other hand, if some other task is
consuming lots of CPU, then that would be a hint as to where to find
the bug.

> >> I am not sure what the change to PREEMPT exactly mean in the end.
> >> ( Let's work with this new kernel and carefully check for possible
> >> side-effects. )
> >> For example CONFIG_RCU_FAST_NO_HZ=y is now dropped, where the Kconfig
> >> descriptive text says some words on better energy saving. For a
> >> notebook this is no good.
> >
> > CONFIG_RCU_FAST_NO_HZ is of no use on a uniprocessor system, so OK
> > to disable it.  But are you saying that CONFIG_RCU_FAST_NO_HZ=y
> > results in problems that are removed by CONFIG_RCU_FAST_NO_HZ=n?
> > That would be a surprise, and I need to know if this is the case.
> 
> In my current setup (PREEMPT and TREE_PREEMPT_RCU)
> CONFIG_RCU_FAST_NO_HZ is not considered and set via Kconfig-system
> (see excerpt below).
> But when you say for UP it is of no use, I need no more info.

OK, "of no use" is overstating things a bit.  But CONFIG_RCU_FAST_NO_HZ's
main purpose is to get the last CPU into dyntick-idle state
(CONFIG_NO_HZ), which is most useful if the system has several CPUs.

> Might be good to add some recommended (and/or useless) kernel-config
> settings to RCU/UP.txt?
> 
> [ init/Kconfig ]
> config RCU_FAST_NO_HZ
>         bool "Accelerate last non-dyntick-idle CPU's grace periods"
>         depends on TREE_RCU && NO_HZ && SMP
>         default n

The "depends on TREE_RCU && NO_HZ && SMP" already excludes it from
UP kernel builds, so no need to document.

> >> I have also questions to some Kconfig dependencies, for example why I
> >> can't select TREE_PREEMPT_RCU if CONFIG_PREEMPT_VOLUNTARY=y, etc.
> >> Intended?
> >
> > Yes.  There is no point in TREE_PREEMPT_RCU unless PREEMPT=y.
> >
> 
> OK.
> 
> >> Maybe I collect all my askings in a separate email to RCU folks and ML
> >> and do not disturb further people from other sub-trees.
> >>
> >> I enjoyed to read the numerous docs in Documentation/RCU/ (and noticed
> >> some typos as well).
> >> The RCU folk gave the word "FAQ" a new meaning: Frequenty Asked
> >> Questions & Q*uiz* :-).
> >>
> >> Thanks for the helpful hints and explanations from the RCU folks!
> >
> > Glad you liked them!  ;-)
> >
> 
> Other sub-trees lack of no good or up2date docs.
> 
> >> - Sedat -
> >>
> >> P.S.: Current RCU and HZ kernel-config settings
> >>
> >> # grep RCU /boot/config-$(uname -r)
> >> # RCU Subsystem
> >> CONFIG_TREE_PREEMPT_RCU=y
> >> CONFIG_PREEMPT_RCU=y
> >> CONFIG_RCU_TRACE=y
> >> CONFIG_RCU_FANOUT=32
> >> # CONFIG_RCU_FANOUT_EXACT is not set
> >> CONFIG_TREE_RCU_TRACE=y
> >> CONFIG_RCU_BOOST=y
> >> CONFIG_RCU_BOOST_PRIO=1
> >> CONFIG_RCU_BOOST_DELAY=500
> >> # CONFIG_SPARSE_RCU_POINTER is not set
> >> # CONFIG_RCU_TORTURE_TEST is not set
> >> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> >> CONFIG_RCU_CPU_STALL_VERBOSE=y
> >>
> >> # grep _HZ /boot/config-$(uname -r)
> >> CONFIG_NO_HZ=y
> >> # CONFIG_HZ_100 is not set
> >> CONFIG_HZ_250=y
> >> # CONFIG_HZ_300 is not set
> >> # CONFIG_HZ_1000 is not set
> >> CONFIG_HZ=250
> >
> > OK, thank you for the info!
> >
> 
> N.P.
> 
> >                                                        Thanx, Paul
> >
> 
> I guees I will revert step-by-step the RCU commits in linux-next and report.
> This weekend I wanted to enhance Debian's live-cd framework with
> overlayfs support and a customized kernel.
> But then came RCU :-(.

Well, if it turns out to be a problem in RCU I will certainly apologize.

> Can you say some words to kfree_rcu.2011.03.25b (rcu/kfree_rcu) GIT branch(es)?

These are just applying Lia Jiangshan's kfree_rcu() to a number of places
in the kernel.  You can safely ignore them.

								Thanx, Paul

> - Sedat -

> Mar 26 00:45:07 tbox kernel: [ 1080.588102] INFO: task umount:2091 blocked for more than 120 seconds.
> Mar 26 00:45:07 tbox kernel: [ 1080.588114] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 00:47:07 tbox kernel: [ 1200.588103] INFO: task umount:2091 blocked for more than 120 seconds.
> Mar 26 00:47:07 tbox kernel: [ 1200.588116] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 00:49:07 tbox kernel: [ 1320.588102] INFO: task umount:2091 blocked for more than 120 seconds.
> Mar 26 00:49:07 tbox kernel: [ 1320.588115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 00:51:07 tbox kernel: [ 1440.588100] INFO: task umount:2091 blocked for more than 120 seconds.
> Mar 26 00:51:07 tbox kernel: [ 1440.588114] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 00:53:07 tbox kernel: [ 1560.588101] INFO: task umount:2091 blocked for more than 120 seconds.
> Mar 26 00:53:07 tbox kernel: [ 1560.588114] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 00:55:07 tbox kernel: [ 1680.588148] INFO: task umount:2091 blocked for more than 120 seconds.
> Mar 26 00:55:07 tbox kernel: [ 1680.588161] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 00:57:07 tbox kernel: [ 1800.588101] INFO: task umount:2091 blocked for more than 120 seconds.
> Mar 26 00:57:07 tbox kernel: [ 1800.588114] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 00:59:08 tbox kernel: [ 1920.588108] INFO: task umount:2091 blocked for more than 120 seconds.
> Mar 26 00:59:08 tbox kernel: [ 1920.588122] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 01:01:07 tbox kernel: [ 2040.588102] INFO: task umount:2091 blocked for more than 120 seconds.
> Mar 26 01:01:07 tbox kernel: [ 2040.588115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 01:03:07 tbox kernel: [ 2160.588102] INFO: task umount:2091 blocked for more than 120 seconds.
> Mar 26 01:03:07 tbox kernel: [ 2160.588115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 13:20:00 tbox kernel: [ 1080.640170] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 13:20:00 tbox kernel: [ 1080.640184] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 13:20:00 tbox kernel: [ 1080.640708] INFO: task kded4:1367 blocked for more than 120 seconds.
> Mar 26 13:20:00 tbox kernel: [ 1080.640717] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 13:20:00 tbox kernel: [ 1080.641116] INFO: task sd:exec:1904 blocked for more than 120 seconds.
> Mar 26 13:20:00 tbox kernel: [ 1080.641125] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 13:20:00 tbox kernel: [ 1080.641488] INFO: task cron:1905 blocked for more than 120 seconds.
> Mar 26 13:20:00 tbox kernel: [ 1080.641497] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 13:22:00 tbox kernel: [ 1200.640058] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 13:22:00 tbox kernel: [ 1200.640071] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 13:22:00 tbox kernel: [ 1200.640592] INFO: task kded4:1367 blocked for more than 120 seconds.
> Mar 26 13:22:00 tbox kernel: [ 1200.640602] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 13:22:00 tbox kernel: [ 1200.641000] INFO: task sd:exec:1904 blocked for more than 120 seconds.
> Mar 26 13:22:00 tbox kernel: [ 1200.641009] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 13:22:00 tbox kernel: [ 1200.641372] INFO: task cron:1905 blocked for more than 120 seconds.
> Mar 26 13:22:00 tbox kernel: [ 1200.641381] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 13:24:00 tbox kernel: [ 1320.640055] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 13:24:00 tbox kernel: [ 1320.640068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 13:24:00 tbox kernel: [ 1320.640602] INFO: task kded4:1367 blocked for more than 120 seconds.
> Mar 26 13:24:00 tbox kernel: [ 1320.640611] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 14:09:31 tbox kernel: [  480.640055] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 14:09:31 tbox kernel: [  480.640068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 14:11:31 tbox kernel: [  600.640055] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 14:11:31 tbox kernel: [  600.640068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 14:13:31 tbox kernel: [  720.640054] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 14:13:31 tbox kernel: [  720.640068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 14:15:31 tbox kernel: [  840.640067] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 14:15:31 tbox kernel: [  840.640080] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 14:30:12 tbox kernel: [  840.644071] INFO: task kworker/u:1:173 blocked for more than 120 seconds.
> Mar 26 14:30:12 tbox kernel: [  840.644085] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 14:30:12 tbox kernel: [  840.645204] INFO: task firefox-bin:1940 blocked for more than 120 seconds.
> Mar 26 14:30:12 tbox kernel: [  840.645213] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 14:30:12 tbox kernel: [  840.645829] INFO: task firefox-bin:1947 blocked for more than 120 seconds.
> Mar 26 14:30:12 tbox kernel: [  840.645839] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 14:30:12 tbox kernel: [  840.646441] INFO: task firefox-bin:1949 blocked for more than 120 seconds.
> Mar 26 14:30:12 tbox kernel: [  840.646450] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 14:30:12 tbox kernel: [  840.647053] INFO: task kworker/0:1:1926 blocked for more than 120 seconds.
> Mar 26 14:30:12 tbox kernel: [  840.647062] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:31:45 tbox kernel: [  360.640052] INFO: task kworker/0:1:20 blocked for more than 120 seconds.
> Mar 26 19:31:45 tbox kernel: [  360.640059] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:31:45 tbox kernel: [  360.640265] INFO: task kworker/u:1:190 blocked for more than 120 seconds.
> Mar 26 19:31:45 tbox kernel: [  360.640268] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:31:45 tbox kernel: [  360.640721] INFO: task firefox-bin:1994 blocked for more than 120 seconds.
> Mar 26 19:31:45 tbox kernel: [  360.640725] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:31:45 tbox kernel: [  360.640945] INFO: task firefox-bin:2009 blocked for more than 120 seconds.
> Mar 26 19:31:45 tbox kernel: [  360.640948] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:31:45 tbox kernel: [  360.641143] INFO: task firefox-bin:2010 blocked for more than 120 seconds.
> Mar 26 19:31:45 tbox kernel: [  360.641146] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:31:45 tbox kernel: [  360.641352] INFO: task firefox-bin:2011 blocked for more than 120 seconds.
> Mar 26 19:31:45 tbox kernel: [  360.641355] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:31:45 tbox kernel: [  360.641576] INFO: task su:2015 blocked for more than 120 seconds.
> Mar 26 19:31:45 tbox kernel: [  360.641579] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:33:45 tbox kernel: [  480.640053] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 19:33:45 tbox kernel: [  480.640066] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:33:45 tbox kernel: [  480.640514] INFO: task kworker/0:1:20 blocked for more than 120 seconds.
> Mar 26 19:33:45 tbox kernel: [  480.640523] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:33:45 tbox kernel: [  480.641014] INFO: task kworker/u:1:190 blocked for more than 120 seconds.
> Mar 26 19:33:45 tbox kernel: [  480.641024] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:52:40 tbox kernel: [ 1080.640062] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 19:52:40 tbox kernel: [ 1080.640075] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:52:40 tbox kernel: [ 1080.640612] INFO: task kded4:1514 blocked for more than 120 seconds.
> Mar 26 19:52:40 tbox kernel: [ 1080.640621] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:52:40 tbox kernel: [ 1080.641033] INFO: task sd:exec:1978 blocked for more than 120 seconds.
> Mar 26 19:52:40 tbox kernel: [ 1080.641042] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:54:40 tbox kernel: [ 1200.640055] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 19:54:40 tbox kernel: [ 1200.640068] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:54:40 tbox kernel: [ 1200.640604] INFO: task kded4:1514 blocked for more than 120 seconds.
> Mar 26 19:54:40 tbox kernel: [ 1200.640613] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:54:40 tbox kernel: [ 1200.641026] INFO: task sd:exec:1978 blocked for more than 120 seconds.
> Mar 26 19:54:40 tbox kernel: [ 1200.641035] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:56:40 tbox kernel: [ 1320.640059] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 19:56:40 tbox kernel: [ 1320.640072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:56:40 tbox kernel: [ 1320.640607] INFO: task kded4:1514 blocked for more than 120 seconds.
> Mar 26 19:56:40 tbox kernel: [ 1320.640616] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:56:40 tbox kernel: [ 1320.641027] INFO: task sd:exec:1978 blocked for more than 120 seconds.
> Mar 26 19:56:40 tbox kernel: [ 1320.641036] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> --
> Mar 26 19:58:40 tbox kernel: [ 1440.640060] INFO: task systemd:1 blocked for more than 120 seconds.
> Mar 26 19:58:40 tbox kernel: [ 1440.640074] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

