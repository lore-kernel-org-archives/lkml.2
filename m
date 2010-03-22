Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab0CVUWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab0CVUWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:22:35 -0400
Date: Mon, 22 Mar 2010 16:21:42 -0400
From: Jason Baron <jbaron@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com, heiko.carstens@de.ibm.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 06/14] tracing: add tracing support for compat syscalls
Message-ID: <20100322202141.GC2278@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com> <a75e730f4fc49c3657d6e407fb16a3508ec321a9.1268749695.git.jbaron@redhat.com> <20100320061215.GN5085@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100320061215.GN5085@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 07:12:17AM +0100, Frederic Weisbecker wrote:
> >  #else /* CONFIG_COMPAT */
> >  
> > +#define NR_syscalls_compat 0
> > +
> >  static inline int is_compat_task(void)
> >  {
> >  	return 0;
> > diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> > index 8f5ac38..1cc1d1e 100644
> > --- a/include/trace/syscall.h
> > +++ b/include/trace/syscall.h
> > @@ -22,6 +22,7 @@
> >  struct syscall_metadata {
> >  	const char	*name;
> >  	int		syscall_nr;
> > +	int		compat_syscall_nr;
> 
> 
> 
> Why do you need both syscall_nr and compat_syscall_nr?
> Compat and usual syscalls never share the same syscall
> metadata.
> 
> 

For example, something like 'sys_read()' is pointed to by both
syscalls_metadata and compat_syscalls_metadata. Thus, the same syscall
metadata record is referenced by two different tables. That said, I'm not
making use of compat_syscall_nr. Although it could be added to the
checks in 'reg_event_syscall_enter()', to make sure that the
compat_syscall_nr is valid. 


> 
> > +#ifdef __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
> > +	if (NR_syscalls_compat) {
> > +		int match;
> > +		struct ftrace_event_call *ftrace_event;
> > +
> > +		compat_syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
> > +						NR_syscalls_compat, GFP_KERNEL);
> > +		if (!compat_syscalls_metadata) {
> > +			WARN_ON(1);
> > +			kfree(syscalls_metadata);
> > +			return -ENOMEM;
> > +		}
> > +		for (i = 0; i < NR_syscalls_compat; i++) {
> > +			addr = arch_compat_syscall_addr(i);
> > +			meta = find_syscall_meta(addr);
> > +			if (!meta)
> > +				continue;
> > +
> > +			meta->compat_syscall_nr = i;
> > +			compat_syscalls_metadata[i] = meta;
> > +		}
> > +		/* now check if any compat_syscalls are not referenced */
> > +		for (ftrace_event = __start_ftrace_events;
> > +			(unsigned long)ftrace_event <
> > +			(unsigned long)__stop_ftrace_events; ftrace_event++) {
> 
> 
> 
> You could reuse for_each_event()
> 
> 

ok. will update.

> 
> > +			match = 0;
> > +			if (!ftrace_event->name)
> > +				continue;
> > +			if (strcmp(ftrace_event->system, "compat_syscalls"))
> > +				continue;
> > +			for (i = 0; i < NR_syscalls_compat; i++) {
> > +				if (ftrace_event->data ==
> > +						compat_syscalls_metadata[i]) {
> > +					match = 1;
> > +					break;
> 
> 
> Nano-neat: starting the whole block with if (NR_syscalls_compat)
> or making the whole a separate init_ftrace_syscalls() would
> have made it win one level of indentation.
> 

yeah...I did that to add local variables at the beginning of the block
so I wouldn't get unused warnings. A separate function is probably
cleaner...will fix.


thanks,

-Jason
