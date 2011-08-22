Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab1HVRmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 13:42:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab1HVRmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 13:42:53 -0400
Date: Mon, 22 Aug 2011 19:39:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        "Serge E. Hallyn" <serge@hallyn.com>, akpm@linux-foundation.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
	when reboot
Message-ID: <20110822173949.GA13242@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <20110814161707.GB30846@redhat.com> <20110814213642.GB13799@hallyn.com> <20110815144744.GA9660@redhat.com> <4E4DA461.8030006@free.fr> <20110819152416.GA17034@redhat.com> <4E524B73.3050704@free.fr> <20110822154448.GA8527@redhat.com> <20110822183134.10390b46@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110822183134.10390b46@neptune.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Bruno Prémont wrote:
>
> On Mon, 22 August 2011 Oleg Nesterov <oleg@redhat.com> wrote:
> > On 08/22, Daniel Lezcano wrote:
> > >
> > > If we pass the reason to the exit_code of the init process, that will be
> > > a bit weird as the process is signaled and did not exited  no ?
> >
> > Just in case, you shouldn't change ->exit_code blindly. We should only
> > change it if init was a) SIGKILL'ed and b) pid_ns->reboot_cmd is set.
> > In this case we can assume that it was killed by sys_reboot.
> >
> > Now. I didn't really mean exit_state should be equal to sys_reboot's
> > cmd arg. I thought about something like
> >
> > 	swicth (reboot_cmd) {
> > 	case LINUX_REBOOT_CMD_RESTART:
> > 		code = SIGHUP;
> > 		break;
> > 	case LINUX_REBOOT_CMD_HALT:
> > 		code = SIGINT;	// doesn't really matter what we report
> > 		...
> > 	}
>
> Isn't it possible to add the two cases to si_code possible values, e.g.
> CDL_RESTART, CDL_HALT (or CDL_SYS_RESTART, CDL_SYS_HALT

How? You should change do_wait() paths then. Even if we could, personally
I'd strongly object ;) Look, you have the very specific problem. The kernel
can't do everything to make everyone happy. There is tradeoff.

But if you really meant siginfo->si_code, I do not understand at all what
you actually mean. This info is not preserved when the task exits.

> to avoid possible
> confusion with CDL_STOPPED)?

How it is possible to confuse this with CDL_STOPPED?

> Then on sys_reboot() flag container init and kill it (this way sys_reboot()
> preserves its "will not return on success for restart/halt" scematic)?

This is what I suggested...

> Then container init would see CLD_KILLED replaced with matching reboot
> reason.

For what? its parent need this info, not container init. I guess I got
lost completely.

> Playing with the exit code is probably more problematic

OK, then please do something else. I do not pretend I really understand
what do you really need to solve your problem. But please do not forget
the kernel is already very complex and full of misc hacks ;)

> > And, iiuc, the point was to "fix" sys_reboot() so that we do not need
> > to mofify the distro/userspace?
>
> That's definitely the goal (not modify distro/userspace running inside
> container).

In this case I do not understand how prctl() can help.


But please do not try to convince me, this is simply unnecessary ;)

Oleg.

