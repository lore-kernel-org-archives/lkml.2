Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2B1NHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:07:12 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:40757 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2B1NHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:07:10 -0500
Date: Tue, 28 Feb 2012 05:05:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Venki Pallipadi <venki@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
Message-ID: <20120228130548.GA2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1329957415-15239-1-git-send-email-venki@google.com>
 <1329989454.24994.57.camel@twins>
 <CABeCy1a0U8Hk3Yfp54M-U80t2fbPrFQw=GnNQ_V082e9VxJQow@mail.gmail.com>
 <20120224054150.GA17543@zhy>
 <20120226013253.GN2393@linux.vnet.ibm.com>
 <20120227090646.GA1112@zhy>
 <20120227170527.GD2463@linux.vnet.ibm.com>
 <20120228071255.GD1112@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120228071255.GD1112@zhy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022813-2398-0000-0000-0000049B5EB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 03:12:55PM +0800, Yong Zhang wrote:
> On Mon, Feb 27, 2012 at 09:05:27AM -0800, Paul E. McKenney wrote:
> > On Mon, Feb 27, 2012 at 05:06:46PM +0800, Yong Zhang wrote:
> > > On Sat, Feb 25, 2012 at 05:32:53PM -0800, Paul E. McKenney wrote:
> > > > On Fri, Feb 24, 2012 at 01:41:50PM +0800, Yong Zhang wrote:
> > > > > On Thu, Feb 23, 2012 at 11:34:11AM -0800, Venki Pallipadi wrote:
> > > > > > On Thu, Feb 23, 2012 at 1:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > > > Why not scheduler_ipi()?
> > > > > > 
> > > > > > Was trying to avoid irq_enter/exit. As the work here is done in idle
> > > > > > thread context, I though we could avoid enter/exit. 
> > > > > 
> > > > > It seems we could not.
> > > > > At least RCU need it, see commit c5d753a55, otherwise we will get
> > > > > warning like 'RCU used illegally from extended quiescent state!'
> > > > 
> > > > If the use is tracing, then Steven Rostedt's patchset plus use of his
> > > > _rcuidle() tracing variants handles this:
> > > > 
> > > > 	https://lkml.org/lkml/2012/2/7/231
> > > > 
> > > > If this is instead algorithmic use of RCU, a set of patches I have queued
> > > > up for 3.4 will be required.
> > > 
> > > scheduler_ipi() doing more than tracing. Will look at your patches :)
> > 
> > Ah!  The key question is whether or not the code in question is called
> > both from idle and from non-idle.
> 
> In fact before this patch from Venki, the only call site of scheduler_ipi()
> is resched irq handler. Then Venki introduce __scheduler_ipi()(which avoid
> irq_enter()/irq_exit()) into cpu_idle(). So the answer is yes.

Ah, that explains why I didn't see it in my testing.  ;-)

> But when I was testing this patch, I didn't see explicit warning on
> illegal rcu usage. The reason maybe 1) there are no much rcu dereference
> in scheduler_ipi(), but we indeed do tracing in it; 2) rq->lock provide
> some kind of protection.
> Maybe I'm overstraining, but it is potential danger.

Did you have CONFIG_PROVE_RCU=y when testing?

> But anyway, it's not an issue anymore since Venki removed __scheduler_ipi()
> in his latest version.

OK.

> > This will be easiest if the code is
> > called only from idle, in which case you should only need this one:
> > 
> > 	https://lkml.org/lkml/2012/2/3/498
> 
> Hmm... Yeah, RCU_NONIDLE() could survive IMHO :)

Seems like it might be needed sooner rather than later...

							Thanx, Paul

