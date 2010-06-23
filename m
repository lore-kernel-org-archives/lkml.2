Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0FWQCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:02:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33754 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab0FWQCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rVoq497kqRaJQxYMfvnHz4oFcXzOutGdJ11PEi9JgYKlUSGCy2i036dNybFVk9pQ1V
         ZQftn8o+ReAOpleBdHd8CFHgAdhH0kG0dnBNBpdUBA85SGn/SX5a4UYyRVBLoHfIhby7
         sq+zhGJXXBU+FetCZ4xl6mUTbqliw4dgSqmQc=
Date: Wed, 23 Jun 2010 18:02:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 10/40] tracing: add tracing support for compat syscalls
Message-ID: <20100623160249.GF5242@nowhere>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-11-git-send-email-imunsie@au1.ibm.com> <1277306786.9181.51.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277306786.9181.51.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 11:26:26AM -0400, Steven Rostedt wrote:
> On Wed, 2010-06-23 at 20:02 +1000, Ian Munsie wrote:
> > From: Jason Baron <jbaron@redhat.com>
> > 
> > Add core support to event tracing for compat syscalls. The basic idea is that we
> > check if we have a compat task via 'is_compat_task()'. If so, we lookup in the
> > new compat_syscalls_metadata table, the corresponding struct syscall_metadata, to
> > check syscall arguments and whether or not we are enabled.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> > ---
> >  include/linux/compat.h        |    2 +
> >  include/trace/syscall.h       |    4 ++
> >  kernel/trace/trace.h          |    2 +
> >  kernel/trace/trace_syscalls.c |   86 +++++++++++++++++++++++++++++++++++++----
> >  4 files changed, 86 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/linux/compat.h b/include/linux/compat.h
> > index ab638e9..a94f13d 100644
> > --- a/include/linux/compat.h
> > +++ b/include/linux/compat.h
> > @@ -363,6 +363,8 @@ extern ssize_t compat_rw_copy_check_uvector(int type,
> >  
> >  #else /* CONFIG_COMPAT */
> >  
> > +#define NR_syscalls_compat 0
> > +
> >  static inline int is_compat_task(void)
> >  {
> >  	return 0;
> > diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> > index 75f3dce..67d4e64 100644
> > --- a/include/trace/syscall.h
> > +++ b/include/trace/syscall.h
> > @@ -22,6 +22,7 @@
> >  struct syscall_metadata {
> >  	const char	*name;
> >  	int		syscall_nr;
> > +	int		compat_syscall_nr;
> 
> This is also bloating the kernel. I don't like to add fields to the
> syscall_metadata lightly.
> 
> You're adding 4 more bytes to this structure to handle a few items. Find
> a better way to do this.


This is for cases when the compat and normal handlers are the same.
I haven't checked whether such case happen enough to make this a
benefit. I suspect it's not. Moreover I guess this adds more
complexity to the code.

May be this should be simply dropped.



 
> >  	int		nb_args;
> >  	const char	**types;
> >  	const char	**args;
> > @@ -38,6 +39,9 @@ struct syscall_metadata {
> >  
> >  #ifdef CONFIG_FTRACE_SYSCALLS
> >  extern unsigned long arch_syscall_addr(int nr);
> > +#ifdef CONFIG_COMPAT
> > +extern unsigned long arch_compat_syscall_addr(int nr);
> > +#endif
> >  extern int init_syscall_trace(struct ftrace_event_call *call);
> >  
> >  extern int reg_event_syscall_enter(struct ftrace_event_call *call);
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 01ce088..53ace4b 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -79,12 +79,14 @@ enum trace_type {
> >  struct syscall_trace_enter {
> >  	struct trace_entry	ent;
> >  	int			nr;
> > +	int			compat;
> 
> You're adding 4 bytes to a trace (taking up precious buffer space) for a
> single flag. If anything, set the 31st bit of nr if it is compat.



That too can be dropped I think. compat syscalls and normal syscalls are
different events, so the difference can be made in the event id or name.

