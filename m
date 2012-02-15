Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2BOR77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:59:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36445 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab2BOR76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:59:58 -0500
Message-ID: <1329328787.2293.173.camel@twins>
Subject: Re: [PATCH 2/2] x86, reschedule: check to see if system is shutting
 down
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com,
        seiji.aguchi@hds.com, ak@linux.intel.com, mjg@redhat.com,
        levinsasha928@gmail.com
Date: Wed, 15 Feb 2012 18:59:47 +0100
In-Reply-To: <20120215155708.GK9751@redhat.com>
References: <1329164860-668-1-git-send-email-dzickus@redhat.com>
	 <1329164860-668-3-git-send-email-dzickus@redhat.com>
	 <1329305197.2293.50.camel@twins> <20120215145429.GE9751@redhat.com>
	 <1329317835.2293.133.camel@twins> <20120215155708.GK9751@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 10:57 -0500, Don Zickus wrote:

> > nope.. same problem, you're not telling anybody you're shooting CPUs
> > down -- this telling is usually done through cpu hotplug notifiers that
> > fix up state.
> 
> Why? If you have successfully sync'd up the cpus, stopped them and then
> run a 'stop_cpu' function, you stop all those WARN_ONs I would think.

So the one you're running in here is native_smp_send_reschedule(), its
send by the scheduler to kick a remote cpu. Doing kstopmachine()
flipping online bits and calling hlt with irqs disabled doesn't inform
the scheduler those CPUs aren't actually around anymore.

>   And
> how much do we care that we fix up the state on a shutdown?  We have
> already shutdown all the processes and unmounted the disks?  Most of the
> drivers have probably been shutdown cleanly.  What is left that we have to
> be polite?

Dunno, probably not much, but things like RCU might just want to try and
wait for remote CPUs to complete their grace period, which'll be a while
with them being quite dead.

There might also still be work left in workqueues, timers left on timer
wheels etc.. timers won't tick since their apic is dead along with the
cpu, so that shouldn't be a big problem unless someone is waiting for
one to complete. Similar with workqueues, I guess since tasks won't get
scheduled.

But the scheduler is still up and thinking its got all these CPUs,
poking them and getting WARNed about it.

> > The only way is to unplug all cpus except the one. Problem with that is
> > that we cannot (as of yet) unplug the boot cpu.
> 
> Yeah, well we can migrate to the boot cpu.  I think powerpc does that for
> kdump.

Right, there's that.
