Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab1BJSMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:12:13 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22919 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab1BJSMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:12:12 -0500
Date: Thu, 10 Feb 2011 19:11:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Tadashi Abe <tabe@mvista.com>
cc: x86@kernel.org, tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix io_bitmap_ptr memory leak on copy_process()
In-Reply-To: <alpine.LNX.2.00.1102101901420.26035@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1102101909520.26035@swampdragon.chaosbits.net>
References: <4D50CDE6.5000903@mvista.com> <alpine.LNX.2.00.1102101901420.26035@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small correction to my previous mail below.

On Thu, 10 Feb 2011, Jesper Juhl wrote:

> On Tue, 8 Feb 2011, Tadashi Abe wrote:
> 
> > x86 copy_thread() allocates io_bitmap_ptr area in child's thread_struct
> > when the parent has TIF_IO_BITMAP flag via ioperm().
> > And in this case, if copy_process() terminates with errors
> > after copy_thread() success,
> > this io_bitmap_ptr area is being left without kfree().
> > 
> > Signed-off-by: Tadashi Abe <tabe@mvista.com>
> > ---
> >  arch/x86/kernel/process.c |    6 ++++++
> >  include/linux/sched.h     |    5 +++++
> >  kernel/fork.c             |    4 +++-
> >  3 files changed, 14 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> > index b3feabc..290e98b 100644
> > --- a/arch/x86/kernel/process.c
> > +++ b/arch/x86/kernel/process.c
> > @@ -122,6 +122,12 @@ void flush_thread(void)
> >  	clear_used_math();
> >  }
> >  
> > +void free_thread_struct(struct task_struct *p)
> > +{
> > +	if (p->thread.io_bitmap_ptr)
> > +		kfree(p->thread.io_bitmap_ptr);
> 
> kfree(NULL) is perfectly legal, so the 'if' is not needed.
> 
> Why is this a new function? Why not simply call kfree() when needed.
> 
> 
> > +}
> > +
> >  static void hard_disable_TSC(void)
> >  {
> >  	write_cr4(read_cr4() | X86_CR4_TSD);
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 23e9c27..2345391 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -2159,6 +2159,11 @@ extern int copy_thread(unsigned long, unsigned long, unsigned long,
> >  			struct task_struct *, struct pt_regs *);
> >  extern void flush_thread(void);
> >  extern void exit_thread(void);
> > +#ifdef CONFIG_X86
> > +extern void free_thread_struct(struct task_struct *p);
> > +#else
> > +#define free_thread_struct(p) do { } while (0)
> > +#endif
> >  
> 
> This should just go away IMHO.
> 
> >  extern void exit_files(struct task_struct *);
> >  extern void __cleanup_sighand(struct sighand_struct *);
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 25e4291..ffcabf3 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1179,7 +1179,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >  		retval = -ENOMEM;
> >  		pid = alloc_pid(p->nsproxy->pid_ns);
> >  		if (!pid)
> > -			goto bad_fork_cleanup_io;
> > +			goto bad_fork_free_thread;
> >  
> >  		if (clone_flags & CLONE_NEWPID) {
> >  			retval = pid_ns_prepare_proc(p->nsproxy->pid_ns);
> > @@ -1315,6 +1315,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >  bad_fork_free_pid:
> >  	if (pid != &init_struct_pid)
> >  		free_pid(pid);
> > +bad_fork_free_thread:
> > +	free_thread_struct(p);
> 
> kfree(p);
>   and be done with it..

I mean kfree(p->thread.io_bitmap_ptr); of course.


> 
> >  bad_fork_cleanup_io:
> >  	if (p->io_context)
> >  		exit_io_context(p);
> > 
> 
> Perhaps I'm overlooking something, in which case I'd be happy to be 
> corrected, but I really can't see why this can't just be as simple as I 
> outlined above.
> 
> 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

