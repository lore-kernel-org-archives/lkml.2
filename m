Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1HVPs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:48:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab1HVPsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:48:52 -0400
Date: Mon, 22 Aug 2011 17:44:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, akpm@linux-foundation.org,
        bonbons@linux-vserver.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
	when reboot
Message-ID: <20110822154448.GA8527@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <20110814161707.GB30846@redhat.com> <20110814213642.GB13799@hallyn.com> <20110815144744.GA9660@redhat.com> <4E4DA461.8030006@free.fr> <20110819152416.GA17034@redhat.com> <4E524B73.3050704@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E524B73.3050704@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Daniel Lezcano wrote:
>
> If we pass the reason to the exit_code of the init process, that will be
> a bit weird as the process is signaled and did not exited  no ?

Just in case, you shouldn't change ->exit_code blindly. We should only
change it if init was a) SIGKILL'ed and b) pid_ns->reboot_cmd is set.
In this case we can assume that it was killed by sys_reboot.

Now. I didn't really mean exit_state should be equal to sys_reboot's
cmd arg. I thought about something like

	swicth (reboot_cmd) {
	case LINUX_REBOOT_CMD_RESTART:
		code = SIGHUP;
		break;
	case LINUX_REBOOT_CMD_HALT:
		code = SIGINT;	// doesn't really matter what we report
		...
	}

we know that init can't be killed by SIGHUP/SIGINT, and this can't be
confused with the case when init does exit(exit_code).

But in fact I do not not think that WIFSIGNALED() is that important.
init shouldn't exit anyway.

> Furthermore, how to differentiate an application container (eg. a
> script) exiting with an error with the same value of a reboot reason ?

Well, I think it is better to fix the script than the kernel.


Daniel, I am not arguing. I agree that this looks like the hack anyway.
Just I think that other approaches are even worse imho. We should try
to make the kernel change as simple as possible.


> Wouldn't make sense to let the user to specify a signal via prctl where
> the si_code is filled with the reason ?

Sorry, I don't quite understand the idea...

And, iiuc, the point was to "fix" sys_reboot() so that we do not need
to mofify the distro/userspace?



In short. Please do what you like more. But I'd like you to know,
I'll argue with any complications which (afaics!) we can avoid,
I promise ;)

Oleg.

