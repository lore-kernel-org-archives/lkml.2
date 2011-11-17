Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab1KQRFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:05:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882Ab1KQRFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:05:24 -0500
Date: Thu, 17 Nov 2011 17:00:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
	pids
Message-ID: <20111117160011.GC12325@redhat.com>
References: <4EC4F2FB.408@parallels.com> <4EC4F348.6020101@parallels.com> <20111117153200.GA12325@redhat.com> <4EC52D14.8090701@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC52D14.8090701@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17, Pavel Emelyanov wrote:
>
> On 11/17/2011 07:32 PM, Oleg Nesterov wrote:
> > On 11/17, Pavel Emelyanov wrote:
> >>
> >> +static int set_pidmap(struct pid_namespace *pid_ns, int pid)
> >> +{
> >> +	int offset;
> >> +	struct pidmap *map;
> >> +
> >> +	/*
> >> +	 * When creating a new pid namespace we must make its init
> >> +	 * have pid == 1 in it.
> >> +	 */
> >> +	if (pid_ns->child_reaper == NULL)
> >> +		return 0;
> >
> > Do we really need this check? please see below...
> >
> >> +	/*
> >> +	 * Don't allow to create a task with a pid which has recently
> >> +	 * belonged to some other (dead already) task. Only init (of
> >> +	 * a freshly created namespace) and his clones can do this.
> >> +	 */
> >> +	if (pid_ns->last_pid != 1)
> >> +		return -EPERM;
> >
> > ->last_pid == 1. This means that pid_nr == 1 was already created
> > in this namespace via CLONE_NEWPID, and the child with this pid
> > must be ->child_reaper, no?
>
> If you use the CLONE_NEWPID | CLONE_CHILD_USEPIDS

Ah wait... I misread the check above as if it returns the error if
->child_reaper == NULL.

So, CLONE_NEWPID simply ignores child_tidptr[0], alloc_pid()
fallbacks to alloc_pidmap() after set_pidmap() returns 0.

> > Cough. I really think 45a68628 should be reverted ;) IMHO it
> > complicates the understanding of CLONE_NEWPID logic.
>
> If we remove it, then it's OK to remove the check above, but in this case we
> make it possible to have an init with pid != 1. This is flexible, but ... strange.

No, I didn't mean we should allow ->child_reaper with pid != 1, sorry
for confusion.

Oleg.

