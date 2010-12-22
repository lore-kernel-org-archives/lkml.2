Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0LVUlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 15:41:10 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:54157 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab0LVUlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 15:41:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wg8TpZeuVKGn9KQtrnitUap4fCjKgUjFSds+ID4AOyXc0Oew2KFUIeeeU/AZQaHuI1
         /8AV3GRhkVnIFVITRcn8qSZDJ9evI68405anpAOqmWKVxGUJ6JrWlZhdttZX2jnATl54
         kHzyKucSm1Av0+T5wpxE2ANiqnS9DBv6S8NDk=
Date: Wed, 22 Dec 2010 21:41:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 15/15] nohz_task: Procfs interface
Message-ID: <20101222204100.GE1739@nowhere>
References: <20101220155737.GA1742@nowhere>
 <1292861799.5021.27.camel@laptop>
 <20101221012418.GI1715@nowhere>
 <1292919280.5021.203.camel@laptop>
 <4D10B2E9.9040806@redhat.com>
 <20101221170512.GM1750@nowhere>
 <4D10EF3D.3070000@redhat.com>
 <20101221210831.GS1750@nowhere>
 <4D11C362.1060100@redhat.com>
 <1293011504.2170.76.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293011504.2170.76.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 10:51:44AM +0100, Peter Zijlstra wrote:
> On Wed, 2010-12-22 at 11:22 +0200, Avi Kivity wrote:
> > > Makes sense. And that integrates well with Peter's idea of creating a
> > > new cpuset attribute for the nohz tasks.
> > >
> > > But instead of making this detection from the scheduler, I think this
> > > should be done from the tick: if there is only one task running, set
> > > it the TF flag.
> > >
> > > But anyway, that's an optimisation. We can start with setting that flag
> > > on every task in that cpuset.
> > 
> > So long as we start without the new knob. 
> 
> Right, so one of the things we can do is let the tick disable itself
> when it finds there is no pending work left and set the TIF bit when
> needed.

Right.

Now I think about potential races. If a tick happens between the end of
the syscall path and the resume to userspace, it can set the TIF flag
but too late. So the task resumes userspace without beeing in an
extended QS.

No big deal though, it's easy to fixup.

Another possible race: a task runs alone with the flag. A new task gets enqueued
so we send the IPI. When the CPU receives the IPI, is "current" still the task
that was previously in nohz mode or the freshly enqueued one? When it's the
second case it becomes hard to clear the flag.

Probably I'll need to hook into the enqueue_task() path to fixup that.

> We should then also rate-limit things so as not to
> enable/disable the tick too often, but that would potentially allow us
> to do away with all knobs.

Right. Before I posted that, I actually had a minimum duration threshold of the tick.
Like, even if we can stop the tick, just wait x more ns, x beeing an abritrary constant.
But that was actually complicating the thing and I wasn't sure there was a real gain.
