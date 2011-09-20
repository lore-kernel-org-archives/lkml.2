Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab1ITPyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 11:54:15 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:21820 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751194Ab1ITPyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 11:54:14 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: NojjoJIVM1kpU55zXBSPRza5Pl012PVI0PPrt.ggzQ8GFv9
 JjVDgeudlIbEfWjI_E.McYVpOGNg37.PrOVXwYw7Xu0yuP7SD5kncFDEpR5X
 WPx0tuV3x.FEzh9svU58kjEUho8k3jLOQIYwxxQAGVu6tIjIAK1MFalZ5EK9
 cg.Wk2UZkjhX.adb7JWsQsQX3gBA5FfoBccnPPKCFcfn4Ge0h9lm093Gllj5
 uTGbilu4Uto8W3sIn3Y_2Gne3otPI4FGUgli.ks0g7_z1xs.Ky.9fbJDYg37
 RP_MEMTU263.vIko8T3MDci6ieaAtew4UQZEu2uFhlLHF2eRaXKD8kZz_OjA
 YwSWp7KSC1D.kukZXs8QStQN_lRva8Q3jO7tmBJx6RizBPwc-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Sep 2011 10:54:10 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: <1316531769.29966.61.camel@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.1109201038150.8056@router.home>
References: <20110919212040.745370781@goodmis.org>  <20110919212640.688732950@goodmis.org>  <alpine.DEB.2.00.1109191657150.19059@router.home>  <1316476089.29966.9.camel@gandalf.stny.rr.com>  <alpine.DEB.2.00.1109200940240.8056@router.home>
 <1316531769.29966.61.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, Steven Rostedt wrote:

> On Tue, 2011-09-20 at 09:46 -0500, Christoph Lameter wrote:
>
> > The effects on just reading are not that severe. We may calculate the
> > address of the per cpu variable on one cpu and then be migrated to another
> > processor. Then there is an access to the per cpu area of another
> > processor which in many cases is harmless and will just cause the
> > cacheline to go from exclusive mode into shared mode on the other cpu. The
> > next write by the other cpu then brings it back to exclusive mode evicting
> > the cacheline from the cpu we migrated to.
>
> Then what protects another process from touching that same CPU variable?
> Looks very error prone to me.

I am sorry but this is a quite puzzling statement. Any processor in kernel
mode can create arbitrary pointers to access any memory location it wants.
That actually occurs legitimately when the sum of all per cpu values is
calculated.

> > The same conventions are also used for RMV instructions like this_cpu_inc.
> > In that case the situation is much more sever. Now we are locklessly
> > incrementing a counter in the per cpu area of another cpu. That is a race
> > condition that can corrupt the counter data.
>
> If you read a per cpu variable with simple this_cpu_read() and then make
> a decision based on that variable, it may be useless in the process if
> you migrate.

Correct but in many context that does not matter.

> > > The point is, most places use this_cpu_read(). Adding a "__" or "raw_"
> > > prefix usually means that less checks are done. Think of the
> > > copy_from_user(). You have __copy_from_user() that does less checks.
> >
> > Why do you need any checks there? this_cpu_xxx operations should take care
> > of preemption.
>
> NO IT DOES NOT!!!! Look at the damn memcg bug and figure it out!

IT DOES!!!! The memcg bug is caused by someone using this_cpu_read and
expecting the cpu not to change. this_cpu_xx ops stand on their own and do
not guarantee access to the same per cpu area.

> > this_cpu_xx can only replace a get_cpu_var/per_cpu section where a single
> > word is read or updated. If multiple per cpu variables are accessed and
> > modified in one go then it is better to keep disabling preemption for
> > the whole section and use the __this_cpu_xx operations.
>
> And that is what __get_cpu_var() is for.

__get_cpu_var cannot generate a single instruction that does RMW ops on a
counter without disabling preemption.

> > If there are cases where this was not done correctly then lets fix those.
>
> Lets not let this happen in the first place! There's absolutely no
> advantage of not disabling preemption for a period of time while per cpu
> variables are being used. If we annotate this properly, then the -rt
> kernel could handle this in other ways too, to not keep the latency of
> preemption off too long.

There are significant advantages for counters and things designed to
operate in an environment where the OS can migrate a task at will.
Vvmstat and the slub fastpaths exploit these things now and it will be
possible with these operations to increase the performance of more
subsystems that way. The page allocator comes to mind.

