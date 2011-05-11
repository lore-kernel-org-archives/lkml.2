Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab1EKUNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:13:54 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:45091 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab1EKUNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:13:52 -0400
Date: Wed, 11 May 2011 13:13:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110511201349.GB2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110508151848.GA21906@linux.vnet.ibm.com>
 <20110509073636.GA18247@elte.hu>
 <BANLkTin82W0yZ5Nvv3Dp62X1eou_GxZ6EA@mail.gmail.com>
 <20110510085623.GG2258@linux.vnet.ibm.com>
 <4DC97E49.7040401@kernel.org>
 <20110510193216.GN2258@linux.vnet.ibm.com>
 <4DC9A5A4.1050308@kernel.org>
 <20110511045443.GS2258@linux.vnet.ibm.com>
 <4DCA2FD0.1070700@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCA2FD0.1070700@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 11:42:24PM -0700, Yinghai Lu wrote:
> On 05/10/2011 09:54 PM, Paul E. McKenney wrote:
> > On Tue, May 10, 2011 at 01:52:52PM -0700, Yinghai Lu wrote:
> >> On 05/10/2011 12:32 PM, Paul E. McKenney wrote:
> >>> On Tue, May 10, 2011 at 11:04:57AM -0700, Yinghai Lu wrote:
> >>>> On 05/10/2011 01:56 AM, Paul E. McKenney wrote:
> >>>>> On Mon, May 09, 2011 at 02:09:21PM -0700, Yinghai Lu wrote:
> >>>>>> On Mon, May 9, 2011 at 12:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >>>>>>>
> >>>>>>> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> >>>>>>>
> >>>>>>>> Hello, Ingo,
> >>>>>>>>
> >>>>>>>> This pull request covers RCU chnages for 2.6.40.  The major new features
> >>>>>>>> are RCU priority boosting and the addition of kfree_rcu(), the latter
> >>>>>>>> courtesy of Lai Jiangshan.  These two features cover well over half
> >>>>>>>> of the commits.  There are a number of smaller features and bug fixes.
> >>>>>>>> All have been sent to LKML in the following batches:
> >>>>>>>>
> >>>>>>>> 0.    https://lkml.org/lkml/2011/2/22/660: RCU priority boosting preview
> >>>>>>>> 1.    https://lkml.org/lkml/2011/5/1/19: RCU priority boosting, kfree_rcu()
> >>>>>>>> 2.    https://lkml.org/lkml/2011/5/2/40: More uses of kfree_rcu()
> >>>>>>>> 3.    https://lkml.org/lkml/2011/5/8/60: miscellaneous
> >>>>>>>>
> >>>>>>>> The kfree_rcu() uses in the pull request have Acked-by:s from the
> >>>>>>>> maintainers.  I have some additional kfree_rcu() requests that lack
> >>>>>>>> Acked-by:s, and I will deal with these later.
> >>>>>>>>
> >>>>>>>> These channges are available in the -rcu git repository at:
> >>>>>>>>
> >>>>>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/next
> >>>>>>>
> >>>>>>> Pulled, thanks a lot Paul!
> >>>>>>>
> >>>>>>
> >>>>>> it seems with this one in tip, my 8 sockets test setup will report cpu stall.
> >>>>>>
> >>>>>> after hard code to enable rcu_cpu_stall_suppress
> >>>>>>
> >>>>>> Index: linux-2.6/kernel/rcutree.c
> >>>>>> ===================================================================
> >>>>>> --- linux-2.6.orig/kernel/rcutree.c
> >>>>>> +++ linux-2.6/kernel/rcutree.c
> >>>>>> @@ -174,7 +174,7 @@ module_param(blimit, int, 0);
> >>>>>>  module_param(qhimark, int, 0);
> >>>>>>  module_param(qlowmark, int, 0);
> >>>>>>
> >>>>>> -int rcu_cpu_stall_suppress __read_mostly;
> >>>>>> +int rcu_cpu_stall_suppress __read_mostly = 1;
> >>>>>>  module_param(rcu_cpu_stall_suppress, int, 0644);
> >>>>>>
> >>>>>>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
> >>>>>>
> >>>>>> will get system hang after pnp ACPI init.
> >>>>>
> >>>>> Could you please send the stack traces from the RCU CPU stall?  Also,
> >>>>> you do have ce31332d3c77532d6ea97ddcb475a2b02dd358b4 applied, correct?
> >>>>>
> >>>>> 							Thanx, Paul
> >>>>
> >>>> Do not have time to bisect it at this point.
> >>>
> >>> Could you please send the stack traces from the RCU CPU stall?
> > 
> > Thank you!  OK, so CPU 0 has not been responding, despite resched IPIs.
> > Everyone is idle, except for CPU 124, which detected the stall, and
> > possibly CPU 0, which has csum_partial_copy_generic() on the stack, though
> > that looks like a backtrace error to me.  The fact that it hangs if you
> > disable RCU CPU stall detection leads me to believe that something real
> > is being detected.
> > 
> > This looks very similar to the situation people were seeing before
> > ce31332d3c77532d6ea97ddcb475a2b02dd358b4 was applied, so I have attached
> > the diagnostic script that helped track this down.  Could you please
> > enable CONFIG_RCU_TRACE, mount debugfs, and run the attached script,
> > and send me the output?  Please check to make sure that the script knows
> > where you mounted debugfs, of course.

And this data shows RCU running normally, which goes along with your
saying that this was happening only at boot time.

Thank you for collecting it.

So help me understand what is happening.  You get the stall warning
during boot, then sometimes a hang?  Or does disabling the stall warnings
prevent the boot-time hang?

							Thanx, Paul

> Wed May 11 14:33:35 UTC 2011
> /sys/kernel/debug/rcu/rcugp:
> rcu_sched: completed=4164  gpnum=4165
> rcu_bh: completed=-282  gpnum=18446744073709551334
> /sys/kernel/debug/rcu/rcuhier:
> rcu_sched:
> c=4164 g=4165 s=2 jfq=0 j=92fc nfqs=6792/nfqsng=0(6792) fqlh=737
> ff/ff ..>.. 0:254 ^0    
> fdff/ffff ..>.. 0:15 ^0    fffc/ffff ..>.. 16:31 ^1    ffff/ffff ..>.. 32:47 ^2    ffff/ffff ..>.. 48:63 ^3    fdff/ffff ..>.. 64:79 ^4    ffff/ffff ..>.. 80:95 ^5    ffff/ffff ..>.. 96:111 ^6    ffff/ffff ..>.. 112:127 ^7    0/0 ..>.. 128:143 ^8    0/0 ..>.. 144:159 ^9    0/0 ..>.. 160:175 ^10    0/0 ..>.. 176:191 ^11    0/0 ..>.. 192:207 ^12    0/0 ..>.. 208:223 ^13    0/0 ..>.. 224:239 ^14    0/0 ..>.. 240:254 ^15    

...
