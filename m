Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab1E3TY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:24:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab1E3TY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:24:56 -0400
Date: Mon, 30 May 2011 21:22:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110530192255.GB20616@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-4-git-send-email-tj@kernel.org> <201105180240.56754.vda.linux@googlemail.com> <20110518095539.GU20624@htj.dyndns.org> <20110523124314.GA7232@redhat.com> <20110524102834.GC10334@htj.dyndns.org> <20110525182919.GB16575@redhat.com> <20110526091401.GD9715@htj.dyndns.org> <20110526150150.GD12525@redhat.com> <20110527182121.GA3212@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527182121.GA3212@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Tejun Heo wrote:
>
> On Thu, May 26, 2011 at 05:01:50PM +0200, Oleg Nesterov wrote:
> > On 05/26, Tejun Heo wrote:
> > > > Or we can change do_wait() to detach a zombie leader. In this case it
> > > > is not clear what should we do if the debugger is the real parent.
> > > > Perhaps do_wait() should do the same: detach a leader (but not reap).
> > > > When the last thread does, the real parent will be notified again.
> > > > IOW, wait(tgid) can succeed twice.
> > >
> > > Just letting PTRACE_DETACH work for zombies sounds much simpler to me.
> >
> > Probably, but please note we have to modify do_wait() anyway. Otherwise
> > in general the tracer simply can not know the tracee has exited. IOW,
> > waitpid(zombie_leader_pid, WEXITED) should succeed without reaping if
> > delay_group_leader(), then the tracer can do PTRACE_DETACH. But this is
> > not symmetrical with sub-thread zombies.
>
> Yes, complicated.  The task/process duality conflicts.  wait(2)
> already is different for group leader and succeeds twice for the
> ptracer and the real parent (when they're different).
>
> If we relocate ptrace group leader zombie wait, as suggested, such
> that it waits for the task itself rather than the whole group, we
> would be taking away a feature - ptracer waiting for the whole process

Partly yes. The parent will be notified again and it can do another
wait() later. The problem is, this is confusing.

> I think group leader wait becoming asymmetrical with sub-thread
> zombies is perfectly fine - it already is.

Well, probably yes... But why? We have to change do_wait() anyway to
report the death of the leader. If we do this, we can detach it as
well.

> But would it be okay to
> change ptrace wait(2) on group leader to wait for the task itself
> rather than the whole group?

Yes, this is iffy. Simply because this can confuse the userspace.
May be we can add W_PTRACED_THREAD_EXITED? (should be used instead
of WEXITED by ptracer). Or, perhaps WEXITED should succeed but put
something special into status?

Oleg.

