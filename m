Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab1EZPD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:03:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab1EZPD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:03:26 -0400
Date: Thu, 26 May 2011 17:01:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110526150150.GD12525@redhat.com>
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-4-git-send-email-tj@kernel.org> <201105180240.56754.vda.linux@googlemail.com> <20110518095539.GU20624@htj.dyndns.org> <20110523124314.GA7232@redhat.com> <20110524102834.GC10334@htj.dyndns.org> <20110525182919.GB16575@redhat.com> <20110526091401.GD9715@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526091401.GD9715@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26, Tejun Heo wrote:
>
> Hello,
>
> On Wed, May 25, 2011 at 08:29:19PM +0200, Oleg Nesterov wrote:
> > > > And. Currently there is no way to detach a zombie leader. Perhaps we
> > > > should change do_wait(), but it is not clear what should we do if the
> > > > tracer is the real parent (we already discussed this a bit).
> > >
> > > Hmmm... maybe just allow detaching zombie leader?
> >
> > Yes, I think we should do this.
> >
> > If we change PTRACE_DETACH (or add the new request) to allow this, then
> > I think it it should detach any zombie, leader or not.
>
> I think we can just make PTRACE_DETACH to succeed for zombies.  No
> reason to add a new request for this.

OK.

> > Or we can change do_wait() to detach a zombie leader. In this case it
> > is not clear what should we do if the debugger is the real parent.
> > Perhaps do_wait() should do the same: detach a leader (but not reap).
> > When the last thread does, the real parent will be notified again.
> > IOW, wait(tgid) can succeed twice.
>
> Just letting PTRACE_DETACH work for zombies sounds much simpler to me.

Probably, but please note we have to modify do_wait() anyway. Otherwise
in general the tracer simply can not know the tracee has exited. IOW,
waitpid(zombie_leader_pid, WEXITED) should succeed without reaping if
delay_group_leader(), then the tracer can do PTRACE_DETACH. But this is
not symmetrical with sub-thread zombies.

Oleg.

