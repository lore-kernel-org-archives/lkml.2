Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259Ab2CBPL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:11:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030201Ab2CBPLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:11:53 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=iqH1YQEIiWMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=qaujsk1Uvohx5Fsot8MA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330701112.25686.257.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RT 7/9][RFC] [PATCH 7/9] cpu/rt: Rework cpu down for
 PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Date: Fri, 02 Mar 2012 10:11:52 -0500
In-Reply-To: <alpine.LFD.2.02.1203021518501.2742@ionos>
References: <20120301185527.064629423@goodmis.org>
	 <20120301190346.172835662@goodmis.org>
	 <alpine.LFD.2.02.1203021518501.2742@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 15:52 +0100, Thomas Gleixner wrote:
> On Thu, 1 Mar 2012, Steven Rostedt wrote:
> > Bringing a CPU down is a pain with the PREEMPT_RT kernel because
> > tasks can be preempted in many more places than in non-RT. In
> > order to handle per_cpu variables, tasks may be pinned to a CPU
> > for a while, and even sleep. But these tasks need to be off the CPU
> > if that CPU is going down.
> > 
> > Several synchronization methods have been tried, but when stressed
> > they failed. This is a new approach.
> 
> OMG! That hotplug stuff has been ugly as hell already, but you managed
> to make it exponentially worse. That's really an achievement.

*Blush*  Oh no, I don't deserve the credit for that. Adding the
migrate_disable() and friends in -rt did most the work for me.


>  
> Instead of adding more mess, we should simply fix hotplug. 
> 
> We can migrate away all tasks _before_ we run stomp-machine and

Well, that's what this patch pretty much tried to do. But I agree, not
so nicely.

Should we call into the scheduler and tell it to do the migrate all
tasks off and add no new ones? But note, the migrate is done with
stomp_machine too. (per cpu, and on the CPU that's going down). Then we
need to let the scheduler allow stomp_machine to enter the CPU, which
shouldn't be that hard.


> prevent that any new tasks go on the cpu which is about to be taken
> down. Once all migratable tasks are gone, we only have to deal with
> the cpu bound ones, which is not causing such headaches.

Also, the headaches came mostly from the tasks that were bound to the
CPU. Moving everything off after the notifiers is what's best. I may be
able to have that happen. We need a way to call into the scheduler and
tell it to migrate everything off then.


> 
> So no, I rather keep the current problem than applying that insanity.

Note, the sync daemon was already added in -rt, I just modified it to be
a little different. What is currently there introduced lots of races
(especially that grabbing of the mutex). And is completely broken.

I'm willing to take another shot at it, but I'm burnt out from this
hotplug crap and I'm way behind in my other duties because of it. As for
now we have a fix (yes it's crappy), for those that need hotplug
working, they can use this mess.

I'm going to go off and catch up on my other work and when I get time
again I'll take another shot at it. Unless someone else beats me to it
(I can only hope so).

-- Steve




