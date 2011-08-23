Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1HWNgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:36:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab1HWNgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:36:06 -0400
Date: Tue, 23 Aug 2011 15:33:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        "Serge E. Hallyn" <serge@hallyn.com>, akpm@linux-foundation.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
	when reboot
Message-ID: <20110823133302.GA19582@redhat.com>
References: <20110814161707.GB30846@redhat.com> <20110814213642.GB13799@hallyn.com> <20110815144744.GA9660@redhat.com> <4E4DA461.8030006@free.fr> <20110819152416.GA17034@redhat.com> <4E524B73.3050704@free.fr> <20110822154448.GA8527@redhat.com> <20110822183134.10390b46@neptune.home> <20110822173949.GA13242@redhat.com> <20110822211716.7c141d5c@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110822211716.7c141d5c@neptune.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Bruno Prémont wrote:
>
> On Mon, 22 August 2011 Oleg Nesterov wrote:
> > On 08/22, Bruno Prémont wrote:
> > >
> > > Isn't it possible to add the two cases to si_code possible values, e.g.
> > > CDL_RESTART, CDL_HALT (or CDL_SYS_RESTART, CDL_SYS_HALT
> >
> > How? You should change do_wait() paths then. Even if we could, personally
> > I'd strongly object ;) Look, you have the very specific problem. The kernel
> > can't do everything to make everyone happy. There is tradeoff.
> >
> > But if you really meant siginfo->si_code, I do not understand at all what
> > you actually mean. This info is not preserved when the task exits.
>
> I've been reading do_wait() code a bit, it decides between CLD_KILLED and
> CLD_DUMPED based on a bit of (struct task_struct).exit_code.

Yes. But we were talking about the CLD_EXITED/CLD_KILLED difference.
And in fact this CLD_ doesn't matter at all. sys_waitid(info) can see
it, but you can simply look at "status". There is no additional info.

> So struct_task IS still available

Sure. But I do not understand why do you mention this... And, I think,
in this discussion we can pretend that only task->exit_code is still
available.

> (how about it's namespace references? If
> the namespaces are not the reboot reason would need to be stored somewhere
> inside of struct task which might be some overhead too much)
>
> So as long as container init's task_struct exists the reboot reason could
> be preserved and used to replace CLD_DUMPED/CLD_KILLED siginfo->si_code.

At least now I understand why did you mention si_code/CLD before. You
meant waitid(). I thought you were talking about the death-notifications
which can't report CLD_ you need.

I strongly object. We shouldn't uglify wait_task_zombie() to solve the
very specific problem.

And once again. sub_init->parent does wiat(&status) and sees
WIFSIGNALED() && WTERMSIG(status) == SIGHUP. This can only mean that
sys_reboot(LINUX_REBOOT_CMD_RESTART) was called. It _can not_ be really
killed by SIGHUP, it must be CMD_RESTART.

Why this can't work? Why do you want the additional complications?

> > > > And, iiuc, the point was to "fix" sys_reboot() so that we do not need
> > > > to mofify the distro/userspace?
> > >
> > > That's definitely the goal (not modify distro/userspace running inside
> > > container).
> >
> > In this case I do not understand how prctl() can help.
>
> I'm not talking about prctl() - as I understand Daniel the prctl() part is
> for the process outside of the container, not the one inside.
> So for container hypervisor to say if it wants to get informed or not.

OK, I certainly misunderstood him. And still can't understand what
exactly was suggested ;)

> > But please do not try to convince me, this is simply unnecessary ;)
>
> No, trying to know what's reasonably possible

Can't resist... IMHO, imho, imho, but in this case I believe
"reasonably possible" == "simplest" ;)

Oleg.

