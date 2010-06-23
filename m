Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0FWTfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:35:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab0FWTfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:35:24 -0400
Date: Wed, 23 Jun 2010 15:34:56 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ian Munsie <imunsie@au1.ibm.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 08/40] tracing: remove syscall bitmaps in preparation
	for compat support
Message-ID: <20100623193455.GE2680@redhat.com>
References: <1277287401-28571-1-git-send-email-imunsie@au1.ibm.com> <1277287401-28571-9-git-send-email-imunsie@au1.ibm.com> <1277306204.9181.43.camel@gandalf.stny.rr.com> <20100623191454.GC2680@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623191454.GC2680@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 03:14:54PM -0400, Jason Baron wrote:
> On Wed, Jun 23, 2010 at 11:16:44AM -0400, Steven Rostedt wrote:
> > On Wed, 2010-06-23 at 20:02 +1000, Ian Munsie wrote:
> > > From: Jason Baron <jbaron@redhat.com>
> > > 
> > > In preparation for compat syscall tracing support, let's store the enabled
> > > syscalls, with the struct syscall_metadata itself. That way we don't duplicate
> > > enabled information when the compat table points to an entry in the regular
> > > syscall table. Also, allows us to remove the bitmap data structures completely.
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> > > ---
> > >  include/linux/syscalls.h      |    8 +++++++
> > >  include/trace/syscall.h       |    4 +++
> > >  kernel/trace/trace_syscalls.c |   42 +++++++++++++++++++---------------------
> > >  3 files changed, 32 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> > > index 86f082b..755d05b 100644
> > > --- a/include/linux/syscalls.h
> > > +++ b/include/linux/syscalls.h
> > > @@ -163,6 +163,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
> > >  		.nb_args 	= nb,				\
> > >  		.types		= types_##sname,		\
> > >  		.args		= args_##sname,			\
> > > +		.ftrace_enter	= 0,				\
> > > +		.ftrace_exit	= 0,				\
> > > +		.perf_enter	= 0,				\
> > > +		.perf_exit	= 0,				\
> > 
> > I really hate this change!
> > 
> > You just removed a nice compressed bitmap (1 bit per syscall) to add 4
> > bytes per syscall. On my box I have 308 syscalls being traced. That was
> > 308 bits per bitmask = 39 bytes * 2 = 78 * 2 (perf and ftrace) = 156.
> > 
> > Now we have 8 bytes per syscall (enter and exit), which is 1232 bytes.
> > 
> > Thus this change added 1076 bytes.
> > 
> > This may not seem as much, but the change is not worth 1K. Can't we just
> > add another bitmask or something for the compat case?
> > 
> > I also hate the moving of ftrace and perf internal data to an external
> > interface.
> > 
> > -- Steve
> > 
> 
> I made this change (I also wrote the original bitmap), b/c compat
> syscalls can share "regular" syscalls. That is the compat syscall table
> points to syscalls from non-compat mode. (looking at ia32 on x86 it
> looks like at least half).
> 
> Thus, if we continue along the bitmap path, we would have to introduce
> another 4 bitmaps for compat. 2 for enter and exit and 2 for perf and
> ftrace. Thus, using your math above: 39 bytes * 8 = 312 bytes. So
> approximately 1 byte per system call.
> 
> Instead, if we store this data in the syscall metadata, we actually only
> need 4 bits per syscall. Now, the above implementation uses 4 chars,
> where we really only need 1 char (or really 4 bits, which we could
> eventually store in the last last bit of the four existing pointer
> assuming they are 2 byte aligned for no increased storage space at all).
> But even assuming we use 1 byte per system call we are going to have in
> the worse case the above 312 bytes + (1 byte * # of non-shared compat
> syscalls). So, yes we might need a little more storage in this scheme.
> Another consideration too, is obviously the alignment of
> syscall_metadata, since the extra 1 byte, might be more...
> 
> However, we don't have to compute the location of the bits in the
> compat syscall map each time a tracing syscall is enable/disable. This
> would be more expensive, especially if we don't store the compat syscall
> number with each syscall meta data structure (which you have proposed
> dropping). So with compat syscalls, we are setting two bit locations
> with each enable/disable instead of 1 with this new scheme.
> 
> Also, I think the more important reason to store these bits in the
> syscall meta data structure is simplicity. Not all arches start their tables
> counting from 0 (requiring a constant shift factor), and obviously we
> waste bits for non-implemented syscalls. I don't want to have to deal
> with these arch specific implementation issues, if I don't need to.
> 
> thanks,
> 
> -Jason
> 

Actually, looking at this further, what we probably want to do change
the "int nb_args" field, which is already in syscall_metadata into a bit
field. nb_args I think can be at most 6, or 3 bits, and we only need 4
bits for storing the enabled/disabled data, so we could even make it a
char. Thus, actually saving space with this patch :) (at least as far as
the syscall_metadata field is concerned).

thanks,

-Jason
