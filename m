Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2GZKr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:47:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:44097 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2GZKr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:47:57 -0400
Date: Thu, 26 Jul 2012 12:47:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, Peter Boonstoppel <pboonstoppel@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Andy Walls <awalls@md.metrocast.net>,
        Diwakar Tundlam <dtundlam@nvidia.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] kthread: disable preemption during complete()
In-Reply-To: <1343289850.26034.79.camel@twins>
Message-ID: <alpine.LFD.2.02.1207261242240.32033@ionos>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D364859@HQMAIL04.nvidia.com>  <20120725000901.GA5304@google.com>  <5FBF8E85CA34454794F0F7ECBA79798F379D36485E@HQMAIL04.nvidia.com>  <20120725224044.GC32378@google.com> <1343289850.26034.79.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012, Peter Zijlstra wrote:
> On Wed, 2012-07-25 at 15:40 -0700, Tejun Heo wrote:
> > > This patch disables preemption during complete(), since we call
> > > schedule() directly afterwards, so it will correctly enter
> > > TASK_UNINTERRUPTIBLE. This speeds up kthread creation/binding during
> > > cpu hotplug significantly.
> 
> tglx has patches that make the kthread create/destroy stuff from hotplug
> go away.. that seems like the better approach.

Right. That cpu hotplug setup/teardown stuff is ugly.

> > > +
> > > +	/*
> > > +	 * Disable preemption so we enter TASK_UNINTERRUPTIBLE after
> > > +	 * complete() instead of possibly being preempted. This speeds
> > > +	 * up clients that do a kthread_bind() directly after
> > > +	 * creation.
> > > +	 */
> > > +	preempt_disable();
> > 
> > Shouldn't this happen before setting current state to UNINTERRUPTIBLE?
> > What prevents preemption happening right above preempt_disable()?
> 
> Nothing, it also doesn't matter that much, you could get preempted right
> before preempt_disable() and end up in the same place.
> 
> The main thing is avoiding the wakeup preemption from the complete()
> because we're going to sleep right after anyway.
> 
> The comment doesn't really make that clear.

Right, the comment is crap. It has nothing to do with kthread_bind()
and stuff. The whole purpose is to avoid the pointless preemption
after wakeup.
 
> > >  	complete(&create->done);
> > > +	preempt_enable_no_resched();
> > > +
> > >  	schedule();
> 
> Other than that it seems fine, although I know tglx just loves new
> preempt_enable_no_resched() sites ;-)

The ones which are immediately followed by a call to schedule() are at
least not causing any headache for RT :)

Thanks,

	tglx
