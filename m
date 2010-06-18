Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870Ab0FRRh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:37:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933739Ab0FRRh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:37:28 -0400
Date: Fri, 18 Jun 2010 18:27:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@parallels.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Louis Rilling <Louis.Rilling@kerlabs.com>
Subject: Re: [PATCH] procfs: Do not release pid_ns->proc_mnt too early
Message-ID: <20100618162734.GB7404@redhat.com>
References: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com> <4C19F0A3.2050707@parallels.com> <m1631hdbdu.fsf@fess.ebiederm.org> <20100617213638.GB4182@redhat.com> <20100618082738.GE16877@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618082738.GE16877@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Louis Rilling wrote:
>
> On 17/06/10 23:36 +0200, Oleg Nesterov wrote:
> > On 06/17, Eric W. Biederman wrote:
> > >
> > > The task->children isn't changed until __unhash_process() which runs
> > > after flush_proc_task().
> >
> > Yes. But this is only the current implementation detail.
> > It would be nice to cleanup the code so that EXIT_DEAD tasks are
> > never sit in ->children list.
> >
> > > So we should be able to come up with
> > > a variant of do_wait() that zap_pid_ns_processes can use that does
> > > what we need.
> >
> > See above...
> >
> > Even if we modify do_wait() or add the new variant, how the caller
> > can wait for EXIT_DEAD tasks? I don't think we want to modify
> > release_task() to do __wake_up_parent() or something similar.
>
> Indeed, I was thinking about calling __wake_up_parent() from release_task()
> once parent->children becomes empty.
>
> Not sure about the performance impact though. Maybe some WAIT_NO_CHILDREN flag
> in parent->signal could limit it. But if EXIT_DEAD children are removed from
> ->children before release_task(), I'm afraid that this becomes impossible.

Thinking more, even the current do_wait() from zap_pid_ns_processes()
is not really good. Suppose that some none-init thread is ptraced, then
zap_pid_ns_processes() will hange until the tracer does do_wait() or
exits.

Oleg.

