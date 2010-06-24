Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0FXMfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 08:35:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0FXMfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 08:35:47 -0400
Date: Thu, 24 Jun 2010 14:35:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org,
       mauro@elte.hu
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624123537.GA28884@elte.hu>
References: <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
 <1277364727.1875.857.camel@laptop>
 <20100624102725.GA578@basil.fritz.box>
 <1277375409.1875.943.camel@laptop>
 <20100624105254.GB578@basil.fritz.box>
 <1277377121.1875.948.camel@laptop>
 <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
 <20100624112340.GA13502@elte.hu>
 <1277379294.1875.959.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277379294.1875.959.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4583]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-06-24 at 13:23 +0200, Ingo Molnar wrote:
> 
> > What might make sense is to offer two types of callbacks: one that is 
> > immediate whenever an event triggers - and another that is sleepable and is 
> > executed from process context.
> 
> Trouble is waking that thread, you cannot wake tasks from NMI context,
> so whatever you do, you'll end up with a trampoline.
> 
> You could of course offer that trampoline nicely packaged, but I'm not
> sure that's really worth the effort.

Right, so there's basically three clean solutions to the 'sleepable callback' 
problem, in order of amount of state that needs to be passed to it:

 - State-less (or idempotent) events/callbacks: use a hardirq callback to wake
   up a well-known process context.

 - If we want the task that generates an event to execute a sleeping callback:
   use a TIF flag and state in the task itself to pass along the info.

 - In the most generic case, if there's arbitrary target task and arbitrary
   state that needs to be queued, then to achieve sleepable callbacks the
   following solution can be used: the task allocates a perf ring-buffer and
   uses a TIF flag to trigger consumption of it.

   All memory allocation, wakeup, etc. is handled already by the regular perf
   events and ring-buffer codepaths.

No special, open-coded trampolining needed - the ring-buffer is the trampoline 
and the ring-buffer consumer can key off the events it receives. (and there 
can be multiple consumers of the same event source so we can have in-task 
kernel based action combined with a user-space daemon that get an event stream 
as well.)

All of these solutions use the fact that perf events are a generic event 
framework. If there's any missing details somewhere then fixes/enhancements 
can be added - right now our in-kernel event consumers are simple. But the 
design is sound.

And none of these solutions involves the incestous low level raping of 
softirqs.

Thanks,

	Ingo
