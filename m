Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2FYPU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:20:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab2FYPUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:20:24 -0400
Date: Mon, 25 Jun 2012 17:18:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: deferring __fput()
Message-ID: <20120625151812.GA16062@redhat.com>
References: <1340369098.2464.20.camel@falcor> <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623203800.GA10306@redhat.com> <20120623210141.GK14083@ZenIV.linux.org.uk> <20120624041652.GN14083@ZenIV.linux.org.uk> <20120624153310.GB24596@redhat.com> <20120625060357.GT14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625060357.GT14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Al Viro wrote:
>
> On Sun, Jun 24, 2012 at 05:33:10PM +0200, Oleg Nesterov wrote:
> > No, we can't do this?
> >
> > OK, perhaps we can check something else instead of PF_EXITING.
> > But somehow we should ensuree that if task_work_add(twork) succeeds,
> > then twork->func() will be called. IOW, if task_work_add() races with
> > the exiting task, it should not succeed after exit_task_work().
>
> Hrm...  I still think that callers can bloody well check it themselves,

Why? I don't think this would be very convenient, and it is not easy
to avoid the races. Unless task == current.

OK, if task == current it can do the necessary checks, so we could add
"force" argument for fput(). But I agree, it would be better to avoid
this.

And since we want to move exit_task_work() after exit_fs() we can't
rely on PF_EXITING (unless we add "force").

> but anyway - we can add a new PF_... bit and have it set on kernel threads
> (all along)

Why? irq_thread() already uses task_work_add()...

> the real question is in locking
> and barriers needed there.  Suggestions?

Yes, we need more barries. Or, perhaps exit_task_work() should simply
take ->pi_lock unconditionally? I don't think additional STORE + mb()
is better.

And if it always takes ->pi_lock we do not need the new PF_ or something
else, exit_task_work() can set task->task_works = NO_MORE under ->pi_lock
(task_work_run() can check PF_EXITING), and task_work_add() ensures that
task_works != NO_MORE.

What do you think?

Oleg.

