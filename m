Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab1HVQcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:32:22 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:33501 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1HVQcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:32:20 -0400
Date: Mon, 22 Aug 2011 18:31:34 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        "Serge E. Hallyn" <serge@hallyn.com>, akpm@linux-foundation.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
 when reboot
Message-ID: <20110822183134.10390b46@neptune.home>
In-Reply-To: <20110822154448.GA8527@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
	<20110814161707.GB30846@redhat.com>
	<20110814213642.GB13799@hallyn.com>
	<20110815144744.GA9660@redhat.com>
	<4E4DA461.8030006@free.fr>
	<20110819152416.GA17034@redhat.com>
	<4E524B73.3050704@free.fr>
	<20110822154448.GA8527@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 August 2011 Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/22, Daniel Lezcano wrote:
> >
> > If we pass the reason to the exit_code of the init process, that will be
> > a bit weird as the process is signaled and did not exited  no ?
> 
> Just in case, you shouldn't change ->exit_code blindly. We should only
> change it if init was a) SIGKILL'ed and b) pid_ns->reboot_cmd is set.
> In this case we can assume that it was killed by sys_reboot.
> 
> Now. I didn't really mean exit_state should be equal to sys_reboot's
> cmd arg. I thought about something like
> 
> 	swicth (reboot_cmd) {
> 	case LINUX_REBOOT_CMD_RESTART:
> 		code = SIGHUP;
> 		break;
> 	case LINUX_REBOOT_CMD_HALT:
> 		code = SIGINT;	// doesn't really matter what we report
> 		...
> 	}

Isn't it possible to add the two cases to si_code possible values, e.g.
CDL_RESTART, CDL_HALT (or CDL_SYS_RESTART, CDL_SYS_HALT to avoid possible
confusion with CDL_STOPPED)?

Then on sys_reboot() flag container init and kill it (this way sys_reboot()
preserves its "will not return on success for restart/halt" scematic)?
Then container init would see CLD_KILLED replaced with matching reboot
reason.

> we know that init can't be killed by SIGHUP/SIGINT, and this can't be
> confused with the case when init does exit(exit_code).
> 
> But in fact I do not not think that WIFSIGNALED() is that important.
> init shouldn't exit anyway.

Playing with the exit code is probably more problematic (maybe even more
once a process can unshare PID_NS as then any process spawning children
may see the exit codes with special meaning and mis-reporting the child
as having failed when return code is non-zero).

> > Furthermore, how to differentiate an application container (eg. a
> > script) exiting with an error with the same value of a reboot reason ?
> 
> Well, I think it is better to fix the script than the kernel.

IMHO this depends a lot on the point-of-view regarding pid_ns versus
container where technically both may be the same though user might have
completely different setup in mind.

For container init should never exit by itself, for simple segmentation
the basic script approach makes a lot of sense and gets invisible to parent
once unshare(PID_NS) gets possible.

> Daniel, I am not arguing. I agree that this looks like the hack anyway.
> Just I think that other approaches are even worse imho. We should try
> to make the kernel change as simple as possible.
> 
> 
> > Wouldn't make sense to let the user to specify a signal via prctl where
> > the si_code is filled with the reason ?
> 
> Sorry, I don't quite understand the idea...
> 
> And, iiuc, the point was to "fix" sys_reboot() so that we do not need
> to mofify the distro/userspace?

That's definitely the goal (not modify distro/userspace running inside
container).

Bruno
