Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641Ab1D1PU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:20:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55832 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760629Ab1D1PU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d2UCfvj9oyI53DBQiImzMYVbPbV/crBC+C6PLp9KV8XS8KK52iCSZ8sIMzqPRGMr8+
         7RNJljHVNuuAf+472Qw26fa2/hb4QNX4jPwjuXebsILsB5Q9T4smdc2DyTVEDKhtyLmr
         w4JOuxanenkt6IL+EaBr4iwdT5fa3Yov0+7dk=
Date: Thu, 28 Apr 2011 17:20:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com, eparis@redhat.com,
        agl@chromium.org, mingo@elte.hu, jmorris@namei.org,
        rostedt@goodmis.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call
 filtering
Message-ID: <20110428152015.GE1798@nowhere>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
 <1303960136-14298-2-git-send-email-wad@chromium.org>
 <20110428151241.GD1798@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428151241.GD1798@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 05:12:44PM +0200, Frederic Weisbecker wrote:
> On Wed, Apr 27, 2011 at 10:08:47PM -0500, Will Drewry wrote:
> > This change adds a new seccomp mode based on the work by
> > agl@chromium.org. This mode comes with a bitmask of NR_syscalls size and
> > an optional linked list of seccomp_filter objects. When in mode 2, all
> > system calls are first checked against the bitmask to determine if they
> > are allowed or denied.  If allowed, the list of filters is checked for
> > the given syscall number. If all filter predicates for the system call
> > match or the system call was allowed without restriction, the process
> > continues. Otherwise, it is killed and a KERN_INFO notification is
> > posted.
> > 
> > The filter language itself is provided by the ftrace filter engine.
> > Related patches tweak to the perf filter trace and free allow the calls
> > to be shared. Filters inherit their understanding of types and arguments
> > for each system call from the CONFIG_FTRACE_SYSCALLS subsystem which
> > predefines this information in syscall_metadata associated enter_event
> > (and exit_event) structures.
> > 
> > The result is that a process may reduce its available interfaces to
> > the kernel through prctl() without knowing the appropriate system call
> > number a priori and with the flexibility of filtering based on
> > register-stored arguments.  (String checks suffer from TOCTOU issues and
> > should be left to LSMs to provide policy for! Don't get greedy :)
> > 
> > A sample filterset for a process that only needs to interact over stdin
> > and stdout and exit cleanly is shown below:
> >   sys_read: fd == 0
> >   sys_write: fd == 1
> >   sys_exit_group: 1
> > 
> > The filters may be specified once prior to entering the reduced access
> > state:
> >   prctl(PR_SET_SECCOMP, 2, filters);
> 
> Instead of having such multiline filter definition with syscall
> names prepended, it would be nicer to make the parsing simplier.
> 
> You could have either:
> 
> 	prctl(PR_SET_SECCOMP, mode);
> 	/* Works only if we are in mode 2 */
> 	prctl(PR_SET_SECCOMP_FILTER, syscall_nr, filter);
> 
> or:
> 	/*
> 	 * If mode == 2, set the filter to syscall_nr
> 	 * Recall this for each syscall that need a filter.
> 	 * If a filter was previously set on the targeted syscall,
> 	 * it will be overwritten.
> 	 */
> 	prctl(PR_SET_SECCOMP, mode, syscall_nr, filter);
> 
> One can erase a previous filter by setting the new filter "1".
> 
> Also, instead of having a bitmap of syscall to accept. You could
> simply set "0" as a filter to those you want to deactivate:
> 
> prctl(PR_SET_SECCOMP, 2, 1, 0); <- deactivate the syscall_nr 1


I meant "0" and not 0. Because a NULL filter would actually mean we
don't have a filter, which would be the same as "1".

> 
> Hm?
