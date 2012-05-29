Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab2E2TTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 15:19:39 -0400
Received: from relay3.sgi.com ([192.48.152.1]:34143 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754545Ab2E2TTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 15:19:38 -0400
Date: Tue, 29 May 2012 14:19:35 -0500
From: Russ Anderson <rja@sgi.com>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rja@americas.sgi.com
Subject: Re: [PATCH] x86: Avoid intermixing cpu dump_stack output on multi-processor systems
Message-ID: <20120529191935.GB29726@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20120524144229.GA27713@sgi.com> <20120529175352.GA31524@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529175352.GA31524@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 01:53:53PM -0400, Don Zickus wrote:
> On Thu, May 24, 2012 at 09:42:29AM -0500, Russ Anderson wrote:
> > When multiple cpus on a multi-processor system call dump_stack()
> > at the same time, the backtrace lines get intermixed, making 
> > the output worthless.  Add a lock so each cpu stack dump comes
> > out as a coherent set.
> > 
> > For example, when a multi-processor system is NMIed, all of the
> > cpus call dump_stack() at the same time, resulting in output for
> > all of cpus getting intermixed, making it impossible to tell what
> > any individual cpu was doing.  With this patch each cpu prints
> > its stack lines as a coherent set, so one can see what each cpu
> > was doing.
> 
> For this particular test case, it sounds like you are doing what
> trigger_all_cpu_backtrace() is doing?  It doesn't solve the general
> problem, but probably your particular usage?

In this case, I am just using the hardware NMI, which sends the NMI
signal to each logical cpu.  Since each cpu receives the NMI at nearly
the exact same time, they end up in dump_stack() at the same time.
Without some form of locking, trace lines from different cpus end
up intermixed, making it impossible to tell what any individual 
cpu was doing.


> Cheers,
> Don
> 
> > 
> > It has been tested on a 4069 cpu system.
> > 
> > Signed-off-by: Russ Anderson <rja@sgi.com>
> > 
> > ---
> >  arch/x86/kernel/dumpstack.c |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > Index: linux/arch/x86/kernel/dumpstack.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/dumpstack.c	2012-05-03 14:31:13.602345805 -0500
> > +++ linux/arch/x86/kernel/dumpstack.c	2012-05-03 14:51:43.805197563 -0500
> > @@ -186,7 +186,9 @@ void dump_stack(void)
> >  {
> >  	unsigned long bp;
> >  	unsigned long stack;
> > +	static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
> >  
> > +	spin_lock(&lock);
> >  	bp = stack_frame(current, NULL);
> >  	printk("Pid: %d, comm: %.20s %s %s %.*s\n",
> >  		current->pid, current->comm, print_tainted(),
> > @@ -194,6 +196,7 @@ void dump_stack(void)
> >  		(int)strcspn(init_utsname()->version, " "),
> >  		init_utsname()->version);
> >  	show_trace(NULL, NULL, &stack, bp);
> > +	spin_unlock(&lock);
> >  }
> >  EXPORT_SYMBOL(dump_stack);
> >  
> > -- 
> > Russ Anderson, OS RAS/Partitioning Project Lead  
> > SGI - Silicon Graphics Inc          rja@sgi.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
