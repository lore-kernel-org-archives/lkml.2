Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab1IICLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:11:45 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:38851 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543Ab1IICLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:11:43 -0400
Date: Thu, 8 Sep 2011 22:11:23 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, neilb@suse.de,
        paul@paulmenage.org, paulmck@linux.vnet.ibm.com
Subject: Re: +
 cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch added to
 -mm tree
Message-ID: <20110909021122.GC16771@unix33.andrew.cmu.edu>
References: <201109012108.p81L8X0b029484@imap1.linux-foundation.org>
 <20110902123706.GB26764@redhat.com>
 <20110902140015.GA31530@redhat.com>
 <20110902141550.GA24012@unix33.andrew.cmu.edu>
 <20110902155534.GA4595@redhat.com>
 <20110907235931.GA22545@unix33.andrew.cmu.edu>
 <20110908173559.GA26492@redhat.com>
 <20110908185805.GB15434@ghc03.ghc.andrew.cmu.edu>
 <20110908213130.GA3924@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908213130.GA3924@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 11:31:30PM +0200, Oleg Nesterov wrote:
> On 09/08, Ben Blum wrote:
> >
> > As for the patch below (which is the same as it was last time?):
> 
> It is the same, yes, I simply copied it from my old email. BTW, it
> wasn't tested at all, even compiled.

Testing is recommended ;)

> 
> > did you
> > mean for Andrew to replace the old tasklist_lock patch with this one, or
> > should one of us rewrite this against it?
> 
> This is up to you. And just in case, please feel free to do nothing and
> keep the current fix.

No, I do like the sighand method better now that I've thought about it.
The way it subsumes the check for consistency of the leader's links is
rather nice (much as it still requires deep understanding of de_thread).

If you polished this patch off, I'd be happier, since I have a lot else
on my plate.

> 
> > either way, it should have
> > something like the comment I proposed in the first thread.
> 
> Confused... Aha, I missed another email from you. You mean
> 
> 	/* If the leader exits, its links on the thread_group list become
> 	 * invalid. One way this can happen is if a sub-thread does exec() when
> 	 * de_thread() calls release_task(leader) (and leader->sighand gets set
> 	 * to NULL, in which case lock_task_sighand will fail). Since in that
> 	 * case the threadgroup is still around, cgroup_procs_write should try
> 	 * again (finding the new leader), which EAGAIN indicates here. This is
> 	 * "double-double-toil-and-trouble-check locking". */
> 
> Agreed.
> 
> 
> 
> 
> 
> Off-topic question... Looking at this code, it seems that
> attach_task_by_pid(zombie_pid, threadgroup => true) returns 0.
> single-task-only case fails with -ESRCH in this case. I am not
> saying this is wrong, just this looks a bit strange (unless I
> misread the code).

yeah, this is a side-effect of cgroup_attach_proc continuing to iterate
in case any one of the sub-threads be still alive. you could keep track
of whether all threads were zombies and return -ESRCH then, but it
shouldn't matter, since the user-facing behaviour is indistinguishable
from if the user had sent the command just before the task turned zombie
but while it was still about to exit.

Thanks,
Ben

> 
> Oleg.
> 
> 
