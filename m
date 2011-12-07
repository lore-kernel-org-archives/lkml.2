Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1LGPRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:17:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab1LGPRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:17:47 -0500
Date: Wed, 7 Dec 2011 16:12:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, serge.hallyn@canonical.com,
        containers@lists.linux-foundation.org, gkurz@fr.ibm.com,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH 1/1][V3] Add reboot_pid_ns to handle the reboot syscall
Message-ID: <20111207151235.GA21962@redhat.com>
References: <1323030290-22216-1-git-send-email-daniel.lezcano@free.fr> <1323030290-22216-2-git-send-email-daniel.lezcano@free.fr> <20111206171617.e31bc3a6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206171617.e31bc3a6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Andrew Morton wrote:
> On Sun,  4 Dec 2011 21:24:50 +0100
> Daniel Lezcano <daniel.lezcano@free.fr> wrote:
>
> > This patch propose to store the reboot value in the 16 upper bits of the
> > exit code from the processes belonging to a pid namespace which has
> > rebooted. When the reboot syscall is called and we are not in the initial
> > pid namespace, we kill the pid namespace.
> >
> > By this way the parent process of the child pid namespace to know if
> > it rebooted or not and take the right decision.
>
> hm, modifying the exit code in this manner is a strange interface.  I
> didn't see that coming.  Perhaps some additional justification for this
> idea should be added to the changelog, along with discussion of
> alternative schemes.  I don't immediately see any problems with it,
> but, odd...  I wonder what potential it has to upset existing
> userspace.

Alternatively, we could do something like

	switch (reboot) {
	case LINUX_REBOOT_CMD_RESTART:
		exit_code = SIGHUP;
		break;
	case LINUX_REBOOT_CMD_HALT:
		exit_code = SIGINT;
		break;
	...
	}

this way the parent can check WIFSIGNALED/WTERMSIG instead of upper bits.
This was the initial suggestion, and personally I like this more.


But I do not think this can upset existing userspace. __WEXITSTATUS()
reports the lower bits only, it can't see the extra info we add.

> Also, this affects the data delivered by taskstats, I believe.  Please
> check this, test it, document it in the changelog and update
> getdelays.c appropriately.

No, taskstats report ->exit_code. This doesn't look right btw. But
in any case I do not think this can break something.

> Also, glibc might be affected.  For symmetry we might want to add a
> WIFREBOOT() or something.

We already use these upper bits to report the ptrace events, in the
same manner. I do not think this has something to do with libc.

Although it could probably have another macro to read this info.

> And we now expect waitid() to fill in extra
> bits in siginfo_t.si_status, which assumes that glibc (and other
> libc's!) aren't using a u8 in there somewhere.  etcetera.  This all
> should be tested, and reviewed by Uli (please).

Again, ptrace already puts the extra info this way when the tracee
stops.

Oleg.

