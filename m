Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab0KRIoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:44:22 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57629 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab0KRIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:44:19 -0500
Date: Thu, 18 Nov 2010 17:43:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH -v4 1/2] lib, Make gen_pool memory allocator lockless
Message-ID: <20101118084341.GA23766@linux-sh.org>
References: <1289868791-16658-1-git-send-email-ying.huang@intel.com> <1289868791-16658-2-git-send-email-ying.huang@intel.com> <20101116135038.fcaa90ca.akpm@linux-foundation.org> <1289960281.8719.1218.camel@yhuang-dev> <1289990458.2109.675.camel@laptop> <AANLkTi=X2noJJwJwWh30-ac76f-pN5W0cD2c9w0F1EeK@mail.gmail.com> <1289994796.2109.722.camel@laptop> <1290042887.3122.5.camel@yhuang-dev> <1290069275.2109.1290.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290069275.2109.1290.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:34:35AM +0100, Peter Zijlstra wrote:
> On Thu, 2010-11-18 at 09:14 +0800, Huang Ying wrote:
> > On Wed, 2010-11-17 at 19:53 +0800, Peter Zijlstra wrote:
> > > On Wed, 2010-11-17 at 19:47 +0800, huang ying wrote:
> > > > On Wed, Nov 17, 2010 at 6:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > On Wed, 2010-11-17 at 10:18 +0800, Huang Ying wrote:
> > > > >>
> > > > >> cmpxchg has been used in that way by ftrace and perf for a long time. So
> > > > >> I agree to make it a requirement on future architecture ports.
> > > > >
> > > > > Neither mandate an architecture do this though, only that when an
> > > > > architecture wants to support either feature and has NMIs (not all archs
> > > > > have NMI equivalents) it has to be safe.
> > > > 
> > > > So we can make sure cmpxchg can be used in lock-less code on
> > > > architectures with perf, irq_work or ftrace enabled?
> > > 
> > > It had better, otherwise stuff is broken.
> > 
> > Take a look at superh architecture cmpxchg implementation. It seems that
> > cmpxchg is implemented with special instruction if CONFIG_GUSA_RB=y or
> > CONFIG_CPU_SH4A=y, otherwise it is implemented with local_irq_save. Is
> > it possible that superh has not PMU support if CONFIG_GUSA_RB=n and
> > CONFIG_CPU_SH4A=n, so that perf work properly but no NMI safe cmpxchg in
> > that situation?
> 
> Dunno, you forgot to CC the author of that code.. I've really no clue
> about SH.

At the moment it's only SH-4 and SH-4A CPUs that implement PMU support,
so all of these are covered by a theoretically NMI-safe cmpxchg
implementation. This is more by coincidence than design, though.

The only cause for concern really is SH-2A which supports hardware
breakpoints (and perf events by proxy) but doesn't contain a PMU, and
only uses an IRQs disabled cmpxchg for the moment. It also supports
ftrace. I suppose I'll need to come up with a hack for this case..
