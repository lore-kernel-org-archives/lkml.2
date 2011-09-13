Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab1IMTu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 15:50:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:39360 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1IMTu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 15:50:56 -0400
Date: Tue, 13 Sep 2011 12:50:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, anton@samba.org,
        paulus@samba.org
Subject: Re: [PATCH tip/core/rcu 55/55] powerpc: Work around tracing from
 dyntick-idle mode
Message-ID: <20110913195033.GB3301@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-55-git-send-email-paulmck@linux.vnet.ibm.com>
 <1315389622.26118.17.camel@pasglop>
 <20110907134400.GJ3610@linux.vnet.ibm.com>
 <20110913191319.GF23424@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913191319.GF23424@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 09:13:21PM +0200, Frederic Weisbecker wrote:
> On Wed, Sep 07, 2011 at 06:44:00AM -0700, Paul E. McKenney wrote:
> > On Wed, Sep 07, 2011 at 07:00:22AM -0300, Benjamin Herrenschmidt wrote:
> > > On Tue, 2011-09-06 at 11:00 -0700, Paul E. McKenney wrote:
> > > > PowerPC LPAR's __trace_hcall_exit() can invoke event tracing at a
> > > > point where RCU has been told that the CPU is in dyntick-idle mode.
> > > > Because event tracing uses RCU, this can result in failures.
> > > > 
> > > > A correct fix would arrange for RCU to be told about dyntick-idle
> > > > mode after tracing had completed, however, this will require some care
> > > > because it appears that __trace_hcall_exit() can also be called from
> > > > non-dyntick-idle mode.
> > > 
> > > This obviously needs to be fixed properly. hcall tracing is very useful
> > > and if I understand your patch properly, it just comments it out :-)
> > 
> > That is exactly what it does, and I completely agree that this patch
> > is nothing but a short-term work-around to allow my RCU tests to find
> > other bugs.
> > 
> > > I'm not sure what the best approach is, maybe have the hcall tracing
> > > test for the dyntick-idle mode and skip tracing in that case ?
> > 
> > Another approach would be to update Frederic Weisbecker's patch at:
> > 
> > 	https://lkml.org/lkml/2011/8/20/83
> > 
> > so that powerpc does tick_nohz_enter_idle(false), and then uses
> > rcu_enter_nohz() explicitly just after doing the hcall tracing.
> > If pseries is the only powerpc architecture requiring this, then
> > the argument to tick_nohz_enter_idle() could depend on the powerpc
> > sub-architecture.
> 
> I'm trying to fix this but I need a bit of help to understand the
> pseries cpu sleeping.
> 
> In pseries_dedicated_idle_sleep(), what is the function that does
> the real sleeping? Is it cede_processor()?

As I understand it, cede_processor()'s call to plpar_hcall_norets()
results in the hypervisor being invoked, and could give up the CPU.
And yes, in this case, RCU needs to stop paying attention to this CPU.
And pseries_shared_idle_sleep() also invokes cede_proceessor().

Gah...  And there also appear to be some assembly-language functions
that can be invoked via the ppc_md.power_save() call from cpu_idle():
ppc6xx_idle(), power4_idle(), idle_spin(), idle_doze(), and book3e_idle().
There is also a power7_idle(), but it does not appear to be used anywhere.

Plus there are the C-language ppc44x_idle(), beat_power_save(),
cbe_power_save(), ps3_power_save(), and cpm_idle().

> > The same thing would be needed for tick_nohz_exit_idle() and
> > rcu_exit_nohz(): powerpc would need to invoke rcu_exit_nohz() after
> > gaining control from the hypervisor but before doing its first tracing,
> > and then it would need the idle loop to to tick_nohz_exit_idle(false).
> > Again, if pseries is the only powerpc architecture requiring this,
> > the argument to tick_nohz_exit_idle() could depend on the architecture.
> > 
> > Would this approach work?
> 
> Sounds like we really need that.

Sounds like an arch-dependent config symbol that is defined for the
pseries targets, but not for the other powerpc architectures.

Not clear to me what to do about power4_idle(), though.

							Thanx, Paul
