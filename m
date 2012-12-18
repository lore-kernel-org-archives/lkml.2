Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab2LRUGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 15:06:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab2LRUGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 15:06:01 -0500
Date: Tue, 18 Dec 2012 21:06:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
	core_pattern-set-core-helpers-root-and-namespace-to-crashing-process
	.patch added to -mm tree
Message-ID: <20121218200604.GA28834@redhat.com>
References: <20121217123428.GA1957@redhat.com> <20121217150559.GD25322@hmsreliant.think-freely.org> <20121217160408.GA20166@redhat.com> <20121217183925.GE25322@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121217183925.GE25322@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17, Neil Horman wrote:
>
> On Mon, Dec 17, 2012 at 05:04:08PM +0100, Oleg Nesterov wrote:
> >
> > > Is there a way to switch all namespaces, except for the pid
> > > namespace?
> >
> > Which exactly namespaces you want to change?
> >
> Ideally, I want the pipe reader process to execute in the same namespaces that
> the crashing process executed in (i.e. the pipe reader should execute as though
> the crashing process forked it).

Yes, and we probably want to change pid_ns as well. But afaics currently
this is not possible, even setns can't do this.

I am starting to think that in this case, perhaps, do_coredump() should
not use call_usermode_helper() at all. Perhaps we can do clone(CLONE_VM) +
commit_creds/restore_root/etc + kernel_execve.

> > To be honest, I do not understand this patch at all. It seems that
> > you need to do something like sys_setns(). But if we do this, then
> > why we can't make core_pattern per-namespace?
> >
> That actually would make sense, although we can't really use setns directly, as
> I don't think we want to open file descriptors to do this manipulation in the
> kernel.

Yes, yes, sure. But this is solveable. We do not really need to open
the files in /proc, we could use proc_ns_operations->install() directly.
Although this is not pretty.

> Perhaps its best just to restrict this patch to adjusting the root fs location
> for the chroot case.

Probably... at least for the start.

BTW. Of course this is subjective, but personally I think that "||"
looks strange. Perhaps it would be better to add something like
--croot argument?

Oleg.

