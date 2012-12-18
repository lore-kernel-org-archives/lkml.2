Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2LRUTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:19:32 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55304 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab2LRUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:19:31 -0500
Date: Tue, 18 Dec 2012 15:19:01 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
 core_pattern-set-core-helpers-root-and-namespace-to-crashing-process .patch
 added to -mm tree
Message-ID: <20121218201900.GA10059@hmsreliant.think-freely.org>
References: <20121217123428.GA1957@redhat.com>
 <20121217150559.GD25322@hmsreliant.think-freely.org>
 <20121217160408.GA20166@redhat.com>
 <20121217183925.GE25322@hmsreliant.think-freely.org>
 <20121218200604.GA28834@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121218200604.GA28834@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 09:06:04PM +0100, Oleg Nesterov wrote:
> On 12/17, Neil Horman wrote:
> >
> > On Mon, Dec 17, 2012 at 05:04:08PM +0100, Oleg Nesterov wrote:
> > >
> > > > Is there a way to switch all namespaces, except for the pid
> > > > namespace?
> > >
> > > Which exactly namespaces you want to change?
> > >
> > Ideally, I want the pipe reader process to execute in the same namespaces that
> > the crashing process executed in (i.e. the pipe reader should execute as though
> > the crashing process forked it).
> 
> Yes, and we probably want to change pid_ns as well. But afaics currently
> this is not possible, even setns can't do this.
> 
> I am starting to think that in this case, perhaps, do_coredump() should
> not use call_usermode_helper() at all. Perhaps we can do clone(CLONE_VM) +
> commit_creds/restore_root/etc + kernel_execve.
> 
Yeah, I was comming to this same conclusion last night as well.  I'd rather keep
using the call_usermode_helper solution if at all possible, but perhaps we can
integrate a clone path into it.

> > > To be honest, I do not understand this patch at all. It seems that
> > > you need to do something like sys_setns(). But if we do this, then
> > > why we can't make core_pattern per-namespace?
> > >
> > That actually would make sense, although we can't really use setns directly, as
> > I don't think we want to open file descriptors to do this manipulation in the
> > kernel.
> 
> Yes, yes, sure. But this is solveable. We do not really need to open
> the files in /proc, we could use proc_ns_operations->install() directly.
> Although this is not pretty.
> 
Its not pretty, no.  If we use the above clone solution however, we can avoid
this entirely.

> > Perhaps its best just to restrict this patch to adjusting the root fs location
> > for the chroot case.
> 
> Probably... at least for the start.
> 
> BTW. Of course this is subjective, but personally I think that "||"
> looks strange. Perhaps it would be better to add something like
> --croot argument?
> 
The || is ambiguous with its simmilarity to a shell 'or' command, but I don't
think the --croot argument is much better on that front, as that then becomes
ambiguous with arguments supplied to the pipe reader directly.  The token should
be leading the pipe_reader string in core_pattern to indicate a change in
environment independent of the executable path.  Perhaps |^ or something
simmilar?

Either way, Andrew, could you please drop this patch?  Olegs comments I think
make it pretty clear I've got some more work to do on this.

Thanks!
Neil

