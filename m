Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1HOOvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:51:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab1HOOvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:51:40 -0400
Date: Mon, 15 Aug 2011 16:47:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, akpm@linux-foundation.org,
        bonbons@linux-vserver.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent
	when reboot
Message-ID: <20110815144744.GA9660@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <20110814161707.GB30846@redhat.com> <20110814213642.GB13799@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110814213642.GB13799@hallyn.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> > On 08/11, Daniel Lezcano wrote:
> > >
> > > In the case of a VPS, when we shutdown/halt/reboot the container, the
> > > reboot utility will invoke the sys_reboot syscall which has the bad
> > > effect to reboot the host.
> >
> > Stupid question. Can't sys_reboot() simply kill init (and thus the whole
> > pid_ns) in this case?
>
> The goal is to be able to distinguish a request for reboot from shutdown.
> If we just kill the init, then the parent of init (the container monitor)
> cannot restart the container to emulate reboot.

OK, thanks.

What if init reports the reason it was killed?

Ignoring LINUX_REBOOT_CMD_CAD_/etc, I mean, roughly,

	- add "int reboot_cmd" into struct pid_namespace

	- sys_reboot(cmd) does

		if (!global_namespace) {
			task_active_pid_ns(current)->reboot_cmd = cmd;
			sigkill_my_init();
		}

	- change zap_pid_ns_processes() to do

		if (pid_ns->reboot_cmd)	// approximately
			current->exit_state = pid_ns->reboot_cmd;

Then its parent can look at status after wait(&status).


Not that I think this is very nice, but signals are not reliable.
And once again, SIGCHLD doesn't queue. And, perhaps this doesn't
matter, but sys_reboot() sends SIGCHLD and returns -EPERM, this
can confuse the container.


In any case. If you want to send a signal, please do not introduce
SA_CLDREBOOT. Please do not play with ptrace or __wake_up_parent, this
is meaningless. Just fill siginfo and send SIGCHLD unconditionally.

Oleg.

