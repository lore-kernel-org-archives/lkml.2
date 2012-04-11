Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169Ab2DKM3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:29:03 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54777 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2DKM26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:28:58 -0400
Date: Wed, 11 Apr 2012 05:28:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        nikunj@linux.vnet.ibm.com
Subject: Re: CPU Hotplug rework
Message-ID: <20120411122843.GD2402@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F674649.2000300@linux.vnet.ibm.com>
 <4F67474A.20707@linux.vnet.ibm.com>
 <20120405173918.GC8194@linux.vnet.ibm.com>
 <4F7F4977.4000302@linux.vnet.ibm.com>
 <1334102999.23924.232.camel@gandalf.stny.rr.com>
 <20120411002836.GM2428@linux.vnet.ibm.com>
 <1334104638.23924.233.camel@gandalf.stny.rr.com>
 <20120411010015.GA2402@linux.vnet.ibm.com>
 <4F851E91.70603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F851E91.70603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041112-1780-0000-0000-000004ABC87A
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000266; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00129938; UDB=6.00030702; UTC=2012-04-11
 12:28:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 11:32:57AM +0530, Srivatsa S. Bhat wrote:
> On 04/11/2012 06:30 AM, Paul E. McKenney wrote:
> 
> > On Tue, Apr 10, 2012 at 08:37:18PM -0400, Steven Rostedt wrote:
> >> On Tue, 2012-04-10 at 17:28 -0700, Paul E. McKenney wrote:
> >>
> >>>> Just to throw out the stupid silly approach.
> >>>>
> >>>> What about creating a "__register_cpu_notifier()" that just does:
> >>>>
> >>>> int __ref __register_cpu_notifier(struct notifier_block *nb)
> >>>> {
> >>>> 	return raw_notifier_chain_register(&cpu_chain, nb);
> >>>> }
> >>>>
> >>>> Also making cpu_maps_update_begin/done() global (and probably rename
> >>>> them).
> >>
> >> I just noticed that the cpu_maps_update_begin/done() are already global.
> >>
> >>>>
> >>>> and then in the above code do:
> >>>>
> >>>> 	cpu_maps_update_begin();
> >>>> 	__register_cpu_notifier(nb);
> >>>> 	do_setup();
> >>>> 	cpu_maps_update_done();
> >>>>
> >>>>
> 
> 
> Wow! Believe it or not, this is precisely the crux of the approach I was
> suggesting all along!! :-) Just that when put to code, it looked slightly
> different than this.. Sorry for not being clear.
> 
> So here is what I proposed, in a simplified form:
> 
> Modify the existing register_cpu_notifier() to this (by possibly giving
> it a different name):
> 
> int __ref register_cpu_notifier(struct notifier_block *nb,
> 					int (*do_setup)(void))
> {
> 	int ret;
> 
> 	cpu_maps_update_begin();
> 	ret = raw_notifier_chain_register(&cpu_chain, nb);
> 	do_setup();
> 	cpu_maps_update_done();
> 
> 	return ret;
> }
> 
> and then, in the caller, do:
> 
> 	register_cpu_notifier(nb, do_setup);
> 
> If the caller doesn't need any such extra setup, just do:
> 
> 	register_cpu_notifier(nb, NULL);
> 
> 
> Of course, register_cpu_notifier() should handle NULL properly.
> (My patch [1] handles it, along with some other special cases.)
> 
> That's it!
> 
> Also, it is to be noted that cpu_maps_update_begin/done() are global, but
> not exported symbols - so modules can't use them. With the above approach,
> we need not make them exported symbols, since the caller need not care about
> these locks at all.
> 
> >>>> Just saying,
> >>>
> >>> That does have some attractive properties, now that you mention it.  ;-)
> >>
> >> Which property? Stupid or Silly ;-)
> > 
> > As with any piece of software, no matter how small, both.  ;-)
> > 
> > Of course, __register_cpu_notifier() would need lockdep checking to make
> > sure that it wasn't called without the benefit of cpu_maps_update_begin().
> 
> 
> Not with my approach ;-) Its all automatically handled :-)

Good point, looks good!

							Thanx, Paul

> > I might be missing something, but as long as that was in place, seems
> > like it is a lot simpler and easier to use than the alternatives that
> > Srivatsa and I were kicking around.
> > 
> 
> 
> Hehe :-) Thanks for simplifying things, Steve!
> 
> 
> [1]. https://lkml.org/lkml/2012/3/1/39
> 
> Regards,
> Srivatsa S. Bhat

