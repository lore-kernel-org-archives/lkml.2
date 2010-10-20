Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab0JTBxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 21:53:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab0JTBxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 21:53:07 -0400
Date: Tue, 19 Oct 2010 21:52:27 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, kaneshige.kenji@jp.fujitsu.com,
        David Miller <davem@davemloft.net>, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
Message-ID: <20101020015227.GA2011@redhat.com>
References: <20101019132236.GA19197@Krystal>
 <alpine.LFD.2.00.1010191524160.6815@localhost6.localdomain6>
 <1287496495.16971.372.camel@gandalf.stny.rr.com>
 <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6>
 <20101019142820.GA14520@Krystal>
 <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6>
 <20101019212816.GA2855@redhat.com>
 <alpine.LFD.2.00.1010192347390.6815@localhost6.localdomain6>
 <alpine.LFD.2.00.1010200015320.6815@localhost6.localdomain6>
 <1287538590.16971.548.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287538590.16971.548.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2010-07-18)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 09:36:30PM -0400, Steven Rostedt wrote:
> 
> On Wed, 2010-10-20 at 00:17 +0200, Thomas Gleixner wrote:
> > On Tue, 19 Oct 2010, Thomas Gleixner wrote:
> > > On Tue, 19 Oct 2010, Jason Baron wrote:
> > > > > Now even worse, when you NOP out the jmpq then your tracepoint is
> > > > > still not enabled. Brilliant !
> > > > > 
> > > > 
> > > > The 'jmpq' in the enabled case is patched with a jmpq to the body of the
> > > > tracepoint itself.
> > > 
> > > Brilliant.
> > 
> > IOW, We now jump around the jump which jumps around the disabled code.
> > 
> 
> 
> Do you happen to have CONFIG_CC_OPTIMIZE_FOR_SIZE set? If so, then this
> is a known issue. We even originally had jump label enabled _only_ if
> CC_OPTIMIZE_FOR_SIZE was not set, but hpa NAK'd it.
> 
> http://lkml.org/lkml/2010/9/22/482
> 
> http://lkml.org/lkml/2010/9/20/488
> 
> http://lkml.org/lkml/2010/9/24/259
> 
> -- Steve

thanks Steve. I was about to say this. When CONFIG_CC_OPTIMIZE_FOR_SIZE
is not set we don't get the double 'jmp' and the tracepoint code is
moved out of line. It was mentioned that a number of distros ship with
CONFIG_CC_OPTIMIZE_FOR_SIZE not set, and as Steve mentioned my original
patch set was conditional on !CONFIG_CC_OPTIMIZE_FOR_SIZE.

using hot/cold labels gcc can fix the CONFIG_CC_OPTIMIZE_FOR_SIZE case,
but its a non-trivial amount of work for gcc. I was hoping that if jump
labels are included, we could make the gcc work happen.

thanks,

-Jason
