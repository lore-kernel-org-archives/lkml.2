Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2E2Wjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 18:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab2E2Wjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 18:39:36 -0400
Date: Tue, 29 May 2012 18:39:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rja@americas.sgi.com
Subject: Re: [PATCH] x86: Avoid intermixing cpu dump_stack output on
 multi-processor systems
Message-ID: <20120529223923.GF32472@redhat.com>
References: <20120524144229.GA27713@sgi.com>
 <20120529175352.GA31524@redhat.com>
 <20120529191935.GB29726@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529191935.GB29726@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 02:19:35PM -0500, Russ Anderson wrote:
> On Tue, May 29, 2012 at 01:53:53PM -0400, Don Zickus wrote:
> > On Thu, May 24, 2012 at 09:42:29AM -0500, Russ Anderson wrote:
> > > When multiple cpus on a multi-processor system call dump_stack()
> > > at the same time, the backtrace lines get intermixed, making 
> > > the output worthless.  Add a lock so each cpu stack dump comes
> > > out as a coherent set.
> > > 
> > > For example, when a multi-processor system is NMIed, all of the
> > > cpus call dump_stack() at the same time, resulting in output for
> > > all of cpus getting intermixed, making it impossible to tell what
> > > any individual cpu was doing.  With this patch each cpu prints
> > > its stack lines as a coherent set, so one can see what each cpu
> > > was doing.
> > 
> > For this particular test case, it sounds like you are doing what
> > trigger_all_cpu_backtrace() is doing?  It doesn't solve the general
> > problem, but probably your particular usage?
> 
> In this case, I am just using the hardware NMI, which sends the NMI
> signal to each logical cpu.  Since each cpu receives the NMI at nearly
> the exact same time, they end up in dump_stack() at the same time.
> Without some form of locking, trace lines from different cpus end
> up intermixed, making it impossible to tell what any individual 
> cpu was doing.

I forgot the original reasons for having the NMI go to each CPU instead of
just the boot CPU (commit 78c06176), but it seems like if you revert that
patch and have the nmi handler just call trigger_all_cpu_backtrace()
instead (which does stack trace locking for pretty output), that would
solve your problem, no?  That locking is safe because it is only called in
the NMI context.

Whereas the lock you are proposing can be called in a mixture of NMI and
IRQ which could cause deadlocks I believe.

Cheers,
Don
